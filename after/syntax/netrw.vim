" Hide all pipe characters (replace with space)
syntax match netrwTreeBar /|/ conceal cchar= 

" The last pipe before a directory name gets an arrow
syntax match netrwTreeDirArrow /|\ze [^|]*\/$/ conceal cchar=▸
