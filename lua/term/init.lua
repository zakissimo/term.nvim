local M = {}

M.default = {
    spawn = true,
    type = "13sp"
}

M.setup = function(user_opts)
    if user_opts then
        M.default = vim.tbl_deep_extend("force", M.default, user_opts)
    end
end

M._init = function ()
    M.path = vim.fn.expand("%:p:h")
    M.bufnr = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(M.bufnr, "Term")
    if M.default.spawn then
        vim.cmd(M.default.type)
    end
    vim.cmd("buffer" .. M.bufnr)
    _ = vim.fn.termopen("zsh")
end

M.toggle = function ()
    local path = vim.fn.expand("%:p:h")
    if vim.fn.bufexists(M.bufnr) ~= 0 then
        if vim.fn.bufwinnr(M.bufnr) > -1 then
            if M.default.spawn then
                local winid = vim.fn.win_getid(vim.fn.bufwinnr(M.bufnr))
                vim.api.nvim_win_close(winid, true)
            else
                local key = vim.api.nvim_replace_termcodes("<C-6>", true, false, true)
                vim.api.nvim_feedkeys(key, 'n', false)
            end
        else
            if path ~= M.path then
                vim.cmd("bd! " .. M.bufnr)
                M._init()
            else
                if M.default.spawn then
                    vim.cmd(M.default.type)
                end
                vim.cmd("buffer" .. M.bufnr)
            end
        end
    else
        M._init()
    end
end

return M
