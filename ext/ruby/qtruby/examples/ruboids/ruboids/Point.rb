#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

class Point

    attr_accessor :x, :y, :z

    # Return a new Point that is the midpoint on the line between two
    # points.
    def Point.midpoint(a, b)
	return Point.new((a.x + b.x) * 0.5, (a.y + b.y) * 0.5,
			   (a.z + b.z) * 0.5)
    end

    def initialize(x = 0, y = 0, z = 0)
	if x.kind_of?(Point)
	    @x = x.x
	    @y = x.y
	    @z = x.z
	else
	    @x = x
	    @y = y
	    @z = z
	end
    end

    ORIGIN = Point.new(0, 0, 0)

    def ==(point)
	return point.kind_of?(Point) &&
	    @x == point.x && @y == point.y && @z == point.z
    end

    # Normalize this point.
    def normalize!
	mag = @x * @x + @y * @y + @z * @z
	if mag != 1.0
	    mag = 1.0 / Math.sqrt(mag)
	    @x *= mag
	    @y *= mag
	    @z *= mag
	end
	return self
    end

    # Return a new point that is a normalized version of this point.
    def normalize
	return self.dup().normalize!()
    end

    # Return a new point that is the cross product of this point and another.
    # The cross product of two unit vectors is another vector that's at
    # right angles to the first two (for example, a surface normal).
    def crossProduct(p)
	return Point.new(@y * p.z - @z * p.y, @z * p.x - @x * p.z,
			 @x * p.y - @y * p.x)
    end

    # Return the (scalar) dot product of this vector and another.
    # The dot product of two vectors produces the cosine of the angle
    # between them, multiplied by the lengths of those vectors. (The dot
    # product of two normalized vectors equals cosine of the angle.)
    def dotProduct(p)
	return @x * p.x + @y * p.y + @z * p.z
    end

    # Return square of distance between this point and another.
    def squareOfDistanceTo(p)
	dx = p.x - @x
	dy = p.y - @y
	dz = p.z - @z
	return dx * dx + dy * dy + dz * dz
    end

    # Return distance between this point and another.
    def distanceTo(p)
	dx = p.x - @x
	dy = p.y - @y
	dz = p.z - @z
	return Math.sqrt(dx * dx + dy * dy + dz * dz)
    end

    def add(d)
	@x += d
	@y += d
	@z += d
	return self
    end

    def addPoint(p)
	@x += p.x
	@y += p.y
	@z += p.z
	return self
    end


    def subtract(d)
	@x -= d
	@y -= d
	@z -= d
	return self
    end

    def subtractPoint(p)
	@x -= p.x
	@y -= p.y
	@z -= p.z
	return self
    end


    def multiplyBy(d)
	@x *= d
	@y *= d
	@z *= d
	return self
    end

    def multiplyByPoint(p)
	@x *= p.x
	@y *= p.y
	@z *= p.z
	return self
    end

    def divideBy(d)
	@x = @x / d
	@y = @y / d
	@z = @z / d
	return self
    end

    def divideByPoint(p)
	@x = @x / p.x
	@y = @y / p.y
	@z = @z / p.z
	return self
    end

    def to_a
	return [@x, @y, @z]
    end

    def to_s
	return "Point<#{@x}, #{@y}, #{@z}>"
    end

end
