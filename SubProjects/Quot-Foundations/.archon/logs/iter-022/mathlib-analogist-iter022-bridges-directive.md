# Mathlib-analogist directive — iter-022 load-bearing-lemma verification

## Mode: api-alignment

Two independent load-bearing Mathlib facts must be verified BEFORE two prover lanes
are dispatched. A progress-critic returned GF CHURNING and FBC STUCK; for both, the
named corrective is "confirm the load-bearing Mathlib lemma exists with the right type
before the next prover round." For EACH question below report: (a) does the named
Mathlib declaration exist (give the exact current name + module path + signature);
(b) does its type unify with the project goal shape described; (c) if it does not exist
as named, what is the canonical Mathlib idiom for the same thing (name it precisely),
or confirm it must be built project-side and sketch the cheapest construction.

Write a persistent `analogies/<slug>.md` per question so the provers can read the result.

---

## Question 1 (GF) — ring-localization ↔ module-localization bridge

**Context.** Closing `genericFlatnessAlgebraic` (generic flatness, algebraic core) bottoms
out at a step that needs to identify, for a commutative ring `C` that is an `A`-algebra and
an element `g : A`:

  the localized MODULE `LocalizedModule (Submonoid.powers g) C`
    (`C` localized at the powers of `g`, viewed as a module localization)

  with the localized RING `Localization.Away (algebraMap A C g)`
    (`C` localized away from the image of `g` in `C`, as a ring).

These two should be canonically isomorphic (as `C`-algebras / as modules over the localized
ring), because both are `IsLocalizedModule (Submonoid.powers g)` / `IsLocalization` objects for
the SAME submonoid (powers of `g`, resp. its image). The project wants either:
  - a NAMED Mathlib iso `LocalizedModule (powers g) C ≃ₗ Localization.Away (algebraMap A C g)`
    (or `≃ₐ`), OR
  - the `IsLocalizedModule`/`IsLocalization`-uniqueness route that produces it in one step.

Please determine the canonical Mathlib idiom. Candidate API families to check and report on:
  - `IsLocalizedModule.iso` / `IsLocalizedModule.linearEquiv` / `LocalizedModule.lift` uniqueness.
  - `IsLocalization.algEquiv` / `IsLocalization.uniqueUpToIso` between two `IsLocalization` objects
    for the same submonoid.
  - whether `Localization.Away (algebraMap A C g)` is *definitionally* / instance-wise an
    `IsLocalizedModule (Submonoid.powers g) C` (so the bridge is just `IsLocalizedModule.iso`
    of the powers submonoid), and whether `Submonoid.powers (algebraMap A C g) =`
    `(Submonoid.powers g).map (algebraMap A C)` is the relevant submonoid identity.
  - the `Algebra.id` / scalar-tower instances needed for the two localizations to live over the
    same base so the iso typechecks.

Goal output: name the exact lemma(s)/idiom the GF prover should use to discharge step (4)
of the cascade, with the precise Mathlib names and the submonoid-identity lemma if one is needed.

`analogies/<slug>.md` slug suggestion: `gf-localizedmodule-localization-away-bridge`.

---

## Question 2 (FBC) — `conjugateEquiv_counit_symm` type-unification

**Context.** Closing `base_change_mate_gstar_transpose` (the live FBC crux) is pinned to the
Mathlib lemma the prover identified:

  `CategoryTheory.conjugateEquiv_counit_symm`
  (reported at `Mathlib/CategoryTheory/Adjunction/Mates.lean:287`), stated as:
  `L₂.map (α.app _) ≫ adj₂.counit.app d = ((conjugateEquiv adj₁ adj₂).symm α).app _ ≫ adj₁.counit.app d`.

This is the COUNIT companion (dual) of `CategoryTheory.unit_conjugateEquiv_symm`, which the
project already used successfully to close the Seam-1 unit coherence (`base_change_mate_unit_value`,
proved axiom-clean). The intended instantiation:
  - `adjL = (tilde.adjunction R).comp (pullbackPushforwardAdjunction (Spec.map ψ))`
  - `adjR = (ModuleCat.extendRestrictScalarsAdj ψ.hom).comp (tilde.adjunction R')`
  - `α    = gammaPushforwardNatIso ψ`,
  so `(conjugateEquiv adjL adjR).symm α = pullback_spec_tilde_iso ψ`.

Please verify:
  (a) `CategoryTheory.conjugateEquiv_counit_symm` exists in the current Mathlib under that name
      (or report its current name) and give its exact signature + hypotheses.
  (b) The dual relationship to `unit_conjugateEquiv_symm` is real (both are exported from
      `Adjunction/Mates.lean`) and the argument order / `Adjunction.comp` composition lemmas
      (`Adjunction.comp_counit_app`) needed to split the composite adjunction counits exist.
  (c) Whether the `conjugateEquiv adj₁ adj₂` direction matches what the project needs (the
      project wants `.symm α = pullback_spec_tilde_iso ψ` — confirm the variance/direction so the
      prover doesn't pick the wrong one of conjugateEquiv vs its symm).

This is an EXISTENCE + type-unification check, not a proof request. The proof route is already
documented; the critic only wants the pinned lemma confirmed against the literal goal shape
before another prover round.

`analogies/<slug>.md` slug suggestion: `fbc-conjugateequiv-counit-symm`.
