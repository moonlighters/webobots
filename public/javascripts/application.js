$.fn.scrollToBottom = function() {
  return this.each(function() {
    this.scrollTop = this.scrollHeight;
  });
};

$(function() {
  $('.nyroModal.show-replay').nyroModal({
    autoSizable: false,
    minWidth: 800,
    minHeight: 440
  });
  $('.nyroModal#show-code').nyroModal({ minWidth: 600 });
});
