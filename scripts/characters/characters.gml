enum genres{
	none,
	lofi,
	ambient,
	JESUS
}

function character(_name,_description,_sprite,_misses,_favoriteGenre,_startingNotes = [0],_startingItems = [],_onSongEnd = function(_moneyGained){return _moneyGained},_onSongStart = function(_song){}) constructor{
	name = _name
	misses = _misses
	sprite = _sprite
	description = _description
	startingNotes = _startingNotes
	startingItems = _startingItems
	onSongEnd = _onSongEnd
	onSongStart = _onSongStart
}

function reset_characters()
{
	global.characters = []

	array_push(global.characters,
		new character("Matthew","A basic guy.",spr_matthew,30,genres.none,[0])
	)
	array_push(global.characters,
		new character("Cassy","More health, gains hp at the end of songs, gains less money.",
		spr_cassy,45,genres.lofi,[0],[],
		function(_moneyGained){
			_moneyGained/=2
			global.currentCharacter.missesLeft+=3
			return _moneyGained
		})
	)
	array_push(global.characters,
		new character("Crazy Shuffler","Starts with a shop reroll and Double Time notes",spr_cassy,20,genres.JESUS,[2],[item_clone(4)])
	)
	array_push(global.characters,
		new character("Fidget","Starts with worm and heal notes, gains more money per song.",
		spr_cassy,25,genres.ambient,[3,5],[],
		function(_moneyGained){
			_moneyGained*=1.7
			return _moneyGained
		})
	)
	array_push(global.characters,
		new character("Depressed Child","Starts with ghost notes, increases song speed, gains more MUCH money per song.",
		spr_cassy,10,genres.ambient,[7],[],
		function(_moneyGained){
			_moneyGained*=3
			return _moneyGained
		},
		function(_song)
		{
			audio_sound_pitch(_song,1.1)
		}
		)
	)
	array_push(global.characters,
		new character("JESUS H CHRIST","HOLY CARP IT'S JEBUS",spr_cassy,9,genres.JESUS,[9])
	)
}

global.currentCharacter = {}

function set_character(_character)
{
	var _struct = {}
	_struct.misses = _character.misses
	_struct.sprite = _character.sprite
	_struct.missesLeft = _character.misses
	_struct.name = _character.name
	_struct.notes = _character.startingNotes
	_struct.items = _character.startingItems
	_struct.onSongEnd = _character.onSongEnd
	_struct.onSongStart = _character.onSongStart
	_struct.position = 0
	_struct.layer = 0
	_struct.money = 0
	_struct.rerollsLeft = 0
	
	global.currentCharacter = _struct
	
	for(var i=0;i<array_length(_struct.items);i++)
	{
		_struct.items[i].onCollect()
	}
}