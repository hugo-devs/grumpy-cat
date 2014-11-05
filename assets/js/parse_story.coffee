parse_story = ->
  console.log "parsing story"
  if cookies.name is undefined or cookies.name is null
    $("#dialog_choose_name").toggle()
  else
    console.log "nice to have you back"