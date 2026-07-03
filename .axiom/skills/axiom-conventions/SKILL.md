---
name: axiom-conventions
description: Information about how to write Axiom-flavored Lean, and IDs (for use with `axm fetch`) of conventional content. Recommended reading before writing any Lean code.
---

# Axiom conventions

This skill describes how to write Axiom-idiomatic Lean code. It also includes descriptions of coventional approaches to
achieve certain things. This skill is most helpful for new users or users without experience with formal logic. Power
users many times should depart from these conventions based on their particular goals.

Making the most of this file relies on using `axm modeling-refs` and pro-active in `axm fetch`ing files containing the
conventional definitions and exemplars. For the various topics in this skill, the relavant modeling-ref slugs are called
out inline with a `ref: <slug>`.

## Naming conventions

Axiom roughly follows the Lean naming conventions. In short:

- File names, namespaces, inductive types, structures, and classes: UpperCamelCase.
- Data: lowerCamelCase.
- Proofs and axioms: snake_case.
- Functions are named based on their return type. That means any function to `Prop` is UpperCamelCase.

For ontological concepts this translates as follows:

- UpperCamelCase for universals, particulars, and named `Prop`s.
- lowerCamelCase for local particulars and constructors.
- snake_case for axioms, premises, and `Prop` valued structure fields.

## Actuality, possibility, and necessity.

`Axiom.Actual`: Alethic modal logic is not a default provided by Axiom. Instead, the platform provides only an actuality
operator, `Axiom.Actual : Type u → Prop`. Axiom's philosophical recommendation is that `Actual p` should hold when `p`
affects the actions of the Formal Identity that commits to it (per the Latin actualis = "pertaining to action"). This
allows the distinction of what is necessarily or mathematically true (`p`) from what is contigently and actually true
(`Actual p`). `Actual` can also be applied to things other than `Prop`s. This gives users flexibility in how they use
the operator, but for the purposes of the conventions described in this file, only `Actual (p : Prop)` is used.

By default, `Axiom.Actual` has no semantics. We recommend users adopt `LogicIsActual` from `ref: actual-bridge` and the
`A` notation from `ref: actual-notation`.

Users are free to extend the actuality operator with a full modal logic theory.

## Ontology

Axiom's ontological theory recommendation is to adopt `axiom bfo : A BFO` (`ref: bfo`) and then use the macro library
provided by `ref: universals-and-relations`.

This ontology is single-sorted at it's core: particulars, universals, and times are all terms of type `Type` in Lean,
distinguished only by which classifying predicates the author asserts. Facts about said entities are `Prop`s. This
mirrors how BFO and other formal ontologies are encoded in KIF/CLIF.

To make this single-sorted approach more ergonomic in Lean, you should use the `ref: universals-and-relations` library
to define domain classes and relationships.

Here is an example (see `ref: child-murder-punishment` for the full example):

```lean
rigid universal Person extends Object := "person"
universal Child extends Person := "child"
rigid universal Murder extends Process := "murder"
rigid universal PunishmentSpecification extends GenericallyDependentContinuant := "punishment specification"

relation MurdersIn : Person → Person → Murder := "murders in"
relation DeservesPunishmentFor : Person → Process → PunishmentSpecification :=
  "deserves punishment specification for"
relation GreaterPunishmentThan : PunishmentSpecification → PunishmentSpecification := "is greater than"
relation NonAgePunishmentRelevantCircumstances : Murder := "punishment relevant circumstances other than victim's age"

structure MurderCase where
  murder : Murder
  murderer : Person
  victim : Person
  punishment : PunishmentSpecification
  murders_in :
    MurdersIn murderer victim murder
  deserved_punishment :
    DeservesPunishmentFor murderer murder punishment

def VictimIsChild (mc : MurderCase) :=
  ∃ t, Child.At mc.victim t ∧ ProcessOccupiesTemporalRegion mc.murder t

def SameNonVictimAgeCircumstances (mc1 mc2 : MurderCase) :=
  (NonAgePunishmentRelevantCircumstances mc1.murder) ↔ (NonAgePunishmentRelevantCircumstances mc2.murder)

def ChildMurderDeservesGreaterPunishmentThanNonChildMurder : Prop :=
  ∀ mc1 mc2 : MurderCase, SameNonVictimAgeCircumstances mc1 mc2 →
    VictimIsChild mc1 → ¬ VictimIsChild mc2 →
      GreaterPunishmentThan mc1.punishment mc2.punishment
```

