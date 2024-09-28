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

    cycles = {
      'paren': [
        r"()\<Left>",
        r"\<Esc>lcl",
        r"())\<Left>\<Left>",
        r"\<Esc>hc4l"
      ],
      'bracket': [
        r"[]\<Left>",
        r"\<Esc>lcl",
        r"[]]\<Left>\<Left>",
        r"\<Esc>hc4l"
      ],
      'brace': [
        r"{}\<Left>",
        r"\<Esc>lcl",
        r"{}}\<Left>\<Left>",
        r"\<Esc>hc4l"
    ]}

    delimiters = {
      '(': 'paren',
      '[': 'bracket',
      '{': 'brace'
    }

    def __init__(self):
        self.pos = (None,None)
        self.delim_yielder = {}

        for delimiter, cycle in iter(DelimiterCycler.cycles.items()):
            self.delim_yielder[delimiter] = self._cycle(delimiter, cycle)

    def yield_delimiters(self, delimiter):
        return next(self.delim_yielder[delimiter])

    def _cycle(self, delim, iterable):

        state = iterable[:]
        delimpair, rest = iterable[0], iterable[1:]

        while state:
            win = vim.current.window
            row, col = win.cursor
            self.pos = (row, col)
            yield delimpair

            for element in rest:
                win = vim.current.window
                if self._can_yield(win.cursor, delim):
                    self.pos = win.cursor
                    yield element
                else:
                    # Reset the cycler
                    break

    def _can_yield(self, pos, delim):
        row, col = pos
        try:
            previous = vim.current.line[col-1]
        except IndexError:
            # Empty line
            previous = None
        return self.pos in [(row, col), (row, col-1)] and DelimiterCycler.delimiters.get(previous) == delim


delimited_cycler___ = DelimiterCycler()

EOF

function! s:DelimiterCycler(delim)
    python3 vim.command('return "{0}"'.format( delimited_cycler___.yield_delimiters(vim.eval('a:delim'))))
endfunction

inoremap <expr> { <SID>DelimiterCycler('brace')
inoremap <expr> [ <SID>DelimiterCycler('bracket')
inoremap <expr> ( <SID>DelimiterCycler('paren')
