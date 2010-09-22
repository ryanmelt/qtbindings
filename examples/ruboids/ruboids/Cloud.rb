#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require './Thing'
require './CloudView'
require './Params'

class Bubble

    attr_reader :loc, :radius, :color

    def initialize
	@radius = rand($PARAMS['cloud_max_bubble_radius']) + 1
	@loc = Point.new(0, rand(8) - 4, rand(8) - 4)
	c = 0.85 + rand() * 0.15
	@color = [c, c, c]
    end

end


class Cloud < Thing

    attr_reader :speed, :bubbles, :width

    def initialize
	minSpeed = $PARAMS['cloud_min_speed']
	minBubbles = $PARAMS['cloud_min_bubbles']
	@speed = rand($PARAMS['cloud_max_speed'] - minSpeed) + minSpeed
	numBubbles = rand($PARAMS['cloud_max_bubbles'] - minBubbles) +
	    minBubbles
	@bubbles = []
	prevBubble = nil
	(0 ... numBubbles).each { | i |
	    bubble = Bubble.new()
	    if !prevBubble.nil?
		bubble.loc.x = prevBubble.loc.x +
		    rand((prevBubble.radius + bubble.radius) * 0.66)
	    end

	    @bubbles[i] = prevBubble = bubble
	}

	@width = bubbles.last.loc.x +
	    @bubbles.first.radius + @bubbles.last.radius

	@view = CloudView.new(self)
    end

    def move
	@position.x += pixelsPerSecToPixelsPerMove(speed)
	halfWorldWidth = $PARAMS['world_width']
	if (@position.x >=  halfWorldWidth / 2)
	    @position.x = -(halfWorldWidth + @width)
	end
    end
end
