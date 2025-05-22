function MenuButton(_text,_sprite,_position,_size,_func) constructor
{
	text = _text
	sprite = _sprite
	position = _position
	size = _size
	func = _func
	DetectClicks = function(){
		var _hasMouseInside = point_in_rectangle(
			device_mouse_x_to_gui(0),
			device_mouse_y_to_gui(0),
			position.x-size.x/2,
			position.y-size.y/2,
			position.x+size.x/2,
			position.y+size.y/2
		)
		if(_hasMouseInside)
		{
			OnHover()
		}
		if(_hasMouseInside&&mouse_check_button_pressed(mb_left))
		{
			func()
		}
	}
	OnHover = function()
	{
		
	}
	Draw = function(){
		draw_sprite(sprite,0,position.x,position.y)
		draw_text(position.x,position.y,text)
		DetectClicks()
	}
}

function MenuContainer() constructor
{
	buttons = []
	Draw = function(){
		for(var i=0;i<array_length(buttons);i++)
		{
			with(buttons[i])
			{
				Draw()
			}
		}
	}
	AddButton = function(_text,_sprite,_position,_size,_func){
		var _button = new MenuButton(_text,_sprite,_position,_size,_func)
		array_push(buttons,_button)
		return _button
	}
}