#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require './Point'

class Thing

    attr_accessor :position, :vector, :view

    def initialize(pos = nil, vec = nil)
	@position = pos ? pos : Point.new
	@vector = vec ? vec : Point.new
    end

    def move
	position.x += vector.x
	position.y += vector.y
	position.z += vector.z
    end

    def draw
	view.draw() if view
    end

    def pixelsPerSecToPixelsPerMove(pixelsPerSecond)
	pps = (pixelsPerSecond.to_f / (1000.0 / 75.0)).to_i
	pps = 1 if pps == 0
	return pps
    end
end
