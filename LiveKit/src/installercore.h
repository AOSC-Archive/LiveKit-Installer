#ifndef INSTALLERCORE_H
#define INSTALLERCORE_H

#include <QObject>
#include <QDebug>
#include <QThread>
#include "QMLDynLoader.h"
#include "partitionselect.h"
#include <QtQml>
#include <QWidget>

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
    void run();
signals:
    void    WorkDone(int);
protected:
    QString ExecCommand;
};

class F_getTarballThread : public QThread{
    Q_OBJECT
public:
    explicit F_getTarballThread(QObject *parent = 0);
    void setOpt(void *_Core,QString DE,QString PM);
    void run();
protected:
    void    *Core;
    QString DesktopEnvironment;
    QString PackageManager;
    QString Prefix;
    QString Suffix;
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
    Q_INVOKABLE void    launchOS3Parted(void);
    Q_INVOKABLE void    getRelease(void);

    void                progress_get(double progress);
signals:
    void newMessagePosted();
    void currentProcess(QVariant);
    void unpackingTarball();
    void updatingSystem();
    void installOptionalFeatures();
    void performingPostInstallation();
    void installDone();
public slots:
    void setNumber(int i  ){
        qDebug()<< "Number is " << i << endl;
    }
    void    switchWindowToPage2(void);
    void    downloadDone(void);
    void    unpackDone(int);
    void    updatingSystemDone(int);
    void    installOptionalFeaturesDone(int);
    void    performingPostInstallationDone(int);
protected:
     F_systemThread *systemThread;
     QString DesktopEnvironment;
     QString PackageManager;
     bool installArtwork;
     bool installChrome;
     bool installIM;
     bool installLibO;  // libreoffice
     bool installWine;
     PartedPage     *PartedWindow;
     F_getTarballThread *getTarballThread;
     double Progress;
     QWidget* MessageBoxWidget;
};


#endif // INSTALLERCORE_H
