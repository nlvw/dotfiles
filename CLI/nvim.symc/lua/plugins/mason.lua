return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"ansible-language-server",
				"ansible-lint",
				"bash-language-server",
				"stylua",
				"shellcheck",
				"shfmt",
				"yaml-language-server",
				"yamllint",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			auto_install = true,
		},
	},
}
