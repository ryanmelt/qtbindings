require_relative 'lcdrange.rb'
require_relative 'cannon.rb'

class GameBoard < Qt::Widget
  slots 'fire()', 'hit()', 'missed()', 'newGame()'

  def initialize()
    super
    quit = Qt::PushButton.new('&Quit')
    quit.font = Qt::Font.new('Times', 18, Qt::Font::Bold)

    connect(quit, SIGNAL('clicked()'), $qApp, SLOT('quit()'))

    angle = LCDRange.new('ANGLE')
    angle.range = 5..70

    force = LCDRange.new('FORCE')
    force.range = 10..50

    cannonBox = Qt::Frame.new
    cannonBox.frameStyle = Qt::Frame::WinPanel | Qt::Frame::Sunken

    @cannonField = CannonField.new

    connect(angle, SIGNAL('valueChanged(int)'),
            @cannonField, SLOT('angle=(int)'))
    connect(@cannonField, SIGNAL('angleChanged(int)'),
            angle, SLOT('value=(int)'))

    connect(force, SIGNAL('valueChanged(int)'),
            @cannonField, SLOT('force=(int)'))
    connect(@cannonField, SIGNAL('forceChanged(int)'),
            force, SLOT('value=(int)'))

    connect(@cannonField, SIGNAL('hit()'),
                self, SLOT('hit()'))
    connect(@cannonField, SIGNAL('missed()'),
                self, SLOT('missed()'))

    shoot = Qt::PushButton.new('&Shoot')
    shoot.font = Qt::Font.new('Times', 18, Qt::Font::Bold)

    connect(shoot, SIGNAL('clicked()'), SLOT('fire()'))
    connect(@cannonField, SIGNAL('canShoot(bool)'),
                shoot, SLOT('setEnabled(bool)'))

    restart = Qt::PushButton.new('&New Game')
    restart.font = Qt::Font.new('Times', 18, Qt::Font::Bold)

    connect(restart, SIGNAL('clicked()'), self, SLOT('newGame()'))

    @hits = Qt::LCDNumber.new(2, self)
    @shotsLeft = Qt::LCDNumber.new(2, self)
    hitsLabel = Qt::Label.new('HITS', self)
    shotsLeftLabel = Qt::Label.new('SHOTS LEFT', self)

    Qt::Shortcut.new(Qt::KeySequence.new(Qt::Key_Enter), self, SLOT('fire()'))
    Qt::Shortcut.new(Qt::KeySequence.new(Qt::Key_Return), self, SLOT('fire()'))
    Qt::Shortcut.new(Qt::KeySequence.new(Qt::CTRL + Qt::Key_Q), self, SLOT('close()'))

    topLayout = Qt::HBoxLayout.new
    topLayout.addWidget(shoot)
    topLayout.addWidget(@hits)
    topLayout.addWidget(hitsLabel)
    topLayout.addWidget(@shotsLeft)
    topLayout.addWidget(shotsLeftLabel)
    topLayout.addStretch(1)
    topLayout.addWidget(restart)

    leftLayout = Qt::VBoxLayout.new()
    leftLayout.addWidget(angle)
    leftLayout.addWidget(force)

    cannonLayout = Qt::VBoxLayout.new
    cannonLayout.addWidget(@cannonField)
    cannonBox.layout = cannonLayout

    gridLayout = Qt::GridLayout.new
    gridLayout.addWidget(quit, 0, 0)
    gridLayout.addLayout(topLayout, 0, 1)
    gridLayout.addLayout(leftLayout, 1, 0)
    gridLayout.addWidget(cannonBox, 1, 1, 2, 1)
    gridLayout.setColumnStretch(1, 10)
    setLayout(gridLayout)

    angle.value = 60
    force.value = 25
    angle.setFocus

    newGame()
  end

  def fire()
    if @cannonField.gameOver || @cannonField.shooting?
      return
    end
    @shotsLeft.display(@shotsLeft.intValue() - 1)
    @cannonField.shoot
  end

  def hit()
    @hits.display(@hits.intValue() + 1)
    if @shotsLeft.intValue() == 0
      @cannonField.setGameOver
    else
      @cannonField.newTarget
    end
  end

  def missed()
    if @shotsLeft.intValue() == 0
      @cannonField.setGameOver
    end
  end

  def newGame()
    @shotsLeft.display(15.0)
    @hits.display(0)
    @cannonField.restartGame
    @cannonField.newTarget
  end
end
