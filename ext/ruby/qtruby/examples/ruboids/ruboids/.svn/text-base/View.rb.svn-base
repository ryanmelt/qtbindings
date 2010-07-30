#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

# A lightweight view
class View

    SHADOW_COLOR = [ 0.25, 0.25, 0.25 ]

    attr_accessor :model, :color, :object, :shadow

    def initialize(model, color = nil)
	super()
	@model = model
	@color = color
	@object = nil
	@shadow = nil
    end

    def makeObject
	raise "subclass should implement"
    end

    def makeShadow
	# Don't raise error; some models may not have a shadow
    end

    def drawObject
	CallList(@object)
    end

    def drawShadow
	CallList(@shadow) if @shadow
    end

    def draw
	# We don't always have enough information to make the 3D objects
	# at initialize() time.
	makeObject() unless @object
	makeShadow() unless @shadow

  	rot = Graphics.rotations(model.vector)

	PushMatrix()

	# Translate and rotate shadow. Rotation around y axis only.
	Translate(model.position.x, 0, model.position.z)
	Rotate(rot.y, 0, 1, 0) if rot.y.nonzero?

	# Draw shadow.
	drawShadow() unless @shadow.nil?

	# Translate and rotate object. Rotate object around x and z axes (y
	# axis already done for shadow).
	Translate(0, model.position.y, 0)
	Rotate(rot.x, 1, 0, 0) if rot.x.nonzero?
	Rotate(rot.z, 0, 0, 1) if rot.z.nonzero?

	# Draw object.
	drawObject()

	PopMatrix()
    end

    # Given the height of an object, return a shadow color. The shadow color
    # gets lighter as heigt increases.
    def shadowColorForHeight(height)
	wh = $PARAMS['world_height']
	ratio = (height + wh / 2.0) / wh

	shadowColor = []
	SHADOW_COLOR.each_with_index { | c0, i |
	    min = c0
	    max = Canvas::GRASS_COLOR[i]
	    if min > max
		tmp = min
		min = max
		max = tmp
	    end
	    shadowColor << min + ratio * (max - min)
	}
	return shadowColor
    end

end
