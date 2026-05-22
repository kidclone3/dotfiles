return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		window = {
			position = "right",
		},
		filesystem = {
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal toggle right<CR>", {})
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal toggle float<CR>", {})
	end,
}
