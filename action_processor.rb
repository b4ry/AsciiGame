class ActionProcessor
    Position = Struct.new(:row, :col)

    def initialize(map_objects)
        @map_objects = map_objects
    end

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
        @map_objects.each do |key, value|
            game_object_position = value.get_position
            
            if(game_object_position.row == new_position.row && game_object_position.col == new_position.col)
                return
            end
        end

        game_object.set_position(new_position)
    end
end