
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

-- Ctrl + v or s => Ctrl + w + v s
vim.keymap.set("n", "<Leader>v", "<C-w>v", opt)
vim.keymap.set("n", "<Leader>s", "<C-w>s", opt)

-- 将 'i', 'k', 'j', 'l' 映射为方向键
vim.keymap.set('n', 'i', [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })
vim.keymap.set('n', 'k', [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.keymap.set('n', 'j', [[v:count ? 'h' : 'h']], { noremap = true, expr = true })
vim.keymap.set('n', 'l', [[v:count ? 'l' : 'l']], { noremap = true, expr = true })

vim.keymap.set('v', 'i', [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })
vim.keymap.set('v', 'k', [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.keymap.set('v', 'j', [[v:count ? 'h' : 'h']], { noremap = true, expr = true })
vim.keymap.set('v', 'l', [[v:count ? 'l' : 'l']], { noremap = true, expr = true })

-- 在插入模式下映射 Ctrl + i, Ctrl + k, Ctrl + j, Ctrl + l
vim.api.nvim_set_keymap('i', '<A-i>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-l>', '<Right>', { noremap = true, silent = true })

vim.keymap.set('i', '<A-h>','<Esc>', opt)
vim.keymap.set('n', 'h', 'i', { noremap = true, silent = true })

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


-- Helper function to check if there are words before the cursor
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Helper function to feed keys
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
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
    	},
	{
		event = "VeryLazy",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
    		"neovim/nvim-lspconfig",
	},
	{
		'neovim/nvim-lspconfig',
       		config = function()
         		local capabilities = require('cmp_nvim_lsp').default_capabilities()
         		-- 替换 <YOUR_LSP_SERVER> 为你使用的 LSP 服务器名称
         		require('lspconfig')['lua_ls'].setup {
           		capabilities = capabilities
         		}
       		end,
	},
	{
	    'hrsh7th/nvim-cmp',
	    dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/cmp-vsnip',
		'hrsh7th/vim-vsnip',
	    },
	    config = function()
		local cmp = require'cmp'
		cmp.setup({
		    snippet = {
			expand = function(args)
			    vim.fn["vsnip#anonymous"](args.body) -- 使用 vsnip
			end,
		    },
		    mapping = {
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			--['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ select = true }), -- 确认选择
			['<Tab>'] = cmp.mapping(function(fallback)
			    if cmp.visible() then
				cmp.confirm({ select = true })
			    else
				fallback() -- 如果没有补全菜单，执行默认行为
			    end
			end, { 'i', 's' }),
			['<S-Tab>'] = cmp.mapping(function(fallback)
			    if cmp.visible() then
				cmp.confirm({ select = true }) -- 自动确认第一个结果
			    else
				fallback() -- 如果没有补全菜单，执行默认行为
			    end
			end, { 'i', 's' }),
		    },
		    sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
		    }, {
			{ name = 'buffer' },
		    })
		})
		-- 配置命令行补全
		cmp.setup.cmdline({ '/', '?' }, {
		    mapping = cmp.mapping.preset.cmdline(),
		    sources = {
			{ name = 'buffer' }
		    }
		})
		cmp.setup.cmdline(':', {
		    mapping = cmp.mapping.preset.cmdline(),
		    sources = cmp.config.sources({
			{ name = 'path' }
		    }, {
			{ name = 'cmdline' }
		    }),
		    matching = { disallow_symbol_nonprefix_matching = false }
		})
	    end
	},
})

-- Theme
-- corlorscheme url : https://github.com/RRethy/base16-nvim
-- Light is good
vim.cmd.colorscheme("base16-tokyo-city-light")
-- Night is good
--vim.cmd.colorscheme("base16-3024")


-- 持久化插件的load
vim.api.nvim_set_keymap('n', '<Leader>sl', ':lua require("persistence").load()<CR>', opt)


-- LSP CONFIG
local lspconfig = require('lspconfig')
require("mason").setup()
require("mason-lspconfig").setup()

require("lspconfig").lua_ls.setup {}
require("lspconfig").pyright.setup{}

