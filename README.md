dotfiles
========

These are the dotfiles of the Starship Caleb Hearth. Its continuing mission: to explore strange new software, to seek out new configurations and new customizations, to boldly go where hopefully lots of folks have gone before.

These dotfiles use [GNU Stow] combined with a Makefile to manage symlinks and to combine configurations from various packages.

[GNU Stow]: https://alex.pearwin.com/2016/02/managing-dotfiles-with-stow/

Stow packages are directories that mirror the home directory structure. Their contents are symlinked into `$HOME` by stow via `make`.

At least the `base` package is required, and other packages can be added as desired by adding them to the `included` variable in Makefile. `bin` is not intended as a package, it just contains some tools for managing the dotfiles themselves.


Special files
-------------

`.stow-global-ignore` specified file patterns relative to package roots that `stow` should ignore when linking packages.

Certain of these files are further handled by Makefile.

### Brewfile and Gemfile

Each package can include a `Brewfile` with Homebrew dependencies. The Makefile concatenates all of them into a single generated Brewfile at `$XDG_DATA_HOME/dotfiles/Brewfile` and runs `brew bundle install` against it.

Similarly, all included packages' `Gemfile`s will be combined into `$XDG_DATA_HOME/dotfiles/Gemfile` and `bundle install` will be run against it. This is useful for packages that install Ruby gems, but I've been moving away from this pattern in favor of setting up `.config/mise/config.<package>.toml` files that are able to manage gems and other dependencies (bun, node, pip, swift, etc.) in a more flexible way. Those can be activated by included them in `$MISE_ENV`, which is easier to adjust on a per-project basis and allows for version differences.

We could do this by creating `<package>/.local/share/dotfiles/Brewfile.d/<package>` to simplify the Makefile step (and the same for Gemfile), but the ergonomics are much nicer with `<package>/{Brewfile,Gemfile}` and we'd still need the combination step.

## Rectangle

Because Rectangle, a tiling window tool, doesn't follow symlinks for its preference file, it is ignored by stow and hard-linked by Makefile.

### Pinned Homebrew formulae

Packages can pin Homebrew formulae to specific versions via a local `caleb/pinned` tap. See our [homebrew-pinned tap's README](base/.local/share/homebrew-pinned/README.md) for details.

