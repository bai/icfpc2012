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

        path += coords_to_action(coords[i], coords[i + 1])
      end

      path
    end

    def self.coords_to_action(previous, current)
      x = 0
      y = 1
      if previous[x] == current[x] and previous[y] == current[y]
        'W'
      elsif previous[x] == (current[x] - 1) and previous[y] == current[y]
        'R'
      elsif previous[x] == (current[x] + 1) and previous[y] == current[y]
        'L'
      elsif previous[x] == current[x] and previous[y] == (current[y] - 1)
        'U'
      elsif previous[x] == current[x] and previous[y] == (current[y] + 1)
        'D'
      else
        # gracefully ignore, assume it's teleport
        #          raise "Coordinates are not adjasted: (#{ previous.join(', ') }) and (#{ current.join(', ')})"
        ''
      end
    end

    def self.action_to_coords(coords, action)
      x = 0
      y = 1
      case action
        when 'U'
          [coords[0], coords[1]+1]
        when 'D'
          [coords[0], coords[1]-1]
        when 'L'
          [coords[0]-1, coords[1]]
        when 'R'
          [coords[0]+1, coords[1]]
        else
          coords
      end
    end

  end
end
