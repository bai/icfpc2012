#!/usr/bin/env ruby

# cat maps/contest1.map.txt | ./miner.rb

CHARS = [ 'R', '#', '*', '\\', 'L', '.', ' ' ]

class Map
  def initialize(input)
    @input = input
  end

  def map
    input = @input.split("\n").map { |l| l.split(//) }
  end
end

puts Map.new(ARGF.read).map.inspect
