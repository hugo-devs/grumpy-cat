#function that gets called from parse story
fight_start = (enemy, enemy_lvl) ->
  currentFight = new Fight(enemy, enemy_lvl)
  currentFight.set_display()

fight_attack = (attack_name) ->
  console.log data[attack_name]