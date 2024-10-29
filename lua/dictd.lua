local function lookup(skip_input)
   local term = vim.fn.expand('<cword>')

   if not skip_input then
      term = vim.fn.input({
         prompt = 'word> ',
         default = term,
      })
   end

   if term == '' then
      return
   end

   local win_height = vim.api.nvim_win_get_height(0) local win_width  = vim.api.nvim_win_get_width(0)

   local f = io.popen('dict "'..term..'" 2>/dev/null')
   if not f then return end

   local lines = {}
   for line in f:lines() do
      table.insert(lines, line)
   end
   f:close()

   if #lines == 0 then
      return print('No entry found: '..term)
   end

   local buf_id = vim.api.nvim_create_buf(false, true)
   vim.api.nvim_buf_set_lines(buf_id, 0, 0, false, lines)

   local float_width  = 78
   local float_height = math.min(#lines+1, win_height-1)
   local win_id = vim.api.nvim_open_win(buf_id, true, {
      relative = 'win',
      col      = math.floor((win_width - float_width) / 2),
      row      = 0,
      width    = float_width,
      height   = float_height,
      style    = 'minimal',
   border   = {
         {" ", ""}, -- top left
         { "", ""}, -- top
         {" ", ""}, -- top right
         {" ", ""}, -- right
         {" ", ""}, -- bottom right
         { "", ""}, -- bottom
         {" ", ""}, -- bottom left
         {" ", ""}, -- left
      },
   })

   -- Matches below largely from @koonix/vimdict.
   vim.bo.filetype = 'dictd'
   return win_id
end


return {
   ---@param opts {key: string, keywordprg_filetypes: string[]}
   setup = function(opts)
      vim.keymap.set('n', opts.key, lookup)

      -- TODO: doesn't work yet. Gotta figure out setting `keywordprg`.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = opts.keywordprg_filetypes,
        callback = function(_)
           vim.bo.keywordprg = [[:lua require('dictd').lookup(true)]]
        end
      })
   end,

   ---@param skip_input boolean
   lookup = function(skip_input)
      lookup(skip_input)
   end,
}
