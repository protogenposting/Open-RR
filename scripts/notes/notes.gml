function note(_name,_description,_sprite,_onHit,_draw,_onMiss) constructor{
	name = _name
	description = _description
	sprite = _sprite
	onHit = _onHit
	draw = _draw
	onMiss = _onMiss
}

timings = [
	{name:"Perfect!",window:20,accuracyBoost:0.01},
	{name:"Good",window:50,accuracyBoost:0.001},
	{name:"Bad...",window:100,accuracyBoost:-0.1},
	{name:"Awful!",window:9999999999,accuracyBoost:-1},
]

#macro hitWindow 150

noteType[0] = new note(
	"Normal",
	"It's a normal note :3",
	spr_note,
	function(_timing,_note){
		audio_play_sound(snd_hit,1000,false)
		_note[noteData.wasHit] = true
		for(var i = 0; i<array_length(global.timings); i++)
		{
			if(global.timings[i].window>abs(_timing))
			{
				return i
			}
		}
	},
	function(_timing,_note,_speed,_barLocation,_songMilliseconds)
	{
		var _x = screenWidth/2 + _note[noteData.row] * 64 - 128 + 32
		var _y = _barLocation-_timing*_speed
		if(_y<0)
		{
			return 0
		}
		
		draw_rectangle(_x-8,_y,_x+8,_barLocation-(_speed*((_note[noteData.time]+_note[noteData.length]-_songMilliseconds))),false)
		
		if(!_note[noteData.wasHit])
		{
			draw_sprite(global.noteType[_note[noteData.type]].sprite,0,_x,_y)
		}
	},
	function(_timing,_note,_lanesHit){
		show_debug_message(_timing)
		global.currentCharacter.missesLeft--
		_note[noteData.wasHit] = true
		_note[noteData.holdHasMissed] = true
		return 3
	}
)

noteType[1] = new note(
	"Half Time",
	"Comes in at half the speed of a normal note!",
	spr_note_slow,
	noteType[0].onHit,
	function(_timing,_note,_speed,_barLocation,_songMilliseconds)
	{
		global.noteType[0].draw(_timing,_note,_speed*0.5,_barLocation,_songMilliseconds)
	},
	noteType[0].onMiss
)

noteType[2] = new note(
	"Double Time",
	"Comes in at double the speed of a normal note!",
	spr_note_fast,
	noteType[0].onHit,
	function(_timing,_note,_speed,_barLocation,_songMilliseconds)
	{
		global.noteType[0].draw(_timing,_note,_speed*1.5,_barLocation,_songMilliseconds)
	},
	noteType[0].onMiss
)

noteType[3] = new note(
	"Worm Note",
	"Wiggles around!",
	spr_note_worm,
	noteType[0].onHit,
	function(_timing,_note,_speed,_barLocation,_songMilliseconds)
	{
		var _x = screenWidth/2 + _note[noteData.row] * 64 - 128 + 32 + sin(_timing/100)*32
		var _y = _barLocation-_timing*_speed
		if(_y<0)
		{
			return 0
		}
		
		draw_rectangle(_x-8,_y,_x+8,_barLocation-(_speed*((_note[noteData.time]+_note[noteData.length]-_songMilliseconds))),false)
		
		if(!_note[noteData.wasHit])
		{
			draw_sprite(global.noteType[_note[noteData.type]].sprite,0,_x,_y)
		}
	},
	noteType[0].onMiss
)

noteType[4] = new note(
	"Bounce Note",
	"Bounces up and down!",
	spr_note_bounce,
	noteType[0].onHit,
	function(_timing,_note,_speed,_barLocation,_songMilliseconds)
	{
		var _x = screenWidth/2 + _note[noteData.row] * 64 - 128 + 32 
		var _y = _barLocation-_timing*_speed + sin(_timing/100)*64
		
		if(_y<0)
		{
			return 0
		}
		
		draw_rectangle(_x-8,_y,_x+8,_barLocation-(_speed*((_note[noteData.time]+_note[noteData.length]-_songMilliseconds))),false)
		
		if(!_note[noteData.wasHit])
		{
			draw_sprite(global.noteType[_note[noteData.type]].sprite,0,_x,_y)
		}
	},
	noteType[0].onMiss
)

noteType[5] = new note(
	"Heal Note",
	"5% chance to heal 1 miss on hit",
	spr_note_heal,
	function(_timing,_note){
		if(random(1)>=0.95)
		{
			global.currentCharacter.missesLeft+=1
			if(global.currentCharacter.missesLeft>global.currentCharacter.misses)
			{
				global.currentCharacter.missesLeft = global.currentCharacter.misses
			}
		}
		return global.noteType[0].onHit(_timing,_note)
	},
	noteType[0].draw,
	noteType[0].onMiss
)

noteType[6] = new note(
	"Fire Note",
	"Don't hit it!",
	spr_note_fire,
	noteType[0].onMiss,
	noteType[0].draw,
	noteType[0].onHit
)

noteType[7] = new note(
	"Ghost Note",
	"Fades away over time!",
	spr_note_ghost,
	noteType[0].onHit,
	function(_timing,_note,_speed,_barLocation,_songMilliseconds)
	{
		var _x = screenWidth/2 + _note[noteData.row] * 64 - 128 + 32 
		var _y = _barLocation-_timing*_speed
		if(_y<0)
		{
			return 0
		}
		
		draw_set_alpha(1-(_timing/500))
		draw_rectangle(_x-8,_y,_x+8,_barLocation-(_speed*((_note[noteData.time]+_note[noteData.length]-_songMilliseconds))),false)
		
		if(!_note[noteData.wasHit])
		{
			draw_sprite(global.noteType[_note[noteData.type]].sprite,0,_x,_y)
		}
		draw_set_alpha(1)
	},
	noteType[0].onMiss
)
noteType[8] = new note(
	"Bouns Note",
	"It's time for a caddicarus BOUNS ROUND!",
	spr_note_bonus,
	function(_timing,_note){
		var _hit = global.noteType[0].onHit(_timing,_note)
		_note[noteData.wasHit]=false
		return _hit
	},
	noteType[0].draw,
	function(){
		_note[noteData.wasHit]=true
		_note[noteData.holdHasMissed]=true
	}
)
noteType[9] = new note(
	"Holy Note",
	"Gives 0.1 misses on hit but takes away 3 misses on miss",
	spr_note_holy,
	function(_timing,_note){
		var _hit = global.noteType[0].onHit(_timing,_note)
		global.currentCharacter.missesLeft+=0.1
		if(global.currentCharacter.missesLeft>global.currentCharacter.misses)
		{
			global.currentCharacter.missesLeft = global.currentCharacter.misses
		}
		return _hit
	},
	noteType[0].draw,
	function(_timing,_note,_lanesHit){
		global.currentCharacter.missesLeft-=2
		return global.noteType[0].onMiss(_timing,_note,_lanesHit)
	}
)