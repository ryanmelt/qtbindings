require './lib/qtbindings_version'

spec = Gem::Specification.new do |s|
  s.authors = ['Richard Dale', 'Arno Rehn', 'Ryan Melton']
  s.email = 'kde-bindings@kde.org'
  s.rubyforge_project = 'qtbindings'
  s.platform = Gem::Platform::CURRENT
  s.summary = "Qt bindings for ruby"
  s.homepage = "http://rubyforge.org/projects/qtbindings"
  s.name = 'qtbindings'
  s.version = QTBINDINGS_VERSION
  s.requirements << 'none'
  s.require_path = 'lib'
  s.files = Dir['lib/**/*', 'bin/**/*', 'examples/**/*', 'ext/**/*', '*.txt', 'extconf.rb', '*.gemspec', 'Rakefile'].to_a
  s.executables = ['smokeapi', 'smokedeptool', 'rbrcc', 'rbuic4', 'rbqtapi']
  s.description = 'qtbindings provides ruby bindings to QT4.x. It is derived from the kdebindings project.'
end