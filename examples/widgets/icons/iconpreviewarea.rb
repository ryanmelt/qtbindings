=begin
**
** Copyright (C) 2004-2005 Trolltech AS. All rights reserved.
**
** This file is part of the example classes of the Qt Toolkit.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** self file.  Please review the following information to ensure GNU
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

class IconPreviewArea < Qt::Widget

    NumModes = 3
    NumStates = 2

    def initialize(parent = nil)
        super(parent)
        mainLayout = Qt::GridLayout.new
        setLayout(mainLayout)
    
        stateLabels = []
        stateLabels[0] = createHeaderLabel(tr("Off"))
        stateLabels[1] = createHeaderLabel(tr("On"))
    
        modeLabels = []
        modeLabels[0] = createHeaderLabel(tr("Normal"))
        modeLabels[1] = createHeaderLabel(tr("Active"))
        modeLabels[2] = createHeaderLabel(tr("Disabled"))
    
        (0...NumStates).each do |j|
            mainLayout.addWidget(stateLabels[j], j + 1, 0)
        end
    
        @pixmapLabels = []
        (0...NumModes).each do |i|
            mainLayout.addWidget(modeLabels[i], 0, i + 1)
    
            @pixmapLabels[i] = []
            (0...NumStates).each do |j|
                @pixmapLabels[i][j] = createPixmapLabel()
                mainLayout.addWidget(@pixmapLabels[i][j], j + 1, i + 1)
            end
        end

        @size = Qt::Size.new
		@icon = Qt::Icon.new
    end
    
    def icon=(icon)
        @icon = icon
        updatePixmapLabels()
    end
    
    def size=(size)
        if size != @size
            @size = size
            updatePixmapLabels()
        end
    end
    
    def createHeaderLabel(text)
        label = Qt::Label.new(tr("<b>%s</b>" % text))
        label.alignment = Qt::AlignCenter.to_i
        return label
    end
    
    def createPixmapLabel()
        label = Qt::Label.new
        label.enabled = false
        label.alignment = Qt::AlignCenter.to_i
        label.frameShape = Qt::Frame::Box
        label.setSizePolicy(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)
        label.backgroundRole = Qt::Palette::Base
        label.setMinimumSize(132, 132)
        return label
    end
    
    def updatePixmapLabels()
        (0...NumModes).each do |i|
            if i == 0
                mode = Qt::Icon::Normal
            elsif i == 1
                mode = Qt::Icon::Active
            else
                mode = Qt::Icon::Disabled
            end
    
            (0...NumStates).each do |j|
                state = (j == 0) ? Qt::Icon::Off : Qt::Icon::On
                pixmap = @icon.pixmap(@size, mode, state)
                @pixmapLabels[i][j].pixmap = pixmap
                @pixmapLabels[i][j].enabled = !pixmap.nil?
            end
        end
    end
end