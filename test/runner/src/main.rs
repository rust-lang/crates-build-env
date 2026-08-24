use anyhow::{Context, Result};
use rustwide::{
    Crate, Toolchain, WorkspaceBuilder,
    cmd::{SandboxBuilder, SandboxImage},
};
use std::path::Path;

/// Prints Rustwide's command output so local and CI failures include the actual
/// sandbox error. `rustwide::logging::init()` captures logs without displaying
/// them, which otherwise leaves only an opaque command exit status.
struct StderrLogger;

impl log::Log for StderrLogger {
    fn enabled(&self, metadata: &log::Metadata<'_>) -> bool {
        metadata.target().starts_with("rustwide") && metadata.level() <= log::Level::Info
    }

    fn log(&self, record: &log::Record<'_>) {
        if self.enabled(record.metadata()) {
            eprintln!("{}: {}", record.level(), record.args());
        }
    }

    fn flush(&self) {}
}

fn main() -> Result<()> {
    rustwide::logging::init_with(StderrLogger);

    let mut args = std::env::args_os().skip(1);
    let image = args.next().context("missing Docker image argument")?;
    let crate_path = args.next().context("missing crate path argument")?;
    let workspace_path = args.next().context("missing workspace path argument")?;
    let cargo_args: Vec<_> = args.collect();
    anyhow::ensure!(!cargo_args.is_empty(), "missing Cargo arguments");

    let image = image
        .to_str()
        .context("Docker image name is not valid UTF-8")?;
    let crate_path = Path::new(&crate_path)
        .canonicalize()
        .context("failed to resolve test crate path")?;

    let workspace =
        WorkspaceBuilder::new(Path::new(&workspace_path), "crates-build-env local test")
            .sandbox_image(SandboxImage::local(image)?)
            .running_inside_docker(true)
            .fast_init(true)
            .init()?;

    let toolchain = Toolchain::dist("nightly");
    toolchain.install(&workspace)?;

    let krate = Crate::local(&crate_path);
    let sandbox = SandboxBuilder::new().enable_networking(false);
    let mut build_dir = workspace.build_dir("local-test-crate");
    build_dir.purge()?;
    build_dir.build(&toolchain, &krate, sandbox).run(|build| {
        build.cargo().args(&cargo_args).run()?;
        Ok(())
    })?;

    println!("successfully built {} in {image}", crate_path.display());
    Ok(())
}
