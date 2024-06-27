require 'io/console'
require_relative 'map'
require_relative 'player'
require_relative 'wall'

class Game
    def initialize
        @game_objects = {}
    end

    def add_object(obj)
        @game_objects[obj.get_id] = obj
    end

    def get_game_objects
        @game_objects
    end
end

if __FILE__ == $0
    game = Game.new
    map = Map.new(game.get_game_objects)

    map_width = map.get_width
    map_height = map.get_height
    
    player = Player.new
    game.add_object(player)

    # ADD VERTICAL WALLS
    for x in 0..map_height-1 do
        verticalWall1 = Wall.new(x, 0, "vertical")
        game.add_object(verticalWall1)

        verticalWall2 = Wall.new(x, map_width-1, "vertical")
        game.add_object(verticalWall2)
    end

    # ADD HORIZONTAL WALLS
    for y in 1..map_width-2 do
        horizontalWall1 = Wall.new(0, y, "horizontal")
        game.add_object(horizontalWall1)

        horizontalWall2 = Wall.new(map_height-1, y, "horizontal")
        game.add_object(horizontalWall2)
    end
    
    map.draw_map(player)

    begin
        user_input = STDIN.getch
        player.move(user_input, map_width, map_height)

        map.draw_map(player)
    end while user_input != "q"
end