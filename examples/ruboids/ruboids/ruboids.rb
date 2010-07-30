#! /usr/bin/env ruby
#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require 'Qt'
require 'World'
require 'WorldWindow'
require 'Canvas'
require 'Params'

app = Qt::Application.new(ARGV)
if (!Qt::GLFormat::hasOpenGL())
    warning("This system has no OpenGL support. Exiting.")
    exit -1
end

Params.readParamsFromFile(ARGV[0] || 'boids.properties')
world = World.instance
win = WorldWindow.new
# app.mainWidget = win

World.instance.canvas = win.canvas
win.show
World.instance.start
app.exec
