#ifndef INSTALLERCORE_H
#define INSTALLERCORE_H

#include <QObject>

class InstallerCore : public QObject
{
    Q_OBJECT
public:
    explicit InstallerCore(QObject *parent = 0);
    Q_INVOKABLE void    SetDesktopEnvironment(QString);
    Q_INVOKABLE void    SetPackageManager(QString);
signals:

public slots:

};

#endif // INSTALLERCORE_H
