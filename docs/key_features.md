# Key Features

## (Lazy Loaded) Extension Languages Support

Support `.coffee`, `.sass`, `.less`, `.ls`, `.jade` ... out of the box.
Each extension languages are lazy loaded to reduce the commonjs `require` performance hit to minimal.

## Templating Languages Applys to Any Contents

Support `.ejs` applied on `.html`, `.js`, `.css`, and even `.coffee`.

## Dependency Management for Assets

Use `require`, `include` directives in comments block of your assets to declare its dependencies.

## Assets Dependency Resolution for HTMLs

Automatically resolve dependencies of an asset and its dependencies of dependencies ... as a graph.
Then reduce it to a normal list of `script` or `style` tags.

## Extension Languages Dependencies Support

You can declare dependencies on `.ls`, `.sass` files as well.

## BuiltIn Linting Tools

Each compiled `.js`, `.css` and `.html` files are passed to their linters. Minified files like `.min.js` and `.min.css` will be ignored.

## Compatible with LiveReload

Works well with `gulp.watch` and `gulp-livereload` plugin.

## Compile/Lint only on Content Changes

During the LiveReload phase, contents passed in to Sprocket will be cached and just run compile/lint on changes ones. This make changes during development really fast.

## BuiltIn Minification Tools

All assets and `.html` files are minified when running under production environment (NODE_ENV=production).

## Concat Assets for HTMLs in Production

All assets (after minification) are concatted to one files when running under production environment.

## BuiltIn Assets Renaming

Postfixed hash digest to filename after assets concattion.
The file `app-1696ce2424a5aed2c810774ec5e0fcb4.min.js` would never expires.

## Compatible with gulpjs

We create streams tha handle `vinyl` objects and many `gulp-plugins` for extension languages so gulp is the best mate.
Or you'd like to write a Grunt plugin to support that, too?

## Build with Full Streaming Support

We just use the files you've passed in to the streams. In Sprocket we never use `fs` APIs directly to touch your file systems.

## Compatible with Sass/LESS @import Statement

We wanna make your Sass and LESS `@import` statement happy. The load path of `@import` statement is from the following:

* all passed in directories
* all passed in base paths of files

See the document to know how base path works.

## Convention over Configuration
