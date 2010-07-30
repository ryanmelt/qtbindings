#!/usr/bin/env ruby

require 'Qt'
require 'dialog.rb'

app = Qt::Application.new(ARGV)
dialog = Dialog.new
dialog.show
app.exec
