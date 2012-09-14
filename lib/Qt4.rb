windows = false
platform = RUBY_PLATFORM.split("-")[1]
windows = true if platform == 'mswin32' or platform == 'mingw32'

module Qt
  PLUGIN_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'plugins'))
end
if RUBY_VERSION.split('.')[1].to_i == 8
  if windows
    ENV['PATH'] = File.join(File.dirname(__FILE__), '../bin') + ';' + File.join(File.dirname(__FILE__), '../lib/1.8') + ';' + File.join(File.dirname(__FILE__), '../bin/plugins') + ';' + File.join(File.dirname(__FILE__), '../bin/1.8') + ';' + ENV['PATH']
  end
  $: << File.join(File.dirname(__FILE__), '../lib/1.8')
  require '1.8/qtruby4'
else
  if windows
    ENV['PATH'] = File.join(File.dirname(__FILE__), '../bin') + ';' + File.join(File.dirname(__FILE__), '../lib/1.9') + ';' + File.join(File.dirname(__FILE__), '../bin/plugins') + ';' + File.join(File.dirname(__FILE__), '../bin/1.9') + ';' + ENV['PATH']
  end
  $: << File.join(File.dirname(__FILE__), '../lib/1.9')
  require '1.9/qtruby4'
end
