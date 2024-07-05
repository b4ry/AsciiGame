class ActionProcessor
    Position = Struct.new(:row, :col)

    def initialize(map)
        @map = map
    end

    def process_action(action, game_object) 
        if (is_movement?(action))
            move(action, game_object)
        end
    end

    private

    def is_movement?(action)
        return action == RIGHT || action == DOWN || action == LEFT || action == UP
    end

    def move(direction, game_object)
        game_object_position = game_object.get_position
        new_position = Position.new(game_object_position.row, game_object_position.col);

        if direction == RIGHT
            new_position.col = game_object_position.col + 1
        elsif direction == LEFT
            new_position.col = game_object_position.col - 1
        elsif direction == DOWN
            new_position.row = game_object_position.row + 1
        elsif direction == UP
            new_position.row = game_object_position.row - 1
        end

        # TODO: can be done in a smarter way; just check the collection of a particular row, instead of all objects
        @map.map_objects.each do |key, value|
            map_object_position = value.get_position
            
            if(map_object_position.row == new_position.row && map_object_position.col == new_position.col)
                return
            end
        end

        # refresh previous state of the previous position, after leaving it by an object
        @map.refresh_previous(game_object_position.row, game_object_position.col)

        game_object.set_position(new_position)
    end
end