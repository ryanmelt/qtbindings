=begin
**
** Copyright (C) 2004-2006 Trolltech AS. All rights reserved.
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
    
class ImageComposer < Qt::Widget
    
    @@resultSize = Qt::Size.new(200, 200)

    slots :chooseSource, :chooseDestination, :recalculateResult

    def initialize()
        super()

        @sourceButton = Qt::ToolButton.new
        @sourceButton.iconSize = @@resultSize
    
        @operatorComboBox = Qt::ComboBox.new
        addOp(Qt::Painter::CompositionMode_SourceOver, tr("SourceOver"))
        addOp(Qt::Painter::CompositionMode_DestinationOver, tr("DestinationOver"))
        addOp(Qt::Painter::CompositionMode_Clear, tr("Clear"))
        addOp(Qt::Painter::CompositionMode_Source, tr("Source"))
        addOp(Qt::Painter::CompositionMode_Destination, tr("Destination"))
        addOp(Qt::Painter::CompositionMode_SourceIn, tr("SourceIn"))
        addOp(Qt::Painter::CompositionMode_DestinationIn, tr("DestinationIn"))
        addOp(Qt::Painter::CompositionMode_SourceOut, tr("SourceOut"))
        addOp(Qt::Painter::CompositionMode_DestinationOut, tr("DestinationOut"))
        addOp(Qt::Painter::CompositionMode_SourceAtop, tr("SourceAtop"))
        addOp(Qt::Painter::CompositionMode_DestinationAtop, tr("DestinationAtop"))
        addOp(Qt::Painter::CompositionMode_Xor, tr("Xor"))
    
        @destinationButton = Qt::ToolButton.new
        @destinationButton.iconSize = @@resultSize
    
        @equalLabel = Qt::Label.new(tr("="))
    
        @resultLabel = Qt::Label.new
        @resultLabel.minimumWidth = @@resultSize.width()
    
        connect(@sourceButton, SIGNAL(:clicked), self, SLOT(:chooseSource))
        connect(@operatorComboBox, SIGNAL('activated(int)'),
                self, SLOT('recalculateResult()'))
        connect(@destinationButton, SIGNAL(:clicked),
                self, SLOT(:chooseDestination))
    
        self.layout = Qt::GridLayout.new do |m|
            m.addWidget(@sourceButton, 0, 0, 3, 1)
            m.addWidget(@operatorComboBox, 1, 1)
            m.addWidget(@destinationButton, 0, 2, 3, 1)
            m.addWidget(@equalLabel, 1, 3)
            m.addWidget(@resultLabel, 0, 4, 3, 1)
            m.sizeConstraint = Qt::Layout::SetFixedSize
        end
    
        @resultImage = Qt::Image.new(@@resultSize, Qt::Image::Format_ARGB32_Premultiplied)
    
        @sourceImage = Qt::Image.new
        @destinationImage = Qt::Image.new

        loadImage(":/images/butterfly.png", @sourceImage, @sourceButton)
        loadImage(":/images/checker.png", @destinationImage, @destinationButton)

    
        setWindowTitle(tr("Image Composition"))
    end
    
    def chooseSource()
        chooseImage(tr("Choose Source Image"), @sourceImage, @sourceButton)
    end
    
    def chooseDestination()
        chooseImage(tr("Choose Destination Image"), @destinationImage,
                    @destinationButton)
    end
    
    def recalculateResult()
        mode = currentMode()
    
        painter = Qt::Painter.new(@resultImage)
        painter.compositionMode = Qt::Painter::CompositionMode_Source
        painter.fillRect(@resultImage.rect(), Qt::Brush.new(Qt::transparent))
        painter.compositionMode = Qt::Painter::CompositionMode_SourceOver
        painter.drawImage(0, 0, @destinationImage)
        painter.compositionMode = mode
        painter.drawImage(0, 0, @sourceImage)
        painter.compositionMode = Qt::Painter::CompositionMode_DestinationOver
        painter.fillRect(@resultImage.rect(), Qt::Brush.new(Qt::white))
        painter.end
    
        @resultLabel.pixmap = Qt::Pixmap.fromImage(@resultImage)
    end
    
    def addOp(mode, name)
        @operatorComboBox.addItem(name, Qt::Variant.new(mode.to_i))
    end
    
    def chooseImage(title, image, button)
        fileName = Qt::FileDialog.getOpenFileName(self, title)
        if !fileName.nil?
            loadImage(fileName, image, button)
        end
    end
    
    def loadImage(fileName, image, button)
        image.load(fileName)
    
        fixedImage = Qt::Image.new(@@resultSize, Qt::Image::Format_ARGB32_Premultiplied)
        painter = Qt::Painter.new(fixedImage)
        painter.compositionMode = Qt::Painter::CompositionMode_Source
        painter.fillRect(fixedImage.rect(), Qt::Brush.new(Qt::transparent))
        painter.compositionMode = Qt::Painter::CompositionMode_SourceOver
        painter.drawImage(imagePos(image), image)
        painter.end
        button.icon = Qt::Icon.new(Qt::Pixmap.fromImage(fixedImage))
    
#       The 'QImage::operator=()' method to use as an assignment isn't easily called
#       in QtRuby, so use the convenience method Qt::Image.fromImage() instead
#       image = fixedImage
        image.fromImage(fixedImage)

        recalculateResult()
    end
    
    def currentMode()
        return @operatorComboBox.itemData(@operatorComboBox.currentIndex()).to_i
    end
    
    def imagePos(image)
        return Qt::Point.new((@@resultSize.width() - image.width()) / 2,
                      (@@resultSize.height() - image.height()) / 2)
    end
end
