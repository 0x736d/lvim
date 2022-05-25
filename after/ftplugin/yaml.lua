local opts = {
	settings = {
		yaml = {

			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},

			schemas = {
				kubernetes = {
					"*.k8s.daemonset.{yml,yaml}",
					"*.k8s.deployment.{yml,yaml}",
					"*.k8s.service.{yml,yaml}",
					"*.k8s.ingress.{yml,yaml}",
					"*.k8s.configmap.{yml,yaml}",
					"*.k8s.secret.{yml,yaml}",
					"*.k8s.pod.{yml,yaml}",
				},
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/deployment.json"] = "*.k8s.deployment.{yml,yaml}",
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/service.json"] = "*.k8s.service.{yml,yaml}",
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/ingress.json"] = "*.k8s.ingress.{yml,yaml}",
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/configmap.json"] = "*.k8s.configmap.{yml,yaml}",
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/secret.json"] = "*.k8s.secret.{yml,yaml}",
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/daemonset.json"] = "*.k8s.daemonset.{yml,yaml}",
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/pod.json"] = "*.k8s.pod.{yml,yaml}",
			},

			hover = true,
			completion = true,
			validate = true,
		},
	},
}

require("lvim.lsp.manager").setup("yamlls", opts)

require("lvim.lsp.null-ls.linters").setup({
	{ command = "yamllint", filetypes = { "yaml" } },
})
