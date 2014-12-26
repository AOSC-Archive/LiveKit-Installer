#include "installercore.h"

InstallerCore::InstallerCore(QObject *parent) :
    QObject(parent)
{
}

void InstallerCore::SetDesktopEnvironment(QString DE){
    if      (DE == "GNOME"){
        //  Todos:  use GNOME
    }// others
}

void InstallerCore::SetPackageManager(QString PM){
    if      (PM == "DPKG"){
        //  Todos:  use APT/DPKG
    }
}
