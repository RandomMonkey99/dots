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
        
        exclusionMode: Ignore
        Image {
            source: "file:///home/rm99/.config/wallpaper/wall"
            anchors.fill: parent
            fillMode: Image.Stretch
        }
    }

    PanelWindow {
        id: "bar"
        height: 30
        color: '#47ffff34'
        anchors {
            top: true
            left: true
            right: true
        }
    }
}