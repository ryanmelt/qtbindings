#! /usr/bin/env ruby
#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#
# This script gathers everything needed to release RuBoids into one directory
# and, if requested, publishes the contents to the RuBoids Web site.
#
# usage:
#
#	release.rb [--publish, -p]
#
# Specifying --publish or -p causes the resulting files to be published
# to the Web site.
#

require 'net/ftp'
require 'ftools'		# For makedirs and install
require 'generateManifest'	# For--you guessed it--generating the Manifest

# Start looking for RUBOIDS classes in this directory.
# This forces us to use the local copy of RUBOIDS, even if there is
# a previously installed version out there somewhere.
$LOAD_PATH[0, 0] = '.'

require 'ruboids/info'		# For Version string

FILE_PERMISSION = 0644
DIR_PERMISSION = 0755

PUBLISH_FLAG = '-p'
RUBOIDS_DIR = 'ruboids'
DOCS_DIR = '.'
#DOCS_HTML_DIR = "#{DOCS_DIR}/README"

RUBOIDS_DIR_WITH_VERSION = "#{RUBOIDS_DIR}-#{Version}"
RELEASE_DIR = "/tmp/#{RUBOIDS_DIR_WITH_VERSION}_release"
#RELEASE_HTML_DIR = "#{RELEASE_DIR}/README"

DOWNLOAD_FILE = "#{DOCS_DIR}/index.html"
#DOCBOOK_FILE = "#{DOCS_DIR}/README.sgml"

WEB_SITE = 'io.com'
WEB_DIR = 'public-web/downloads/ruboids'

# Copies all files from `fromDir' into the release directory. Sets the
# permissions of all files to 0644.
def copyFiles(fromDir, toDir, match=nil)
    Dir.foreach(fromDir) { | f |
	next if f =~ /^\.\.?/ || (!match.nil? && !(f =~ match))
	File.install("#{fromDir}/#{f}", toDir, FILE_PERMISSION)
    }
end

# Recursively removes the contents of a directory.
def rmDirectory(dirName)
    return unless File.exists?(dirName)
    Dir.foreach(dirName) { | f |
	next if f =~ /^\.\.?/
	path = "#{dirName}/#{f}"
	rmDirectory(path) if File.directory?(path)
	File.delete(path) if !File.directory?(path)
    }
    
end

# Recursively sends files and directories.
def sendToWebSite(ftp, releaseDir, webDir)
    ftp.chdir(webDir)
    Dir.foreach(releaseDir) { | f |
	next if f =~ /^\.\.?/
	path = "#{releaseDir}/#{f}"
	if File.directory?(path)
	    begin
		ftp.mkdir(f)
	    rescue Net::FTPPermError
		# ignore; it's OK if the directory already exists
	    end
	    sendToWebSite(ftp, path, f)
	    ftp.chdir('..')
	else
	    ftp.putbinaryfile(path, f)
	end
    }
end

def ensureVersionInFile(fileName, regex)
    lines = File.open(fileName).grep(regex)
    found = lines.detect { | line | line =~ /#{Version}/o }
    if !found
	$stderr.puts "Warning: it looks like the #{fileName} version number" +
	    " is incorrect"
    end
end

# ================================================================
# main
# ================================================================

# Make sure the docs mention the correct version number.
#ensureVersionInFile(DOWNLOAD_FILE, /Download the latest/)
#ensureVersionInFile(DOCBOOK_FILE, /releaseinfo/)

# Empty release dir if it already exists.
rmDirectory(RELEASE_DIR)

# (Re)create release dir. This makes RELEASE_HTML_DIR, whose parent
# is RELEASE_DIR. Therefore, RELEASE_DIR is created as well.
#File.makedirs(RELEASE_HTML_DIR)
File.makedirs(RELEASE_DIR)

# Recreate the full documentation (creating README and docs/README) and copy
# the HTML files to the release directory. Finally, clean up the docs
# directory.

#system("cd #{DOCS_DIR} && make")
#copyFiles(DOCS_DIR, RELEASE_DIR, /\.html$/)
#copyFiles(DOCS_HTML_DIR, RELEASE_HTML_DIR, /\.html$/)
copyFiles(DOCS_DIR, RELEASE_DIR, 'index.html')

# Generate the Manifest file.
generateManifest()

# Create .tar.gz file. We temporarily rename the RUBOIDS folder to
# "ruboids-X.Y.Z", tar and gzip that directory, then restore its original
# name.
Dir.chdir('..')
File.rename(RUBOIDS_DIR, RUBOIDS_DIR_WITH_VERSION)
system("tar -czf #{RELEASE_DIR}/#{RUBOIDS_DIR_WITH_VERSION}.tar.gz " +
       RUBOIDS_DIR_WITH_VERSION)
File.chmod(FILE_PERMISSION, "#{RELEASE_DIR}/#{RUBOIDS_DIR_WITH_VERSION}.tar.gz")
File.rename(RUBOIDS_DIR_WITH_VERSION, RUBOIDS_DIR)

# ftp files if requested
if !ARGV.empty? && ARGV[0] == PUBLISH_FLAG
    require 'net/ftp'

    # Ask for ftp username and password
    guess = ENV['LOGNAME'] || ENV['USER']
    print "username [#{guess}]: "
    username = $stdin.gets().chomp()
    username = guess if username.empty?
    print "password: "
    password = $stdin.gets().chomp()

    # ftp files to web site
    ftp = Net::FTP.open(WEB_SITE, username, password)
    sendToWebSite(ftp, RELEASE_DIR, WEB_DIR)
    ftp.close()
end
