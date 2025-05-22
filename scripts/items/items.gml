enum shopTypes{
	normal
}

function item(_name,_description,_sprite,_cost,_shop,_onCollect=function(){},_update=function(){},_onSongEnd=function(){}) constructor
{
	name = _name
	description = _description
	sprite = _sprite
	cost = _cost
	shop = _shop
	onCollect = _onCollect
	update = _update
	onSongEnd = _onSongEnd
}

function item_clone(_id)
{
	return new item(
		global.itemTypes[_id].name,
		global.itemTypes[_id].description,
		global.itemTypes[_id].sprite,
		global.itemTypes[_id].cost,
		global.itemTypes[_id].onCollect,
		global.itemTypes[_id].update,
		global.itemTypes[_id].onSongEnd
	)
}

itemTypes[0] = new item(
	"Soothing Tunes",
	"Heals 3 misses back!",
	spr_item_placeholder,
	5,
	shopTypes.normal,
	function(){
		global.currentCharacter.missesLeft += 3
		if(global.currentCharacter.missesLeft > global.currentCharacter.misses)
		{
			global.currentCharacter.missesLeft = global.currentCharacter.misses
		}
	}
)

itemTypes[1] = new item(
	"Melodic Reverberations",
	"Slowly gain health back during a song",
	spr_item_placeholder,
	33,
	shopTypes.normal,
	function(){},
	function(){
		global.currentCharacter.missesLeft += delta_time/100000
		if(global.currentCharacter.missesLeft > global.currentCharacter.misses)
		{
			global.currentCharacter.missesLeft = global.currentCharacter.misses
		}
	}
)

itemTypes[2] = new item(
	"New Life",
	"You will get all your health back after diying! Can only be used once.",
	spr_item_placeholder,
	125,
	shopTypes.normal,
	function(){},
	function(){
		try{
			if(wasUsed)
			{
				return 0
			}
		}
		catch(e)
		{
			
		}
		if(global.currentCharacter.missesLeft<=0)
		{
			global.currentCharacter.missesLeft=global.currentCharacter.misses
			wasUsed = true
		}
	}
)

itemTypes[3] = new item(
	"Chaos Chaos!",
	"Add another random note type to your deck",
	spr_item_placeholder,
	30,
	shopTypes.normal,
	function(){},
	function(){
		
	}
)

itemTypes[4] = new item(
	"Dubstep Dice",
	"+1 shop reroll!",
	spr_item_placeholder,
	100,
	shopTypes.normal,
	function(){
		global.currentCharacter.rerollsLeft+=1	
	},
	function(){}
)