Behind the scenes, these macros define a `Subtype` over `Type` and adds coercions and other helper functions. The
difference between `rigid universal` and plain `universal` is particularly important to get right. Defining a
`rigid universal` allows you do e.g. `(person : Person)` because a `Person` term is an `InstanceOf` the `Person.U`
universal at all times, but a plain `universal` is only guarenteed to be an instance of that universal at some time. If
you need more details, inspect the macros in the fetched `ref: universals-and-relations` file.

These declarations can then be used in actual situations:

```lean
def Murderer : Type := "The Marjory Stoneman Douglas High School shooter"
def ChildVictim : Type := "Alyssa Alhadeff"
def ChildMurder : Type := "the murder of Alyssa Alhadeff"
def ChildCasePunishmentSpec : Type :=
  "the punishment specification deserved for the murder of Alyssa Alhadeff"

def AdultVictim : Type := "Chris Hixon"
def AdultMurder : Type := "the murder of Chris Hixon"
def AdultCasePunishmentSpec : Type :=
  "the punishment specification deserved for the murder of Chris Hixon"

structure TwoConcreteMurderCases : Prop where
  child_case_involvement :
    MurderInvolves ChildMurder ChildVictim Murderer
  child_case_deserved_punishment :
    DeservesPunishmentFor Murderer ChildCasePunishmentSpec ChildMurder
  child_case_victim_is_child :
    ∃ t, Child.At ChildVictim t ∧ ProcessOccupiesTemporalRegion ChildMurder t
  non_child_case_involvement :
    MurderInvolves AdultMurder AdultVictim Murderer
  non_child_case_deserved_punishment :
    DeservesPunishmentFor Murderer AdultCasePunishmentSpec AdultMurder
  non_child_case_victim_is_not_child :
    ¬ ∃ t, Child.At AdultVictim t ∧ ProcessOccupiesTemporalRegion AdultMurder t
  same_non_victim_age_circumstances :
    MurderCircumstancesRelevantToTheDeservedPunishmentOtherThanVictimAge ChildMurder ↔
      MurderCircumstancesRelevantToTheDeservedPunishmentOtherThanVictimAge AdultMurder

theorem child_case_deserves_greater_punishment
    (logic_is_actual : LogicIsActual)
    (principle : A ChildMurderDeservesGreaterPunishmentThanNonChildMurder)
    (cases : A TwoConcreteMurderCases) :
    A (IsGreaterPunishmentThan
      ChildCasePunishmentSpec
      AdultCasePunishmentSpec) := by ...
```

And users can adopt those premises as user axioms to have the conclusion follow:

```lean
user_axioms {
  axiom logic_is_actual : LogicIsActual
  ...
  axiom : child_victim_greater_murder_punishment : A ChildMurderDeservesGreaterPunishmentThanNonChildMurder
  axiom : school_shooting : A TwoConcreteMurderCases
}
```

Another good example is `ref: declaration-of-independence`.

## Axiomatic definitions

In general, Axiom prefers utilizing Semantic Strings for defining concepts, unless it's explicitly mathematical concept.
Utilizing Semantic Strings enables definitions to evolve over time as users define User Axioms about them. In Lean,
`opaque` declarations typically fulfill this role, but `opaque` and `axiom` declarations are not allowed in Axiom, so
Semantic Strings should be used instead.

## Semantic strings

Semantic strings allow users to refer to concepts by name, using English-flavored string literals that coerce to typed
`Prop`s or `Type`s, rather than defining them constructively. This serves two main purposes:

- **Irreducible Vagueness:** Capturing real-world concepts (e.g. `"apple"`, `"loves"`) that bottom out in natural
  language and do not reduce cleanly to mathematical primitives.
- **Scaffolding and Scoping:** Allowing novices or authors focusing on high-level argument flow to draft theorems and
  construct proofs before they are ready or able to write formal constructive definitions for the constituent
  predicates.

Because identical `(α, s)` pairs resolve to the same kernel-level opaque constants, different users can commit distinct
axioms to the same semantic concept. This allows meanings to be cooperatively and incrementally constrained over time
without requiring upfront coordination or shared imports.

The ontological examples above rely heavily on them, but you can also use them outside of those macros by having a
String coerce to some other type (e.g. `("is red" : Apple → Prop)` or `("Sam Cymbaluk" : Type)`).

