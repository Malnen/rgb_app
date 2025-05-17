//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_nsd/flutter_nsd_plugin.h>
#include <keyboard_event/keyboard_event_plugin.h>
#include <screen_retriever_windows/screen_retriever_windows_plugin_c_api.h>
#include <system_tray/system_tray_plugin.h>
#include <window_manager/window_manager_plugin.h>
#include <windows_single_instance/windows_single_instance_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
    FlutterNsdPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("FlutterNsdPlugin"));
  KeyboardEventPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("KeyboardEventPlugin"));
    ScreenRetrieverWindowsPluginCApiRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("ScreenRetrieverWindowsPluginCApi"));
  SystemTrayPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemTrayPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
  WindowsSingleInstancePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowsSingleInstancePlugin"));
}
