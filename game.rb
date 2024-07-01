require 'io/console'
require_relative 'map'
require_relative './game_objects/player'
require_relative './game_objects/wall'
require_relative './game_objects/border'

class Game
    # TODO: move to some actions processer
    Position = Struct.new(:row, :col)

    def initialize()
        @game_objects = {}
    end

    def add_object(obj)
        @game_objects[obj.get_id] = obj
    end

    def get_game_objects
        return @game_objects
    end

    # TODO: move to some actions processer or maybe to the game_object?
    def process_action(action, game_object) 
        if (action == "d" || action == "s" || action == "a" || action == "w")
            move(action, game_object)
        end
    end

    private

    def move(direction, game_object)
        game_object_position = game_object.get_position
        new_position = Position.new(game_object_position.row, game_object_position.col);

        if direction == "d"
            new_position.col = game_object_position.col + 1
        elsif direction == "a"
            new_position.col = game_object_position.col - 1
        elsif direction == "s"
            new_position.row = game_object_position.row + 1
        elsif direction == "w"
            new_position.row = game_object_position.row - 1
        end

        # TODO: can be done in a smarter way; just check the collection of a particular row, instead of all objects
        @game_objects.each do |key, value|
            game_object_position = value.get_position
            
            if(game_object_position.row == new_position.row && game_object_position.col == new_position.col)
                return
            end
        end

        game_object.set_position(new_position)
    end
end

if __FILE__ == $0
    game = Game.new
    map = Map.new(game.get_game_objects)

    map_width = map.get_width
    map_height = map.get_height
    
    player = Player.new
    game.add_object(player)

    # ADD VERTICAL BORDER
    for x in 0..map_height-1 do
        verticalWallLeft = Border.new(x, 0, true)
        game.add_object(verticalWallLeft)

        verticalWallRight = Border.new(x, map_width-1, true)
        game.add_object(verticalWallRight)
    end

    # ADD HORIZONTAL BORDER
    for y in 1..map_width-2 do
        horizontalWallUp = Border.new(0, y, false)
        game.add_object(horizontalWallUp)

        horizontalWallDown = Border.new(map_height-1, y, false)
        game.add_object(horizontalWallDown)
    end
    
    wall = Wall.new(3, 3)
    game.add_object(wall)

    wall2 = Wall.new(3, 4)
    game.add_object(wall2)

    wall4 = Wall.new(3, 5)
    game.add_object(wall4)

    wall5 = Wall.new(4, 3)
    game.add_object(wall5)

    wall6 = Wall.new(4, 5)
    game.add_object(wall6)

    wall3 = Wall.new(7, 6)
    game.add_object(wall3)

    map.draw_map(player)

    begin
        user_input = STDIN.getch
        game.process_action(user_input, player)

        map.draw_map(player)
    end while user_input != "q"
end