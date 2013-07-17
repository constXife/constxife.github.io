window.blog = {}

$(document).ready(
  function(){
  var csrf_token = $('meta[name=csrf-token]').attr('content');
  var csrf_param = $('meta[name=csrf-param]').attr('content');
  var params;
  if (csrf_param !== undefined && csrf_token !== undefined) {
    params = csrf_param + "=" + encodeURIComponent(csrf_token);
  }
  window.blog.redactor_config =
      {
          "imageUpload":"/redactor_rails/pictures?" + params,
          "imageGetJson":"/redactor_rails/pictures",
          "path":"/assets/redactor-rails",
          "css":"style.css",
          "focus": true,
          "lang": 'ru',
          "plugins": ['fullscreen']
      }
});