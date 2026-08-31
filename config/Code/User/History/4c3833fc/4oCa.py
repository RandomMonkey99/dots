import tkinter as tk
tk = tk.Tk()
tk.title("My Tkinter Window")
tk.geometry("400x300")
tk.configure(bg="lightblue")
button = tk.Button(tk, text="Click Me", command=lambda: print("Button Clicked!"))
button.pack(pady=20)
tk.mainloop()