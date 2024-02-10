extends Node

var delay_between_food = 2
var is_food_eaten = true
var time_since_last_food_eaten = 0.0

var snake_size = Vector2(32, 32)  # Taille du snake
var currentFoodArea = 0
var length = 4
var queue = []
var head = 0
var snake = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    # Add a snake at a random place
    # Window size: 1024 * 1024
    # Border: 64 * 64
    # Grass size: 896 * 896
    # Snake size : 32 * 32

    # Chemin vers la scène à instancier
    var scene_path = "res://Snake.tscn"
    # Charger la scène
    var scene_to_instance = load(scene_path)
    # Créer une instance de la scène
    var instance = scene_to_instance.instantiate()  # Correction ici: instance() au lieu de instantiate()

    var game_area_size = Vector2(896, 896)  # Taille du terrain de jeu
    var grid_width = int(game_area_size.x / snake_size.x)
    var grid_height = int(game_area_size.y / snake_size.y)
    
    # Générer des positions aléatoires sur la grille
    var random_x = randi() % grid_width
    var random_y = randi() % grid_height
    
    while random_x < 8 or random_x > 21:
        random_x = randi() % grid_width
    
    while random_y < 8 or random_y > 21:
        random_y = randi() % grid_height
    
    # Calculer la position en pixels, en tenant compte de la bordure
    # +32 pour centrer dans le carré de 64x64 de la bordure
    var pixel_position = Vector2(random_x * snake_size.x + 64 + snake_size.x / 2, random_y * snake_size.y + snake_size.y / 2 + 64)

    # Définir la position de l'instance
    instance.position = pixel_position
    snake = instance
    # Ajouter l'instance à l'arbre de scène
    add_child(instance)
    
    for i in length:
        var el = Area2D.new()
        add_child(el)
        var sprite = Sprite2D.new()
        sprite.texture = preload("res://asset/snake_body.webp")
        el.add_child(sprite)
        queue.push_back(el)
        

    instance.connect("body_entered", head_collision)

    match instance.get_direction():
        Vector2.UP:
            for i in length:
                queue[i].position = instance.position
                queue[i].position.y += i * snake_size.x
        Vector2.DOWN:
            for i in length:
                queue[i].position = instance.position
                queue[i].position.y -= i * snake_size.x
        Vector2.LEFT:
            for i in length:
                queue[i].position = instance.position
                queue[i].position.x += i * snake_size.x
        Vector2.RIGHT:
            for i in length:
                queue[i].position = instance.position
                queue[i].position.y -= i * snake_size.x
            
    instance.queue = queue


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    # Check if the snake is eating himself
    
    for i in queue:
        if i != queue[0]:
            if snake.position == i.position:
                _on_area_2d_body_entered()
    
    if is_food_eaten:
        time_since_last_food_eaten += delta
    
        if time_since_last_food_eaten > delay_between_food:
            time_since_last_food_eaten = 0
            add_food()
            
            

func head_collision(Body):
    print("HEAD : ")
    print(Body)
    _on_game_area_area_exited()
    

func add_food():
    print("Add food")
    
    is_food_eaten = false
    
    # Add a random food
    # Charger la scène
    var food = Area2D.new()

    currentFoodArea = food	
    var collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.extents = Vector2(1, 1)
    
    collision.shape = shape
    

    
    food.add_child(collision)
    add_child(food)
    
    food.connect("area_entered", eat_food)

    #collision.connect("ready", eat_food)

    
    var sprite = Sprite2D.new()

    sprite.texture = preload("res://asset/apple.png")
    food.add_child(sprite)

    
    var game_area_size = Vector2(896, 896)  # Taille du terrain de jeu
    var grid_width = int(game_area_size.x / snake_size.x)
    var grid_height = int(game_area_size.y / snake_size.y)
    
    # Générer des positions aléatoires sur la grille
    var random_x = randi() % grid_width
    var random_y = randi() % grid_height
    
    while random_x < 3 or random_x > 26:
        random_x = randi() % grid_width
    
    while random_y < 3 or random_y > 26:
        random_y = randi() % grid_height
    
    var pixel_position = Vector2(random_x * snake_size.x + 64 + snake_size.x / 2, random_y * snake_size.y + snake_size.y / 2 + 64)
    food.position = pixel_position
    
func eat_food(Body):
    #Increase speed
    
    snake.move_delay -= 0.01
    
    print("Food eaten")
    currentFoodArea.queue_free()
    currentFoodArea.disconnect("area_entered", eat_food)
    var fst = Area2D.new()
    fst.position = Vector2(-100, -100)
    
    fst.connect("body_entered", _on_area_2d_body_entered)

    add_child(fst)

    
    var spriteFst = Sprite2D.new()

    spriteFst.texture = preload("res://asset/snake_body.webp")
    fst.add_child(spriteFst)

    queue.push_back(fst)
    is_food_eaten = true
    

func _on_game_area_area_exited():
    print('Game loosed')
    
    # On affiche le game over
    $Label.visible = true
    
    # On stop l'autre script : 
    $Snake.can_move = false

    #quit_game()

func _on_area_2d_body_entered():
    print('Game loosed')
    
    # On affiche le game over
    $Label.visible = true
    
    # On stop l'autre script : 
    $Snake.can_move = false
    
    #quit_game()
    
func quit_game():
    get_tree().quit()
