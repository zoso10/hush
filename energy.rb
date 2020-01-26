# frozen_string_literal: true

require "io/console"


module Hush
  class Energy
    RECHARGING = :recharging
    DISCHARGING = :discharging
    RECHARGING_FRAME_1 = <<-ART
          Z
            Z
          Z
            Z
          Z
        _____|~~\\_____      _____________
    _-~               \\    |    \\
    _-    | )     \\    |__/   \\   \\
    _-         )   |   |  |     \\  \\
    _-    | )     /    |--|      |  |
    __-_______________ /__/_______|  |_________
  (                |----         |  |
   `---------------'--\\\\\\\\      .`--'
                                `||||
ART
    RECHARGING_FRAME_2 = <<-ART
            Z
          Z
            Z
          Z
            Z
        _____|~~\\_____      _____________
    _-~               \\    |    \\
    _-    | )     \\    |__/   \\   \\
    _-         )   |   |  |     \\  \\
    _-    | )     /    |--|      |  |
    __-_______________ /__/_______|  |_________
  (                |----         |  |
   `---------------'--\\\\\\\\      .`--'
                                `||||
ART

    def initialize
      @level = 100
      @state = DISCHARGING
      @start_time = Time.now
    end

    def expend
      # TODO: use up energy level based on how many commands there are
    end

    def recharge
      @state = RECHARGING
      frame_1 = true

      while @state == RECHARGING do
        IO.console.winsize.first.times { $stdout.puts }

        # every hour += 12.5 to level
        if frame_1
          $stdout.puts(RECHARGING_FRAME_1)
        else
          $stdout.puts(RECHARGING_FRAME_2)
        end

        sleep(1)
        frame_1 = !frame_1
      end
    end

    def discharge
      @state = DISCHARGING
    end
  end
end
