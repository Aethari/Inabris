## Trigger event handling singleton. This does not listen for
## events, but merely provides a global space for implementations
## of the events. In other words, this executes the trigger,
## while the [Trigger] class listens for the triggers.
extends Node

func run(key : int, a : Variant):
	match key:
		-1:
			print("Debug trigger 1")
		1:
			Inventory.remove_item(a)
