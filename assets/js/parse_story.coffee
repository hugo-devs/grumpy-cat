check_for_new_game = ->
  if cookies.character is undefined or cookies.name is null
    $("#dialog_choose_name").toggle()
    console.log "toggling dialog"
  else
    load_story()

skip_tut = ->
  if cookies.story_pos is 0 && cookies.finished_tut
    if cookies.storyline is "latin"
      cookies.story_pos = 10

parse_story = ->
  skip_tut()
  parse_story_element data.story[cookies.story_pos]
  set_cookie("story_pos", cookies.story_pos + 1)
  load_cookies()

parse_story_element = (element) ->
  console.log element
  if element.type is "text"
    notify parse_inline_vars(element.value)
    setTimeout ->
      parse_story();
    ,2000
  else if element.type is "pop"
    if element.hasOwnProperty "title"
      swal {
        text: parse_inline_vars(element.value),
        title: parse_inline_vars(element.title)
      }, ->
        setTimeout ->
          parse_story()
          console.log "callback from swal"
        ,1000
    else
      swal {
        title: parse_inline_vars(element.value)
      }, ->
        setTimeout ->
          parse_story()
          console.log "callback from swal"
        ,1000

  else if element.type is "advanced_pop"
    __swal = element.swal

    if __swal.hasOwnProperty "title"
      __swal.title = parse_inline_vars __swal.title
    if __swal.hasOwnProperty "text"
      __swal.text = parse_inline_vars __swal.text
    if __swal.hasOwnProperty "confirmButtonText"
      __swal.confirmButtonText = parse_inline_vars __swal.confirmButtonText
    if __swal.hasOwnProperty "cancelButtonText"
      __swal.cancelButtonText = parse_inline_vars __swal.cancelButtonText

    if element.hasOwnProperty "callback"
      swal __swal, callbacks[element.callback]
    else
      swal __swal, ->
        parse_story()

parse_inline_vars = (input) ->
  __print = input.split("||")
  for i in [0..__print.length-1]
    if __print[i].toLowerCase() is "name"
      __print[i] = cookies.name
    else if __print[i].toLowerCase() is "creature"
      __print[i] = cookies.character
  __print = __print.join("")

set_name = ->
  console.log  "Name set: #{$("#dialog_choose_name > paper-input").val()}"
  set_cookie("name", $("#dialog_choose_name > paper-input").val())
  load_cookies()
  $("#dialog_choose_name").remove()
  $("#dialog_backstory").attr "heading", "Welcome to the Hugo Science Enrichment Center"
  $("#dialog_backstory").html "<p>HugoOS: We here at Hugo Science Enrichment Center are the leading scientists in terms of portals and time travel. You have been chosen to test our newest time machine protoype. You may never come back, so choose wisely if you want to go to ancient Rome, the England of Shakepeare or the french revolution.</p> <paper-button onclick='show_choose_creature()' affirmative autofocus role='button'>Got it</paper-button>"
  $("#dialog_backstory").toggle()

set_character = (what) ->
  set_cookie("character", what)
  set_cookie("lvl", 1)
  set_cookie("finished_tut", false)
  set_cookie("story_pos", 0)
  load_cookies()
  $("#dialog_choose_creature").remove()

set_storyline = (which) ->
  set_cookie("storyline", which)
  load_cookies()
  load_story()

show_choose_creature = ->
  $("#dialog_backstory").remove()
  $("#dialog_choose_creature").toggle()
  notify "HugoOS: We here at Hugo Science Enrichment Center are the leading scientists in terms of portals and time travel. You have been chosen to test our newest time machine protoype. You may never come back, so choose wisely if you want to go to ancient Rome, the England of Shakepeare or the french revolution."

notify = (text) ->
  $("#timeline_content").prepend "<p class='notification-element'>#{text}</p>"
  $(".notification-element:nth-of-type(1)").css "display", "none"
  $(".notification-element:nth-of-type(1)").fadeIn "fast"

pop = (text, heading) ->
  $(".dialog").html('<paper-dialog heading="' + heading + '" opened="true" transition="paper-dialog-transition-bottom">' + text + '</paper-dialog>')