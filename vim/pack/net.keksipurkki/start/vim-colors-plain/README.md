# vim-colors-plain

This is a fork of [vim-colors-off][] which is being developed based on my
personal taste.

## Motivation

Minimalistic colorscheme which uses bold to highlight keywords and a
distinguished color for constant literals (string, numbers, JSX tags).

## Screenshots

### Light Variant

![Screenshot](screenshots/ocaml.png)
![Screenshot](screenshots/fzf-files.png)

### Dark Variant

![Screenshot](screenshots/ocaml-dark.png)
![Screenshot](screenshots/fzf-files-dark.png)

## Installation & Usage

With [vim-plug][] you add this to the `.vimrc`:

```
Plug 'andreypopp/vim-colors-plain'
```

Then:

```
set background=light " Set to dark for a dark variant
colorscheme plain
```

## FAQ

- What terminal emulator is shown on the screenshots?

  This is [kitty][]. Fast and highly configurable.

- Is this Vim or Neovim on the screenshots and why?

  This is Neovim.

- What font is being used on the screenshots?

  [Pragmata Pro][] which is not free but worth the money paid. [Iosevka][] is
  another great font I used before which is similar in feel.

[vim-colors-off]: https://github.com/pbrisbin/vim-colors-off
[vim-plug]: https://github.com/junegunn/vim-plug
[kitty]: https://github.com/kovidgoyal/kitty
[Pragmata Pro]: https://www.fsd.it/shop/fonts/pragmatapro/
[Iosevka]: https://github.com/be5invis/Iosevka
