import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.AbstractCard {
    id: root
    property var widget
    signal updateWidget(unifyBgType: int)
    checked: widget.unifyBgType !== 0

    contentItem: RowLayout {
        Kirigami.Icon {
            width: Kirigami.Units.gridUnit
            height: width
            source: widget.icon
        }
        ColumnLayout {
            RowLayout {
                Label {
                    text: widget.title
                }
                Rectangle {
                    visible: widget.inTray
                    color: Kirigami.Theme.highlightColor
                    Kirigami.Theme.colorSet: root.Kirigami.Theme["Selection"]
                    radius: parent.height / 2
                    width: label.width + 12
                    height: label.height + 2
                    Kirigami.Theme.inherit: false
                    Label {
                        anchors.centerIn: parent
                        id: label
                        text: i18n("System Tray")
                        color: Kirigami.Theme.textColor
                        Kirigami.Theme.colorSet: root.Kirigami.Theme["Selection"]
                        Kirigami.Theme.inherit: false
                    }
                }
            }
            TextEdit {
                text: widget.name
                opacity: 0.6
                readOnly: true
                color: Kirigami.Theme.textColor
                selectedTextColor: Kirigami.Theme.highlightedTextColor
                selectionColor: Kirigami.Theme.highlightColor
            }
        }
        Item {
            Layout.fillWidth: true
        }
        Button {
            text: i18n("D")
            checkable: true
            checked: widget?.unifyBgType === index
            icon.name: checked ? "checkmark-symbolic" : "dialog-close-symbolic"
            Layout.preferredWidth: 50
            property int index: 0
            ButtonGroup.group: unifyButtonGroup
            enabled: widget?.unifyBgType !== 0
        }
        Button {
            text: i18n("S")
            checkable: true
            checked: widget?.unifyBgType === index
            icon.name: checked ? "checkmark-symbolic" : "dialog-close-symbolic"
            Layout.preferredWidth: 50
            property int index: 1
            ButtonGroup.group: unifyButtonGroup
        }
        Button {
            text: i18n("E")
            checkable: true
            checked: widget?.unifyBgType === index
            icon.name: checked ? "checkmark-symbolic" : "dialog-close-symbolic"
            property int index: 2
            Layout.preferredWidth: 50
            ButtonGroup.group: unifyButtonGroup
        }
        ButtonGroup {
            id: unifyButtonGroup
            onCheckedButtonChanged: {
                if (checkedButton) {
                    widget.unifyBgType = checkedButton.index
                    updateWidget(widget.unifyBgType)
                }
            }
        }
    }
}