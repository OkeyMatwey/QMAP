import QtQuick 2.15
import QtPositioning 5.12
import QtLocation 5.12
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12


ApplicationWindow {
    id: win
    visible: true
    width: 640
    height: 480

    Universal.theme: Universal.Cyan
    Universal.accent: Universal.Violet

    Connections {
        target: b
        onSendToQml: {
            mappolyline.addCoordinate(QtPositioning.coordinate(x, y))
        }
    }
    Plugin {
        id: plugin
        name: "osm"
        PluginParameter {name: "osm.mapping.host"; value: "http://127.0.0.1:5000/Google_Sat_RU_SD/"}
        PluginParameter {name: "osm.mapping.providersrepository.disabled"; value: true}
        PluginParameter {name: "osm.mapping.cache.directory"; value: "cache/"}
    }
    Map {
        id: map
        anchors.fill: parent
        center: QtPositioning.coordinate(56.639545, 47.890209)
        zoomLevel: 10
        plugin: plugin
        activeMapType: supportedMapTypes[supportedMapTypes.length - 1]

        MapPolyline {
            id: mappolyline
            line.width: 3
            line.color: 'green'
        }

        Row {
            id: column
            width: map.width
            height: 32

            Button {
                id: button_clear
                text: qsTr("Сlear")
                onClicked: mappolyline.path = []
                width: 64
                height: 32
            }

//            ComboBox {
//                id: comboBox
//                model: ["First", "Second", "Third"]
//            }
        }
    }
}
