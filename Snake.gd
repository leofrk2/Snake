extends Area2D

var move_delay = 0.35 # Délai entre chaque mouvement
var time_since_last_move = 0.0 # Temps écoulé depuis le dernier mouvement
var direction = Vector2.ZERO # Direction du mouvement
var size = 0.0
var can_move = true

var snake_size = 32
var stone_size = 64


var queue_length = 2
var queue = []

func _ready():
    print("uwu")
    # Initialisation de la direction de manière aléatoire

    var rng = RandomNumberGenerator.new()
    rng.randomize() # Assurez-vous d'appeler randomize pour obtenir des résultats différents à chaque fois
    var rdm = rng.randi_range(1, 4)
    # Position in the grid : 4 X 32 + 64 + 16
    var position_grid_x = (position.x - (snake_size / 2) - stone_size) / snake_size
    var position_grid_y = (position.y - (snake_size / 2) - stone_size) / snake_size

    match rdm:
        1: 
            direction = Vector2.UP
        2: 
            direction = Vector2.RIGHT
        3: 
            direction = Vector2.DOWN
        4: 
            direction = Vector2.LEFT
            


func _process(delta):
    time_since_last_move += delta

    # Mise à jour de la direction basée sur l'input utilisateur
    if Input.is_action_pressed("right") && direction != Vector2.LEFT:
        direction = Vector2.RIGHT
    elif Input.is_action_pressed("left") && direction != Vector2.RIGHT:
        direction = Vector2.LEFT
    elif Input.is_action_pressed("down") && direction != Vector2.UP:
        direction = Vector2.DOWN
    elif Input.is_action_pressed("up") && direction != Vector2.DOWN:
        direction = Vector2.UP
    
    # Déplace le serpent après un délai si la partie n'est pas fini pour ce joueur
    if can_move:
        if time_since_last_move > move_delay:
            move_snake()
            time_since_last_move = 0
            

func move_snake():
    var old_head_position = position
    position += direction * snake_size

    # Déplace chaque segment de la queue
    if queue.size() > 0:
        # Déplace le dernier segment à l'ancienne position de la tête
        var last_position = old_head_position
        for i in range(queue.size()):
            var temp_position = queue[i].position
            queue[i].position = last_position
            last_position = temp_position
    

    
func get_direction():
    return direction
