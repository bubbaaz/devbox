-- Fast jj to escape insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-- Make single 'j' feel instant (reduce mapping timeout lag)
vim.o.timeout = true
vim.o.timeoutlen = 400  -- 400ms is perfect balance
