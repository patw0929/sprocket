# Dependency Management in sprocketjs

Thanks to the [vinyl](https://github.com/wearefractal/vinyl), it has never been that easy for us to build dependencies based on it. Just simply parse the directives from the result of `vinyl.contents.toString()`, and we can build a graph of file nodes based on that information. But how to sprocketjs load their dependencies files? Since we don't use `fs` directly to read files, we rely on gulpjs to pass in the files by the stream of `gulp.src`. Once we got files from the stream, we can resolve the node and continue parse dependencies.
