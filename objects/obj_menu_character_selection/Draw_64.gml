menuContainer.Draw()

var _x = screenWidth / 1.3
var _y = screenHeight / 3

draw_sprite(spr_note_button,0,_x,_y)

if(global.characterSelected!=-4)
{
	var _character = global.characters[global.characterSelected]
	draw_text(_x,_y-32,_character.name)
	draw_sprite(_character.sprite,0,_x,_y)
	_y+=64
	draw_text_ext(_x,_y,_character.description,32,400)
	_y+=96
	draw_text(_x,_y,"Misses: "+string(_character.misses))
}