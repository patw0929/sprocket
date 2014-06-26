# Example

## Under Development

```shell
cd examples
npm install
gulp server
```
It will start a connect server on port 5000, as well as a livereload server on port 35729, automatically watch changes and recompile the aseets. Look at the compiled [`index.html`](https://github.com/tomchentw/sprocket/blob/master/examples/client/views/index.jade) to see how `javascript_include_tag` get transformed into the `<script ...>` tags.

## In Production

```shell
export NODE_ENV=production
npm start
```

It will compile and concat javascripts and stylesheets into one files with versioning support. You need to just run once `gulp html` before releasing your new version.

