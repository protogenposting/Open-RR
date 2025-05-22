reset_characters()

menuContainer = new MenuContainer()

global.characterSelected = -4

var _x = 64
var _y = 64
var _size = 64
for(var i = 0; i < array_length(global.characters); i++)
{
	var _button = menuContainer.AddButton(
		global.characters[i].name,
		global.characters[i].sprite,
		{x: _x,y: _y},
		{x: _size,y: _size},
		function(){
			set_character(global.characters[global.characterSelected])
			var _inst = instance_create_depth(0,0,depth-1000,obj_transition)
			_inst.roomToGoTo = rm_map
			audio_play_sound(snd_select,1000,false)
		}
	)
	with(_button)
	{
		characterID = i
		OnHover = function(){
			global.characterSelected = characterID
		}
	}
	_y+=_size*1.5
	if(_y>screenHeight-64)
	{
		_y = 64
		_x+=_size*3
	}
}