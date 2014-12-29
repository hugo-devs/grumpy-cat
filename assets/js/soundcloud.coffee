try
	console.log "Init soundcloud"
	SC.initialize {
	  	client_id: "bb72e01542b2481b1ed0c625951bcb03"
	  }
catch e
	console.log "soundcloud failed"

play_sound = (sound_id) ->
  try
    SC.stream sound_id, (sound) ->
      sound.play()
  catch e
    console.log "You probably don't have any or a good network connection"

  localStorage.story_pos = parseInt(localStorage.story_pos) + 1
  parse_story()
