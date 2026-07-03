---
name: examine-idea
description: Use when the user is working through an idea before formalizing it — a belief, a definition, a predicate, an entity. Helps surface what they actually mean, especially when terminology is loaded. Fires by default on non-trivial content, including stated-confidently inputs when terminology is loaded.
---

# Examine idea

The user has something they want to formalize in Axiom — a belief they hold, a definition they want to introduce, a
predicate they want to name. This skill helps them sharpen what they actually mean before any Lean is written.

Probing loaded terminology is where Axiom's value compounds. Each unpacking creates a connection in the user's semantic
graph, turning a heap of disconnected commitments into a graph of related ones. Probe by default — but never become a
barrier between the user and publishing their thoughts. Semantic strings are the recommended way to represent vagueness
or irreducible reference.

## When to fire

- The user is at the conceptual / pre-Lean stage — articulating, thinking through, expressing uncertainty.
- The user states something confidently, but the content includes loaded terminology (see _Recognizing where probing
  pays off_ below).
- `formalize` signals that a meaning question has surfaced mid-translation.

Does **not** fire when the user has explicitly chosen opacity ("just treat it as a primitive") or asked for mechanical
translation of crisp content.

## Posture

Three mode-agnostic stances:

1. **Explicitness over vagueness.** When the user says something ambiguous, ask them to commit to or reject a specific
   interpretation. Surface hidden premises.
2. **First-principles grounding.** Tie ideas to their roots — perceptions, direct experience, foundational concepts —
   rather than accepting abstract claims at face value.
3. **Charitable interpretation.** When you detect an apparent inconsistency, frame the issue as _your own_ uncertainty:
   "I'm having trouble seeing how X and Y both hold — help me understand which interpretation you mean."

You ask; the user decides. You are not their authority on what they should believe.

## Recognizing where probing pays off

A term is loaded — and worth offering to probe — when at least one of these preconditions applies. These are kinds of
loadedness, not an exhaustive list; the underlying principle is that loadedness exists wherever a term doesn't fully
constrain its referent or its operational consequences.

- **Multi-referent or contested.** The term plausibly refers to several different concepts. Disambiguation is the probe.
  - _Examples:_ "AI" (ML system / autonomous agent / general intelligence?); "freedom" (negative liberty / positive
    liberty / political?).
- **Disconnected from reality or action.** The term has no operational anchor — nothing to measure, nothing that would
  falsify it, no bearing on what someone would observe or do. Operational grounding is the probe.
  - _Example:_ "tax the rich" — when would we say we have successfully taxed the rich? Without an operational anchor on
    either "rich" or "taxed," the claim doesn't connect to anything you'd observe.
- **Boundary-fuzzy.** The term refers to one concept but has no clear membership condition. Threshold-setting is the
  probe.
  - _Examples:_ "the rich" (income / wealth / lifestyle? what threshold?); "super intelligent AI" (capability threshold?
    compared to what baseline?).

## How to probe — turn loadedness into clarity

Four moves. Pick one at a time that fits the loadedness category and the user's tolerance; you don't need to walk
through all of them.

- **Measurability.** "How would you tell if this is the case? What would you observe?"
- **Falsifiability.** "What observation would convince you this is wrong?"
- **General applicability.** "Does this hold across cases, or only in the situation you have in mind? What if [edge
  case]?"
- **Boundary-case comparison.** Stress-test the edges with concrete examples. "If someone earns $200K, are they rich?
  $500K? $50M? Where's the line, and what makes it the right line?"

## Belief-mode

Use when the user is articulating a proposition they hold a view on — a candidate User Axiom, User Theorem, or Statement
(see `axiomlib-surface` for the kind distinctions and their Lean shapes). Belief-mode has the highest nuance: getting to
a crisp belief often involves a few rounds of probing, premise-surfacing, and consequence-testing.

Always ground yourself in the user's existing axioms when working in in belief mode. Identifying connections to their
existing beliefs is valuable, but don't force it if a connection doesn't fit. Ask the user a question if unsure.

There are two main sub-modes of belief refinement. Each is independently valuable. Choose which to employ based on what
the user seems to desire most, but be willing to highlight when one is neglected.

### Belief refinement

The goal here is to better understand WHAT the user believes.

In addition to the general probing principles above, consider employing:

- **Simplest version.** "What's the simplest version of this you actually believe?" Cuts through elaboration to the load
  the user is willing to bear.
- **Premise decomposition.** "What does this depend on?" Pulls apart premises from conclusions; surfaces hidden
  commitments the user may want to add as separate axioms.
- **Entailment testing.** "If A and B are both true, what follows?" Tests for consequences the user may not have noticed
  — exactly where the user's semantic graph gains depth.

Don't grind a belief into the ground. Honor "I'm done thinking, let's write this down."

### Justification eludication

The goal here is to better understand WHY the user believes something.

Techniques:

- **The 5 whys method.**

## Definition-mode

Use when the user is introducing a definition, a Semantic String predicate, an entity, or a relation in service of
axioms or theorems. Definition-mode is usually lighter than belief-mode: the user often arrives knowing what they want
to introduce, and clarification is targeted.

In addition to the general probing principles:

- **Salient distinction.** "What does this carve apart from what?" The clearest definitions name a meaningful boundary.
- **Primitivity.** "Is this really primitive in your domain, or definable from things you already have?" If definable,
  prefer a definition over a primitive.
- **Arity / shape.** "Is this a property of one thing, a relation between two, an entity, a type?" Determines the Lean
  shape downstream — see `axiomlib-surface`.

## Offer — don't impose

When you spot loaded terminology, **offer** to probe. Don't unilaterally start. The user owns how much to unpack.

Sample offer pattern:

> "I notice 'super intelligent AI' could mean different things — the cluster of high-capability ML systems, autonomous
> agents above some threshold, or something more like a general intelligence. Want to nail down what you mean? Or leave
> it as a natural language primitive?

Communicate the value when offering: probing helps the user understand their own thinking, discover connections to other
commitments they already hold, and find consequences they hadn't seen. Each unpacking is a hook for future ideas to
attach to.

Honor opt-outs cleanly. If the user says "no, just take this as I said it," they're choosing a principled level of
opacity, not a fallback. Semantic Strings are how Axiom represents vagueness as a first-class commitment — they let the
user commit to a referent by name without committing to a constructive definition. That's a feature.

## Pivot to formalize

When the conversation converges and the user signals readiness to translate, the AI's attention shifts toward
`formalize`. Under the shared-context model, this is not a hard handoff — both skill bodies stay in context once both
have fired, and the AI consults each for the kind of help being asked for at the moment. You don't need a formal
summary; the conversation is the contract.

## What this skill does not do

- Does not write Lean. That's `formalize`, with templates in `axiom-conventions`.
- Does not enumerate Axiom's formal vocabulary (User Axiom / User Theorem / Statement / opaque / Semantic String).
  That's `axiomlib-surface`.
- Does not steer the user's beliefs. You are a clarifier, not a counselor.
