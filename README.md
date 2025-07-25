# Neovim Config
This repository contains my Neovim config which provides:
* LSP Management via [mason.nvim](https://github.com/mason-org/mason.nvim)
* Code Completion via [blink.cmp](https://github.com/Saghen/blink.cmp)
* Fuzzy File Navigation via [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

It also provides the following (presumably non-standard) keybinds:
Binding | Function | Mode
--------|----------|-----
`<C-p>` | find non-hidden files | Normal
`<leader>pf` | find files added to git | Normal
`<leader>pb` | list open buffers | Normal
`<leader>pg` | find files that contain a given string | Normal
`<leader>rn` | rename hovered variable | Normal
`<leader>ca` | list code actions provides by the active language server | Normal
`gd` | goto the definition of the hovered symbol | Normal
`gD` | goto the declaration of the hovered symbol | Normal
`gr` | list all references to the hovered symbol | Normal
`<leader>ds` | list all symbols in the current buffer | Normal
`<leader>ws` | list all symbols in the current workspace | Normal
`K` | show the documentation of the currently hovered symbol | Normal
`<leader>pv` | open Netrw in the directory of the current file | Normal
`J` | move the selected block down one line | Visual
`K` | move the selected block up one line | Visual
`<C-c>` | exit to normal mode | Insert
`<leader>vs` | vertical split | Normal
`<leader>hs` | horizontal split | Normal
`<leader>f` | format the current buffer using the language server | Normal
`<C-h>` | move the cursor left | Insert
`<C-j>` | move the cursor down | Insert
`<C-k>` | move the cursor up | Insert
`<C-l>` | move the cursor right | Insert
