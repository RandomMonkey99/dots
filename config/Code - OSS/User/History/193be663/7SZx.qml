import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets

ShellRoot {

    PanelWindow {
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        WlrLayershell.layer: WlrLayer.Background

        Image {
            source: "file:///home/rm99/.config/wallpaper/wall"
            anchors.fill: parent
            fillMode: Image.Stretch
        }
    }

    PanelWindow {
        anchors {
            top: true
            left: true
            bottom: true
        }

        implicitWidth: 30
        color: "#000000"

        Rectangle {
            anchors.fill: parent
            color: "#000000"
            border.pixelAligned: true

            Rectangle {
                id: apps
                width: 30
                height: 30
                color: "#000000"
                border.color: "#ffffff"

                MouseArea {
                    anchors.fill: parent
                    onClicked: launcher.visible = !launcher.visible
                }

                Image {
                    source: "file:///usr/share/endeavouros/EndeavourOS-icon.png"
                    anchors.fill: parent
                    anchors.margins: 3
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }
}