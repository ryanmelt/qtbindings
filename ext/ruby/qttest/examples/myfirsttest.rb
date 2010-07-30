#!/usr/bin/ruby

require 'Qt4'
require 'qttest'

class MyFirstTest < Qt::Object
  private_slots :initTestCase, 
                :myFirstTest, :mySecondTest,
                :cleanupTestCase

  def initTestCase()
    qDebug("called before everything else")
  end 
  
  def myFirstTest()
    QVERIFY('1 == 1')
    qDebug("myFirstTest()")
  end

  def mySecondTest()
    QVERIFY('1 != 2')
    qDebug("mySecondTest()")
  end

  def cleanupTestCase()
    qDebug("called after myFirstTest and mySecondTest")
  end
end

Qt::Test.qExec(MyFirstTest.new, ARGV)
