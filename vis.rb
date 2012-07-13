require_relative './lib/model/map.rb'

path = '';

def read_map
	Map.new(File.read('./maps/contest1.map.txt'))
end

def print_map map
	map.to_s.split('\n').each do |line|
		puts line
	end 
end

def read_step
	step = gets
	puts step
	path = path + step
	step
end

map = read_map
while true
	print_map map
	step = read_step
	if step == "A"
		break; 
	end
end