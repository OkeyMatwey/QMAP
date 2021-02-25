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

    Universal.theme: Universal.Dark
    Universal.accent: Universal.Dark

    Component {
        id: imageDelegate
        MapQuickItem {
            coordinate: QtPositioning.coordinate(latitude, longitude)
            zoomLevel: 15

            sourceItem: Image {
                fillMode: Image.Pad
                source: path
            }
        }
    }

    ListModel {
        id: imageModel
        ListElement { latitude: 56.639545; longitude: 47.890209; path: "file:d:/tiff_shevtsovo/rus_69_shevtsovo_X_n_F1_1_rli.tif"}
    }

    Connections {
        target: b
        onSendToQmlpoint: {
            mappolyline.addCoordinate(QtPositioning.coordinate(x, y))
        }
        onSendToQmlimg: {
            imageModel.append({ latitude: x, longitude: y, path: path})
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

        MapItemView {
            id: items
            model: imageModel
            delegate: imageDelegate
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

            Slider {
                id: slider
                width: 64
                value: 100
                to: 100
                onMoved: items.opacity = slider.value / 100
            }
        }
    }
}

