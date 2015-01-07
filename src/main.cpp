#include <QApplication>
#include "installercore.h"

#include <QtQml>
#include <QtQuick/QQuickView>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setApplicationName("LiveKit-Installer");
    app.setApplicationVersion("0.0.1");
    app.setOrganizationName("Anthon Open Source Community");

    QQmlApplicationEngine engine(QUrl("qrc:/qml/start.qml"));

    InstallerCore Core;

    QObject* topLevel = engine.rootObjects().value(0);
    QQuickWindow* window = qobject_cast<QQuickWindow *>(topLevel);
    if (!window) {
        qWarning("ERROR: Your root item has to be a Window");
        return -1;
    }
    window->setTitle("LiveKit Installer");
    window->show();

    return app.exec(); 
}
