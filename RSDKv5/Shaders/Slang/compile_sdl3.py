"""Compile the Slang shaders consumed by the SDL 3.4 GPU renderer.

The output directory is the runtime Data/Shaders/SDL3 directory. Build all
three formats when distributing a portable Data folder; the runtime selects
the format supported by SDL's active GPU backend.
"""

import argparse
import pathlib
import subprocess


SHADERS = ["None", "Clean", "CRT-Yeetron", "CRT-Yee64", "YUV-420", "YUV-422", "YUV-444", "RGB-Image"]


def compile_shader(slangc, source, target, stage, output):
    command = [
        slangc,
        "-target",
        target,
        "-I",
        str(source.parent),
        "-entry",
        "PSMain",
        "-stage",
        "fragment",
        "-no-mangle",
        "-profile",
        "spirv_1_0",
        str(source),
        "-o",
        str(output),
    ]
    if stage == "vertex":
        command[command.index("-entry") + 1] = "VSMain"
        command[command.index("-stage") + 1] = "vertex"
    command.insert(-2, "-DRETRO_REV02=1")
    subprocess.check_call(command)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--slangc", default="slangc")
    parser.add_argument("--output", type=pathlib.Path, default=pathlib.Path("../SDL3"))
    parser.add_argument(
        "--targets",
        nargs="+",
        choices=("spirv", "dxil", "metal", "hlsl"),
        default=("spirv", "dxil", "metal", "hlsl"),
        help="shader targets to generate (default: all SDL GPU targets)",
    )
    args = parser.parse_args()

    args.output.mkdir(parents=True, exist_ok=True)
    root = pathlib.Path(__file__).parent
    extensions = {"spirv": "spv", "dxil": "dxil", "metal": "msl", "hlsl": "hlsl"}
    for target in args.targets:
        extension = extensions[target]
        for name in SHADERS:
            compile_shader(args.slangc, root / f"{name}.slang", target, "fragment", args.output / f"{name}.{extension}")


if __name__ == "__main__":
    main()
