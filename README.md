# sprocket [![Travis CI][travis-image]][travis-url] [![Quality][codeclimate-image]][codeclimate-url] [![Coverage][coveralls-image]][coveralls-url] [![Dependencies][gemnasium-image]][gemnasium-url]
> Opinioned asset build tools for any javascript frameworks. Inspired from ruby Sprocket and gulpjs.

[![Version][npm-image]][npm-url]

It's designed for ExpressJS websites, SailsJS websites and even pure-static websites. Pure jQuery site? Or fancy AngularJS Apps? No problem!

The only required dependency is [gulpjs](http://gulpjs.com/). We use `gulpfile` to build your workflow.


## Quick Overview

**4 Steps** to bring all goodies to your front end development!

### 1. With your `assets` files:

![2014-06-27 12 35 25](https://cloud.githubusercontent.com/assets/922234/3401418/39491f76-fd50-11e3-88ef-68a54f7a508e.png)

**Notice** the project structure in the left

### 2. Specify the dependency in `admin.html.ejs` (or `index.jade`): 

![2014-06-27 12 36 58](https://cloud.githubusercontent.com/assets/922234/3401420/3aa3df1e-fd50-11e3-9edf-97f853a22d23.png)

### 3. Running server under [development mode](#under-development):

![2014-06-27 12 33 04](https://cloud.githubusercontent.com/assets/922234/3401423/3c719200-fd50-11e3-96b8-52af187f7006.png)

* Resolving dependencies
* Compiling languages extensions
* Running linting tools

### 4. [`npm start`](#in-production) on production:

![2014-06-27 12 34 11](https://cloud.githubusercontent.com/assets/922234/3401425/3de9f6e0-fd50-11e3-8452-f6661c556eed.png)

* Minifying
* Concating
* Reversioning

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
