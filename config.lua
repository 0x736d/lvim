--***************************************************************************--
-- vim general
--***************************************************************************--
vim.opt.cmdheight = 1

-- NOTE: experimenting
--***************************************************************************--
-- autocmds
--***************************************************************************--
vim.api.nvim_create_augroup("_change_cursor_shape", {})
vim.api.nvim_create_autocmd("ExitPre", {
	group = "_change_cursor_shape",
	pattern = "*",
	command = "set guicursor=a:hor20,a:blinkwait750-blinkoff400-blinkon250-Cursor/lCursor",
})

--***************************************************************************--
-- lvim general
--***************************************************************************--
lvim.leader = "space"
lvim.log.level = "warn"
lvim.format_on_save = true

--***************************************************************************--
-- custom keys
--***************************************************************************--
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

--***************************************************************************--
-- disable diagnostics outputs with virtual_text
--***************************************************************************--
lvim.lsp.diagnostics.virtual_text = false

--***************************************************************************--
-- builtin plugins
--***************************************************************************--
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.active = true
-- debugger adapter
lvim.builtin.dap.active = true

-- for rainbow brackets
-- NOTE: colors don't have any effect because when using colorscheme with builtin integration of ts-rainbow
lvim.builtin.treesitter.rainbow = {
	enable = true,
	extended_mode = true,
	max_file_lines = nil,
	colors = {
		"#8be9fd",
		"#50fa7b",
		"#ffb86c",
		"#ff79c6",
		"#bd93f9",
		"#ff5555",
		"#f1fa8c",
	},
}

lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"javascript",
	"json",
	"lua",
	"python",
	"typescript",
	"tsx",
	"css",
	"rust",
	"java",
	"yaml",
	"markdown",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	-- for input mode
	i = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
		["<C-n>"] = actions.cycle_history_next,
		["<C-p>"] = actions.cycle_history_prev,
	},
	-- for normal mode
	n = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
	},
}

--***************************************************************************--
-- null-ls
--***************************************************************************--

--***************************************************************************--
-- formatters setup (not lazyloaded)
--***************************************************************************--
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "stylua", filetypes = { "lua" } },
	{ command = "rustfmt", filetypes = { "rust" } },
	{
		command = "prettier",
		filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"json",
			"html",
			"markdown",
			"yaml",
		},
	},
})

--***************************************************************************--
-- linters setup
--***************************************************************************--
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "eslint_d", filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" } },
	{ command = "luacheck", filetypes = { "lua" } },
})

--***************************************************************************--
-- custom whichkey mappings
--***************************************************************************--

-- TroubleToggle
lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	t = { "<cmd>TroubleToggle<cr>", "TroubleToggle" },
	r = { "<cmd>Trouble lsp_references<cr>", "References" },
	f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
	q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
	l = { "<cmd>Trouble loclist<cr>", "LocationList" },
	w = { "<cmd>Trouble workspace_diagnostics<cr>", "Diagnostics" },
}

-- Telescope projects
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- Hop
lvim.builtin.which_key.mappings["n"] = {
	name = "Hop",
	w = { "<cmd>HopWord<cr>", "word" },
	l = { "<cmd>HopLine<cr>", "line" },
	p = { "<cmd>HopPattern<cr>", "pattern" },
}

-- Session (persistence)
lvim.builtin.which_key.mappings["S"] = {
	name = "Session",
	c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
	l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
	Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

-- Spectre
lvim.builtin.which_key.mappings["U"] = {
	name = "Spectre",
	o = { "<cmd>lua require('spectre').open()<cr>", "Open Spectre" },
	-- TODO: need more keybinds
}

-- Goto preview
lvim.builtin.which_key.mappings["m"] = {
	name = "Goto preview",
	d = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "Go to preview definition" },
	i = { "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", "Go to preview implementation" },
	q = { "<cmd>lua require('goto-preview').close_all_win()<cr>", "Close all preview" },
	r = { "<cmd>lua require('goto-preview').goto_preview_references()<cr>", "Go to preview references" },
}

lvim.builtin.which_key.mappings["i"] = {
	name = "gh issue",
	c = { "<cmd>Octo issue create<cr>", "Create issue" },
	l = { "<cmd>Octo issue list<cr>", "List issues" },
}

