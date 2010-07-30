begin
  version = Qt::version
  raise LoadError.new("Qt3 already loaded") unless version =~ /^4/
rescue NameError
  require 'qtruby4'
end
