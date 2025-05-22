enum noteData{
	time,
	row,
	length,
	type,
	wasHit,
	holdHasMissed
}

musicStream = audio_create_stream(global.currentSongFolder+"/song.ogg")

songData = load_file(global.currentSongFolder+"/data.json")

usingVideo=false

struct = songData.song

currentSection = 0

loadedNotes = []

bpm = 120

function update_sections()
{	
	loadedNotes = []
	
	var _sections = struct.notes
	
	if(currentSection>=array_length(_sections))
	{
		return 0
	}
	
	while(array_length(_sections[currentSection].sectionNotes)==0)
	{
		currentSection++
		if(currentSection>=array_length(_sections))
		{
			return 0
		}
	}
	
	if(variable_struct_exists(_sections[currentSection],"bpm"))
	{
		bpm =_sections[currentSection].bpm
	}
	
	var _endGoal = min(array_length(_sections)-1,sectionsToLoad + currentSection)
	
	for(var i = currentSection;i < _endGoal; i++)
	{
		var _notes = _sections[i].sectionNotes
		
		for(var o = 0; o < array_length(_notes); o++)
		{
			if(array_length(_notes[o])<=4)
			{
				while(_notes[o][noteData.row]>3)
				{
					_notes[o][noteData.row]-=4
				}
				var _noteChance = (global.currentCharacter.layer/20)*100
				_notes[o][noteData.type] = global.currentCharacter.notes[0]
				if(irandom(100)<_noteChance&&array_length(global.currentCharacter.notes)>1)
				{
					_notes[o][noteData.type] = global.currentCharacter.notes[irandom(array_length(global.currentCharacter.notes)-2)+1]
				}
				_notes[o][noteData.wasHit] = false
				_notes[o][noteData.holdHasMissed] = false
			}
			array_push(loadedNotes,_notes[o])
		}
	}
	
	var _unhitNotes = 0
	
	for(var i=0;i<array_length(_sections[currentSection].sectionNotes);i++)
	{
		if(!_sections[currentSection].sectionNotes[i][noteData.wasHit])
		{
			_unhitNotes++
		}
	}
	
	if(_unhitNotes<=0)
	{
		currentSection++
	}
}

timeBetweenTicks = 1000

timeUntilNextTick = timeBetweenTicks

ticks = 4

starting = true

music = -4

songMilliseconds = 0

tickMessages = ["","GO!","1","2","3"]

tickSFX = [-4,snd_tick_go,snd_tick_1,snd_tick_2,snd_tick_3]

barLocation = screenHeight - 64

textAlpha = 0

speedScale = 0.3

accuracy = 100

lanesHit = [false,false,false,false]

accuracyMessage = ""

displayingScore = false

lost = false

audio_play_sound(tickSFX[ticks],1000,false)

update_sections()

if(file_exists(global.currentSongFolder+"/video.mp4"))
{
	video_open(global.currentSongFolder+"/video.mp4")

	var _format = video_get_format();
	if (_format == video_format_yuv)
	{
	    videoChromaSampler = shader_get_sampler_index(shader_YUV, "v_chroma");
		show_debug_message("LINUX BASED")
	}
	
	usingVideo=true
}