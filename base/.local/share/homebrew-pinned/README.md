Pinned Homebrew formulae
========================

Homebrew has [no built-in version locking]. To pin a formula to a specific version, place a Homebrew formula `.rb` file at `<package>/.local/share/homebrew-pinned/Formula/<name>.rb` and include it in `<package>/Brewfile` as `brew "caleb/pinned/<name>"`.

[no built-in version locking]: https://emmer.dev/blog/installing-old-homebrew-formula-versions/

Stow creates symlinks for these into a tap directory and Makefile creates a hard link into Homebrew's taps directory so that they can be installed. They're hard links instead of symlinks because Homebrew doesn't follow symlinks for formulae. The intermediate step is necessary because stow is relative to $HOME, and Homebrew's directory is outside of that.

The package's Brewfile references the pinned formula:

```
<package>/Brewfile:
  tap "caleb/pinned"
  brew "caleb/pinned/<name>"
```

If you're annoyed by all of this too, complain to Homebrew about it as they've removed `Brewfile.lock.json` (which was never a lock) and `brew switch` (which allowed switching between installed version). `brew pin` would work to prevent updates, but wouldn't support installing the specific version in the first place.

To pin a new formula
--------------------

1. Find the formula for the version you want. If it's currently installed, check `$(brew --prefix)/Cellar/<name>/<version>/.brew/`.
2. Copy it into your package at `.local/share/homebrew-pinned/Formula/<name>.rb`.
3. Add a `Brewfile` with `tap "caleb/pinned"` and `brew "caleb/pinned/<name>"`.
4. Add the package to `included` in the Makefile.
5. Run `make stow` then `make brew_install` (may need to clean up `Brewfile.d` artifacts first).
