//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <keyboard_event/keyboard_event_plugin.h>
#include <screen_retriever/screen_retriever_plugin.h>
#include <system_tray/system_tray_plugin.h>
#include <window_manager/window_manager_plugin.h>
#include <windows_single_instance/windows_single_instance_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  KeyboardEventPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("KeyboardEventPlugin"));
  ScreenRetrieverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverPlugin"));
  SystemTrayPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemTrayPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
  WindowsSingleInstancePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowsSingleInstancePlugin"));
}
