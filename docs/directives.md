# Sprocket Directives

You may use the following directives inside the asset source files. They are designed to closely resemble the original [Sprockets directives](https://github.com/sstephenson/sprockets#sprockets-directives), with some difference in its actually implementation.

The following examples share the following directory structure:

    .
    ├── a/
    │   └── apple.js
    ├── b/
    │   └── banana.js
    └── c/
        ├── cats/
        │   ├── meow.js
        │   └── pad.js
        ├── color.js
        └── cut.js


With a task like this in the `gulpfile.js`:

```js
gulp.src(['a/*.js', 'b/*.js', 'c/**/*.js'])
    .pipe(env.createJavascriptsStream())
    .pipe(gulp.dest(...));
```

Although the above demonstration uses javascript files, the rule also applies to CSS files and other [language extensions](https://github.com/tomchentw/sprocket/blob/master/docs/language_extensions.md).

In `env.createJavascriptsStream()`, `env.createStylesheetsStream()` and `env.createHtmlsStream()`, the Sprocket directives are processed and the [dependencies are resolved](https://github.com/tomchentw/sprocket/blob/master/docs/dependency_management.md). If a file is being required multiple times, it would be included only once in the final HTML (in development) or asset file (in production.)


## `require` Directive

The directive declares the dependency between the current file and a specific file. The dependencies are referred by their `keyPath`, as explained in the [dependency management documentation](https://github.com/tomchentw/sprocket/blob/master/docs/dependency_management.md).

### Usage

In `apple.js`:

```js
//= require banana.js

/*  c/**/*.js matches the glob "cats" and filename "meow" */
//= require cats/meow.js
```

## `require_self` Directive

This directive inserts the content of the current file. It is useful when we need to declare dependencies after the body of current document.

### Usage

In `apple.js`:

```js
//= require banana.js
//= require_self
//= require cats/meow.js

/*
 * In development mode, banana.js, apple.js and cats/meow.js will be included in HTML in order.
 * In production mode, the javascripts will be concatenated in order.
 */
```

## `require_directory` Directive

The directive pulls in all files under a directory. The child directories are not traversed. The dependencies are specified by relative path, starting from the current file.

### Usage

In `apple.js`:

```js
/* Pulling in c/color.js and c/cut.js */
//= require_directory ../c
```

## `require_tree` Directive

Similar to `require_directory`, but `require_tree` traverses the child directories.

### Usage

In `apple.js`:

```js
/* Pulling in c/color.js, c/cut.js, cats/meow.js and cats/pad.js */
//= require_tree ../c
```


## Pitfalls

### Excessive characters after directives

The current implementation of the directive does not support the existence of other characters in the line that contains the directive.

```js
/* ============ */
/*  Acceptable  */
/* ============ */

//= require banana.js

/*
= require banana.js
*/

/*
 * = require banana.js
 */

#= require banana.js

/* ======================================== */
/*  Not Acceptable and Ignored by Sprocket  */
/* ======================================== */

//= require banana.js // Don't put comments after the path like this!
/*= require banana.js */
```

### `require` specifies its path differently from `require_directory` and `require_tree`

The `require` directive uses `keyPath`. `require_directory` and `require_tree` uses relative paths. This is because `require` matches wildcard and glob patterns, while it does not make sense for the latter two.