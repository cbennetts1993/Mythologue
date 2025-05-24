extends Node

const python_environment_path: = "python/mythologue.exe"
#"python_environment/venv/Scripts/python.exe"
const python_script_path:  = "python_environment/mythologue.py"


signal similarity_check_completed
signal similarity_check_failed

var python_env: = ProjectSettings.globalize_path("res://" + python_environment_path)
var script_path: = ProjectSettings.globalize_path("res://" + python_script_path)

var directory_path: = OS.get_executable_path().get_base_dir()

enum ErrorCode {
	FAILED = -1
}


func _ready():
	if OS.has_feature("release"):
		python_env = directory_path.path_join(python_environment_path)
		script_path = directory_path.path_join(python_script_path)


## Starts a new process thread for the similarity check in python
func new_similarity_thread(sentence1: String, sentence2: String):
	var new_thread: = Thread.new()
	var output = []
	print("check")
	new_thread.start(_run_sentence_similarity.bind(sentence1, sentence2, output))



## The running code for a similarity check
func _run_sentence_similarity(sentence1: String, sentence2: String, output: Array):
	#var time = Time.get_ticks_msec() ## Debugging
	
	#var process_id = OS.execute(python_env, [script_path, sentence1, sentence2], output)
	var process_id = OS.execute(python_env, [sentence1, sentence2], output)
	print(process_id, " = ",output)
	if output.is_empty():
		_emit_check_failed.call_deferred()
		return ErrorCode.FAILED
	
	#print(Time.get_ticks_msec() - time) ## Debugging
	var result = float(output[0])
	_emit_check_completed.call_deferred(result)
	return result


## emits the completed signal when a similarity check is completed
func _emit_check_completed(result: float):
	print(result)
	similarity_check_completed.emit(result)



func _emit_check_failed():
	similarity_check_failed.emit()
