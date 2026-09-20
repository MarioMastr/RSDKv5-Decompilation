[[vk::binding(0, 2)]]
Sampler2D inputTexture : register(s0, space2);

[[vk::binding(0, 3)]]
cbuffer ShaderConstants : register(b0, space3)
{
    float2 pixelSize;
    float2 textureSize;
    float2 viewSize;
#if defined(RETRO_REV02)
    float screenDim;
#endif
};

struct PixelInput
{
    float4 color : COLOR0;
    float2 tex : TEXCOORD0;
};

float4 SampleDiffuse(float2 texCoord)
{
    return inputTexture.Sample(texCoord);
}

float4 ApplyScreenDim(float4 color)
{
#if defined(RETRO_REV02)
    color *= screenDim;
#endif
    return color;
}
