return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		event = "VeryLazy",
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			model = "gpt-4o",
			agent = "copilot",
			context = "nil",
			temperature = 0.2,

			window = {
				layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
				width = 0.37, -- fractional width of parent, or absolute width in columns when > 1
				height = 0.37, -- fractional height of parent, or absolute height in rows when > 1
				-- Options below only apply to floating windows
				relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
				border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
				row = nil, -- row position of the window, default is centered
				col = nil, -- column position of the window, default is centered
				title = "Copilot Chat", -- title of chat window
				footer = nil, -- footer of chat window
				zindex = 1, -- determines if window is on top or below other floating windows
			},

			show_help = true, -- Shows help message as virtual lines when waiting for user input
			show_folds = true, -- Shows folds for sections in chat
			highlight_selection = true, -- Highlight selection
			highlight_headers = false, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)
			auto_follow_cursor = true, -- Auto-follow cursor in chat
			auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
			insert_at_end = false, -- Move cursor to end of buffer when inserting text
			clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

			debug = false, -- Enable debug logging (same as 'log_level = 'debug')
			log_level = "info", -- Log level to use, 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
			proxy = nil, -- [protocol://]host[:port] Use this proxy
			allow_insecure = false, -- Allow insecure server connections

			chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)
			history_path = vim.fn.stdpath("data") .. "/copilotchat_history", -- Default path to stored history

			question_header = "# User ", -- Header to use for user questions
			answer_header = "# Copilot ", -- Header to use for AI answers
			error_header = "# Error ", -- Header to use for errors
			separator = "───", -- Separator to use in chat

			-- default prompt
			prompts = {
				Explain = {
					prompt = "> /COPILOT_EXPLAIN\n\n 解释选中的代码，中文输出",
				},

				Review = {
					prompt = "> /COPILOT_REVIEW\n\n 评审选中的代码，中文输出",
				},

				Fix = {
					prompt = "> /COPILOT_GENERATE\n\n 选中的代码有问题，重新生成代码，修复bug",
				},

				Optimize = {
					prompt = "> /COPILOT_OPTIMIZE\n\n 优化选中的代码，使其具有更好的性能和更好的可读性",
				},

				Docs = {
					prompt = "> /COPILOT_GENERATE\n\n 生成选中代码的文档",
				},

				Tests = {
					prompt = "> /COPILOT_GENERATE\n\n 生成选中代码的测试",
				},

				Commit = {
					prompt = "> #git:staged\n\nWrite commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
				},
			},

			-- default mappings
			-- default mappings
			mappings = {
				--complete = {
				--insert = "<C-\\>",
				--},
				close = {
					normal = "q",
					insert = "<C-c>",
				},
				reset = {
					normal = "<C-x>",
					insert = "<C-x>",
				},
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-CR>",
				},
				accept_diff = {
					normal = "<C-?>",
					insert = "<C-?>",
				},
				show_context = {
					normal = "gc",
				},
				show_help = {
					normal = "gh",
				},
			},
		},

		keys = {
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						if require("CopilotChat.select").visual ~= "" then
							require("CopilotChat").ask(input, {
								selection = require("CopilotChat.select").visual,
							})
						else
							require("CopilotChat").ask(input, {
								selection = require("CopilotChat.select").buffer,
							})
						end
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
			{
				"<leader>ap",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				desc = "CopilotChat - Prompt actions",
			},
			-- Code related commands
			{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "CopilotChat - Generate docs" },
			{ "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "CopilotChat - Fix code" },
			{ "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
			{ "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
			{ "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
			{ "<leader>ao", "<cmd>CopilotChatOptimize<cr>", desc = "CopilotChat - Optimize code" },
			{ "<leader>an", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle chat" },
			{ "<leader>ac", "<cmd>CopilotChatCommit<cr>", desc = "CopilotChat - Commit code" },
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
