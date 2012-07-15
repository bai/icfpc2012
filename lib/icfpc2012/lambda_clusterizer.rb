module Icfpc2012
  class LambdaClusterizer

    attr_accessor :clusters

    def initialize
      @clusters = []
    end

    def adjasted? l1, l2
      ((l1[0] - l2[0]).abs() < 2) and ((l1[1] - l2[1]).abs() < 2)
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