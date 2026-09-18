# SDL GPU Slang shaders

These shaders preserve the effects in `../DX9` while using Slang's portable
resource and entry-point syntax.

Each effect provides:

- `VSMain`: passthrough vertex shader
- `PSMain`: effect-specific fragment shader

The fragment shader uses one combined `Sampler2D` input at `s0` and one uniform
block at `b0`. The uniform block contains `pixelSize`, `textureSize`, `viewSize`,
and `screenDim`. Define `RETRO_REV02` when compiling to enable dimming.

For example:

```sh
slangc -target spirv -I . -entry VSMain -stage vertex None.slang -o None.vert.spv
slangc -target spirv -I . -entry PSMain -stage fragment None.slang -o None.frag.spv
```

SDL 3.4's GPU renderer loads precompiled backend code from
`Data/Shaders/SDL3`. Generate the supported formats (SPIR-V, DXIL, and Metal
source) with:

```sh
python3 compile_sdl3.py --output ../../Data/Shaders/SDL3
```

Do not compile these files at runtime: the SDL renderer selects the matching
format for its active GPU backend and disables shader support if the packaged
binary is missing or invalid.
