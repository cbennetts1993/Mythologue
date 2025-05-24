extends Node

var save_directory: = OS.get_executable_path().get_base_dir().path_join("Myths")
var internal_myth_directory: = "res://media/Myths/"


var mythDB: Array[Myth] = []


func _ready():
	if !save_directory_exists():
		initialize_save_directory()
	
	var directory = DirAccess.open(save_directory)
	var files = directory.get_files()
	for f in files:
		var myth = load_myth(save_directory.path_join(f))
		if myth:
			mythDB.append(myth)


func save_directory_exists() -> bool:
	return DirAccess.dir_exists_absolute(save_directory)



func initialize_save_directory():
	DirAccess.make_dir_recursive_absolute(save_directory)
	
	var directory: = DirAccess.open(internal_myth_directory)
	var files = directory.get_files()
	
	for f in files:
		var myth = load_myth(internal_myth_directory.path_join(f))
		if myth and save_directory_exists():
			save_myth(myth, save_directory.path_join(f))



func save_myth(myth: Myth, path: String = ""):
	ResourceSaver.save(myth, path)
	#print("saved ", myth, "at path ", path)



func load_myth(path: String) -> Myth:
	var myth = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	#print("loaded ", myth, " at path ", path)
	return myth
