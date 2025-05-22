currentNode = global.nodes[global.currentCharacter.layer][global.currentCharacter.position]

timeUntilTransition--

var _position = move_smooth_between_points(lastNode.x,lastNode.y,currentNode.x,currentNode.y,1-(timeUntilTransition/transitionTime))

playerX = _position.x

playerY = _position.y

if(timeUntilTransition<=0&&!isTransitioning&&!canMove)
{
	if(currentNode.type==nodeTypes.song)
	{
		var _inst = instance_create_depth(0,0,depth-1000,obj_transition)
		_inst.roomToGoTo = rm_game
	
		isTransitioning = true
	
		global.currentSongFolder = currentNode.data
	}
	if(currentNode.type==nodeTypes.noteChoice)
	{
		isTransitioning = true
		var _inst = instance_create_depth(0,0,depth-1,obj_note_choice)
	}
	if(currentNode.type==nodeTypes.shop)
	{
		var _inst = instance_create_depth(0,0,depth-1,obj_shop)
		canMove = true
	}
}

camera_set_view_pos(
	view_camera[0],
	playerX-screenWidth/2,
	playerY-screenHeight/2
)