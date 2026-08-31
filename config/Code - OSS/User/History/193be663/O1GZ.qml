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

        WlrLayershell.layer: WlrLayer.Bottom
        
        
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
    implicitHeight: 40
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: "#801a1b26" // Translucent fill for xray focus
        border.color: "#330db9d7"
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: "Xray Panel"
            color: "#0db9d7"
        }
    }
}

}