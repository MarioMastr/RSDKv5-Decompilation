#include "../Input.hpp"

#ifndef SDL3_INPUT_DEVICE_H
#define SDL3_INPUT_DEVICE_H

namespace SKU
{

struct InputDeviceSDL : RSDK::InputDevice {
    void UpdateInput();
    void ProcessInput(int32 controllerID);
    void CloseDevice();

    int32 buttonMasks;
    int32 prevButtonMasks;
    uint8 stateUp;
    uint8 stateDown;
    uint8 stateLeft;
    uint8 stateRight;
    uint8 stateA;
    uint8 stateB;
    uint8 stateC;
    uint8 stateX;
    uint8 stateY;
    uint8 stateZ;
    uint8 stateStart;
    uint8 stateSelect;
    uint8 stateBumper_L;
    uint8 stateBumper_R;
    uint8 stateStick_L;
    uint8 stateStick_R;
    float bumperDeltaL;
    float bumperDeltaR;
    float triggerDeltaL;
    float triggerDeltaR;
    float hDelta_L;
    float vDelta_L;
    float vDelta_R;
    float hDelta_R;

    SDL_Gamepad *controllerPtr;
    bool32 swapABXY;
};

InputDeviceSDL *InitSDL3InputDevice(uint32 id, SDL_Gamepad *game_controller);

void InitSDL3InputAPI();
void ReleaseSDL3InputAPI();

} // namespace SKU

#endif // SDL2_INPUT_DEVICE_H