#!/usr/bin/ruby -w

require 'Qt'
require 'rexml/document'

require '../base/rui.rb'

class MyTextEditor < Qt::TextEdit
   signals 'saved()'
   slots 'insert_icon()', 'new()', 'open()', 'save_as()'
   def initialize(w = nil)
      @images = {}
      @@next_image_id = 0
      super(w)
      self.setTextFormat(Qt::RichText)
   end
   def insert_richtext(richtext)
      # todo, use a rand string
      unique_string = '000___xxx123456789xxx___xxx123456789xxx___000'
      insert(unique_string)
      txt = self.text().gsub(unique_string, richtext)
      self.setText(txt)
   end
   def next_image_id
      @@next_image_id += 1
   end
   def load_image(fname, image_id)
      pixmap = Qt::Pixmap.new(fname)
      msfactory = Qt::MimeSourceFactory.defaultFactory
      msfactory.setPixmap(image_id, pixmap)
      @images[image_id] = fname
      image_id
   end
   def insert_icon
      fname = Qt::FileDialog.getOpenFileName
      return if fname.nil?
      image_id = "image_#{next_image_id}"
      load_image(fname, image_id)
      insert_richtext('<qt><img source="'+image_id+'"></qt>')
   end
   def createPopupMenu(pos) # virtual
      pm = Qt::PopupMenu.new
      pm.insertItem("Insert Image!", self, SLOT('insert_icon()'))
      pm
   end
   def has_metadata
      !@images.empty?
   end
   def metadata_fname(fname)
      "#{fname}.metadata.xml"
   end
   def attempt_metadata_load(fname)
      return unless File.exists?(metadata_fname(fname))
      file = File.open(metadata_fname(fname))
      @xmldoc = REXML::Document.new file
      @xmldoc.root.elements.each("image") {
         |image|
         image_id = image.attributes["ident"]
         img_fname = image.attributes["filename"]
         load_image(img_fname, image_id)
      }
   end
   def metadata_save_if_has(fname)
      return if not has_metadata
      metadata_doc = REXML::Document.new '<metadata/>'
      @images.each {
         |id, img_fname|
         metadata_doc.root.add_element("image", {"filename"=>img_fname, "ident"=>id})
      }
      file = File.new(metadata_fname(fname), "w")
      file.puts(metadata_doc)
      file.close
   end
   def metadata_clear
      @images = {}
   end
   def new(txt = "")
      metadata_clear
      self.setText(txt)
   end
   def open
      fname = Qt::FileDialog.getOpenFileName
      return if fname.nil?
      unless File.exists?(fname)
         Qt::MessageBox.critical(self, "File Does Not Exist", "Sorry, unable to find the requested file!")
         return
      end
      return if fname.nil?
      txt = File.open(fname).gets(nil)
      metadata_clear
      attempt_metadata_load(fname)
      self.setText(txt)
   end
   def save_as
      fname = Qt::FileDialog.getSaveFileName
      return if fname.nil?
      if File.exists?(fname)
         Qt::MessageBox.critical(self, "File Already Exists", "Sorry, file already exists. Please choose a non-existing filename!")
         return save_as
      end
      file = File.new(fname, "w")
      file.puts(text())
      file.close
      metadata_save_if_has(fname)
      emit saved()
   end
end

class MyWidget < Qt::MainWindow
   slots 'text_changed()', 'saved()'
   def initialize()
      super
      @editor = MyTextEditor.new(self)
      connect(@editor, SIGNAL('textChanged()'), self, SLOT('text_changed()'))
      connect(@editor, SIGNAL('saved()'), self, SLOT('saved()'))

      fileTools = Qt::ToolBar.new(self, "file operations")
      fileMenu = Qt::PopupMenu.new(self)

      actions = [
         RAction.new("&New",  Icons::FILE_NEW, @editor, SLOT('new()'), [fileTools, fileMenu]),
         RAction.new("&Open...", Icons::FILE_OPEN, @editor, SLOT('open()'), [fileTools, fileMenu]),
         @save = RAction.new("Save &As...", Icons::FILE_SAVE_AS, @editor, SLOT('save_as()'), [fileTools, fileMenu]),
         RSeperator.new([fileMenu]),
         RAction.new("E&xit", Icons::EXIT, $qApp, SLOT('quit()'), [fileMenu])
      ]

      build_actions(actions)

      menubar = Qt::MenuBar.new(self)
      menubar.insertItem("&File", fileMenu)

      self.setCentralWidget(@editor)
   end
   def saved
      @save.action.setEnabled(false)
   end
   def text_changed
      @save.action.setEnabled(true)
   end
end

a = Qt::Application.new(ARGV)

w = MyWidget.new
w.show

a.setMainWidget(w)
a.exec()
exit
