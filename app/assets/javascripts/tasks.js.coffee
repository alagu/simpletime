# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


set_date =->
  today = new Date()
  dd = today.getDate()
  mm = today.getMonth() + 1

  yyyy = today.getFullYear()    
  dd= '0' + dd if dd < 10 
  mm= '0' + mm if mm < 10
  today = "#{dd}-#{mm}-#{yyyy}"

  $("#task-when").val(today)
  $('#task-when').datepicker({ format: 'dd-mm-yyyy' })


$(document).ready ->
  set_date()
  