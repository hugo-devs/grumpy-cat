function Fight (enemy, enemy_lvl) {
	this.character = localStorage.character;
	this.player_lvl = parseInt(localStorage.lvl);
	this.enemy = enemy;
	this.enemy_lvl = enemy_lvl;

	this.player_description = data.creatures[this.character].description;
	this.enemy_description = data.creatures[this.enemy].description;

	//Keeps track of health
	this.player_health = Math.round(parseInt(data.creatures[this.character].basestats.hp) * parseInt(localStorage.lvl) / 33);
	this.enemy_health = Math.round(parseInt(data.creatures[this.enemy].basestats.hp) * parseInt(enemy_lvl) / 33);
	this.player_basehealth = this.player_health;
	this.enemy_basehealth = this.enemy_health;

	//Keeps track type and multipliers and attacks
	this.player_type = data.creatures[this.character].basestats.type;
	this.enemy_type = data.creatures[this.enemy].basestats.type;

	this.player_attack_multiplier = 1.0;
	this.enemy_attack_multiplier = 1.0;
	this.player_defense_multiplier = 1.0;
	this.enemy_defense_multiplier = 1.0 ;

	this.player_attacks = data.creatures[this.character].attacks;
	this.enemy_attacks = data.creatures[this.enemy].attacks;

	//keeps track of whos turn it is
	this.turn = 'player';
	this.victim = 'enemy';

	this.switch_turn = function () {
		console.log("running switch_turn");
		console.log("currentFight.turn was " + this.turn);
		if (this.turn == 'player') {
			this.turn = 'enemy';
			this.victim = 'player';
			$(".select_attack > .attack_btns > paper-button").attr("disabled", "");
			fight_enemy_attack();
		} else {
			this.turn = 'player';
			this.victim  = 'enemy';
			$(".select_attack > .attack_btns > paper-button").removeAttr("disabled");
		}
		console.log("currentFight.turn is now " + this.turn);
	};

	this.update_health = function () {
		$(".fight_area > .creatures > .player > paper-progress").attr("value", Math.round(this.player_health / this.player_basehealth * 100));
		$(".fight_area > .creatures > .enemy > paper-progress").attr("value", Math.round(this.enemy_health / this.enemy_basehealth * 100));
	};

	this.set_display = function () {
		//setting h1 with names and lvl of creatures and tooltips
		$('.fight_area > .creatures > .player > h1 > core-tooltip > span.name').html(this.character);
		$('.fight_area > .creatures > .enemy > h1 > core-tooltip > span.name').html(this.enemy);
		$('.fight_area > .creatures > .player > h1 > span.lvl > span').html(this.player_lvl);
		$('.fight_area > .creatures > .enemy > h1 > span.lvl > span').html(this.enemy_lvl);
		$('.fight_area > .creatures > .player > h1 > core-tooltip').attr("label", this.player_description);
		$('.fight_area > .creatures > .enemy > h1 > core-tooltip').attr("label", this.enemy_description);

		//Attack btns
		$(".select_attack > .attack_btns").html("");
		for (var i = 0; i < this.player_attacks.length; i++) {
			console.log("Testing " + i + " (" + this.player_attacks[i] + ") and it is:");
			console.log(data.attacks[this.player_attacks[i]]);
			if (data.attacks[this.player_attacks[i]].hasOwnProperty("action_self")) {
				$(".select_attack > .attack_btns").append(
					"<core-tooltip position='top'>"+
						"<paper-button raised onclick='fight_question(\""+ this.player_attacks[i]+ "\")'>" + this.player_attacks[i] + "</paper-button>"+
						"<div tip class='tip'>"+
							"<p><b>Enemy: </b>"+ data.attacks[this.player_attacks[i]].action[0].toUpperCase() + " " + data.attacks[this.player_attacks[i]].action[1] +"</p>"+
							"<p class='you'><b>You: " + data.attacks[this.player_attacks[i]].action_self[0].toUpperCase() + " " + data.attacks[this.player_attacks[i]].action_self[1] + "</b></p>"+
						"</div>"+
					"</core-tooltip>"
				);
			} else if (data.attacks[this.player_attacks[i]].hasOwnProperty("action_self") === false) {
				$(".select_attack > .attack_btns").append(
					"<core-tooltip position='top'>"+
						"<paper-button raised onclick='fight_question(\""+ this.player_attacks[i]+ "\")'>" + this.player_attacks[i] + "</paper-button>"+
						"<div tip class='tip'>"+
							"<p><b>Enemy: </b>"+ data.attacks[this.player_attacks[i]].action[0].toUpperCase() + " " + data.attacks[this.player_attacks[i]].action[1] +"</p>"+
						"</div>"+
					"</core-tooltip>"
				);
			}
		}

		this.check_health = function () {
			if (this.player_health <= 0) {
				swal({
					title: "You lost the Battle.",
					text: "Try again!",
					timer: 2999,
					type: "error"
				},
					function () {
						parse_story();
					}
				);
			} else if (this.enemy_health <= 0) {
				swal({
					title: "You won the Battle!",
					text: "You earn one level. Continue you journey.",
					timer: 2999,
					type: "success"
				},
					function () {
						localStorage.story_pos = parseInt(localStorage.story_pos) + 1;
						localStorage.lvl = parseInt(localStorage.lvl) + 1;
						parse_story();
						$(".fight_area").fadeOut("fast");
					});
			}
		};

		this.update_health();
	};
}