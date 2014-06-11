require! {
  gulp
}
require! {
  SprocketEnvironment: '../environment'
}

module.exports = SprocketGulpHelpers
/*
 * SprocketGulpHelpers
 */
!function SprocketGulpHelpers (@environment, options)
  [@[key] = val for key, val of options || {}]
/*
 * SprocketGulpHelpers.prototype
 */
const {prototype} = SprocketGulpHelpers

Object.keys SprocketEnvironment.SUPPORTED_ANCESTORS .forEach !(ancestor) ->
  prototype["#{ ancestor }Dest"] = ->
    gulp.dest @environment["#{ ancestor }Path"]
