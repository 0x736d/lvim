local M = {}

M.inactive = {
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

M.get_colors = function()
	local colors = {}
	local ok, palette = pcall(require, "catppuccin.core.palettes.init")
	if ok then
		colors = palette.get_palette()
	end
	return colors
end

return M
