module Icfpc2012
  class Timer
    attr_accessor :wake_up_interval

    def initialize(seconds)
      self.wake_up_interval = seconds

      Thread.new do
        sleep @wake_up_interval
        Thread.main.raise 'Time is up!'
      end
    end
  end
end