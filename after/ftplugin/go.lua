--***************************************************************************--
-- null-ls
--***************************************************************************--
require("lvim.lsp.null-ls.formatters").setup({
	{ command = "goimports", filetypes = { "go", "gomod", "gotmpl" } },
})

require("lvim.lsp.null-ls.linters").setup({
	{ command = "golangci_lint", filetypes = { "go" } },
})

--***************************************************************************--
-- debugger
--***************************************************************************--
require("dap-go").setup()

local dap, dapui = require("dap"), require("dapui")
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

--***************************************************************************--
-- lsp - gopls
--***************************************************************************--
local opts = {
	settings = {
		gopls = {
			gofumpt = true,
			codelenses = {
				generate = true, -- Runs go generate for a given directory
				test = true,
				tidy = true, -- Runs go mod tidy for a module
				upgrade_dependency = true, -- Upgrades a dependency in the go.mod file for a module
				vendor = true, -- Runs go mod vendor for a module
			},
			completeUnimported = true,
			staticcheck = true,
			usePlaceholders = true, -- enables placeholders for function parameters or struct fields in completion responses
			analyses = {
				fieldalignment = true, -- find structs that would use less memory if their fields were sorted
				nilness = true, -- check for redundant or impossible nil comparisons
				shadow = true, -- check for possible unintended shadowing of variables
				unusedparams = true, -- check for unused parameters of functions
				unusedwrite = true, -- checks for unused writes, an instances of writes to struct fields and arrays that are never read
			},
		},
	},
}

require("lvim.lsp.manager").setup("gopls", opts)
