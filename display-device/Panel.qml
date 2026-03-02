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

  // property real contentPreferredWidth: panelContainer. * Style.uiScaleRatio
  property real contentPreferredHeight: panelContainer.implicitHeight + Style.margin2L

  readonly property bool allowAttach: true
  // readonly property bool panelAnchorHorizontalCenter: true
  // readonly property bool panelAnchorVerticalCenter: true
  // readonly property bool panelAnchorTop: false
  // readonly property bool panelAnchorBottom: false
  // readonly property bool panelAnchorLeft: false
  // readonly property bool panelAnchorRight: false

  // anchors.fill: parent

  Component.onCompleted: {
    if (pluginApi) {
      Logger.i("DisplayDevice", "Panel initialized");
    }
  }

  Rectangle {
    id: panelContainer
    // anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      anchors {
        fill: parent
        margins: Style.marginL
      }
      spacing: Style.marginL

      NBox {
        Layout.fillWidth: true
        Layout.preferredHeight: contentLayout.implicitHeight + 2 * Style.marginM
        color: Color.mSurfaceVariant
        radius: Style.radiusL

        ColumnLayout {
          id: contentLayout
          anchors.fill: parent
          anchors.margins: Style.marginM
          spacing: Style.marginL
          // Process to get all display devices
          Process {
            id: listDevicesProcess
            command: ["sh", "-c", "display-device -a"]
            
            property string fullOutput: ""
            
            stdout: SplitParser {
              id: devicesParser
              onRead: function(data) {
                listDevicesProcess.fullOutput += data + "\n"
              }
            }
            
            onExited: function(exitCode, exitStatus) {
              if (exitCode === 0) {
                var lines = listDevicesProcess.fullOutput.trim().split('\n')
                devicesModel.clear()
                for (var i = 0; i < lines.length; i++) {
                  var line = lines[i].trim()
                  if (line && line !== "Display device script") {
                    devicesModel.append({deviceName: line})
                    Logger.i("DisplayDevice", "Added device: " + line)
                  }
                }
                Logger.i("DisplayDevice", "Total devices: " + devicesModel.count)
              }
            }
            
            running: true
          }

          // Model to store device names
          ListModel {
            id: devicesModel
          }

          // Process to switch devices
          Process {
            id: switchDeviceProcess
          }

          ButtonGroup {
            id: devices
          }

          NText {
            text: 'Display Device'
            pointSize: Style.fontSizeL
            color: Color.mPrimary
          }

          Repeater {
            model: devicesModel
            NRadioButton {
              ButtonGroup.group: devices
              pointSize: Style.fontSizeS
              text: deviceName
              checked: index === 0
              onClicked: {
                switchDeviceProcess.command = ["display-device", "-d", deviceName]
                switchDeviceProcess.startDetached()
              }
              Layout.fillWidth: true
            }
          }
        }
      }
    }
  }
}