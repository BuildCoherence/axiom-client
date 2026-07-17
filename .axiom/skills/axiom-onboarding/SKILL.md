---
name: axiom-onboarding
description: Use when the user has just initialized their Axiom workspace (fresh `axm init`), when `Axioms.lean` contains an empty `user_axioms { }` block, or when the user asks to get started / set up their axioms. Walks the user from an empty workspace to a working starting point — starter commitments decided, a first Statement drafted, full `axm check` passing — via a short path (install the conventional starter) or a long path (each commitment explained and decided one at a time). Publishing is recommended at the end but not required.
---

# Axiom onboarding

The user has a fresh Axiom workspace and an empty `user_axioms { }` block in `Axioms.lean`. This skill walks them to a
working starting point: their starter commitments decided, a first Statement drafted in `Workspace/`, and everything
passing full `axm check` — one `axm publish` away from being live, whether or not they take that step now.

## When to invoke

- `Axioms.lean` contains an empty `user_axioms { }` block.
- The user just ran `axm init` and is asking what to do next.
- The user explicitly asks to "get started" or "set up my axioms".

## Done condition

Onboarding is complete when all of the following hold:

1. All five starter commitments (the four Classical Bridge Bundle fields and BFO adoption) have been **decided** —
   installed or declined. A user who declines everything still completes onboarding; their workspace, their commitments.
2. A first Statement is drafted in a `Workspace/` file.
3. Both files pass full `axm check`.
4. Publishing has been recommended and the user has decided — yes or no. Either answer completes onboarding.

Then deliver the closing beat (below) and stop driving. Do not require publishing.

## Two paths

Offer the user a choice up front. Do not assume which they want.

- **Short path**: "I'll install the conventional starter — the classical bridge bundle for `Actual` plus BFO as your
  upper ontology — draft a first Statement, and verify everything checks. You decide at the end whether to publish."
- **Long path**: "Want me to walk through each piece with the rationale, so you can decide each one and ask questions
  along the way?"

The two paths are pacing modes over the same steps, not separate scripts. Switch freely mid-flight: a short-path user
who starts asking questions should be offered the long path from wherever they are; a long-path user can say "install
the rest as recommended" and collapse to the short path.

## Auth gate (both paths, first)

Drafting a Statement, full `axm check`, and `axm publish` all require authentication, so verify it before any authoring:
run `axm status` (or check for `~/.axiom/auth.json`).

- If unauthenticated, tell the user what's about to happen — `axm auth` hands off to the browser to sign in, then
  returns to the CLI — and run it.
- If they have no Axiom account or beta access, say so plainly, point them to axiomreason.com, and pause onboarding
  until they have one.

On the long path, add one sentence of framing: authentication ties this machine to their username's **Formal Identity**
— everything they publish is attributed to it and appears on their profile at axiomreason.com.

## The conventional starter

Five commitments, installed as two `user_axioms` entries:

```lean
user_axioms {
  axiom logic_is_actual : LogicIsActual
  axiom bfo : A BFO
}
```

