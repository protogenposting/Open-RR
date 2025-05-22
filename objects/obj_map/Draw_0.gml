for(var i = 0; i < array_length(global.nodes); i++)
{
	for(var o = 0; o < array_length(global.nodes[i]); o++)
	{
		draw_sprite(spr_node,global.nodes[i][o].type,global.nodes[i][o].x,global.nodes[i][o].y)
		
		var _hasMouseInside = point_in_rectangle(
			mouse_x,
			mouse_y,
			global.nodes[i][o].x-32,
			global.nodes[i][o].y-32,
			global.nodes[i][o].x+32,
			global.nodes[i][o].y+32
		)
		
		if(global.nodes[i][o].type==nodeTypes.song)
		{
			if(_hasMouseInside)
			{
				var _name = global.nodes[i][o].data
			
				var _lastSlash = string_last_pos("/",_name)
			
				_name = string_copy(_name,_lastSlash+1,99999)
			
				draw_text(global.nodes[i][o].x,global.nodes[i][o].y+64,_name)
			}
			
			draw_text(global.nodes[i][o].x,global.nodes[i][o].y,string(global.nodes[i][o].songFile.difficulty))
		}
		
		if(
			global.currentCharacter.layer==i-1&&
			_hasMouseInside&&
			mouse_check_button_pressed(mb_left)&&
			canMove
		)
		{
			timeUntilTransition = transitionTime
		
			lastNode = currentNode
		
			global.currentCharacter.layer = i
		
			global.currentCharacter.position = o
			
			canMove = false
			
			instance_destroy(obj_shop)
		}
	}
}

draw_sprite(global.currentCharacter.sprite,0,playerX,playerY)