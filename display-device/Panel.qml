import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services.UI
import qs.Widgets

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

          // Button to open plugin settings - demonstrates using panelOpenScreen
          NButton {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Style.marginL
            text: pluginApi?.tr("panel.open-settings") || "Open Plugin Settings"
            icon: "settings"

            onClicked: {
              // Use panelOpenScreen to get the screen this panel is on
              var screen = pluginApi?.panelOpenScreen;
              if (screen && pluginApi?.manifest) {
                Logger.i("DisplayDevice", "Opening plugin settings on screen:", screen.name);
                BarService.openPluginSettings(screen, pluginApi.manifest);
              }
            }
          }
        }
      }
    }
  }
}
