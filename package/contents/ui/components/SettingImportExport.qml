import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

RowLayout {

    signal importConfirmed()
    signal exportConfirmed()
    property bool exporting: false
    Layout.alignment: Qt.AlignHCenter
    Button {
        icon.name: "document-import-symbolic"
        text: i18n("Import")
        onClicked: {
            exporting = false
            importEportDialog.open()
        }
    }
    Button {
        icon.name: "document-export-symbolic"
        text: i18n("Export")
        onClicked: {
            exporting = true
            importEportDialog.open()
        }
    }
    Button {
        icon.name: "dialog-information-symbolic"
        ToolTip.text: i18n("Export these settings to the default configuration folder and import them in other instances of Panel Colorizer")
        highlighted: true
        hoverEnabled: true
        ToolTip.visible: hovered
        Kirigami.Theme.inherit: false
        flat: true
    }

    Kirigami.PromptDialog {
        id: importEportDialog
        title: exporting ? i18n("Export current settings?") : i18n("Import saved settings?")
        subtitle: exporting
            ? i18n("This will overwrite any previous export!")
            : i18n("This will replace your current settings")

        standardButtons: Kirigami.Dialog.Ok | Kirigami.Dialog.Cancel
        onAccepted: {
            if (exporting) {
                exportConfirmed()
            } else {
                importConfirmed()
            }

        }
    }
}