require File.expand_path('../test_helper', __FILE__)

class DummyMap # Dynamic typing, yay!
  def walkable? x, y
    true
  end
end

class LambdaClusterizerTest < Test::Unit::TestCase
  def test_clusterize
    lambdas = [
      [0,0], [3, 3], [3, 4], [7, 7], [0, 1], [1, 0], [1, 1], [2, 2]
    ]
    clusterizer = Icfpc2012::LambdaClusterizer.new (DummyMap.new)
    lambdas.each do |lambda|
      clusterizer.add lambda
    end

    # strictly adjasted
    # assert [[[0, 0], [0, 1], [1, 0], [1, 1]], [[3, 3], [3, 4]], [[7, 7]], [[2, 2]]] == clusterizer.clusters

    # more liberal
    assert [[[0, 0], [0, 1], [1, 0], [1, 1], [3, 3], [3, 4], [2, 2]], [[7, 7]]] == clusterizer.clusters
  end
end
