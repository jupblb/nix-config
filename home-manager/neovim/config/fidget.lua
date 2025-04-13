local fidget = require('fidget')
local progress = require('fidget.progress')

fidget.setup({
    notification = {
        override_vim_notify = true,
    },
})

-- https://codecompanion.olimorris.dev/usage/ui.html#fidget-nvim-progress-by-jessevdp

local code_companion_autocmd_group =
    vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})
local request_id_to_handler = {}

local store_progress_handler = function(id, handler)
    request_id_to_handler[id] = handler
end

local pop_progress_handle = function(id)
    local handle = request_id_to_handler[id]
    request_id_to_handler[id] = nil
    return handle
end

local llm_role_title = function(adapter)
    local parts = {}
    table.insert(parts, adapter.formatted_name)
    if adapter.model and adapter.model ~= "" then
        table.insert(parts, "(" .. adapter.model .. ")")
    end
    return table.concat(parts, " ")
end

local create_progress_handler = function(request)
    return progress.handle.create({
        title = " Requesting assistance (" .. request.data.strategy .. ")",
        message = "In progress...",
        lsp_client = {
            name = llm_role_title(request.data.adapter),
        },
    })
end

local report_exit_status = function(handler, request)
    if request.data.status == "success" then
        handler.message = "Completed"
    elseif request.data.status == "error" then
        handler.message = "  Error"
    else
        handler.message = "  Cancelled"
    end
end

vim.api.nvim_create_autocmd({ "User" }, {
    pattern  = "CodeCompanionRequestStarted",
    group    = code_companion_autocmd_group,
    callback = function(request)
        local handler = create_progress_handler(request)
        store_progress_handler(request.data.id, handler)
    end,
})

vim.api.nvim_create_autocmd({ "User" }, {
    pattern  = "CodeCompanionRequestFinished",
    group    = code_companion_autocmd_group,
    callback = function(request)
        local handler = pop_progress_handle(request.data.id)
        if handler then
            report_exit_status(handler, request)
            handler:finish()
        end
    end,
})
