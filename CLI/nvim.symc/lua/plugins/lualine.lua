return {
	"nvim-lualine/lualine.nvim",
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	event = "VeryLazy",
	opts = function()
		return {
			theme = 'dracula',
			--[[add your custom lualine config here]]
		}
	end,
}
