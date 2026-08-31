# endcord-image-pfp
An extension for [endcord](https://github.com/sparklost/endcord) discord TUI client, that adds drawing rounded profile pictures in the chat using kitty protocol.  
Should work on all terminals with kitty image protocol support.  
If running in tmux, dont forget to set `allow-passthrough`.  
Other kitty image protocol endcord extensions: [endcord-image-inline](https://github.com/sparklost/endcord-image-inline), [endcord-image-emoji](https://github.com/sparklost/endcord-image-emoji).

## Installing
See [official extensions documentation](https://github.com/sparklost/endcord/blob/main/docs/extensions.md#installing-extensions) for installing instructions.
Available options:
- Git clone into `Extensions` directory located in endcord config directory.
- Run `endcord -i https://github.com/sparklost/endcord-image-pfp`
- Or use endcord client-side command `install_extension sparklost/endcord-image-pfp`

## Configuration
All extension options are under `[main]` section in endcord config. This extension options are always prefixed with `ext_image_pfp_`.  
Note that many options can significantly impact RAM and CPU usage.

### Settings options
- `ext_image_pfp_round = True`  
    Convert profile pictures to circular shape. Needs either endcord full or medium, or imagemagick or graphicsmagick installed.  
    After toggling this, delete `pfp-small` directory in endcord cache to apply this option.
- `ext_image_pfp_antialias = True`  
    Antialias circle edge if `ext_image_pfp_round` is `True`.  
    After toggling this, delete `pfp-small` directory in endcord cache to apply this option.
- `ext_image_pfp_max_cache_age = None`  
    If this key exists, it will override endcord builtin value from `max_thumb_cache_age` only for pfp cache.  
    Images not used for more than this many days will be deleted on endcord startup.
- `ext_image_pfp_format_message_shift = [0, 5]`  
    Insert spaces to `format_message` from endcord them config (also to `format_message_color`) to make space for pfp image.  
    Leave like this if you did not change `format_message` in theme.  
    Image is 4x2 cells large and always drawn at x=0 relative to chat left edge, and y=0 relative to message base line.  
    If message base is not in 2 lines (no `\n` in `format_message`), then image is drawn smaller: 2x1 cells.  
    In this example, 5 spaces are inserted at index 0.  
- `ext_image_pfp_format_message_grouped_shift = [2, 1]`
    Same as above, but for `format_message_grouped`.
- `ext_image_pfp_format_newline_shift = [2, 1]`
    Same as above but for `format_newline`.

## Disclaimer
> [!WARNING]
> Using third-party client is against Discord's Terms of Service and may cause your account to be banned!  
> **Use endcord and/or this extension at your own risk!**  
> If this extension is modified, it may be used for harmful or unintended purposes.  
> **The developer is not responsible for any misuse or for actions taken by users.**  
