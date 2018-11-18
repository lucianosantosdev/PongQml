import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Pong")

    Loader {
        id: _loader
        focus: true
        anchors.fill: parent
        anchors.centerIn: parent
        source: "Pong.qml"
        objectName: "loader"
    }
}
