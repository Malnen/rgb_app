#pragma once

extern "C" {
	__declspec(dllexport) void registerUsbConnectedCallback(void (*callback)());
}