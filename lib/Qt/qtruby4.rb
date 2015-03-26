=begin
/***************************************************************************
                          qtruby.rb  -  description
                             -------------------
    begin                : Fri Jul 4 2003
    copyright            : (C) 2003-2008 by Richard Dale
    email                : richard.j.dale@gmail.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Lesser General Public License as        *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 ***************************************************************************/
=end

module Qt

  module DebugLevel
    Off, Minimal, High, Extensive = 0, 1, 2, 3
  end

  module QtDebugChannel
    QTDB_NONE = 0x00
    QTDB_AMBIGUOUS = 0x01
    QTDB_METHOD_MISSING = 0x02
    QTDB_CALLS = 0x04
    QTDB_GC = 0x08
    QTDB_VIRTUAL = 0x10
    QTDB_VERBOSE = 0x20
    QTDB_ALL = QTDB_VERBOSE | QTDB_VIRTUAL | QTDB_GC | QTDB_CALLS | QTDB_METHOD_MISSING | QTDB_AMBIGUOUS
  end

  @@debug_level = DebugLevel::Off
  def Qt.debug_level=(level)
    @@debug_level = level
    Internal::setDebug Qt::QtDebugChannel::QTDB_ALL if level >= DebugLevel::Extensive
  end

  def Qt.debug_level
    @@debug_level
  end

  module Internal
    #
    # From the enum MethodFlags in qt-copy/src/tools/moc/generator.cpp
    #
    AccessPrivate = 0x00
    AccessProtected = 0x01
    AccessPublic = 0x02
    MethodMethod = 0x00
    MethodSignal = 0x04
    MethodSlot = 0x08
    MethodCompatibility = 0x10
    MethodCloned = 0x20
    MethodScriptable = 0x40
  end

  class Base
    def self.signals(*signal_list)
      meta = Qt::Meta[self.name] || Qt::MetaInfo.new(self)
      meta.add_signals(signal_list, Internal::MethodSignal | Internal::AccessProtected)
      meta.changed = true
    end

    def self.slots(*slot_list)
      meta = Qt::Meta[self.name] || Qt::MetaInfo.new(self)
      meta.add_slots(slot_list, Internal::MethodSlot | Internal::AccessPublic)
      meta.changed = true
    end

    def self.private_slots(*slot_list)
      meta = Qt::Meta[self.name] || Qt::MetaInfo.new(self)
      meta.add_slots(slot_list, Internal::MethodSlot | Internal::AccessPrivate)
      meta.changed = true
    end

    def self.q_signal(signal)
      meta = Qt::Meta[self.name] || Qt::MetaInfo.new(self)
      meta.add_signals([signal], Internal::MethodSignal | Internal::AccessProtected)
      meta.changed = true
    end

    def self.q_slot(slot)
      meta = Qt::Meta[self.name] || Qt::MetaInfo.new(self)
      meta.add_slots([slot], Internal::MethodSlot | Internal::AccessPublic)
      meta.changed = true
    end

    def self.q_classinfo(key, value)
      meta = Qt::Meta[self.name] || Qt::MetaInfo.new(self)
      meta.add_classinfo(key, value)
      meta.changed = true
    end

    def **(a)
      return Qt::**(self, a)
    end
    def +(a)
      return Qt::+(self, a)
    end
    def ~(a)
      return Qt::~(self, a)
    end
    def -@()
      return Qt::-(self)
    end
    def -(a)
      return Qt::-(self, a)
    end
    def *(a)
      return Qt::*(self, a)
    end
    def /(a)
      return Qt::/(self, a) #/
    end
    def %(a)
      return Qt::%(self, a)
    end
    def >>(a)
      return Qt::>>(self, a)
    end
    def <<(a)
      return Qt::<<(self, a)
    end
    def &(a)
      return Qt::&(self, a)
    end
    def ^(a)
      return Qt::^(self, a)
    end
    def |(a)
      return Qt::|(self, a)
    end

#    Module has '<', '<=', '>' and '>=' operator instance methods, so pretend they
#    don't exist by calling method_missing() explicitly
    def <(a)
      begin
        Qt::method_missing(:<, self, a)
      rescue
        super(a)
      end
    end

    def <=(a)
      begin
        Qt::method_missing(:<=, self, a)
      rescue
        super(a)
      end
    end

    def >(a)
      begin
        Qt::method_missing(:>, self, a)
      rescue
        super(a)
      end
    end

    def >=(a)
      begin
        Qt::method_missing(:>=, self, a)
      rescue
        super(a)
      end
    end

