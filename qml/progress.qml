import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.2

ApplicationWindow {
    id: livekitwindow
    title: qsTr("AOSC LiveKit")
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
        id: progressBar1
        x: 50
        y: 217
        width: 942
        value: 0.4
    }

}
