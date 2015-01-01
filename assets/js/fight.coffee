#function that gets called from parse story
fight_start = (enemy, enemy_lvl) ->
  console.log "running fight_start"
  currentFight = new Fight(enemy, enemy_lvl)
  currentFight.set_display()
  $(".fight_area").fadeIn "fast"

fight_question = (attack_name) ->
  console.log "running fight_question"
  currentQuestion.difficulty = data.attacks[attack_name].difficulty
  #currentQuestion.type = data.attacks[attack_name].type
  currentQuestion.question = data.questions[currentQuestion.difficulty][random(0, data.questions[currentQuestion.difficulty].length)]
  $(".dialog").html("
      <paper-dialog backdrop heading='#{currentQuestion.question.question}' class='paper-dialog-transition paper-dialog-transition-bottom' transition='paper-dialog-transition-bottom'>
        <h3>Answer this question to perform the attack!</h3>
        <paper-input autoclosedisabled label='enter your answer here'></paper-input>
        <paper-button onclick='fight_check_question(\"#{attack_name}\")' autofocus role='button' affirmative>Attack!</paper-button>
      </paper-dialog>
    ")
  $(".dialog > paper-dialog")[0].toggle()

fight_check_question = (attack_name) ->
  console.log "running fight_check_question"
  __lower_array = []

  for i in [0..currentQuestion.question.answer.length - 1]
    __lower_array.push currentQuestion.question.answer[i].toLowerCase()

  try
    $(".core-overlay-backdrop").remove()

  if localStorage.cheatMode == "Boss" or localStorage.character == 'Ben-Cheat'
    fight_attack(attack_name)
    currentFight.switch_turn()
    return
  
  if $(".dialog > paper-dialog > paper-input").val().toLowerCase() == currentQuestion.question.answer.toLowerCase()
    fight_attack(attack_name)
    currentFight.switch_turn()
  else if $.inArray($(".dialog > paper-dialog > paper-input").val().toLowerCase(), __lower_array) != -1
    fight_attack(attack_name)
    currentFight.switch_turn()
  else
    notify "<span style='color: #E53935;'>Wrong answer! Your attack failed!<span>"
    setTimeout ->
      currentFight.switch_turn()
    ,500

fight_enemy_attack = ->
  console.log "running fight_enemy_attack"
  __random = random(0, currentFight.enemy_attacks.length)
  __attack = currentFight.enemy_attacks[__random]
  console.log "#{__attack} (#{__random})"
  fight_attack(__attack)
  currentFight.switch_turn()


fight_attack = (attack_name) ->
  currAttack = data.attacks[attack_name]

  fight_change_vals(currAttack.action, currentFight.turn, currentFight.victim)

  if currAttack.hasOwnProperty "action-self"
    fight_change_vals(currAttack['action-self'], currentFight.victim, currentFight.turn)

  #output
  if currentFight.turn is 'player'
    notify fight_parse_inline_vars(currAttack.text)
  else if currentFight.turn is 'enemy'
    swal fight_parse_inline_vars(currAttack.text)
    notify fight_parse_inline_vars(currAttack.text)
  else
    console.log "No fight has been start yet or currentFight.turn is wrong: #{currentFight.turn}"

  currentFight.check_health()

fight_change_vals = (action, attacker, victim) ->
  console.log "running fight_change_vals"
  if currAttack.action[0] is 'hp'
    currentFight[victim + '_health'] += Math.round(parseInt(action[1]) * currentFight[attacker + '_attack_multiplier'] * currentFight[victim + '_defense_multiplier'] * currentFight[attacker + '_lvl'] / 33)
    currentFight.update_health()
  else if currAttack.action[0] is 'attack'
    currentFight[victim + "_attack_multiplier"] += action[1]
  else if currAttack.action[0] is 'defense'
    currentFight[victim + "_attack_multiplier"] += action[1]
  else
    console.log "++++++++++ERROR++++++++++"
    console.log "There's an error with the action[0]. currAttack is:"
    console.log currAttack
    console.log "action[0] is:"
    console.log currAttack.action[0]
    console.log "++++++++++ERROR++++++++++"

fight_attack_tooltip = (self, other, dat, i) ->
  result = ""
  # ###########
  # other
  # ###########
  # HP
  if other and parseFloat(dat.other_val) != 0 and parseFloat(dat.other_val) > 0 and dat.other_type.toLowerCase() == 'hp'
    result += '<p><b>Enemy: </b>' + dat.other_type.toUpperCase() + ' +' + Math.round(dat.other_val * currentFight.player_attack_multiplier * currentFight.enemy_defense_multiplier * currentFight.player_lvl / 33) + '</p>'
  else if other and parseFloat(dat.other_val) != 0 and parseFloat(dat.other_val) < 0 and dat.other_type.toLowerCase() == 'hp'
    result += '<p><b>Enemy: </b>' + dat.other_type.toUpperCase() + ' ' + Math.round(dat.other_val * currentFight.player_attack_multiplier * currentFight.enemy_defense_multiplier * currentFight.player_lvl / 33) + '</p>'
  # ATTACK
  else if other and parseFloat(dat.other_val) != 0 and parseFloat(dat.other_val) > 0 and dat.other_type.toLowerCase() == 'attack'
    result += '<p><b>Enemy: </b>' + dat.other_type.toUpperCase() + ' +' + dat.other_val*100 + '%</p>'
  else if other and parseFloat(dat.other_val) != 0 and parseFloat(dat.other_val) < 0 and dat.other_type.toLowerCase() == 'attack'
    result += '<p><b>Enemy: </b>' + dat.other_type.toUpperCase() + ' ' + dat.other_val*100 + '%</p>'
  # DEFENSE
  else if other and parseFloat(dat.other_val) != 0 and parseFloat(dat.other_val) < 0 and dat.other_type.toLowerCase() == 'defense'
    result += '<p><b>Enemy: </b>' + dat.other_type.toUpperCase() + ' +' + dat.other_val*(-100) + '%</p>'
  else if other and parseFloat(dat.other_val) != 0 and parseFloat(dat.other_val) > 0 and dat.other_type.toLowerCase() == 'defense'
    result += '<p><b>Enemy: </b>' + dat.other_type.toUpperCase() + ' ' + dat.other_val*(-100) + '%</p>'

  # ###########
  # self
  # ###########
  # HP
  console.log self
  console.log dat.self_type
  console.log dat.self_val
  if self and parseFloat(dat.self_val) != 0 and parseFloat(dat.self_val) > 0 and dat.self_type.toLowerCase() == 'hp'
    result += '<p><b>You: </b>' + dat.self_type.toUpperCase() + ' +' + Math.round(dat.self_val * currentFight.player_attack_multiplier * currentFight.enemy_defense_multiplier * currentFight.player_lvl / 33) + '</p>'
  else if self and parseFloat(dat.self_val) != 0 and parseFloat(dat.self_val) < 0 and dat.self_type.toLowerCase() == 'hp'
    result += '<p><b>You: </b>' + dat.self_type.toUpperCase() + ' ' + Math.round(dat.self_val * currentFight.player_attack_multiplier * currentFight.enemy_defense_multiplier * currentFight.player_lvl / 33) + '</p>'
  # ATTACK
  else if self and parseFloat(dat.self_val) != 0 and parseFloat(dat.self_val) > 0 and dat.self_type.toLowerCase() == 'attack'
    result += '<p><b>You: </b>' + dat.self_type.toUpperCase() + ' +' + dat.self_val*100 + '%</p>'
  else if self and parseFloat(dat.self_val) != 0 and parseFloat(dat.self_val) < 0 and dat.self_type.toLowerCase() == 'attack'
    result += '<p><b>You: </b>' + dat.self_type.toUpperCase() + ' ' + dat.self_val*100 + '%</p>'
  # DEFENSE
  else if self and parseFloat(dat.self_val) != 0 and parseFloat(dat.self_val) > 0 and dat.self_type.toLowerCase() == 'defense'
    result += '<p><b>You: </b>' + dat.self_type.toUpperCase() + ' ' + dat.self_val*(-100) + '%</p>'
  else if self and parseFloat(dat.self_val) != 0 and parseFloat(dat.self_val) < 0 and dat.self_type.toLowerCase() == 'defense'
    result += '<p><b>You: </b>' + dat.self_type.toUpperCase() + ' +' + dat.self_val*(-100) + '%</p>'

  if result == ''
    result = 'Nothing happens'

  $('.select_attack > .attack_btns > .' + i + ' > .tip').html(result)
  

  

fight_parse_inline_vars = (text) ->
  console.log "running fight_parse_inline_vars"
  __attacker = currentFight.character
  __victim = currentFight.enemy
  if currentFight.turn is 'enemy'
    __attacker = currentFight.enemy
    __victim = currentFight.character
    
  __res = text.split("||")
  for i in [0..__res.length-1]
    if __res[i].toLowerCase() is 'creature'
      __res[i] = __attacker
    else if __res[i].toLowerCase() is 'enemy'
      __res[i] = __victim
  __res = __res.join("")