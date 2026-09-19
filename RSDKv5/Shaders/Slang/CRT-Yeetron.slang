#include "Common.slang"

static const float RSDK_PI = 3.14159;
static const float viewSizeHD = 720.0;
static const float3 intensity = float3(1.1, 0.9, 0.9);

float4 PSMain(PixelInput input) : SV_Target
{
    float2 viewPos = floor((textureSize / pixelSize) * input.tex.xy * viewSize) + 0.5;
    float intensityPos = frac((viewPos.y * 3.0 + viewPos.x) * 0.166667);

    float4 scanlineIntensity;
    if (intensityPos < 0.333)
        scanlineIntensity.rgb = intensity;
    else if (intensityPos < 0.666)
        scanlineIntensity.rgb = intensity.zxy;
    else
        scanlineIntensity.rgb = intensity.yzx;

    float2 pixelPos = input.tex.xy * textureSize;
    float2 roundedPixelPos = floor(pixelPos);

    scanlineIntensity.a = clamp(abs(sin(pixelPos.y * RSDK_PI)) + 0.25, 0.5, 1.0);
    pixelPos = frac(pixelPos) - 0.5;

    float2 invTexPos = -input.tex.xy * textureSize + (roundedPixelPos + 0.5);

    float2 newTexPos;
    newTexPos.x = clamp(-abs(invTexPos.x * 0.5) + 1.5, 0.8, 1.25);
    newTexPos.y = clamp(-abs(invTexPos.y * 2.0) + 1.25, 0.5, 1.0);

    float2 colorMod;
    colorMod.x = newTexPos.x * newTexPos.y;
    colorMod.y = newTexPos.x * ((scanlineIntensity.a + newTexPos.y) * 0.5);

    scanlineIntensity.a *= newTexPos.x;

    float2 texPos = ((pixelPos - clamp(pixelPos, -0.25, 0.25)) * 2.0 + roundedPixelPos + 0.5) / textureSize;
    float4 texColor = SampleDiffuse(texPos);

    float3 blendedColor;
    blendedColor.r = scanlineIntensity.a * texColor.r;
    blendedColor.gb = colorMod * texColor.gb;

    float4 outColor;
    outColor.rgb = viewSize.y >= viewSizeHD ? scanlineIntensity.rgb * blendedColor : blendedColor;
    outColor.a = texColor.a;
    return ApplyScreenDim(outColor);
}
