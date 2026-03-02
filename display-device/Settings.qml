import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  property var pluginApi: null

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  property string valueMessage: cfg.message ?? defaults.message
  property string valueIconColor: cfg.iconColor ?? defaults.iconColor

  spacing: Style.marginL

  Component.onCompleted: {
    Logger.d("DisplayDevice", "Settings UI loaded");
  }

  ColumnLayout {
    spacing: Style.marginM
    Layout.fillWidth: true
  }

  function saveSettings() {
    if (!pluginApi) {
      Logger.e("DisplayDevice", "Cannot save settings: pluginApi is null");
      return;
    }

    pluginApi.saveSettings();

    Logger.d("DisplayDevice", "Settings saved successfully");
  }
}
