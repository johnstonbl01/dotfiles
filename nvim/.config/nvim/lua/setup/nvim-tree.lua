local tree = require("nvim-tree")

tree.setup({
    auto_reload_on_write = true,
    create_in_closed_folder = false,
    disable_netrw = true,
    hijack_netrw = true,
    open_on_tab = false,
    hijack_cursor = false,
    hijack_directories = {enable = true, auto_open = true},
    diagnostics = {
        enable = false,
        icons = {hint = "", info = "", warning = "", error = ""}
    },
    git = {enable = true, ignore = true, timeout = 400},
    update_focused_file = {enable = true, update_cwd = false, ignore_list = {}},
    system_open = {cmd = nil, args = {}},
    filters = {dotfiles = false, custom = {".git"}},
    actions = {
        change_dir = {enable = true, global = false, restrict_above_cwd = true},
        open_file = {resize_window = false, quit_on_open = true},
        remove_file = {close_window = true}
    },
    view = {width = 30, side = "left"},
    renderer = {
        root_folder_label = false,
        indent_markers = {enable = true},
        highlight_git = true,
        icons = {
            glyphs = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌"
                },
                folder = {
                    arrow_open = "",
                    arrow_closed = "",
                    default = " ",
                    open = " ",
                    empty = " ",
                    empty_open = " ",
                    symlink = " ",
                    symlink_open = " "
                }
            }
        }
    }
})
