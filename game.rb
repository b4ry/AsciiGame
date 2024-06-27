require 'io/console'
require_relative 'map'
require_relative 'player'

if __FILE__ == $0
    map = Map.new
    player = Player.new
    
    map.add_object(player)
    map.draw_map(player)

    map_width = map.get_width
    map_height = map.get_height

    begin
        user_input = STDIN.getch
        player.move(user_input, map_width, map_height)

        map.draw_map(player)
    end while user_input != "q"
end