extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var footstep_audio = $FootstepAudio
var isMoving = false

const SPEED = 300.0

func _ready():
	$Label.text = GameData.username

# Character direction
# 0 is up, 1 is down, 2 is right, 3 is left
var characterDirection = 0

func _physics_process(delta):
		#Animation
	if (velocity.x > 1):
		sprite_2d.animation = "Right"
		characterDirection = 2
	elif (velocity.x < -1):
		sprite_2d.animation = "Left"
		characterDirection = 3
	elif (velocity.y > 1):
		sprite_2d.animation = "Down"
		characterDirection = 1
	elif (velocity.y < -1):
		sprite_2d.animation = "Up"
		characterDirection = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_axis("Left", "Right")
	var directionY = Input.get_axis("Up", "Down")
	var nowMoving = false # c nowMoving
	
	if directionX:
		velocity.x = directionX * SPEED
		nowMoving = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if directionY:
		velocity.y = directionY * SPEED
		nowMoving = true
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if nowMoving:
		if not isMoving:
			# when starting to move
			isMoving = true
			footstep_audio.play()
	elif isMoving:
		# when starting to not move
		isMoving = false
		footstep_audio.stop()
		
		# 0 is up, 1 is down, 2 is right, 3 is left
		if (characterDirection == 0):
			sprite_2d.animation = "Up_Idle"
		elif (characterDirection == 1):
			sprite_2d.animation = "Down_Idle"
		elif (characterDirection == 2):
			sprite_2d.animation = "Right_Idle"
		elif (characterDirection == 3):
			sprite_2d.animation = "Left_Idle"
			
	
	move_and_slide()

func _on_footstep_audio_finished():
	# loop audio
	if isMoving:
		footstep_audio.play()
