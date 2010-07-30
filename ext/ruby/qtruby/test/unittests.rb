require 'Qt'
require 'test/unit'

class TestQtRuby < Test::Unit::TestCase

  def setup
    @app = Qt::Application.instance || Qt::Application.new(ARGV)
    assert @app
  end

  def test_link_against_qt4
    assert_raise(NoMethodError) { @app.setMainWidget(nil) }
  end

  def test_qapplication_methods
   assert @app == Qt::Application::instance
   assert @app == Qt::CoreApplication::instance
   assert @app == Qt::Application.instance
   assert @app == Qt::CoreApplication.instance
   assert @app == $qApp
  end

  def test_qapplication_inheritance
   assert @app.inherits("Qt::Application")
   assert @app.inherits("Qt::CoreApplication")
   assert @app.inherits("Qt::Object")
  end

  def test_widget_inheritance
    widget = Qt::Widget.new(nil)
    assert widget.inherits("Qt::Widget")
    assert widget.inherits("Qt::Object")
    assert widget.inherits("QObject")
  end

  def test_qstring_marshall
    widget = Qt::Widget.new(nil)
    assert widget.objectName.nil?
    widget.objectName = "Barney"
    assert widget.objectName == "Barney"
  end

  def test_widgetlist
    w1 = Qt::Widget.new(nil)
    w2 = Qt::Widget.new(w1)
    w3 = Qt::Widget.new(w1)
    w4 = Qt::Widget.new(w2)

    assert w1.children == [ w2, w3 ]
  end

  def test_find_children
    w = Qt::Widget.new(nil)
    assert_raise(TypeError) { w.findChildren(nil) }

    assert w.findChildren(Qt::Widget) == [ ]
    w2 = Qt::Widget.new(w)

    assert w.findChildren(Qt::Widget) == [ w2 ]
    assert w.findChildren(Qt::Object) == [ w2 ]
    assert w.findChildren(Qt::LineEdit) == [ ]
    assert w.findChildren(Qt::Widget,"Bob") == [ ]
    assert w.findChildren(Qt::Object,"Bob") == [ ]

    w2.objectName = "Bob"

    assert w.findChildren(Qt::Widget) == [ w2 ]
    assert w.findChildren(Qt::Object) == [ w2 ]
    assert w.findChildren(Qt::Widget,"Bob") == [ w2 ]
    assert w.findChildren(Qt::Object,"Bob") == [ w2 ]
    assert w.findChildren(Qt::LineEdit, "Bob") == [ ]

    w3 = Qt::Widget.new(w)
    w4 = Qt::LineEdit.new(w2)
    w4.setObjectName("Bob")

    assert w.findChildren(Qt::Widget) == [ w4, w2, w3 ]
    assert w.findChildren(Qt::LineEdit) == [ w4 ]
    assert w.findChildren(Qt::Widget,"Bob") == [ w4, w2 ]    
    assert w.findChildren(Qt::LineEdit,"Bob") == [ w4 ]    
  end

  def test_find_child
    w = Qt::Widget.new(nil)
    assert_raise(TypeError) { w.findChild(nil) }

    assert_nil w.findChild(Qt::Widget)
    w2 = Qt::Widget.new(w)

    w3 = Qt::Widget.new(w)
    w3.objectName = "Bob"
    w4 = Qt::LineEdit.new(w2)
    w4.objectName = "Bob"

    assert w.findChild(Qt::Widget,"Bob") == w3
    assert w.findChild(Qt::LineEdit,"Bob") == w4
  end

  def test_boolean_marshalling
    assert Qt::Variant.new(true).toBool
    assert !Qt::Variant.new(false).toBool

    assert !Qt::Boolean.new(true).nil?
    assert Qt::Boolean.new(false).nil?

    # Invalid variant conversion should change b to false
    b = Qt::Boolean.new(true)
    v = Qt::Variant.new("Blah")
    v.toInt(b);

    assert b.nil?
  end

  def test_intp_marshalling
    assert Qt::Integer.new(100).value == 100
  end

  def test_variant_conversions
    v = Qt::Variant.new(Qt::Variant::Invalid)

    assert !v.isValid
    assert v.isNull

    v = Qt::Variant.new(55)
    assert v.toInt == 55
    assert v.toUInt == 55
    assert v.toLongLong == 55
    assert v.toULongLong == 55
    assert Qt::Variant.new(-55).toLongLong == -55
    assert Qt::Variant.new(-55).toULongLong == 18446744073709551561
    assert v.toDouble == 55.0
    assert v.toChar == Qt::Char.new(55)
    assert v.toString == "55"
    assert v.toStringList == [ ]


    assert Qt::Variant.new("Blah").toStringList == [ "Blah" ]

    assert Qt::Variant.new(Qt::Size.new(30,40)).toSize == Qt::Size.new(30,40)
    assert Qt::Variant.new(Qt::SizeF.new(20,30)).toSizeF == Qt::SizeF.new(20,30)

    assert Qt::Variant.new(Qt::Rect.new(30,40,10,10)).toRect == Qt::Rect.new(30,40,10,10)
    assert Qt::Variant.new(Qt::RectF.new(20,30,10,10)).toRectF == Qt::RectF.new(20,30,10,10)

    assert Qt::Variant.new(Qt::Point.new(30,40)).toPoint == Qt::Point.new(30,40)
    assert Qt::Variant.new(Qt::PointF.new(20,30)).toPointF == Qt::PointF.new(20,30)


  end

end
