#include "SDL3AudioDevice.hpp"

using namespace RSDK;

uint8 AudioDevice::contextInitialized;

SDL_AudioDeviceID AudioDevice::device;
SDL_AudioSpec AudioDevice::deviceSpec;
SDL_AudioStream AudioDevice::stream;

bool32 AudioDevice::Init()
{
    SDL_InitSubSystem(SDL_INIT_AUDIO);
    if (!contextInitialized) {
        contextInitialized = true;
        InitAudioChannels();
    }

    SDL_AudioSpec want = {SDL_AUDIO_F32, AUDIO_CHANNELS, AUDIO_FREQUENCY};

    audioState = false;
    stream = SDL_OpenAudioDeviceStream(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &want, AudioCallback, NULL);
    device = SDL_GetAudioStreamDevice(stream);
    if (device) {
        SDL_ResumeAudioDevice(device);
        audioState = true;
    }
    else {
        PrintLog(PRINT_NORMAL, "ERROR: Unable to open audio device!");
        PrintLog(PRINT_NORMAL, "ERROR: %s", SDL_GetError());
    }

    return true;
}

void AudioDevice::Release()
{
    SDL_PauseAudioDevice(device);

    LockAudioDevice();
    AudioDeviceBase::Release();
    UnlockAudioDevice();

    SDL_CloseAudioDevice(device);
    SDL_QuitSubSystem(SDL_INIT_AUDIO);
}

void AudioDevice::InitAudioChannels()
{
    AudioDeviceBase::InitAudioChannels();
}

void AudioDevice::AudioCallback(void *data, SDL_AudioStream *stream, int32 len, int32 another_one)
{
    (void)data; // Unused

    AudioDevice::ProcessAudioMixing(stream, len / sizeof(SAMPLE_FORMAT));
}
