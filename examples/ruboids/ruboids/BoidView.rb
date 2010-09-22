#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require './View'

class BoidView < View

    BODY_COLOR = [0, 0, 0]
    BEAK_COLOR = [0.75, 0.5, 0.0]
    SHADOW_COLOR = [0.25, 0.55, 0.25]

    HALF_WING_BASE = 3
    HALF_LENGTH = 5
    HALF_THICKNESS = 1
    NOSE_LENGTH = 3

    @@object = nil
    @@shadow = nil
    @@wings = nil
    @@wingsShadows = nil

    def initialize(model)
	super(model, [0, 0, 0])
	@wings = nil
	@wingsShadows = nil
    end

    def makeObject
	@@object = BoidView.makeObject() unless @@object
	@object = @@object
	@wings = @@wings
    end

    def makeShadow
	BoidView.makeShadow() unless @@shadow
	@shadow = @@shadow
	@wingsShadows = @@wingsShadows
    end

    def drawObject
	super()

	angle = 0
	case model.wingFlapPos
	when 0
	    angle = 60
	when 1, 7
	    angle = 30
	when 2, 6
	    angle = 0
	when 3, 5
	    angle = -30
	when 4
	    angle = -60
	end

	PushMatrix()
	Rotate(angle, 0, 0, 1)
	CallList(@wings[0])
	Rotate(angle * -2, 0, 0, 1)
	CallList(@wings[1])
	PopMatrix()
    end

    def BoidView.makeObject
	makeWings()

	object = GenLists(1)
	NewList(object, COMPILE)

	makeBody()
	makeNose()

	EndList()

	return object
    end

    def BoidView.makeShadow
	@@shadow = GenLists(1)
	NewList(@@shadow, COMPILE)

	p0 = Point::ORIGIN.dup()
	p1 = Point::ORIGIN.dup()
	dims = Point.new(HALF_THICKNESS, HALF_THICKNESS, HALF_LENGTH)
	p0.subtractPoint(dims)
	p1.addPoint(dims)
	
	groundLevel = -($PARAMS['world_height'] / 2) + 1

	Color(SHADOW_COLOR)
	Begin(QUADS)
	Vertex(p1.x, groundLevel, p0.z)
	Vertex(p0.x, groundLevel, p0.z)
	Vertex(p0.x, groundLevel, p1.z)
	Vertex(p1.x, groundLevel, p1.z)
	End()
#  	Begin(TRIANGLES)
#  	Vertex(p1.x, groundLevel, p1.z)
#  	Vertex(0, groundLevel, p0.z)
#  	Vertex(p0.x, groundLevel, p1.z)
#  	End()

	EndList()
    end

    def BoidView.makeBody
	p0 = Point::ORIGIN.dup()
	p1 = Point::ORIGIN.dup()
	dims = Point.new(HALF_THICKNESS, HALF_THICKNESS, HALF_LENGTH)
	p0.subtractPoint(dims)
	p1.addPoint(dims)

	Color(BODY_COLOR)
	Graphics.boxFromCorners(p0, p1)
    end

    def BoidView.makeWings
	@@wings = []
	len = -$PARAMS['boid_wing_length']
	@@wings << makeOneWing(len)
	@@wings << makeOneWing(-len)
    end

    def BoidView.makeOneWing(len)
	wing = GenLists(1)
	NewList(wing, COMPILE)

	Color(BODY_COLOR)
	Begin(TRIANGLES)

	Vertex(0, 0, -HALF_WING_BASE)
	Vertex(len, 0, 0)
	Vertex(0, 0, HALF_WING_BASE)

	End()
	EndList()
	return wing
    end

    def BoidView.makeNose()
	Color(BEAK_COLOR)
	Begin(TRIANGLE_FAN)

	Vertex(0, 0, HALF_LENGTH + NOSE_LENGTH)
	Vertex( HALF_THICKNESS,  HALF_THICKNESS, HALF_LENGTH)
	Vertex(-HALF_THICKNESS,  HALF_THICKNESS, HALF_LENGTH)
	Vertex(-HALF_THICKNESS, -HALF_THICKNESS, HALF_LENGTH)
	Vertex( HALF_THICKNESS, -HALF_THICKNESS, HALF_LENGTH)

	End()
    end

end

