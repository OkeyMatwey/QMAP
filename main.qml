import QtQuick 2.15
import QtPositioning 5.12
import QtLocation 5.12
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12
import QtQuick.Dialogs 1.2
import QtWebView 1.1
import QtQuick.Layouts 1.15
import "jsfile.js" as JS

ApplicationWindow {
    id: win
    visible: true
    width: 640
    height: 480

    Universal.theme: Universal.Brown
    Universal.accent: Universal.Dark

    property var latitude_metr: QtPositioning.coordinate(90, 0).distanceTo(
                                    QtPositioning.coordinate(89, 0))

    Dialog {
        id: prototypeDialog
        title: "Характеристик самолета и луча"
        width: 400

        contentItem: GridLayout {
            anchors.fill: parent
            columns: 2
            anchors.margins: 10

            Label {
                text: "Характеристики самолета:"
            }
            Label {}
            Label {
                text: "Высота (м.)"
            }
            TextField {
                id: property_height
                Layout.fillWidth: true
                validator: IntValidator {}
                text: "600"
            }
            Label {
                text: "Скорость (м/с)"
            }
            TextField {
                id: property_plane_velocity
                Layout.fillWidth: true
                validator: IntValidator {}
            }

            Label {
                text: "Угол от надира(°)"
            }
            TextField {
                id: property_angle_nadir
                Layout.fillWidth: true
                validator: IntValidator {}
                text: "30"
            }

            Label {
                text: "Характеристики луча:"
            }
            Label {}

            Label {
                text: "Азимут(°)"
            }
            TextField {
                id: alpha
                Layout.fillWidth: true
                validator: IntValidator {}
                text: "30"
            }

            Label {
                text: "Угол места(°)"
            }
            TextField {
                id: beta
                Layout.fillWidth: true
                validator: IntValidator {}
                text: "30"
            }

            Label {
                text: "Период(сек.)"
            }
            TextField {
                id: frequency
                Layout.fillWidth: true
                validator: IntValidator {}
            }
            Label {}
        }

        //            Label {
        //                text: "Формат координат:"
        //            }
        //            ComboBox {
        //                model: ["Десятичные градусы", "Градусы, минуты, секунды"]
        //                width: parent.width
        //            }
        //            Label {
        //                id: coordinatyLable
        //                text: "Координаты пути:"
        //            }
        //            ScrollView {
        //                id: view
        //                width: parent.width
        //                height: 128
        //                TextArea {
        //                }
        //            }
    }

    property var mod_prototype: false

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
        ListElement {
            latitude: 56.639545
            longitude: 47.890209
            path: "file:d:/tiff_shevtsovo/rus_69_shevtsovo_X_n_F1_1_rli.tif"
        }
    }

    Component {
        id: prototypeDelegate
        MapCircle {
            center {
                latitude: latitude
                longitude: longitude
            }
            radius: 5.0
            color: 'white'
        }
    }
    ListModel {
        id: prototypeModel
    }
    // Делегат прототипа прямоугольника сьемки с самолета
    Component {
        id: rectangleDelegate
        MapPolyline {
            line.width: 3
            line.color: 'green'
            path: [{
                    "latitude": y1,
                    "longitude": x1
                }, {
                    "latitude": y2,
                    "longitude": x2
                }, {
                    "latitude": y4,
                    "longitude": x4
                }, {
                    "latitude": y3,
                    "longitude": x3
                },{
                    "latitude": y1,
                    "longitude": x1
                }]
        }
    }
    ListModel {
        id: rectangleModel
    }

    Connections {
        target: b
        onSendToQmlpoint: {
            trackPolyline.addCoordinate(QtPositioning.coordinate(x, y))
        }
        onSendToQmlimg: {
            imageModel.append({
                                  "latitude": x,
                                  "longitude": y,
                                  "path": path
                              })
        }
    }

    Plugin {
        id: plugin
        name: "osm"
        PluginParameter {
            name: "osm.mapping.host"
            value: "http://127.0.0.1:5000/Google_Sat_RU_SD/"
        }
        PluginParameter {
            name: "osm.mapping.providersrepository.disabled"
            value: true
        }
        PluginParameter {
            name: "osm.mapping.cache.directory"
            value: "cache/"
        }
    }

    Map {
        id: map
        anchors.fill: parent
        center: QtPositioning.coordinate(56.639545, 47.890209)
        zoomLevel: 10
        plugin: plugin
        activeMapType: supportedMapTypes[supportedMapTypes.length - 1]

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (mod_prototype) {
                    var map_coordinate = map.toCoordinate(Qt.point(mouse.x,
                                                                   mouse.y))
                    prototypeModel.append({
                                              "latitude": map_coordinate.latitude,
                                              "longitude": map_coordinate.longitude
                                          })
                    trackPrototype.addCoordinate(map_coordinate)
                }
            }
            property var add: false
            onPositionChanged: {
                if (add) {
                    trackPrototype.removeCoordinate(
                                trackPrototype.pathLength() - 1)
                    add = false
                }
                if (mod_prototype && trackPrototype.pathLength() > 0) {
                    var map_coordinate = map.toCoordinate(Qt.point(mouse.x,
                                                                   mouse.y))
                    trackPrototype.addCoordinate(map_coordinate)
                    add = true
                }
            }
            onExited: {
                if (mod_prototype && trackPrototype.pathLength() > 0) {
                    trackPrototype.removeCoordinate(
                                trackPrototype.pathLength() - 1)
                    add = false
                }
            }
        }

        MenuBar {
            Menu {
                title: "Трек"
                width: 128
                MenuItem {
                    Slider {
                        id: trackOpacity
                        width: 128
                        value: 100
                        to: 100
                        onMoved: trackPolyline.opacity = trackOpacity.value / 100
                    }
                }
                MenuItem {
                    text: "Удалить"
                    onClicked: trackPolyline.path = []
                }
            }
            Menu {
                title: "RLI"
                width: 128
                MenuItem {
                    Slider {
                        id: rliOpacity
                        width: 128
                        value: 100
                        to: 100
                        onMoved: items.opacity = rliOpacity.value / 100
                    }
                }
                MenuItem {
                    text: "Удалить"
                    onClicked: imageModel.clear()
                }
            }
            Menu {
                title: "Прототип"
                width: 128
                MenuItem {
                    Slider {
                        id: prototypeOpacity
                        width: 128
                        value: 100
                        to: 100
                        onMoved: prototype.opacity = prototypeOpacity.value / 100
                    }
                }
                MenuItem {
                    text: "Характеристики"
                    onClicked: prototypeDialog.open()
                }
                MenuItem {
                    text: "Задать точки"
                    onClicked: {
                        mod_prototype = true
                    }
                }
                MenuItem {
                    text: "Посчитать"
                    onClicked: {
                        rectangleModel.clear()

                        mod_prototype = false
                        for (var i = 1; i < trackPrototype.pathLength(); i++) {
                            var a = trackPrototype.path[i - 1]
                            var b = trackPrototype.path[i]
                            var katets = JS.calculateCoverage(
                                        property_height.text,
                                        property_angle_nadir.text, beta.text,
                                        a, b, latitude_metr)
                            console.log(katets)
                            rectangleModel.append({"x1":katets[1], "y1":katets[0],"x2":katets[3], "y2":katets[2],"x3":katets[5], "y3":katets[4],"x4":katets[7], "y4":katets[6]})
                        }
                    }
                }
                MenuItem {
                    text: "Удалить"
                    onClicked: {
                        trackPrototype.path = []
                        prototypeModel.clear()
                        rectangleModel.clear()
                    }
                }
            }
        }
        //Рисует rli картинки
        MapItemView {
            id: items
            model: imageModel
            delegate: imageDelegate
        }
        //Рисует точки прототипа трека полета самолета
        MapItemView {
            id: pointsPrototype
            model: prototypeModel
            delegate: prototypeDelegate
        }
        //Рисует прямые трека полета самолета
        MapPolyline {
            id: trackPolyline
            line.width: 3
            line.color: 'green'
        }
        //Рисует прямые прототипа трека полета самолета
        MapPolyline {
            id: trackPrototype
            line.width: 3
            line.color: 'white'
        }
        //Рисует прямоугольник прототипа сканирования с самолета
        MapItemView {
            id: rectanglePrototype
            model: rectangleModel
            delegate: rectangleDelegate
        }
    }
}
