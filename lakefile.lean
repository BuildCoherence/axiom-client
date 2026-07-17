import Lake
open Lake DSL
open System

package axiomClient where
  leanOptions := #[⟨`autoImplicit, false⟩]

  version := v!"1.1.3-beta"
require AxiomLib from git "https://github.com/BuildCoherence/axiom-lib" @ "v1.0.2-beta"

-- Both libraries are default targets: a bare `lake build` is what the CLI's
-- remediation messages (`axm init` pre-warm failure, `axm upgrade`) and the
-- fetch → publish flow tell users to run, so it must compile the workspace
-- rather than build nothing. `Env`'s glob walks `.axiomdata/files/A/` at
-- build time and Lake errors if that directory is missing — the tracked
-- `.axiomdata/files/A/.gitkeep` guarantees it exists in a fresh clone.
@[default_target]
lean_lib Env where
  srcDir := ".axiomdata/files"
  roots := #[`A]
  globs := #[Glob.submodules `A]

@[default_target]
lean_lib Workspace where
  roots := #[`Workspace]
  globs := #[Glob.submodules `Workspace]
