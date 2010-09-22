#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require './Point'

class Triangle
    attr_accessor :points

    def initialize(p0 = Point::ORIGIN,
		   p1 = Point::ORIGIN,
		   p2 = Point::ORIGIN)
	@points = []
	@points << p0 ? p0 : Point::ORIGIN.dup()
	@points << p1 ? p1 : Point::ORIGIN.dup()
	@points << p2 ? p2 : Point::ORIGIN.dup()
    end
end
