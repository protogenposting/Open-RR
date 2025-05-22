itemChoices = []

shopType = shopTypes.normal

function reroll()
{
	for(var i = 0; i < 3; i++)
	{
		itemChoices[i] = irandom(array_length(global.itemTypes)-1)
		if(global.itemTypes[itemChoices[i]].shop != shopType)
		{
			i--
			continue;
		}
		for(var o = 0; o < array_length(itemChoices)-1; o++)
		{
			if(itemChoices[i]==itemChoices[o])
			{
				i--
				break;
			}
		}
	}
}

menuContainer = new MenuContainer()

menuContainer.AddButton(
	"Reroll",spr_button,
	{x:screenWidth/2,y:screenHeight-64},
	{x:128,y:64},
	function()
	{
		if(global.currentCharacter.rerollsLeft > 0)
		{
			with(obj_shop)
			{
				reroll()
			}
			global.currentCharacter.rerollsLeft--
		}
	}
)

reroll()