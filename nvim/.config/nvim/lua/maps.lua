-- Unmap 'Q' in normal mode
vim.keymap.set('n', 'Q', '<Nop>')

-- Disable search highlight
vim.keymap.set('n', '<Leader><CR>', '<cmd>noh<CR>', { silent = true})

-- Smart way to move between windows
vim.keymap.set('n', '<C-j>', '<C-W>j')
vim.keymap.set('n', '<C-k>', '<C-W>k')
vim.keymap.set('n', '<C-h>', '<C-W>h')
vim.keymap.set('n', '<C-l>', '<C-W>l')

-- Move a line of text using ALT+[jk]
vim.keymap.set('n', '<M-j>', 'mz:m+<cr>`z')
vim.keymap.set('n', '<M-k>', 'mz:m-2<cr>`z')
vim.keymap.set('v', '<M-j>', ':m\'>+<cr>`<my`>mzgv`yo`z')
vim.keymap.set('v', '<M-k>', ':m\'<-2<cr>`>my`<mzgv`yo`z')
