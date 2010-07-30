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
	
require 'opengl'
	
class GLWidget < Qt::GLWidget
	
	signals	'clicked()'
	
	def initialize(parent, shareWidget)
	    super(parent, shareWidget)
	    @clearColor = Qt::Color.new(Qt::black)
		@lastPos = Qt::Point.new
	    @xRot = 0
	    @yRot = 0
	    @zRot = 0
		@refCount = 0
		@sharedObject = nil
	end
	
	def dispose()
		@refCount -= 1
	    if @refCount == 0
	        makeCurrent()
	        GL.DeleteLists(sharedObject, 1)
	    end
		super
	end
	
	def minimumSizeHint()
	    return Qt::Size.new(50, 50)
	end
	
	def sizeHint()
	    return Qt::Size.new(200, 200)
	end
	
	def rotateBy(xAngle, yAngle, zAngle)
	    @xRot += xAngle
	    @yRot += yAngle
	    @zRot += zAngle
	    updateGL()
	end
	
	def clearColor=(color)
	    @clearColor = color
	    updateGL()
	end
	
	def initializeGL()
	    if @sharedObject.nil?
	        @sharedObject = makeObject()
		end
	    @refCount += 1
	
	    GL.Enable(GL::DEPTH_TEST)
	    GL.Enable(GL::CULL_FACE)
	    GL.Enable(GL::TEXTURE_2D)
	end
	
	def paintGL()
	    qglClearColor(@clearColor)
	    GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
	    GL.LoadIdentity()
	    GL.Translated(0.0, 0.0, -10.0)
	    GL.Rotated(@xRot / 16.0, 1.0, 0.0, 0.0)
	    GL.Rotated(@yRot / 16.0, 0.0, 1.0, 0.0)
	    GL.Rotated(@zRot / 16.0, 0.0, 0.0, 1.0)
	    GL.CallList(@sharedObject)
	end
	
	def resizeGL(width, height)
	    side = [width, height].min
	    GL.Viewport((width - side) / 2, (height - side) / 2, side, side)
	
	    GL.MatrixMode(GL::PROJECTION)
	    GL.LoadIdentity()
	    GL.Ortho(-0.5, +0.5, +0.5, -0.5, 4.0, 15.0)
	    GL.MatrixMode(GL::MODELVIEW)
	end
	
	def mousePressEvent(event)
	    @lastPos = event.pos
	end
	
	def mouseMoveEvent(event)
	    dx = event.x - @lastPos.x
	    dy = event.y - @lastPos.y
	
	    if event.buttons & Qt::LeftButton.to_i != 0
	        rotateBy(8 * dy, 8 * dx, 0)
	    elsif event.buttons & Qt::RightButton.to_i != 0
	        rotateBy(8 * dy, 0, 8 * dx)
	    end
	    @lastPos = event.pos()
	end
	
	def mouseReleaseEvent(event)
	    emit clicked()
	end
	
	def makeObject()
	    coords = [
	        [ [ +1, -1, -1 ], [ -1, -1, -1 ], [ -1, +1, -1 ], [ +1, +1, -1 ] ],
	        [ [ +1, +1, -1 ], [ -1, +1, -1 ], [ -1, +1, +1 ], [ +1, +1, +1 ] ],
	        [ [ +1, -1, +1 ], [ +1, -1, -1 ], [ +1, +1, -1 ], [ +1, +1, +1 ] ],
	        [ [ -1, -1, -1 ], [ -1, -1, +1 ], [ -1, +1, +1 ], [ -1, +1, -1 ] ],
	        [ [ +1, -1, +1 ], [ -1, -1, +1 ], [ -1, -1, -1 ], [ +1, -1, -1 ] ],
	        [ [ -1, -1, +1 ], [ +1, -1, +1 ], [ +1, +1, +1 ], [ -1, +1, +1 ] ] ]
	
	    list = GL.GenLists(1)
	    GL.NewList(list, GL::COMPILE)
	
		(0...6).each do |i|
	        bindTexture(Qt::Pixmap.new("images/side%d.png" % (i + 1)))
	
	        GL.Begin(GL::QUADS)
			(0...4).each do |j|
	            GL.TexCoord2d(j == 0 || j == 3 ? 1.0 : 0.0, j == 0 || j == 1 ? 1.0 : 0.0)
	            GL.Vertex3d(0.2 * coords[i][j][0], 0.2 * coords[i][j][1],
	                       0.2 * coords[i][j][2])
	        end
	        GL.End()
	    end
	
	    GL.EndList()
	    return list
	end
end
