#include <QCoreApplication>
#include <ThreadSafeValue.hpp>
#include <UdpClient.hpp>
#include <qcoreapplication.h>


void sendCoordinates(ThreadSafeValue<double>& coordinateData, ThreadSafeValue<bool>& stopFlag) {
    QHostAddress targetAddress{"127.0.0.1"}; 
    quint16 targetPort{8080};
    UdpClient<double> udpClient(targetAddress, targetPort);

    double data;

    while(true) {
        if (coordinateData.hasNewValue()) {
            data = coordinateData.take();
            udpClient.send(data);
        }
        if (stopFlag.take()) {
            break;
        }
    }
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    
    ThreadSafeValue<bool> stopFlag(true);
    ThreadSafeValue<double> coordinateData(109.1);

    sendCoordinates(coordinateData, stopFlag);    

    return 0;
}