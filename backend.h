#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QTcpSocket>

class backend: public QObject
{
    Q_OBJECT
public:
    backend();
};

#endif // BACKEND_H
