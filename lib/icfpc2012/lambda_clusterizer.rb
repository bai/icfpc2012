module Icfpc2012
  class LambdaClusterizer

    attr_accessor :clusters, :map, :strict

    def initialize map, strict = false
      @clusters = []
      @map = map
      @strict = strict
    end

    def strictly_adjasted? l1, l2
      v_adj = (l1[0] == l2[0]) and ((l1[1] - l2[1]).abs() == 1)
      h_adj = (l1[1] == l2[1]) and ((l1[0] - l2[0]).abs() == 1)
      puts "#{l1.inspect}, #{l2.inspect} " + [v_adj, h_adj].join(', ')
      v_adj or h_adj
    end

    def loosely_adjasted? l1, l2
      if (l1[0] - l2[0]).abs == 1 and (l1[1] - l2[1]).abs == 1 # diagonal
        map.walkable?(l1[0], l2[1]) or map.walkable?(l2[0], l1[1])
      elsif l1[0] == l2[0] # same vertical 
        (l1[1] - l2[1]).abs() <= 2 and map.walkable?(l1[0], ((l1[1] + l2[1]) / 2).to_i)
      elsif l1[1] == l2[1] # same horizontal
        (l1[0] - l2[0]).abs() <= 2 and map.walkable?(((l1[0] + l2[0]) / 2).to_i, l1[1])
      else
        false
      end
    end

    def adjasted? l1, l2
      if @strict
        return strictly_adjasted? l1, l2
      else
        return loosely_adjasted? l1, l2
      end
    end

    def add lambda
      clusters_to_mix = [] # sometimes we need to merge two clusters
      @clusters.each do |cluster|
        if cluster.any? { |l| adjasted?(lambda, l) } 
          clusters_to_mix.push cluster
        end
      end

      if clusters_to_mix.length == 0
        @clusters.push([lambda]) # create new cluster with only one lambda
      elsif clusters_to_mix.length == 1
        clusters_to_mix[0].push lambda
      else # need to mix several clusters into one, the first cluster corresponds to closest lambda so it goes the first
        first = clusters_to_mix.delete_at 0
        clusters_to_mix.each do |cluster|
          @clusters.delete cluster
          first.concat cluster
        end
        first.push lambda
      end
      @clusters
    end

  end
end