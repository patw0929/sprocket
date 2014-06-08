require! {
  'gulp-filter'
  'gulp-minify-css'
  'gulp-rename'
}

module.exports = (dest) ->
  const filter = gulp-filter '!**/*.min.css'
  filter.pipe gulp-minify-css!
    .pipe gulp-rename extname: '.min.css'
    .pipe filter.restore!
    .pipe dest
  filter
