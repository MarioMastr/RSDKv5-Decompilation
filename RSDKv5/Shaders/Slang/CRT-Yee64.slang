#include "RSDKShader.slang"

static const float viewSizeHD = 720.0;
static const float3 intensity = float3(1.2, 0.9, 0.9);
static const float brightness = 1.25;

float4 PSMain(PixelInput input) : SV_Target
{
    float2 texelPos = (textureSize / pixelSize) * input.tex.xy;
    float4 size = (pixelSize / textureSize).xyxy * texelPos.xyxy;
    float2 exp = size.zw * textureSize + -floor(size.zw * textureSize) - 0.5;

    float4 factor = pow(2.0, pow(-exp.x + float4(-1, 1, -2, 2), 2.0) * -3.0);
    float factor2 = pow(2.0, pow(exp.x, 2.0) * -3.0);

    float3 power;
    power.x = pow(2.0, pow(exp.y, 2.0) * -8.0);
    power.y = pow(2.0, pow(-exp.y - 1.0, 2.0) * -8.0);
    power.z = pow(2.0, pow(-exp.y + 1.0, 2.0) * -8.0);

    float2 viewPos = floor(texelPos * viewSize) + 0.5;
    float intensityPos = frac((viewPos.y * 3.0 + viewPos.x) * 0.166667);

    float4 scanlineIntensity;
    if (intensityPos < 0.333)
        scanlineIntensity.rgb = intensity;
    else if (intensityPos < 0.666)
        scanlineIntensity.rgb = intensity.zxy;
    else
        scanlineIntensity.rgb = intensity.yzx;

    float2 sampleBase = floor(size.zw * textureSize);
    float3 color1 = SampleDiffuse((sampleBase + float2(1, -1) + 0.5) / textureSize).rgb * factor.y * brightness;
    float3 color2 = SampleDiffuse((sampleBase + float2(-2, 0) + 0.5) / textureSize).rgb * factor.z * brightness;
    float3 color3 = SampleDiffuse((sampleBase + float2(-1, 0) + 0.5) / textureSize).rgb * factor.x * brightness;
    float3 color4 = SampleDiffuse((sampleBase + float2(1, 0) + 0.5) / textureSize).rgb * factor.y * brightness;
    float3 color5 = SampleDiffuse((sampleBase + 0.5) / textureSize).rgb * factor2 * brightness;
    float3 color6 = SampleDiffuse((sampleBase + float2(-1, 1) + 0.5) / textureSize).rgb * factor.x * brightness;
    float3 color7 = SampleDiffuse((sampleBase + float2(2, 0) + 0.5) / textureSize).rgb * factor.w * brightness;
    float3 color8 = SampleDiffuse((sampleBase - 1.0 + 0.5) / textureSize).rgb * factor.x * brightness;
    float3 color9 = SampleDiffuse((sampleBase + float2(0, -1) + 0.5) / textureSize).rgb * factor2 * brightness;
    float3 color10 = SampleDiffuse((sampleBase + 1.0 + 0.5) / textureSize).rgb * factor.y * brightness;
    float3 color11 = SampleDiffuse((floor(size.xy * textureSize) + float2(0, 1) + 0.5) / textureSize).rgb * factor2 * brightness;

    float3 finalColor =
        power.x * (color2 + color3 + color4 + color5 + color7) / (factor.z + factor.x + factor.y + factor2 + factor.w) +
        power.y * (color1 + color8 + color9) / (factor.y + factor.x + factor2) +
        power.z * (color10 + color6 + color11) / (factor.y + factor.x + factor2);

    float4 outColor;
    outColor.rgb = viewSize.y > viewSizeHD ? scanlineIntensity.rgb * finalColor : finalColor;
    outColor.a = 1.0;
    return ApplyScreenDim(outColor);
}
