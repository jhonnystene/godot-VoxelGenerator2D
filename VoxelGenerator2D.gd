extends Node2D

var viewDistance = 32

var noise = OpenSimplexNoise.new()
var block = load("res://Block.tscn")

func _ready():
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 20.0
	noise.persistence = 0.8
	
func _process(delta):
	# Despawn all blocks
	var BlockManager = get_node("BlockManager")
	for child in BlockManager.get_children():
		child.queue_free()
	
	# Despawn enemies
	var followObject = get_node("FollowObject")
	
	# Load 14 blocks either side of the player
	for i in range(-viewDistance, viewDistance):
		generate(round(followObject.position.x / 20) + i)

func putBlockAt(x, y, blockType=0):
	var blockInstance = block.instance()
	
	# Place block
	blockInstance.set_transform(Transform2D(0, Vector2(x, y)))
	get_node("BlockManager").add_child(blockInstance)

func generate(x):
	var playerObject = get_node("Player")
	# Get line height
	var blockHeight = round(noise.get_noise_2d(x, 1) * 10)
	putBlockAt((x * 20) + 10, blockHeight * 20) # Place a grass block