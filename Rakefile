require 'rake'

windows = false
processor, platform, *rest = RUBY_PLATFORM.split("-")
windows = true if platform =~ /mswin32/ or platform =~ /mingw32/

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
    File.open('qtlib/qtbindings_qt_version.rb', 'w') do |file|
      file.write("QTBINDINGS_QT_VERSION = '#{ENV['VERSION'].split('.')[0..-2].join('.')}'\n")
      file.write("QTBINDINGS_QT_RELEASE_DATE = '#{Time.now}'\n")
    end    
  end
end

def clear_version
  if ENV['VERSION']
    File.open('lib/qtbindings_version.rb', 'w') do |file|
      file.write("QTBINDINGS_VERSION = '0.0.0.0'\n")
      file.write("QTBINDINGS_RELEASE_DATE = ''\n")
    end
    File.open('lib/qtbindings_qt_version.rb', 'w') do |file|
      file.write("QTBINDINGS_QT_VERSION = '0.0.0'\n")
      file.write("QTBINDINGS_QT_RELEASE_DATE = ''\n")
    end    
  end
end

task :build_examples do
  # Go into the examples directory and look for all the makefiles and build them
  Dir['examples/**/makefile'].each do |file|
    if windows
      system("cd #{File.dirname(file).gsub('/', '\\')} && #{MAKE}")
    else
      system("cd #{File.dirname(file)} && #{MAKE}")
    end
  end
end

task :examples => [:build_examples] do
  system('cd examples && ruby run_all.rb')
end

task :default => [:all]

task :extconf do
  system('ruby extconf.rb')
end

# All calls 'make clean' and 'make build'
task :all => [:extconf] do
  system("#{MAKE} all")
end

task :clean => [:extconf] do
  system("#{MAKE} clean")
end

task :distclean => [:extconf] do
  system("#{MAKE} distclean")
end

task :make_build => [:extconf] do
  system("#{MAKE} build")
end

task :install => [:extconf] do
  system("#{MAKE} install")
end

task :gem => [:distclean] do
  warn_version()
  set_version()
  system("gem build qtbindings.gemspec")
  clear_version()
end

task :gemnative do
  warn_version()
  set_version()
  system("gem build qtbindingsnative.gemspec")
  clear_version()
end

task :gemqt do
  warn_version()
  set_version()
  system("#{MAKE} installqt")
  system("gem build qtbindings-qt.gemspec")
  clear_version()
end

task :build do
  Rake::Task[:extconf].execute
  Rake::Task[:all].execute
  Rake::Task[:install].execute
end
