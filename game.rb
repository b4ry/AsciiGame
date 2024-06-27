require 'io/console'
require_relative 'map'
require_relative 'player'
require_relative 'wall'

if __FILE__ == $0
    map = Map.new

    map_width = map.get_width
    map_height = map.get_height
    
    player = Player.new
    map.add_object(player)

    # ADD VERTICAL WALLS
    for x in 0..map_height-1 do
        verticalWall1 = Wall.new(x, 0, "vertical")
        map.add_object(verticalWall1)

        verticalWall2 = Wall.new(x, map_width-1, "vertical")
        map.add_object(verticalWall2)
    end

    # ADD HORIZONTAL WALLS
    for y in 1..map_width-2 do
        horizontalWall1 = Wall.new(0, y, "horizontal")
        map.add_object(horizontalWall1)

        horizontalWall2 = Wall.new(map_height-1, y, "horizontal")
        map.add_object(horizontalWall2)
    end
    
    map.draw_map(player)

    begin
        user_input = STDIN.getch
        player.move(user_input, map_width, map_height)

        map.draw_map(player)
    end while user_input != "q"
end