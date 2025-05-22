var _size = 128
var _x = screenWidth/2 - _size
var _y = screenHeight/3

draw_text(_x,_y-64,"Shop!")

for(var i=0;i<array_length(itemChoices);i++)
{
	draw_sprite(spr_note_button,0,_x,_y)
	draw_sprite(global.itemTypes[itemChoices[i]].sprite,0,_x,_y)
	draw_text(_x,_y,global.itemTypes[itemChoices[i]].name)
	draw_text(_x-32,_y-32,string(global.itemTypes[itemChoices[i]].cost))
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
		draw_text_ext(screenWidth/2,_y+64,global.itemTypes[itemChoices[i]].description,32,screenWidth/2)
		if(mouse_check_button_pressed(mb_left))
		{
			if(global.currentCharacter.money>=global.itemTypes[itemChoices[i]].cost)
			{
				global.currentCharacter.money-=global.itemTypes[itemChoices[i]].cost
				
				var _newItem = item_clone(itemChoices[i])
				
				_newItem.slot = array_length(global.currentCharacter.items)
				
				array_push(global.currentCharacter.items,_newItem)
				audio_play_sound(snd_slap,1000,false)
				global.itemTypes[itemChoices[i]].onCollect()
				array_delete(itemChoices,i,1)
				break;
			}
		}
	}
	_x += _size
}

if(global.currentCharacter.rerollsLeft<=0)
{
	menuContainer.buttons[0].position.y=200000
}
else
{
	menuContainer.buttons[0].position.y=screenHeight-64
}

menuContainer.Draw()