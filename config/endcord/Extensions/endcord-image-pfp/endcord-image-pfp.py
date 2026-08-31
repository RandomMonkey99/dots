import base64
import importlib
import logging
import os
import queue
import sys
import threading

from endcord import formatter, peripherals, terminal_utils, utils

EXT_NAME = "Image PFP"
EXT_VERSION = "0.1.0"
EXT_ENDCORD_VERSION = "1.5.2"
EXT_DESCRIPTION = "An extension that adds drawing rounded profile pictures in the chat using kitty protocol"
EXT_SOURCE = "https://github.com/sparklost/endcord-image-pfp"
logger = logging.getLogger(__name__)
support_media = importlib.util.find_spec("PIL") is not None

START_IMAGE_ID = 5500
IMAGE_SIZES = [16, 20, 22, 24, 28, 32, 40, 44, 48, 56, 60, 64, 80, 96, 100, 128, 160, 240, 254]

def check_kitty():
    """Check if kitty protocol is supported"""
    response = terminal_utils.query_terminal(b"\x1b_Gi=1,s=1,v=1,a=q,t=d,f=24;AAAA\x1b\\\x1b[c")
    return "OK" in response


def kitty_upload_png(path, image_id):
    """Upload base64 encoded png into kitty image cache"""
    with open(path, "rb") as f:
        png_data = f.read()
    payload = base64.b64encode(png_data).decode("ascii")
    for i in range(0, len(payload), 4096):
        chunk = payload[i:i + 4096]
        more = 1 if i + 4096 < len(payload) else 0
        if i == 0:
            header = f"a=t,f=100,q=2,i={image_id},m={more}"
        else:
            header = f"m={more}"
        os.write(sys.stdout.fileno(), f"\033_G{header};{chunk}\033\\".encode())
    return True


def kitty_upload_image(path, image_id):
    """Upload base64 encoded any image into kitty image cache"""
    from PIL import Image
    try:
        img = Image.open(path).convert("RGBA")
    except Exception:
        return False
    w_px, h_px = img.size
    payload = base64.b64encode(img.tobytes()).decode("ascii")
    for i in range(0, len(payload), 4096):
        chunk = payload[i:i + 4096]
        more = 1 if i + 4096 < len(payload) else 0
        if i == 0:
            header = f"a=t,f=32,q=2,s={w_px},v={h_px},i={image_id},m={more}"
        else:
            header = f"m={more}"
        os.write(sys.stdout.fileno(), f"\033_G{header};{chunk}\033\\".encode())
    return True


def kitty_draw_image_by_id(image_id, x, y, w=None, h=None, cut_y=None, cut_h=None, z=-1):
    """Draw previously uploaded image by its id"""
    header = f"a=p,q=2,z={z},i={image_id}"
    if w is not None:
        header += f",c={w}"
    if h is not None:
        header += f",r={h}"
    if cut_y is not None:
        header += f",y={cut_y}"
    if cut_h is not None:
        header += f",h={cut_h}"
    # \0337 is remember cursor, \0338 is restore cursor, \033[y,x]H is move cursor
    os.write(sys.stdout.fileno(), f"\0337\033[{y+1};{x+1}H\033_G{header}\033\\\0338".encode())


def kitty_delete_images_by_id(image_id):
    """Delete all images with this id and remove it from memory"""
    os.write(sys.stdout.fileno(), f"\033_Ga=d,d=I,q=2,i={image_id}\033\\".encode())


def kitty_clear_images_by_id(image_id):
    """Delete all images with this id but keep image in memory"""
    os.write(sys.stdout.fileno(), f"\033_Ga=d,d=i,q=2,i={image_id}\033\\".encode())


