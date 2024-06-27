class GameObject
    @@id = 0
    
    def initialize
      @id = @@id
      @@id += 1
    end
  
    def get_id
      @id
    end
end
  