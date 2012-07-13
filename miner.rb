#!/usr/bin/env ruby

# cat maps/contest1.map.txt | ./miner.rb

CHARS = [ 'R', '#', '*', '\\', 'L', '.', ' ' ]

puts Map.new(ARGF.read).map.inspect
