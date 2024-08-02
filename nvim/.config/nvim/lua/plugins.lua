-- https://github.com/ellisonleao/gruvbox.nvim#configuration
require("gruvbox").setup({
    contrast = "hard",
    italic = {
        strings = false,
    }
})
vim.cmd('colorscheme gruvbox')

-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#highlight
require("nvim-treesitter").setup()
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false; -- Disable folding at startup.

-- https://github.com/numToStr/Comment.nvim#configuration-optional
require("Comment").setup()

-- https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#default-configuration
require("lualine").setup()

-- https://github.com/m4xshen/smartcolumn.nvim/#-configuration
require("smartcolumn").setup({
    colorcolumn = { "100", "120" },
    disabled_filetypes = {
        "help",
        "text",
        "markdown",
        "checkhealth",
        "NvimTree",
    }
})
