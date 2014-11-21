function Fight (enemy, enemy_lvl) {
  this.character = localStorage.character;
  this.player_lvl = parseInt(localStorage.lvl);
  this.enemy = enemy;
  this.enemy_lvl = enemy_lvl;

  //Keeps track of health
  this.player_health = Math.round(parseInt(data.creatures[this.character].basestats.hp) * parseInt(localStorage.lvl) / 33);
  this.enemy_health = Math.round(parseInt(data.creatures[this.enemy].basestats.hp) * parseInt(enemy_lvl) / 33);
  this.player_basehealth = this.player_health
  this.enemy_basehealth = this.enemy_health

  //Keeps track type and multipliers
  this.player_type = data.creatures[this.character].basestats.type;
  this.enemy_type = data.creatures[this.enemy].basestats.type;
  this.player_multiplier = 1.0;
  this.enemy_multiplier = 1.0;

  this.update_health = function () {
    $(".fight_area > .creatures > .player > paper-progress").attr("value", Math.round(this.player_health / this.player_basehealth * 100))
    $(".fight_area > .creatures > .enemy > paper-progress").attr("value", Math.round(this.enemy_health / this.enemy_basehealth * 100))
  };

  this.set_display = function () {
    //setting h1 with names and lvl of creatures
    $('.fight_area > .creatures > .player > h1 > span.name').html(this.character);
    $('.fight_area > .creatures > .enemy > h1 > span.name').html(this.enemy);
    $('.fight_area > .creatures > .player > h1 > span.lvl > span').html(this.player_lvl);
    $('.fight_area > .creatures > .enemy > h1 > span.lvl > span').html(this.enemy_lvl);

    this.update_health();
  };
}