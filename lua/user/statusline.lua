local lsp_severity = vim.diagnostic.severity
local b = vim.b
local colors = require("user.utils").get_colors()
local inactive = require("user.utils").inactive

local _, lsp = pcall(require, "feline.providers.lsp")

local seprator_style = {
	round = {
		left = "",
		right = "",
	},

	circle = {
		left = "",
		right = "",
	},

	bars = {
		large = "█",
		default = "┃",
		thin = "│",
		dotted = "",
	},

	arrow_thin = {
		left = "",
		right = "",
	},

	arrow_full = {
		left = "",
		right = "",
	},

	dots = {
		large = "●",
		small = "•",
	},
}

local mode_colors = {
	["n"] = { "NORMAL", colors.lavender },
	["no"] = { "N-PENDING", colors.lavender },
	["i"] = { "INSERT", colors.green },
	["ic"] = { "INSERT", colors.green },
	["t"] = { "TERMINAL", colors.green },
	["v"] = { "VISUAL", colors.flamingo },
	["V"] = { "V-LINE", colors.flamingo },
	[""] = { "V-BLOCK", colors.flamingo },
	["R"] = { "REPLACE", colors.maroon },
	["Rv"] = { "V-REPLACE", colors.maroon },
	["s"] = { "SELECT", colors.maroon },
	["S"] = { "S-LINE", colors.maroon },
	[""] = { "S-BLOCK", colors.maroon },
	["c"] = { "COMMAND", colors.peach },
	["cv"] = { "COMMAND", colors.peach },
	["ce"] = { "COMMAND", colors.peach },
	["r"] = { "PROMPT", colors.teal },
	["rm"] = { "MORE", colors.teal },
	["r?"] = { "CONFIRM", colors.mauve },
	["!"] = { "SHELL", colors.green },
}

local function any_git_changes()
	local gst = b.gitsigns_status_dict -- git stats
	if gst then
		if
			gst["added"] and gst["added"] > 0
			or gst["removed"] and gst["removed"] > 0
			or gst["changed"] and gst["changed"] > 0
		then
			return true
		end
	end
	return false
end

local function invisible_sep()
	return {
		str = " ",
		hl = {
			fg = colors.mantle,
			bg = colors.mantle,
		},
	}
end

local function is_lsp_attached()
	return next(vim.lsp.buf_get_clients(0)) ~= nil
end

local shortline = false
local function is_enabled(is_shortline, winid, min_width)
	if is_shortline then
		return true
	end

	winid = winid or 0
	return vim.api.nvim_win_get_width(winid) > min_width
end

local function vi_mode_hl()
	return {
		fg = colors.mantle,
		bg = mode_colors[vim.fn.mode()][2],
		style = "bold",
	}
end

local M = {}

M.statusline = {
	components = {
		active = { {}, {}, {} },
		inactive = { {}, {}, {} },
	},
}

