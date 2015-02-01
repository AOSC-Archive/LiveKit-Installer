#ifndef QMLDYNLOADER_H
#define QMLDYNLOADER_H


#include <QObject>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QQuickWindow>
#include <QQuickView>


class QMLDynLoader : public QObject{
    Q_OBJECT
public:
    QMLDynLoader();

    void setEngine( QQmlApplicationEngine* engine );
    void loadQml(const QUrl& qmlFile );
private:
    QQuickView* mView_;             //显示的view
    QQuickWindow* mParentWindow_;   //框架的父窗体
    QQmlApplicationEngine* mEngine_;
signals:
    void sError(const QString errorMsg);
};

#endif // QMLDYNLOADER_H
