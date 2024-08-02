extends CheckButton

@export var num: int


func _ready():
	self.text = str(num)


func _process(_delta):
	pass
