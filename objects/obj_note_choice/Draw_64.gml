var _size = 128
var _x = screenWidth/2 - _size
var _y = screenHeight/3

draw_text(_x,_y-64,"Choose a note to add to your deck...")

for(var i=0;i<array_length(noteChoices);i++)
{
	draw_sprite(spr_note_button,0,_x,_y)
	draw_sprite(global.noteType[noteChoices[i]].sprite,0,_x,_y)
	draw_text(_x,_y,global.noteType[noteChoices[i]].name)
	var _isInside = point_in_rectangle(
		device_mouse_x_to_gui(0),
		device_mouse_y_to_gui(0),
		_x-32,
		_y-32,
		_x+32,
		_y+32
	)
	if(_isInside)
	{
		draw_text_ext(screenWidth/2,_y+64,global.noteType[noteChoices[i]].description,32,screenWidth/2)
		if(mouse_check_button_pressed(mb_left))
		{
			array_push(global.currentCharacter.notes,noteChoices[i])
			audio_play_sound(snd_slap,1000,false)
			obj_map.canMove = true
			obj_map.isTransitioning = false
			instance_destroy()
		}
	}
	_x += _size
}