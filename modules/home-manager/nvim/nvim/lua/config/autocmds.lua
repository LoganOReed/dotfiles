-- set conceal level for norg specifically
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = {"*.norg"},
  command = "set conceallevel=2",
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = {"*.norg"},
  command = "set concealcursor=n",
})
