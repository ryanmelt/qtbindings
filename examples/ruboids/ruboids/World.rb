#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require 'singleton'
require 'Qt'
require './Params'
require './Cloud'
require './Flock'
require './Boid'
require './Camera'
require './Canvas'

class World < Qt::Object
	slots 'slotMove()'
	
    include Singleton

    attr_accessor :canvas
    attr_reader :width, :height, :depth, :camera, :clouds, :flock

    def initialize
	super
	@width = $PARAMS['world_width']
	@height = $PARAMS['world_height']
	@depth = $PARAMS['world_depth']

	@clouds = []
	minAltitude = $PARAMS['cloud_min_altitude']
	$PARAMS['cloud_count'].times {
	    c = Cloud.new
	    c.position =
		Point.new(rand(@width) - @width / 2,
			  rand(@height) - @height / 2,
			  rand(@depth - minAltitude) - @depth / 2 + minAltitude)
	    @clouds << c
	}
	# Sort clouds by height so lower/darker shadows are drawn last
	@clouds.sort { |a, b| a.position.y <=> b.position.y }

	@flock = Flock.new
	$PARAMS['flock_boids'].times {
	    b = Boid.new
	    b.position = Point.new(rand(@width) - @width / 2,
				   rand(@height) - @height / 2,
				   rand(@depth) - @depth / 2)
	    @flock.add(b)	# flock will delete boid
	}

	@clock = Qt::Timer.new()
	connect(@clock, SIGNAL('timeout()'), self, SLOT('slotMove()'))

	@camera = Camera.new	# Reads values from params
	setupTranslation()
    end

    # Should be called whenever camera or screen changes.
    def setupTranslation
	@canvas.update() if @canvas
    end

    def start
	@clock.start($PARAMS['world_sleep_millis'])
    end

    def slotMove
	@clouds.each { | c | c.move() }
	@flock.move()
	@canvas.update() if @canvas

	# Camera follow boid.
#  	b = @flock.members.first
#    	@camera.position = b.position
#  	@camera.rotation = Graphics.rotations(b.vector)
#  	@camera.zoom = 1.0
	    
    end
end

