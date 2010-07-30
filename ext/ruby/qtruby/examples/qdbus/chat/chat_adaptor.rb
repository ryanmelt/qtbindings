
class ChatAdaptor < Qt::DBusAbstractAdaptor
    q_classinfo("D-Bus Interface", "com.trolltech.chat")

    signals 'action(const QString&, const QString&)',
            'message(const QString&, const QString&)'

    def initialize(parent = nil)
        super
        setAutoRelaySignals(true)
    end
end
