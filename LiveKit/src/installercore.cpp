#include "installercore.h"
#include <QLayout>
#include <QDebug>
#include <stdio.h>
#include <string.h>
#include <curl/curl.h>

CURL *curl;
CURLcode res;

size_t write_data(void *buffer, size_t size, size_t nmemb, void *user_p){
    FILE *fp = (FILE*)user_p;
    size_t return_size = fwrite(buffer,size,nmemb,fp);
    return return_size;
}

size_t progress_func(void *progress_data, double dltotal, double dlnow,double ultotal, double ulnow){
    ((InstallerCore*)progress_data)->progress_get(dlnow*100.0/dltotal);
    return 0;
}


InstallerCore::InstallerCore(QMLDynLoader *parent){
    systemThread        = new F_systemThread(this);
    getTarballThread    = new F_getTarballThread(this);
    PartedWindow        = new PartedPage;
    installArtwork      = false;
    installChrome       = false;
    installIM           = false;
    installLibO         = false;
    installWine         = false;
    PartedWindow->setVisible(false);
    PartedWindow->resize(465,430);
    PartedWindow->setMaximumSize(460,425);
    PartedWindow->setMinimumSize(460,425);
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

}

void InstallerCore::launchOS3Parted(void){
    this->PartedWindow->PervShow();
    this->PartedWindow->setVisible(!this->PartedWindow->isVisible());
}

void InstallerCore::progress_get(double progress){
    return;
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
    FILE *fp = fopen("/tmp/OS3Beta.tar.xz","ab+");
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


