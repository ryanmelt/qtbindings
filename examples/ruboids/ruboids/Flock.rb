#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require './Flock'
require './Boid'
require './Params'

class Flock
    attr_reader :members

    def initialize
	@members = []
    end

    def add(boid)
	@members << boid
	boid.flock = self
    end

    def draw
	@members.each { | boid | boid.draw() }
    end

    def move
	@members.each { | boid | boid.move() }
    end

    # Return distance between two boid's positions.
    def distBetween(b1, b2)
	return b1.position.distanceTo(b2.position)
    end

    # Center of mass
    def centerExcluding(b)
	p = Point.new()
	@members.each { | boid |
	    p.addPoint(boid.position) unless boid == b
	}
	p.divideBy(@members.length - 1)
	return p
    end
end

