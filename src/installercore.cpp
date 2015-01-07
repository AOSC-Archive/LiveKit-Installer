#include "installercore.h"
#include <QDebug>
#include <stdio.h>

InstallerCore::InstallerCore(QObject *parent) :
    QObject(parent)
{
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
