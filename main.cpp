#include <QApplication>
#include <QQmlApplicationEngine>
#include "installercore.h"

#include <QtDeclarative/QtDeclarative>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<InstallerCore>("InstallerCore",1,0,"InstallerCoreInQML");
    QQmlApplicationEngine engine;
    InstallerCore Core;
    engine.rootContext()->setContextProperty("Core",&Core);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
