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
	
	
class Receiver < Qt::Dialog
		
	slots :processPendingDatagrams

	def initialize(parent = nil)
	    super(parent)
	    @statusLabel = Qt::Label.new(tr("Listening for broadcasted messages"))
	    @quitButton = Qt::PushButton.new(tr("&Quit"))
	
	    @udpSocket = Qt::UdpSocket.new(self)
	    @udpSocket.bind(45454)
	
	    connect(@udpSocket, SIGNAL(:readyRead),
	            self, SLOT(:processPendingDatagrams))
	    connect(@quitButton, SIGNAL(:clicked), self, SLOT(:close))
	
	    buttonLayout = Qt::HBoxLayout.new do |b|
	    	b.addStretch(1)
	   		b.addWidget(@quitButton)
		end
	
	    self.layout = Qt::VBoxLayout.new do |m|
	    	m.addWidget(@statusLabel)
	    	m.addLayout(buttonLayout)
	    end
	
	    self.windowTitle = tr("Broadcast Receiver")
	end
	
	def processPendingDatagrams()
	    while @udpSocket.hasPendingDatagrams do
	        datagram = Qt::ByteArray.new
	        datagram.resize(@udpSocket.pendingDatagramSize)
	        @udpSocket.readDatagram(datagram.data(), datagram.size())
	        @statusLabel.text = tr('Received datagram: "%d"' % datagram.data)
	    end
	end
end
