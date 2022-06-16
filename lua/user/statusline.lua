local M = {}

local inactive = {
	filetypes = {
		"help",
		"startify",
		"dashboard",
		"packer",
		"neogitstatus",
		"NvimTree",
		"Trouble",
		"alpha",
		"lir",
		"Outline",
		"spectre_panel",
		"toggleterm",
		"qf",
		"dbui",
		"fugitive",
		"fugitiveblame",
	},
	buftypes = {
		"terminal",
		"dashboard",
		"nofile",
		"quickfix",
	},
}

local separator_icon_sets = {
	left_semicircle = "",
	right_semicircle = "",
	right_semicircle_cut = "",
	left_semicircle_cut = "",
	vertical_bar_chubby = "█",
	vertical_bar_medium = "┃",
	vertical_bar_thin = "│",
	vertical_bar_dotted = "",
	left_arrow_thin = "",
	right_arrow_thin = "",
	left_arrow_filled = "",
	right_arrow_filled = "",
	slant_left = "",
	slant_left_thin = "",
	slant_right = "",
	slant_right_thin = "",
	slant_left_2 = "",
	slant_left_2_thin = "",
	slant_right_2 = "",
	slant_right_2_thin = "",
	chubby_dot = "●",
	slim_dot = "•",
}

M.setup = function()
	local lsp_severity = vim.diagnostic.severity
	local b = vim.b

	local _, feline = pcall(require, "feline")
	local _, lsp = pcall(require, "feline.providers.lsp")
	local _, palette = pcall(require, "catppuccin.core.palettes.init")
	local colors = palette.get_palette()

	local color_preset = {
		default_bg = colors.mantle,
		default_fg = colors.subtext0,
		lsp_info = colors.maroon,
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

	local shortline = false

	local function is_enabled(is_shortline, winid, min_width)
		if is_shortline then
			return true
		end

		winid = winid or 0
		return vim.api.nvim_win_get_width(winid) > min_width
	end

	local blank_sep = {
		str = " ",
		hl = {
			fg = color_preset.default_bg,
			bg = color_preset.default_bg,
		},
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

	local vi_mode_hl = function()
		return {
			fg = color_preset.default_bg,
			bg = mode_colors[vim.fn.mode()][2],
			style = "bold",
		}
	end

	local is_lsp_attached = function()
		return next(vim.lsp.buf_get_clients(0)) ~= nil
	end

	local opts = {
		winbar_components = {
			active = { {}, {}, {} },
			inactive = { {}, {}, {} },
			force_inactive = {
				filetypes = {},
				buftypes = {},
				bufnames = {},
			},
		},
		components = {
			active = { {}, {}, {} },
			inactive = { {}, {}, {} },
			force_inactive = {
				filetypes = {},
				buftypes = {},
				bufnames = {},
			},
		},
	}

	opts.winbar_components.force_inactive.filetypes = inactive.filetypes
	opts.winbar_components.force_inactive.buftypes = inactive.buftypes
	opts.components.force_inactive.filetypes = inactive.filetypes
	opts.components.force_inactive.buftypes = inactive.buftypes

	-- ####################################################################################################
	-- # COMPONENTS
	-- ####################################################################################################

	opts.components.active[1][1] = {
		provider = separator_icon_sets.vertical_bar_chubby,
		hl = function()
			return {
				fg = mode_colors[vim.fn.mode()][2],
				bg = color_preset.default_bg,
			}
		end,
	}
	opts.components.active[1][2] = {
		provider = function()
			return " " .. mode_colors[vim.fn.mode()][1] .. " "
		end,
		hl = vi_mode_hl,
	}

	opts.components.active[1][3] = {
		provider = separator_icon_sets.right_arrow_filled,
		hl = function()
			return {
				fg = mode_colors[vim.fn.mode()][2],
				bg = colors.mauve,
			}
		end,
	}

	opts.components.active[1][4] = {
		provider = function()
			local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			return "  " .. dir_name .. " "
		end,

		enabled = is_enabled(shortline, winid, 80),

		hl = {
			fg = color_preset.default_bg,
			bg = colors.mauve,
			style = "bold",
		},
	}

	opts.components.active[1][5] = {
		provider = separator_icon_sets.right_arrow_filled,
		hl = function()
			return {
				fg = colors.mauve,
				bg = color_preset.default_bg,
			}
		end,
	}

	opts.components.active[1][6] = {
		provider = { name = "file_info", opts = { type = "relative-short" } },
		hl = {
			fg = colors.subtext1,
			bg = color_preset.default_bg,
		},
		left_sep = {
			str = " ",
			hl = {
				fg = colors.subtext1,
				bg = color_preset.default_bg,
			},
		},
		right_sep = blank_sep,
		enabled = is_enabled(shortline, winid, 70),
	}

	opts.components.active[1][7] = {
		provider = "position",
		-- enabled = shortline or function(winid)
		--  return vim.api.nvim_win_get_width(winid) > 90
		-- end,
		hl = {
			fg = colors.overlay1,
			bg = color_preset.default_bg,
		},
		left_sep = {
			str = separator_icon_sets.vertical_bar_dotted .. " ",
			hl = {
				fg = colors.peach,
				bg = color_preset.default_bg,
				style = "bold",
			},
		},
	}

	opts.components.active[1][8] = {
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
			bg = color_preset.default_bg,
		},
		left_sep = blank_sep,
	}

	opts.components.active[2][1] = {

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
			bg = color_preset.default_bg,
		},
	}

	-- genral diagnostics (errors, warnings. info and hints)
	opts.components.active[2][2] = {
		provider = "diagnostic_errors",
		enabled = function()
			return lsp.diagnostics_exist(lsp_severity.ERROR)
		end,

		hl = {
			fg = colors.red,
			bg = color_preset.default_bg,
		},
		icon = "  ",
	}

	opts.components.active[2][3] = {
		provider = "diagnostic_warnings",
		enabled = function()
			return lsp.diagnostics_exist(lsp_severity.WARN)
		end,
		hl = {
			fg = colors.yellow,
			bg = color_preset.default_bg,
		},
		icon = "  ",
	}

	opts.components.active[2][4] = {
		provider = "diagnostic_info",
		enabled = function()
			return lsp.diagnostics_exist(lsp_severity.INFO)
		end,
		hl = {
			fg = colors.sky,
			bg = color_preset.default_bg,
		},
		icon = "  ",
	}

	opts.components.active[2][5] = {
		provider = "diagnostic_hints",
		enabled = function()
			return lsp.diagnostics_exist(lsp_severity.HINT)
		end,
		hl = {
			fg = colors.rosewater,
			bg = color_preset.default_bg,
		},
		icon = "  ",
	}

	opts.components.active[3][1] = {
		provider = "git_branch",
		enabled = is_enabled(shortline, winid, 70),
		hl = {
			fg = colors.overlay2,
			bg = color_preset.default_bg,
			style = "bold",
		},
		icon = {
			str = "  ",
			hl = {
				fg = colors.teal,
				bg = color_preset.default_bg,
			},
		},
	}

	opts.components.active[3][2] = {
		provider = "git_diff_added",
		hl = {
			fg = colors.subtext1,
			bg = color_preset.default_bg,
		},
		enabled = any_git_changes,
		icon = {
			str = " +",
			hl = {
				fg = colors.green,
			},
		},
	}

	opts.components.active[3][3] = {
		provider = "git_diff_changed",
		hl = {
			fg = colors.subtext1,
			bg = color_preset.default_bg,
		},
		enabled = any_git_changes,
		icon = {
			str = " ~",
			hl = {
				fg = colors.yellow,
			},
		},
	}

	opts.components.active[3][4] = {
		provider = "git_diff_removed",
		hl = {
			fg = colors.subtext1,
			bg = color_preset.default_bg,
		},
		enabled = any_git_changes,
		icon = {
			str = " -",
			hl = {
				fg = colors.red,
			},
		},
	}

	opts.components.active[3][5] = {
		provider = separator_icon_sets.left_arrow_filled,
		hl = {
			fg = colors.maroon,
			bg = colors.base,
		},
		enabled = is_lsp_attached,
		left_sep = {
			str = "  ",
			hl = {
				fg = color_preset.default_bg,
				bg = color_preset.default_bg,
			},
		},
	}

	opts.components.active[3][6] = {
		provider = separator_icon_sets.vertical_bar_chubby,
		enabled = is_lsp_attached,
		hl = {
			fg = colors.maroon,
			bg = color_preset.default_bg,
		},
	}

	opts.components.active[3][7] = {
		provider = function()
			local clients = {}
			for _, client in pairs(vim.lsp.buf_get_clients(0)) do
				if client.name ~= "null-ls" then
					clients[#clients + 1] = client.name
				end
			end

			return table.concat(clients, " "), " "
		end,
		enabled = is_lsp_attached,
		hl = {
			fg = color_preset.default_bg,
			bg = colors.maroon,
		},
		right_sep = {
			str = " ",
			hl = {
				fg = colors.maroon,
				bg = colors.maroon,
			},
		},
	}

	opts.components.active[3][8] = {
		provider = separator_icon_sets.left_arrow_filled,
		hl = {
			fg = colors.lavender,
			bg = colors.maroon,
		},
	}

	opts.components.active[3][9] = {
		provider = separator_icon_sets.vertical_bar_chubby,
		hl = {
			fg = colors.lavender,
			bg = color_preset.default_bg,
		},
	}

	opts.components.active[3][10] = {
		provider = "file_encoding",
		hl = {
			fg = color_preset.default_bg,
			bg = colors.lavender,
		},
	}

	opts.components.active[3][11] = {
		provider = separator_icon_sets.vertical_bar_chubby,
		hl = {
			fg = colors.lavender,
			bg = color_preset.default_bg,
		},
	}

	opts.components.active[3][12] = {
		provider = "scroll_bar",
		hl = {
			fg = colors.peach,
			bg = color_preset.default_bg,
		},
	}

	opts.winbar_components.active[1][1] = {
		provider = { name = "file_info", opts = { type = "unique" } },
		hl = {
			fg = colors.overlay1,
			bg = colors.base,
		},
		left_sep = {
			str = " ",
			hl = {
				fg = colors.subtext1,
				bg = colors.base,
			},
		},
		right_sep = {
			str = " > ",
			hl = {
				fg = colors.subtext1,
				bg = colors.base,
			},
		},
		enabled = is_enabled(shortline, winid, 70),
	}

	local ok, navic = pcall(require, "nvim-navic")
	opts.winbar_components.active[1][2] = {
		provider = function()
			if not ok then
				return ""
			end
			return navic.get_location()
		end,
		hl = {
			bg = colors.base,
			fg = colors.subtext0,
		},
		enabled = navic.is_available,
	}

	feline.setup({
		components = opts.components,
		force_inactive = opts.components.force_inactive,
	})

	feline.winbar.setup({ components = opts.winbar_components, force_inactive = opts.winbar_components.force_inactive })
end

return M
