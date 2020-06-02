# BuckleScript Monorepo example

This small example, boostrapped from the `react-hooks` theme (`bsb -init .
-theme react-hooks`), showcases a simple monorepo setup for BuckleScript
projects.

It strives to be as simple as possible and makes the following design choices:

- No complicated monorepo tools
  - yarn supports `link:/path/to/sub/package` which works well enough for the
    purposes of this demonstration (and arguably most projects).
- No reliance on `bsb -w`
  - BuckleScript's watch mode isn't aware of linked dependencies
  - Watch mode is implemented by reading the source directories BuckleScript is
    aware of (just like `bsb` does) and passing them to
    [entr](http://eradman.com/entrproject/), a simple utility to run commands
    when files change.
- No reliance on `bsb`
  - `bsb` is written in JavaScript, and I've got better things to do than to
    wait for Node.js startup. This example calls the native `bsb.exe` binary
    directly.

## Package structure

The file structure is the same as the react-hooks theme, with the exception
that one of the subdirectories in `src` (`FetchedDogPictures`) is now its own
library. The `bsconfig.json` file is changed accordingly:

```diff
  "sources": {
    "dir": "src",
-    "subdirs": true
+    "subdirs": [
+      "ReasonUsingJSUsingReason",
+      "ReducerFromReactJSDocs",
+      "BlinkingGreeting"
+    ]
  },
```

Additionally, we place a `bsconfig.json` inside the `src/FetchedDogPictures`
folder, add a name to the library (`fetched-dog-pictures`), and:

1. Add `"fetched-dog-pictures"` as dependency in `package.json`:

```diff
  "dependencies": {
    "react": "^16.13.1",
    "react-dom": "^16.13.1",
-    "reason-react": ">=0.8.0"
+    "reason-react": ">=0.8.0",
+    "fetched-dog-pictures": "link:./src/FetchedDogPictures"
```

2. Add `"fetched-dog-pictures"` as a dependency in the root `bsconfig.json`:

```diff
  "bs-dependencies": [
    "reason-react",
+    "fetched-dog-pictures"
  ],
```

## Running the example

_Note_: this repository is set up to consume `bs-platform` using
[Nix](https://nixos.org/nix/) simply because that's the package manager I use.
It should work if you're consuming `bs-platform` from NPM, as long as the
references to `$BSB_PATH` and `./node_modules/.bin/bsb.exe` are replaced
appropriately.

To run the example, run:

```sh
$ make
```

This will start a watcher process and serve a bundle via `webpack-dev-server`.

## License & Copyright

