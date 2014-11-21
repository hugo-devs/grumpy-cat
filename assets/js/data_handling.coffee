get_JSON = (what, where) ->
  data_ = undefined
  $.getJSON "assets/data/#{what}.json", (json) ->
    data_ = json
    data[where] = data_

load_story = ->
  $.getJSON "assets/data/#{localStorage.storyline}-story.json", (json) ->
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