lvim.builtin.which_key.mappings["a"] = {
	name = "gh pr",
	o = { "<cmd>Octo pr create<cr>", "Create pr" },
	l = { "<cmd>Octo pr list<cr>", "List pr" },
}

--***************************************************************************--
-- skipped lsp servers for manual configuration
--===========================================================================--
--  - rust_analyzer (configured with rust-tools.nvim)
--  - gopls (after/ftplugin/go.lua)
--***************************************************************************--
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer", "gopls", "yamlls" })

--***************************************************************************--
-- Additional Plugins
--***************************************************************************--
lvim.plugins = {
	{ "lunarvim/colorschemes" },
	{ "p00f/nvim-ts-rainbow" },
	{ "christianchiarulli/nvcode-color-schemes.vim" },
	{ "folke/tokyonight.nvim" },
	{ "yashguptaz/calvera-dark.nvim" },
	{ "EdenEast/nightfox.nvim" },
	{
		"catppuccin/nvim",
		as = "catppuccin",
	},
	{
		"nvim-treesitter/playground",
		event = "BufRead",
	},
	{ "rebelot/kanagawa.nvim" },
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup()
		end,
	},
	{
		"simrat39/rust-tools.nvim",
		config = function()
			local lsp_installer_servers = require("nvim-lsp-installer.servers")
			local _, requested_server = lsp_installer_servers.get_server("rust_analyzer")
			require("rust-tools").setup({
				tools = {
					autoSetHints = true,
					hover_with_actions = true,
					inlay_hints = {
						show_parameter_hints = true,
					},
					runnables = {
						use_telescope = true,
					},
				},
				server = {
					cmd_env = requested_server._default_options.cmd_env,
					on_attach = require("lvim.lsp").common_on_attach,
					on_init = require("lvim.lsp").common_on_init,
				},
			})
		end,
		ft = { "rust", "rs" },
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		setup = function()
			vim.g.indentLine_enabled = 1
			vim.g.indent_blankline_char = "▏"
			vim.g.indent_blankline_filetype_exclude = { "lspinfo", "help", "terminal", "dashboard" }
			vim.g.indent_blankline_buftype_exclude = { "terminal", "dashboard", "nofile", "quickfix" }
			vim.g.indent_blankline_show_trailing_blankline_indent = false
			vim.g.indent_blankline_show_first_indent_level = false
		end,
	},
	{
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require("neoscroll").setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				easing_function = "sine",
				pre_hook = nil, -- Function to run before the scrolling animation starts
				post_hook = nil, -- Function to run after the scrolling animation ends
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup()
		end,
	},
	{
		"f-person/git-blame.nvim",
		event = "BufRead",
		config = function()
			vim.g.gitblame_enabled = 1
			vim.g.gitblame_display_virtual_text = 0
		end,
	},
	{
		"nacro90/numb.nvim",
		event = "BufRead",
		config = function()
			require("numb").setup({
				show_numbers = true, -- Enable 'number' for the window while peeking
				show_cursorline = true, -- Enable 'cursorline' for the window while peeking
			})
		end,
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		module = "persistence",
		config = function()
			require("persistence").setup({
				dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
				options = { "buffers", "curdir", "tabpages", "winsize" },
			})
		end,
	},
	{
		"windwp/nvim-spectre",
		event = "BufRead",
		config = function()
			require("spectre").setup()
		end,
	},
	{
		"sindrets/diffview.nvim",
		event = "BufRead",
	},
	{
		"phaazon/hop.nvim",
		event = "BufRead",
		config = function()
			require("hop").setup()
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		ft = "markdown",
		config = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_auto_start = 1
		end,
	},
	{
		"npxbr/glow.nvim",
		ft = { "markdown" },
	},
	{
		"tpope/vim-surround",
		keys = { "c", "d", "y" },
	},
	{
		"leoluz/nvim-dap-go",
	},
	{ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } },
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({
				width = 80, -- Width of the floating window
				height = 15, -- Height of the floating window
				default_mappings = false, -- Bind default mappings
				debug = false, -- Print debug information
				opacity = 5, -- 0-100 opacity level of the floating window where 100 is fully transparent.
				post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
				focus_on_open = true,
				dismiss_on_move = false,
			})
		end,
	},
	{
		"SmiteshP/nvim-gps",
		requires = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-gps").setup()
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		event = { "BufRead", "BufNew" },
		config = function()
			require("bqf").setup({
				auto_enable = true,
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
				},
				func_map = {
					vsplit = "",
					ptogglemode = "z,",
					stoggleup = "",
				},
				filter = {
					fzf = {
						action_for = { ["ctrl-s"] = "split" },
						extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
					},
				},
			})
		end,
	},
	{
		"pwntester/octo.nvim",
		event = "BufRead",
		config = function()
			require("octo").setup({
				default_remote = { "upstream", "origin" }, -- order to try remotes
				reaction_viewer_hint_icon = "", -- marker for user reactions
				user_icon = " ", -- user icon
				timeline_marker = "", -- timeline marker
				timeline_indent = "2", -- timeline indentation
				right_bubble_delimiter = "", -- Bubble delimiter
				left_bubble_delimiter = "", -- Bubble delimiter
				github_hostname = "", -- GitHub Enterprise host
				snippet_context_lines = 4, -- number or lines around commented lines
				file_panel = {
					size = 10, -- changed files panel rows
					use_icons = true, -- use web-devicons in file panel
				},
				mappings = {
					issue = {
						reload = { lhs = "<C-r>", desc = "reload issue" },
						open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
						copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
						create_label = { lhs = "<space>lc", desc = "create label" },
						add_label = { lhs = "<space>la", desc = "add label" },
						remove_label = { lhs = "<space>ld", desc = "remove label" },
						add_comment = { lhs = "<space>ca", desc = "add comment" },
						delete_comment = { lhs = "<space>cd", desc = "delete comment" },
						next_comment = { lhs = "]c", desc = "go to next comment" },
						prev_comment = { lhs = "[c", desc = "go to previous comment" },
						react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
						react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
						react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
						react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
						react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
						react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
						react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
						react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
					},
					pull_request = {
						checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
						merge_pr = { lhs = "<space>pm", desc = "merge commit PR" },
						squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
						list_commits = { lhs = "<space>pc", desc = "list PR commits" },
						list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
						show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
						add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
						remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
						close_issue = { lhs = "<space>ic", desc = "close PR" },
						reopen_issue = { lhs = "<space>io", desc = "reopen PR" },
						list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
						reload = { lhs = "<C-r>", desc = "reload PR" },
						open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
						copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
						goto_file = { lhs = "gf", desc = "go to file" },
						add_assignee = { lhs = "<space>aa", desc = "add assignee" },
						remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
						create_label = { lhs = "<space>lc", desc = "create label" },
						add_label = { lhs = "<space>la", desc = "add label" },
						remove_label = { lhs = "<space>ld", desc = "remove label" },
						goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
						add_comment = { lhs = "<space>ca", desc = "add comment" },
						delete_comment = { lhs = "<space>cd", desc = "delete comment" },
						next_comment = { lhs = "]c", desc = "go to next comment" },
						prev_comment = { lhs = "[c", desc = "go to previous comment" },
						react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
						react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
						react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
						react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
						react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
						react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
						react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
						react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
					},
				},
			})
		end,
	},
}
--***************************************************************************--
-- # COLORSCHEME CONFIG
--***************************************************************************--
local catppuccin = require("catppuccin")
catppuccin.setup({
	transparent_background = true,
	term_colors = false,
	styles = {
		comments = "italic",
		conditionals = "italic",
		loops = "NONE",
		functions = "italic",
		keywords = "NONE",
		strings = "NONE",
		variables = "NONE",
		numbers = "bold",
		booleans = "italic",
		properties = "NONE",
		types = "NONE",
		operators = "NONE",
	},
	integrations = {
		treesitter = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = "italic",
				hints = "italic",
				warnings = "italic",
				information = "italic",
			},
			underlines = {
				errors = "undercurl",
				hints = "underdot",
				warnings = "undercurl",
				information = "underdot",
			},
		},
		lsp_trouble = true,
		cmp = true,
		lsp_saga = false,
		gitgutter = false,
		gitsigns = true,
		telescope = true,
		nvimtree = {
			enabled = true,
			show_root = true,
			transparent_panel = true,
		},
		neotree = {
			enabled = false,
			show_root = false,
			transparent_panel = false,
		},
		which_key = true,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = true,
		},
		dashboard = true,
		neogit = false,
		vim_sneak = false,
		fern = false,
		barbar = false,
		bufferline = true,
		markdown = true,
		lightspeed = false,
		ts_rainbow = true,
		hop = true,
		notify = true,
		telekasten = true,
		symbols_outline = true,
	},
})

