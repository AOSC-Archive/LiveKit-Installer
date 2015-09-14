QT_VERSION = $$[QT_VERSION]
QT_VERSION = $$split(QT_VERSION, ".")
QT_VER_MAJ = $$member(QT_VERSION, 0)
QT_VER_MIN = $$member(QT_VERSION, 1)

lessThan(QT_VER_MAJ, 5) | lessThan(QT_VER_MIN, 3) | {
    error(LiveKit-Installer is only tested under Qt 5.3!)
}

QT += qml quick widgets declarative core
TARGET = liveinst-qt
CODECFORSRC = UTF-8

include(src/src.pri)

OTHER_FILES +=       \
    qml/start.qml    \
    qml/progress.qml 

RESOURCES += resources.qrc

unix {
    isEmpty(PREFIX) {
        PREFIX = /usr
    }

    BINDIR = $$PREFIX/bin
    DATADIR = $$PREFIX/share
    DEFINES += PREFIX=\\\"$$PREFIX\\\"
    DEFINES += TARGET=\\\"$$TARGET\\\"
    DEFINES += DATADIR=\\\"$$DATADIR\\\" PKGDATADIR=\\\"$$PKGDATADIR\\\"
    INSTALLS += target desktop
    target.path = $$BINDIR
    desktop.path = $$DATADIR/applications
    desktop.files += $${TARGET}.desktop
    icon.path = $$DATADIR/icons/hicolor/256x256
    icon.files += images/$${TARGET}.png
}

DISTFILES += \
    qml/completion.qml

SOURCES += \
    src/QMLDynLoader.cpp \
    src/partitionselect.cpp

HEADERS += \
    src/QMLDynLoader.h \
    src/partitionselect.h

LIBS += -lparted -lcurl
