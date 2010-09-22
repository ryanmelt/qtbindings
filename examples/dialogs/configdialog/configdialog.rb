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
    
require './pages.rb'

class ConfigDialog < Qt::Dialog
    
    slots 'changePage(QListWidgetItem*, QListWidgetItem*)'
    
    def initialize()
        super
        @contentsWidget = Qt::ListWidget.new do |c|
            c.viewMode = Qt::ListView::IconMode
            c.iconSize = Qt::Size.new(96, 84)
            c.movement = Qt::ListView::Static
            c.maximumWidth = 128
            c.spacing = 12
        end
    
        @pagesWidget = Qt::StackedWidget.new do |p|
            p.addWidget(ConfigurationPage.new)
            p.addWidget(UpdatePage.new)
            p.addWidget(QueryPage.new)
        end
    
        closeButton = Qt::PushButton.new(tr("Close"))
    
        createIcons()
        @contentsWidget.currentRow = 0
    
        connect(closeButton, SIGNAL('clicked()'), self, SLOT('close()'))
    
        horizontalLayout = Qt::HBoxLayout.new do |h|
            h.addWidget(@contentsWidget)
            h.addWidget(@pagesWidget, 1)
        end
    
        buttonsLayout = Qt::HBoxLayout.new do |b|
            b.addStretch(1)
            b.addWidget(closeButton)
        end
    
        self.layout = Qt::VBoxLayout.new do |m|
            m.addLayout(horizontalLayout)
            m.addStretch(1)
            m.addSpacing(12)
            m.addLayout(buttonsLayout)
        end
    
        self.windowTitle = tr("Config Dialog")
    end
    
    def createIcons
        configButton = Qt::ListWidgetItem.new(@contentsWidget) do |c|
            c.icon = Qt::Icon.new("images/config.png")
            c.text = tr("Configuration")
            c.textAlignment = Qt::AlignHCenter
            c.flags = Qt::ItemIsSelectable | Qt::ItemIsEnabled
        end

        updateButton = Qt::ListWidgetItem.new(@contentsWidget) do |u|
            u.icon = Qt::Icon.new("images/update.png")
            u.text = tr("Update")
            u.textAlignment = Qt::AlignHCenter
            u.flags = Qt::ItemIsSelectable | Qt::ItemIsEnabled
        end

        queryButton = Qt::ListWidgetItem.new(@contentsWidget) do |q|
            q.icon = Qt::Icon.new("images/query.png")
            q.text = tr("Query")
            q.textAlignment = Qt::AlignHCenter
            q.flags = Qt::ItemIsSelectable | Qt::ItemIsEnabled
        end
    
        connect(@contentsWidget,
                SIGNAL('currentItemChanged(QListWidgetItem*, QListWidgetItem*)'),
                self, SLOT('changePage(QListWidgetItem*, QListWidgetItem*)'))
    end
    
    def changePage(current, previous)
        if current.nil?
            current = previous
        end

        @pagesWidget.currentIndex = @contentsWidget.row(current)
    end
end