--***************************************************************************--
-- # overrides for hl groups
--***************************************************************************--
local colors = require("catppuccin.api.colors").get_colors()

catppuccin.remap({
	-- 	-- general
	TSKeywordFunction = { fg = colors.mauve, style = "bold,italic" },
	TSMethod = { fg = colors.blue, style = "NONE" },
	TSFunction = { fg = colors.sapphire, style = "italic" },
	-- 	-- typescript
	-- 	typescriptTSType = { fg = colors.yellow },
	-- 	typescriptTSTypeBuiltin = { fg = colors.yellow, style = "bold" },
	-- 	typescriptTSParameter = { fg = colors.white, style = "italic" },
	-- 	typescriptInterfaceName = { fg = colors.yellow },
	-- 	typescriptTSNumber = { fg = colors.peach },

	-- 	-- go
	goTSProperty = { fg = colors.subtext1 },
	goTSVariable = { fg = colors.text },
	goTSTypeBuiltin = { fg = colors.yellow, style = "bold" },
	-- 	goTSMethod = { fg = colors.blue },
	goTSParameter = { fg = colors.subtext0, style = "italic" },
	-- 	goTSNumber = { fg = colors.peach },
	goTSType = { fg = colors.teal },
	goTSNamespace = { fg = colors.text, style = "bold" },
	-- 	goTSKeyword = { fg = colors.red },
	-- 	goTSKeywordFunction = { fg = colors.maroon, style = "italic,bold" },
	-- 	-- jsx/tsx
	tsxTSMethod = { fg = colors.blue, style = "italic" },
	-- 	tsxTSProperty = { fg = colors.lavender, style = "italic" },
	-- 	tsxTSTypeBuiltin = { fg = colors.yellow, style = "bold" },
	-- 	tsxTSParameter = { fg = colors.white, style = "italic" },
	-- 	tsxTSConstructor = { fg = colors.flamingo, style = "bold" },
	-- 	tsxTSTagAttribute = { fg = colors.lavender },
	-- 	tsxTSNumber = { fg = colors.peach },

	-- 	-- dockerfile
	dockerfileTSKeyword = { fg = colors.mauve, style = "bold" },
	-- -- lua
	luaTSField = { fg = colors.lavender },
})

