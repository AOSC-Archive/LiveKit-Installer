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
    QQmlApplicationEngine engine(QUrl("qrc:/qml/start.qml"));
    engine.rootContext()->setContextProperty("Core",&Core);
    Core.setEngine(&engine);
    return app.exec(); 
}
