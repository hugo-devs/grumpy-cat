get_JSON = (what, where) ->
  data_ = undefined
  $.getJSON "assets/data/#{what}.json", (json) ->
    data_ = json
    data[where] = data_

load_story = ->
  $.getJSON "assets/data/#{localStorage.storyline}-story.json", (json) ->
    data.story = json
    load_attacks()

load_questions = ->
    $.getJSON "assets/data/#{data.creatures[localStorage.character].basestats.type}-questions.json", (json) ->
      data.questions = json

load_attacks = ->
  $.getJSON "assets/data/attacks.json", (json) ->
    data.attacks = json
    load_creatures()

load_creatures = ->
  console.log "Hey I am loading the creatures"
  $.getJSON "assets/data/creatures.json", (json) ->
    data.creatures = json
    load_questions()
    parse_story()

random = (from, to) -> Math.floor((Math.random()*to)+from)