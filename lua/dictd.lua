local function lookup()
   local term = vim.fn.input({
      prompt = 'word> ',
      default = vim.fn.expand('<cword>')
   })

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
   setup = function(bind)
      bind = bind or '<leader>df'
      vim.keymap.set('n', bind, lookup)
   end
}
