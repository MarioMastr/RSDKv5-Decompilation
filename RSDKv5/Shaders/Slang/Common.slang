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

struct VertexInput
{
    float4 pos : POSITION;
    float4 color : COLOR0;
    float4 tex : TEXCOORD0;
};

struct VertexOutput
{
    float4 pos : SV_Position;
    float4 color : COLOR0;
    float4 tex : TEXCOORD0;
};

struct PixelInput
{
    float4 tex : TEXCOORD0;
};

VertexOutput VSMain(VertexInput input)
{
    VertexOutput output;
    output.pos = input.pos;
    output.color = input.color;
    output.tex = input.tex;
    return output;
}

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
