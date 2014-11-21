#function that gets called from parse story
fight_start = (enemy, enemy_lvl) ->
  currentFight = new Fight(enemy, enemy_lvl)
  currentFight.set_display()

fight_attack = (attack_name) ->
  currAttack = data.attacks[attack_name]

  console.log currAttack

  #actual changing of values
  if currAttack.action[0] is 'hp'
    console.log "It's a hp action and it takes " + Math.round(parseInt(currAttack.action[1]) * currentFight[currentFight.turn + '_attack_multiplier'] * currentFight[currentFight.victim + '_defense_multiplier'] * currentFight[currentFight.turn + '_lvl'] / 33)
    currentFight[currentFight.victim + '_health'] += Math.round(parseInt(currAttack.action[1]) * currentFight[currentFight.turn + '_attack_multiplier'] * currentFight[currentFight.victim + '_defense_multiplier'] * currentFight[currentFight.turn + '_lvl'] / 33)
    currentFight.update_health()

  #output
  if currentFight.turn is 'player'
    notify fight_parse_inline_vars(currAttack.text)
  else if currentFight.turn is 'enemy'
    swal fight_parse_inline_vars(currAttack.text)
    notify fight_parse_inline_vars(currAttack.text)
  else
    console.log "No fight has been start yet or currentFight.turn is wrong: #{currentFight.turn}"

fight_parse_inline_vars = (text) ->
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