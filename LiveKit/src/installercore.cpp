#include "installercore.h"
#include <QLayout>
#include <QDebug>
#include <stdio.h>
#include <string.h>
#include <curl/curl.h>
#include <QMessageBox>

CURL *curl;
CURLcode res;

size_t write_data(void *buffer, size_t size, size_t nmemb, void *user_p){
    FILE *fp = (FILE*)user_p;
    size_t return_size = fwrite(buffer,size,nmemb,fp);
    return return_size;
}

size_t progress_func(void *progress_data, double dltotal, double dlnow,double , double ){
    ((InstallerCore*)progress_data)->progress_get(dlnow*100.0/dltotal);
    return 0;
}


InstallerCore::InstallerCore(QMLDynLoader *){
    systemThread        = new F_systemThread(this);
    getTarballThread    = new F_getTarballThread(this);
    PartedWindow        = new PartedPage;
    MessageBoxWidget    = new QWidget;
    installArtwork      = false;
    installChrome       = false;
    installIM           = false;
    installLibO         = false;
    installWine         = false;
    PartedWindow->setVisible(false);
    PartedWindow->resize(465,430);
    PartedWindow->setMaximumSize(460,425);
    PartedWindow->setMinimumSize(460,425);
    this->connect(PartedWindow,SIGNAL(PartedDone()),this,SLOT(switchWindowToPage2()));
    this->connect(getTarballThread,SIGNAL(finished()),this,SLOT(downloadDone()));
}

void InstallerCore::setDesktopEnvironment(QString DE){
    qDebug() << DE << "is selected!";
    DesktopEnvironment = DE;
}

