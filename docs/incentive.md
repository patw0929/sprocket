# Since there're so [many good tools](https://github.com/tomchentw/sprocket/blob/master/docs/another_tools.md)

## Why you create sprocketjs?

They have common characteristics in these libraries, which are

1. dependency management
2. resolving files from different load path 
3. convert/compile files from language extensions
4. command line interfaces
5. serve the compiled static assets

Many of these libraries try to rolling their own implementation, while in contrast, I would prefer not to reinvent the wheels. And I later found that [gulpjs](http://gulpjs.com/) do a good job here. It has native command line interfaces (4.) support, with many of its plugins can compile from different language extensions (3.). gulpjs has created a virtual file format called [vinyl](https://github.com/wearefractal/vinyl) and with it's abstraction of files, we can easily resolve files different load path(2.2). Thus makes sprocket styles of loading path possible.

The core guideline of gulpjs states that `gulpfile.js` is just plain old nodejs script, so you can easily integrate static file server into it(5.), and we let you rolling own implementation, don't making any assumption on it. Finally, we just have one things to deal with, the dependency management (1.).



