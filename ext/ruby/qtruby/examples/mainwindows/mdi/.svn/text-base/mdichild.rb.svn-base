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
	
	
	
class MdiChild < Qt::TextEdit
	
	attr_reader :currentFile

	slots 'documentWasModified()'
	
	def initialize()
		super
	    setAttribute(Qt::WA_DeleteOnClose)
	    @isUntitled = true
	end
	
	def newFile()
	    @@sequenceNumber = 1
	
	    @isUntitled = true
	    @currentFile = tr("document%s.txt" % @@sequenceNumber += 1)
	    setWindowTitle(@currentFile + "[*]")
	
	    connect(document(), SIGNAL('contentsChanged()'),
	            self, SLOT('documentWasModified()'))
	end
	
	def loadFile(fileName)
	    file = Qt::File.new(fileName)
	    if !file.open(Qt::File::ReadOnly | Qt::File::Text)
	        Qt::MessageBox.warning(self, tr("MDI"),
	                             tr("Cannot read file %s:\n%s." % [fileName, file.errorString]))
	        return false
	    end
	
	    inf = Qt::TextStream.new(file)
	    Qt::Application.overrideCursor = Qt::Cursor.new(Qt::WaitCursor)
	    setPlainText(inf.readAll())
	    Qt::Application.restoreOverrideCursor()
	
	    setCurrentFile(fileName)
	
	    connect(document(), SIGNAL('contentsChanged()'),
	            self, SLOT('documentWasModified()'))
	
	    return true
	end
	
	def save()
	    if @isUntitled
	        return saveAs()
	    else
	        return saveFile(@currentFile)
	    end
	end
	
	def saveAs()
	    fileName = Qt::FileDialog.getSaveFileName(self, tr("Save As"),
	                                                    @currentFile)
	    if fileName.empty?
	        return false
		end
	
	    return saveFile(fileName)
	end
	
	def saveFile(fileName)
	    file = Qt::File.new(fileName)
	    if !file.open(Qt::File::WriteOnly | Qt::File::Text)
	        Qt::MessageBox::warning(self, tr("MDI"),
	                             tr("Cannot write file %s:\n%s." % [fileName, file.errorString]))
	        return false
	    end
	
	    outf = Qt::TextStream.new(file)
	    Qt::Application.setOverrideCursor(Qt::WaitCursor)
	    outf << toPlainText()
	    Qt::Application.restoreOverrideCursor()
	
	    setCurrentFile(fileName)
	    return true
	end
	
	def userFriendlyCurrentFile()
	    return strippedName(@currentFile)
	end
	
	def closeEvent(event)
	    if maybeSave()
	        event.accept()
	    else
	        event.ignore()
	    end
	end
	
	def documentWasModified()
	    setWindowModified(document().isModified())
	end
	
	def maybeSave()
	    if document().isModified()
	        ret = Qt::MessageBox::warning(self, tr("MDI"),
	                     tr("'%s' has been modified.\n" \
	                        "Do you want to save your changes?" % 
                              userFriendlyCurrentFile()),
	                     Qt::MessageBox::Yes | Qt::MessageBox::Default,
	                     Qt::MessageBox::No,
	                     Qt::MessageBox::Cancel | Qt::MessageBox::Escape)
	        if ret == Qt::MessageBox::Yes
	            return save()
	        elsif ret == Qt::MessageBox::Cancel
	            return false
			end
	    end
	    return true
	end
	
	def setCurrentFile(fileName)
	    @currentFile = Qt::FileInfo.new(fileName).canonicalFilePath()
	    @isUntitled = false
	    document().modified = false
	    setWindowModified(false)
	    setWindowTitle(userFriendlyCurrentFile() + "[*]")
	end
	
	def strippedName(fullFileName)
	    return Qt::FileInfo.new(fullFileName).fileName()
	end
end
