require! {
  gulp
}

module.exports = SprocketGulpHelpers
/*
 * SprocketGulpHelpers
 */
!function SprocketGulpHelpers (options)
  [@[key] = val for key, val of options || {}]

SprocketGulpHelpers::<<< {
  javascriptsDest:~
    -> gulp.dest @environment.javascriptsPath

  stylesheetsDest:~
    -> gulp.dest @environment.stylesheetsPath
}
