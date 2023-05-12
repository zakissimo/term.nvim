local M = {}

local TermAugroup = vim.api.nvim_create_augroup("TermAugroup", { clear = true })

vim.api.nvim_create_autocmd({ "BufLeave" }, {
    group = TermAugroup,
    pattern = "Term",
    callback = function()
        M.term_bufnr = 0
    end,
})

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
    return M.path, M.bufnr
end

M.toggle = function ()
    M.path = vim.fn.expand("%:p:h")
    if vim.fn.bufexists(M.term_bufnr) ~= 0 then
        if vim.fn.bufwinnr(M.term_bufnr) > -1 then
            -- vim.api.nvim_win_close(vim.fn.win_getid(vim.fn.bufwinnr(M.term_bufnr)), true)
            vim.cmd("bd!")
        else
            if M.term_path ~= M.path then
                vim.cmd("bprev")
                M.term_path, M.term_bufnr = M._init()
            else
                if M.default.spawn then
                    vim.cmd(M.default.type)
                end
                vim.cmd("buffer" .. M.term_bufnr)
            end
        end
    else
        M.term_path, M.term_bufnr = M._init()
    end
end

return M
