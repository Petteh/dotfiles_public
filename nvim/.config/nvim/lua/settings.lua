
-- Use space as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Share clipboard with system
vim.opt.clipboard = 'unnamedplus'

vim.o.background = 'dark'
vim.o.termguicolors  = true

vim.opt.iskeyword:append('-')  -- Treat words with '-' in them as full words
vim.opt.backspace = { 'indent', 'eol', 'start' } -- Better backspace behavior

-- Enable mouse in all modes
vim.opt.mouse = 'a'

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Window Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Indentation, tabs and spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- Tabs -> spaces
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- Screen info
vim.opt.ruler = true
vim.opt.number = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.showtabline = 2

-- Responsiveness
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