#    Object has a '==' operator instance method, so pretend it
#    don't exist by calling method_missing() explicitly
    def ==(a)
      return false if a.nil?
      begin
        Qt::method_missing(:==, self, a)
      rescue
        super(a)
      end
    end

    def self.ancestors
      klass = self
      classid = nil
      loop do
        classid = Qt::Internal::find_pclassid(klass.name)
        break if classid.index

        klass = klass.superclass
        if klass.nil?
          return super
        end
      end

      klasses = super
      klasses.delete(Qt::Base)
      klasses.delete(self)
      ids = []
      Qt::Internal::getAllParents(classid, ids)
      return [self] + ids.map {|id| Qt::Internal.find_class(Qt::Internal.classid2name(id))} + klasses
    end

    # Change the behaviors of is_a? and kind_of? (alias of is_a?) to use above self.ancestors method
    # Note: this definition also affects Object#===
    def is_a?(mod)
      super || self.class.ancestors.include?(mod)
    end
    alias :kind_of? :is_a?

    def methods(regular=true)
      if !regular
        return singleton_methods
      end

      qt_methods(super, 0x0)
    end

    def protected_methods(all=true)
      # From smoke.h, Smoke::mf_protected 0x80
      qt_methods(super, 0x80)
    end

    def public_methods(all=true)
      methods
    end

    def singleton_methods(all=true)
      # From smoke.h, Smoke::mf_static 0x01
      qt_methods(super, 0x01)
    end

    private
    def qt_methods(meths, flags)
      ids = []
      # These methods are all defined in Qt::Base, even if they aren't supported by a particular
      # subclass, so remove them to avoid confusion
      meths -= ["%", "&", "*", "**", "+", "-", "-@", "/", "<", "<<", "<=", ">", ">=", ">>", "|", "~", "^"]
      classid = Qt::Internal::idInstance(self)
      Qt::Internal::getAllParents(classid, ids)
      ids << classid
      ids.each { |c| Qt::Internal::findAllMethodNames(meths, c, flags) }
      return meths.uniq
    end
  end # Qt::Base

  # Provides a mutable numeric class for passing to methods with
  # C++ 'int*' or 'int&' arg types
  class Integer
    attr_accessor :value
    def initialize(n=0) @value = n end

    def +(n)
      return Integer.new(@value + n.to_i)
    end
    def -(n)
      return Integer.new(@value - n.to_i)
    end
    def *(n)
      return Integer.new(@value * n.to_i)
    end
    def /(n)
      return Integer.new(@value / n.to_i)
    end
    def %(n)
      return Integer.new(@value % n.to_i)
    end
    def **(n)
      return Integer.new(@value ** n.to_i)
    end

    def |(n)
      return Integer.new(@value | n.to_i)
    end
    def &(n)
      return Integer.new(@value & n.to_i)
    end
    def ^(n)
      return Integer.new(@value ^ n.to_i)
    end
    def <<(n)
      return Integer.new(@value << n.to_i)
    end
    def >>(n)
      return Integer.new(@value >> n.to_i)
    end
    def >(n)
      return @value > n.to_i
    end
    def >=(n)
      return @value >= n.to_i
    end
    def <(n)
      return @value < n.to_i
    end
    def <=(n)
      return @value <= n.to_i
    end

    def <=>(n)
      if @value < n.to_i
        return -1
      elsif @value > n.to_i
        return 1
      else
        return 0
      end
    end

    def to_f() return @value.to_f end
    def to_i() return @value.to_i end
    def to_s() return @value.to_s end

    def coerce(n)
      [n, @value]
    end
  end

  # If a C++ enum was converted to an ordinary ruby Integer, the
  # name of the type is lost. The enum type name is needed for overloaded
  # method resolution when two methods differ only by an enum type.
  class Enum
    attr_accessor :type, :value
    def initialize(n, enum_type)
      @value = n
      @type = enum_type
    end

    def +(n)
      return @value + n.to_i
    end
    def -(n)
      return @value - n.to_i
    end
    def *(n)
      return @value * n.to_i
    end
    def /(n)
      return @value / n.to_i
    end
    def %(n)
      return @value % n.to_i
    end
    def **(n)
      return @value ** n.to_i
    end

    def |(n)
      return Enum.new(@value | n.to_i, @type)
    end
    def &(n)
      return Enum.new(@value & n.to_i, @type)
    end
    def ^(n)
      return Enum.new(@value ^ n.to_i, @type)
    end
    def ~()
      return ~ @value
    end
    def <(n)
      return @value < n.to_i
    end
    def <=(n)
      return @value <= n.to_i
    end
    def >(n)
      return @value > n.to_i
    end
    def >=(n)
      return @value >= n.to_i
    end
    def <<(n)
      return Enum.new(@value << n.to_i, @type)
    end
    def >>(n)
      return Enum.new(@value >> n.to_i, @type)
    end

    def ==(n) return @value == n.to_i end
    def to_i() return @value end

    def to_f() return @value.to_f end
    def to_s() return @value.to_s end

    def coerce(n)
      [n, @value]
    end

    def inspect
      to_s
    end

    def pretty_print(pp)
      pp.text "#<%s:0x%8.8x @type=%s, @value=%d>" % [self.class.name, object_id, type, value]
    end
  end

  # Provides a mutable boolean class for passing to methods with
  # C++ 'bool*' or 'bool&' arg types
  class Boolean
    attr_accessor :value
    def initialize(b=false) @value = b end
    def nil?
      return !@value
    end
  end

  class AbstractSlider < Qt::Base
    def range=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class AbstractSocket < Qt::Base
    def abort(*args)
      method_missing(:abort, *args)
    end
  end

  class AbstractTextDocumentLayout < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class AccessibleEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class ActionEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Action < Qt::Base
    def setShortcut(arg)
      if arg.kind_of?(String)
        return super(Qt::KeySequence.new(arg))
      else
        return super(arg)
      end
    end

    def shortcut=(arg)
      setShortcut(arg)
    end
  end

  class Application < Qt::Base
    attr_reader :thread_fix

    def initialize(*args)
      if args.length == 1 && args[0].kind_of?(Array)
        super(args.length + 1, [$0] + args[0])
      else
        super(*args)
      end
      $qApp = self
      @thread_fix = RubyThreadFix.new
    end

    def disable_threading
      @thread_fix.stop if @thread_fix
      @thread_fix = nil
    end

    # Delete the underlying C++ instance after exec returns
    # Otherwise, rb_gc_call_finalizer_at_exit() can delete
    # stuff that Qt::Application still needs for its cleanup.
    def exec
      result = method_missing(:exec)
      disable_threading()
      self.dispose
      Qt::Internal.application_terminated = true
      result
    end

    def type(*args)
      method_missing(:type, *args)
    end

    def self.translate(*args)
      if args[3] and args[3].value == Qt::Application::UnicodeUTF8.value
        return method_missing(:translate,*args).force_encoding('utf-8')
      else
        return method_missing(:translate,*args)
      end
    end
  end

  class Buffer < Qt::Base
    def open(*args)
      method_missing(:open, *args)
    end
  end

  class ButtonGroup < Qt::Base
    def id(*args)
      method_missing(:id, *args)
    end
  end

  class ByteArray < Qt::Base
    def initialize(*args)
      if args.size == 1 && args[0].kind_of?(String)
        super(args[0], args[0].size)
      else
        super
      end
    end

    def to_s
      return constData()
    end

    def to_i
      return toInt()
    end

    def to_f
      return toDouble()
    end

    def chop(*args)
      method_missing(:chop, *args)
    end

    def split(*args)
      method_missing(:split, *args)
    end
  end

  class CheckBox < Qt::Base
    def setShortcut(arg)
      if arg.kind_of?(String)
        return super(Qt::KeySequence.new(arg))
      else
        return super(arg)
      end
    end

    def shortcut=(arg)
      setShortcut(arg)
    end
  end

  class ChildEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class CloseEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Color < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " %s>" % name)
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " %s>" % name)
    end

    def name(*args)
      method_missing(:name, *args)
    end
  end

  class Connection < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " memberName=%s, memberType=%s, object=%s>" %
        [memberName.inspect, memberType == 1 ? "SLOT" : "SIGNAL", object.inspect] )
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n memberName=%s,\n memberType=%s,\n object=%s>" %
        [memberName.inspect, memberType == 1 ? "SLOT" : "SIGNAL", object.inspect] )
    end
  end

  class ContextMenuEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class CoreApplication < Qt::Base
    attr_reader :thread_fix

    def initialize(*args)
      if args.length == 1 && args[0].kind_of?(Array)
        super(args.length + 1, [$0] + args[0])
      else
        super(*args)
      end
      $qApp = self
      @thread_fix = RubyThreadFix.new
    end

    def disable_threading
      @thread_fix.stop if @thread_fix
      @thread_fix = nil
    end

    # Delete the underlying C++ instance after exec returns
    # Otherwise, rb_gc_call_finalizer_at_exit() can delete
    # stuff that Qt::Application still needs for its cleanup.
    def exec
      method_missing(:exec)
      disable_threading()
      self.dispose
      Qt::Internal.application_terminated = true
    end

    def type(*args)
      method_missing(:type, *args)
    end

    def exit(*args)
      method_missing(:exit, *args)
    end

    def self.translate(*args)
      if args[3] and args[3].value == Qt::Application::UnicodeUTF8.value
        return method_missing(:translate,*args).force_encoding('utf-8')
      else
        return method_missing(:translate,*args)
      end
    end
  end

  class Cursor < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " shape=%d>" % shape)
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " shape=%d>" % shape)
    end
  end

  class CustomEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Date < Qt::Base
    def initialize(*args)
      if args.size == 1 && args[0].class.name == "Date"
        return super(args[0].year, args[0].month, args[0].day)
      else
        return super(*args)
      end
    end

    def inspect
      str = super
      str.sub(/>$/, " %s>" % toString)
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " %s>" % toString)
    end

    def to_date
      ::Date.new! to_julian_day
    end
  end

  class DateTime < Qt::Base
    def initialize(*args)
      if args.size == 1 && args[0].class.name == "DateTime"
        return super(  Qt::Date.new(args[0].year, args[0].month, args[0].day),
                Qt::Time.new(args[0].hour, args[0].min, args[0].sec) )
      elsif args.size == 1 && args[0].class.name == "Time"
        result = super(  Qt::Date.new(args[0].year, args[0].month, args[0].day),
                Qt::Time.new(args[0].hour, args[0].min, args[0].sec, args[0].usec / 1000) )
        result.timeSpec = (args[0].utc? ? Qt::UTC : Qt::LocalTime)
        return result
      else
        return super(*args)
      end
    end

    def to_time
      if timeSpec == Qt::UTC
        return ::Time.utc(  date.year, date.month, date.day,
                  time.hour, time.minute, time.second, time.msec * 1000 )
      else
        return ::Time.local(  date.year, date.month, date.day,
                    time.hour, time.minute, time.second, time.msec * 1000 )
      end
    end

    def inspect
      str = super
      str.sub(/>$/, " %s>" % toString)
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " %s>" % toString)
    end
  end

  class DBusArgument < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " currentSignature='%s', atEnd=%s>" % [currentSignature, atEnd])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " currentSignature='%s, atEnd=%s'>" % [currentSignature, atEnd])
    end
  end

  class DBusConnection < Qt::Base
    def send(*args)
      method_missing(:send, *args)
    end
  end

  class DBusConnectionInterface < Qt::Base
    def serviceOwner(name)
        return Qt::DBusReply.new(internalConstCall(Qt::DBus::AutoDetect, "GetNameOwner", [Qt::Variant.new(name)]))
    end

    def service_owner(name)
        return serviceOwner(name)
    end

    def registeredServiceNames
      return Qt::DBusReply.new(internalConstCall(Qt::DBus::AutoDetect, "ListNames"))
    end

    def registered_service_names
      return registeredServiceNames
    end

    def isServiceRegistered(serviceName)
        return Qt::DBusReply.new(internalConstCall(Qt::DBus::AutoDetect, "NameHasOwner", [Qt::Variant.new(serviceName)]))
    end

    def is_service_registered(serviceName)
        return isServiceRegistered(serviceName)
    end

    def serviceRegistered?(serviceName)
        return isServiceRegistered(serviceName)
    end

    def service_registered?(serviceName)
        return isServiceRegistered(serviceName)
    end

    def servicePid(serviceName)
        return Qt::DBusReply.new(internalConstCall(Qt::DBus::AutoDetect, "GetConnectionUnixProcessID", [Qt::Variant.new(serviceName)]))
    end

    def service_pid(serviceName)
        return servicePid(serviceName)
    end

    def serviceUid(serviceName)
        return Qt::DBusReply.new(internalConstCall(Qt::DBus::AutoDetect, "GetConnectionUnixUser", [Qt::Variant.new(serviceName)]))
    end

    def service_uid(serviceName)
        return serviceUid(serviceName)
    end

    def startService(name)
        return call("StartServiceByName", Qt::Variant.new(name), Qt::Variant.new(0)).value
    end

    def start_service(name)
        startService(name)
    end
  end

  class DBusError < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class DBusInterface < Qt::Base
    def call(method_name, *args)
      if args.length == 0
        return super(method_name)
      elsif method_name.is_a? Qt::Enum
        opt = args.shift
        qdbusArgs = args.collect {|arg| qVariantFromValue(arg)}
        return super(method_name, opt, *qdbusArgs)
      else
        # If the method is Qt::DBusInterface.call(), create an Array
        # 'dbusArgs' of Qt::Variants from '*args'
        qdbusArgs = args.collect {|arg| qVariantFromValue(arg)}
        return super(method_name, *qdbusArgs)
      end
    end

    def method_missing(id, *args)
      begin
        # First look for a method in the Smoke runtime
        # If not found, then throw an exception and try dbus.
        super(id, *args)
      rescue
        if args.length == 0
          return call(id.to_s).value
        else
          return call(id.to_s, *args).value
        end
      end
    end
  end

  class DBusMessage < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end

    def value
      if type() == Qt::DBusMessage::ReplyMessage
        reply = arguments()
        if reply.length == 0
          return nil
        elsif reply.length == 1
          return reply[0].value
        else
          return reply.collect {|v| v.value}
        end
      else
        return nil
      end
    end

    def <<(a)
      if a.kind_of?(Qt::Variant)
        return super(a)
      else
        return super(qVariantFromValue(a))
      end
    end
  end

  class DBusReply
    def initialize(reply)
      @error = Qt::DBusError.new(reply)

      if @error.valid?
        @data = Qt::Variant.new
        return
      end

      if reply.arguments.length >= 1
        @data = reply.arguments[0]
        return
      end

      # error
      @error = Qt::DBusError.new(  Qt::DBusError::InvalidSignature,
                    "Unexpected reply signature" )
      @data = Qt::Variant.new      # clear it
    end

    def isValid
      return !@error.isValid
    end

    def valid?
      return !@error.isValid
    end

    def value
      return @data.value
    end

    def error
      return @error
    end
  end

  class Dial < Qt::Base
    def range=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class Dialog < Qt::Base
    def exec(*args)
      method_missing(:exec, *args)
    end
  end

  class Dir < Qt::Base
    Time = Qt::Enum.new(1, "QDir::SortFlag")
  end

  class DomAttr < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end
  end

  class DoubleSpinBox < Qt::Base
    def range=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class DoubleValidator < Qt::Base
    def range=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class DomDocumentType < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end

    def type(*args)
      method_missing(:type, *args)
    end
  end

  class DragEnterEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class DragLeaveEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class DropEvent < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Event < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class EventLoop < Qt::Base
    def exec(*args)
      method_missing(:exec, *args)
    end

    def exit(*args)
      method_missing(:exit, *args)
    end
  end

  class File < Qt::Base
    def open(*args)
      method_missing(:open, *args)
    end
  end

  class FileOpenEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class FileIconProvider < Qt::Base
    File = Qt::Enum.new(6, "QFileIconProvider::IconType")

    def type(*args)
      method_missing(:type, *args)
    end
  end

  class FocusEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Font < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " family=%s, pointSize=%d, weight=%d, italic=%s, bold=%s, underline=%s, strikeOut=%s>" %
      [family.inspect, pointSize, weight, italic, bold, underline, strikeOut])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n family=%s,\n pointSize=%d,\n weight=%d,\n italic=%s,\n bold=%s,\n underline=%s,\n strikeOut=%s>" %
      [family.inspect, pointSize, weight, italic, bold, underline, strikeOut])
    end
  end

  class FontDatabase < Qt::Base
    Symbol = Qt::Enum.new(30, "QFontDatabase::WritingSystem")
  end

  class Ftp < Qt::Base
    def abort(*args)
      method_missing(:abort, *args)
    end
  end

  class GLContext < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class GLPixelBuffer < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class GLWidget < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class GenericArgument < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end
  end

  class Gradient < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsEllipseItem < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsItem < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsItemGroup < Qt::Base
    Type = 10

    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsLineItem < Qt::Base
    Type = 6
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsPathItem < Qt::Base
    Type = 2
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsPixmapItem < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsPolygonItem < Qt::Base
    Type = 5
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsProxyWidget < Qt::Base
    Type = 12
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsRectItem < Qt::Base
    Type = 3
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsSceneDragDropEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsSceneMouseEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsSceneContextMenuEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsSceneHoverEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsSceneHelpEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsSceneWheelEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsSimpleTextItem < Qt::Base
    Type = 9
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsSvgItem < Qt::Base
    Type = 13
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsTextItem < Qt::Base
    Type = 8
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class GraphicsWidget < Qt::Base
    Type = 11
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class HelpEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class HideEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class HoverEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Http < Qt::Base
    def abort(*args)
      method_missing(:abort, *args)
    end
  end

  class HttpRequestHeader < Qt::Base
    def method(*args)
      if args.length == 1
        super(*args)
      else
        method_missing(:method, *args)
      end
    end
  end

  class IconDragEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class InputEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class InputMethodEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class IODevice < Qt::Base
    def open(*args)
      method_missing(:open, *args)
    end
  end

  class Image < Qt::Base
    def fromImage(image)
      send("operator=".to_sym, image)
    end

    def format(*args)
      method_missing(:format, *args)
    end

    def load(*args)
      method_missing(:load, *args)
    end
  end

  class ImageIOHandler < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end

    def name(*args)
      method_missing(:name, *args)
    end
  end

  class ImageReader < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class ImageWriter < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class IntValidator < Qt::Base
    def range=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class ItemSelection < Qt::Base
    include Enumerable

    def each
      for i in 0...count
        yield at(i)
      end
      return self
    end

    def select(*args)
      method_missing(:select, *args)
    end

    def split(*args)
      method_missing(:split, *args)
    end
  end

  class ItemSelectionModel < Qt::Base
    def select(*args)
      method_missing(:select, *args)
    end
  end

  class KeyEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class KeySequence < Qt::Base
    def initialize(*args)
      if args.length == 1 && args[0].kind_of?(Qt::Enum) && args[0].type == "Qt::Key"
        return super(args[0].to_i)
      end
      return super(*args)
    end

    def inspect
      str = super
      str.sub(/>$/, " %s>" % toString)
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " %s>" % toString)
    end
  end

  class LCDNumber < Qt::Base
    def display(item)
      method_missing(:display, item)
    end
  end

  class Library < Qt::Base
    def load(*args)
      method_missing(:load, *args)
    end
  end

  class ListWidgetItem < Qt::Base
    def clone(*args)
      Qt::ListWidgetItem.new(self)
    end

    def type(*args)
      method_missing(:type, *args)
    end

    def inspect
      str = super
      str.sub(/>$/, " text='%s'>" % text)
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " text='%s'>" % text)
    end
  end

  class Locale < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end

    def system(*args)
      method_missing(:system, *args)
    end
  end

  class Menu < Qt::Base
    def exec(*args)
      method_missing(:exec, *args)
    end
  end

  class MetaClassInfo < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end
  end

  class MetaEnum < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end

    def keyValues()
      res = []
      for i in 0...keyCount()
        if flag?
          res.push "%s=0x%x" % [key(i), value(i)]
        else
          res.push "%s=%d" % [key(i), value(i)]
        end
      end
      return res
    end

    def inspect
      str = super
      str.sub(/>$/, " scope=%s, name=%s, keyValues=Array (%d element(s))>" % [scope, name, keyValues.length])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " scope=%s, name=%s, keyValues=Array (%d element(s))>" % [scope, name, keyValues.length])
    end
  end

  class MetaMethod < Qt::Base
    # Oops, name clash with the Signal module so hard code
    # this value rather than get it from the Smoke runtime
    Method = Qt::Enum.new(0, "QMetaMethod::MethodType")
    Signal = Qt::Enum.new(1, "QMetaMethod::MethodType")
  end

  class MetaObject < Qt::Base
    def method(*args)
      if args.length == 1 && args[0].kind_of?(Symbol)
        super(*args)
      else
        method_missing(:method, *args)
      end
    end

    # Add three methods, 'propertyNames()', 'slotNames()' and 'signalNames()'
    # from Qt3, as they are very useful when debugging

    def propertyNames(inherits = false)
      res = []
      if inherits
        for p in 0...propertyCount()
          res.push property(p).name
        end
      else
        for p in propertyOffset()...propertyCount()
          res.push property(p).name
        end
      end
      return res
    end

    def slotNames(inherits = false)
      res = []
      if inherits
        for m in 0...methodCount()
          if method(m).methodType == Qt::MetaMethod::Slot
            res.push "%s %s" % [method(m).typeName == "" ? "void" : method(m).typeName,
                      method(m).signature]
          end
        end
      else
        for m in methodOffset()...methodCount()
          if method(m).methodType == Qt::MetaMethod::Slot
            res.push "%s %s" % [method(m).typeName == "" ? "void" : method(m).typeName,
                      method(m).signature]
          end
        end
      end
      return res
    end

    def signalNames(inherits = false)
      res = []
      if inherits
        for m in 0...methodCount()
          if method(m).methodType == Qt::MetaMethod::Signal
            res.push "%s %s" % [method(m).typeName == "" ? "void" : method(m).typeName,
                      method(m).signature]
          end
        end
      else
        for m in methodOffset()...methodCount()
          if method(m).methodType == Qt::MetaMethod::Signal
            res.push "%s %s" % [method(m).typeName == "" ? "void" : method(m).typeName,
                      method(m).signature]
          end
        end
      end
      return res
    end

    def enumerators(inherits = false)
      res = []
      if inherits
        for e in 0...enumeratorCount()
          res.push enumerator(e)
        end
      else
        for e in enumeratorOffset()...enumeratorCount()
          res.push enumerator(e)
        end
      end
      return res
    end

    def inspect
      str = super
      str.sub!(/>$/, "")
      str << " className=%s," % className
      str << " propertyNames=Array (%d element(s))," % propertyNames.length unless propertyNames.length == 0
      str << " signalNames=Array (%d element(s))," % signalNames.length unless signalNames.length == 0
      str << " slotNames=Array (%d element(s))," % slotNames.length unless slotNames.length == 0
      str << " enumerators=Array (%d element(s))," % enumerators.length unless enumerators.length == 0
      str << " superClass=%s," % superClass.inspect unless superClass == nil
      str.chop!
      str << ">"
    end

    def pretty_print(pp)
      str = to_s
      str.sub!(/>$/, "")
      str << "\n className=%s," % className
      str << "\n propertyNames=Array (%d element(s))," % propertyNames.length unless propertyNames.length == 0
      str << "\n signalNames=Array (%d element(s))," % signalNames.length unless signalNames.length == 0
      str << "\n slotNames=Array (%d element(s))," % slotNames.length unless slotNames.length == 0
      str << "\n enumerators=Array (%d element(s))," % enumerators.length unless enumerators.length == 0
      str << "\n superClass=%s," % superClass.inspect unless superClass == nil
      str << "\n methodCount=%d," % methodCount
      str << "\n methodOffset=%d," % methodOffset
      str << "\n propertyCount=%d," % propertyCount
      str << "\n propertyOffset=%d," % propertyOffset
      str << "\n enumeratorCount=%d," % enumeratorCount
      str << "\n enumeratorOffset=%d," % enumeratorOffset
      str.chop!
      str << ">"
      pp.text str
    end
  end

  class MetaProperty < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end

    def type(*args)
      method_missing(:type, *args)
    end
  end

  class MetaType < Qt::Base
    Float = Qt::Enum.new(135, "QMetaType::Type")

    def load(*args)
      method_missing(:load, *args)
    end

    def type(*args)
      method_missing(:type, *args)
    end
  end

  class MouseEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class MoveEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Movie < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class NetworkProxy < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Object < Qt::Base
  end

  class PageSetupDialog < Qt::Base
    def exec(*args)
      method_missing(:exec, *args)
    end
  end

  class PaintEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Picture < Qt::Base
    def load(*args)
      method_missing(:load, *args)
    end
  end

  class PictureIO < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class Pixmap < Qt::Base
    def load(*args)
      method_missing(:load, *args)
    end
  end

  class PluginLoader < Qt::Base
    def load(*args)
      method_missing(:load, *args)
    end
  end

  class Point < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " x=%d, y=%d>" % [self.x, self.y])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n x=%d,\n y=%d>" % [self.x, self.y])
    end
  end

  class PointF < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " x=%f, y=%f>" % [self.x, self.y])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n x=%f,\n y=%f>" % [self.x, self.y])
    end
  end

  class Polygon < Qt::Base
    include Enumerable

    def each
      for i in 0...count
        yield point(i)
      end
      return self
    end
  end

  class PolygonF < Qt::Base
    include Enumerable

    def each
      for i in 0...count
        yield point(i)
      end
      return self
    end
  end

  class PrintDialog < Qt::Base
    def exec(*args)
      method_missing(:exec, *args)
    end
  end

  class Process < Qt::Base
    StandardError = Qt::Enum.new(1, "QProcess::ProcessChannel")
  end

  class ProgressBar < Qt::Base
    def range=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class ProgressDialog < Qt::Base
    def range=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class Printer < Qt::Base
    def abort(*args)
      method_missing(:abort, *args)
    end
  end

  class PushButton < Qt::Base
    def setShortcut(arg)
      if arg.kind_of?(String)
        return super(Qt::KeySequence.new(arg))
      else
        return super(arg)
      end
    end

    def shortcut=(arg)
      setShortcut(arg)
    end
  end

  class Line < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " x1=%d, y1=%d, x2=%d, y2=%d>" % [x1, y1, x2, y2])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n x1=%d,\n y1=%d,\n x2=%d,\n y2=%d>" % [x1, y1, x2, y2])
    end
  end

  class LineF < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " x1=%f, y1=%f, x2=%f, y2=%f>" % [x1, y1, x2, y2])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n x1=%f,\n y1=%f,\n x2=%f,\n y2=%f>" % [x1, y1, x2, y2])
    end
  end

  class MetaType < Qt::Base
    def self.type(*args)
      method_missing(:type, *args)
    end
  end

  class ModelIndex < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " valid?=%s, row=%s, column=%s>" % [valid?, row, column])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n valid?=%s,\n row=%s,\n column=%s>" % [valid?, row, column])
    end
  end

  class RadioButton < Qt::Base
    def setShortcut(arg)
      if arg.kind_of?(String)
        return super(Qt::KeySequence.new(arg))
      else
        return super(arg)
      end
    end

    def shortcut=(arg)
      setShortcut(arg)
    end
  end

  class Rect < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " x=%d, y=%d, width=%d, height=%d>" % [self.x, self.y, width, height])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n x=%d,\n y=%d,\n width=%d,\n height=%d>" % [self.x, self.y, width, height])
    end
  end

  class RectF < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " x=%f, y=%f, width=%f, height=%f>" % [self.x, self.y, width, height])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n x=%f,\n y=%f,\n width=%f,\n height=%f>" % [self.x, self.y, width, height])
    end
  end

  class ResizeEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class ScrollBar < Qt::Base
    def range=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class Shortcut < Qt::Base
    def id(*args)
      method_missing(:id, *args)
    end
  end

  class ShortcutEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class ShowEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Size < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " width=%d, height=%d>" % [width, height])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n width=%d,\n height=%d>" % [width, height])
    end
  end

  class SizeF < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " width=%f, height=%f>" % [width, height])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n width=%f,\n height=%f>" % [width, height])
    end
  end

  class SizePolicy < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " horizontalPolicy=%d, verticalPolicy=%d>" % [horizontalPolicy, verticalPolicy])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n horizontalPolicy=%d,\n verticalPolicy=%d>" % [horizontalPolicy, verticalPolicy])
    end
  end

  class Slider < Qt::Base
    def range=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class SocketNotifier < Qt::Base
    Exception = Qt::Enum.new(2, "QSocketNotifier::Type")

    def type(*args)
      method_missing(:type, *args)
    end
  end

  class SpinBox < Qt::Base
    def range=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class SqlDatabase < Qt::Base
    def exec(*args)
      method_missing(:exec, *args)
    end

    def open(*args)
      method_missing(:open, *args)
    end
  end

  class SqlError < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class SqlField < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end

    def type(*args)
      method_missing(:type, *args)
    end
  end

  class SqlIndex < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end
  end

  class SqlQuery < Qt::Base
    def exec(*args)
      method_missing(:exec, *args)
    end
  end

  class SqlResult < Qt::Base
    def exec(*args)
      method_missing(:exec, *args)
    end
  end

  class SqlTableModel < Qt::Base
    def select(*k)
      method_missing(:select, *k)
    end
  end

  class StandardItem < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " text='%s'>" % [text])
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, "\n text='%s'>" % [text])
    end

    def type(*args)
      method_missing(:type, *args)
    end

    def clone
      Qt::StandardItem.new(self)
    end
  end

  class StandardItemModel < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class StatusTipEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class StyleHintReturn < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class StyleOption < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class SyntaxHighlighter < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class TableWidgetItem < Qt::Base
    def clone(*args)
      Qt::TableWidgetItem.new(self)
    end

    def type(*args)
      method_missing(:type, *args)
    end

    def inspect
      str = super
      str.sub(/>$/, " text='%s'>" % text)
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " text='%s'>" % text)
    end
  end

  class TemporaryFile < Qt::Base
    def open(*args)
      method_missing(:open, *args)
    end
  end

  class TextCursor < Qt::Base
    def select(*k)
      method_missing(:select, *k)
    end
  end

  class TextDocument < Qt::Base
    def clone(*args)
      method_missing(:clone, *args)
    end

    def print(*args)
      method_missing(:print, *args)
    end
  end

  class TextFormat < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class TextImageFormat < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end
  end

  class TextInlineObject < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class TextLength < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class TextList < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class TextObject < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class TextTable < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class TextTableCell < Qt::Base
    def format(*args)
      method_missing(:format, *args)
    end
  end

  class Time < Qt::Base
    def initialize(*args)
      if args.size == 1 && args[0].class.name == "Time"
        return super(args[0].hour, args[0].min, args[0].sec)
      else
        return super(*args)
      end
    end

    def inspect
      str = super
      str.sub(/>$/, " %s>" % toString)
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " %s>" % toString)
    end
  end

  class Timer < Qt::Base
    def start(*args)
      method_missing(:start, *args)
    end
  end

  class TimerEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class TimeLine < Qt::Base
    def frameRange=(arg)
      if arg.kind_of? Range
        return super(arg.begin, arg.exclude_end?  ? arg.end - 1 : arg.end)
      else
        return super(arg)
      end
    end
  end

  class ToolButton < Qt::Base
    def setShortcut(arg)
      if arg.kind_of?(String)
        return super(Qt::KeySequence.new(arg))
      else
        return super(arg)
      end
    end

    def shortcut=(arg)
      setShortcut(arg)
    end
  end

  class Translator < Qt::Base
    def load(*args)
      method_missing(:load, *args)
    end
  end

  class TreeWidget < Qt::Base
    include Enumerable

    def each
      it = Qt::TreeWidgetItemIterator.new(self)
      while it.current
        yield it.current
        it += 1
      end
    end
  end

  class TreeWidgetItem < Qt::Base
    include Enumerable

    def initialize(*args)
      # There is not way to distinguish between the copy constructor
      # QTreeWidgetItem (const QTreeWidgetItem & other)
      # and
      # QTreeWidgetItem (QTreeWidgetItem * parent, const QStringList & strings, int type = Type)
      # when the latter has a single argument. So force the second variant to be called
      if args.length == 1 && args[0].kind_of?(Qt::TreeWidgetItem)
        super(args[0], Qt::TreeWidgetItem::Type)
      else
        super(*args)
      end
    end

    def inspect
      str = super
      str.sub!(/>$/, "")
      str << " parent=%s," % parent unless parent.nil?
      for i in 0..(columnCount - 1)
        str << " text%d='%s'," % [i, self.text(i)]
      end
      str.sub!(/,?$/, ">")
    end

    def pretty_print(pp)
      str = to_s
      str.sub!(/>$/, "")
      str << " parent=%s," % parent unless parent.nil?
      for i in 0..(columnCount - 1)
        str << " text%d='%s'," % [i, self.text(i)]
      end
      str.sub!(/,?$/, ">")
      pp.text str
    end

    def clone(*args)
      Qt::TreeWidgetItem.new(self)
    end

    def type(*args)
      method_missing(:type, *args)
    end

    def each
      it = Qt::TreeWidgetItemIterator.new(self)
      while it.current
        yield it.current
        it += 1
      end
    end
  end

  class TreeWidgetItemIterator < Qt::Base
    def current
      return send("operator*".to_sym)
    end
  end

  class Url < Qt::Base
    def inspect
      str = super
      str.sub(/>$/, " url=%s>" % toString)
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " url=%s>" % toString)
    end
  end

  class UrlInfo < Qt::Base
    def name(*args)
      method_missing(:name, *args)
    end
  end

  class Uuid < Qt::Base
    Time = Qt::Enum.new(1, "QUuid::Version")
  end

  class Variant < Qt::Base
    String = Qt::Enum.new(10, "QVariant::Type")
    Date = Qt::Enum.new(14, "QVariant::Type")
    Time = Qt::Enum.new(15, "QVariant::Type")
    DateTime = Qt::Enum.new(16, "QVariant::Type")

    def initialize(*args)
      if args.size == 1 && args[0].nil?
        return super()
      elsif args.size == 1 && args[0].class.name == "Date"
        return super(Qt::Date.new(args[0]))
      elsif args.size == 1 && args[0].class.name == "DateTime"
        return super(Qt::DateTime.new(  Qt::Date.new(args[0].year, args[0].month, args[0].day),
                        Qt::Time.new(args[0].hour, args[0].min, args[0].sec) ) )
      elsif args.size == 1 && args[0].class.name == "Time"
        return super(Qt::Time.new(args[0]))
      elsif args.size == 1 && args[0].class.name == "BigDecimal"
        return super(args[0].to_f) # we have to make do with a float
      else
        return super(*args)
      end
    end

    def to_a
      return toStringList()
    end

    def to_f
      return toDouble()
    end

    def to_i
      return toInt()
    end

    def to_int
      return toInt()
    end

    def value
      case type()
      when Qt::Variant::Invalid
        return nil
      when Qt::Variant::Bitmap
      when Qt::Variant::Bool
        return toBool
      when Qt::Variant::Brush
        return qVariantValue(Qt::Brush, self)
      when Qt::Variant::ByteArray
        return toByteArray
      when Qt::Variant::Char
        return qVariantValue(Qt::Char, self)
      when Qt::Variant::Color
        return qVariantValue(Qt::Color, self)
      when Qt::Variant::Cursor
        return qVariantValue(Qt::Cursor, self)
      when Qt::Variant::Date
        return toDate
      when Qt::Variant::DateTime
        return toDateTime
      when Qt::Variant::Double
        return toDouble
      when Qt::Variant::Font
        return qVariantValue(Qt::Font, self)
      when Qt::Variant::Icon
        return qVariantValue(Qt::Icon, self)
      when Qt::Variant::Image
        return qVariantValue(Qt::Image, self)
      when Qt::Variant::Int
        return toInt
      when Qt::Variant::KeySequence
        return qVariantValue(Qt::KeySequence, self)
      when Qt::Variant::Line
        return toLine
      when Qt::Variant::LineF
        return toLineF
      when Qt::Variant::List
        return toList
      when Qt::Variant::Locale
        return qVariantValue(Qt::Locale, self)
      when Qt::Variant::LongLong
        return toLongLong
      when Qt::Variant::Map
        return toMap
      when Qt::Variant::Palette
        return qVariantValue(Qt::Palette, self)
      when Qt::Variant::Pen
        return qVariantValue(Qt::Pen, self)
      when Qt::Variant::Pixmap
        return qVariantValue(Qt::Pixmap, self)
      when Qt::Variant::Point
        return toPoint
      when Qt::Variant::PointF
        return toPointF
      when Qt::Variant::Polygon
        return qVariantValue(Qt::Polygon, self)
      when Qt::Variant::Rect
        return toRect
      when Qt::Variant::RectF
        return toRectF
      when Qt::Variant::RegExp
        return toRegExp
      when Qt::Variant::Region
        return qVariantValue(Qt::Region, self)
      when Qt::Variant::Size
        return toSize
      when Qt::Variant::SizeF
        return toSizeF
      when Qt::Variant::SizePolicy
        return toSizePolicy
      when Qt::Variant::String
        return toString
      when Qt::Variant::StringList
        return toStringList
      when Qt::Variant::TextFormat
        return qVariantValue(Qt::TextFormat, self)
      when Qt::Variant::TextLength
        return qVariantValue(Qt::TextLength, self)
      when Qt::Variant::Time
        return toTime
      when Qt::Variant::UInt
        return toUInt
      when Qt::Variant::ULongLong
        return toULongLong
      when Qt::Variant::Url
        return toUrl
      end

      return qVariantValue(nil, self)
    end

    def inspect
      str = super
      str.sub(/>$/, " typeName=%s>" % typeName)
    end

    def pretty_print(pp)
      str = to_s
      pp.text str.sub(/>$/, " typeName=%s>" % typeName)
    end

    def load(*args)
      method_missing(:load, *args)
    end

    def type(*args)
      method_missing(:type, *args)
    end
  end

  class DBusVariant < Variant
    def initialize(value)
      if value.kind_of? Qt::Variant
        super(value)
      else
        super(Qt::Variant.new(value))
      end
    end

    def setVariant(variant)
    end

    def variant=(variant)
      setVariant(variant)
    end

    def variant()
      return self
    end
  end

  class WhatsThisClickedEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class Widget < Qt::Base
    def raise(*args)
      method_missing(:raise, *args)
    end
  end

  class WindowStateChangeEvent < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class XmlAttributes < Qt::Base
    def type(*args)
      method_missing(:type, *args)
    end
  end

  class SignalBlockInvocation < Qt::Object
    def initialize(parent, block, signature)
      super(parent)
      if metaObject.indexOfSlot(signature) == -1
        self.class.slots signature
      end
      @block = block
    end

    def invoke(*args)
      @block.call(*args)
    end
  end

  class BlockInvocation < Qt::Object
    def initialize(target, block, signature)
      super(target)
      if metaObject.indexOfSlot(signature) == -1
        self.class.slots signature
      end
      @block = block
    end

    def invoke(*args)
      @block.call(*args)
    end
  end

  class MethodInvocation < Qt::Object
    def initialize(target, method, signature)
      super(target)
      if metaObject.indexOfSlot(signature) == -1
        self.class.slots signature
      end
      @target = target
      method = method.intern unless method.is_a?Symbol
      @method = method
    end

    def invoke(*args)
      @target.send @method, *args
    end
  end

  module Internal
    @@classes   = {}
    @@cpp_names = {}
    @@idclass   = []

    @@normalize_procs = []

    class ModuleIndex
      attr_accessor :index

      def smoke
        if ! @smoke
            return 0
        end
        return @smoke
      end

      def initialize(smoke, index)
        @smoke = smoke
        @index = index
      end
    end

    def self.classes
      return @@classes
    end

    def self.cpp_names
      return @@cpp_names
    end

    def self.idclass
      return @@idclass
    end

    def self.add_normalize_proc(func)
      @@normalize_procs << func
    end

    def Internal.normalize_classname(classname)
      @@normalize_procs.each do |func|
        ret = func.call(classname)
        if !ret.nil?
          return ret
        end
      end
      if classname =~ /^Q3/
        ruby_classname = classname.sub(/^Q3(?=[A-Z])/,'Qt3::')
      elsif classname =~ /^Q/
        ruby_classname = classname.sub(/^Q(?=[A-Z])/,'Qt::')
      else
        ruby_classname = classname
      end
      ruby_classname
    end

    def Internal.init_class(c)
      if c == "WebCore" || c == "std" || c == "QGlobalSpace"
        return
      end
      classname = Qt::Internal::normalize_classname(c)
      classId = Qt::Internal.findClass(c)
      insert_pclassid(classname, classId)
      @@idclass[classId.index] = classname
      @@cpp_names[classname] = c
      klass = isQObject(c) ? create_qobject_class(classname, Qt) \
                                                   : create_qt_class(classname, Qt)
      @@classes[classname] = klass unless klass.nil?
    end

    def Internal.debug_level
      Qt.debug_level
    end

    def Internal.checkarg(argtype, typename)
      const_point = typename =~ /^const\s+/ ? -1 : 0
      if argtype == 'i'
        if typename =~ /^int&?$|^signed int&?$|^signed$|^qint32&?$/
          return 6 + const_point
        elsif typename =~ /^quint32&?$/
          return 4 + const_point
        elsif typename =~ /^(?:short|ushort|unsigned short int|unsigned short|uchar|char|unsigned char|uint|long|ulong|unsigned long int|unsigned|float|double|WId|HBITMAP__\*|HDC__\*|HFONT__\*|HICON__\*|HINSTANCE__\*|HPALETTE__\*|HRGN__\*|HWND__\*|Q_PID|^quint16&?$|^qint16&?$)$/
          return 4 + const_point
        elsif typename =~ /^(quint|qint|qulong|qlong|qreal)/
          return 4 + const_point
        else
          t = typename.sub(/^const\s+/, '')
          t.sub!(/[&*]$/, '')
          if isEnum(t)
            return 2
          end
        end
      elsif argtype == 'n'
        if typename =~ /^double$|^qreal$/
          return 6 + const_point
        elsif typename =~ /^float$/
          return 4 + const_point
        elsif typename =~ /^int&?$/
          return 2 + const_point
        elsif typename =~ /^(?:short|ushort|uint|long|ulong|signed|unsigned|float|double)$/
          return 2 + const_point
        else
          t = typename.sub(/^const\s+/, '')
          t.sub!(/[&*]$/, '')
          if isEnum(t)
            return 2 + const_point
          end
        end
      elsif argtype == 'B'
        if typename =~ /^(?:bool)[*&]?$/
          return 2 + const_point
        end
      elsif argtype == 's'
        if typename =~ /^(const )?((QChar)[*&]?)$/
          return 6 + const_point
        elsif typename =~ /^(?:(u(nsigned )?)?char\*)$/
          return 4 + const_point
        elsif typename =~ /^(?:const (u(nsigned )?)?char\*)$/
          return 2 + const_point
        elsif typename =~ /^(?:(?:const )?(QString)[*&]?)$/
          return 8 + const_point
        end
      elsif argtype == 'a'
        # FIXME: shouldn't be hardcoded. Installed handlers should tell what ruby type they expect.
        if typename =~ /^(?:
            const\ QCOORD\*|
            (?:const\ )?
            (?:
                QStringList[\*&]?|
                QValueList<int>[\*&]?|
                QRgb\*|
                char\*\*
            )
                  )$/x
          return 2 + const_point
        end
      elsif argtype == 'u'
        # Give nil matched against string types a higher score than anything else
        if typename =~ /^(?:u?char\*|const u?char\*|(?:const )?((Q(C?)String))[*&]?)$/
          return 4 + const_point
        # Numerics will give a runtime conversion error, so they fail the match
        elsif typename =~ /^(?:short|ushort|uint|long|ulong|signed|unsigned|int)$/
          return -99
        else
          return 2 + const_point
        end
      elsif argtype == 'U'
        if typename =~ /QStringList/
          return 4 + const_point
        else
          return 2 + const_point
        end
      else
        t = typename.sub(/^const\s+/, '')
        t.sub!(/(::)?Ptr$/, '')
        t.sub!(/[&*]$/, '')
        if argtype == t
          return 4 + const_point
        elsif classIsa(argtype, t)
          return 2 + const_point
        elsif isEnum(argtype) and
            (t =~ /int|qint32|uint|quint32|long|ulong/ or isEnum(t))
          return 2 + const_point
        end
      end
      return -99
    end

    def Internal.find_class(classname)
      @@classes[classname]
    end

    # Runs the initializer as far as allocating the Qt C++ instance.
    # Then use a throw to jump back to here with the C++ instance
    # wrapped in a new ruby variable of type T_DATA
    def Internal.try_initialize(instance, *args)
      initializer = instance.method(:initialize)
      catch :newqt do
        initializer.call(*args)
      end
    end

    # If a block was passed to the constructor, then
    # run that now. Either run the context of the new instance
    # if no args were passed to the block. Or otherwise,
    # run the block in the context of the arg.
    def Internal.run_initializer_block(instance, block)
      if block.arity == -1 || block.arity == 0
        instance.instance_eval(&block)
      elsif block.arity == 1
        block.call(instance)
      else
        raise ArgumentError, "Wrong number of arguments to block(#{block.arity} for 1)"
      end
    end

    # Looks up and executes a Qt method
    #
    # package - Always the string 'Qt'
    # method  - Methodname as a string
    # klass   - Ruby class object
    # this    - instance of class
    # args    - arguments to method call
    #
    def Internal.do_method_missing(package, method, klass, this, *args)
      # Determine class name
      if klass.class == Module
        # If a module use the module's name - typically Qt
        classname = klass.name
      else
        # Lookup Qt class name from Ruby class name
        classname = @@cpp_names[klass.name]
        if classname.nil?
          # Make sure we haven't backed all the way up to Object
          if klass != Object and klass != Qt
            # Don't recognize this class so try the superclass
            return do_method_missing(package, method, klass.superclass, this, *args)
          else
            # Give up if we back all the way up to Object
            return nil
          end
        end
      end

      # Modify constructor method name from new to the name of the Qt class
      # and remove any namespacing
      if method == "new"
        method = classname.dup
        method.gsub!(/^.*::/,"")
      end

      # If the method contains no letters it must be an operator, append "operator" to the
      # method name
      method = "operator" + method.sub("@","") if method !~ /[a-zA-Z]+/

      # Change foobar= to setFoobar()
      method = 'set' + method[0,1].upcase + method[1,method.length].sub("=", "") if method =~ /.*[^-+%\/|=]=$/ && method != 'operator='

      # Build list of munged method names which is the methodname followed
      # by symbols that indicate the basic type of the method's arguments
      #
      # Plain scalar = $
      # Object = #
      # Non-scalar (reference to array or hash, undef) = ?
      #
      methods = []
      methods << method.dup
      args.each do |arg|
        if arg.nil?
          # For each nil arg encountered, triple the number of munged method
          # templates, in order to cover all possible types that can match nil
          temp = []
          methods.collect! do |meth|
            temp << meth + '?'
            temp << meth + '#'
            meth << '$'
          end
          methods.concat(temp)
        elsif isObject(arg)
          methods.collect! { |meth| meth << '#' }
        elsif arg.kind_of? Array or arg.kind_of? Hash
          methods.collect! { |meth| meth << '?' }
        else
          methods.collect! { |meth| meth << '$' }
        end
      end

      # Create list of methodIds that match classname and munged method name
      methodIds = []
      methods.collect { |meth| methodIds.concat( findMethod(classname, meth) ) }

      # If we didn't find any methods and the method name contains an underscore
      # then convert to camelcase and try again
      if method =~ /._./ && methodIds.length == 0
        # If the method name contains underscores, convert to camel case
        # form and try again
        method.gsub!(/(.)_(.)/) {$1 + $2.upcase}
        return do_method_missing(package, method, klass, this, *args)
      end

      # Debugging output for method lookup
      if debug_level >= DebugLevel::High
        puts "Searching for #{classname}##{method}"
        puts "Munged method names:"
        methods.each {|meth| puts "        #{meth}"}
        puts "candidate list:"
        prototypes = dumpCandidates(methodIds).split("\n")
        line_len = (prototypes.collect { |p| p.length }).max
        prototypes.zip(methodIds) {
          |prototype,id| puts "#{prototype.ljust line_len}  (smoke: #{id.smoke} index: #{id.index})"
        }
      end

      # Find the best match
      chosen = nil
      if methodIds.length > 0
        best_match = -1
        methodIds.each do
          |id|
          puts "matching => smoke: #{id.smoke} index: #{id.index}" if debug_level >= DebugLevel::High
          current_match = (isConstMethod(id) ? 1 : 0)
          (0...args.length).each do
            |i|
            typename = get_arg_type_name(id, i)
            argtype = get_value_type(args[i])
            score = checkarg(argtype, typename)
            current_match += score
            puts "        #{typename} (#{argtype}) score: #{score}" if debug_level >= DebugLevel::High
          end

          # Note that if current_match > best_match, then chosen must be nil
          if current_match > best_match
            best_match = current_match
            chosen = id
          # Ties are bad - but it is better to chose something than to fail
          elsif current_match == best_match && id.smoke == chosen.smoke
            puts " ****** warning: multiple methods with the same score of #{current_match}: #{chosen.index} and #{id.index}" if debug_level >= DebugLevel::Minimal
            chosen = id
          end
          puts "        match => smoke: #{id.smoke} index: #{id.index} score: #{current_match} chosen: #{chosen ? chosen.index : nil}" if debug_level >= DebugLevel::High
        end
      end

      # Additional debugging output
      if debug_level >= DebugLevel::Minimal && chosen.nil? && method !~ /^operator/
        id = find_pclassid(normalize_classname(klass.name))
        hash = findAllMethods(id)
        constructor_names = nil
        if method == classname
          puts "No matching constructor found, possibles:\n"
          constructor_names = hash.keys.grep(/^#{classname}/)
        else
          puts "Possible prototypes:"
          constructor_names = hash.keys
        end
        method_ids = hash.values_at(*constructor_names).flatten
        puts dumpCandidates(method_ids)
      else
        puts "setCurrentMethod(smokeList index: #{chosen.smoke}, meth index: #{chosen.index})" if debug_level >= DebugLevel::High && chosen
      end

      # Select the chosen method
      setCurrentMethod(chosen) if chosen
      return nil
    end

    def Internal.init_all_classes()
      Qt::Internal::getClassList().each do |c|
        if c == "Qt"
          # Don't change Qt to Qt::t, just leave as is
          @@cpp_names["Qt"] = c
        elsif c != "QInternal" && !c.empty?
          Qt::Internal::init_class(c)
        end
      end

      @@classes['Qt::Integer'] = Qt::Integer
      @@classes['Qt::Boolean'] = Qt::Boolean
      @@classes['Qt::Enum'] = Qt::Enum
    end

    def Internal.get_qinteger(num)
      return num.value
    end

    def Internal.set_qinteger(num, val)
      return num.value = val
    end

    def Internal.create_qenum(num, enum_type)
      return Qt::Enum.new(num, enum_type)
    end

    def Internal.get_qenum_type(e)
      return e.type
    end

    def Internal.get_qboolean(b)
      return b.value
    end

    def Internal.set_qboolean(b, val)
      return b.value = val
    end

    def Internal.getAllParents(class_id, res)
      getIsa(class_id).each do |s|
        c = findClass(s)
        res << c
        getAllParents(c, res)
      end
    end

    # Keeps a hash of strings against their corresponding offsets
    # within the qt_meta_stringdata sequence of null terminated
    # strings. Returns a proc to get an offset given a string.
    # That proc also adds new strings to the 'data' array, and updates
    # the corresponding 'pack_str' Array#pack template.
    def Internal.string_table_handler(data, pack_str)
      hsh = {}
      offset = 0
      return lambda do |str|
        if !hsh.has_key? str
          hsh[str] = offset
          data << str
          pack_str << "a*x"
          offset += str.length + 1
        end

        return hsh[str]
      end
    end

    def Internal.makeMetaData(classname, classinfos, dbus, signals, slots)
      # Each entry in 'stringdata' corresponds to a string in the
      # qt_meta_stringdata_<classname> structure.
      # 'pack_string' is used to convert 'stringdata' into the
      # binary sequence of null terminated strings for the metaObject
      stringdata = []
      pack_string = ""
      string_table = string_table_handler(stringdata, pack_string)

      # This is used to create the array of uints that make up the
      # qt_meta_data_<classname> structure in the metaObject
      data = [1,                 # revision
          string_table.call(classname),   # classname
          classinfos.length, classinfos.length > 0 ? 10 : 0,   # classinfo
          signals.length + slots.length,
          10 + (2*classinfos.length),   # methods
          0, 0,               # properties
          0, 0]              # enums/sets

      classinfos.each do |entry|
        data.push string_table.call(entry[0])    # key
        data.push string_table.call(entry[1])    # value
      end

      signals.each do |entry|
        data.push string_table.call(entry.full_name)        # signature
        data.push string_table.call(entry.full_name.delete("^,"))  # parameters
        data.push string_table.call(entry.reply_type)        # type, "" means void
        data.push string_table.call("")        # tag
        if dbus
          data.push MethodScriptable | MethodSignal | AccessPublic
        else
          data.push entry.access  # flags, always protected for now
        end
      end

      slots.each do |entry|
        data.push string_table.call(entry.full_name)        # signature
        data.push string_table.call(entry.full_name.delete("^,"))  # parameters
        data.push string_table.call(entry.reply_type)        # type, "" means void
        data.push string_table.call("")        # tag
        if dbus
          data.push MethodScriptable | MethodSlot | AccessPublic  # flags, always public for now
        else
          data.push entry.access    # flags, always public for now
        end
      end

      data.push 0    # eod

      return [stringdata.pack(pack_string), data]
    end

    def Internal.getMetaObject(klass, qobject)
      if klass.nil?
        klass = qobject.class
      end

      parentMeta = nil
      if @@cpp_names[klass.superclass.name].nil?
        parentMeta = getMetaObject(klass.superclass, qobject)
      end

      meta = Meta[klass.name]
      if meta.nil?
        meta = Qt::MetaInfo.new(klass)
      end

      if meta.metaobject.nil? or meta.changed
        stringdata, data = makeMetaData(  qobject.class.name,
                          meta.classinfos,
                          meta.dbus,
                          meta.signals,
                          meta.slots )
        meta.metaobject = make_metaObject(qobject, parentMeta, stringdata, data)
        meta.changed = false
      end

      meta.metaobject
    end

    # Handles calls of the form:
    #  connect(myobj, SIGNAL('mysig(int)'), mytarget) {|arg(s)| ...}
    #  connect(myobj, SIGNAL('mysig(int)')) {|arg(s)| ...}
    #  connect(myobj, SIGNAL(:mysig), mytarget) { ...}
    #  connect(myobj, SIGNAL(:mysig)) { ...}
    def Internal.connect(src, signal, target, block)
      args = (signal =~ /\((.*)\)/) ? $1 : ""
      signature = Qt::MetaObject.normalizedSignature("invoke(%s)" % args).to_s
      return Qt::Object.connect(  src,
                    signal,
                    Qt::BlockInvocation.new(target, block.to_proc, signature),
                    SLOT(signature) )
    end

    # Handles calls of the form:
    #  connect(SIGNAL(:mysig)) { ...}
    #  connect(SIGNAL('mysig(int)')) {|arg(s)| ...}
    def Internal.signal_connect(src, signal, block)
      args = (signal =~ /\((.*)\)/) ? $1 : ""
      signature = Qt::MetaObject.normalizedSignature("invoke(%s)" % args).to_s
      return Qt::Object.connect(  src,
                    signal,
                    Qt::SignalBlockInvocation.new(src, block.to_proc, signature),
                    SLOT(signature) )
    end

    # Handles calls of the form:
    #  connect(:mysig, mytarget, :mymethod))
    #  connect(SIGNAL('mysignal(int)'), mytarget, :mymethod))
    def Internal.method_connect(src, signal, target, method)
      signal = SIGNAL(signal) if signal.is_a?Symbol
      args = (signal =~ /\((.*)\)/) ? $1 : ""
      signature = Qt::MetaObject.normalizedSignature("invoke(%s)" % args).to_s
      return Qt::Object.connect(  src,
                    signal,
                    Qt::MethodInvocation.new(target, method, signature),
                    SLOT(signature) )
    end

    # Handles calls of the form:
    #  Qt::Timer.singleShot(500, myobj) { ...}
    def Internal.single_shot_timer_connect(interval, target, block)
      return Qt::Timer.singleShot(  interval,
                      Qt::BlockInvocation.new(target, block, "invoke()"),
                      SLOT("invoke()") )
    end
  end # Qt::Internal

  Meta = {}

  # An entry for each signal or slot
  # Example
  #  int foobar(QString,bool)
  #  :name is 'foobar'
  #  :full_name is 'foobar(QString,bool)'
  #  :arg_types is 'QString,bool'
  #  :reply_type is 'int'
  QObjectMember = Struct.new :name, :full_name, :arg_types, :reply_type, :access

  class MetaInfo
    attr_accessor :classinfos, :dbus, :signals, :slots, :metaobject, :mocargs, :changed

    def initialize(klass)
      Meta[klass.name] = self
      @klass = klass
      @metaobject = nil
      @signals = []
      @slots = []
      @classinfos = []
      @dbus = false
      @changed = false
      Internal.addMetaObjectMethods(klass)
    end

    def add_signals(signal_list, access)
      signal_names = []
      signal_list.each do |signal|
        if signal.kind_of? Symbol
          signal = signal.to_s + "()"
        end
        signal = Qt::MetaObject.normalizedSignature(signal).to_s
        if signal =~ /^(([\w,<>:]*)\s+)?([^\s]*)\((.*)\)/
          @signals.push QObjectMember.new(  $3,
                                              $3 + "(" + $4 + ")",
                                              $4,
                                              ($2 == 'void' || $2.nil?) ? "" : $2,
                                              access )
          signal_names << $3
        else
          qWarning( "#{@klass.name}: Invalid signal format: '#{signal}'" )
        end
      end
      Internal.addSignalMethods(@klass, signal_names)
    end

    # Return a list of signals, including inherited ones
    def get_signals
      all_signals = []
      current = @klass
      while current != Qt::Base
        meta = Meta[current.name]
        if !meta.nil?
          all_signals.concat meta.signals
        end
        current = current.superclass
      end
      return all_signals
    end

    def add_slots(slot_list, access)
      slot_list.each do |slot|
        if slot.kind_of? Symbol
          slot = slot.to_s + "()"
        end
        slot = Qt::MetaObject.normalizedSignature(slot).to_s
        if slot =~ /^(([\w,<>:]*)\s+)?([^\s]*)\((.*)\)/
          @slots.push QObjectMember.new(  $3,
                                          $3 + "(" + $4 + ")",
                                          $4,
                                          ($2 == 'void' || $2.nil?) ? "" : $2,
                                          access )
        else
          qWarning( "#{@klass.name}: Invalid slot format: '#{slot}'" )
        end
      end
    end

    def add_classinfo(key, value)
      @classinfos.push [key, value]
      if key == 'D-Bus Interface'
        @dbus = true
      end
    end
  end # Qt::MetaInfo

  # These values are from the enum WindowType in qnamespace.h.
  # Some of the names such as 'Qt::Dialog', clash with QtRuby
  # class names. So add some constants here to use instead,
  # renamed with an ending of 'Type'.
  WidgetType = 0x00000000
  WindowType = 0x00000001
  DialogType = 0x00000002 | WindowType
  SheetType = 0x00000004 | WindowType
  DrawerType = 0x00000006 | WindowType
  PopupType = 0x00000008 | WindowType
  ToolType = 0x0000000a | WindowType
  ToolTipType = 0x0000000c | WindowType
  SplashScreenType = 0x0000000e | WindowType
  DesktopType = 0x00000010 | WindowType
  SubWindowType =  0x00000012

end # Qt

class Object
  def SIGNAL(signal)
    if signal.kind_of? Symbol
      return "2" + signal.to_s + "()"
    else
      return "2" + signal
    end
  end

  def SLOT(slot)
    if slot.kind_of? Symbol
      return "1" + slot.to_s + "()"
    else
      return "1" + slot
    end
  end

  def emit(signal)
    return signal
  end

  def QT_TR_NOOP(x) x end
  def QT_TRANSLATE_NOOP(scope, x) x end

  # See the discussion here: http://eigenclass.org/hiki.rb?instance_exec
  # about implementations of the ruby 1.9 method instance_exec(). This
  # version is the one from Rails. It isn't thread safe, but that doesn't
  # matter for the intended use in invoking blocks as Qt slots.
  def instance_exec(*arguments, &block)
    block.bind(self)[*arguments]
  end unless defined? instance_exec
end

class Proc
  # Part of the Rails Object#instance_exec implementation
  def bind(object)
    block, time = self, Time.now
    (class << object; self end).class_eval do
      method_name = "__bind_#{time.to_i}_#{time.usec}"
      define_method(method_name, &block)
      method = instance_method(method_name)
      remove_method(method_name)
      method
    end.bind(object)
  end
end

class Module
  alias_method :_constants, :constants
  alias_method :_instance_methods, :instance_methods
  alias_method :_protected_instance_methods, :protected_instance_methods
  alias_method :_public_instance_methods, :public_instance_methods

  private :_constants, :_instance_methods
  private :_protected_instance_methods, :_public_instance_methods

  if RUBY_VERSION < '1.9'
    def constants
      qt_methods(_constants, 0x10, true)
    end
  else
    def constants(_arg = true)
      qt_methods(_constants, 0x10, true)
    end
  end

  def instance_methods(inc_super=true)
    qt_methods(_instance_methods(inc_super), 0x0, inc_super)
  end

  def protected_instance_methods(inc_super=true)
    qt_methods(_protected_instance_methods(inc_super), 0x80, inc_super)
  end

  def public_instance_methods(inc_super=true)
    qt_methods(_public_instance_methods(inc_super), 0x0, inc_super)
  end

  private
  def qt_methods(meths, flags, inc_super=true)
    if !self.kind_of? Class
      return meths
    end

    klass = self
    classid = Qt::Internal::ModuleIndex.new(0, 0)
    loop do
      classid = Qt::Internal::find_pclassid(klass.name)
      break if classid.index

      klass = klass.superclass
      if klass.nil?
        return meths
      end
    end

    # These methods are all defined in Qt::Base, even if they aren't supported by a particular
    # subclass, so remove them to avoid confusion
    meths -= ["%", "&", "*", "**", "+", "-", "-@", "/", "<", "<<", "<=", ">", ">=", ">>", "|", "~", "^"]
    ids = []
    if inc_super
      Qt::Internal::getAllParents(classid, ids)
    end
    ids << classid
    ids.each { |c| Qt::Internal::findAllMethodNames(meths, c, flags) }
    return meths.uniq
  end
end