(`BFO` here is the fetched bfo file's top-level abbrev, so `Axioms.lean` needs that file id in its `open` line.)

`LogicIsActual` is the Classical Bridge Bundle — a `structure … : Prop` whose four fields are the classical Bridge
Axioms. Adopting the bundle as one entry is the convention; it is structurally unwrapped into per-field Holdings, so it
is equivalent to holding each field individually. The fields (prose names in parentheses):

1. `actual_intro : ∀ p : Prop, p → Actual p` (introduction)
2. `mp : ∀ p q : Prop, Actual (p → q) → Actual p → Actual q` (modus ponens)
3. `consistency : ¬ Actual False` (consistency)
4. `idempotency : ∀ p : Prop, Actual p = Actual (Actual p)` (idempotence — not the elimination `Actual p → p`, which the
   bundle deliberately omits so actuality never collapses into necessity)

`A` is notation for `Actual`. `BFO` (a top-level abbrev in the fetched `ref: bfo` file) is the Basic Formal Ontology
adoption term.

### Installation mechanics

1. Run `axm modeling-refs` and fetch `ref: actual-bridge`, `ref: actual-notation`, and `ref: bfo` with `axm fetch`.
   Files land at `.axiomdata/files/A/<id>.lean`.
2. **Read the fetched files. They are the source of truth** for exact declarations, field names, and types — the
   snippets in this skill orient you, but if they disagree with fetched content, the fetched content wins (the bundle
   has grown fields before).
3. Edit `Axioms.lean`: add the `import A.<id>` lines, the `open`s (the `A`-notation file id, and the bfo file id so
   `BFO` resolves unqualified), and the accepted entries inside `user_axioms { }`. Offer a one-line comment above each
   entry in the user's own words; skip if they prefer bare.
4. Run `axm check --basic` for fast local feedback, then full `axm check`.

### Partial installs (long path)

If the user accepts all four bundle fields, install the single `logic_is_actual : LogicIsActual` entry. If they decline
any field, install the accepted fields as individual axioms instead, preserving a proposition **definitionally equal**
to the fetched bundle field — definitionally equal propositions merge with bundle-holders' unwrapped Holdings, so a
partial install still participates fully in shared Holdings. Copying the fetched proposition is the simplest way to
preserve that equivalence, but token-for-token source identity is not required. Note to the user that this departs from
the labeled-record convention cosmetically and can be consolidated later by re-publishing `Axioms.lean` with the bundle.

If the user wants to _modify_ an item or design a different bridge posture (intuitionist, paraconsistent, …), that is
real authoring work: hand off to `examine-idea` / `formalize` rather than improvising it inline.

## Short path

1. Auth gate.
2. Install the full starter (both entries) with a one-sentence summary per commitment — the four fields in one breath,
   BFO in another. No per-item decisions.
3. Draft the canned welcome Statement (see _First Statement_ below), with one refinement pass in the user's voice.
4. Run `axm check --basic`, then full `axm check`.
5. Exit beat: recommend publishing, explain irrevocability in two sentences, let the user decide. Either answer
   completes onboarding.
6. Closing beat.

The short-path user makes exactly two decisions: "short or long?" and "publish or not?". Everything else proceeds
without pausing.

## Long path

Each step: explain, invite questions, then decide or act. Never install an item the user has declined.

**1. Auth gate** — plus the Formal Identity sentence.

**2. Workspace orientation** (no decision). `Axioms.lean` is the standing-commitments file: imports, opens, comments,
and exactly one `user_axioms { }` block, nothing else. `Workspace/*.lean` is where all ordinary authoring goes
(`InitialWorkspace.lean` is just template scaffolding). `.axiomdata/` holds fetched server content — read it, never
hand-edit it. `axm check` validates; `axm publish` submits publicly; details at their steps.

**3. Why bridges exist** (no decision, then a hard gate). A bare provable `p : Prop` is logical truth — true in every
logically possible world. `Actual p` marks what is _contingently_ true in the actual world. `Actual` is opaque: without
bridge axioms nothing is derivably actual, so the user's bridges define what counts as actual to them. Then stop and ask
explicitly: **"Questions, or shall I proceed?"** Philosophically-trained users often have them here. Curated answers:

- _"Do you have modal logic?"_ — No alethic modal logic ships by default; the platform provides only `Actual`. Bare
  provable propositions play the role of necessary truth, `Actual` marks contingent actuality, and users are free to
  layer a full modal theory on top. Hypotheticals have a conventional encoding (`ref: hypothetical-world`). Declining
  the bundle doesn't mean rejecting logic as a lens on actuality — it means choosing different bridges (e.g. an
  intuitionist posture with bridges over an embedded provability predicate).
