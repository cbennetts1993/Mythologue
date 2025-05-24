class_name Myth
extends Resource

@export var name: String

@export var myth_teller_introductions: Array[String]

func get_introduction() -> String:
	if myth_teller_introductions.is_empty(): return ""
	return myth_teller_introductions.pick_random()


@export var myth_teller_question_introductions: Array[String]

func get_question_introduction() -> String:
	if myth_teller_question_introductions.is_empty(): return ""
	return myth_teller_question_introductions.pick_random()

@export var positive_reaction: String
@export var negative_reaction: String


## MythSegments that make up the myth as it is presented to the player.
@export var myth_base: Array[MythSegment]


## Returns the full text of the myth.
var text: String:
	get = _get_full_text

func _get_full_text() -> String:
	var text: String = ""
	for segment in myth_base:
		text += segment.text
	return text


## How different the myth is syntactically from its original.
var divergence: float:
	get = _get_divergence

func _get_divergence() -> float:
	var total_divergence: float = 0
	for segment in myth_base:
		total_divergence += segment.divergence
	return total_divergence / myth_base.size()


## the number of generations(ie. questions) that the myth has undergone
@export var generations: int:
	get = _get_generations

func _get_generations() -> int:
	var total_generations: int = 0
	for segment in myth_base:
		total_generations += segment.divergence_history.size()
	return total_generations


## returns a random segment of the myth
var random_segment: MythSegment:
	get = _get_random_segment

func _get_random_segment() -> MythSegment:
	return myth_base.pick_random()
