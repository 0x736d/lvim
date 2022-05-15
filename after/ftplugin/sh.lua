require("lvim.lsp.manager").setup("bashls")

require("lvim.lsp.null-ls.formatters").setup({
	{ command = "shfmt", filetypes = { "sh" } },
})

require("lvim.lsp.null-ls.linters").setup({
	{ command = "shellcheck", filetypes = { "sh" } },
})

require("lvim.lsp.null-ls.code_actions").setup({
	{ command = "shellcheck", filetypes = { "sh" } },
})
