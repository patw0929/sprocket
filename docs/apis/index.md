# API docs

We use [vinyl](https://github.com/wearefractal/vinyl) as an abstraction layer of File. So it'll play nicely with [gulpjs](http://gulpjs.com/)

First, open your `gulpfile` and require `sprocket`.

```javascript
var gulp = require('gulp');
var Sprocket = require('sprocket');
```

Then, create a `Sprocket.Environment` instance:

```javascript
var environment = new Sprocket.Environment();// create with conventions
```

Okay, you're done... not yet.
Go to the [Sprocket.Environment](https://github.com/tomchentw/sprocket/blob/master/docs/apis/environment.md) docs for next step.
