if exists('loaded_delimited') || &cp
  finish
endif

let loaded_delimited = 1
python3 << EOF

import vim

class DelimiterCycler(object):
    """Autoclose delimiters in a smart way.

    When inserting the opening delimiter (e.g., '(','[','{''), the closing
    delimiter is automatically inserted. Pressing the delimiter key for the
    second time undoes the previous action.  Third key press inserts nested
    delimiters, whereas fourth key press returns to the initial state so
    ending the cycle. The cycle is reset when the cursor position changes by
    more than one character inside a row, the row changes or when the character
    under the cursor does not match the opening delimiter.

    """

    def _cycle(self, delim, iterable):
        saved = iterable[:]
        delimpair, rest = iterable[0], iterable[1:]
        while saved:
            win = vim.current.window
            row, col = win.cursor
            self.pos = (row, col)
            yield delimpair

            for element in rest:
                win = vim.current.window
                row, col = win.cursor
                try:
                    char = vim.current.line[col-1]
                except IndexError:
                    # Empty line
                    char = None

                if self.pos in [(row, col), (row, col-1)] and char == delim:
                    self.pos = (row, col)
                    yield element
                else:
                    # Reset the cycler
                    break

    def __init__(self):
        self.pos = (None,None)
        self.delim_yielder = {}
        self.delimiters = {
                  'paren': [
                  "()\<Left>",
                  "\<Esc>lcl",
                  "())\<Left>\<Left>",
                  "\<Esc>hc4l"
                 ],
                  'bracket': [
                  "[]\<Left>",
                  "\<Esc>lcl",
                  "[]]\<Left>\<Left>",
                  "\<Esc>hc4l"
                 ],
                  'brace': [
                  "{}\<Left>",
                  "\<Esc>lcl",
                  "{}}\<Left>\<Left>",
                  "\<Esc>hc4l"
                 ]}

        for key, iterable in self.delimiters.iteritems():
            self.delim_yielder[key] = self._cycle(key, iterable)

    def yield_delimiters(self, delim):
        return next(self.delim_yielder[delim])


delimited_cycler___ = DelimiterCycler()

EOF

function! s:DelimiterCycler(delim)
    python3 vim.command('return "{0}"'.format( delimited_cycler___.yield_delimiters(vim.eval('a:delim'))) )
endfunction

inoremap <expr> { <SID>DelimiterCycler('brace')
inoremap <expr> [ <SID>DelimiterCycler('bracket')
inoremap <expr> ( <SID>DelimiterCycler('paren')
