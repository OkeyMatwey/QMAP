#include "backend.h"

backend::backend(int port)
{
    TIFF* tif = TIFFOpen("d:/tiff_shevtsovo/rus_69_shevtsovo_X_n_F1_1_rli.tif", "r");
    for(int i = 254; i < 50000; i++)
    {
        uint32  count;
        uint32   *data;
        int b = 0;
        try {
            b = TIFFGetField(tif, i, &count, &data);
        }  catch (int e) {continue;}
        if(b)
        {
            qDebug() << i << count << *reinterpret_cast<uint32*>(data);
        }
    }
    TIFFClose(tif);

    udpSocket.bind(QHostAddress::LocalHost, port);

    connect(&udpSocket, &QUdpSocket::readyRead, this, &backend::readPendingDatagrams);
}

void backend::readPendingDatagrams()
{
    struct gps
    {
        float x;
        float y;
    };

    while (udpSocket.hasPendingDatagrams())
    {
        QNetworkDatagram datagram = udpSocket.receiveDatagram();
        gps x = *reinterpret_cast<gps*>(datagram.data().data());
        QGeoCoordinate new_point(x.x, x.y);
        points.append(new_point);
        emit sendToQmlpoint(x.x, x.y);
        emit sendToQmlimg(x.x, x.y, "file:d:/tiff_shevtsovo/rus_69_shevtsovo_X_n_F1_1_rli.tif");
    }
}


