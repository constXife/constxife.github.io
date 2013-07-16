#= require jquery
#= require redactor/redactor.min
#= require redactor/ru
#= require redactor/fullscreen
#= require jquery.fancybox.pack
#= require_tree .

$.ajaxSetup
  beforeSend: (xhr) ->
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))

$(document).ready ->
  if $('div.post').length
    $(window).scroll ->
      if ($(this).scrollTop() > 100)
        $('.scrollup').fadeIn()
      else
        $('.scrollup').fadeOut()

    $('.scrollup').click ->
      $("html, body").animate({ scrollTop: 0 }, 600)
      return false;