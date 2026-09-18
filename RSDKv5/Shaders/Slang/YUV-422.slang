#include "RSDKShader.slang"

float4 PSMain(PixelInput input) : SV_Target
{
    float3 yuv;
    yuv.r = SampleDiffuse(input.tex.xy).r;
    yuv.gb = SampleDiffuse(float2(clamp(input.tex.x / 2.0, 0.0, 0.499), input.tex.y)).gb;
    yuv -= float3(16.0 / 256.0, 0.5, 0.5);

    float4 outColor;
    outColor.r = 1.164 * yuv.r + 1.596 * yuv.b;
    outColor.g = 1.164 * yuv.r - 0.392 * yuv.g - 0.813 * yuv.b;
    outColor.b = 1.164 * yuv.r + 2.017 * yuv.g;
    outColor.a = 1.0;
    return ApplyScreenDim(outColor);
}
