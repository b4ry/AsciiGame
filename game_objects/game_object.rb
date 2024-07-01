class GameObject
    @@id = 0
    
    def initialize(obstructs)
      @id = @@id
      @@id += 1
      @obstructs = obstructs
    end
  
    def get_id
      return @id
    end

    def obstructs?
      return @obstructs
    end
end
  