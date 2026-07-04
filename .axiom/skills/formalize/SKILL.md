---
name: formalize
description: Use when the user has crisp(-enough) intent to translate something into Lean — a User Axiom, User Theorem, Statement, opaque type, semantic string, or supporting definition.
---

# Formalize

The user has something to translate into Lean. This skill orchestrates the translation: confirm the conceptual kind,
look up the Lean shape, place the file, re-ground in conventions, state the intended shape, draft, check, and offer next
steps.

This skill is intentionally thin. The kind taxonomy (User Axiom / User Theorem / Statement / opaque / semantic string /
Bridge Axiom), the Lean templates, and the `Actual`-wrap guidance live in `axiomlib-surface` — `formalize` consults them
rather than restating. The `axiom-conventions` skill is required reading before drafting Lean code.

## When to fire

- The user has crisp intent and asks "how do I write this in Axiom?" / "formalize this."
- `examine-idea`'s articulation phase has converged on a crisp unit.
- The user is editing a `.lean` file and asking how to express something specific.

## Procedure

1. **Confirm the conceptual kind.** If unclear from context, briefly ask. Is this a commitment (User Axiom), a
   derivation (User Theorem), an attribution without commitment (Statement), a domain primitive (`opaque` or semantic
   string predicate), or supporting infrastructure for one of the above? Skip the question if the kind is obvious.

2. **Look up the Lean shape.** Consult `axiomlib-surface` for the form matching the conceptual kind, including the
   `Actual`-wrap convention (contingent commitments are `Actual`-wrapped; structural or necessary content is bare —
   apply the Actuality test in `axiom-conventions` when classifying).

3. **Search for prior art.** The `axm` CLI has a rich search functionality. Before attempting to formalize something, it
   is the best practice to search Axiom for files that already formalize something similar. This allows you to either
   reuse existing code that fits your use case or fork something that is close but not exactly right. You shouldn't fork
   something just to fork something. It often makes sense to start from scratch.

   For `universal` / `rigid universal` / `relation` one-liners, prior art is for **alignment**, not import: copy the
   conventional line into your file rather than fetching its file. Import what identity actually requires — structures,
   theorems, notation, bundles. See _Identify prior art_ in `axiom-conventions`.

4. **Place the file.**
   - **User Axiom** → `Axioms.lean`, inside the `user_axioms { … }` block.
   - **Everything else** (User Theorem, Statement, opaque type, semantic string definition, supporting `def`) →
     `Workspace/<descriptive-name>.lean`.

5. **Re-ground immediately before drafting.** Do not draft from memory of an earlier read — long gaps between reading
   `axiom-conventions` and applying it are where drafts silently revert to generic Lean (fresh sorts, raw `def`
   predicates, bare implications). Re-open `axiom-conventions` (at minimum its Ontology, Semantic strings, Indexicals,
   and Actuality sections) unless you read it after this formalization began. For ontological content, also fetch and
   study at least one exemplar from `axm modeling-refs` (e.g. `ref: child-murder-punishment`); the machinery refs alone
   do not anchor the idiom.

6. **State the target shape before writing the file.** In a few lines, tell the user what you intend to declare — which
   universals (`universal` vs `rigid universal`), which `relation`s, which particulars, which named `Prop`s, and what
   gets `A`-wrapped — and confirm it matches what they meant. This show-and-ask beat happens before the file exists, not
   after.

7. **Draft.** Use the relevant template from `axiomlib-surface`. Apply naming per `axiom-conventions` (PascalCase for
   types, files, and namespaces; camelCase for terms; snake_case for proofs and axioms). When defining operators so
   propositions read naturally, follow the Notation section of `axiom-conventions`. For a **User Theorem**,
   `axiomlib-surface` also describes how leading `Prop` hypotheses match a snapshot's axioms — consult it.

   **Prefer closed premises.** Write each leading hypothesis as a fully-applied, closed `Prop` (`h : MyProp`,
   `h : A ∧ B`) rather than quantifying over an open binder (`theorem t (P : Prop) (h : P) : …`). A closed Prop-typed
   premise is the shape premise matching can adopt — it is what makes a reader's holding of that proposition count
   toward your theorem. An open-binder theorem still publishes, but it is **not adoptable**: it carries no premise
   matching and no adoption. Close your binders wherever the statement allows it.

