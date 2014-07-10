# sprocket [![Travis CI][travis-image]][travis-url] [![Quality][codeclimate-image]][codeclimate-url] [![Coverage][coveralls-image]][coveralls-url] [![Dependencies][gemnasium-image]][gemnasium-url]
> Opinioned, Convention over Configuration asset build tool for any javascript frameworks.

[![Version][npm-image]][npm-url]

It's designed for ExpressJS websites, SailsJS websites and even pure-static websites. Pure jQuery site? Or fancy AngularJS Apps? No problem!

The only required dependency is [gulpjs](http://gulpjs.com/). We use `gulpfile` to build your workflow.


## Quick Overview

**4 Steps** to bring all goodies to your front end development!

### 1. With your `assets` files:

![2014-06-27 11 58 18](https://cloud.githubusercontent.com/assets/922234/3414301/ffd91a9c-fe13-11e3-9132-cf6d08db0563.png)

**Notice** the project structure in the left

* [Supported sprocket directives](https://github.com/tomchentw/sprocket/blob/master/docs/directives.md)

### 2. Specify the dependency in `admin.html.ejs` (or `index.jade`):

![2014-06-27 12 36 58](https://cloud.githubusercontent.com/assets/922234/3401420/3aa3df1e-fd50-11e3-9edf-97f853a22d23.png)

### 3. Running server under [development mode](https://github.com/tomchentw/sprocket/tree/master/examples#under-development):

![2014-06-27 11 56 47](https://cloud.githubusercontent.com/assets/922234/3414300/ffb905ea-fe13-11e3-885b-22f3876ffe0e.png)

* [Resolving dependencies](https://github.com/tomchentw/sprocket/blob/master/docs/dependency_management.md)
* Compiling [languages extensions](https://github.com/tomchentw/sprocket/blob/master/docs/language_extensions.md)
* Running linting tools

### 4. [`npm start`](https://github.com/tomchentw/sprocket/tree/master/examples#in-production) in production:

![2014-06-27 12 34 11](https://cloud.githubusercontent.com/assets/922234/3401425/3de9f6e0-fd50-11e3-8452-f6661c556eed.png)

* [Minifying](https://github.com/tomchentw/sprocket/blob/master/docs/seamless_integration.md#minification)
* [Concating](https://github.com/tomchentw/sprocket/blob/master/docs/seamless_integration.md#concation)
* [Reversioning](https://github.com/tomchentw/sprocket/blob/master/docs/seamless_integration.md#versioning-and-renaming)

**See** the [example project](https://github.com/tomchentw/sprocket/blob/master/examples) for these steps.

### Convention over Configuration Wins


## Usage


It's simple. Go to the [APIs](https://github.com/tomchentw/sprocket/blob/master/docs/apis/index.md) page and walk through it.


## Docs

### [Incentive](https://github.com/tomchentw/sprocket/blob/master/docs/incentive.md)

### [APIs](https://github.com/tomchentw/sprocket/blob/master/docs/apis/index.md)


## Information

<table>
<tr> 
<td>Package</td><td>sprocket</td>
</tr>
<tr>
<td>Description</td>
<td>Opinioned, Convention over Configuration asset build tool for any javascript frameworks.</td>
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
