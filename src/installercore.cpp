#include "installercore.h"
#include <QDebug>
#include <stdio.h>

InstallerCore::InstallerCore(QObject *parent) :
    QObject(parent){
    systemThread = new F_systemThread(this);
    systemThread->setExecCommand("sudo gparted");
}

void InstallerCore::setDesktopEnvironment(QString DE){
    qDebug() << DE << "is selected!";
    if      (DE == "GNOME"){
    }else if(DE == "CINNAMON"){
    }else if(DE == "DEEPIN"){
    }else if(DE == "KODI"){
    }else if(DE == "MATE"){
    }else if(DE == "PANTHEON"){
    }else if(DE == "UNITY"){
    }else if(DE == "XFCE"){
    }
}

void InstallerCore::setPackageManager(QString PM){
    qDebug() << PM << "is selected!" << endl;
    if      (PM == "DPKG"){
    }else if(PM == "RPM"){
    }
}

void InstallerCore::launchGparted(){
    if(systemThread->isRunning()){
        systemThread->terminate();
        system("sudo killall gparted gpartedbin");
    }
    systemThread->start();
}

F_systemThread::F_systemThread(QObject *parent):
    QThread(parent){
}

void F_systemThread::setExecCommand(QString Cmd){
    ExecCommand = Cmd;
}
