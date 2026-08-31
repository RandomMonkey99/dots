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
            right: true
        }
        implicitHeight: 30
        color: "#000000"
        Rectangle {
            anchors.fill: parent
            color: "#000000"
            border.color: "#ffffff"
            border.pixelAligned: true
            Rectangle {
                id: myButton
                width: 35
                height: 40
                MouseArea {
                    anchors.fill: parent
                    onClicked: command.running = true        
                }
                Image {
                    source: "file:///usr/share/endeavouros/EndeavourOS-icon.png"
                    width: 30
                    height: 30
                    anchors.centerIn: parent
                    anchors.margins: 10
                }
            }
        }
    }
}