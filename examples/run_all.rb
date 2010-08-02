windows = false
processor, platform, *rest = RUBY_PLATFORM.split("-")
windows = true if platform == 'mswin32' or platform == 'mingw32'

files = Dir["**/main.rb"]
files.each do |file|
  if windows
    command = "cd #{File.dirname(file).gsub('/', '\\')} && ruby -rubygems #{File.basename(file)}"
  else
    command = "cd #{File.dirname(file)} && ruby -rubygems #{File.basename(file)}"
  end
  puts "running: #{command}"
  system(command)
end
