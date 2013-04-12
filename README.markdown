# caleb does dotfiles

## dotfiles

Your dotfiles are how you personalize your system. These are mine. The very
prejudiced mix: bash, Ruby, Rails, git, rvm, vim. If you match up along most of
those lines, you may dig my dotfiles.

I was a little tired of having long alias files and everything strewn about
(which is extremely common on other dotfiles projects, too). That led to this
project being much more topic-centric. I realized I could split a lot of things
up into the main areas I used (Ruby, git, system libraries, and so on), so I
structured the project accordingly.

If you're interested in the philosophy behind why projects like these are
awesome, you might want to [read @holman's post on the
subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## install

- `git clone git://github.com/calebthompson/dotfiles ~/.dotfiles`
- `cd ~/.dotfiles`
- `script/bootstrap`

The install rake task will symlink the appropriate files in `.dotfiles` to your
home directory. Everything is configured and tweaked within `~/.dotfiles`,
though.

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles – say, "Java" – you can simply add a `java` directory and put
files in there. Anything with an extension of `.bash` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `rake install`.

If you're into that zsh thing, check out [holman/dotfiles](/holman/dotfiles),
whence my dotfiles began.

## what's inside

A lot of stuff. Seriously, a lot of stuff. Check them out in the file browser
above and see what components may mesh up with you. Fork it, remove what you
don't use, and build on what you do use.

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.bash**: Any files ending in `.bash` get loaded into your
  environment.
- **topic/\*.symlink**: Any files or folders ending in `*.symlink` get symlinked
  into your `$HOME`. This is so you can keep all of those versioned in your
  dotfiles but still keep those autoloaded files in your home directory. These
  get symlinked in when you run `rake install`.
- **topic/\*.completion.sh**: Any files ending in `completion.sh` get loaded
  last so that they get loaded after we set up bash autocomplete functions.

## goodies

Either I or Zach Holman have added some really nice stuff in here. A lot of it
is in `bin/`, so you can look around in there for specifics, but here's a few
gems:

- **git-promote**: Automagically promotes a local topic branch to a remote
  tracking branch of the same name.
- **[spark](https://github.com/holman/spark)**: Generates sparklines for a set
  of data.
- **refold**: Takes text from the command line, std in, or via pipe and wraps it
  to 80 characters. It also preserves the indentation of the first line passed
  to it. Particularly useful in vim (select block of text, call `refold` from
  the vim console). Courtesy [Ram Dobson](https://github.com/fringd).
- **gfl**: Excellent visualization for github repositories. `gfl -a` includes
  all local and remote branches.
- `vim` will remove trailing whitespace (`/\s*$/`) in files every time you write
  them, which is pretty nice.

## add-ons

There are a few things I use to make my life awesome. They're not a required
dependency, but if you install them they'll make your life a bit more like a
bubble bath.

- I have a few [.js](https://github.com/defunkt/dotjs) files stored in
  [dotjs](/calebthompson/dotfiles/tree/master/dotjs/) which, if you have a dotjs
  server running, will make your browsing experience more like mine - for better
  or for worse. If you have cool ideas for these, you should definately [open
  pull-requests](https://github.com/calebthompson/dotfiles/pull-requests)
  for them as I like cool ideas.

## bugs

I want this to work for everyone; that means when you clone it down it should
work for you even though you may not have `rvm` installed, for example. That
said, I do use this as *my* dotfiles, so there's a good chance I may break
something if I forget to make a check for a dependency.

If you're brand-new to the project and run into any blockers, please
[open an issue](https://github.com/calebthompson/dotfiles/issues) on this
repository and I'd love to get it fixed for you!
