init = ->
  check_for_new_game()

  emojify.setConfig({
  	img_dir: 'bower_components/emojify/images/emoji'
  	})
  emojify.run()

  update_money()
  
  # Only while dev
  # shop_dialog.toggle()