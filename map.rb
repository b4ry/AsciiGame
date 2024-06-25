require 'io/console'
require_relative 'game'
require_relative 'player'

if __FILE__ == $0
    game = Game.new
    player = Player.new
    
    game.add_object(player)
    game.draw_map

    begin
        user_input = STDIN.getch
        player.move(user_input)

        game.draw_map
    end while user_input != "q"
end