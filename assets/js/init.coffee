init = ->
  load_cookies()
  check_for_new_game()
  
  #$("div > *").css("visibility", "visible")
  #$("#preloader").fadeOut("fast")
  # stupid thigns that css coundnt do for me
  $(".select_attack").css("position", "absolute")