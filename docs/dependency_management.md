# Dependency Management in sprocketjs

Thanks to the [vinyl](https://github.com/wearefractal/vinyl), it has never been that easy for us to build dependencies based on it. There's no need to use `fs` directly to read your dependencies, and you can also specify your dependencies without their absolute path and extension names. How could sprocketjs do that?

## In depth of dependencies resolution

First, just simply parse the directives from the result of `vinyl.contents.toString()`, then we can build a dependency graph based on the information.

We don't grab dependencies files using `fs` directly, so your `vinyl` file stream should provide sufficient files to complete the graph. The graph wouldn't be complete yet not until the stream ends.

The dependencies are referred by their `keyPath`. Simply put, it's just a `vinyl.relative` path without any extension informations. For example, you grab files using the follwing:

```javascript
gulp.src(['bower_components/**/*.js'])
```

So that all files in the stream would have relative set to:

`<%= bower_component_name %>/<% main_file_name %>.js`

You can deduce that `keyPath` is just:
`<%= bower_component_name %>/<% main_file_name %>`

For example, these are libraries that would be hosted on `bower`:

* [angular of bower](https://github.com/angular/bower-angular) would have `angular/angular.min` as `keyPath`
* [jquery of bower](https://github.com/jquery/jquery) would have `jquery/dist/jquery` as `keyPath`

Notice you could add `.min` with `keyPath`. Sprocketjs will look for the minified version first, resulting better performance.


## Dependency resolution is aware of language extensions

Look at [`examples`](https://github.com/tomchentw/sprocket/tree/master/examples) and you'll understand.


