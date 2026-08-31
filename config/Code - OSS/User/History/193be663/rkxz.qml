import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets

ShellRoot {

    PanelWindow {
        id: launcher
        width: 500
        height: 600
        visible: false

         onActiveChanged: {
        if (!active) {
            console.log("Focus lost");
            // optional: close launcher
            visible = false;
        }

        Rectangle {
            anchors.fill: parent
            color: "#1e1e2e"
            radius: 12

            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                TextField {
                    id: search
                    placeholderText: "Search..."
                }

                ListView {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 500

                    model: DesktopEntries.applications

                    delegate: Item {
                        required property DesktopEntry modelData

                        visible:
                            search.text === "" ||
                            modelData.name.toLowerCase().includes(search.text.toLowerCase())

                        width: ListView.view.width
                        height: visible ? 48 : 0

                        Rectangle {
                            anchors.fill: parent
                            color: mouse.containsMouse ? "#313244" : "transparent"

                            Row {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 12

                                Image {
                                    width: 24
                                    height: 24
                                    source: "image://icon/" + modelData.icon
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.name
                                    color: "white"
                                }
                            }

                            MouseArea {
                                id: mouse
                                anchors.fill: parent
                                onClicked:{ 
                                    modelData.execute();
                                    launcher.visible = false
                                }
                            }
                        }
                    }
                }
            }
        }
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