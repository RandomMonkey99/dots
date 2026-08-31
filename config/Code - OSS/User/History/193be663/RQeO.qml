import Quickshell // for PanelWindow
import QtQuick // for Text
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets

ShellRoot {
    Process {
        id: command
        command: ["rofi", "-show", "drun"]
}

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
            color: '#00000000'
            border.pixelAligned: true
            Rectangle {
                id: apps
                width: 30
                height: 30
                color: "#000000"
                border.color: "#ffffff"
                MouseArea {
                    anchors.fill: parent
                    onClicked: command.running = true        
                }
                Image {
                    source: "file:///usr/share/endeavouros/EndeavourOS-icon.png"
                    width: 30
                    height: 30
                    anchors.fill: parent
                    anchors.topMargin: 3
                    anchors.bottomMargin: 3
                    anchors.leftMargin: 3
                    anchors.rightMargin: 3
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }
}