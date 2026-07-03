---
name: axiomlib-surface
description: "Use when needing to import from `Axiom` or understand AxiomLib's Lean surface: `Actual`, semantic strings, authenticated terms, User Axioms, Statements, User Theorems, and the user-facing commands/elaborators."
---

# AxiomLib import surface

The main target exposed by the library is `import Axiom`, which brings the basic types, notations, and elaborators into
scope. Keep imports honest: do not guess submodules, do not assume Mathlib is available, and do not treat arbitrary Lean
dependencies as admitted platform substrate. When a narrow import is useful, use an actual file such as
`Axiom.Types.Actual`, `Axiom.Types.SemanticStrings`, etc. Most user-authored Lean should just `import Axiom`.

AxiomLib is part of Axiom's small common substrate, alongside Lean core. Its constructs are forced on every user as the
platform-defined machinery for formal identity, authenticated publication, actuality, semantic strings, and
snapshot-bound theorem artifacts. Anything outside Lean core and AxiomLib must enter through normal published
`import A.<file_id>` content or, if it exists locally, a `import Workspace.<name>`.

## `Actual`

`Axiom.Actual {α : Type u} (t : α) : Prop` is an opaque proposition for "actuality." The philosophical convention is
that `Actual t` should hold when `t` affects the actions of the Formal Identity that commits to it, but AxiomLib does
not enforce an interpretation. Users supply Bridge Axioms, such as `∀ P : Prop, P -> Actual P`,
`Actual (P -> Q) -> Actual P -> Actual Q`, and `Actual False -> False`, to decide how bare Lean propositions relate to
actuality.

Use `Actual` for contingent real-world commitments, not for every mathematical or structural proposition. A bare
`P : Prop` is ordinary Lean truth; `Actual P` is the user's modality over that proposition. Semantic strings and
`Actual` compose, but semantic strings do not imply any bridge axioms on their own.

## Semantic Strings

`Axiom.Types.SemanticStrings` lets string literals coerce into typed predicates or referents through `CoeDep` instances.
Predicate-like targets use `getSemantics? : String -> Option α` plus `getSemantics`, falling back through
`IsPredicate.noSemantics` to `False` pointwise when the optional meaning is absent. Referent-like targets use
`getReferent : String -> α` plus `IsReferent.defaultReferent`, falling back to `PUnit` pointwise.

This is the sanctioned way to introduce vague or irreducible concepts without declaring new `opaque` constants, which
user content cannot do. The identity is the pair `(target type, string)`: `("is red" : Apple -> Prop)` and
`("is red" : Weather -> Prop)` are different substrates, while two users using the same target type and string refer to
the same kernel-level opaque. Users constrain or reject predicate meanings with axioms about `getSemantics?`, and
constrain type referents with positive axioms about `getReferent`.

## `AuthenticatedTerm`

`AuthenticatedTerm {α : Type u} (term : α) : Prop` is an opaque witness that the platform authenticated a submitted
term. In beta this is server-side attestation: publish-time validation checks that the username and timestamp embedded
in the generated `AuthenticatedTerm` match the authenticated request and server-time window. It is not a user auth token
and should not be hand-authored except through the platform commands and transform.

`AuthenticatedTerm` is the auth field behind Axiom Snapshots and Statements. The unfounded Lean `axiom` declarations the
transform emits are permitted only in the specific `AuthenticatedTerm ("<user>", <value>, <timestamp>)` shapes the
validator recognizes. Ordinary users should never write top-level `axiom` declarations outside a `user_axioms` block.

## `Axioms` and `UserAxioms`

`Axioms` is an abbreviation for `List (String × Prop)`: a concrete list of named propositions.
`UserAxioms user timestamp` is the authenticated snapshot wrapper around that list, with fields `axioms : Axioms` and
`auth : AuthenticatedTerm (user, axioms, timestamp)`. In product language, a `UserAxioms` value is an Axiom Snapshot,
not a single user axiom.

Snapshots are immutable and timestamped; publishing a new `Axioms.lean` creates a new snapshot rather than mutating the
old one. The current profile and holding calculations use the latest snapshot, while older snapshots remain kernel facts
that existing artifacts can still reference. The profile and index may derive Holdings from individual entries and from
structure-of-`Prop`s entries such as conjunction bundles.

## `user_axioms`

The user-facing syntax for personal commitments is exactly one block in `Axioms.lean`:

```lean
import Axiom
import A.<id>
...
import Workspace.<name>
...
open <id>
...

user_axioms {
  axiom my_premise : ∀ n : Nat, n + 0 = n
  axiom another : True
}
```

