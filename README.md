# MatchOpen

A simple [Vim](http://www.vim.org/) plugin to highlight the last opened, 
but unclosed delimiter. Based on Vim's own `matchparen.vim`.

Example:

    synIDattr(synID(line("."), col("."), 0), "name") 
                   ^            ^
                   |            if cursor is here
                   this is highlighted

Note: This is a preliminary version for testing. Only works for regular
parenthesis and has no documentation.

Warning: Like `matchparen.vim`, this installs an autocommand run whenever
the cursor is moved. It may be too slow if you have large folds collapsed
in the current window, or very long lines. It can be turned it off with 
`:NoMatchLastOpen`, and on again with `:DoMatchLastOpen`.
