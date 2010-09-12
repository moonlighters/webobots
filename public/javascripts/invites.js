function invites() {
  $('#invite_comment').coolinput('комментарий');

  $('.invite .remove_link').live('click', function(e) {
    if (confirm("Точно отменить инвайт?")) {
      link = this;
      $.post(link.href, {_method: 'DELETE'}, function() {
        $(link).closest('.invite').hide('fast');
      });
    }

    e.preventDefault();
  });
};
