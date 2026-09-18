#include "RSDKShader.slang"

float4 PSMain(PixelInput input) : SV_Target
{
    float2 texel = input.tex.xy * textureSize;
    float2 texelFloored = floor(texel);
    float2 s = frac(texel);
    float2 regionRange = 0.5 - 0.5 / 2.0;
    float2 centerDist = s - 0.5;
    float2 f = (centerDist - clamp(centerDist, -regionRange, regionRange)) * 2.0 + 0.5;
    float2 modTexel = texelFloored + f;

    return ApplyScreenDim(SampleDiffuse(modTexel / textureSize));
}
