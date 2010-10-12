$(function() {
  $('.match_entity .more_link').click(function (e){
    $(this).closest('.match_entity').find('.more').slideToggle('fast');
    e.preventDefault();
  });
});
