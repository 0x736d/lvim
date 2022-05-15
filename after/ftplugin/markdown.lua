require("lvim.lsp.manager").setup("ltex")

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "markdownlint", filetypes = { "markdown" } },
})
