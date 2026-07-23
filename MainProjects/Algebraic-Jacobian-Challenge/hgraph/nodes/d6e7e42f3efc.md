---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.qcohRestriction_eq_comparison
docstring: '**Restriction = localisation comparison** (`def:qcoh_sections_localized`,
  item (5);

  the differential brick of step (c)).  For the standard sheaf `tilde M`, the presheaf

  restriction map between basic-open section groups `M_a → M_b` (along an inclusion

  `D(b) ⊆ D(a)`) is, as an `R`-linear map, the canonical away-localisation comparison

  `AwayComparison.comparison` — provided `a` acts invertibly on `M_b` (`Inverts a
  M_b`,

  which holds whenever `a ∣ b`, the {\v C}ech-face case).  Proved by the universal

  property `AwayComparison.comparison_unique`: both the restriction and the comparison

  are `R`-linear maps that recover `tilde.toOpen M (D b)` after precomposition with

  `tilde.toOpen M (D a)` (the restriction does so by `tilde.toOpen_res`).  Summed
  over

  the alternating signs, this identifies the section {\v C}ech differential with the

  module differential `SectionCechModule.dDiff`.'
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.qcohRestriction_eq_comparison
type: lean
updated: '2026-07-24T03:02:09'
---
lemma qcohRestriction_eq_comparison {R : CommRingCat.{u}} (M : ModuleCat.{u} R) {a b : R}
    (i : (PrimeSpectrum.basicOpen b : (Spec R).Opens) ⟶ PrimeSpectrum.basicOpen a)
    (hb : AwayComparison.Inverts a
      ((modulesSpecToSheaf.obj (tilde M)).presheaf.obj
        (Opposite.op (PrimeSpectrum.basicOpen b)))) :
    ((modulesSpecToSheaf.obj (tilde M)).presheaf.map i.op).hom
      = AwayComparison.comparison (AlgebraicGeometry.tilde.toOpen M (PrimeSpectrum.basicOpen a)).hom
          (AlgebraicGeometry.tilde.toOpen M (PrimeSpectrum.basicOpen b)).hom hb := by
  haveI : IsLocalizedModule (Submonoid.powers a)
      (AlgebraicGeometry.tilde.toOpen M (PrimeSpectrum.basicOpen a)).hom := inferInstance
  refine (AwayComparison.comparison_unique
    (AlgebraicGeometry.tilde.toOpen M (PrimeSpectrum.basicOpen a)).hom
    (AlgebraicGeometry.tilde.toOpen M (PrimeSpectrum.basicOpen b)).hom hb _ ?_).symm
  have h := AlgebraicGeometry.tilde.toOpen_res M (PrimeSpectrum.basicOpen a)
    (PrimeSpectrum.basicOpen b) i
  exact congrArg ModuleCat.Hom.hom h

/-! ## Project-local Mathlib supplement — section {\v C}ech homology bridge (L1 steps c, d)

The categorical→module bridge of `lem:section_cech_homology_exact`: the
`Ab`-valued section {\v C}ech complex `sectionCechComplex` (of `PresheafCech.lean`)
has its degree-`p` object a *categorical product* `∏ᶜ_σ F(⨅ₖ U (σ k))` in `Ab`, and
its differential the alternating sum of the {\v C}ech coface restrictions.  These
lemmas (c1)–(c3) move that abstract complex to the concrete localised-module complex
`SectionCechModule.dDiff` (whose positive-degree exactness `dDiff_exact` is step (a)),
and read off homology vanishing. -/

section SectionCechBridge

open CategoryTheory.Limits AlgebraicTopology

variable {X : Scheme.{u}}