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
    
    slots 'advanceGears()'

    def initialize(parent = nil)
        super(parent)
        @xRot = 0
        @yRot = 0
        @zRot = 0
        @gear1Rot = 0
        @lastPos = Qt::Point.new
    
        timer = Qt::Timer.new(self)
        connect(timer, SIGNAL('timeout()'), self, SLOT('advanceGears()'))
        timer.start(20)
    end

    def xRotation() return @xRot end
    def yRotation() return @yRot end
    def zRotation() return @zRot end
    
    def dispose()
        makeCurrent()
        GL.DeleteLists(@gear1, 1)
        GL.DeleteLists(@gear2, 1)
        GL.DeleteLists(@gear3, 1)
        super
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
    
    def initializeGL
        lightPos = [ 5.0, 5.0, 10.0, 1.0 ]
        reflectance1 = [ 0.8, 0.1, 0.0, 1.0 ]
        reflectance2 = [ 0.0, 0.8, 0.2, 1.0 ]
        reflectance3 = [ 0.2, 0.2, 1.0, 1.0 ]
    
        GL.Lightfv(GL::LIGHT0, GL::POSITION, lightPos)
        GL.Enable(GL::LIGHTING)
        GL.Enable(GL::LIGHT0)
        GL.Enable(GL::DEPTH_TEST)
    
        @gear1 = makeGear(reflectance1, 1.0, 4.0, 1.0, 0.7, 20)
        @gear2 = makeGear(reflectance2, 0.5, 2.0, 2.0, 0.7, 10)
        @gear3 = makeGear(reflectance3, 1.3, 2.0, 0.5, 0.7, 10)
    
        GL.Enable(GL::NORMALIZE)
    end
    
    def paintGL()
        GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
    
        GL.PushMatrix
        GL.Rotated(@xRot / 16.0, 1.0, 0.0, 0.0)
        GL.Rotated(@yRot / 16.0, 0.0, 1.0, 0.0)
        GL.Rotated(@zRot / 16.0, 0.0, 0.0, 1.0)
    
        drawGear(@gear1, -3.0, -2.0, 0.0, @gear1Rot / 16.0)
        drawGear(@gear2, +3.1, -2.0, 0.0, -2.0 * (@gear1Rot / 16.0) - 9.0)
    
        GL.Rotated(+90.0, 1.0, 0.0, 0.0)
        drawGear(@gear3, -3.1, -1.8, -2.2, +2.0 * (@gear1Rot / 16.0) - 2.0)
    
        GL.PopMatrix
    end
    
    def resizeGL(width, height)
        side = [width, height].min
        GL.Viewport((width - side) / 2, (height - side) / 2, side, side)
    
        GL.MatrixMode(GL::PROJECTION)
        GL.LoadIdentity
        GL.Frustum(-1.0, +1.0, -1.0, 1.0, 5.0, 60.0)
        GL.MatrixMode(GL::MODELVIEW)
        GL.LoadIdentity
        GL.Translated(0.0, 0.0, -40.0)
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
    
    def advanceGears
        @gear1Rot += 2 * 16
        updateGL()
    end
    
    def makeGear(reflectance, innerRadius,
                              outerRadius, thickness,
                              toothSize, toothCount)
        list = GL.GenLists(1)
        GL.NewList(list, GL::COMPILE)
        GL.Material(GL::FRONT, GL::AMBIENT_AND_DIFFUSE, reflectance)
    
        r0 = innerRadius
        r1 = outerRadius - toothSize / 2.0
        r2 = outerRadius + toothSize / 2.0
        delta = (2.0 * PI / toothCount) / 4.0
        z = thickness / 2.0
    
        GL.ShadeModel(GL::FLAT)
    
        for i in 0...2
            sign = (i == 0) ? +1.0 : -1.0
    
            GL.Normal3d(0.0, 0.0, sign)
    
            GL.Begin(GL::QUAD_STRIP)
            for j in 0..toothCount
                angle = 2.0 * PI * j / toothCount
                GL.Vertex3d(r0 * cos(angle), r0 * sin(angle), sign * z)
                GL.Vertex3d(r1 * cos(angle), r1 * sin(angle), sign * z)
                GL.Vertex3d(r0 * cos(angle), r0 * sin(angle), sign * z)
                GL.Vertex3d(r1 * cos(angle + 3 * delta), r1 * sin(angle + 3 * delta),
                            sign * z)
            end
            GL.End
    
            GL.Begin(GL::QUADS)
            for j in 0...toothCount
                angle = 2.0 * PI * j / toothCount
                GL.Vertex3d(r1 * cos(angle), r1 * sin(angle), sign * z)
                GL.Vertex3d(r2 * cos(angle + delta), r2 * sin(angle + delta),
                            sign * z)
                GL.Vertex3d(r2 * cos(angle + 2 * delta), r2 * sin(angle + 2 * delta),
                            sign * z)
                GL.Vertex3d(r1 * cos(angle + 3 * delta), r1 * sin(angle + 3 * delta),
                            sign * z)
            end
            GL.End
        end
    
        GL.Begin(GL::QUAD_STRIP)
        for i in 0...toothCount
            for j in 0...2
                angle = 2.0 * PI * (i + (j / 2.0)) / toothCount
                s1 = r1
                s2 = r2
                if j == 1
                    s1, s2 = s2, s1
                end
    
                GL.Normal3d(cos(angle), sin(angle), 0.0)
                GL.Vertex3d(s1 * cos(angle), s1 * sin(angle), +z)
                GL.Vertex3d(s1 * cos(angle), s1 * sin(angle), -z)
        
                GL.Normal3d(s2 * sin(angle + delta) - s1 * sin(angle),
                            s1 * cos(angle) - s2 * cos(angle + delta), 0.0)
                GL.Vertex3d(s2 * cos(angle + delta), s2 * sin(angle + delta), +z)
                GL.Vertex3d(s2 * cos(angle + delta), s2 * sin(angle + delta), -z)
            end
        end
        GL.Vertex3d(r1, 0.0, +z)
        GL.Vertex3d(r1, 0.0, -z)
        GL.End
    
        GL.ShadeModel(GL::SMOOTH)
    
        GL.Begin(GL::QUAD_STRIP)
        for i in 0..toothCount
            angle = i * 2.0 * PI / toothCount
            GL.Normal3d(-cos(angle), -sin(angle), 0.0)
            GL.Vertex3d(r0 * cos(angle), r0 * sin(angle), +z)
            GL.Vertex3d(r0 * cos(angle), r0 * sin(angle), -z)
        end
        GL.End
    
        GL.EndList
    
        return list
    end
    
    def drawGear(gear, dx, dy, dz, angle)
        GL.PushMatrix
        GL.Translated(dx, dy, dz)
        GL.Rotated(angle, 0.0, 0.0, 1.0)
        GL.CallList(gear)
        GL.PopMatrix
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