8. **Check against conventions, then against tooling.** First verify the draft by eye against `axiom-conventions`:
   - every kind is declared with `universal` / `rigid universal` — no `def X : Type := "…"` for anything English
     quantifies over;
   - every predicate or relation over universals uses the `relation` macro — no raw `def … : … → Prop := "…"`;
   - contingent real-world content is `A`-wrapped, premises and conclusion, per the Actuality test in
     `axiom-conventions`;
   - no indexicals ("I", "now", "here") remain inside `Prop`-typed semantic strings;
   - naming and notation follow `axiom-conventions`.

   Only then run `axm check --basic` for fast local feedback and `axm check` for the full server-side validation
   pipeline. The checks validate elaboration, not conventions — semantic strings coerce to almost anything, so a draft
   violating every rule above can still pass both. Passing checks is necessary; it is never evidence the shape is right.

9. **Show the draft.** Present it and ask whether it matches what the user meant.

10. **Recommend next steps.** `axm publish` when ready. Publishing is a public commitment — the user decides when.

## Pivot to examine-idea posture

If a meaning question surfaces mid-translation, the right response is `examine-idea`'s probing posture, not a Lean-craft
answer. Signals to watch for:

- A term in the user's content turns out to be loaded — multi-referent, action-disconnected, or boundary-fuzzy. (See
  `examine-idea` for the cues.)
- Committing to a Lean shape forces a meaning question the user hasn't decided. "Making this a User Axiom commits you to
  it; making it a Statement doesn't — which fits what you mean?" "BFO would model 'redness' as a quality of an entity,
  not a predicate over entities — does that match how you think about it?"
- Generality / scope question. "You said 'all apples' — every apple, or every apple in the context you have in mind?"

Under the shared-context model, you don't formally hand off — you shift posture for that question. Both `examine-idea`
and `formalize` coexist in context once both have fired; the AI uses whichever frame applies at the moment.

## Banned Lean Constructs and Features

- **`opaque`:** Banned globally. You must use Semantic Strings for opaque-like behavior.
- **`sorry`:** Banned at both the syntax level and post-elaboration level (`sorryAx`). All goals must be fully proven.
- **`set_option`:** Banned globally to prevent overriding compile/elaboration options (such as heartbeats or recursion
  depth limits).
- **`initialize` (and `register_option`):** Banned. Initializers run once per process and mutate global state, which
  violates process/import-reuse contracts.
- **Custom Elaborators (`elab` and `elab_rules`):** Banned. Users cannot write custom C++/Lean metaprogramming or custom
  elaboration functions that execute during compilation.
- **`unsafe` declarations:** Banned (any occurrence of the keyword `unsafe` or `unsafe` constant attributes is
  rejected).
- **`extern` / FFI:** Banned. The `@[extern]`, `@[init]`, and `@[csimp]` attributes are disallowed to prevent execution
  of native code or unchecked axioms during validation.
- **Bare `axiom` declarations:** Top-level `axiom` keywords are restricted. To declare axioms, you must use the
  `user_axioms` block in `Axioms.lean`, which generates wrapped and authenticated `AuthenticatedTerm` structures
  matching your user identity and a 5-minute time window.

### Supported Language Extensions

- **Custom Macros and Notations:** You are allowed to declare custom notations and macros (e.g. using `syntax`, `macro`,
  `macro_rules`, or `notation`). However:
  - **Automatic Scoped Promotion:** The compilation pipeline (`AxmTransform`) automatically promotes top-level workspace
    `notation` and `macro` commands to `scoped notation` and `scoped macro` (as well as global `instance`s to
    `scoped instance` and non-reducibility attributes like `@[my_attr]` to `@[scoped my_attr]`). This prevents
    environment-extension entries (notations, macro tables, instance databases) from leaking globally to other users'
    files upon transitive imports.
  - **Macro-Expansion Containment:** Custom macros must not expand to any banned command kinds (like `set_option` or
    `initialize`). Post-macro-expansion command overrides will catch and reject them.

## What this skill does not do

- Does not interrogate meaning. That's `examine-idea`'s posture.
- Does not publish on the user's behalf. Recommends; the user decides.
