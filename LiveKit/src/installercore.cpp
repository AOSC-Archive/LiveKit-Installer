#include "installercore.h"
#include <QDebug>
#include <stdio.h>

InstallerCore::InstallerCore(QMLDynLoader *parent){
    systemThread = new F_systemThread(this);
//    systemThread->setExecCommand("sudo gparted");
    PartedWindow        = new PartitionList;
    DesktopEnvironment  = DEFAULT;
    PackageManager      = DEFAULT;
    installArtwork      = false;
    installChrome       = false;
    installIM           = false;
    installLibO         = false;
    installWine         = false;
    PartedWindow->setVisible(false);
    PartedWindow->resize(400,400);
}

void InstallerCore::setDesktopEnvironment(QString DE){
    qDebug() << DE << "is selected!";
    if      (DE == "GNOME"){
        DesktopEnvironment = DE_GNOME;
    }else if(DE == "CINNAMON"){
        DesktopEnvironment = DE_CINNAMON;
    }else if(DE == "DEEPIN"){
        DesktopEnvironment = DE_DEEPIN;
    }else if(DE == "KDE"){
        DesktopEnvironment = DE_KDE;
    }else if(DE == "MATE"){
        DesktopEnvironment = DE_MATE;
    }else if(DE == "PANTHEON"){
        DesktopEnvironment = DE_PANTHEON;
    }else if(DE == "UNITY"){
        DesktopEnvironment = DE_UNITY;
    }else if(DE == "XFCE"){
        DesktopEnvironment = DE_XFCE;
    }
}

void InstallerCore::setPackageManager(QString PM){
    qDebug() << PM << "is selected!";
    if      (PM == "DPKG"){
        PackageManager = DPKG;
    }else if(PM == "RPM"){
        PackageManager = RPM;
    }
}

void InstallerCore::launchGparted(){
    if(systemThread->isRunning()){
        systemThread->terminate();
//        system("sudo killall gparted gpartedbin");
    }
    systemThread->start();
}

void InstallerCore::switchWindowToPage2(){
    this->loadQml(QUrl("qrc:/qml/progress.qml"));
}

void InstallerCore::setOptional(QString Opt){
    qDebug() << Opt << "is selected!";
    if(Opt == "Artwork")
        installArtwork  = !installArtwork;
    else if(Opt == "Chrome")
        installChrome   = !installChrome;
    else if(Opt == "IM")
        installIM       = !installIM;
    else if(Opt == "LibO")
        installLibO     = !installLibO;
    else if(Opt == "Wine")
        installWine     = !installWine;
}

void InstallerCore::launchOS3Parted(void){
    this->PartedWindow->setVisible(!this->PartedWindow->isVisible());
    this->PartedWindow->RefreshList();
}

F_systemThread::F_systemThread(QObject *parent):
    QThread(parent){
}

void F_systemThread::setExecCommand(QString Cmd){
    ExecCommand = Cmd;
}


