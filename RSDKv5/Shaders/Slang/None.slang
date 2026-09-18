#include "RSDKShader.slang"

float4 PSMain(PixelInput input) : SV_Target
{
    float2 viewScale = frac((1.0 / pixelSize) * viewSize) - 0.01;

    if (viewScale.x < 0 && viewScale.y < 0)
        return ApplyScreenDim(SampleDiffuse(input.tex.xy));

    float2 adjacent;
    adjacent.x = abs(ddx(input.tex.x));
    adjacent.y = abs(ddy(input.tex.y));

    float4 texPos;
    texPos.zw = adjacent.yx * 0.500501 + input.tex.yx;
    texPos.xy = -adjacent.xy * 0.500501 + input.tex.xy;

    float2 texSize = 1.0 / textureSize.yx;
    float2 texCoord = clamp(texSize.xy * round(input.tex.yx / texSize.xy), texPos.yx, texPos.zw);

    float4 blendFactor;
    blendFactor.xy = -texPos.xy + texCoord.yx;
    blendFactor.zw = texPos.zw - texCoord.xy;

    float strength = adjacent.x * adjacent.y * 0.500501 * 2.002;
    float4 filteredColor =
        ((blendFactor.x * blendFactor.y) / strength) * SampleDiffuse(texPos.xy) +
        ((blendFactor.z * blendFactor.w) / strength) * SampleDiffuse(texPos.wz) +
        ((blendFactor.z * blendFactor.x) / strength) * SampleDiffuse(texPos.xz) +
        ((blendFactor.w * blendFactor.y) / strength) * SampleDiffuse(texPos.wy);

    return ApplyScreenDim(filteredColor);
}
