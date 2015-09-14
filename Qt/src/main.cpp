#include <QApplication>
#include "installercore.h"

#include <QtQml>
#include <QtQuick/QQuickView>
#include "QMLDynLoader.h"

int main(int argc, char *argv[]){
    QApplication app(argc, argv);
    app.setApplicationName("LiveKit-Installer");
    app.setApplicationVersion("0.0.1");
    app.setOrganizationName("Anthon Open Source Community");

    InstallerCore Core;
    qmlRegisterType<InstallerCore>("com.aosc.InstallerCore",1,0,"InstallerCore");

    QQmlApplicationEngine engine(QUrl("qrc:/qml/start.qml"));
    //QObject::connect(&Core,SIGNAL(newMessagePosted()), engine.rootObjects().value(0),SLOT(messageArrive()));
    engine.rootContext()->setContextProperty("Core",&Core);
    Core.setEngine(&engine);
    return app.exec();
}
