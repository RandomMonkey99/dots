import tkinter as tki
tk = tki.Tk()
tk.title("My Tkinter Window")
tk.geometry("400x300")
tk.configure(bg="lightblue")
button = tki.Button(tk, text="Click Me", command=lambda: print("Button Clicked!"))
button.pack(pady=20)
tk.mainloop()