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

    Text {
        id: smile
        x: 56
        y: 170
        color: "#666666"
        text: qsTr(":-)")
        font.bold: true
        font.pixelSize: 140
    }

    Text {
        id: congrats
        x: 250
        y: 170
        color: "#666666"
        text: qsTr("Congratulations!")
        font.bold: true
        font.pixelSize: 48
    }

    Text {
        id: congratsWithAttitude
        x: 250
        y: 230
        width: 700
        color: "#666666"
        text: qsTr("An adventure has just got started. AOSC strives to make you a fresh experience every day (well... every so often),
                                and we wish you a good day with AOSC OS. If you have any question please find us at #anthon (Freenode).<br><br>
                                Now pick a route below and start the adventure! Be brave.")
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        font.pixelSize: 12
    }

    RadioButton {
        id: kexec
        x: 56
        y: 380
        text: qsTr("                                Kexec (direct boot) into AOSC OS")
    }

    RadioButton {
        id: reboot
        x: 56
        y: 420
        text: qsTr("                                Reboot the computer")
    }

    RadioButton {
        id: quit
        x: 56
        y: 460
        text: qsTr("                                Exit the installer and do more with LiveKit")
    }
}
