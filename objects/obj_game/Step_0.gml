timeUntilNextTick-=delta_time/1000

textAlpha-=delta_time/1000000

if(timeUntilNextTick<=0)
{
	ticks--
	if(displayingScore&&ticks>=0)
	{
		audio_play_sound(snd_slap,1000,false)
		timeUntilNextTick = timeBetweenTicks
	}
	textAlpha = 1
	if(starting)
	{
		audio_play_sound(tickSFX[ticks],1000,false)
		timeUntilNextTick = timeBetweenTicks
		if(ticks<=1)
		{
			music = audio_play_sound(musicStream,1000,false)
			starting = false
			global.currentCharacter.onSongStart(music)
		}
	}
}

if(!starting&&!displayingScore)
{
	songMilliseconds = audio_sound_get_track_position(music)*1000
	update_sections()
	for(var i=0;i<array_length(global.currentCharacter.items);i++)
	{
		global.itemTypes[i].update()
	}
	if(!audio_is_playing(music)&&ticks<=1)
	{
		if(global.currentCharacter.missesLeft<=0)
		{
			lost = true
		}
		else
		{
			displayingScore = true
			timeUntilNextTick = timeBetweenTicks
			ticks = 4
		}
	}
}

if(global.currentCharacter.missesLeft<=0)
{
	audio_stop_sound(music)
}