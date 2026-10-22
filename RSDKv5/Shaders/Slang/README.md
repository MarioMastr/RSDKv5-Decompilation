# SDL3 Slang Shader

To compile, `slangc` must be available. You can download Slang from [GitHub](https://github.com/shader-slang/slang/releases/latest). Then, run the following command in the terminal:

```bash
python3 compile_sdl3.py # --targets (list of targets: defaults to spirv on all, msl on non-windows, and dxil on windows) --output (output directory: defaults to Data/Shaders/CSO-SDL3/) --slangc (path to slangc executable: defaults to system path)
```
