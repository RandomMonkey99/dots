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
        id: "bar"
        top: true
            bottom: true
            left: true
            right: true
    }
}