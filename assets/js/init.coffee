init = ->
  load_cookies()
  check_for_new_game()
  
  $("div > *").css("visibility", "visible")
  $("#preloader").fadeOut("fast")