class Extension:
    """Main extension class"""

    def __init__(self, app):
        self.app = app
        self.tui = app.tui
        self.run = True
        kitty_supported = getattr(self.tui, "kitty_supported", None)
        if kitty_supported is False or (kitty_supported is not True and not check_kitty()):
            logger.warning("No kitty protocol support detected in this terminal")
            self.run = False
        self.cell_w, self.cell_h = terminal_utils.get_font_size()
        self.ratio = self.cell_h
        if not self.cell_w:
            self.run = False

        if not self.run:
            del type(self).on_chat_update
            del type(self).on_chat_draw
            del type(self).on_force_redraw
            self.tui.kitty_supported = False
            return

        self.round = app.config.get("ext_image_pfp_round", True)
        self.antialias = app.config.get("ext_image_pfp_antialias", True)
        message_shift = app.config.get("ext_image_pfp_format_message_shift", (0, 5))
        format_message = app.config["format_message"]
        max_cache_age = app.config.get("ext_image_pfp_max_cache_age", app.config["max_thumb_cache_age"])
        app.formatter.format_message = format_message[:message_shift[0]] + (" " * message_shift[1]) + format_message[message_shift[0]:]
        app.formatter.color_message = formatter.shift_formats(app.formatter.color_message, message_shift[0], message_shift[1])
        app.formatter.color_mention_message = formatter.shift_formats(app.formatter.color_mention_message, message_shift[0], message_shift[1])
        if "\n" in app.formatter.format_message:
            grouped_shift = app.config.get("ext_image_pfp_format_message_grouped_shift", (2, 1))
            format_message_grouped = app.config["format_message_grouped"]
            app.formatter.format_message_grouped = format_message_grouped[:grouped_shift[0]] + (" " * grouped_shift[1]) + format_message_grouped[grouped_shift[0]:]
            app.formatter.color_message_grouped = formatter.shift_formats(app.formatter.color_message_grouped, grouped_shift[0], grouped_shift[1])
            app.formatter.color_mention_message_grouped = formatter.shift_formats(app.formatter.color_mention_message_grouped, grouped_shift[0], grouped_shift[1])
            newline_shift = app.config.get("ext_image_pfp_format_newline_shift", (2, 1))
            format_newline = app.config["format_newline"]
            app.formatter.format_newline = format_newline[:newline_shift[0]] + (" " * newline_shift[1]) + format_newline[newline_shift[0]:]
            app.formatter.color_newline = formatter.shift_formats(app.formatter.color_newline, newline_shift[0], newline_shift[1])
            app.formatter.color_mention_newline = formatter.shift_formats(app.formatter.color_mention_newline, newline_shift[0], newline_shift[1])
            self.pfp_size = 2
        else:
            self.pfp_size = 1
        app.formatter.calculate_lengths()
        app.keep_avatars = True

        self.image_type = "webp" if support_media else "png"
        self.image_size = min(self.pfp_size * self.cell_h, self.pfp_size * 2 * self.cell_w)
        self.image_size = min((x for x in IMAGE_SIZES if x >= self.image_size), default=None)

        self.chat_map = []
        self.update = threading.Event()
        self.prev_chat_index = None
        self.prev_chat_hw = None
        self.prev_win_hw = self.tui.screen_hw
        self.force_draw = False
        self.pfp_cache_path = os.path.expanduser(os.path.join(peripherals.cache_path, "pfp-small"))
        self.image_cache = {}
        self.image_ids = {}
        self.image_ids_lock = threading.Lock()
        self.image_cache_lock = threading.Lock()
        self.download_queue = queue.Queue()

        threading.Thread(target=utils.delete_old_files, daemon=True, args=(os.path.join(peripherals.cache_path, "pfp-small"), max_cache_age, True)).start()
        threading.Thread(target=self.downloader, daemon=True).start()
        threading.Thread(target=self.worker, daemon=True).start()


    def on_chat_update(self, chat, chat_format, chat_map):   # noqa
        """Get new chat map"""
        self.chat_map = chat_map
        self.update.set()


    def on_chat_draw(self):
        """Re-calculate image positions and draw them"""
        if not self.force_draw and self.prev_chat_index == self.tui.chat_index and self.prev_chat_hw == self.tui.chat_hw:
            return
        if self.tui.disable_drawing:
            return
        if self.prev_win_hw != self.tui.screen_hw:
            self.prev_win_hw = self.tui.screen_hw
            self.reupload_all()
        h = self.pfp_size
        w = self.pfp_size * 2
        with self.tui.lock:
            chat_y, chat_x = self.tui.win_chat.getbegyx()
            chat_h = self.tui.chat_hw[0]
            with self.image_cache_lock:
                subtitle_line = bool(self.tui.win_subtitle_line)
                with self.image_ids_lock:
                    for kitty_image_id in self.image_ids.values():
                        kitty_clear_images_by_id(kitty_image_id)
                for kitty_image_id, rel_y in self.image_cache.values():
                    abs_y = chat_h - (rel_y - self.tui.chat_index - self.tui.have_title - subtitle_line + 1)
                    if abs_y - chat_y <= -h or abs_y >= chat_h + 1 + subtitle_line:
                        continue
                    cut_y = None
                    cut_h = None
                    h_1 = None   # so kitty wont fit image to height causing it to deform
                    if abs_y > chat_h - h + 1 + subtitle_line:
                        cut_h = int(min(h, chat_h - abs_y + 1 + subtitle_line) * self.cell_h) + subtitle_line
                        logger.info(cut_h)
                    if abs_y <= subtitle_line:
                        cut_y = int(((-abs_y * self.cell_h) + self.cell_h * (1 + subtitle_line)))
                        abs_y = chat_y
                    # logger.info((kitty_image_id, abs_y, rel_y, cut_y, cut_h))
                    kitty_draw_image_by_id(kitty_image_id, x=chat_x, y=abs_y, w=w, h=h_1, cut_y=cut_y, cut_h=cut_h, z=0)
        self.prev_chat_index = self.tui.chat_index
        self.prev_chat_hw = self.tui.chat_hw


    def on_force_redraw(self):
        """When curses screen.clear(), kitty images are cleared too so redraw them"""
        self.reupload_all()


    def reupload_all(self):
        """Delete all images and trigger reupload"""
        for image in self.image_cache.values():
            with self.tui.lock:
                kitty_clear_images_by_id(image[0])
                kitty_delete_images_by_id(image[0])
        self.image_cache = {}
        self.update.set()


    def get_free_id(self, new_cache):
        """Get first free id"""
        ids = sorted(set(i[0] for i in self.image_cache.values()) | set(i[0] for i in new_cache.values()))
        for i in range(len(ids) - 1):
            if ids[i + 1] != ids[i] + 1:
                return ids[i] + 1
        if START_IMAGE_ID not in ids:
            return START_IMAGE_ID
        return START_IMAGE_ID + len(ids)


    def worker(self):
        """Thread that updates image cache on disk and in ram and downloads missing images"""
        while self.run:
            self.update.wait()
            self.update.clear()
            image_cache = {}
            visible = set()
            self.force_draw = False

            for rel_y, line_map in enumerate(self.chat_map):
                if not line_map:
                    continue
                if not line_map[1]:
                    continue
                try:
                    message = self.app.messages[line_map[0]]
                    message_id = message["id"]
                    user_id = message["user_id"]
                    avatar_id = message.get("avatar")
                except IndexError:
                    continue
                if not user_id:
                    continue
                # download and cache (disk and ram)
                if message_id in self.image_cache:
                    image_cache[message_id] = (self.image_cache[message_id][0], rel_y)
                elif avatar_id in self.image_ids:
                    image_cache[message_id] = (self.image_ids[avatar_id], rel_y)
                else:
                    kitty_image_id = self.get_free_id(image_cache)
                    self.download_queue.put((message_id, user_id, avatar_id, kitty_image_id, rel_y))
                    image_cache[message_id] = (kitty_image_id, rel_y)
                    with self.image_ids_lock:
                        self.image_ids[avatar_id] = kitty_image_id
                visible.add(avatar_id)


            # update changed images
            if image_cache != self.image_cache or self.force_draw:
                self.image_cache = image_cache
                self.force_draw = True
                self.on_chat_draw()

            # delete unused cache
            deleted_kitty = []
            with self.image_ids_lock:
                to_delete = [k for k in self.image_ids if k not in visible]
                for avatar_id in to_delete:
                    deleted_kitty.append(self.image_ids.pop(avatar_id))
            with self.tui.lock:
                for kitty_image_id in deleted_kitty:
                    kitty_delete_images_by_id(kitty_image_id)


    def downloader(self):
        """Download image and draw it"""
        while self.run:
            message_id, user_id, avatar_id, kitty_image_id, rel_y = self.download_queue.get()

            # check if cached
            cache_path = os.path.join(os.path.expanduser(peripherals.cache_path), "pfp-small")
            if not os.path.exists(cache_path):
                os.makedirs(cache_path)
            image_path = utils.search_pfp_cache(cache_path, f"{avatar_id}*", avatar_id)
            if not image_path:
                image_path = self.app.discord.get_pfp(user_id, avatar_id, size=self.image_size, img_type=self.image_type, save_path=self.pfp_cache_path, keepalive=True)
                if image_path and not avatar_id:
                    image_path = peripherals.resize_image(image_path, h=self.image_size, w=self.image_size)
            if not image_path:
                continue

            if self.round:
                try:
                    image_path = peripherals.make_round_image(image_path, antialias=self.antialias)
                except Exception as e:
                    logger.error(f"Error converting image: {e}")

            with self.tui.lock:
                if support_media:
                    success = kitty_upload_image(image_path, kitty_image_id)
                else:
                    success = kitty_upload_png(image_path, kitty_image_id)
            if not success or message_id not in self.image_cache or self.tui.disable_drawing:
                continue

            # use latest data, in case something changed during download and upload
            kitty_image_id, rel_y = self.image_cache[message_id]

            h = self.pfp_size
            w = self.pfp_size * 2
            chat_y, chat_x = self.tui.win_chat.getbegyx()
            chat_h = self.tui.chat_hw[0]
            with self.tui.lock:
                with self.image_cache_lock:
                    subtitle_line = bool(self.tui.win_subtitle_line)
                    abs_y = chat_h - (rel_y - self.tui.chat_index - self.tui.have_title - subtitle_line + 1)
                    if abs_y - chat_y <= -h or abs_y >= chat_h + 1 + subtitle_line:
                        continue
                    cut_y = None
                    cut_h = None
                    h_1 = None   # so kitty wont fit image to height causing it to deform
                    if abs_y > chat_h - h + 1 + subtitle_line:
                        cut_h = int(min(h, chat_h - abs_y + 1 + subtitle_line) * self.cell_h) + subtitle_line
                    if abs_y <= subtitle_line:
                        cut_y = int(((-abs_y * self.cell_h) + self.cell_h * (1 + subtitle_line)))
                        abs_y = chat_y
                    # logger.info((kitty_image_id, abs_y, rel_y, h_1, cut_y, cut_h))
                    kitty_draw_image_by_id(kitty_image_id, x=chat_x, y=abs_y, w=w, h=h_1, cut_y=cut_y, cut_h=cut_h, z=0)
