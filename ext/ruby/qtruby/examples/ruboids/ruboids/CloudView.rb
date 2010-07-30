#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require 'Qt'
require 'View'
require 'Cloud'
require 'Params'
require 'World'
require 'Graphics'

class CloudView < View

    def initialize(cloud)
	super(cloud)
    end

    def makeObject
	@object = GenLists(1)
	NewList(@object, COMPILE)

	@model.bubbles.each { | bubble |
  	    Color(bubble.color)
	    PushMatrix()
	    Translate(bubble.loc.x, bubble.loc.y, bubble.loc.z)
	    Scale(bubble.radius, bubble.radius, bubble.radius)
	    Graphics.sphere()
	    PopMatrix()
	}

	EndList()
    end

    def makeShadow
	@shadow = GenLists(1)
	NewList(@shadow, COMPILE)

	groundLevel = -($PARAMS['world_height'] / 2) + 1
	@model.bubbles.each { | bubble |
  	    Color(shadowColorForHeight(model.position.y + bubble.loc.y))
	    PushMatrix()
	    Translate(bubble.loc.x, groundLevel, bubble.loc.z)
	    Scale(bubble.radius, 1.0, bubble.radius)
	    Graphics.circle(2)
	    PopMatrix()
	}

	EndList()
    end

end
