require 'Qt'
include Math

class CannonField < Qt::Widget
    
    signals 'hit()', 'missed()', 'angleChanged(int)', 'forceChanged(int)', 
            'canShoot(bool)'
    
    slots   'setAngle(int)', 'setForce(int)', 'shoot()', 'moveShot()', 
            'newTarget()', 'setGameOver()', 'restartGame()'
    
    
    def initialize(parent = nil)
        super
        @currentAngle = 45
        @currentForce = 0
        @timerCount = 0;
        @autoShootTimer = Qt::Timer.new( self )
        connect( @autoShootTimer, SIGNAL('timeout()'),
                 self, SLOT('moveShot()') );
        @shootAngle = 0
        @shootForce = 0
        @target = Qt::Point.new(0, 0)
        @gameEnded = false
        setPalette( Qt::Palette.new( Qt::Color.new( 250, 250, 200) ) )
        setAutoFillBackground(true)
        newTarget()
        @barrelRect = Qt::Rect.new(33, -4, 15, 8)
    end

    def angle() 
        return @currentAngle 
    end

    def force() 
        return @currentForce 
    end

    def gameOver() 
        return @gameEnded 
    end

    def setAngle( degrees )
        if degrees < 5
            degrees = 5
        elsif degrees > 70
            degrees = 70
        end
        if @currentAngle == degrees
            return
        end
        @currentAngle = degrees
        update( cannonRect() )
        emit angleChanged( @currentAngle )
    end
    
    def setForce( newton )
        if newton < 0
            newton = 0
        end
        if @currentForce == newton
            return
        end
        @currentForce = newton
        emit forceChanged( @currentForce )
    end
    
    def shoot()
        if isShooting()
            return
        end
        @timerCount = 0
        @shootAngle = @currentAngle
        @shootForce = @currentForce
        @autoShootTimer.start( 50 )
		emit canShoot( false )
    end

    @@first_time = true
    
    def newTarget()
        if @@first_time
            @@first_time = false
            midnight = Qt::Time.new( 0, 0, 0 )
            srand( midnight.secsTo(Qt::Time.currentTime()) )
        end
        @target = Qt::Point.new( 200 + rand(190), 10  + rand(255) )
        update()
    end
    
    def setGameOver()
        if @gameEnded
            return
        end
        if isShooting()
            @autoShootTimer.stop()
        end
        @gameEnded = true
        update()
    end

    def restartGame()
        if isShooting()
            @autoShootTimer.stop()
        end
        @gameEnded = false
        update()
        emit canShoot( true )
    end
    
    def moveShot()
        r = Qt::Region.new( shotRect() )
        @timerCount += 1

        shotR = shotRect()

        if shotR.intersects( targetRect() ) 
            @autoShootTimer.stop()
            emit hit()
            emit canShoot(true)
        elsif shotR.x() > width() || shotR.y() > height()
            @autoShootTimer.stop()
            emit missed()
            emit canShoot(true)
        else
            r = r.unite( Qt::Region.new( shotR ) )
        end
        
        update( r )
    end

    def paintEvent( e )
        painter = Qt::Painter.new( self )

        if @gameEnded
            painter.setPen( Qt::black )
            painter.setFont( Qt::Font.new( "Courier", 48, Qt::Font::Bold ) )
            painter.drawText( rect(), Qt::AlignCenter, "Game Over" )
        end
        paintCannon(painter)
        if isShooting()
            paintShot( painter )
        end        
        if !@gameEnded
            paintTarget( painter )
        end
        painter.end()
    end

    def paintShot( painter )
        painter.setPen( Qt::NoPen )
        painter.setBrush( Qt::Brush.new(Qt::black) )
        painter.drawRect( shotRect() )
    end

    def paintTarget( painter )
        painter.setBrush( Qt::Brush.new(Qt::red) )
        painter.setPen( Qt::Pen.new(Qt::Color.new(Qt::black)) )
        painter.drawRect( targetRect() )
    end
    
    def paintCannon(painter)                
        painter.setPen(Qt::NoPen)
        painter.setBrush(Qt::Brush.new(Qt::blue))

        painter.save()
        painter.translate(0, height())
        painter.drawPie( Qt::Rect.new(-35, -35, 70, 70), 0, 90*16 )
        painter.rotate( - @currentAngle )
        painter.drawRect( @barrelRect )
        painter.restore()
    end

    def cannonRect()
        r = Qt::Rect.new( 0, 0, 50, 50)
        r.moveBottomLeft( rect().bottomLeft() )
        return r
    end
    
    def shotRect()
        gravity = 4.0

        time      = @timerCount / 4.0
        velocity  = @shootForce
        radians   = @shootAngle*3.14159265/180.0

        velx      = velocity*cos( radians )
        vely      = velocity*sin( radians )
        x0        = ( @barrelRect.right()  + 5.0 )*cos(radians)
        y0        = ( @barrelRect.right()  + 5.0 )*sin(radians)
        x         = x0 + velx*time
        y         = y0 + vely*time - 0.5*gravity*time*time

        r = Qt::Rect.new( 0, 0, 6, 6 );
        r.moveCenter( Qt::Point.new( x.round, height() - 1 - y.round ) )
        return r
    end

    def targetRect()
        r = Qt::Rect.new( 0, 0, 20, 10 )
        r.moveCenter( Qt::Point.new(@target.x(), height() - 1 - @target.y()) )
        return r
    end
    
    def isShooting()
        return @autoShootTimer.isActive()
    end
end
