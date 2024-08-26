local keymap = vim.keymap

-- CTRL+C to go back to normal
vim.keymap.set('i', '<C-c>', '<Esc>', { noremap = true, silent = true })  -- Insert mode to Normal mode
vim.keymap.set('v', '<C-c>', '<Esc>', { noremap = true, silent = true })  -- Visual mode to Normal mode
vim.keymap.set('x', '<C-c>', '<Esc>', { noremap = true, silent = true })  -- Visual block mode to Normal mode
vim.keymap.set('s', '<C-c>', '<Esc>', { noremap = true, silent = true })  -- Select mode to Normal mode

-- x doesn't copy to clipboard
keymap.set("n", "x", '"_x')

-- window splitting
keymap.set("n", "<leader>sv", "<C-w>v") -- vertical
keymap.set("n", "<leader>sh", "<C-w>s") -- horizontal
keymap.set("n", "<leader>se", "<C-w>=") -- make window width equal
keymap.set("n", "<leader>sx", ":close<CR>") -- close split


-- open oil
vim.keymap.set('n', '<C-e>', ':Oil<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-e>', '<C-c>:Oil<CR>', { noremap = true, silent = true })

