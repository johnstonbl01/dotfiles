local lsp = require('languages.lsp')
local M = {}

M.lsp = {
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
                -- Example k8s schema
                -- ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml"
            }
        }
    },
    capabilities = lsp.capabilities,
    on_attach = lsp.on_attach,
}

return M