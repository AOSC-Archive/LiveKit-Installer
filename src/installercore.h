#ifndef INSTALLERCORE_H
#define INSTALLERCORE_H

#include <QObject>
#include <QDebug>
#include <QThread>

#ifndef LIVEKIT_DEF
#define LIVEKIT_DEF
    #define DE_GNOME    1
    #define DE_CINNAMON 2
    #define DE_DEEPIN   3
    #define DE_KODI     4
    #define DE_MATE     5
    #define DE_PANTHEON 6
    #define DE_UNITY    7
    #define DE_XFCE     8
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

class InstallerCore : public QObject{
    Q_OBJECT
public:
    explicit InstallerCore(QObject *parent = 0);
    ~InstallerCore(){
        system("sudo killall gparted gpartedbin");
    }
    Q_INVOKABLE void    setDesktopEnvironment(QString);
    Q_INVOKABLE void    setPackageManager(QString);
    Q_INVOKABLE void    launchGparted(void);
signals:

public slots:
    void setNumber(int i  ){
        qDebug()<< "Number is " << i << endl;
    }
protected:
     F_systemThread *systemThread;

};

#endif // INSTALLERCORE_H
