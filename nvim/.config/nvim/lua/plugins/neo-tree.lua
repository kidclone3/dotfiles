return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		close_if_last_window = true,
		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.opt_local.buflisted = false
					vim.opt_local.bufhidden = "hide"
				end,
			},
		},
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
		git_status = {
			symbols = {
				-- shown next to each changed file in the dedicated view
				added = "✚",
				modified = "✹",
				deleted = "✖",
				renamed = "➜",
				untracked = "?",
				ignored = "◌",
				unstaged = "⛔",
				staged = "✔",
				conflict = "",
			},
			window = {
				position = "right",
				mappings = {
					["<cr>"] = "open_tabnew",
					["o"] = "open_tabnew",
				},
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal toggle right<CR>", {})
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal toggle float<CR>", {})
	vim.keymap.set("n", "<leader>gg", ":Neotree git_status toggle right<CR>", {})
	end,
}
