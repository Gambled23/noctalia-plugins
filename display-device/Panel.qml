import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Commons
import qs.Services.UI
import qs.Widgets
import qs.Modules.MainScreen
import qs.Services.Media
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Widgets

// Panel Component
Item {
  id: root

  // Plugin API (injected by PluginPanelSlot)
  property var pluginApi: null

  // SmartPanel
  readonly property var geometryPlaceholder: panelContainer

  property real contentPreferredWidth: 440 * Style.uiScaleRatio
  property real contentPreferredHeight: 580 * Style.uiScaleRatio

  readonly property bool allowAttach: true
  // readonly property bool panelAnchorHorizontalCenter: true
  // readonly property bool panelAnchorVerticalCenter: true
  // readonly property bool panelAnchorTop: false
  // readonly property bool panelAnchorBottom: false
  // readonly property bool panelAnchorLeft: false
  // readonly property bool panelAnchorRight: false

  anchors.fill: parent

  Component.onCompleted: {
    if (pluginApi) {
      Logger.i("DisplayDevice", "Panel initialized");
    }
  }

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      anchors {
        fill: parent
        margins: Style.marginL
      }
      spacing: Style.marginL

      // Content area
      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Color.mSurfaceVariant
        radius: Style.radiusL

        ColumnLayout {
          anchors.centerIn: parent
          spacing: Style.marginL

          NText {
            Layout.alignment: Qt.AlignHCenter
            text: pluginApi?.pluginSettings?.message || pluginApi?.manifest?.metadata?.defaultSettings?.message || ""
            font.pointSize: Style.fontSizeXXL * Style.uiScaleRatio
            font.weight: Font.Bold
            color: Color.mPrimary
          }

          ButtonGroup {
            id: devices
          }

          NBox {
            Layout.fillWidth: true
            Layout.preferredHeight: outputColumn.implicitHeight + Style.margin2M

            ColumnLayout {
              id: outputColumn
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.top: parent.top
              anchors.margins: Style.marginM
              spacing: Style.marginS

              NText {
                text: 'Display Device'
                pointSize: Style.fontSizeL
                color: Color.mPrimary
              }

              NRadioButton {
                ButtonGroup.group: devices
                pointSize: Style.fontSizeS
                text: 'pc-gambled'
                checked: true
                Process {
                    id: ddPcGambled
                    command: "display-device -d pc-gambled"
                }
                onClicked: {
                  ddPcGambled.start()
                }
                Layout.fillWidth: true
                }
            }
          }
        }
      }
    }
  }
}
