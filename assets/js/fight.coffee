#function that gets called from parse story
fight_start = (enemy, enemy_lvl) ->
  currentFight = new Fight(enemy, enemy_lvl)
  currentFight.set_display()

fight_attack = (attack_name) ->
  currAttack = data.attacks[attack_name]

  console.log currAttack

  fight_change_vals(currAttack.action, currentFight.turn, currentFight.victim)

  #output
  if currentFight.turn is 'player'
    notify fight_parse_inline_vars(currAttack.text)
  else if currentFight.turn is 'enemy'
    swal fight_parse_inline_vars(currAttack.text)
    notify fight_parse_inline_vars(currAttack.text)
  else
    console.log "No fight has been start yet or currentFight.turn is wrong: #{currentFight.turn}"

fight_change_vals = (action, attacker, victim) ->
  if action[0] is 'hp'
    currentFight[victim + '_health'] += Math.round(parseInt(action[1]) * currentFight[attacker + '_attack_multiplier'] * currentFight[victim + '_defense_multiplier'] * currentFight[attacker + '_lvl'] / 33)
    currentFight.update_health()
  if action[0] is 'attack'
    currentFight[victim + "_attack_multiplier"] += action[1]
  if action[0] is 'defense'
    currentFight[victim + "_attack_multiplier"] += action[1]


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