module Icfpc2012
  class PatternDefs < Array
    @partial_pattern

    def load(string_def)
      instance_eval(string_def)
      push(@partial_pattern) if @partial_pattern
    end

    def define_pattern name
      push(@partial_pattern) if @partial_pattern
      @partial_pattern = Pattern.new (name)
    end

    def body the_body
      @partial_pattern.body = the_body
    end

    def path the_path
      @partial_pattern.add_path(the_path)
    end
  end
end