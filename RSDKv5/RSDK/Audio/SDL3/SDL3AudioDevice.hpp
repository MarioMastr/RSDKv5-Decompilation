#include "../Audio.hpp"

#ifndef SDL3_AUDIO_DEVICE_H
#define SDL3_AUDIO_DEVICE_H

#define LockAudioDevice() SDL_LockAudioStream(AudioDevice::stream)
#define UnlockAudioDevice() SDL_UnlockAudioStream(AudioDevice::stream)

namespace RSDK
{
class AudioDevice : public AudioDeviceBase
{
public:
    static SDL_AudioDeviceID device;
    static SDL_AudioStream *stream;

    static bool32 Init();
    static void Release();

    static void ProcessAudioMixing(SDL_AudioStream *stream, int32 length, uint8 *destBuffer);

    static void LoadSfxToSlot(char *filename, uint8 slot, uint8 plays, uint8 scope);

    static void FrameInit() {}

    inline static void HandleStreamLoad(ChannelInfo *channel, bool32 async)
    {
        if (async)
            SDL_CreateThread((SDL_ThreadFunction)LoadStream, "LoadStream", (void *)channel);
        else
            LoadStream(channel);
    }

private:
    static SDL_AudioSpec deviceSpec;

    static uint8 contextInitialized;

    static void SDLCALL AudioCallback(void *data, SDL_AudioStream *stream, int32 len, int32 another_one);
};
} // namespace RSDK

#endif