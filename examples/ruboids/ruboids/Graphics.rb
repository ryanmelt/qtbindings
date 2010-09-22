#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require './Triangle'

class Graphics

    DEFAULT_SPHERE_ITERATIONS = 3

    XPLUS = Point.new(1, 0, 0)	# X
    XMINUS = Point.new(-1, 0, 0)# -X
    YPLUS = Point.new(0, 1, 0)	# Y
    YMINUS = Point.new(0, -1, 0)# -Y
    ZPLUS = Point.new(0, 0, 1)	# Z
    ZMINUS = Point.new(0, 0, -1)# -Z

    # defined w/counter-clockwise triangles
    OCTAHEDRON = [
	Triangle.new(YPLUS, ZPLUS, XPLUS),
	Triangle.new(XMINUS, ZPLUS, YPLUS),
	Triangle.new(YMINUS, ZPLUS, XMINUS),
	Triangle.new(XPLUS, ZPLUS, YMINUS),
	Triangle.new(ZMINUS, YPLUS, XPLUS),
	Triangle.new(ZMINUS, XMINUS , YPLUS),
	Triangle.new(ZMINUS, YMINUS , XMINUS),
	Triangle.new(ZMINUS, XPLUS, YMINUS)
    ]
    # Defines counter-clockwise points used in OpenGL TRIANGLE_STRIP to
    # create a circle on the X/Z plane. Don't include center point here;
    # It is added when outputting the circle.
    SQUARE = [
	XPLUS, ZMINUS, XMINUS, ZPLUS, XPLUS
    ]

    @@spheres = Hash.new()
    @@circles = Hash.new()

    def Graphics.radiansToDegrees(rad)
	return rad * 180.0 / Math::PI
    end

    def Graphics.degreesToRadians(deg)
	return deg * Math::PI / 180.0
    end

    # Given a vector, return a point containing x, y, z rotation angles.
    #
    # atan2(x, y) = the angle formed with the x axis by the ray from the
    # origin to the point {x,y}
    def Graphics.rotations(v)
	return Point::ORIGIN.dup() if v.nil?
	return v if v == Point::ORIGIN

	x = Math.atan2(v.y, v.z)
	y = Math.atan2(v.z, v.x)
	z = Math.atan2(v.y, v.x)

	rot = Point.new(z, x, y)
	rot.add(Math::PI).multiplyBy(180.0).divideBy(Math::PI)

	rot.x = rot.x.to_i
	rot.y = rot.y.to_i
	rot.z = rot.z.to_i

	return rot
    end

    # Build box from corners. All faces are counter-clockwise.
    def Graphics.boxFromCorners(p0, p1)
	pa = p0.dup()
	pb = p1.dup()

	# Make sure all coords of pa are < all coords of pb
	if pa.x > pb.x
	    tmp = pa.x; pa.x = pb.x; pb.x = tmp
	end
	if pa.y > pb.y
	    tmp = pa.y; pa.y = pb.y; pb.y = tmp
	end
	if pa.z > pb.z
	    tmp = pa.z; pa.z = pb.z; pb.z = tmp
	end

	Begin(QUAD_STRIP)

	# top
	Vertex(pb.x, pb.y, pa.z)
	Vertex(pa.x, pb.y, pa.z)
	# top/front
	Vertex(pb.x, pb.y, pb.z)
	Vertex(pa.x, pb.y, pb.z)
	# front/bottom
	Vertex(pb.x, pa.y, pb.z)
	Vertex(pa.x, pa.y, pb.z)
	# bottom/back
	Vertex(pb.x, pa.y, pa.z)
	Vertex(pa.x, pa.y, pa.z)
	# back/top
	Vertex(pb.x, pb.y, pa.z)
	Vertex(pa.x, pb.y, pa.z)

	End()

	Begin(QUADS)

	# left
	Vertex(pa.x, pa.y, pb.z)
	Vertex(pa.x, pa.y, pa.z)
	Vertex(pa.x, pb.y, pa.z)
	Vertex(pa.x, pb.y, pb.z)

	# right
	Vertex(pb.x, pa.y, pb.z)
	Vertex(pb.x, pa.y, pa.z)
	Vertex(pb.x, pb.y, pa.z)
	Vertex(pb.x, pb.y, pb.z)

	End()
    end

    # sphere() (and buildSphere()) - generate a triangle mesh approximating
    # a sphere by recursive subdivision. First approximation is an
    # octahedron; each level of refinement increases the number of
    # triangles by a factor of 4.
    #
    # Level 3 (128 triangles) is a good tradeoff if gouraud shading is used
    # to render the database.
    #
    # Usage: sphere [level] [counterClockwise]
    #
    #	The value level is an integer >= 1 setting the recursion level
    #		(default = DEFAULT_SPHERE_ITERATIONS).
    #	The boolean counterClockwise causes triangles to be generated
    #		with vertices in counterclockwise order as viewed from
    #		the outside in a RHS coordinate system. The default is
    #		counter-clockwise.
    #
    # @author Jon Leech (leech@cs.unc.edu) 3/24/89 (C version)
    # Ruby version by Jim Menard (jimm@io.com), May 2001.
    def Graphics.sphere(iterations = DEFAULT_SPHERE_ITERATIONS,
			counterClockwise = true)
	if @@spheres[iterations].nil?
	    @@spheres[iterations] = buildSphere(iterations, OCTAHEDRON)
	end
	sphere = @@spheres[iterations] 
	
	Begin(TRIANGLES)
	sphere.each { | triangle |
	    triangle.points.each { | p |
		Vertex(p.x, p.y, p.z) if counterClockwise
		Vertex(p.z, p.y, p.x) if !counterClockwise
	    }
	}
	End()
    end

    #
    # Subdivide each triangle in the oldObj approximation and normalize
    #  the new points thus generated to lie on the surface of the unit
    #  sphere.
    # Each input triangle with vertices labelled [0,1,2] as shown
    #  below will be turned into four new triangles:
    #
    #                        Make new points
    #                                a = (0+2)/2
    #                                b = (0+1)/2
    #                                c = (1+2)/2
    #          1
    #         /\             Normalize a, b, c
    #        /  \
    #      b/____\ c         Construct new counter-clockwise triangles
    #      /\    /\                  [a,b,0]
    #     /  \  /  \                 [c,1,b]
    #    /____\/____\                [c,b,a]
    #   0      a     2               [2,c,a]
    #
    #
    # The normalize step (which makes each point a, b, c unit distance
    # from the origin) is where we can modify the sphere's shape.
    #
    def Graphics.buildSphere(iterations, sphere)
	oldObj = sphere
	# Subdivide each starting triangle (maxlevel - 1) times
	iterations -= 1
	iterations.times {
	    # Create a new object. Allocate 4 * the number of points in the
	    # the current approximation.
	    newObj = Array.new(oldObj.length * 4)

	    j = 0
	    oldObj.each { | oldt |
		# New midpoints
		a = Point.midpoint(oldt.points[0], oldt.points[2])
		a.normalize!()
		b = Point.midpoint(oldt.points[0], oldt.points[1])
		b.normalize!()
		c = Point.midpoint(oldt.points[1], oldt.points[2])
		c.normalize!()

		# New triangeles. Their vertices are counter-clockwise.
		newObj[j] = Triangle.new(a, b, oldt.points[0])
		j += 1
		newObj[j] = Triangle.new(c, oldt.points[1], b)
		j += 1
		newObj[j] = Triangle.new(c, b, a)
		j += 1
		newObj[j] = Triangle.new(oldt.points[2], c, a)
		j += 1
	    }

	    # Continue subdividing new triangles
	    oldObj = newObj
	}
	return oldObj
    end

    # Creates a circle in the X/Z plane. To have the circle's normal
    # point down (-Y), specify clockwise instead of counter-clockwise.
    # To create the circle in another plane, call OpenGL's Rotate() method
    # before calling this.
    def Graphics.circle(iterations = DEFAULT_SPHERE_ITERATIONS,
			counterClockwise = true)
	if @@circles[iterations].nil?
	    @@circles[iterations] = buildCircle(iterations, SQUARE)
	end
	circle = @@circles[iterations] 
	
	Begin(TRIANGLE_FAN)
	Vertex(0, 0, 0)
	if counterClockwise
	    circle.each { | p | Vertex(p.x, 0, p.z) }
	else
	    circle.reverse.each { | p | Vertex(p.x, 0, p.z) }
	end
	End()
    end

    # Different than buildSphere because we are creating triangles to
    # be used in an OpenGL TRIANGLE_FAN operation. Thus the first point
    # (the center) is always inviolate. We create new points between
    # the remaining points.
    def Graphics.buildCircle(iterations, circle)
	oldObj = circle
	# Subdivide each starting line segment (maxlevel - 1) times
	iterations -= 1
	iterations.times {
	    # Create a new object. Allocate 2 * the number of points in the
	    # the current approximation. Subtract one because the last point
	    # (same as the first point) is simply copied.
	    newObj = Array.new(oldObj.length * 2 - 1)

	    prevP = nil
	    j = 0
	    oldObj.each { | p |
		if !prevP.nil?
		    newObj[j] = prevP
		    j += 1

		    # New midpoint
		    a = Point.midpoint(prevP, p)
		    a.normalize!()
		    newObj[j] = a
		    j += 1
		end
		prevP = p
	    }
	    newObj[j] = prevP	# Copy last point

	    # Continue subdividing new triangles
	    oldObj = newObj
	}
	return oldObj
    end
end
