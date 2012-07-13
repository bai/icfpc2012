require_relative './lib/model/map.rb'
require 'io/console'

def read_map
	Map.new(File.read('./maps/contest1.map.txt'))
end

def print_map map
	map.to_s.split('\n').each do |line|
		puts line
	end 
end

$stdin.raw!

def read_step 
	step = $stdin.getc
	step = step[0].capitalize
	puts step
	step
end

map = read_map
while true
	puts ''
	print_map map
	step = read_step 
	map = map.step step
	if step[0] == "A"
		break; 
	end
end