# Class `Sprocket.Environment`

Create instance using new keyword like [this](https://github.com/tomchentw/sprocket/blob/master/docs/apis/index.md).

## Prototype methods


### environment.createJavascriptsStream()

Equivalent of `sprocket._createStream('application/javascript')`, see below.


### environment.createStylesheetsStream()

Equivalent of `sprocket._createStream('text/css')`, see below.


### environment.createHtmlsStream()

Equivalent of `sprocket._createStream('text/html')`, see below.


### environment._createStream(mimeType)

The core of `sprocket`. Return a stream that would resolve dependencies, compile, lint and concat assets for you.

**Notice:** The dependencies resolution of directives **only limits** to the files you're passing in. i.e, sprocket DON'T use `fs` to read/find files. You have to `glob` in all the assets that would later be required.

```javascript
gulp.task('js', function(){
  return gulp.src([
    'client/javascripts/**/*.ls',
    'client/javascripts/**/*.js',
    'bower_components/**/*.js'
  ]).pipe(sprocket.createJavascriptsStream()
  ).pipe(gulp.dest('tmp/public'));
});
```

**Notice:** Sprocket directives are using relative path.

Say, you have `bower_components/jquery/dist/jquery.js` installded and use the above `js` task.
In your `application.js` header:

```javascript
//= require jquery/dist/jquery
```

If you want to require the precompiled assets located in `bower_components/angular/angular.min.js`:

```javascript
/*
 *= require angular/angular.min
 */
```

Please notice they're **different**. In the former one, sprocket will minify `jquery`. In contrast, sprocket will use minified version of `angularjs` and won't minify agian.

It's recommended to require minified libraries directly since it could save your time and get a better code for libraries who use *Google Closure Compiler* like `angularjs`.


#### mimeType
Type: `String`

One of `'application/javascript'`, `'text/css'` and `'text/html'`.


### environment.viewLocals

This would return a [view local](#view-local) that can serve as `locals` when building htmls or `ejs` templates.

The returned object would prototypically inherit from `Sprocket.viewLocals` object.


### view local

Object returned by [environment.createViewHelpers(options)](#environmentviewLocals). You can freely extend/modify it since these functions are bounded.

#### javascriptIncludeTag(filename, options) / javascript_include_tag(filename, options)
Type: `Function`

Yes, *underscored* versions are also provided.

It would create a (list of) `<script></script>` tag(s) so that the generated html could references to the right assets.

```jade
html
  head
    != javascriptIncludeTag("application")
```

##### filename
Type: `String`

**Notice:** Sprocket directives are using relative path.  

It should relative to your globbing paths.


##### options
Type: `Object`

##### options.assetsPath
Type: `String`
Default: `/`

Prepend to the path of assets when generating `<script></script>` and `<link>` tags.

##### options.indent
Type: `String`
Default: `    `(4 spaces)

Prepend to the tags so that it would indent correctly after comiplation.
Default value is four spaces since we use 2 space for indent and `html->(head/body)->tag` has 2 level of indent (2x2 = 4).


#### stylesheetLinkTag(filename, options) / stylesheet_link_tag(filename, options)
Type: `Function`

It would create a (list of) `<link>` tag(s) so that the generated html could references to the right assets.

##### filename
Type: `String`

**Notice:** Sprocket directives are using relative path.  

It should relative to your globbing paths.

```jade
html
  head
    != stylesheet_link_tag("application")
```

##### options
See [options]() above.
