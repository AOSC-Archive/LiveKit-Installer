import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.2

ApplicationWindow {
    id: livekitwindow
    title: qsTr("LiveKit Installer")
    width: 1024
    height: 720
    visible: true
    flags: Qt.FramelessWindowHint

    MouseArea {
        id: moving
        x: 0
        y: 0
        width: 1024
        height: 128
        property var clickPos: "1,1"

        onPressed: {
            clickPos  = Qt.point(mouse.x,mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            livekitwindow.x = (livekitwindow.x+delta.x/5);
            livekitwindow.y = (livekitwindow.y+delta.y/5);
        }
    }

    Rectangle {
        id: rectangle1
        x: 0
        y: 0
        width: 1024
        height: 128
        color: "#474747"

        Image {
            id: syslogo
            x: 900
            y: 16
            width: 96
            height: 96
            source: "qrc:/img/SysLogo_Desktop.png"
        }

        Image {
            id: quitlogo
            x: 16
            y: 16
            width: 24
            height: 24
            source: "qrc:/img/Progress_Error.png"
        }

        MouseArea {
            id: mouseArea1
            x: 16
            y: 16
            width: 24
            height: 24
            onClicked: {
                Qt.quit()
            }
        }
    }

    ProgressBar {
        id: installProgress
        x: 56
        y: 250
        width: 924
        value: 0.4
    }

    Text {
        id: title
        x: 56
        y: 170
        color: "#666666"
        text: qsTr("Installation In Progress...")
        font.bold: true
        font.pixelSize: 36
    }

    Text {
        id: ouput
        x: 56
        y: 280
        width: 924
        height: 16
        color: "#666666"
        text: qsTr("Output Foo")
        font.pixelSize: 14
    }

    Image {
        id: progressStage1
        x: 56
        y: 360
        width: 28
        height: 28
        source: "qrc:/img/Progress_Working.png"
    }

    Image {
        id: progressStage2
        x: 56
        y: 400
        width: 28
        height: 28
        source: "qrc:/img/Progress_Working.png"
    }

    Image {
        id: progressStage3
        x: 56
        y: 440
        width: 28
        height: 28
        source: "qrc:/img/Progress_Working.png"
    }

    Image {
        id: progressStage4
        x: 56
        y: 480
        width: 28
        height: 28
        source: "qrc:/img/Progress_Working.png"
    }

    Image {
        id: progressStage5
        x: 56
        y: 520
        width: 28
        height: 28
        source: "qrc:/img/Progress_Working.png"
    }

    Text {
        id: downloading
        x: 130
        y: 365
        width: 844
        height: 16
        color: "#666666"
        text: qsTr("Downloading system release...")
        font.pixelSize: 14
        }

    Text {
        id: unpack
        x: 130
        y: 405
        width: 844
        height: 16
        color: "#666666"
        text: qsTr("Unpacking system tarball...")
        font.pixelSize: 14
        }

    Text {
        id: update
        x: 130
        y: 445
        width: 844
        height: 16
        color: "#666666"
        text: qsTr("Updating system...")
        font.pixelSize: 14
        }

    Text {
        id: option
        x: 130
        y: 485
        width: 844
        height: 16
        color: "#666666"
        text: qsTr("Installing optional features...")
        font.pixelSize: 14
        }

    Text {
        id: configuration
        x: 130
        y: 525
        width: 844
        height: 16
        color: "#666666"
        text: qsTr("Performing post-installation configuration...")
        font.pixelSize: 14
        }

    Text {
        id: notice
        x: 56
        y: 585
        width: 924
        color: "#666666"
        text: "Please sit back and have a cup of tea. Depending on the performance of your machine and the speed of Internet connection,
                    setup can take a while to finish. Generally by installing a GNOME system build and install all the optional features available,
                    setup can take up to 30 minutes with a 10 Mbps Internet connection and a relatively new computer with a solid state drive."
        font.pointSize: 10
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        }
    }