- _"Why 'actual' instead of 'true' / 'real' / 'exists'?"_ — "Actual" descends from Latin _actualis_, "pertaining to
  action": something is actual iff it affects how you act. Existence debates ("do numbers exist?") produce internally
  coherent positions and no actionable conclusion; the action-grounded question ("do numbers affect this engineer's
  decisions?") is tractable. Actuality is deliberately agent-relative. Full argument:
  https://coherencelabs.net/blog/towards-practical-philosophy/
- _"Isn't agent-relative actuality just subjectivism?"_ — No. Asserting `Actual p` exposes your commitments to formal
  scrutiny: you are bound by what follows from your axioms, and contradictions are visible and lock your account.
  Accountability comes from logical consequence, not metaphysical consensus.

**4. The four bridge fields, one at a time** (four decisions). For each: show the field, explain what it commits the
user to, and give the differential example — what they lose by declining _this field while keeping the other three_. You
may re-skin an example's subject matter to the user's stated interests, but preserve the logical shape exactly; when
unsure, use the canonical example verbatim. The `A`-notation import/open rides along as mechanical setup, not a
decision.

- **Introduction** (`actual_intro`): anything you can prove becomes actual to you. _Declining it:_ suppose you hold
  `Actual GrassIsGreen` and your definitions prove `GrassIsGreen → GrassContainsChlorophyll`. That proved implication
  never becomes `Actual (…→…)`, so modus ponens has nothing to apply — you cannot conclude
  `Actual GrassContainsChlorophyll`. Even `Actual (2 + 2 = 4)` is unreachable; every mathematical fact you want at the
  actual layer becomes its own hand-written axiom.
- **Modus ponens** (`mp`): actual implications can be applied to actual premises, so contingent commitments chain.
  _Declining it:_ you commit `Actual TodayItRained`, and you can prove `TodayItRained → StreetsAreWet`. Introduction
  lifts the proved implication to `Actual (TodayItRained → StreetsAreWet)` — but you still cannot reach
  `Actual StreetsAreWet`: `TodayItRained` is contingent, not provable, so no other field recovers the conclusion. Your
  contingent commitments become inert. Community effect: most published arguments about the actual world take
  `logic_is_actual` as a premise, so their conclusions never become your Holdings.
- **Consistency** (`consistency`): nothing inconsistent is actually true. _Declining it:_ if your commitments ever yield
  both `Actual P` and `Actual ¬P`, modus ponens gives `Actual False`. With this field that is a genuine `False` —
  Inconsistency Detection catches it and locks publishing until you revise, which is what makes your commitments
  accountable. Without it, nothing flags; instead introduction + modus ponens quietly derive `Actual q` for _every_ `q`
  (`False → q` is provable), so your entire actual layer becomes trivial — every claim and its negation actual — with no
  signal that it happened.
- **Idempotence** (`idempotency`): `Actual (Actual p)` and `Actual p` are the same proposition. The upward direction is
  already derivable from introduction; the loss is downward. _Declining it:_ an argument that treats actuality itself as
  subject matter can conclude `Actual (Actual EmissionsCauseWarming)` — and you can never recover the plain
  `Actual EmissionsCauseWarming` from it. The index treats the two as distinct propositions, so agreement fragments into
  towers of nested `Actual`. Being an equality, the field also rewrites nested occurrences inside larger propositions.
  In prose, call this field _idempotence_, never "elimination" — the bundle deliberately omits `Actual p → p`.

**5. BFO adoption** (fifth decision). BFO (Basic Formal Ontology) is an upper ontology: a small vocabulary of high-level
categories — object, process, quality, role — that domain content hangs off of. It is an ISO standard used across
biomedical, financial, and defense ontologies, and Axiom's `universal` / `rigid universal` / `relation` macro library
(`ref: universals-and-relations`) builds on it, so adopting it buys interop with convention-following users. Disclose
the cost honestly: adopting `A BFO` commits the user to BFO's axioms — several hundred propositions whose consistency
burden becomes theirs; if a contradiction is ever proven from axioms they hold, their account locks until they revise.
Declining is fine: BFO vocabulary can still be _referenced_ without commitment (importing/opening carries no adoption),
and the user can adopt later or build their own scaffold.

**6. First Statement** (see _First Statement_ below for the shape). Explain the distinction first: User Axioms are
assertoric — standing commitments you are accountable to; Statements are attributional — "I, at time t, emitted this
term," with no truth connotation. You could state something _sarcastically_; you can't axiom it sarcastically. Unlike
the short path, invite the user to state something they actually want to say, offering the canned welcome Statement as
the default.

**7. Check.** `axm check --basic` elaborates locally; full `axm check` runs the real server-side validation pipeline —
the same one publishing runs — while persisting nothing.

**8. Publish — explained, offered, not required.** See _Publishing_ below.

Then the closing beat.

## First Statement

A Statement in a new `Workspace/` file — propose `Workspace/Welcome.lean`, let the user pick the name. Consult
`axiomlib-surface` for the `statement` syntax.

**Type the payload as a `String`, not a `Prop`**, unless the user explicitly pushes for a proposition:

```lean
statement welcome := "I'm excited to start using Axiom"
```

Rationale (share it if the user asks why): indexicals — "I", present tense — cannot be discharged by a plain `Prop`. A
string payload keeps the meaning open, so semantics can be layered later at whatever shape actually fits — e.g. the same
string later given semantics as a `relation` with slots for the speaker and the time. Typing the payload as a `Prop` up
front forces the meaning into a shape that can't accommodate that. This is a general rule, not a Statement-only one —
the Indexicals section of `axiom-conventions` covers how first-person claims become `Prop`s (resolve the indexicals to
explicit referents, or discharge them as `relation` argument slots).

Phrase the content in the user's voice and ask them to refine it before moving on.

## Publishing

Publishing is a public, irrevocable act: the record stays in the graph's history even after newer snapshots replace
profile content. **Never publish without the user's explicit permission for the exact content.**

At the exit beat, recommend publishing both files — `Axioms.lean` first, then the Statement file — and explain in a few
sentences what it does: the user's profile at `axiomreason.com/u/<username>` shows their snapshot; the index derives
what they hold from it; others can fetch their files and prove theorems from their axioms. On the user's first
`axm publish` from a machine, the CLI prompts an irrevocability acknowledgement (`[y/N/always]`); explain that `always`
persists the acknowledgement so it never asks again, and let the user pick. If their axioms are ever proven
inconsistent, publishing locks until they revise `Axioms.lean` — that is Inconsistency Detection working as designed.

Declining to publish completes onboarding just the same; everything stays local and ready.

## Closing beat (both paths)

Two moves, then stop driving. On the short path, preface with: "we skipped the explanations — ask about anything and
I'll go as deep as you like."

**What you can do next** — lead with whatever matches interests the user revealed during onboarding, rather than
reciting the list:

- **Assert your first actual-world commitment.** The starter is structural — you haven't yet _said_ anything about the
  world. A User Axiom wrapping `Actual` around something you hold true is the natural first real commitment
  (`examine-idea` to sharpen it, `formalize` to write it).
- **Define a concept, or find one someone else defined.** Introduce a Semantic String or a `universal`, or search for
  prior art with `axm search` (`axiom-conventions` has the templates).
- **Give your Statement a semantics.** User Axioms constraining what your welcome string means — e.g. typing its
  semantics as a `Person → Time → Prop` and relating it to your other commitments.
- **Build on someone else's content.** `axm search`, `axm fetch`, `axm fork`; or prove a theorem from another user's
  published axioms — the platform's primary social interaction.
- **Publish**, if they declined at the exit beat.

**What we didn't cover** — name the gaps and invite digging: Semantic Strings in depth, the `universal` / `relation`
macros, how the profile works (Holdings, adopter counts), User Theorems, and the View/syntax system (`open` and how
others' notation reaches you). Onboarding is done; you are not — answer follow-ups from `axiom-conventions`,
`axiomlib-surface`, and the other skills rather than this one.

## Handoffs

- **`axiom-conventions`** — modeling refs, naming conventions, conventional content and templates.
- **`axiomlib-surface`** — the exact Lean shapes for `user_axioms`, `statement`, `Actual`, and friends.
- **`formalize`** — when the user wants to author an axiom of their own (including a custom bridge posture), during or
  after onboarding.
- **`examine-idea`** — when the user needs to work out what they mean before formalizing.

## What this skill does not do

- Does not author user-specific axioms. Hand off to `formalize`.
- Does not interrogate why the user is here or what they want to formalize. Hand off to `examine-idea`.
- Does not keep driving after the closing beat. Follow-up questions are answered from the sibling skills; subsequent
  publish cycles, forks, and theorem authoring are normal work, not onboarding.
