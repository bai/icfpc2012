module Icfpc2012
  class CoordHelper
    def self.coords_to_actions (coords)

      # coords = [
      #   [x, y], [x, y]
      # ]
      x = 0
      y = 1
      path = ''

      (coords.length - 1).times do |i|
        previous = coords[i]
        current = coords[i + 1]

        if previous[x] == current[x] and previous[y] == current[y]
          path += 'W'
        elsif previous[x] == (current[x] - 1) and previous[y] == current[y]
          path += 'R'
        elsif previous[x] == (current[x] + 1) and previous[y] == current[y]
          path += 'L'
        elsif previous[x] == current[x] and previous[y] == (current[y] - 1)
          path += 'U'
        elsif previous[x] == current[x] and previous[y] == (current[y] + 1)
          path += 'D'
        else
          raise "Coordinates are not adjasted: (#{ previous.join(', ') }) and (#{ current.join(', ')})"
        end
      end

      path
    end
  end
end