#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require 'Qt'
require 'opengl'
require 'World'
require 'Cloud'
require 'Flock'
require 'Params'
require 'Camera'

include GL

class Canvas < Qt::GLWidget

    GRASS_COLOR = [0, 0.75, 0]
    MDA_ROTATE = :MDA_ROTATE
    MDA_ZOOM = :MDA_ZOOM
    MDA_CHANGE_FOCUS = :MDA_CHANGE_FOCUS

    def initialize(parent = nil, name = '')
        super(parent)
        @grassObject = nil
    end

    def update
        updateGL()
    end

    def initializeGL()
        ClearColor(0.4, 0.4, 1.0, 0.0) # Let OpenGL clear to light blue
        @grassObject = makeGrassObject()
        ShadeModel(FLAT)
    end

    def paintGL()
        Enable(DEPTH_TEST)
        Clear(COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT)

        MatrixMode(MODELVIEW)

        camera = World.instance.camera

        LoadIdentity()
        Rotate(camera.rotation.x, 1, 0, 0)
        Rotate(camera.rotation.y, 0, 1, 0)
        Rotate(camera.rotation.z, 0, 0, 1.0)
        Translate(-camera.position.x, -camera.position.y, -camera.position.z)
        Scale(camera.zoom, camera.zoom, camera.zoom)

        CallList(@grassObject)

        World.instance.clouds.each { | cloud | cloud.draw() }
        World.instance.flock.draw()
    end

    # Set up the OpenGL view port, matrix mode, etc.
    def resizeGL(w, h)
        Viewport(0, 0, w, h)
        MatrixMode(PROJECTION)
        LoadIdentity()

#          # left, right, bottom, top, front, back (focal_length)
        halfXSize = $PARAMS['world_width'] / 2 * 1.25
        halfYSize = $PARAMS['world_height'] / 2 * 1.25
        halfZSize = $PARAMS['world_depth'] / 2 * 1.25

#            Frustum(-halfXSize, halfXSize, -halfYSize, halfYSize,
#                  5, halfZSize * 2)

        Ortho(-halfXSize, halfXSize, -halfYSize, halfYSize,
              -halfZSize, halfZSize)

        MatrixMode(MODELVIEW)
    end

    def makeGrassObject
        halfXSize = $PARAMS['world_width']
        halfYSize = $PARAMS['world_depth'] / 2
        halfZSize = $PARAMS['world_height']

        list = GenLists(1)
        NewList(list, COMPILE)
        LineWidth(2.0)
        Begin(QUADS)

        Color(GRASS_COLOR)
        # Counter-clockwise
        Vertex( halfXSize, -halfYSize,  halfZSize)
        Vertex(-halfXSize, -halfYSize,  halfZSize)
        Vertex(-halfXSize, -halfYSize, -halfZSize)
        Vertex( halfXSize, -halfYSize, -halfZSize)

        End()
        EndList()
        return list
    end

    def mousePressEvent(e)
        @mouseLoc = e.pos()
        case e.button()
        when Qt::LeftButton
            @mouseDragAction = MDA_ZOOM
        when Qt::RightButton
            @mouseDragAction = MDA_ROTATE
        when Qt::MidButton
            @mouseDragAction = MDA_CHANGE_FOCUS
        end
    end

    # Rotate around sphere with right (#2) button. Zoom with left button.
    # Change focus with left button.
    def mouseMoveEvent(e)
        return if @mouseLoc.nil?

        dx = dy = 0
        if e.x() != @mouseLoc.x()
            dx = e.x() - @mouseLoc.x() # move right increases dx
            @mouseLoc.setX(e.x())
        end
        if e.y() != @mouseLoc.y()
            dy = @mouseLoc.y() - e.y() # move up increases dy
            @mouseLoc.setY(e.y())
        end

        return if dx == 0 && dy == 0

        case @mouseDragAction
        when MDA_ZOOM
            return if (dy == 0)
            World.instance.camera.zoom += 0.1 * -dy
        when MDA_ROTATE
            break
        when MDA_CHANGE_FOCUS
            break
        end
        World.instance.setupTranslation()
    end
end
