#!/usr/bin/env ruby
$VERBOSE = true; $:.unshift File.dirname($0)

require 'Qt'
require_relative 'gamebrd.rb'

app = Qt::Application.new(ARGV)
gb = GameBoard.new
gb.setGeometry(100, 100, 500, 355)
gb.show
app.exec
