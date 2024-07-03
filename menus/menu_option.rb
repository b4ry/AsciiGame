class MenuOption
    attr_accessor :description
    attr_accessor :action

    def initialize(description, action)
        @description = description
        @action = action
    end
end