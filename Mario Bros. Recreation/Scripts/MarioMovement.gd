extends CharacterBody2D

@onready var MarioSprites = $MarioSprites

const ACCELLERATION = 10.0
const TOP_SPEED = 100
const TOP_SPEED_RUNNING = 200
const JUMP_VELOCITY = -350.0
var speed = 0
var direction = 1  # 1 for right, -1 for left

var can_jump = true
var is_walking = false
var is_running = false
var walking_left = false
var walking_right = false

var curState = "Small"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor():
        velocity.y += gravity * delta
        
    if is_on_floor():
        can_jump = true

    # Handle jump.
    if Input.is_action_just_pressed("Jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY
        can_jump = false
        
    if Input.is_action_just_released("Jump") and !is_on_floor() and !can_jump:
        velocity.y += (gravity * delta) * 2

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction = Input.get_axis("WalkLeft", "WalkRight")




    move_and_slide()
    check_inputs()
    do_movements()
    do_anims()

func do_movements():
    if is_running == false:
        if speed <= TOP_SPEED and direction == 1:
            speed += ACCELLERATION
            velocity.x = speed
        elif speed <= TOP_SPEED and direction == -1:
            speed += ACCELLERATION
            velocity.x = -speed
        elif speed >= TOP_SPEED and is_walking == true:
            speed -= ACCELLERATION
        elif speed != 0 and is_walking == false and is_on_floor():
            speed -= ACCELLERATION
            if speed < 0:
                speed = 0
            velocity.x = direction * speed
    else:
        if speed <= TOP_SPEED_RUNNING and direction == 1:
            speed += ACCELLERATION
            velocity.x = speed
        elif speed <= TOP_SPEED_RUNNING and direction == -1:
            speed += ACCELLERATION
            velocity.x = -speed
        elif speed >= 0 and is_walking == false and is_on_floor():
            speed -= ACCELLERATION
            if speed < 0:
                speed = 0
            velocity.x = direction * speed

func do_anims():
    if Input.is_action_pressed("Crouch") and is_on_floor():
        MarioSprites.play("crouch" + curState)
    if Input.is_action_pressed("WalkLeft") and is_on_floor():
        MarioSprites.flip_h = true
    if Input.is_action_pressed("WalkRight") and is_on_floor():
        MarioSprites.flip_h = false
    if is_walking == true:
        MarioSprites.play("walk" + curState)
    if is_walking == false:
        MarioSprites.play("stand" + curState)
    if not is_on_floor():
        MarioSprites.play("jump" + curState)

func check_inputs():
    if Input.is_action_pressed("WalkLeft"):
        is_walking = true
        if is_on_floor():
            direction = -1
    elif Input.is_action_pressed("WalkRight"):
        is_walking = true
        if is_on_floor():
            direction = 1 
    else:
        direction = 0
        is_walking = false
    if Input.is_action_pressed("RunFire"):
        is_running = true
    else:
        is_running = false
