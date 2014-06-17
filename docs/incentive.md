# Incentive

In the nodejs community, there're many tools that try to solve the problem of assets management, while the ruby on rails community benifits greatly from the awesome gem, [sprocket](https://github.com/sstephenson/sprockets).

This project aims to be the `sprocket` in the nodejs community.


## Project philosophy

### Convention over Configuration
The sprocket based projects have three conventions:

* Seamless Integration (Optimization)
* Dependency Management (Injection)
* Language Extensions Support

Let's talk about them sequentially.

### [Seamless Integration](https://github.com/tomchentw/sprocket/blob/master/docs/seamless_integration.md) (Optimization)
Why this is so important? It makes developers **focus on the business logic**, don't care about optimization stuffs. It just works!

When you're ready to release a new version, `sprocket` automatically *minify, concact and versioned* them together for you. Thus provides best network performance under the hood.

### [Dependency Management](https://github.com/tomchentw/sprocket/blob/master/docs/dependency_management.md) (Injection)
We always have to take good care about dependencies. While there's no standars yet and many tools like `require.js` or `commonjs`(`browserify`) are trying to solve this problem, sprocket use `require` *directive* to declare your depencency.

Under development, the html looks like you're using standard `<script></script>` and `<link>` tags, with dependencies **automatically resolved** and flattened dependency tree into a list.

### [Language Extensions](https://github.com/tomchentw/sprocket/blob/master/docs/language_extensions.md) Support
Thanks to the "great" JavaScript! There're [brunch of languages](https://github.com/jashkenas/coffeescript/wiki/List-of-languages-that-compile-to-JS) that compiles to it. The same thing also happens to the stylesheets. (Does anyone have the link?)

If your team is in the transition state from one to another, say from JavaScript to LiveScript for readibility, or from pure CSS to Sass/LESS. It'll be really helpful to have a build tool that **treats them equally**.

### Develop in LiveScript
[LiveScript](http://livescript.net/) is a compile-to-js language, which provides us more robust way to write JavaScript.  
It also has great readibility and lots of syntax sugar just like you're writting python/ruby.


## How sprocket compares to other libraries in the [list](https://github.com/tomchentw/sprocket/blob/master/docs/other_tools.md)?

They have common characteristics in these libraries, which are

1. dependency management
2. resolving files from different load path 
3. convert/compile files from language extensions
4. command line interfaces
5. serve the compiled static assets

Many of these libraries try to rolling their own implementation, while in contrast, I would prefer not to reinvent the wheels. And I later found that [gulpjs](http://gulpjs.com/) do a good job here. It has native command line interfaces (4.) support, with many of its plugins can compile from different language extensions (3.). gulpjs has created a virtual file format called [vinyl](https://github.com/wearefractal/vinyl) and with it's abstraction of files, we can easily resolve files different load path(2.2). Thus makes sprocket styles of loading path possible.

The core guideline of gulpjs states that `gulpfile.js` is just plain old nodejs script, so you can easily integrate static file server into it(5.), and we let you rolling own implementation, don't making any assumption on it. Finally, we just have one things to deal with, the dependency management (1.).



