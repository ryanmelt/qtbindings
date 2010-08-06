require 'rubygems'
require 'rake'

windows = false
processor, platform, *rest = RUBY_PLATFORM.split("-")
windows = true if platform == 'mswin32' or platform == 'mingw32'

if windows
  MAKE = 'mingw32-make'
else
  MAKE = 'make'
end

def warn_version
  puts 'Warning: VERSION not specified' unless ENV['VERSION']
end

def set_version
  if ENV['VERSION']
    File.open('lib/qtbindings_version.rb', 'w') do |file| 
      file.write("QTBINDINGS_VERSION = '#{ENV['VERSION']}'\n")
      file.write("QTBINDINGS_RELEASE_DATE = '#{Time.now}'\n")
    end
  end  
end

def clear_version
  if ENV['VERSION']
    File.open('lib/qtbindings_version.rb', 'w') do |file| 
      file.write("QTBINDINGS_VERSION = '0.0.0.0'\n")
      file.write("QTBINDINGS_RELEASE_DATE = ''\n")
    end
  end    
end

task :default => [:all]

task :extconf do
  system('ruby extconf.rb')
end

task :all => [:extconf] do  
  system("#{MAKE} all")
end

task :clean => [:extconf] do  
  system("#{MAKE} clean")
end

task :distclean => [:extconf] do  
  system("#{MAKE} distclean")
end

task :build => [:extconf] do  
  system("#{MAKE} build")
end

task :install => [:extconf] do  
  system("#{MAKE} install")
end

task :installqt => [:extconf] do  
  system("#{MAKE} installqt")
end

task :gem => [:distclean] do
  warn_version()
  set_version()
  system("gem build qtbindings.gemspec")
  clear_version()
end

task :gemnative => [:clean] do
  warn_version()
  set_version()
  system("gem build qtbindingsnative.gemspec")
  clear_version()
end

task :gemwindows => [:installqt, :gemnative]

task :ryanbuildwindows do
  if RUBY_VERSION.split('.')[1].to_i == 9
    system("move C:\\Ruby C:\\Ruby191 && move C:\\Ruby187 C:\\Ruby")
  end
  Rake::Task[:extconf].execute
  Rake::Task[:all].execute
  Rake::Task[:install].execute
  system("move C:\\Ruby C:\\Ruby187 && move C:\\Ruby191 C:\\Ruby")
  Rake::Task[:extconf].execute
  Rake::Task[:all].execute
  Rake::Task[:install].execute
  system("move C:\\Ruby C:\\Ruby191 && move C:\\Ruby187 C:\\Ruby")
end

task :ryangemwindows => [:ryanbuildwindows, :gemwindows]
