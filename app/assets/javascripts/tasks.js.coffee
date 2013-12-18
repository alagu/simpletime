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

initialize_datepicker =->
  $("#reportrange").daterangepicker
    ranges:
      Today: [moment(), moment()]
      Yesterday: [moment().subtract("days", 1), moment().subtract("days", 1)]
      "Last 7 Days": [moment().subtract("days", 6), moment()]
      "Last 30 Days": [moment().subtract("days", 29), moment()]
      "This Month": [moment().startOf("month"), moment().endOf("month")]
      "Last Month": [moment().subtract("month", 1).startOf("month"), moment().subtract("month", 1).endOf("month")]

    startDate: moment().subtract("days", 29)
    endDate: moment()
    , (start, end) ->
      start_s = start.format("DD-MM-YYYY")
      end_s   = end.format("DD-MM-YYYY")
      window.location = "/dashboard?from=#{start_s}&to=#{end_s}"


$(document).ready ->
  set_date()
  initialize_datepicker()