--***************************************************************************--
vim.g.catppuccin_flavour = "mocha"
lvim.colorscheme = "catppuccin"
--***************************************************************************--

--***************************************************************************--
-- statusline configuration
--***************************************************************************--
local is_readonly = {
	function()
		if not vim.bo.readonly or not vim.bo.modifiable then
			return ""
		end
		return " "
	end,
	color = { fg = colors.red },
}

local components = require("lvim.core.lualine.components")
local gps = require("nvim-gps")

lvim.builtin.lualine.inactive_sections = {
	lualine_a = {},
	lualine_b = {},
	lualine_c = {},
	lualine_x = {},
	lualine_y = {},
	lualine_z = {},
}

lvim.builtin.lualine.sections = {
	lualine_a = { "mode" },
	lualine_b = {},
	lualine_c = {
		{ gps.get_location, cond = gps.is_avaliable, left_padding = 2, color = { fg = colors.overlay1 } },
	},
	lualine_x = {
		{
			"branch",
			icon = { "", color = { fg = colors.teal } },
			padding = 0,
		},
		{ "diff", separator = "", padding = 1 },
		{ "diagnostics", separator = "" },
		{ "filetype", separator = "" },
		{ "filename", color = { fg = colors.lavender, gui = "bold" }, separator = "" },
		is_readonly,
		components.encoding,
	},
	lualine_y = {},
	lualine_z = { components.scrollbar },
}
--***************************************************************************--
-- ##
--***************************************************************************--
