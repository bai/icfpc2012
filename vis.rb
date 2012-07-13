require_relative './lib/model/map.rb'

map = nil;
path = '';

def read_map
	map = Map.new(File.read('./maps/contest1.map.txt'))
	puts map.inspect
	map

end

def print_map
	gets.chomp
	map.inspect
end

def read_step
	step = gets
	puts step
	path = path + step
	step
end

read_map
while true
	step = read_step
	if step == "A"
		break;
	end
	print_map
end