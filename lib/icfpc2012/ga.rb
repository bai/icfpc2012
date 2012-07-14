# IDEA: use gene algo to traverse the map

module Icfpc2012
  class Ga
    attr_accessor :map

    def initialize(map)
      @map = map
    end
    
    def init_path
      posssible_moves = ['L', 'R', 'U', 'D']
      path = ''
      len = (map.height + map.width);
      len = len * rand(201) / 100
      len.times do
        path += posssible_moves[rand(4)]
      end
      path
    end
    
  end
end
