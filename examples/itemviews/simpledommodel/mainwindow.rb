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

require './dommodel.rb'

class MainWindow < Qt::MainWindow
    slots 'openFile()'
    
    def initialize()
        super
        @fileMenu = menuBar().addMenu(tr("&File"))
        @fileMenu.addAction(tr("&Open..."), self, SLOT('openFile()'),
                            Qt::KeySequence.new(tr("Ctrl+O")))
        @fileMenu.addAction(tr("E&xit"), self, SLOT('close()'),
                            Qt::KeySequence.new(tr("Ctrl+Q")))
    
        @model = DomModel.new(Qt::DomDocument.new, self)
        @view = Qt::TreeView.new(self)
        @view.model = @model
    
        setCentralWidget(@view)
        setWindowTitle(tr("Simple DOM Model"))
    end
    
    def openFile()
        filePath = Qt::FileDialog.getOpenFileName(self, tr("Open File"),
            @xmlPath, tr("XML files (*.xml);;HTML files (*.html);;" \
                        "SVG files (*.svg);;User Interface files (*.ui)"))
    
        if !filePath.nil?
            file = Qt::File.new(filePath)
            if file.open(Qt::IODevice::ReadOnly)
                document = Qt::DomDocument.new
                if document.setContent(file)
                    newModel = DomModel.new(document, self)
                    @view.model = newModel
                    @model = newModel
                    @xmlPath = filePath
                end
                file.close()
            end
        end
    end
end
