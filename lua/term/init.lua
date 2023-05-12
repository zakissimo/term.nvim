local M = {}

M.default = {
    type = "13sp"
}

M.setup = function(user_opts)
    if user_opts then
        M.default = vim.tbl_deep_extend("force", M.default, user_opts)
    end
end

M._init = function ()
    M.path = vim.fn.expand("%:p:h")
    M.buf = vim.api.nvim_create_buf(false, false)
    vim.cmd(M.default.type)
    vim.cmd("buffer" .. M.buf)
    _ = vim.fn.termopen("zsh")
    return M.path, M.buf
end

M.toggle = function ()
    M.path = vim.fn.expand("%:p:h")
    if vim.fn.bufexists(M.term_bufnr) ~= 0 then
        if vim.fn.bufwinnr(M.term_bufnr) > -1 then
            vim.api.nvim_win_close(vim.fn.win_getid(vim.fn.bufwinnr(M.term_bufnr)), true)
        else
            if M.term_path ~= M.path then
                vim.cmd(M.term_bufnr .. "bd!")
                M.term_path, M.term_bufnr = M._init()
            else
                vim.cmd(M.default.type)
                vim.cmd("buffer" .. M.term_bufnr)
            end
        end
    else
        M.term_path, M.term_bufnr = M._init()
    end
end

return M
