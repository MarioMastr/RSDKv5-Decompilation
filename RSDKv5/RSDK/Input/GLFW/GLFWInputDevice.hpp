#pragma once

#include <RSDK/Core/RetroEngine.hpp>

namespace SKU
{

struct InputDeviceGLFW : RSDK::InputDevice {
    void UpdateInput();
    void ProcessInput(int32 controllerID);
    void CloseDevice();

    uint32 currentState;
    GLFWgamepadstate states[2];
    uint32 jid;

    bool32 swapABXY;
};

InputDeviceGLFW *InitGLFWInputDevice(uint32 id, uint8 controllerID);
void InitGLFWInputAPI();

} // namespace SKU