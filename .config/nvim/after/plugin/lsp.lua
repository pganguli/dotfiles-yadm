local lsp_ok, lsp = pcall(require, 'lsp-zero')
if lsp_ok then
    lsp.preset('recommended')

    lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set('n',          'K',  function() vim.lsp.buf.hover()                   end, opts)
        vim.keymap.set('n',          'gd', function() vim.lsp.buf.definition()              end, opts)
        vim.keymap.set('n',          'gD', function() vim.lsp.buf.declaration()             end, opts)
        vim.keymap.set('n',          'gi', function() vim.lsp.buf.implementation()          end, opts)
        vim.keymap.set('n',          'gy', function() vim.lsp.buf.type_definition()         end, opts)
     -- vim.keymap.set('n',          'gr', function() vim.lsp.buf.references()              end, opts)
        vim.keymap.set('n',          'gr', function() vim.cmd('Telescope lsp_references')   end, opts)
        vim.keymap.set('n',          'gs', function() vim.lsp.buf.signature_help()          end, opts)
        vim.keymap.set('n',          'gn', function() vim.lsp.buf.rename()                  end, opts)
        vim.keymap.set({ 'n', 'x' }, 'gq', function() vim.lsp.buf.format({ async = true })  end, opts)
        vim.keymap.set('n',          'gw', function() vim.lsp.buf.document_symbol()         end, opts)
        vim.keymap.set('n',          'ga', function() vim.lsp.buf.code_action()             end, opts)
        vim.keymap.set('n',          'gl', function() vim.diagnostic.setloclist()           end, opts)
        vim.keymap.set('n',          '[g', function() vim.diagnostic.goto_prev()            end, opts)
        vim.keymap.set('n',          ']g', function() vim.diagnostic.goto_next()            end, opts)


        if client.supports_method('textDocument/documentHighlight') then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                callback = function(args) vim.lsp.buf.document_highlight({ buffer = args.buf }) end
            })
            vim.api.nvim_create_autocmd('CursorMoved', {
                callback = function(args) vim.lsp.buf.clear_references({ buffer = args.buf }) end
            })
        end
    end)

    lsp.setup()

    -- You need to setup `cmp` after lsp-zero
    local cmp_ok, cmp = pcall(require, 'cmp')
    if cmp_ok then
        local cmp_action = lsp.cmp_action()

        cmp.setup({
            -- Make the first item in completion menu always be selected.
            preselect = 'item',
            completion = {
                completeopt = 'menu,menuone,noinsert'
            },

            mapping = {
                -- `Enter` key to select and confirm completion
                ['<CR>'] = cmp.mapping.confirm({select = false}),

                -- Ctrl+Space to trigger completion menu
                ['<C-Space>'] = cmp.mapping.complete(),

                -- Navigate between snippet placeholder
                ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                ['<C-b>'] = cmp_action.luasnip_jump_backward(),

                -- If completion menu is visible: navigate to next item
                -- If cursor is on top of a "snippet trigger": expand item
                -- If cursor can jump to a snippet placeholder: move to item
                -- If cursor is in the middle of a word: display completion menu
                -- Else: act like regular Tab key
                ['<Tab>'] = cmp_action.luasnip_supertab(),
                ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
            }
        })
    end
end
