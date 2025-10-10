# Use Makefiles for CI Commands

## Context

Continuous Integration (CI) workflows often contain multiple commands for building, testing, linting, and deploying
software. These commands can be written directly inside the CI workflow definitions (e.g., GitHub Actions YAML), or they
can be placed in separate scripts where the CI workflows can call them.

However, both approaches have drawbacks:

* **CI workflows only**: Developers cannot easily run the exact same steps locally without re-creating the workflow
  environment or copy-pasting commands from YAML files.
* **Separate scripts**: While more reusable than inline commands (different CI environments and local dev), scripts can
  accumulate and require remembering how they are named, where they live, and in which order they should be run.

Makefiles provide a consistent and discoverable interface to common tasks across local development and CI/CD pipelines.

## Options

1. **Write commands directly in CI workflows**
    * Keeps everything in one YAML file
    * Limited reusability CI when using another CI system
    * Harder for developers to replicate the same flow locally

2. **Use separate shell/Python scripts**
    * Allows reusing logic in CI and locally
    * Requires remembering file names and arguments or investing significant effort for developing a strict framework
    * Can fragment into multiple small scripts which require knowledge about how to chain them together

3. **Define commands in Makefile**
    * Provides a single entry point (`make <target>`) for all build/test/deploy tasks
    * Easy for developers to run the same commands locally that CI runs
    * Commands are grouped and discoverable (`make help`), and can programmatically chained together
    * CI workflows stay minimal, calling only the required Make targets
    * Avoids duplication between CI YAML and local dev scripts

## Decision

> Adopt **Makefiles** as the canonical place for defining project build, test, and deployment commands.
> CI workflows will invoke `make` targets rather than duplicating or hardcoding commands.

### Justification

* **Ease of local execution**: Developers can run `make lint` or `make apply` locally, without digging into CI YAML.
* **Consistency**: The exact same Make targets are run in CI and locally, avoiding drift.
* **Discoverability**: A `Makefile` serves as self-documentation of available project tasks.
* **Simplicity**: No need to remember how multiple scripts tie together.

## Consequences

* The toolchain requires developers to have GNU Make installed (which is available by default on most UNIX-like
  systems).
* Some CI steps may still require lightweight shell wrapping (e.g. secrets handling), but the majority of commands live
  in the `Makefile`.
* CI workflows become shorter and easier to maintain, but the Makefile may grow in complexity if too many
  responsibilities are centralised.
