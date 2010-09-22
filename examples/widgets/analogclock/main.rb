#!/usr/bin/env ruby

require 'Qt'
require './analogclock.rb'

app = Qt::Application.new(ARGV)
clock = AnalogClock.new
clock.show
app.exec
