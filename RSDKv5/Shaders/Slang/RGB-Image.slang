#include "RSDKShader.slang"

float4 PSMain(PixelInput input) : SV_Target
{
    return ApplyScreenDim(SampleDiffuse(input.tex.xy));
}
