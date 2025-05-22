global.songs = []

var _file=file_find_first(working_directory+"/"+"songs/*",fa_directory)

while(_file!="")
{
	array_push(global.songs,working_directory+"/"+"songs/"+_file)
	_file = file_find_next()
}

file_find_close()