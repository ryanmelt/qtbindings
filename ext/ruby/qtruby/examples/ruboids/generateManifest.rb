#! /usr/bin/env ruby
#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#
# This script builds the Manifest file. It can be run stand-alone, but
# is normally used from within release.rb.
#

def recurseDirectory(io, dirName, indentLevel)
    Dir.entries(dirName).sort.each { | f |
	next if f =~ /^\.\.?/
	fileName = "#{dirName}/#{f}"
	fileName.sub!(/^\.\//, '')
	if File.directory?(fileName)
	    io.puts "\t" * indentLevel + fileName + '/'
	    recurseDirectory(io, fileName, indentLevel + 1)
	else
	    io.puts "\t" * indentLevel + f
	end
    }
end

def generateManifest
    io = nil
    begin
	io = File.open('Manifest', 'w')
	recurseDirectory(io, '.', 0)
    ensure
	io.close() if io
    end
end

if $0 == __FILE__
    generateManifest()
end



    
