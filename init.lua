
-- this is a Lua configuration file of the neovim


local set = vim.o

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

-- Leader Key Mapping 
vim.g.mapleader = " "

-- Ctrl + hjkl => Ctrl + w hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", opt)
vim.keymap.set("n", "<C-j>", "<C-w>j", opt)
vim.keymap.set("n", "<C-k>", "<C-w>k", opt)
vim.keymap.set("n", "<C-l>", "<C-w>l", opt)

-- Ctrl + v or s => Ctrl + w + v s
vim.keymap.set("n", "<Leader>v", "<C-w>v", opt)
vim.keymap.set("n", "<Leader>s", "<C-w>s", opt)

-- 更好的行跳
-- https://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
vim.keymap.set("n", "j", [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.keymap.set("n", "k", [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })

-- lazy.nvim 的配置
-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{
		"RRethy/nvim-base16",
		lazy = true,
	},
	{
        	'folke/persistence.nvim',
        	event = 'BufReadPre', -- 懒加载配置，只有在读取缓冲区之前才会加载插件
        	config = function()
            	require('persistence').setup({
                	dir = vim.fn.expand(vim.fn.stdpath('data') .. '/persistence'), -- 会话文件存储目录
                	options = { 'buffers', 'curdir', 'tabpages', 'winsize' }, 
            	})
        	end,
    	},
	{	
		cmd = "Telescope",
    		'nvim-telescope/telescope.nvim', 
		keys = {
          		{ "<Leader>p", ":Telescope find_files<CR>", desc = "find files" },
          		{ "<Leader>P", ":Telescope live_grep<CR>", desc = "grep file" },
          		{ "<Leader>rs", ":Telescope resume<CR>", desc = "resume" },
          		{ "<Leader>q", ":Telescope oldfiles<CR>", desc = "oldfiles" },
		},        	
		tag = '0.1.8',
      		dependencies = { 'nvim-lua/plenary.nvim' }
    	}
})


-- Theme
-- corlorscheme url : https://github.com/RRethy/base16-nvim
-- Light is good
vim.cmd.colorscheme("base16-tokyo-city-light")
-- Night is good
--vim.cmd.colorscheme("base16-3024")
--
vim.api.nvim_set_keymap('n', '<Leader>sl', ':lua require("persistence").load()<CR>', opt)


