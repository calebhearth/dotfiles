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

Homebrew has [no built-in version locking]. To pin a formula to a specific version, put the formula's `.rb` file at `<package>/Formula/<name>.rb` and reference it from the package's `Brewfile`:

[no built-in version locking]: https://emmer.dev/blog/installing-old-homebrew-formula-versions/

```
tap "caleb/pinned"
brew "caleb/pinned/<name>"
```

Stow ignores `Formula/`. The `pinned_tap` target in Makefile hard-links every included package's formulae into the `caleb/pinned` tap under `$(brew --repository)/Library/Taps/` before `brew bundle` runs. They're hard links instead of symlinks because Homebrew doesn't follow symlinks for formulae. Git rewrites files on checkout, which breaks hard links, so `make` relinks them on every run.


If you're annoyed by all of this too, complain to Homebrew about it as they've removed `Brewfile.lock.json` (which was never a lock) and `brew switch` (which allowed switching between installed version). `brew pin` would work to prevent updates, but wouldn't support installing the specific version in the first place.

To pin a new formula:

1. Find the formula for the version you want. If it's currently installed, check `$(brew --prefix)/Cellar/<name>/<version>/.brew/`.
2. Copy it into your package at `Formula/<name>.rb`.
3. Add a `Brewfile` with `tap "caleb/pinned"` and `brew "caleb/pinned/<name>"`.
4. Add the package to `included` in the Makefile.
5. Run `make brew_install` (may need to clean up `Brewfile.d` artifacts first).

