# sprocket [![Travis CI][travis-image]][travis-url] [![Quality][codeclimate-image]][codeclimate-url] [![Coverage][coveralls-image]][coveralls-url] [![Dependencies][gemnasium-image]][gemnasium-url]
> Opinioned asset build tools for any javascript frameworks. Inspired from ruby Sprocket and gulpjs.

[![Version][npm-image]][npm-url]

It's designed for ExpressJS websites, SailsJS websites and even pure-static websites. Pure jQuery site? Or fancy AngularJS Apps? No problem!

The only required dependency is [gulpjs](http://gulpjs.com/). We use `gulpfile` to build your workflow.


## Quick Overview

### With your `javascripts` like this:

**Notice**: project structure in the left

![2014-06-17 11 09 53](https://cloud.githubusercontent.com/assets/922234/3295893/f1f9da46-f5cc-11e3-99d3-79f5f2be5176.png)

### And include it in your `index.jade` (or `admin.html.ejs`): 

![2014-06-24 6 28 41](https://cloud.githubusercontent.com/assets/922234/3370075/602d4332-fb8a-11e3-9365-a380e198173b.png)

### Running your [`gulpfile.js` with `server` task](#under-development) and open the browser:

![2014-06-17 11 14 11](https://cloud.githubusercontent.com/assets/922234/3295916/8ce5484c-f5cd-11e3-98d9-9c9535c1c0d6.png)

### [In production](#in-production), looks like this:

![2014-06-17 11 16 44](https://cloud.githubusercontent.com/assets/922234/3295928/d6ae0eaa-f5cd-11e3-8f28-5e39dcdb90de.png)

### That's Awesome!


## Usage

It's simple and works just like rails does. Typical steps are:

1. create a [`application.js`](https://github.com/tomchentw/sprocket/blob/master/examples/client/javascripts/application.js), declare dependencies to mark it as an entry point.

2. use [`javascriptIncludeTag`](https://github.com/tomchentw/sprocket/blob/master/docs/apis/sprocket.md#javascriptincludetagfilename--javascript_include_tagfilename) inside [`index.jade`](https://github.com/tomchentw/sprocket/blob/master/examples/client/views/index.jade#L19) to include `application.js` as script tag(s).

3. create a [`gulpfile.js`](https://github.com/tomchentw/sprocket/blob/master/examples/gulpfile.js#L6) to initialize a [`sprocket`](https://github.com/tomchentw/sprocket/blob/master/docs/apis/index.md) instance and [compile assets](https://github.com/tomchentw/sprocket/blob/master/docs/apis/sprocket.md#sprocketcreatejavascriptsstream).

4. output the compiled assets and htmls to a folder and serve them in [`index.js`](https://github.com/tomchentw/sprocket/blob/master/examples/index.js#L14)


## Example

See the [`examples`](https://github.com/tomchentw/sprocket/tree/master/examples) folder and a complete [`gulpfile.js`](https://github.com/tomchentw/sprocket/blob/master/examples/gulpfile.js) for the above example.

### Under Development

```shell
cd examples
npm install
gulp server
```
It will start a connect server on port 5000, as well as a livereload server on port 35729, automatically watch changes and recompile the aseets. Look at the compiled [`index.html`](https://github.com/tomchentw/sprocket/blob/master/examples/client/views/index.jade) to see how `javascript_include_tag` get transformed into the `<script ...>` tags.

### In Production

```shell
export NODE_ENV=production
npm start
```

It will compile and concat javascripts and stylesheets into one files with versioning support. You need to just run once `gulp html` before releasing your new version.


## Information

<table>
<tr> 
<td>Package</td><td>sprocket</td>
</tr>
<tr>
<td>Description</td>
<td>Opinioned asset build tools for any javascript frameworks. Inspired from ruby Sprocket and gulpjs.</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.10</td>
</tr>
<tr>
<td>Gulp Version</td>
<td>>= 3.5.0</td>
</tr>
</table>


## Docs

### [Incentive](https://github.com/tomchentw/sprocket/blob/master/docs/incentive.md)

### [API](https://github.com/tomchentw/sprocket/blob/master/docs/apis/index.md)


## Contributing

### [Help Wanted](https://github.com/tomchentw/sprocket/issues?labels=help+wanted&page=1&state=open)


[![devDependency Status][david-dm-image]][david-dm-url]

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[npm-image]: https://img.shields.io/npm/v/sprocket.svg
[npm-url]: https://www.npmjs.org/package/sprocket

[travis-image]: https://travis-ci.org/tomchentw/sprocket.svg?branch=master
[travis-url]: https://travis-ci.org/tomchentw/sprocket
[codeclimate-image]: https://img.shields.io/codeclimate/github/tomchentw/sprocket.svg
[codeclimate-url]: https://codeclimate.com/github/tomchentw/sprocket
[coveralls-image]: https://img.shields.io/coveralls/tomchentw/sprocket.svg
[coveralls-url]: https://coveralls.io/r/tomchentw/sprocket
[gemnasium-image]: https://gemnasium.com/tomchentw/sprocket.svg
[gemnasium-url]: https://gemnasium.com/tomchentw/sprocket
[david-dm-image]: https://david-dm.org/tomchentw/sprocket/dev-status.svg?theme=shields.io
[david-dm-url]: https://david-dm.org/tomchentw/sprocket#info=devDependencies
