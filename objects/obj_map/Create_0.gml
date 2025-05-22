enum nodeTypes{
	none,
	song,
	noteChoice,
	shop
}

randomize()

show_debug_message("seed: "+string(random_get_seed()))

function node(_x,_y,_type,_data) constructor
{
	x = _x
	
	y = _y
	
	type = _type
	
	data = _data
}

global.nodes = [
	[new node(screenWidth/2,screenHeight-128,nodeTypes.none,"")],
]

var _last = 0
repeat(20)
{
	var _currentType = nodeTypes.song
	var _newLayer = []
	var _songs = 3
	var _x = screenWidth/2 - 128 * floor(_songs/2)
	var _lastSong = ""
	repeat(_songs)
	{
		var _y = global.nodes[_last][0].y - 128 + random_range(-15,15)
		
		var _song = global.songs[irandom(array_length(global.songs)-1)]
		
		var _songIsNew = false
		while(!_songIsNew&&array_length(_newLayer)!=0)
		{
			_song = global.songs[irandom(array_length(global.songs)-1)]
			for(var i=0;i<array_length(_newLayer);i++)
			{
				if(_newLayer[i].data==_song)
				{
					_songIsNew = false
					break;
				}
				if(i==array_length(_newLayer)-1)
				{
					_songIsNew = true
				}
			}
		}
		
		var _node = new node(_x,_y,_currentType,_song)
		
		_node.songFile = load_file(_song+"/data.json")
		
		array_push(_newLayer,_node)
		
		_x+=128
	}
	array_push(global.nodes,_newLayer)
	
	_last++
	
	var _y = global.nodes[_last][0].y - 128 + random_range(-15,15)
	
	_x = screenWidth/2
	
	var _node = [new node(_x,_y,nodeTypes.noteChoice,"")]
	
	array_push(global.nodes,_node)
	
	_last++
	
	_y = global.nodes[_last][0].y - 128 + random_range(-15,15)
	
	if(irandom(10)>=5)
	{
		_node = [new node(_x,_y,nodeTypes.shop,"")]
	
		array_push(global.nodes,_node)
	
		_last++
	}
}

timeUntilTransition = 0

transitionTime = 60

isTransitioning = false

lastNode = global.nodes[global.currentCharacter.layer][global.currentCharacter.position]

currentNode = global.nodes[global.currentCharacter.layer][global.currentCharacter.position]

playerX = 0

playerY = 0

canMove = true