Each entry is `axiom <name> : <Prop>`; there is no `:=` body inside the block. The elaborator checks duplicate names,
elaborates each entry as a fully determined `Prop`, emits local defs for the propositions, builds `userAxiomsList`, and
emits `user_axioms_auth` plus `userAxioms` with a placeholder timestamp during local elaboration. The `axm_transform`
publish path expands the block into authenticated declarations stamped with request server time; the server validates
that expanded plain Lean.

`user_axioms` belongs only in `Axioms.lean`. If it appears in a workspace file, the elaborator rejects it. Keep
`Axioms.lean` to imports, opens, comments, and that single block.

## `Statement`

`Statement user statement timestamp` is an authenticated, timestamped record that a Formal Identity stated a term. It
carries no truth connotation: contrast a User Axiom, which is a commitment the user is accountable to. Its single field
is `auth : AuthenticatedTerm (user, statement, timestamp)`.

Use a Statement for attributed posts, observations, notes, or quoted terms that should enter the formal graph without
claiming they are true commitments. A Statement can wrap a `String`, `Nat`, `Prop`, function, type, or any Lean term
whose type can be inferred or ascribed. Published Statements are indexed under the `Statement` type head and can be
queried by user, payload, and timestamp.

Currently, statements are not featured prominently on axiomreason.com, but likely will be in the future.

## `statement`

The workspace syntax is:

```lean
statement post_name := "I think this deserves later formalization"
statement typed_post : Prop := ∀ n : Nat, n = n
```

The local elaborator reads the username from `~/.axiom/auth.json`, elaborates the payload, and emits `<name>Payload`,
`<name>_auth`, and `<name> : Statement "<user>" <name>Payload 0` so IDE feedback and later references work before
publish. The timestamp `0` is only a local placeholder; `axm_transform` restamps the generated `AuthenticatedTerm` and
`Statement` with request server time at publish. `statement` commands belong in `Workspace/*.lean`, not `Axioms.lean`.

Statements are not cleanly forkable because their `_auth` witness is bound to the original user and timestamp. A forked
file containing a published Statement usually needs the Statement removed or rewritten before republishing. The server
never runs the `statement` elaborator; it validates the transformed `def` and authenticated `axiom` declarations as
plain Lean.

## `UserTheorem`

`UserTheorem userAxioms p` is a kernel artifact proving that proposition `p` follows from a specific Axiom Snapshot. Its
field is `proof : (∀ ax ∈ userAxioms.axioms, ax.snd) -> p`, so the artifact is eternally tied to the snapshot value it
references. In product terms, anyone can publish a User Theorem for anyone's snapshot if they can provide the proof.

The conclusion `p` is the theorem's result after any leading snapshot-discharged premises are supplied. Data binders and
anonymous arrow-style `Prop` binders begin the conclusion telescope rather than being matched against snapshot axioms.
Prefer closed, fully applied premise propositions when authoring the ordinary theorem that will be minted into a
`UserTheorem`, because those are the shapes the platform can later recognize as adopted or held.

## `user_theorem`

A `user_theorem` is minted from an ordinary Lean theorem:

```lean
theorem alice_axioms_imply_p (some_axiom : <axiom-prop>) : <conclusion> := by
  -- proof using `some_axiom`

def alice_axioms_imply_p_for_alice :=
  user_theorem <owner_file_id>.userAxioms alice_axioms_imply_p
```

Each leading `Prop` hypothesis is matched to an axiom by proposition, using definitional equality. Hypothesis names are
advisory: naming a hypothesis after an axiom improves readability and can sharpen error messages, but it is not the
matching key. A named hypothesis whose proposition is not defeq to any snapshot axiom is a hard error; to prove a
conditional `P -> C` where `P` is not a snapshot axiom, put `P -> C` in the conclusion instead of making `P` a leading
named premise.

Matching also reaches into structure-of-`Prop`s entries. If a snapshot contains an axiom headed by a literal Prop-valued
structure such as `P ∧ Q` or `P ↔ Q`, the elaborator offers the bundle and its Prop fields as premise candidates. The
implementation uses `Axioms.holds_at` internally to discharge matched premises by literal list index; authors normally
do not call it directly.

## `CommandLib` and `AxiomTransform`

`CommandLib` is a small support library used by AxiomLib, `axm_transform`, and the validator, not the normal authoring
surface. `AxmTransform` is the Lake executable implementation behind `lake exe axm_transform`, invoked by the `axm` CLI
during `check` and `publish`. It elaborates user sources, rewrites `Workspace.<X>` imports to `A.<file_id>`, wraps
published files in `namespace <file_id>`, expands `user_axioms` and `statement` into authenticated plain Lean, records
dependencies, and applies validator-facing source-shape edits such as scoped promotion.

Do not import or call `AxmTransform` from user Lean. It is publish-path machinery, not a modeling API. If local source
and published source differ, assume the transform owns that difference: files on disk stay in authorable workspace form,
and publish-time output becomes the server-validated, namespaced representation.
