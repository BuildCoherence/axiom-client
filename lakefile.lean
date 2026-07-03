import Lake
open Lake DSL
open System

package axiomClient where
  leanOptions := #[⟨`autoImplicit, false⟩]

  version := v!"1.0.0-beta"
require AxiomLib from git "https://github.com/BuildCoherence/axiom-lib" @ "v1.0.0-beta"

lean_lib Env where
  srcDir := ".axiomdata/files"
  roots := #[`A]
  globs := #[Glob.submodules `A]

lean_lib Workspace where
  roots := #[`Workspace]
  globs := #[Glob.submodules `Workspace]
