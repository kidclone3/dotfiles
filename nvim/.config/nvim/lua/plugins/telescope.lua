return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local preview_utils = require("telescope.previewers.utils")
      local image_extensions = {
        avif = true,
        bmp = true,
        gif = true,
        heic = true,
        jpeg = true,
        jpg = true,
        png = true,
        tiff = true,
        webp = true,
      }

      local function is_image(filepath)
        return image_extensions[vim.fn.fnamemodify(filepath, ":e"):lower()] == true
      end

      local telescope_active = false
      local telescope_preview_visible = false

      local function clear_image_scene(image)
        -- Sixel has no placement-delete operation. Clear the complete scene;
        -- image.nvim's Sixel backend then redraws only the desired frame.
        image.clear()
        vim.cmd("redraw!")
      end

      local function preview_binary(filepath, bufnr, opts)
        local ok, image = pcall(require, "image")
        if ok then
          clear_image_scene(image)
          telescope_preview_visible = false
        end

        if not is_image(filepath) then
          preview_utils.set_preview_message(
            bufnr,
            opts.winid,
            "Binary cannot be previewed",
            opts.preview.msg_bg_fillchar
          )
          return
        end

        if not ok then
          preview_utils.set_preview_message(bufnr, opts.winid, "image.nvim is unavailable", opts.preview.msg_bg_fillchar)
          return
        end

        -- Telescope classifies images as binary before reading the preview
        -- buffer. Hand the file to image.nvim explicitly in the preview win.
        vim.api.nvim_win_call(opts.winid, function()
          image.hijack_buffer(filepath, opts.winid, bufnr, {
            namespace = "telescope",
            max_width_window_percentage = 96,
            max_height_window_percentage = 90,
          })
        end)
        telescope_preview_visible = true
      end

      local image_group = vim.api.nvim_create_augroup("telescope.image-preview", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = image_group,
        pattern = "TelescopeFindPre",
        callback = function()
          telescope_active = true
          local ok, image = pcall(require, "image")
          if ok then
            clear_image_scene(image)
          end
        end,
      })
      vim.api.nvim_create_autocmd("WinClosed", {
        group = image_group,
        callback = function()
          if not telescope_active then
            return
          end

          vim.schedule(function()
            local prompt_open = false
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == "TelescopePrompt" then
                prompt_open = true
                break
              end
            end
            if prompt_open then
              return
            end

            telescope_active = false
            telescope_preview_visible = false
            local ok, image = pcall(require, "image")
            if not ok then
              return
            end

            clear_image_scene(image)
            -- Restore images belonging to surviving normal windows. Preview
            -- images are tied to Telescope windows, which are invalid now.
            for _, existing in ipairs(image.get_images()) do
              if
                existing.window
                and vim.api.nvim_win_is_valid(existing.window)
                and (not existing.buffer or vim.api.nvim_win_get_buf(existing.window) == existing.buffer)
              then
                existing:render()
              end
            end
          end)
        end,
      })

      require("telescope").setup({
        defaults = {
          path_display = { "truncate" },
          preview = {
            filetype_hook = function(filepath, bufnr, opts)
              if is_image(filepath) then
                preview_binary(filepath, bufnr, opts)
                return false
              end

              local ok, image = pcall(require, "image")
              if ok and telescope_preview_visible then
                clear_image_scene(image)
                telescope_preview_visible = false
              end
              return true
            end,
            mime_hook = preview_binary,
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.live_grep, {})
      vim.keymap.set("n", "<leader><leader>", builtin.find_files, {})

      require("telescope").load_extension("ui-select")
    end,
  },
}
