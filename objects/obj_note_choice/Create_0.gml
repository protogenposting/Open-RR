noteChoices = []

for(var i = 0; i < 3; i++)
{
	noteChoices[i] = irandom(array_length(global.noteType)-2)+1
	for(var o = 0; o < array_length(noteChoices)-1; o++)
	{
		if(noteChoices[i]==noteChoices[o])
		{
			i--
			break;
		}
	}
}