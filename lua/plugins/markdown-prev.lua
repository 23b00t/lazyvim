return {
  "iamcco/markdown-preview.nvim",
  opts = function()
    vim.cmd([[
      function! OpenPreviewInKittyAwrit(url)
        call system('kitty @ launch awrit ' . shellescape(a:url))
      endfunction
      let g:mkdp_browserfunc = 'OpenPreviewInKittyAwrit'
    ]])
  end,
}
