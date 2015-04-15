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
require './car.rb'

app = Qt::Application.new(ARGV)

scene = Qt::GraphicsScene.new
scene.setSceneRect(-500, -500, 1000, 1000)
scene.itemIndexMethod = Qt::GraphicsScene::NoIndex

car = Car.new
scene.addItem(car)

view = Qt::GraphicsView.new(scene)
view.renderHint = Qt::Painter::Antialiasing
view.backgroundBrush = Qt::Brush.new(Qt::darkGray)
view.setWindowTitle(QT_TRANSLATE_NOOP(Qt::GraphicsView, "Qt DBus Controlled Car"))
view.resize(400, 300)
view.show()

adaptor = CarAdaptor.new(car)
connection = Qt::DBusConnection::sessionBus()
connection.registerObject("/Car", adaptor, Qt::DBusConnection::ExportScriptableSlots)
connection.registerService("com.trolltech.CarExample")

app.exec
