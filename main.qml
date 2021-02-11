import QtQuick 2.15
import QtQuick.Window 2.15
import QtPositioning 5.12
import QtLocation 5.12
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtPositioning 5.2


Window {
    visible: true
    width: 640
    height: 480

    Connections {
            target: b
            onSendToQml: {
                mappolyline.addCoordinate(QtPositioning.coordinate(x, y))
            }
        }

    Plugin {
        id: spacePlugin
        name: "osm"
        PluginParameter {name: "osm.mapping.host"; value: "http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/"}
        PluginParameter {name: "osm.mapping.providersrepository.disabled"; value: true}
        PluginParameter {name: "osm.mapping.cache.directory"; value: "cache/"}
    }

    Plugin {
        id: plugin
        name: "osm"
        PluginParameter {name: "osm.mapping.host"; value: "http://a.tile.openstreetmap.org/"}
        PluginParameter {name: "osm.mapping.providersrepository.disabled"; value: true}
        PluginParameter {name: "osm.mapping.cache.directory"; value: "cache/"}
    }

    Map {
        id: map
        anchors.fill: parent
        zoomLevel: 10
        plugin: plugin
        activeMapType: supportedMapTypes[supportedMapTypes.length - 1]

        MapPolyline {
            id: mappolyline
            line.width: 3
            line.color: 'green'
        }

        Button {
            text: qsTr("Сlear")
            onClicked: mappolyline.path = []
        }
    }

}
