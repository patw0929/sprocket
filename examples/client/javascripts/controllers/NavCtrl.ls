#= require utils
#= require models/User
!function NavCtrl
  @user = new User 'current_user'
  utils.consoleLog \NavCtrl @user.getId!

@ <<< {NavCtrl}
