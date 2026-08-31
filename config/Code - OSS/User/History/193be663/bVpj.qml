import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets

ShellRoot {
    PanelWindow {
        id: "bar"
        height: 30
        color: '#47ffffff'
        WlrLayershell.layer: WlrLayer.Overlay
        anchors {
            top: true
            left: true
            right: true
        }
    }
}