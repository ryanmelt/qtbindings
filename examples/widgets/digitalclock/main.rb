#!/usr/bin/env ruby

require 'Qt'
require './digitalclock.rb'

require 'memory_profiler'
report = MemoryProfiler.report do
app = Qt::Application.new(ARGV)
clock = DigitalClock.new
clock.show
app.exec
end
time = Time.now
timestamp = sprintf("%04u_%02u_%02u_%02u_%02u_%02u", time.year, time.month, time.mday, time.hour, time.min, time.sec)
File.open("#{timestamp}_memory.txt","w") {|file| report.pretty_print(file) }
