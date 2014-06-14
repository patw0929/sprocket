var ref$;
module.exports = RequireState;
function RequireState(){
  this._inRequireStates = [true];
  this._keyPaths = {};
  this._nodes = [];
  this._totalBufferSize = 0;
}
/*
 * RequireState.prototype
 */
ref$ = RequireState.prototype;
ref$.pushState = function(it){
  this._inRequireStates.push(it);
};
ref$.popState = function(){
  this._inRequireStates.pop();
};
ref$.requiredBefore = function(keyPath){
  var ref$;
  return (ref$ = this._inRequireStates)[ref$.length - 1] && keyPath in this._keyPaths;
};
ref$.addNode = function(node){
  var vinyl, keyPath, that;
  vinyl = node.vinyl, keyPath = node.keyPath;
  if (this.requiredBefore(keyPath)) {
    return;
  }
  this._keyPaths[keyPath] = true;
  this._nodes.push(node);
  if (that = vinyl.contents) {
    this._totalBufferSize += that.length;
  }
};