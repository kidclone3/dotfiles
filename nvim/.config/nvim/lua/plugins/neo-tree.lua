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
			mappings = {
				["<cr>"] = "open_tabnew",
				["o"] = "open_tabnew",
				-- free up `y` as a prefix (default `y` = copy_to_clipboard fires too early)
				["y"] = "none",
				["yy"] = "copy_to_clipboard", -- original file-copy (paste with p)
				["yn"] = "copy_filename_to_clipboard", -- just the name
				["yp"] = "copy_path_to_clipboard", -- absolute path
			},
		},
		commands = {
			copy_filename_to_clipboard = function(state)
				local node = state.tree:get_node()
				local name = node.name
				vim.fn.setreg("+", name)
				vim.notify("Copied filename: " .. name)
			end,
			copy_path_to_clipboard = function(state)
				local node = state.tree:get_node()
				local path = node:get_id() -- absolute path
				vim.fn.setreg("+", path)
				vim.notify("Copied path: " .. path)
			end,
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
