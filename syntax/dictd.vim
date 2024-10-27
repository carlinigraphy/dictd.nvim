syn match dictdHeader  '\v^\d+ definitions? found'
syn match dictdName    '^From.*$'
syn match dictdWord    '^  \w[^\\]\+'
syn match dictdNumber  '\v^ {5}\d+\.?'
syn match dictdLetter  '\v^ {5,8}\(\w\)'
syn match dictdNote    '^ *Note:'
syn region dictdSee    start='{'  end='}'

hi! def link dictdHeader Type
hi! def link dictdName   Comment
hi! def link dictdWord   Boolean
hi! def link dictdNumber Conditional
hi! def link dictdLetter Conditional
hi! def link dictdSee    Type
hi! def link dictdNote   Comment
