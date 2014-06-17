# API docs

We use [vinyl](https://github.com/wearefractal/vinyl) as an abstraction layer of File. So it'll play nicely with [gulpjs](http://gulpjs.com/)

First, open your `gulpfile` and require `sprocket`.

```javascript
var gulp = require('gulp');
var Sprocket = require('sprocket');
```

Then, create a `sprocket` instance:

```javascript
var sprocket = Sprocket();// create with conventions
```

Go [Sprocket](https://github.com/tomchentw/sprocket/blob/master/docs/apis/sprocket.md) docs on how to use `sprocket` instance.