By convention, Semantic strings do not capitalize the beginning of a sentence, but do contain capital letters for proper
nouns. Punctuation can be part of a semantic string, but periods are omitted for single sentences, and semantic strings
with multiple sentences are generally a smell.

## Notation

Custom notation is how propositions come to read like natural language, but it is easy to get wrong. The conventions
here are an interim safe subset; richer conventions are work in progress.

- Prefer `infix`, `infixl`, `infixr`, `prefix`, and `postfix`. Plain `notation` is acceptable when its right-hand side
  is linear (each variable used once, in left-to-right order). Lean's pretty-printer automatically renders only these
  linear forms; anything else parses but displays desugared to readers.
- Do not define `macro`, `syntax` + `macro_rules`, or binder notations unless the user is an experienced Lean user who
  explicitly wants them.
- Write multi-word operators in kebab-case: `infix:50 " taller-than " => TallerThan`. A spaced atom like
  `" taller than "` reserves each word as a keyword token, shadowing those identifiers for everyone who opens the file;
  a kebab-case token cannot collide with any identifier. Avoid single common words and Lean reserved words as atoms.
- Use precedence 50 for word relations — the band Lean core uses for `=` and `<`. At 50, `x taller-than y ∧ P` parses as
  `(x taller-than y) ∧ P`, matching the natural reading.
- Prefer words over invented Unicode operators (`≺`, `⊑`) unless it matches existing domain conventions.
- Derive the operator token from the concept's semantic string:
  `relation TallerThan : Person → Person := "is taller than"` pairs with `taller-than`.
- Parenthesize infix propositions under `A` — write `A (x taller-than y)` — rather than relying on precedence.
- Do not write `scoped` yourself; the publish transform promotes top-level notation automatically. If two opened files
  define the same token, uses become ambiguous and error at the use site; resolve by opening only one of them.

## UserAxioms vs Statements

The two methods for publishing user-attributed formal content are `UserAxioms` and `Statement`s. `UserAxioms` contain
`Prop`, but `Statements` can contain any type. User axioms are assertoric. The web profile treats the snapshot as the
user's standing commitments and surfaces theorems downstream of them. Statements are attributional. Publishing one says
"I, at time t, emitted this term of type T." T can be a Prop, a Nat, a function, a proof artifact — the act of
statementing doesn't endorse the Prop, it just stamps authorship. For example, a user might state `p : Prop`
_sarcastically_. This would not be possible with `UserAxioms`. Because statements are first-class authenticated values,
another axiom (yours or someone else's) can quantify over `Statement u p` and treat its existence as evidence for
`hp : p`. This implies that users can choose to assert beliefs indirectly by writing axioms about `Statement`s and then
making statements. No convention yet exists for whether assertions should be directly within `UserAxioms` or indirectly
via `Statement`s. Users are encouraged to do what works for them.

## BFO compatibility

When formalizing ideas about real-world objects, strive to maintain BFO compatibility. For things outside of BFO's
typical domain, such as deontic concepts, layering on top of BFO compatible objects is standard (e.g.
`relation Love : Type → Type := "love"` or `relation Ought : Agent → Prop`).

## Time

Time should be defined in a BFO-compatible way. See `ref: bfo` for details.

## Hypotheticals

Hypotheticals have many different representations in logic including modal logic. Because Axiom doesn't want to ship
with Alethic modal logic, we encode hypotheticals using a structure representing an alternative world state. See
`ref: hypothetical-world`.

## Identify prior art

The `axm` CLI has a rich search functionality. Before attempting to formalize something, it is the best practice to
search Axiom for files that already formalize something similar. This allows you to either reuse existing code that fits
your use case or fork something that is close but not exactly right. You shouldn't fork something just to fork
something. It often makes sense to start from scratch.

## Externally authored lean

Axiom does not ship with Mathlib or any dependencies other than the Lean stdlib and AxiomLib. If the user is referencing
a concept that exists already in Mathlib or some other Lean package, you can grab that code and put it in a local
workspace file so the user can use it. You will likely have to perform some modifications to ensure it is compliant with
the Axiom lean validation rules. Do your best to add attribution comments when utilizing externally authored Lean code.

## Code Comments

Use code comments extremely sparingly. The purpose of Axiom is to communicate using logic. Comments are often
antethetical to this ethos. Adhere to this principle despite the fact that many of the example files referenced below
contain code comments. Those comments are there to educate you, and are not meant to be illustrative of how user content
should be authored.
