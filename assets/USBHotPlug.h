#pragma once

extern "C" {
	__declspec(dllexport) void registerUsbConnectionCallback(void (*callback)());
	__declspec(dllexport) void registerTestMessageCallback(void (*callback)(int message));
	__declspec(dllexport) void startListening(int hWnd);
}