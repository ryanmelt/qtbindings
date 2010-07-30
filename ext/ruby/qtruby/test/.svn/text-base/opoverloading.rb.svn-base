require 'Qt'

class Qt::Point
   def to_s
      "(#{x}, #{y})"
   end
end

$t = binding
def test(str)
   puts "#{str.ljust 25} => #{eval(str, $t)}"
end

test("p1 = Qt::Point.new(5,5)")
test("p2 = Qt::Point.new(20,20)")
test("p1 + p2")
test("p1 - p2")
test("-p1 + p2")
test("p2 += p1")
test("p2 -= p1")
test("p2 * 3")

class Qt::Region
   def to_s
      "(#{empty?})"
   end
end

test("r1 = Qt::Region.new()")
test("r2 = Qt::Region.new( 100,100,200,80, Qt::Region::Ellipse )")
test("r1 + r2")

class Qt::WMatrix
   def to_s
      "(#{m11}, #{m12}, #{m21}, #{m22}, #{dx}, #{dy})"
   end
end

test("a    = Math::PI/180 * 25")         # convert 25 to radians
test("sina = Math.sin(a)")
test("cosa = Math.cos(a)")
test("m1 = Qt::Matrix.new(1, 0, 0, 1, 10, -20)")  # translation matrix
test("m2 = Qt::Matrix.new( cosa, sina, -sina, cosa, 0, 0 )")
test("m3 = Qt::Matrix.new(1.2, 0, 0, 0.7, 0, 0)") # scaling matrix
test("m = Qt::Matrix.new")
test("m = m3 * m2 * m1")                  # combine all transformations
