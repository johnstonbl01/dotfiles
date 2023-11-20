local cmp = require("cmp")
local luasnip = require('luasnip')

cmp.setup {
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, { name = 'luasnip' }, { name = 'nvim_diagnostic' }
  }, { { name = 'buffer' }, { name = 'nvim_lua' }, { name = 'path' } })
}

cmp.setup.cmdline("/", { sources = { { name = 'buffer' } } })

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})

-- local lspkind = require("lspkind")
-- local api = vim.api
-- local fn = vim.fn
--
-- local has_words_before = function()
--     local line, col = unpack(api.nvim_win_get_cursor(0))
--     return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end
--
-- local feedkey = function(key, mode)
--     api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode, true)
-- end
--
-- cmp.setup(
--     {
--         snippet = {
--             expand = function(args)
--                 fn["vsnip#anonymous"](args.body)
--             end
--         },
--         mapping = {
--             ["<C-b>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
--             ["<C-e>"] = cmp.mapping(
--                 {
--                     i = cmp.mapping.abort(),
--                     c = cmp.mapping.close()
--                 }
--             ),
--             ["<CR>"] = cmp.mapping.confirm(
--                 {
--                     behavior = cmp.ConfirmBehavior.Replace,
--                     select = true
--                 }
--             ),
--             ["<Tab>"] = cmp.mapping(
--                 function(fallback)
--                     if cmp.visible() then
--                         cmp.select_next_item()
--                     elseif fn["vsnip#available"](1) == 1 then
--                         feedkey("<Plug>(vsnip-expand-or-jump)", "")
--                     elseif has_words_before() then
--                         cmp.complete()
--                     else
--                         fallback()
--                     end
--                 end,
--                 {"i", "s"}
--             ),
--             ["<S-Tab>"] = cmp.mapping(
--                 function()
--                     if cmp.visible() then
--                         cmp.select_prev_item()
--                     elseif fn["vsnip#jumpable"](-1) == 1 then
--                         feedkey("<Plug>(vsnip-jump-prev)", "")
--                     end
--                 end,
--                 {"i", "s"}
--             )
--         },
--         sources = cmp.config.sources(
--             {
--                 {name = "nvim_lua"},
--                 {name = "nvim_lsp"},
--                 {name = "path"},
--                 {name = "vsnip"},
--                 {name = "nvim_diagnostic"}
--             },
--             {
--                 {name = "buffer"}
--             }
--         ),
--
--     }
-- )
--
-- cmp.setup.cmdline(
--     "/",
--     {
--         sources = {
--             {name = "buffer"}
--         }
--     }
-- )
--
-- cmp.setup.cmdline(
--     ":",
--     {
--         sources = cmp.config.sources(
--             {
--                 {name = "path"}
--             },
--             {
--                 {name = "cmdline"}
--             }
--         )
--     }
-- )
--
