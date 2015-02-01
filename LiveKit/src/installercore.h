#ifndef INSTALLERCORE_H
#define INSTALLERCORE_H

#include <QObject>
#include <QDebug>
#include <QThread>
#include "QMLDynLoader.h"

#ifndef LIVEKIT_DEF
#define LIVEKIT_DEF
    #define DEFAULT     0
    #define DE_GNOME    1
    #define DE_CINNAMON 2
    #define DE_DEEPIN   3
    #define DE_KDE     4
    #define DE_MATE     5
    #define DE_PANTHEON 6
    #define DE_UNITY    7
    #define DE_XFCE     8
    #define DPKG        9
    #define RPM         10
#endif

class F_systemThread : public QThread{  // Function systenm() thread
    Q_OBJECT
public:
    explicit F_systemThread(QObject *parent = 0);
    void setExecCommand(QString);
    void run(){
        if(ExecCommand.isEmpty())
            return;
        else
            system(ExecCommand.toUtf8().data());
    };
protected:
    QString ExecCommand;
};

class InstallerCore : public QMLDynLoader{
    Q_OBJECT
public:
    explicit InstallerCore(QMLDynLoader *parent = 0);
    ~InstallerCore(){
//        system("sudo killall gparted gpartedbin");
    }
    Q_INVOKABLE void    setDesktopEnvironment(QString);
    Q_INVOKABLE void    setPackageManager(QString);
    Q_INVOKABLE void    setOptional(QString);
    Q_INVOKABLE void    launchGparted(void);
    Q_INVOKABLE void    switchWindowToPage2(void);
signals:

public slots:
    void setNumber(int i  ){
        qDebug()<< "Number is " << i << endl;
    }
protected:
     F_systemThread *systemThread;
     int DesktopEnvironment;
     int PackageManager;
     bool installArtwork;
     bool installChrome;
     bool installIM;
     bool installLibO;  // libreoffice
     bool installWine;
};

#endif // INSTALLERCORE_H
