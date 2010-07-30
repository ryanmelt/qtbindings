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
include Math

class GLWidget < Qt::GLWidget

    slots   'setXRotation(int)',
            'setYRotation(int)',
            'setZRotation(int)'
    
    signals 'xRotationChanged(int)',
            'yRotationChanged(int)',
            'zRotationChanged(int)'
    
    NumSectors = 200
    
    def initialize(parent)
        super(parent)
        @object = 0
        @xRot = 0
        @yRot = 0
        @zRot = 0
    
        @trolltechGreen = Qt::Color.fromCmykF(0.40, 0.0, 1.0, 0.0)
        @trolltechPurple = Qt::Color.fromCmykF(0.39, 0.39, 0.0, 0.0)
    end
    
    def dispose()
        makeCurrent()
        glDeleteLists(object, 1)
        super
    end

    def xRotation() return @xRot end
    def yRotation() return @yRot end
    def zRotation() return @zRot end
    
    def minimumSizeHint()
        return Qt::Size.new(50, 50)
    end
    
    def sizeHint()
        return Qt::Size.new(400, 400)
    end
    
    def setXRotation(angle)
        angle = normalizeAngle(angle)
        if angle != @xRot
            @xRot = angle
            emit xRotationChanged(angle)
            updateGL()
        end
    end
    
    def setYRotation(angle)
        angle = normalizeAngle(angle)
        if angle != @yRot
            @yRot = angle
            emit yRotationChanged(angle)
            updateGL()
        end
    end
    
    def setZRotation(angle)
        angle = normalizeAngle(angle)
        if angle != @zRot
            @zRot = angle
            emit zRotationChanged(angle)
            updateGL()
        end
    end
    
    def initializeGL()
        qglClearColor(@trolltechPurple.dark)
        @object = makeObject()
        GL.ShadeModel(GL::FLAT)
        GL.Enable(GL::DEPTH_TEST)
        GL.Enable(GL::CULL_FACE)
    end
    
    def paintGL()
        GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
        GL.LoadIdentity()
        GL.Translated(0.0, 0.0, -10.0)
        GL.Rotated(@xRot / 16.0, 1.0, 0.0, 0.0)
        GL.Rotated(@yRot / 16.0, 0.0, 1.0, 0.0)
        GL.Rotated(@zRot / 16.0, 0.0, 0.0, 1.0)
        GL.CallList(@object)
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
            setXRotation(@xRot + 8 * dy)
            setYRotation(@yRot + 8 * dx)
        elsif event.buttons & Qt::RightButton.to_i != 0
            setXRotation(@xRot + 8 * dy)
            setZRotation(@zRot + 8 * dx)
        end
        @lastPos = event.pos
    end
    
    def makeObject()
        list = GL.GenLists(1)
        GL.NewList(list, GL::COMPILE)
    
        GL.Begin(GL::QUADS)
    
        x1 = +0.06
        y1 = -0.14
        x2 = +0.14
        y2 = -0.06
        x3 = +0.08
        y3 = +0.00
        x4 = +0.30
        y4 = +0.22
    
        quad(x1, y1, x2, y2, y2, x2, y1, x1)
        quad(x3, y3, x4, y4, y4, x4, y3, x3)
    
        extrude(x1, y1, x2, y2)
        extrude(x2, y2, y2, x2)
        extrude(y2, x2, y1, x1)
        extrude(y1, x1, x1, y1)
        extrude(x3, y3, x4, y4)
        extrude(x4, y4, y4, x4)
        extrude(y4, x4, y3, x3)
    
        (0...NumSectors).each do |i|
            angle1 = (i * 2 * PI) / NumSectors
            x5 = 0.30 * sin(angle1)
            y5 = 0.30 * cos(angle1)
            x6 = 0.20 * sin(angle1)
            y6 = 0.20 * cos(angle1)
    
            angle2 = ((i + 1) * 2 * PI) / NumSectors
            x7 = 0.20 * sin(angle2)
            y7 = 0.20 * cos(angle2)
            x8 = 0.30 * sin(angle2)
            y8 = 0.30 * cos(angle2)
    
            quad(x5, y5, x6, y6, x7, y7, x8, y8)
    
            extrude(x6, y6, x7, y7)
            extrude(x8, y8, x5, y5)
        end
    
        GL.End()
    
        GL.EndList()
        return list
    end
    
    def quad(x1, y1, x2, y2, x3, y3, x4, y4)
        qglColor(@trolltechGreen)
    
        GL.Vertex3d(x1, y1, -0.05)
        GL.Vertex3d(x2, y2, -0.05)
        GL.Vertex3d(x3, y3, -0.05)
        GL.Vertex3d(x4, y4, -0.05)
    
        GL.Vertex3d(x4, y4, +0.05)
        GL.Vertex3d(x3, y3, +0.05)
        GL.Vertex3d(x2, y2, +0.05)
        GL.Vertex3d(x1, y1, +0.05)
    end
    
    def extrude(x1, y1, x2, y2)
        qglColor(@trolltechGreen.dark(250 + (100 * x1)))
    
        GL.Vertex3d(x1, y1, +0.05)
        GL.Vertex3d(x2, y2, +0.05)
        GL.Vertex3d(x2, y2, -0.05)
        GL.Vertex3d(x1, y1, -0.05)
    end
    
    def normalizeAngle(angle)
        while angle < 0 do
            angle += 360 * 16
        end
        while angle > 360 * 16 do
            angle -= 360 * 16
        end
        return angle
    end
end
