return {
	"zbirenbaum/copilot.lua",
	config = function()
		require("copilot").setup({
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<C-\\>",
				},
			},
		})
		-- 更稳定的快捷键绑定
		vim.api.nvim_set_keymap(
			"i",
			"<C-\\>",
			[[<cmd>lua require('copilot.suggestion').accept()<CR>]],
			{ noremap = true, silent = true }
		)
	end,
}
