#ifndef UDPCLIENT_HPP
#define UDPCLIENT_HPP

#include <QUdpSocket>
#include <QDataStream>
#include <qhostaddress.h>
#include <QByteArray>
#include <QDebug>

class UdpClient{
    public:
        UdpClient(const QHostAddress& targetAddress, quint16 targetPort) :
            targetAddress_(targetAddress),
            targetPort_(targetPort),
            stream_(&datagram_, QIODevice::WriteOnly) 
        {
            stream_.setByteOrder(QDataStream::BigEndian);
        }

        void send(QByteArray& data) {
            datagram_.clear();
            datagram_ = data;
            socket_.writeDatagram(datagram_, targetAddress_, targetPort_);
            qDebug() << "Sent: " << data;
        }

    private:
        QUdpSocket socket_;
        QHostAddress targetAddress_;
        qint16 targetPort_;
        QByteArray datagram_;
        QDataStream stream_;
};

#endif // UdpClient