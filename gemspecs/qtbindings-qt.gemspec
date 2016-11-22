require './qtlib/qtbindings_qt_version'

spec = Gem::Specification.new do |s|
  s.authors = ['Ryan Melton', 'Jason Thomas']
  s.email = 'kde-bindings@kde.org'
  s.rubyforge_project = 'qtbindings-qt'
  s.platform = Gem::Platform::CURRENT
  s.summary = "Qt bindings for ruby - Qt Dlls"
  s.homepage = "http://github.com/ryanmelt/qtbindings"
  s.name = 'qtbindings-qt'
  s.version = QTBINDINGS_QT_VERSION
  s.requirements << 'none'
  s.require_path = 'qtlib'
  s.files = Dir['qtlib/**/*', 'qtbin/**/*'].to_a
  s.description = 'qtbindings-qt contains the compiled qt dlls'
  s.licenses = ['LGPL-2.1']
end
