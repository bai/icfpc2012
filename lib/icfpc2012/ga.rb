# IDEA: use gene algo to traverse the map

module Icfpc2012

  class RobotPath < Array
    attr_accessor :map

    def initialize(map, path)
      super (path.split(//))
      @map = map
    end

    def fitness
      # raise 'Not Implemented Yet'
      0
    end

    def recombine (c2)
      cross_point_1 = rand(@self.length + 1)
      cross_point_2 = rand(c2.length + 1)

      c1_a, c1_b = self.separate(cross_point_1)
      c2_a, c2_b = c2.separate(cross_point_2)

      [RobotPath.new(@map, c1_a + c2_b), RobotPath.new(@map, c2_a + c1_b)]
    end

    def mutate
      posssible_moves = ['L', 'R', 'U', 'D']
      mutate_point = (self.length * rand).to_i
      self[mutate_point] = posssible_moves[rand(4)]
    end
  end

  class Ga
    attr_accessor :map, :population, :genetic_algorithm

    def initialize(population_size, map)
      @map = map
      @population = init_population(population_size)
      @genetic_algorithm = GeneticAlgorithm.new (@population)
    end

    def evolve (generations = 1000)
      generations.times { @genetic_algorithm.evolve }
      @genetic_algorithm.best_fit[0]
    end

    def init_population (population_size)
      population = Array.new(population_size)
      population.size.times do |i|
        population[i] = RobotPath.new(@map, init_path)
      end
      population
    end

    def init_path
      posssible_moves = ['L', 'R', 'U', 'D']
      path = ''
      len = (@map.height + @map.width);
      len = (len * rand(201) / 100).to_i
      len.times do
        path += posssible_moves[rand(4)]
      end
      path
    end
  end
end