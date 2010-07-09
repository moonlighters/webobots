$.fn.scrollToBottom = function() {
  return this.each(function() {
    this.scrollTop = this.scrollHeight;
  });
};

$(function() {
  if( $("#replay-canvas")[0] )
    replayer();
 })
