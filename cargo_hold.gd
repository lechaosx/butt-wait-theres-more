class_name CargoHold extends Node

signal cargo_updated

var cargo: int = 0

func add_cargo(cnt: int) -> void:
	cargo += cnt
	cargo_updated.emit()
