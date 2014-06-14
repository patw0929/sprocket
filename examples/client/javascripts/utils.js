(function (global) {
  
  function consoleLog (argument) {
    if (typeof console !== 'undefined' && typeof console.log !== 'undefined') {
      return console.log.apply(console, argument);
    }
  }

  global.utils = {
    consoleLog: consoleLog
  };

})(this);