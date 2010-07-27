var COMMENT_MAX_LENGTH = 1000;

$(function() {
  $('.comment_entity .remove_link').live('click', function(e) {
    link = this;
    if (confirm("Точно удалить комментарий?")) {
      $.post(link.href, {_method: 'DELETE'}, function() {
        $(link).closest('.comment_entity').hide('fast');
      });
    }

    e.preventDefault();
  });

  $add_comment_link = $('.comments #add_comment');
  $form = $('.comments form');
  $form.hide();

  function show_form() {
    $add_comment_link.slideUp();
    $form.slideDown();
    $form.find('textarea').val('');
  }
  function hide_form() {
    $add_comment_link.show('fast');
    $form.hide('fast');
  }

  $form.ajaxForm({
    beforeSubmit: function () {
      text = $form.find('textarea').val();
      if(text.replace(/\s/g,'') == '') {
        alert("Нельзя добавить пустой комментарий");
        return false;
      }
      if(text.length > COMMENT_MAX_LENGTH) {
        alert("Слишком длинный комментарий, максимум" + COMMENT_MAX_LENGTH + " символов");
        return false;
      }
    },
    success: function(res) {
      if(res != "ERROR") {
        $comment = $('.comments .comment_entity:first');
        entity = $(res).hide();
        if($comment.length == 0) {
          // first comment
          $('.comments').append(entity);
        } else {
          $comment.before(entity);
        }
        entity.show('fast');
        hide_form();
      } else {
        alert("Что-то пошло не так, комментарий не добавлен");
      }
    }
  });

  $add_comment_link.click(function(e) {
    show_form();
    e.preventDefault();
  });

});
