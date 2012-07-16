module Icfpc2012
  class SolverTarget
    attr_reader :want_lambdas, :want_exit, :want_beard, :target_cells

    def initialize(target_cells, want_target = true, want_lambdas = false, want_beard = false)
      @want_lambdas = want_lambdas
      @want_target = want_target
      @want_beard = want_beard
      @target_cells = target_cells
    end

    def in_target?(position)
      @target_cells.include?(position)
    end

    def heuristic(solution)
      rob = solution.last_map.robot.position

      (@want_path ? -solution.waypoints.size * 100 : 0) +
        (@want_lambdas ? solution.last_map.collected_lambdas * 100 : 0) +
        (solution.won? ? 10000 : 0) +
        (in_target?(rob) ? @target_cells.index(rob) * 100 + 200 : 0) +
        (solution.last_map.razors * 10) +
        # FIXME: Better expression to express "We're gonna drown"
        (solution.last_map.waterproof == 0 ? 0 : solution.last_map.robot.underwater_ticks * 100 / solution.last_map.waterproof)
    end

    def can_do_better?(champion_solution, partial_pretender)
      return true if champion_solution == nil

      unless @want_lambdas || @want_beard
        rob = partial_pretender.last_map.robot.position
        return distance_to_target(rob) + partial_pretender.size >= champion_solution.size
      end
      # TODO: Implement for other targets
      true
    end

    # Manhattan distance to the best of the target cells
    def distance_to_target(cell)
      (cell[0] - @target_cells.last[0]).abs + (cell[1] - @target_cells.last[1]).abs
    end

  end
end