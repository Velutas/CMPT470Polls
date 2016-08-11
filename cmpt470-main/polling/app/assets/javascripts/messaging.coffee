# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
    $('#reply-form').hide();
    $('#reply-expand').on 'click', ->
        $('#reply-form').show();
        $('#reply-expand').hide();
        origHeight = $('#reply-form').height();
        $('#reply-form').animate {height: 0}, 0;
        $('#reply-form').animate {opacity: 0}, 0;
        $('#reply-form').animate {height: origHeight}, 300;
        $('#reply-form').animate {opacity: 1}, 500;