local M = {}

M._init = function ()
    M.path = vim.fn.expand("%:p:h")
    M.buf = vim.api.nvim_create_buf({}, {})
    vim.cmd("13sp")
    vim.cmd("buffer" .. M.buf)
    _ = vim.fn.termopen("zsh")
    vim.cmd("startinsert")
    return M.path, M.buf
end

M.toggle = function ()
    M.path = vim.fn.expand("%:p:h")
    if vim.fn.bufexists(M.term_bufnr) ~= 0 then
        if vim.fn.bufwinnr(M.term_bufnr) > -1 then
            vim.api.nvim_win_close(vim.fn.win_getid(vim.fn.bufwinnr(M.term_bufnr)), "force")
        else
            if M.term_path ~= M.path then
                vim.cmd(M.term_bufnr .. "bd!")
                M.term_path, M.term_bufnr = M._init()
            else
                vim.cmd("13sp")
                vim.cmd("buffer" .. M.term_bufnr)
                vim.cmd("startinsert")
            end
        end
    else
        M.term_path, M.term_bufnr = M._init()
    end
end

return M