local providers = {
	mode = {
		{
			provider = seprator_style.bars.large,
			hl = function()
				return {
					fg = mode_colors[vim.fn.mode()][2],
					bg = colors.mantle,
				}
			end,
		},
		{
			provider = function()
				return " " .. mode_colors[vim.fn.mode()][1] .. " "
			end,
			hl = vi_mode_hl,
		},
		{
			provider = seprator_style.arrow_full.right,
			hl = function()
				return {
					fg = mode_colors[vim.fn.mode()][2],
					bg = colors.mauve,
				}
			end,
		},
	},

	dir_name = {
		{

			provider = function()
				local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				return "  " .. dir_name .. " "
			end,

			enabled = is_enabled(shortline, winid, 90),

			hl = {
				fg = colors.mantle,
				bg = colors.mauve,
				style = "bold",
			},
		},
		{
			provider = seprator_style.arrow_full.right,
			enabled = is_enabled(shortline, winid, 90),
			hl = function()
				return {
					fg = colors.mauve,
					bg = colors.mantle,
				}
			end,
		},
	},

	file_info = {
		{
			provider = { name = "file_info", opts = { type = "unique-short" } },
			hl = {
				fg = colors.subtext1,
				bg = colors.mantle,
			},
			left_sep = {
				str = " ",
				hl = {
					fg = colors.subtext1,
					bg = colors.mantle,
				},
			},
			right_sep = invisible_sep(),
			enabled = is_enabled(shortline, winid, 80),
		},
		{
			provider = "position",
			-- enabled = shortline or function(winid)
			--  return vim.api.nvim_win_get_width(winid) > 90
			-- end,
			hl = {
				fg = colors.overlay1,
				bg = colors.mantle,
			},
			left_sep = {
				str = seprator_style.bars.dotted .. " ",
				hl = {
					fg = colors.peach,
					bg = colors.mantle,
					style = "bold",
				},
			},
		},
		{
			provider = function()
				local current_line = vim.fn.line(".")
				local total_line = vim.fn.line("$")

				if current_line == 1 then
					return " Top "
				elseif current_line == vim.fn.line("$") then
					return " Bot "
				end
				local result, _ = math.modf((current_line / total_line) * 100)
				return " " .. result .. "%% "
			end,
			-- enabled = shortline or function(winid)
			-- 	return vim.api.nvim_win_get_width(winid) > 90
			-- end,
			hl = {
				fg = colors.overlay1,
				bg = colors.mantle,
			},
			left_sep = invisible_sep(),
		},
	},
	lsp = {
		{
			provider = function()
				local Lsp = vim.lsp.util.get_progress_messages()[1]

				if Lsp then
					local msg = Lsp.message or ""
					local percentage = Lsp.percentage or 0
					local title = Lsp.title or ""
					local spinners = {
						"",
						"",
						"",
					}
					local success_icon = {
						"",
						"",
						"",
					}
					local ms = vim.loop.hrtime() / 1000000
					local frame = math.floor(ms / 120) % #spinners

					if percentage >= 70 then
						return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
					end

					return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
				end

				return ""
			end,
			enabled = is_enabled(shortline, winid, 80),
			hl = {
				fg = colors.rosewater,
				bg = colors.mantle,
			},
		},
		{
			provider = "diagnostic_errors",
			enabled = function()
				return lsp.diagnostics_exist(lsp_severity.ERROR)
			end,

			hl = {
				fg = colors.red,
				bg = colors.mantle,
			},
			icon = "  ",
		},
		{
			provider = "diagnostic_warnings",
			enabled = function()
				return lsp.diagnostics_exist(lsp_severity.WARN)
			end,
			hl = {
				fg = colors.yellow,
				bg = colors.mantle,
			},
			icon = "  ",
		},
		{
			provider = "diagnostic_info",
			enabled = function()
				return lsp.diagnostics_exist(lsp_severity.INFO)
			end,
			hl = {
				fg = colors.sky,
				bg = colors.mantle,
			},
			icon = "  ",
		},
		{
			provider = "diagnostic_hints",
			enabled = function()
				return lsp.diagnostics_exist(lsp_severity.HINT)
			end,
			hl = {
				fg = colors.rosewater,
				bg = colors.mantle,
			},
			icon = "  ",
		},
	},

	git = {
		{
			provider = "git_branch",
			enabled = is_enabled(shortline, winid, 70),
			hl = {
				fg = colors.overlay2,
				bg = colors.mantle,
				style = "bold",
			},
			icon = {
				str = "  ",
				hl = {
					fg = colors.teal,
					bg = colors.mantle,
				},
			},
		},
		{
			provider = "git_diff_added",
			hl = {
				fg = colors.subtext1,
				bg = colors.mantle,
			},
			enabled = any_git_changes and is_enabled(shortline, winid, 100),
			icon = {
				str = " +",
				hl = {
					fg = colors.green,
				},
			},
		},
		{
			provider = "git_diff_changed",
			hl = {
				fg = colors.subtext1,
				bg = colors.mantle,
			},
			enabled = any_git_changes and is_enabled(shortline, winid, 100),
			icon = {
				str = " ~",
				hl = {
					fg = colors.yellow,
				},
			},
		},
		{
			provider = "git_diff_removed",
			hl = {
				fg = colors.subtext1,
				bg = colors.mantle,
			},
			enabled = any_git_changes and is_enabled(shortline, winid, 100),
			icon = {
				str = " -",
				hl = {
					fg = colors.red,
				},
			},
		},
	},
	lsp_clients = {
		{
			provider = seprator_style.arrow_full.left,
			hl = {
				fg = colors.maroon,
				bg = colors.base,
			},
			enabled = is_lsp_attached and is_enabled(shortline, winid, 110),
			left_sep = {
				str = "  ",
				hl = {
					fg = colors.mantle,
					bg = colors.mantle,
				},
			},
		},
		{

			provider = seprator_style.bars.large,
			enabled = is_lsp_attached and is_enabled(shortline, winid, 110),
			hl = {
				fg = colors.maroon,
				bg = colors.mantle,
			},
		},
		{
			provider = function()
				local clients = {}
				for _, client in pairs(vim.lsp.buf_get_clients(0)) do
					if client.name ~= "null-ls" then
						clients[#clients + 1] = client.name
					end
				end

				return table.concat(clients, " "), " "
			end,
			enabled = is_lsp_attached and is_enabled(shortline, winid, 110),
			hl = {
				fg = colors.mantle,
				bg = colors.maroon,
			},
			right_sep = {
				str = " ",
				hl = {
					fg = colors.maroon,
					bg = colors.maroon,
				},
			},
		},
	},

	file_encoding = {
		{
			provider = seprator_style.arrow_full.left,
			hl = {
				fg = colors.lavender,
				bg = colors.maroon,
			},
		},
		{

			provider = seprator_style.bars.large,
			hl = {
				fg = colors.lavender,
				bg = colors.mantle,
			},
		},
		{
			provider = "file_encoding",
			hl = {
				fg = colors.mantle,
				bg = colors.lavender,
			},
		},
		{
			provider = seprator_style.bars.large,
			hl = {
				fg = colors.lavender,
				bg = colors.mantle,
			},
		},
	},

	scroll_bar = {
		{
			provider = "scroll_bar",
			hl = {
				fg = colors.peach,
				bg = colors.mantle,
			},
		},
	},
}

M.setup = function()
	local ok, feline = pcall(require, "feline")
	if not ok then
		return
	end

	for _, v in pairs(providers.mode) do
		M.statusline.components.active[1][#M.statusline.components.active[1] + 1] = v
	end

	for _, v in pairs(providers.dir_name) do
		M.statusline.components.active[1][#M.statusline.components.active[1] + 1] = v
	end

	for _, v in pairs(providers.file_info) do
		M.statusline.components.active[1][#M.statusline.components.active[1] + 1] = v
	end

	for _, v in pairs(providers.lsp) do
		M.statusline.components.active[2][#M.statusline.components.active[2] + 1] = v
	end

	for _, v in pairs(providers.git) do
		M.statusline.components.active[3][#M.statusline.components.active[3] + 1] = v
	end

	for _, v in pairs(providers.lsp_clients) do
		M.statusline.components.active[3][#M.statusline.components.active[3] + 1] = v
	end

	for _, v in pairs(providers.file_encoding) do
		M.statusline.components.active[3][#M.statusline.components.active[3] + 1] = v
	end

	for _, v in pairs(providers.scroll_bar) do
		M.statusline.components.active[3][#M.statusline.components.active[3] + 1] = v
	end
	feline.setup({
		components = M.statusline.components,
		force_inactive = inactive,
	})
end

return M
