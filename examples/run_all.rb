files = Dir["**/main.rb"]
files.each do |file|
  command = "cd #{File.dirname(file).gsub('/', '\\')} && ruby -rubygems #{File.basename(file)}"
  puts "running: #{command}"
  system(command)
end