"""Compile the Slang shaders consumed by the SDL 3.4 GPU renderer.

The output directory is the runtime Data/Shaders/SDL3 directory. Build all
three formats when distributing a portable Data folder; the runtime selects
the format supported by SDL's active GPU backend.
"""

import argparse
import pathlib
import subprocess
import sys


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
        str(source),
        "-o",
        str(output),
    ]
    if target == "spirv":
        command.insert(command.index("-no-mangle"), "-profile")
        command.insert(command.index("-no-mangle"), "spirv_1_0")
    if stage == "vertex":
        command[command.index("-entry") + 1] = "VSMain"
        command[command.index("-stage") + 1] = "vertex"
    command.insert(-2, "-DRETRO_REV02=1")
    subprocess.check_call(command)


def main():
    is_windows = sys.platform == "win32"
    default_targets = ("spirv", "dxil") if is_windows else ("spirv", "metal")

    parser = argparse.ArgumentParser()
    parser.add_argument("--slangc", default="slangc")
    parser.add_argument("--output", type=pathlib.Path, default=pathlib.Path("../CSO-SDL3"))
    parser.add_argument(
        "--targets",
        nargs="+",
        choices=("spirv", "dxil", "metal"),
        default=default_targets,
        help=f"shader targets to generate (default: {', '.join(default_targets)})",
    )
    args = parser.parse_args()

    args.output.mkdir(parents=True, exist_ok=True)
    root = pathlib.Path(__file__).parent
    folders = {"spirv": "SPIRV", "dxil": "DXIL", "metal": "MSL"}
    for target in args.targets:
        target_output = args.output / folders[target]
        target_output.mkdir(parents=True, exist_ok=True)
        for name in SHADERS:
            compile_shader(args.slangc, root / f"{name}.slang", target, "fragment", target_output / f"{name}.frag")


if __name__ == "__main__":
    main()
