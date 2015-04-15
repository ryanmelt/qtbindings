=begin
**
** Copyright (C) 2004-2005 Trolltech AS. All rights reserved.
**
** This file is part of the example classes of the Qt Toolkit.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** this file.  Please review the following information to ensure GNU
** General Public Licensing requirements will be met:
** http://www.trolltech.com/products/qt/opensource.html
**
** If you are unsure which license is appropriate for your use, please
** review the following information:
** http://www.trolltech.com/products/qt/licensing.html or contact the
** sales department at sales@trolltech.com.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**

** Translated to QtRuby by Richard Dale
=end

require 'Qt'
require './movieplayer.rb'

require 'memory_profiler'
report = MemoryProfiler.report do
app = Qt::Application.new(ARGV)
player = MoviePlayer.new
player.show
app.exec
end
time = Time.now
timestamp = sprintf("%04u_%02u_%02u_%02u_%02u_%02u", time.year, time.month, time.mday, time.hour, time.min, time.sec)
File.open("#{timestamp}_memory.txt","w") {|file| report.pretty_print(file) }
