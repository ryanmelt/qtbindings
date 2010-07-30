begin
  version = Qt::version
  raise LoadError.new("Qt4 already loaded") unless version =~ /^3/
rescue NameError
  require 'qtruby'
end
