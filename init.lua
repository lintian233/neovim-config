
local set = vim.o

-- 行号
set.number = true

-- 相对行号
set.relativenumber = true

-- 打通剪切板"+yy 可以复制到系统的剪切板
set.clipboard = "unnamed"

-- 在 copy 后高亮 魔法命令
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			timeout = 300,
		})
	end,
})

-- keybindings
local opt = { noremap = true, silent = true }

vim.keymap.set("n", "<C-h>", "<C-w>h", opt)
vim.keymap.set("n", "<C-j>", "<C-w>j", opt)
vim.keymap.set("n", "<C-k>", "<C-w>k", opt)
vim.keymap.set("n", "<C-l>", "<C-w>l", opt)



