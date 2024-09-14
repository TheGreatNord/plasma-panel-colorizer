import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

// A component to create a list of color pickers
// color (hex) | ColorButton | randomize | move up | move down | delete | add new
// ...
// text field with colors | update list above

ColumnLayout {
    property var colorsList: []
    signal colorsChanged(newColors: var)
    property bool clearing: false

    ListModel {
        id: colorsListModel
    }

    Connections {
        target: colorsListModel
        onCountChanged: {
            if (clearing) return
            console.log("model count changed:", colorsListModel.count);
            updateColorsList()
        }
    }

    function initColorsListModel() {
        clearing = true
        colorsListModel.clear()
        const colors = colorsList
        for (let i in colors) {
            colorsListModel.append({"color": colors[i]})
        }
        clearing = false
    }

    function getRandomColor() {
        const h = Math.random()
        const s = Math.random()
        const l = Math.random()
        const a = 1.0
        console.log(h,s,l);
        return Qt.hsla(h,s,l,a)
    }

    function updateColorsList() {
        console.log("updateColorsList()");
        let colors_list = []
        for (let i = 0; i < colorsListModel.count; i++) {
            let c = colorsListModel.get(i).color
            console.log(c);
            colors_list.push(c)
        }
        colorsList = colors_list
        colorsChanged(colorsList)
    }

    Component.onCompleted: {
        initColorsListModel()
    }

    GroupBox {
        visible: listColorRadio.checked
        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Repeater {
                id: customColorsRepeater
                model: colorsListModel
                delegate : RowLayout {

                    TextMetrics {
                        id: metrics
                        text: (model.length + 1).toString()
                    }

                    Label {
                        text: (index + 1).toString() + "."
                        Layout.preferredWidth: metrics.width
                    }

                    TextMetrics {
                        id: colorMetrics
                        text: "#FFFFFF"
                    }

                    TextArea {
                        text: modelData
                        font.capitalization: Font.AllUppercase
                        Kirigami.SpellCheck.enabled: false
                        Layout.preferredWidth: colorMetrics.width * 1.4
                    }

                    ColorButton {
                        showAlphaChannel: false
                        dialogTitle: i18n("Widget background") + "("+index+")"
                        color: modelData
                        showCurentColor: false
                        onAccepted: (color) => {
                            colorsListModel.set(index, {"color": color.toString()})
                            updateColorsList()
                        }
                    }

                    Button {
                        icon.name: "randomize-symbolic"
                        onClicked: {
                            colorsListModel.set(index, {"color": getRandomColor().toString() })
                            updateColorsList()
                        }
                    }

                    Button {
                        icon.name: "arrow-up"
                        enabled: index>0
                        onClicked: {
                            let prevIndex = index-1
                            let prev = colorsListModel.get(prevIndex).color
                            colorsListModel.set(prevIndex, colorsListModel.get(index))
                            colorsListModel.set(index, {"color":prev})
                            updateColorsList()
                        }
                    }

                    Button {
                        icon.name: "arrow-down"
                        enabled: index < colorsListModel.count - 1
                        onClicked: {
                            let nextIndex = index+1
                            let next = colorsListModel.get(nextIndex).color
                            colorsListModel.set(nextIndex, colorsListModel.get(index))
                            colorsListModel.set(index, {"color":next})
                            updateColorsList()
                        }
                    }

                    Button {
                        icon.name: "edit-delete-remove"
                        onClicked: {
                            colorsListModel.remove(index)
                        }
                    }

                    Button {
                        icon.name: "list-add-symbolic"
                        onClicked: {
                            colorsListModel.insert(index+1, {"color": getRandomColor().toString() })
                        }
                    }
                }
            }

            RowLayout {
                visible: colorsListModel.count === 0
                Item {
                    Layout.fillWidth: true
                }
                Button {
                    icon.name: "list-add-symbolic"
                    onClicked: {
                        colorsListModel.insert(0, {"color": getRandomColor().toString() })
                    }
                }
            }

            RowLayout {
                TextArea {
                    id: customColors
                    text: colorsList?.join(" ") || []
                    onTextChanged: {
                        colorsList = text.split(" ")
                        colorsChanged(colorsList)
                    }
                    Layout.preferredWidth: 300
                    Layout.fillWidth: true
                    wrapMode: TextEdit.WordWrap
                    font.capitalization: Font.AllUppercase
                    Kirigami.SpellCheck.enabled: false
                }
                Button {
                    id: btn
                    icon.name: "view-refresh-symbolic"
                    onClicked: initColorsListModel()
                }
            }
        }
    }
}
