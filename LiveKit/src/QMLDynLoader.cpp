#include "QMLDynLoader.h"


QMLDynLoader::QMLDynLoader(){
    this->mEngine_ = NULL;
    this->mView_ = NULL;
    this->mParentWindow_ = NULL;
}

void QMLDynLoader::setEngine(QQmlApplicationEngine *engine){
    this->mEngine_ = engine ;
    if( this->mEngine_ == NULL ){
        emit this->sError("初始化qml引擎失败");
        return ;
    }
    this->mEngine_->clearComponentCache();
    if( this->mView_ )
        return ;
    //获取主窗体
    if( this->mEngine_->rootObjects().count( ) >= 0 ){
        this->mParentWindow_ = qobject_cast<QQuickWindow*>( this->mEngine_->rootObjects().value(0));
        if(this->mParentWindow_ == NULL ){
            emit this->sError("无法独立加载QML，必须先加载主窗体.");
            return ;
        }
    }
   this->mView_ = new QQuickView(this->mEngine_ , this->mParentWindow_ );
}

void QMLDynLoader::loadQml(const QUrl& qmlFile){
    if(this->mView_){
        mEngine_->load(qmlFile);
        //this->mView_->close();
        //this->mParentWindow_->close();
        this->mParentWindow_ = qobject_cast<QQuickWindow*>( this->mEngine_->rootObjects().value(0));
        mView_ = new QQuickView(this->mEngine_, this->mParentWindow_);
    }
}
