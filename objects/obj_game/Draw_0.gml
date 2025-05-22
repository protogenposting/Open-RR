if(usingVideo)
{
	video_set_volume(0)
	video_seek_to(songMilliseconds)
	var _data = video_draw();

	var videoSizeMultiplier={x:screenWidth/surface_get_width(_data[1]),y:screenHeight/surface_get_height(_data[1])}
	show_debug_message(_data[0])
	if(_data[0] == 0)
	{
		show_debug_message("yes")
		switch(video_get_format())
		{
			case video_format_rgba:
				var _surf = _data[1];
				draw_surface_ext(_surf, 0,0,videoSizeMultiplier.x,videoSizeMultiplier.y,0,c_white,1);
				break;
	
			//  #### YUV PART HERE ####
			case video_format_yuv:
				var _surf = _data[1];
				var _chromasurf = _data[2];
				if(surface_exists(_surf) and surface_exists(_chromasurf))
				{
					shader_set(shader_YUV);
			
					var _tex_id = surface_get_texture(_surf);
					var _chroma_tex_id = surface_get_texture(_chromasurf);
					texture_set_stage(videoChromaSampler, _chroma_tex_id);
					gpu_set_texfilter(false);
				
					draw_surface_ext(_surf, 0,0,videoSizeMultiplier.x,videoSizeMultiplier.y,0,c_white,1);
			
					gpu_set_texfilter(true);
					shader_reset();
				}
				break;
		}
	}
}

if(starting)
{
	draw_text(screenWidth/2,screenHeight/2,tickMessages[ticks])
}
else if(!displayingScore)
{
	draw_text(screenWidth/2,screenHeight/2,accuracyMessage)
	draw_text(screenWidth/2,screenHeight/2+64,string(accuracy)+"%")
}
var _currentLanesHit = [false,false,false,false]
for(var i = 0; i < array_length(loadedNotes); i++)
{
	var _note = loadedNotes[i]
	var _noteStruct = global.noteType[_note[noteData.type]]
	
	var _timing = _note[noteData.time]-songMilliseconds
		
	var _speed = 0.4
	
	if(_timing<-_note[noteData.length]&&_note[noteData.length]>0||_note[noteData.length]<0)
	{
		_note[noteData.holdHasMissed] = true
	}
	if(
		!_note[noteData.wasHit]&&_timing<-hitWindow&&_note[noteData.length]<=0||
		!_note[noteData.holdHasMissed]&&_note[noteData.length]>0&&!lanesHit[_note[noteData.row]]&&_timing<-hitWindow
	)
	{
		_noteStruct.onMiss(_timing,_note,lanesHit)
	}
	if(!_note[noteData.wasHit])
	{
		if(abs(_timing)<=hitWindow)
		{
			if(keyboard_check_pressed(global.noteInputs[_note[noteData.row]])&&!_currentLanesHit[_note[noteData.row]])
			{
				var _timed = _noteStruct.onHit(_timing,_note)
				
				accuracyMessage = global.timings[_timed].name
				accuracy += global.timings[_timed].accuracyBoost
				_currentLanesHit[_note[noteData.row]] = true
			}
		}
	}
	_noteStruct.draw(_timing,_note,_speed,barLocation,songMilliseconds)
}
	
for(var i = 0; i < array_length(global.noteInputs); i++)
{
	var _x = screenWidth/2 + i * 64 - 128 + 32
	var _y = barLocation
	var _size = 1
		
	if(keyboard_check(global.noteInputs[i]))
	{
		lanesHit[i] = true
	}
	else
	{
		lanesHit[i] = false
	}
		
	draw_sprite_ext(spr_note,0,_x,_y,_size,_size,0,c_white,1)
	
	if(lanesHit[i])
	{
		draw_sprite_ext(spr_note,0,_x,_y+32,0.5,0.5,0,c_white,1)
	}
		
	draw_text_color(_x,_y,get_key_name(global.noteInputs[i]),c_white,c_white,c_white,c_white,textAlpha)
}

var _x = screenWidth-128

var _y = screenHeight/1.3

draw_rectangle(_x-64,_y-256*(global.currentCharacter.missesLeft/global.currentCharacter.misses),_x,_y,false)

draw_text(_x-32,_y+32,string(global.currentCharacter.missesLeft)+"/"+string(global.currentCharacter.misses))

if(displayingScore)
{
	var _moneyGained = songData.difficulty*(accuracy/100)
	if(ticks<=3)
	{
		draw_text(screenWidth/2,screenHeight/2,"Win")
	}
	if(ticks<=2)
	{
		draw_text(screenWidth/2,screenHeight/2 + 32,"Accuracy: "+string(accuracy)+"%")
	}
	if(ticks<=1)
	{
		draw_text(screenWidth/2,screenHeight/2 + 64,"Money Gained: $"+string(_moneyGained))
	}
	if(ticks<=0)
	{
		draw_text(screenWidth/2,screenHeight/2 + 96,"Press space to continue")
		if(keyboard_check_pressed(vk_space))
		{
			with(global.currentCharacter)
			{
				_moneyGained = onSongEnd(_moneyGained)
			}
			global.currentCharacter.money+=_moneyGained
			for(var i=0;i<array_length(global.currentCharacter.items);i++)
			{
				global.itemTypes[i].onSongEnd()
			}
			room_goto(rm_map)
		}
	}
}

if(lost)
{
	draw_text(screenWidth/2,screenHeight/2,"U lose >:3")
	draw_text(screenWidth/2,screenHeight/2 + 32,"Press space to return to menu!")
	if(keyboard_check_pressed(vk_space))
	{
		room_goto(rm_menu)
	}
}