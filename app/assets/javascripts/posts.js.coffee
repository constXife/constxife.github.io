# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

hidePanel = ->
  content = $('div.post div.content')
  preview = $('div.post div.preview')
  saveButton = $('#save_post')

  $('#edit_post').text('Изменить')
  content.removeClass('redactor')
  preview.removeClass('redactor')
  content.redactor('destroy');
  preview.redactor('destroy');
  saveButton.hide()

$(document).ready ->
  $('.fancybox').fancybox()

  $('.redactor').redactor(window.blog.redactor_config)

  $('#edit_post').on 'click', ->
    content = $('div.post div.content')
    preview = $('div.post div.preview')
    saveButton = $('#save_post')

    if content.hasClass('redactor')
      hidePanel()
    else
      $(@).text('Отмена')
      saveButton.show()
      content.addClass('redactor')
      preview.addClass('redactor')
      content.redactor(window.blog.redactor_config)
      preview.redactor(window.blog.redactor_config)

  $('#save_post').on 'click', ->
    content = $('.content.redactor').redactor('get');
    preview = $('.preview.redactor').redactor('get');
    id = $('div.post').data('id')

    $.ajax "/blog/posts/#{id}.json",
      type: 'POST'
      data:
        _method:'PATCH'
        post:
          content: content
          preview: preview
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log jqXHR
        console.log textStatus
        console.log errorThrown
      success: (data, textStatus, jqXHR ) ->
        hidePanel()
      completed: ->
        hidePanel()