get_JSON = (what, where) ->
  data_ = undefined
  $.getJSON "assets/data/#{what}.json", (json) ->
    data_ = json
    data[where] = data_

load_story = ->
  console.log "loading story"
  $.getJSON "assets/data/#{localStorage.storyline}-story.json", (json) ->
    data.story = json
    load_attacks()

load_questions_latin = ->
  console.log "loading latin questions"
  data.questions = {}
  $.getJSON "assets/data/latin-questions.json", (json) ->
    data.questions.latin = json

load_questions_english = ->
  console.log "loading english questions"
  $.getJSON "assets/data/english-questions.json", (json) ->
    data.questions.english = json

load_questions_french = ->
  console.log "loading french questions"
  $.getJSON "assets/data/french-questions.json", (json) ->
    data.questions.french = json

load_attacks = ->
  console.log "loading attacks"
  $.getJSON "assets/data/attacks.json", (json) ->
    data.attacks = json
    load_creatures()

load_creatures = ->
  console.log "Hey I am loading the creatures"
  $.getJSON "assets/data/creatures.json", (json) ->
    data.creatures = json
    load_questions_latin()
    load_questions_english()
    load_questions_french()
    parse_story()

reset = ->
  localStorage.clear()
  window.location.reload()

reset_test = ->
  localStorage.clear()
  window.location.replace("/")

random = (from, to) ->
  console.log "from: #{from}"
  console.log "to: #{to}"
  res = Math.floor((Math.random()*to)+from)
  console.log "number: #{res}"
  res