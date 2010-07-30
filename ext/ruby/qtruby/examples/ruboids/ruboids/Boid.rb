#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require 'BoidView'
require 'Flock'
require 'Point'
require 'Params'

class Boid < Thing

    attr_accessor :maxSpeed, :maxSpeedSquared, :perchingTurnsLeft,
	:wingFlapPos, :almostGroundLevel, :flock

    def initialize(pos = nil)
	super(pos, nil)
	init
    end

    def init
	@maxSpeed = $PARAMS['boid_max_speed']
	@maxSpeedSquared = @maxSpeed * @maxSpeed
	@flock = nil		# set by flock when flock adds to self
	@wingFlapPos = rand(7)
	@perchingTurnsLeft = 0
	@almostGroundLevel = 5.0

	@view = BoidView.new(self)
    end

    def move
	# Flap wings. Only flap occasionally if not perching.
	if (@perchingTurnsLeft == 0 ||
	    rand(100) < $PARAMS['boid_perch_wing_flap_percent'])
	    @wingFlapPos = (@wingFlapPos + 1) & 7
	end

	if @perchingTurnsLeft > 0
	    # Only take off when wing flap position == 2.
	    if --@perchingTurnsLeft == 0 && @wingFlapPos != 2
		@perchingTurnsLeft = (8 + 2 - @wingFlapPos) & 7
		return
	    end
	end

	moveTowardsFlockCenter()
	avoidOthers()
	matchOthersVelocities()
	boundPosition()
	limitSpeed()

	super()			# Add velocity vector to position.

	# Boids at ground level perch for a while.
	if @position.y < @almostGroundLevel
	    @position.y = @almostGroundLevel
	    @vector.x = @vector.y = @vector.z = 0
	    @perchingTurnsLeft =
		rand($PARAMS['boid_max_perching_turns'])
	end
    end

    def moveTowardsFlockCenter()
	flockCenter = @flock.centerExcluding(self)
	flockCenter.subtractPoint(@position)
	# Move 1% of the way towards the center
	flockCenter.divideBy(100.0)

	@vector.addPoint(flockCenter)
    end

    def avoidOthers()
	c = Point.new()
	@flock.members.each { | b |
	    if b != self
		otherPos = b.position
		if @position.squareOfDistanceTo(otherPos) <
			$PARAMS['boid_square_of_personal_space_dist']
		    c.addPoint(@position)
		    c.subtractPoint(otherPos)
		end
	    end
	}
	@vector.addPoint(c)
    end

    def matchOthersVelocities()
	vel = Point.new()
	flock.members.each { | b |
	    if b != self
		vel.addPoint(b.vector)
	    end
	}
	vel.divideBy(flock.members.length - 1)
	vel.subtractPoint(@vector)
	vel.divideBy(8)

	@vector.addPoint(vel)
    end

    def boundPosition()
	v = Point.new

	halfWidth = $PARAMS['world_width'] / 2
	halfHeight = $PARAMS['world_height'] / 2
	halfDepth = $PARAMS['world_depth'] / 2

	if position.x < -halfWidth
	    v.x = $PARAMS['boid_bounds_limit_pull']
	elsif position.x > halfWidth
	    v.x = -$PARAMS['boid_bounds_limit_pull']
	end

	if position.y < -halfHeight + almostGroundLevel +
		$PARAMS['boid_bounds_limit_above_ground_level']
	    v.y = $PARAMS['boid_bounds_limit_pull']
	elsif position.y > halfHeight
	    v.y = -$PARAMS['boid_bounds_limit_pull']
	end

	if position.z < -halfDepth
	    v.z = $PARAMS['boid_bounds_limit_pull']
	elsif position.z > halfDepth
	    v.z = -$PARAMS['boid_bounds_limit_pull']
	end

	@vector.addPoint(v)
    end

    def limitSpeed()
	speedSquared = Point::ORIGIN.squareOfDistanceTo(@vector)
	if speedSquared > @maxSpeedSquared
	    f = Math.sqrt(speedSquared) * @maxSpeed
	    @vector.divideBy(f)
	end
    end
end
    
