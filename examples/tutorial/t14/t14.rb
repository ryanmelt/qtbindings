#!/usr/bin/env ruby
$VERBOSE = true; $:.unshift File.dirname($0)

require 'Qt'
require './gamebrd.rb'

app = Qt::Application.new(ARGV)
board = GameBoard.new
board.setGeometry( 100, 100, 500, 355 )
board.show
app.exec
