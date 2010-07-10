$.fn.scrollToBottom = function() {
  return this.each(function() {
    this.scrollTop = this.scrollHeight;
  });
};

$(function() {
  $('.nyroModal#show-replay').nyroModal({ autoSizable: false, minWidth: 700, minHeight: 480 });
});
