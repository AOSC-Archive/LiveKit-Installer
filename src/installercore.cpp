#include "installercore.h"
#include <QDebug>
#include <stdio.h>

InstallerCore::InstallerCore(QObject *parent) :
    QObject(parent){
    systemThread = new F_systemThread(this);
//    systemThread->setExecCommand("sudo gparted");
    DesktopEnvironment  = DEFAULT;
    PackageManager      = DEFAULT;
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
    qDebug() << PM << "is selected!" << endl;
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

F_systemThread::F_systemThread(QObject *parent):
    QThread(parent){
}

void F_systemThread::setExecCommand(QString Cmd){
    ExecCommand = Cmd;
}
