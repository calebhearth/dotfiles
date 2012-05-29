..................... dotjs ........................

## ~/.js

These are scripts for [dotjs](https://github.com/defunkt/dotjs). They belong in
`~/.js`.

## dotjs, a überhawt self-hosted browser extension shitdinger.

[dotjs](https://github.com/defunkt/dotjs) is a Google Chrome extension that
executes JavaScript files in ~/.js based on their filename.

If you navigate to http://www.google.com/, dotjs will execute
~/.js/google.com.js.

This makes it super easy to spruce up your favorite pages using JavaScript.

Bonus: files in ~/.js have jQuery 1.6.2 loaded, regardless of whether the site
you're hacking uses jQuery.

Double bonus: ~/.js/default.js is loaded on every request, meaning you can stick
plugins or helper functions in it.

GreaseMonkey user scripts are great, but you need to publish them somewhere and
re-publish after making modifications. With dotjs, just add or edit files in
~/.js.
