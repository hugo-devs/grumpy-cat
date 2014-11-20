get_JSON = (what, where) ->
  data_ = undefined
  $.getJSON "assets/data/#{what}.json", (json) ->
    data_ = json
    data[where] = data_

read_cookie = (key) ->
  result = undefined
  result = undefined
  if result = new RegExp("(?:^|; )" + encodeURIComponent(key) + "=([^;]*)").exec(document.cookie)
    result[1]
  else
    undefined

set_cookie = (cookieName, cookieValue) ->
  expire = undefined
  expire = new Date(1000000000000000)
  document.cookie = cookieName + "=" + cookieValue + ";expires=" + expire.toGMTString()
  load_cookies()

load_cookies = ->
  __to_load = ["name", "character", "finished_tut", "lvl", "storyline", "story_pos"]
  for key in __to_load
    cookies[key] = read_cookie(key)
  # parsing values
  cookies.story_pos = parseInt(cookies.story_pos)
  if cookies.finished_tut is "true"
    cookies.finished_tut = true
  else if cookies.finished_tut is "false"
    cookies.finished_tut = false

load_story = ->
  $.getJSON "assets/data/#{cookies.storyline}-story.json", (json) ->
    data.story = json
    load_attacks()

load_attacks = ->
  $.getJSON "assets/data/attacks.json", (json) ->
    data.attacks = json
    load_creatures()

load_creatures = ->
  $.getJSON "assets/data/creatures.json", (json) ->
    data.creatures = json
    parse_story()