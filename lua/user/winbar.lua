local colors = require("user.utils").get_colors()
local inactive = require("user.utils").inactive

local M = {}

M.setup = function()
	local _, feline = pcall(require, "feline")

	local ok, navic = pcall(require, "nvim-navic")
	if not ok then
		return
	end

	local components = { active = { {}, {}, {} }, inactive = { {}, {}, {} } }
	components.active[1][1] = {
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
	}

	components.active[1][2] = {
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

	feline.winbar.setup({
		components = components,
		force_inactive = inactive,
	})
end

return M
