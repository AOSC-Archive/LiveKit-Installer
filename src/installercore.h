#ifndef INSTALLERCORE_H
#define INSTALLERCORE_H

#include <QObject>
#include <QDebug>

class InstallerCore : public QObject
{
    Q_OBJECT
public:
    explicit InstallerCore(QObject *parent = 0);
    Q_INVOKABLE void    setDesktopEnvironment(QString);
    Q_INVOKABLE void    setPackageManager(QString);
signals:

public slots:
    void setNumber(int i  ){
        qDebug()<< "Number is " << i << endl;
    }

};

#endif // INSTALLERCORE_H