void InstallerCore::setPackageManager(QString PM){
    qDebug() << PM << "is selected!";
    PackageManager = PM;
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
    if(DesktopEnvironment.isEmpty())
        exit(0);
    if(PackageManager.isEmpty())
        exit(0);
    getTarballThread->setOpt(this,DesktopEnvironment,PackageManager);
    this->connect(this,SIGNAL(currentProcess(QVariant)),this->mEngine_->rootObjects().value(1), SLOT(onProgressArrive(QVariant)));
    this->connect(this,SIGNAL(unpackingTarball()),      this->mEngine_->rootObjects().value(1), SLOT(onUnpackingTarball()));
    this->connect(this,SIGNAL(updatingSystem()),        this->mEngine_->rootObjects().value(1), SLOT(onUpdatingSystem()));
    this->connect(this,SIGNAL(installOptionalFeatures()),this->mEngine_->rootObjects().value(1),SLOT(onInstallOptionalFeatures()));
    this->connect(this,SIGNAL(installDone()),           this->mEngine_->rootObjects().value(1), SLOT(onInstallDone()));
    this->getRelease();
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

void InstallerCore::getRelease(){
    getTarballThread->start();
}

void InstallerCore::launchOS3Parted(void){
    this->PartedWindow->PervShow();
    this->PartedWindow->setVisible(!this->PartedWindow->isVisible());
}

void InstallerCore::progress_get(double progress){
    emit this->currentProcess(progress);
    this->Progress = progress;
}

void InstallerCore::downloadDone(){
    if(Progress < 99.9) exit(0);
    // step II (Unpack tarball)
    systemThread->setExecCommand("tar -xf /target/OS3Release.tar.xz > /tmp/output");
    systemThread->start();
    emit unpackingTarball();
}

void InstallerCore::unpackDone(int status){
    if(status != 0){
        QMessageBox::warning(MessageBoxWidget,tr("Warning"),tr("Failed to unpack system tarball!  Please read /tmp/output for detail"),QMessageBox::Yes);
        exit(0);
    }
    if (system(PRE_INST_SCRIPT) != 0){
        QMessageBox::warning(MessageBoxWidget,tr("Warning"),tr("Failed to execute PreInst script/command"),QMessageBox::Yes);
        exit(0);
    }
    systemThread->disconnect(   systemThread,SIGNAL(WorkDone(int)),this,SLOT(unpackDone(int)));
    this->connect(              systemThread,SIGNAL(WorkDone(int)),this,SLOT(updatingSystemDone(int)));
    if(this->PackageManager == "dpkg")
        systemThread->setExecCommand(DPKG_UPDATE_SYSTEM_COMMAND);
    else
        systemThread->setExecCommand(RPM_UPDATE_SYSTEM_COMMAND);
    emit this->updatingSystem();
    systemThread->start();
}

void InstallerCore::updatingSystemDone(int status){
    if(status != 0){
        if(QMessageBox::warning(MessageBoxWidget,tr("Warning"),tr("Failed to updating system!  Do you want to go on installing?"),QMessageBox::Yes|QMessageBox::No) == QMessageBox::No)
            exit(0);
    }
    this->disconnect(systemThread,SIGNAL(WorkDone(int)),this,SLOT(updatingSystemDone(int)));
    this->connect(systemThread,SIGNAL(WorkDone(int)),this,SLOT(installOptionalFeaturesDone(int)));
    char ExecBuf[512] = {0};
    if(this->PackageManager == "dpkg")
        sprintf(ExecBuf,"apt install ");
        if(installArtwork){
            strcat(ExecBuf,PNs_ARTWORK);
            strcat(ExecBuf," ");
        }
        if(installChrome){
            strcat(ExecBuf,PNs_CHROME);
            strcat(ExecBuf," ");
        }
        if(installIM){
            strcat(ExecBuf,PNs_IM);
            strcat(ExecBuf," ");
        }
        if(installLibO){
            strcat(ExecBuf,PNs_LIBO);
            strcat(ExecBuf," ");
        }
        if(installWine){
            strcat(ExecBuf,PNs_WINE);
            strcat(ExecBuf," ");
        }
        systemThread->setExecCommand(ExecBuf);
    emit this->installOptionalFeatures();
    systemThread->start();
}

void InstallerCore::installOptionalFeaturesDone(int status){
    if(status != 0){
        if (QMessageBox::warning(MessageBoxWidget,tr("Warning"),tr("Failed to install optional features! Do you want to go on installing?"),QMessageBox::Yes|QMessageBox::No) == QMessageBox::No)
            exit(0);
    }
    systemThread->disconnect(systemThread,SIGNAL(WorkDone(int)),this,SLOT(installOptionalFeaturesDone(int)));
    systemThread->connect(systemThread,SIGNAL(WorkDone(int)),this,SLOT(performingPostInstallationDone(int)));
    systemThread->setExecCommand(POST_INST_SCRIPT);
    emit this->performingPostInstallation();
    systemThread->start();
}

void InstallerCore::performingPostInstallationDone(int status){
    if(status != 0){
        QMessageBox::warning(MessageBoxWidget,tr("Warning"),tr("Failed to performing post-installation scripts!  Please read /tmp/output for detail"),QMessageBox::Yes);
        exit(0);
    }
    systemThread->disconnect(systemThread,SIGNAL(WorkDone(int)),this,SLOT(performingPostInstallationDone(int)));
    emit this->installDone();
    // Then what should installer do?
}

F_getTarballThread::F_getTarballThread(QObject *parent):
    QThread(parent){
}
void F_getTarballThread::setOpt(void *_Core, QString DE, QString PM){
    Prefix = "http://mirrors.ustc.edu.cn/anthon/os3-releases/01_Beta/01_Tarballs/aosc-os3_";
    Suffix = "_en-US.tar.xz";
    Core = _Core;
    DesktopEnvironment  = DE;
    PackageManager      = PM;
}

void F_getTarballThread::run(){
    CURLcode return_code;
    return_code = curl_global_init(CURL_GLOBAL_ALL);        // initialize everything possible
    if(return_code != CURLE_OK){
        fprintf(stderr,"init libcurl failed!\n");
        return;
    }
    CURL *easy_handle = curl_easy_init();
    if(easy_handle == NULL){
        fprintf(stderr,"get a easy handle failed!\n");
        curl_global_cleanup();
        return;
    }
    char TarballURL[256] = {0};
    strcpy(TarballURL,Prefix.toUtf8().data());
    strcat(TarballURL,DesktopEnvironment.toUtf8().data());
    strcat(TarballURL,"-beta_pichu_");
    strcat(TarballURL,PackageManager.toUtf8().data());
    strcat(TarballURL,Suffix.toUtf8().data());
    printf("URL = %s\n",TarballURL);
    FILE *fp = fopen("/target/OS3Beta.tar.xz","ab+");
    curl_easy_setopt(easy_handle,CURLOPT_URL,TarballURL);
    curl_easy_setopt(easy_handle, CURLOPT_NOPROGRESS, 0);
    curl_easy_setopt(easy_handle, CURLOPT_PROGRESSDATA,Core);
    curl_easy_setopt(easy_handle, CURLOPT_PROGRESSFUNCTION, progress_func);
    curl_easy_setopt(easy_handle, CURLOPT_WRITEFUNCTION, &write_data);
    curl_easy_setopt(easy_handle, CURLOPT_WRITEDATA, fp);

    curl_easy_perform(easy_handle);
    curl_easy_cleanup(easy_handle);
    curl_global_cleanup();
    return;
}


F_systemThread::F_systemThread(QObject *parent):
    QThread(parent){
}

void F_systemThread::setExecCommand(QString Cmd){
    ExecCommand = Cmd;
}

void F_systemThread::run(){
    emit WorkDone(system(ExecCommand.toUtf8().data()));
}
