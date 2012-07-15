module Icfpc2012
  class Robot
    attr_accessor :x, :y, :underwater_ticks

    def initialize(x, y, alive = true, underwater_ticks = 0)
      @x = x
      @y = y
      @alive = alive
      @underwater_ticks = underwater_ticks
    end

    def step(direction)
      case direction
      when 'W','S' then [@x, @y] # wait, apply razor
      when 'L' then [@x-1, @y] # move left
      when 'R' then [@x+1, @y] # move right
      when 'U' then [@x, @y+1] # move up
      when 'D' then [@x, @y-1] # move down
      else raise "Invalid direction: #{direction}".inspect
      end
    end

    def position
      [ @x, @y ]
    end

    def alive?
      @alive
    end
  end
end
