module Icfpc2012
  class PatternMatcher
    def initizlize(file_name)
    end
    def match(map, x, y)
      @patterns.find {|p| p.match(map,x,y) }
    end
  end
end