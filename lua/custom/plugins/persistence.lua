-- persistence config file
return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- 懒加载配置，只有在读取缓冲区之前才会加载插件
	config = function()
		require("persistence").setup({
			dir = vim.fn.expand(vim.fn.stdpath("data") .. "/persistence"), -- 会话文件存储目录
			options = { "buffers", "curdir", "tabpages", "winsize" },
		})
	end,

	keys = {
		{
			"<leader>ll",
			function()
				require("persistence").load()
			end,
			desc = "Load last session",
		},
	},
}
