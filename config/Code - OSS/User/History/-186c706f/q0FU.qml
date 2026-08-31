import QtQuick
import QtQuick.Controls
import Quickshell
    
Rectangle {
    id: launcher
    width: 500
    height: 600
    color: "#1e1e2e"
    radius: 12
    visible: false
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
                    modelData.name.toLowerCase()
                        .includes(search.text.toLowerCase())

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

                        onClicked: modelData.execute()
                    }
                }
            }
        }
    }
}
