import QtQuick 2.15
import QtQuick.Window 2.15
import QtPositioning 5.12
import QtLocation 5.12

Window {
    visible: true
    width: 640
    height: 480

    Plugin {
      id: plugin
      name: "osm"

      PluginParameter {
               name: "osm.mapping.host";
               value: "http://a.tile.openstreetmap.org/"
           }
    }

        Map {
            id: map
            anchors.fill: parent
            zoomLevel: 10
            plugin: plugin
            activeMapType: map.supportedMapTypes[7]
        }
}
