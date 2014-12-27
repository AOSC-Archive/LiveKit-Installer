#include <QApplication>
#include "installercore.h"

#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/qdeclarative.h>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    InstallerCore Core;
    engine.rootContext()->setContextProperty("Core",&Core);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
