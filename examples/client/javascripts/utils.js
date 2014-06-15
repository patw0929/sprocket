(function (global) {
  
  function consoleLog () {
    if ((typeof console !== 'undefined') && (typeof console.log !== 'undefined')) {
      return console.log.apply(console, arguments);
    }
  }

  global.utils = {
    consoleLog: consoleLog
  };

})(this);