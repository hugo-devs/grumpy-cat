check_for_new_game = ->
  if localStorage.character is undefined or localStorage.name is null
    $("#dialog_choose_name")[0].toggle()
    console.log "toggling dialog"
  else
    load_story()

skip_tut = ->
  if parseInt(localStorage.story_pos) is 0 && localStorage.finished_tut == "true"
    if localStorage.storyline is "latin"
      localStorage.story_pos = 10

parse_story = ->
  console.log "running parse_story"
  if parseInt(localStorage.story_pos) >= data.story.length
    $(".dialog").html("
      <paper-dialog backdrop autoCloseDisabled='true' heading='Which story do you want to play next?' class='paper-dialog-transition paper-dialog-transition-bottom' transition='paper-dialog-transition-bottom'>
        <h3>Choose one of the three. You will still learn the same language and have the same creature, but your level will be reset. You can also replay the story you just played. Or you can completely reset the game and choose another language to learn.</h3>
        <paper-button onclick=\"set_storyline('english');\" raised role='button' affirmative>English</paper-button>
        <paper-button onclick=\"set_storyline('latin');\" raised  role='button' affirmative>Latin</paper-button>
        <paper-button onclick=\"set_storyline('french');\" raised  role='button' affirmative>French</paper-button>
        <paper-button onclick=\"reset();\" raised role='button' affirmative>Reset</paper-button>
      </paper-dialog>
    ")
    $(".dialog > paper-dialog")[0].toggle()

  skip_tut()
  parse_story_element data.story[parseInt(localStorage.story_pos)]
  if data.story[parseInt(localStorage.story_pos)].type != "fight"
    localStorage.story_pos = parseInt(localStorage.story_pos) + 1

parse_story_element = (element) ->
  console.log element
  if element.type is "text"
    notify parse_inline_vars(element.value)
    setTimeout ->
      parse_story();
    ,1000

  else if element.type is "pop"
    if element.hasOwnProperty "title"
      swal {
        text: parse_inline_vars(element.value),
        title: parse_inline_vars(element.title)
      }, ->
        setTimeout ->
          parse_story()
          console.log "callback from swal"
        ,250
    else
      swal {
        title: parse_inline_vars(element.value)
      }, ->
        setTimeout ->
          parse_story()
          console.log "callback from swal"
        ,250

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

  else if element.type is 'fight'
    console.log "fight lvl: #{element.lvl}"
    console.log element
    fight_start(element.enemy, parseInt(element.lvl))

parse_inline_vars = (input) ->
  __print = input.split("||")
  for i in [0..__print.length-1]
    if __print[i].toLowerCase() is "name"
      __print[i] = localStorage.name
    else if __print[i].toLowerCase() is "creature"
      __print[i] = localStorage.character
  __print = __print.join("")

reset = ->
  swal({
    title: "Are you sure?",
    text: "All progress will be lost.",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes, reset the game!",
    cancelButtonText: "No, cancel please!",
  }, (confirmed) ->
    if confirmed
      localStorage.clear()
      location.reload()
    else
      location.reload()
  )

set_name = ->
  console.log  "Name set: #{$("#dialog_choose_name > paper-input").val()}"
  localStorage.name = $("#dialog_choose_name > paper-input").val()
  $("#dialog_choose_name").remove()
  $("#dialog_backstory").attr "heading", "Welcome to the Hugo Science Enrichment Center"
  $("#dialog_backstory").html "<p>HugoOS: We here at Hugo Science Enrichment Center are the leading scientists in terms of portals and time travel. You have been chosen to test our newest time machine protoype. You may never come back, so choose wisely if you want to go to ancient Rome, the England of Shakepeare or the french revolution.</p> <paper-button onclick='show_choose_creature()' affirmative autofocus role='button'>Got it</paper-button>"
  $("#dialog_backstory")[0].toggle()

set_character = (what) ->
  localStorage.character = what
  localStorage.lvl = 1
  localStorage.finished_tut = false
  localStorage.story_pos = 0
  $("#dialog_choose_creature").remove()
  $(".core-overlay-backdrop").remove()

set_storyline = (which) ->
  console.log "Running set_storyline"
  localStorage.story_pos = 0
  localStorage.lvl = 1
  localStorage.storyline = which
  $(".core-overlay-backdrop").remove()
  load_story()

show_choose_creature = ->
  $("#dialog_backstory").remove()
  $("#dialog_choose_creature")[0].toggle()
  notify "HugoOS: We here at Hugo Science Enrichment Center are the leading scientists in terms of portals and time travel. You have been chosen to test our newest time machine protoype. You may never come back, so choose wisely if you want to go to ancient Rome, the England of Shakepeare or the french revolution."

notify = (text) ->
  $("#timeline_content").prepend "<p class='notification-element'>#{text}</p>"
  $(".notification-element:nth-of-type(1)").css "display", "none"
  $(".notification-element:nth-of-type(1)").fadeIn "fast"

pop = (text, heading) ->
  $(".dialog").html('<paper-dialog heading="' + heading + '" opened="true" transition="paper-dialog-transition-bottom">' + text + '</paper-dialog>')