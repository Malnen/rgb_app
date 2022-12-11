#pragma once

extern "C" {
	__declspec(dllexport) void registerUsbConnectedCallback(void (*callback)());
	__declspec(dllexport) void registerUsbDisconnectedCallback(void (*callback)());
	__declspec(dllexport) void startListening();
}