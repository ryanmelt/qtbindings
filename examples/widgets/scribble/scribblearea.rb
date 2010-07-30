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

class ScribbleArea < Qt::Widget

	slots 'clearImage()'

	def initialize(parent = nil)
		super(parent)
		setAttribute(Qt::WA_StaticContents)
		@modified = false
		@scribbling = false
		@myPenWidth = 1
		@myPenColor = Qt::blue
		@image = Qt::Image.new
		@lastPoint = Qt::Point.new
	end
	
	def openImage(fileName)
		loadedImage = Qt::Image.new
		if !loadedImage.load(fileName)
			return false
		end
	
		newSize = loadedImage.size().expandedTo(size())
		resizeImage(loadedImage, newSize)
		@image = loadedImage
		@modified = false
		update()
		return true
	end
	
	def saveImage(fileName,  fileFormat)
		visibleImage = @image
		resizeImage(visibleImage, size())
	
		if visibleImage.save(fileName, fileFormat.to_s)
			@modified = false
			return true
		else
			return false
		end
	end
	
	def modified?
		return @modified
	end

	def penColor
		return @myPenColor
	end

	def penColor=(newColor)
		@myPenColor = newColor
	end
	
	def penWidth
		return @myPenWidth
	end
	
	def penWidth=(newWidth)
		@myPenWidth = newWidth
	end
	
	def clearImage()
		@image.fill(qRgb(255, 255, 255))
		@modified = true
		update()
	end
	
	def mousePressEvent(event)
		if event.button() == Qt::LeftButton
			@lastPoint = event.pos()
			@scribbling = true
		end
	end
	
	def mouseMoveEvent(event)
		if (Qt::LeftButton & event.buttons() != 0) && @scribbling
			drawLineTo(event.pos())
		end
	end
	
	def mouseReleaseEvent(event)
		if event.button() == Qt::LeftButton && @scribbling
			drawLineTo(event.pos())
			@scribbling = false
		end
	end
	
	def paintEvent(event)
		painter = Qt::Painter.new(self)
		painter.drawImage(Qt::Point.new(0, 0), @image)
		painter.end
	end
	
	def resizeEvent(event)
		if width() > @image.width() || height() > @image.height()
			newWidth = [width() + 128, @image.width()].max
			newHeight = [height() + 128, @image.height()].max
			resizeImage(@image, Qt::Size.new(newWidth, newHeight))
			update()
		end
		super(event)
	end
	
	def drawLineTo(endPoint)
		painter = Qt::Painter.new(@image)
		painter.pen = Qt::Pen.new(Qt::Brush.new(@myPenColor), @myPenWidth, Qt::SolidLine, Qt::RoundCap,
							Qt::RoundJoin)
		painter.drawLine(@lastPoint, endPoint)
		@modified = true
	
		rad = @myPenWidth / 2
		update(Qt::Rect.new(@lastPoint, endPoint).normalized().adjusted(-rad, -rad, +rad, +rad))
		@lastPoint = endPoint
		painter.end
	end
	
	def resizeImage(image, newSize)
		if image.size == newSize
			return
		end
	
		newImage = Qt::Image.new(newSize, Qt::Image::Format_RGB32)
		newImage.fill(qRgb(255, 255, 255))
		painter = Qt::Painter.new(newImage)
		painter.drawImage(Qt::Point.new(0, 0), image)
		@image = newImage
		painter.end
	end
end
