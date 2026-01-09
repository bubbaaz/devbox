-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load LazyVim core + your custom plugins
require("lazy").setup({
  spec = {
    -- Core LazyVim (provides defaults, auto-loads lua/config/*, etc.)
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Your personal plugins (in .config/nvim/lua/plugins/)
    { import = "plugins" },
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
})
