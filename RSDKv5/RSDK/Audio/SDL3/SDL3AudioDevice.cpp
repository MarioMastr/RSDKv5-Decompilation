#include "SDL3AudioDevice.hpp"

using namespace RSDK;

uint8 AudioDevice::contextInitialized;

SDL_AudioDeviceID AudioDevice::device;
SDL_AudioStream *AudioDevice::stream;
SDL_AudioSpec AudioDevice::deviceSpec;

bool32 AudioDevice::Init()
{
    SDL_InitSubSystem(SDL_INIT_AUDIO);
    if (!contextInitialized) {
        contextInitialized = true;
        AudioDeviceBase::InitAudioChannels();
    }

    deviceSpec = { SDL_AUDIO_F32, AUDIO_CHANNELS, AUDIO_FREQUENCY };

    audioState = false;
    stream     = SDL_OpenAudioDeviceStream(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &deviceSpec, AudioCallback, NULL);
    device     = SDL_GetAudioStreamDevice(stream);
    if (device > 0) {
        audioState = true;
        SDL_ResumeAudioDevice(device);
        PrintLog(PRINT_NORMAL, "Opened audio device: %d", device);
    }
    else {
        PrintLog(PRINT_NORMAL, "ERROR: Unable to open audio device!");
        PrintLog(PRINT_NORMAL, "ERROR: %s", SDL_GetError());
        return false;
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

void AudioDevice::LoadSfxToSlot(char *filename, uint8 slot, uint8 plays, uint8 scope)
{
    FileInfo info;
    InitFileInfo(&info);

    char fullFilePath[0x80];
    sprintf_s(fullFilePath, sizeof(fullFilePath), "Data/SoundFX/%s", filename);

    RETRO_HASH_MD5(hash);
    GEN_HASH_MD5(filename, hash);

    char *path;
    SDL_AudioSpec spec;
    Uint8 *buf = NULL;
    Uint32 buflen = 0;

    if (SDL_LoadWAV(fullFilePath, &spec, &buf, &buflen)) {
        AllocateStorage((void **)&sfxList[slot].buffer, sizeof(float) * buflen, DATASET_SFX, false);
        sfxList[slot].length = buflen;
        *sfxList[slot].buffer += *(float *)buf;
    }
    else {
        PrintLog(PRINT_NORMAL, "ERROR: Unable to load wav file: %s", filename);
        PrintLog(PRINT_NORMAL, "ERROR: %s", SDL_GetError());
    }
}

void AudioDevice::ProcessAudioMixing(SDL_AudioStream *stream, int32 length, uint8 *destBuffer)
{
    for (int32 c = 0; c < CHANNEL_COUNT; ++c) {
        ChannelInfo *channel = &channels[c];

        switch (channel->state) {
            default:
            case CHANNEL_IDLE: break;

            case CHANNEL_SFX: {
                SAMPLE_FORMAT *sfxBuffer = &channel->samplePtr[channel->bufferPos];
                SDL_MixAudio(destBuffer, (uint8 *)sfxBuffer, deviceSpec.format, length, channel->volume);
            }
            case CHANNEL_STREAM: {
                SAMPLE_FORMAT *streamBuffer = &channel->samplePtr[channel->bufferPos];
                SDL_MixAudio(destBuffer, (uint8 *)streamBuffer, deviceSpec.format, length, channel->volume);
                break;
            }
            case CHANNEL_LOADING_STREAM: break;
        }
    }
}

void SDLCALL AudioDevice::AudioCallback(void *data, SDL_AudioStream *stream, int32 len, int32 another_one)
{
    (void)data; // unused
    stream = AudioDevice::stream;

    if (len > 0) {
        uint8 *buf = SDL_stack_alloc(uint8, len);
        if (buf) {
            AudioDevice::ProcessAudioMixing(stream, len, buf);
            memset(stream, 0, sizeof(len));
            SDL_PutAudioStreamData(stream, buf, len);
            SDL_stack_free(buf);
        }
    }
}
