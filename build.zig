const std = @import("std");

pub fn build(b: *std.Build) void {
    var disabled_features = std.Target.Cpu.Feature.Set.empty;
    var enabled_features = std.Target.Cpu.Feature.Set.empty;

    disabled_features.addFeature(@intFromEnum(std.Target.x86.Feature.mmx));
    disabled_features.addFeature(@intFromEnum(std.Target.x86.Feature.sse));
    disabled_features.addFeature(@intFromEnum(std.Target.x86.Feature.sse2));
    disabled_features.addFeature(@intFromEnum(std.Target.x86.Feature.avx));
    disabled_features.addFeature(@intFromEnum(std.Target.x86.Feature.avx2));
    enabled_features.addFeature(@intFromEnum(std.Target.x86.Feature.soft_float));

    const target_query = std.Target.Query{
        .cpu_arch = std.Target.Cpu.Arch.x86,
        .os_tag = std.Target.Os.Tag.freestanding,
        .abi = std.Target.Abi.none,
        .cpu_features_sub = disabled_features,
        .cpu_features_add = enabled_features,
    };

    const optimise = b.standardOptimizeOption(.{});

    const kernel = b.addExecutable(.{
        .name = "kernel.elf",
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(target_query),
        .optimize = optimise,
        .code_model = .kernel,
    });

    kernel.setLinkerScript(b.path("src/linker.ld"));
    b.installArtifact(kernel);

    const kernel_step = b.step("kernel", "Build the Kernel");
    kernel_step.dependOn(&kernel.step);

    const mkdirs = b.addSystemCommand(&[_][]const u8{
        "mkdir", "-p", "isodir/boot/grub",
    });

    const copy_kernel = b.addSystemCommand(&[_][]const u8{
        "cp",
        "zig-out/bin/kernel.elf",
        "isodir/boot/kernel.elf",
    });
    copy_kernel.step.dependOn(&kernel.step);
    copy_kernel.step.dependOn(&mkdirs.step);

    const copy_grub = b.addSystemCommand(&[_][]const u8{
        "cp",
        "grub.cfg",
        "isodir/boot/grub/grub.cfg",
    });
    copy_grub.step.dependOn(&copy_kernel.step);

    const mkiso = b.addSystemCommand(&[_][]const u8{
        "grub-mkrescue",
        "-o", "kernel.iso",
        "isodir",
    });
    mkiso.step.dependOn(&copy_grub.step);

    const iso_step = b.step("iso", "Build bootable ISO");
    iso_step.dependOn(&mkiso.step);
}
