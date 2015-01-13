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

    ScrollView {
        x: 0
        y: 128
        width: 1024
        height: 592


        style: ScrollViewStyle {
            transientScrollBars: true
        }

        Rectangle {
            x: 0
            y: 0
            width:1024
            height: 3000
            color: "#f6f6f6"

            Text {
                id: howdy
                x: 56
                y: 20
                color: "#666666"
                text: qsTr("<b>Hi there.</b>")
                font.family: "Sans"
                textFormat: Text.RichText
                font.pixelSize: 48
            }

            Text {
                id: howdyInDetail
                x: 56
                y: 105
                width: 870
                height: 148
                color: "#666666"
                text: qsTr("Thanks for checking out AOSC OS.<br /><br /> AOSC OS is now richer than ever, with numerous choices in desktop environment, optional packages, and even package managers.
                                    LiveKit installer will lead you through the installation of AOSC OS, your first stop here is to pick the desktop, package manager, and optional features you would want
                                    installed on your copy of AOSC OS. Please take your time and make good choices - no need to worry about wrong choices though, you can always install the other choices
                                    after you finished the installation (when necessary, consult AOSC TechBase at <link>http://wiki-dev.anthonos.org</link>).")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 15
            }

            Text {
                id: holdonthere
                x: 56
                y: 315
                width: 900
                height: 40
                color: "#666666"
                text: qsTr("<b>Before you start...</b>")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 32
            }

            Text {
                id: elderlytalk
                x: 56
                y: 385
                width: 870
                height: 100
                color: "#666666"
                text: qsTr("1. Make sure you are <b>connected to the Internet</b> (setup cannot continue without a working Internet connection);<br />
                                    2. Make sure you have already done <b>a backup</b> of your important files (just in case);<br />
                                    3. Make sure you are <b>plugged into AC</b> if you are using a laptop (consequence may be destructive given a failed power supply);<br />
                                    4. Make sure you <b>keep scrolling</b> until you see the button for next step (pay attention);<br /><br /><br />
                                    <b>So get scrolling shall we? ;-)</b>")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 15
            }

            Text {
                id: stop1
                x: 56
                y: 590
                width: 870
                height: 40
                color: "#666666"
                text: qsTr("<b>Stop I. Choose a Package Manager</b>")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 32
            }

            Text {
                id: stop1text
                x: 56
                y: 650
                width: 870
                height: 40
                color: "#666666"
                text: qsTr("Choose from the two package managers below, please pay attention to all description below.")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 15
            }

            Grid {
                x: 56
                y: 710
                columns: 2

                Rectangle {
                    color: "#f6f6f6"
                    width: 200
                    height: 150
                    Image {
                        id: dpkglogo
                        width: 128
                        height: 128
                        source: "qrc:/img/Logo_DPKG.png"
                        MouseArea {
                            anchors.fill:parent
                            onClicked: {
                                onClicked: dpkgselected.visible = true
                                onClicked: rpmselected.visible = false
                            }
                        }

                    }
                }

                Rectangle {
                    width: 700
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: dpkgtitle
                        color: "#666666"
                        text: qsTr("<b>DPKG (Debian Packages)</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        id: dpkgdesc
                        color: "#666666"
                        text: qsTr("Debian Packages are mainly used by Debian GNU/Linux, Ubuntu and their derivatives.<br /> DPKG provides simple-to-use tools for package management. DPKG is probably more<br /> suitable
                                            for first timers, and it's recommended for AOSC OS over RPM for its simplicity.")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 15
                    }

                    Image {
                        id: dpkgselected
                        x: -96
                        y: 104
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
                }

                Rectangle {
                    color: "#f6f6f6"
                    width: 200
                    height: 150
                    Image {
                        id: rpmlogo
                        width: 128
                        height: 128
                        source: "qrc:/img/Logo_RPM.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            onClicked: rpmselected.visible = true
                            onClicked: dpkgselected.visible = false
                        }
                    }
                }

                Rectangle {
                    x: 150
                    width: 450
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: rpmtitle
                        color: "#666666"
                        text: qsTr("<b>RPM (Red Hat Package Manager)</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        id: rpmdesc
                        color: "#666666"
                        text: qsTr("RPM is mainly used by Fedora, RedHat, CentOS, Mandriva and many more. RPM<br /> generally provides a more complex but accurate dependency tree and packages are<br /> interchangable between
                                            different operating systems (if applicable). RPM is experimental<br /> for AOSC OS3, thus it may bring trouble to first timers.")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 15
                    }
                    Image {
                        id: rpmselected
                        x: -96
                        y: 104
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
                }
            }

            Text {
                id: stop2
                x: 56
                y: 1025
                width: 870
                height: 40
                color: "#666666"
                text: qsTr("<b>Stop II. Choose a Desktop Environment")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 32
            }

            Text {
                id: stop2text
                x: 56
                y: 1080
                width: 870
                height: 40
                color: "#666666"
                text: qsTr("AOSC OS supports numerous desktop environments, and here below is the ones we would recommend as default desktop environment. Pick your choice, they are equally good if you are new.")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 15
            }

            Grid {
                x: 56
                y: 1165
                columns: 4
                spacing: 2

                Rectangle {
                    width: 128
                    height: 150
                    color: "#f6f6f6"
                    Image {
                        id: gnomelogo
                        width: 96
                        height: 96
                        source: "qrc:/img/gnome-oobp.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            onClicked: gnomeselected.visible        = true
                            onClicked: cinnamondescselected.visible = false
                            onClicked: mateselected.visible         = false
                            onClicked: xfceselected.visible         = false
                            onClicked: unityselected.visible        = false
                            onClicked: deepinselected.visible       = false
                            onClicked: pantheonselected.visible     = false
                            onClicked: kdeselected.visible         = false
                            Core.setDesktopEnvironment("GNOME")         // FSCK QT!
                        }
                    }
                }

                Rectangle {
                    width: 300
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: gnometitle
                        color: "#666666"
                        text: qsTr("<b>GNOME</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        width: 280
                        id: gnomedesc
                        color: "#666666"
                        text: qsTr("GNOME is a free and open source desktop environment and applications suite, suitable for newer computers.")
                        font.family: "Sans"
                        wrapMode: Text.WordWrap
                        textFormat: Text.RichText
                        font.pixelSize: 15
                    }
                    Image {
                        id: gnomeselected
                        x: -46
                        y: 76
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
                }

                Rectangle {
                    width: 128
                    height: 150
                    color: "#f6f6f6"
                    Image {
                        id: cinnamonlogo
                        width: 96
                        height: 96
                        source: "qrc:/img/cinnamon-oobp.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            onClicked: gnomeselected.visible        = false
                            onClicked: cinnamondescselected.visible = true
                            onClicked: mateselected.visible         = false
                            onClicked: xfceselected.visible         = false
                            onClicked: unityselected.visible        = false
                            onClicked: deepinselected.visible       = false
                            onClicked: pantheonselected.visible     = false
                            onClicked: kdeselected.visible         = false
                            Core.setDesktopEnvironment("CINNAMON")
                        }
                    }
                }

                Rectangle {
                    width: 300
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: cinnamontitle
                        color: "#666666"
                        text: qsTr("<b>Cinnamon</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        width: 280
                        id: cinnamondesc
                        color: "#666666"
                        text: qsTr("Cinnamon is a fork of GNOME 3, with a redesigned interface optimized for conventional desktop PCs.")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        font.pixelSize: 15
                    }
                    Image {
                        id: cinnamondescselected
                        x: -46
                        y: 76
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
              }

                Rectangle {
                    width: 128
                    height: 150
                    color: "#f6f6f6"
                    Image {
                        id: matelogo
                        width: 96
                        height: 96
                        source: "qrc:/img/mate-oobp.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            onClicked: gnomeselected.visible        = false
                            onClicked: cinnamondescselected.visible = false
                            onClicked: mateselected.visible         = true
                            onClicked: xfceselected.visible         = false
                            onClicked: unityselected.visible        = false
                            onClicked: deepinselected.visible       = false
                            onClicked: pantheonselected.visible     = false
                            onClicked: kdeselected.visible         = false
                            Core.setDesktopEnvironment("MATE")
                        }
                    }
                }

                Rectangle {
                    width: 300
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: matetitle
                        color: "#666666"
                        text: qsTr("<b>MATE</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        width: 280
                        id: matedesc
                        color: "#666666"
                        text: qsTr("MATE is a fork of GNOME 2, but not for nostalgic purpose.")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        font.pixelSize: 15
                    }
                    Image {
                        id: mateselected
                        x: -46
                        y: 76
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
              }


                Rectangle {
                    width: 128
                    height: 150
                    color: "#f6f6f6"
                    Image {
                        id: xfcelogo
                        width: 96
                        height: 96
                        source: "qrc:/img/xfce-oobp.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            onClicked: gnomeselected.visible        = false
                            onClicked: cinnamondescselected.visible = false
                            onClicked: mateselected.visible         = false
                            onClicked: xfceselected.visible         = true
                            onClicked: unityselected.visible        = false
                            onClicked: deepinselected.visible       = false
                            onClicked: pantheonselected.visible     = false
                            onClicked: kdeselected.visible         = false
                            Core.setDesktopEnvironment("XFCE")
                        }
                    }
                }

                Rectangle {
                    width: 300
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: xfcetitle
                        color: "#666666"
                        text: qsTr("<b>XFCE</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        width: 280
                        id: xfcedesc
                        color: "#666666"
                        text: qsTr("XFCE is a popular lightweight GTK+2 desktop, nimble like a cute little mouse.")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        font.pixelSize: 15
                    }
                    Image {
                        id: xfceselected
                        x: -46
                        y: 76
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
              }

                Rectangle {
                    width: 128
                    height: 150
                    color: "#f6f6f6"
                    Image {
                        id: unitylogo
                        width: 96
                        height: 96
                        source: "qrc:/img/unity-oobp.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            onClicked: gnomeselected.visible        = false
                            onClicked: cinnamondescselected.visible = false
                            onClicked: mateselected.visible         = false
                            onClicked: xfceselected.visible         = false
                            onClicked: unityselected.visible        = true
                            onClicked: deepinselected.visible       = false
                            onClicked: pantheonselected.visible     = false
                            onClicked: kdeselected.visible         = false
                            Core.setDesktopEnvironment("UNITY")
                        }
                    }
                }

                Rectangle {
                    width: 300
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: unitytitle
                        color: "#666666"
                        text: qsTr("<b>Unity</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        width: 280
                        id: unitydesc
                        color: "#666666"
                        text: qsTr("The default (and arguably easy to use) desktop environment of Ubuntu.")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        font.pixelSize: 15
                    }
                    Image {
                        id: unityselected
                        x: -46
                        y: 76
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
              }

                Rectangle {
                    width: 128
                    height: 150
                    color: "#f6f6f6"
                    Image {
                        id: deepinlogo
                        width: 96
                        height: 96
                        source: "qrc:/img/deepin-oobp.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            onClicked: gnomeselected.visible        = false
                            onClicked: cinnamondescselected.visible = false
                            onClicked: mateselected.visible         = false
                            onClicked: xfceselected.visible         = false
                            onClicked: unityselected.visible        = false
                            onClicked: deepinselected.visible       = true
                            onClicked: pantheonselected.visible     = false
                            onClicked: kdeselected.visible         = false
                            Core.setDesktopEnvironment("DEEPIN")
                        }
                    }
                }

                Rectangle {
                    width: 300
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: deepintitle
                        color: "#666666"
                        text: qsTr("<b>Deepin</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        width: 280
                        id: deepindesc
                        color: "#666666"
                        text: qsTr("Deepin Desktop Environment, ported from Deepin (Linux), a OSX like desktop environment with an elegant dock.")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        font.pixelSize: 15
                    }
                    Image {
                        id: deepinselected
                        x: -46
                        y: 76
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
              }

                Rectangle {
                    width: 128
                    height: 150
                    color: "#f6f6f6"
                    Image {
                        id: pantheonlogo
                        width: 96
                        height: 96
                        source: "qrc:/img/pantheon-oobp.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            onClicked: gnomeselected.visible        = false
                            onClicked: cinnamondescselected.visible = false
                            onClicked: mateselected.visible         = false
                            onClicked: xfceselected.visible         = false
                            onClicked: unityselected.visible        = false
                            onClicked: deepinselected.visible       = false
                            onClicked: pantheonselected.visible     = true
                            onClicked: kdeselected.visible         = false
                            Core.setDesktopEnvironment("PANTHEON")
                        }
                    }
                }

                Rectangle {
                    width: 300
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: pantheontitle
                        color: "#666666"
                        text: qsTr("<b>Pantheon</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        width: 280
                        id: pantheondesc
                        color: "#666666"
                        text: qsTr("Pantheon, a fast and simplistic desktop environment ported from Elementary OS (Linux).")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        font.pixelSize: 15
                    }
                    Image {
                        id: pantheonselected
                        x: -46
                        y: 76
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
              }

                Rectangle {
                    width: 128
                    height: 150
                    color: "#f6f6f6"
                    Image {
                        id: kdelogo
                        width: 96
                        height: 96
                        source: "qrc:/img/kde-oobp.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            onClicked: gnomeselected.visible        = false
                            onClicked: cinnamondescselected.visible = false
                            onClicked: mateselected.visible         = false
                            onClicked: xfceselected.visible         = false
                            onClicked: unityselected.visible        = false
                            onClicked: deepinselected.visible       = false
                            onClicked: pantheonselected.visible     = false
                            onClicked: kdeselected.visible         = true
                            Core.setDesktopEnvironment("KDE")
                        }
                    }
                }

                Rectangle {
                    width: 300
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: kdetitle
                        color: "#666666"
                        text: qsTr("<b>Plasma</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        width: 280
                        id: kdedesc
                        color: "#666666"
                        text: qsTr("Plasma desktop (KDE) is a full desktop suite with beautiful visual effects.")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        font.pixelSize: 15
                    }
                    Image {
                        id: kdeselected
                        x: -46
                        y: 76
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
              }
            }

            Text {
                id: stop3
                x: 56
                y: 1780
                width: 870
                height: 40
                color: "#666666"
                text: qsTr("<b>Stop III. Optional Features")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 32
            }

            Text {
                id: stop3text
                x: 56
                y: 1835
                width: 870
                height: 40
                color: "#666666"
                text: qsTr("AOSC OS tries to include best softwares with the system release, but sadly with some limitations like licensing for
                                        redistribution and instalation sizes, we were not able to include some great softwares with our AOSC OS releases.
                                        But with help from the Internet, you will be able to install them from our repository, and here below is some of the best
                                        ones we were to offer.")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 15
            }

            Grid {
                x: 56
                y: 1950
                columns: 4
                spacing: 2

                Rectangle {
                    width: 128
                    height: 150
                    color: "#f6f6f6"
                    Image {
                        id: aoscartworklogo
                        width: 96
                        height: 96
                        source: "qrc:/img/OptLogo_Artwork.png"
                    }
                }

                Rectangle {
                    width: 300
                    height: 150
                    color: "#f6f6f6"
                    Text {
                        id: aoscartworktitle
                        color: "#666666"
                        text: qsTr("<b>Artwork</b>")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 24
                    }
                    Text {
                        y: 34
                        width: 280
                        id: aoscartworkdesc
                        color: "#666666"
                        text: qsTr("Beautiful wallpapers from our friends inside and outside of AOSC.")
                        font.family: "Sans"
                        wrapMode: Text.WordWrap
                        textFormat: Text.RichText
                        font.pixelSize: 15
                    }
                    Image {
                        id: aoscartworkselected
                        x: -46
                        y: 76
                        width: 24
                        height: 24
                        visible: false
                        source: "qrc:/img/Progress_Checked.png"
                    }
                }

            Rectangle {
                width: 128
                height: 150
                color: "#f6f6f6"
                Image {
                    id: chromelogo
                    width: 96
                    height: 96
                    antialiasing: true
                    source: "qrc:/img/OptLogo_GoogleChrome.png"
                }
           }


            Rectangle {
                width: 300
                height: 150
                color: "#f6f6f6"
                Text {
                    id: chrometitle
                    color: "#666666"
                    text: qsTr("<b>Google Chrome</b>")
                    font.family: "Sans"
                    textFormat: Text.RichText
                    font.pixelSize: 24
                }
                Text {
                    y: 34
                    width: 280
                    id: chromedesc
                    color: "#666666"
                    text: qsTr("Google Chrome is a fast browser from Google,due to proprietary components included, we are not able to preinstall it.")
                    font.family: "Sans"
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                }
                Image {
                    id: chromeselected
                    x: -46
                    y: 76
                    width: 24
                    height: 24
                    visible: false
                    source: "qrc:/img/Progress_Checked.png"
                }
          }

            Rectangle {
                width: 128
                height: 150
                color: "#f6f6f6"
                Image {
                    id: imlogo
                    width: 96
                    height: 96
                    antialiasing: true
                    source: "qrc:/img/OptLogo_InputMethod.png"
                }
           }


            Rectangle {
                width: 300
                height: 150
                color: "#f6f6f6"
                Text {
                    id: imtitle
                    color: "#666666"
                    text: qsTr("<b>Input Method</b>")
                    font.family: "Sans"
                    textFormat: Text.RichText
                    font.pixelSize: 24
                }
                Text {
                    y: 34
                    width: 280
                    id: imdesc
                    color: "#666666"
                    text: qsTr("Input method for complex language input like Chinese and Japanese.")
                    font.family: "Sans"
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                }
                Image {
                    id: imselected
                    x: -46
                    y: 76
                    width: 24
                    height: 24
                    visible: false
                    source: "qrc:/img/Progress_Checked.png"
                }
          }

            Rectangle {
                width: 128
                height: 150
                color: "#f6f6f6"
                Image {
                    // Hacks used. Too lazy to fix the image.
                    id: libologo
                    x: 5
                    width: 85
                    height: 96
                    antialiasing: true
                    source: "qrc:/img/OptLogo_LibO.png"
                }
           }


            Rectangle {
                width: 300
                height: 150
                color: "#f6f6f6"
                Text {
                    id: libotitle
                    color: "#666666"
                    text: qsTr("<b>LibreOffice</b>")
                    font.family: "Sans"
                    textFormat: Text.RichText
                    font.pixelSize: 24
                }
                Text {
                    y: 34
                    width: 280
                    id: libodesc
                    color: "#666666"
                    text: qsTr("LibreOffice is a FOSS productivitiy suite that is generally compatible with Microsoft Office.")
                    font.family: "Sans"
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                }
                Image {
                    id: liboselected
                    x: -46
                    y: 76
                    width: 24
                    height: 24
                    visible: false
                    source: "qrc:/img/Progress_Checked.png"
                }
          }

            Rectangle {
                width: 128
                height: 150
                color: "#f6f6f6"
                Image {
                    id: winelogo
                    width: 96
                    height: 96
                    antialiasing: true
                    source: "qrc:/img/OptLogo_Wine.png"
                }
           }

            Rectangle {
                width: 300
                height: 150
                color: "#f6f6f6"
                Text {
                    id: winetitle
                    color: "#666666"
                    text: qsTr("<b>Wine</b>")
                    font.family: "Sans"
                    textFormat: Text.RichText
                    font.pixelSize: 24
                }
                Text {
                    y: 34
                    width: 280
                    id: winedesc
                    color: "#666666"
                    text: qsTr("Wine is a compatibility layer/translator for running Windows applications under UNIX operating systems.")
                    font.family: "Sans"
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                }
                Image {
                    id: wineselected
                    x: -46
                    y: 76
                    width: 24
                    height: 24
                    visible: false
                    source: "qrc:/img/Progress_Checked.png"
                }
          }
      }

            Text {
                id: stop4
                x: 56
                y: 2425
                width: 870
                height: 40
                color: "#666666"
                text: qsTr("<b>Stop IV. Target Customization")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 32
            }

            Text {
                id: stop4text
                x: 56
                y: 2475
                width: 870
                height: 40
                color: "#666666"
                text: qsTr("In here below you are to choose the target partition and file system of the installation, and user information. Please
                                        double check before you confirm the installation.")
                font.family: "Sans"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: 15
            }


/*            Grid {
                x: 56
                y: 1800
                columns: 4
                spacing: 2
                Rectangle{
                    width: 300
                    height: 200
                    color: "red"
                    Text{
                        y: 33
                        id: launchGpartedText
                        text: qsTr("点我打开gparted XD")
                        font.family: "Sans"
                        textFormat: Text.RichText
                        font.pixelSize: 15
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            Core.launchGparted()
                        }
                    }
                }
            } */

        }
    }

}
