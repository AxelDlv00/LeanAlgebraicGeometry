/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffFunctorCompare
import AlgebraicJacobian.Picard.DivSchemeAbel
-- The two declarations this file's docstrings reason ABOUT rather than use:
-- `isCertified_affine_and_not_isCertified_chart` (the R2 strictness payoff, which is WHY the
-- widened carrier has to reach the Picard side at all) and `abelSigmaChart` (the consumer that
-- takes a CHART-TYPED representation, which is what it cannot currently reach). Imported so
-- every cited name is in this file's import closure and `#check`s here rather than merely
-- being greppable elsewhere -- measured on the first version of this header, which cited both
-- out of scope (the recurring failure recorded at I-1073).
import AlgebraicJacobian.Picard.DivisorFamilyAffStrict
import AlgebraicJacobian.Picard.Pic0AtlasFromDivRep

/-!
# THE ABEL HOOK ON THE R2 CARRIER: `DivFamZarAff` acquires a Picard class in `picEt`

Protection `I-0492` mandates the **widened** carrier — `DivFamZarAff`, certificates over
arbitrary affine-open covers — and `isCertified_affine_and_not_isCertified_chart`
(`Picard/DivisorFamilyAffStrict.lean`) proves the widening is *strict*: a straddling connected
divisor is certified on the widened side and on **no** chart-typed adaptation, in any degree.

Measured at HEAD before writing this file (declaration index, plus a case-insensitive grep so
that producers in suffix position are not missed — memory `I-1005`): the widened carrier had a
class map (`DivFamZarAff.picClass`) and its two naturalities, a functor (`divFunctorAff`) and a
comparison (`divFunctorToAff`) — and **zero** declarations carrying it to `PicEtAff`, `picEt`,
`relPic` or `pic0`.  The whole Abel layer (`abelDivPlus`, `abelDivAff`, `abelDiv`,
`abelDivTrans`, `chartValue`, `DivFamZar.classDeg_picClass`) is stated at `DivFamZar` alone
(`Picard/DivSchemeAbel.lean`); of the 25 files mentioning `DivFamZarAff`, none composed it with
the unit of the plus construction.

That gap is why the two halves of the DD-R lane cannot meet.  `abelSigmaChart`
(`Picard/Pic0AtlasFromDivRep.lean:205`) takes `rep : (divFunctor C π n).RepresentableBy D` — the
**chart-typed** functor — and composes it through `chartValueTrans`/`chartValue`/`abelDiv`.  So
the only Σ-atlas the tree can build is built from a representation of `divFunctor`, while the
carrier the human's decision mandates is `divFunctorAff`.  A widened representability datum,
had anyone one, could not have reached the atlas at all.

## What this file lands, and what it does NOT

It lands the Abel hook on the widened carrier: the composite
`PicEtAff.unit ∘ relPicMk ∘ DivFamZarAff.picClass`, its naturality in the test algebra, its
lift to an arbitrary test object through the widened vehicle, and naturality there.  Every step
is the chart-typed proof with `DivFamZarAff` in place of `DivFamZar`; nothing is new
mathematics, and that cheapness is the finding — the gap was a missing transcription, not a
missing theorem.

**No certificate is produced and no gate is cleared.**  In particular this does *not* prove the
widened functor representable, does not discharge `rep` (antecedent 3 of
`pic0RepresentableByOfCharts`), and does not weaken the straddling no-go.  `π` is still carried
as a section variable everywhere the chart-typed statements carry it, because the *comparison*
`DivFamZar.toAff` needs it even though the widened carrier itself does not.

## The compatibility that makes this consistent with the chart-typed layer

`abelDivAffPlus_toAff` records that the widened hook applied to the image of a chart-typed
class is the chart-typed hook: the two Abel values agree, because `DivFamZarAff.picClass_toAff`
says the widening does not move the Picard class.  So this is an *extension* of the existing
Abel layer along `divFunctorToAff`, not a second incompatible one.

## Main declarations

* `AlgebraicGeometry.abelDivAffPlus` — the widened Abel transformation at an affine test.
* `AlgebraicGeometry.abelDivAffPlus_mapAlgHom` — its naturality in the test algebra.
* `AlgebraicGeometry.abelDivAffPlus_toAff` — agreement with the chart-typed hook.
* `AlgebraicGeometry.abelDivAff'` — the widened Abel transformation at an arbitrary test.
* `AlgebraicGeometry.picEtMap_abelDivAff'` — its naturality in the test object.
-/

set_option autoImplicit false
/- Statements mix `Γ(relCurve C R, ·)` with opens produced on the product spelling; see
`AlgebraicJacobian.Cohomology.RelativeSectionsLinear`. -/
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161), so the pinned synthesis depth
must be set in-file for the faithful per-file check. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory MonoidalCategory CartesianMonoidalCategory Opposite

namespace AlgebraicGeometry

attribute [local instance] Over.sectionsAlgebra Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))} [IsProper C.hom] {n : ℕ}

noncomputable section

/-! ## The widened Abel transformation at an affine test -/

section AbelAff

variable (C) in
/-- **The Abel transformation of a widened locally certified class at an affine test**: the
étale-unit image of the relative Picard class of `𝒪(F₀)`.

Verbatim `abelDivPlus` (`Picard/DivSchemeAbel.lean`) with `DivFamZarAff` in place of
`DivFamZar` — the class map `DivFamZarAff.picClass` is all that is consumed, and it never saw
the cover, so no chart typing enters. -/
def abelDivAffPlus (A : Type u) [CommRing A] [Algebra k A] (F₀ : DivFamZarAff C A n) :
    PicEtAff C A :=
  PicEtAff.unit C A (relPicMk C (overSpec k A) F₀.picClass)

/-- **Naturality of the widened affine Abel transformation in the test algebra**
(`DivFamZarAff.picClass_mapAlg` + `PicEtAff.mapAlg_unit`): base change of the widened Abel
value is the Abel value of the base-changed class. -/
theorem abelDivAffPlus_mapAlgHom {A B : Type u} [CommRing A] [Algebra k A] [CommRing B]
    [Algebra k B] (φ : A →ₐ[k] B) (F₀ : DivFamZarAff C A n) :
    PicEtAff.mapAlg C φ (abelDivAffPlus C A F₀)
      = abelDivAffPlus C B (DivFamZarAff.mapAlgHom φ F₀) := by
  letI : Algebra A B := φ.toRingHom.toAlgebra
  haveI : IsScalarTower k A B := .of_algebraMap_eq fun a => (φ.commutes a).symm
  have hclass : (DivFamZarAff.mapAlgHom φ F₀).picClass
      = Scheme.CechPic.map (C ◁ Over.overSpecMap φ).left F₀.picClass := by
    have hcurve : relCurveMap C A B = (C ◁ Over.overSpecMap φ).left := by
      refine congrArg (fun ψ : overSpec k B ⟶ overSpec k A => (C ◁ ψ).left) ?_
      exact Over.OverMorphism.ext rfl
    rw [← hcurve]
    exact DivFamZarAff.picClass_mapAlg B n F₀
  calc PicEtAff.mapAlg C φ (abelDivAffPlus C A F₀)
      = PicEtAff.unit C B (relPicAlgMap C φ
          (relPicMk C (overSpec k A) F₀.picClass)) := PicEtAff.mapAlg_unit C φ _
    _ = PicEtAff.unit C B (relPicMk C (overSpec k B)
          (Scheme.CechPic.map (C ◁ Over.overSpecMap φ).left F₀.picClass)) :=
        congrArg (PicEtAff.unit C B)
          (relPicMap_mk C (Over.overSpecMap φ) F₀.picClass)
    _ = abelDivAffPlus C B (DivFamZarAff.mapAlgHom φ F₀) := by
        rw [abelDivAffPlus, hclass]

omit [IsProper C.hom] in
/-- **The widened hook extends the chart-typed one along `DivFamZar.toAff`**: the widened Abel
value of the image of a chart-typed class is the chart-typed Abel value.

This is what makes the file an *extension* of `Picard/DivSchemeAbel.lean` rather than a second,
incompatible Abel layer: `DivFamZarAff.picClass_toAff` says the widening does not move the
Picard class, and both hooks are `unit ∘ relPicMk` of that class. -/
theorem abelDivAffPlus_toAff {A : Type u} [CommRing A] [Algebra k A]
    {π : C.left ⟶ P1 k} [IsAffineHom π] (F₀ : DivFamZar C A π n) :
    abelDivAffPlus C A F₀.toAff = abelDivPlus C π A F₀ := by
  rw [abelDivAffPlus, abelDivPlus, DivFamZarAff.picClass_toAff]

end AbelAff

/-! ## The widened Abel transformation at an arbitrary test -/

section AbelVehicle

/- `picEtMap` (`Picard/PicEtMap.lean:206-207`) carries these two beyond `[IsProper C.hom]`; they
are hypotheses of the whole DD-R lane, so this costs no generality, but they are stated rather
than inherited silently. -/
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

variable (C n) in
/-- **The Abel transformation of a widened class at an arbitrary test object**: componentwise
over the affine opens of the test, compatible by `abelDivAffPlus_mapAlgHom`.

Verbatim `abelDiv` (`Picard/DivSchemeAbel.lean`) on the widened vehicle. -/
def abelDivAff' (T : Over (Spec (.of k))) (s : divFamZarAff C n T) : picEt C T :=
  ⟨fun U => abelDivAffPlus C Γ(T.left, U.1) (s.1 U), fun U V h => by
    rw [abelDivAffPlus_mapAlgHom (Over.resAlgHom T h) (s.1 V), s.compat U V h]⟩

omit [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom] in
@[simp]
lemma abelDivAff'_val (T : Over (Spec (.of k))) (s : divFamZarAff C n T)
    (U : T.left.affineOpens) :
    (abelDivAff' C n T s).1 U = abelDivAffPlus C Γ(T.left, U.1) (s.1 U) :=
  rfl

/-- **Naturality of the widened Abel transformation in the test object**: restriction of the
widened Abel value along an arbitrary test morphism is the widened Abel value of the restricted
family.

The chart-typed proof (`picEtMap_abelDiv`) transported: both glued restrictions are pinned by
their `∃!`-characterizations, and the widened one is `divFamZarAff.mapVal_spec`. -/
theorem picEtMap_abelDivAff' {T T' : Over (Spec (.of k))} (f : T' ⟶ T)
    (s : divFamZarAff C n T) :
    picEtMap C f (abelDivAff' C n T s) = abelDivAff' C n T' (divFamZarAff.map C n f s) := by
  refine picEt.ext fun W => ?_
  rw [picEtMap_val]
  refine picEtMapVal_eq_of C f (abelDivAff' C n T s) ?_
  intro W₀ hW₀ V hV
  rw [abelDivAff'_val, abelDivAff'_val, divFamZarAff.map_val,
    abelDivAffPlus_mapAlgHom (Over.resAlgHom T' hW₀) (divFamZarAff.mapVal C n f s W),
    abelDivAffPlus_mapAlgHom (Over.appLEAlgHom f V.1 W₀.1 hV) (s.1 V),
    divFamZarAff.mapVal_spec C n f s W W₀ hW₀ V hV]

end AbelVehicle

/-! ## The widened chart value, and the ONE statement still owed

`chartValue` (`Picard/DivSchemeAbel.lean`) twists the Abel value into degree zero, and its
`pic0Subgroup` membership is `degAt_chartValue` plus the chart-index degree constraint.  The
widened analogue of the twist is free — it is the same product in `picEt C T`, whose factors
`sigmaFamily`/`thetaFamily` never saw a divisor cover at all.  What is **not** free is the
degree ledger: `degAt_abelDiv` rests on `DivFamZar.classDeg_picClass`, whose proof runs through
the field collapse `DivFam.exists_toZar_eq` and the CRT identity `deg_divFamDivisor`, and the
degree half of that chain (`DivisorAdaptation.deg_presentationDivisor_eq_finrank_glued`) consumes
`relCover_sup` together with `cover₀`/`cover₁` — the pinned-pair structure R2 removes.

Measured, not assumed: there is no widened analogue of `finrank_glued_eq_sum_of_separated`,
`subsingleton_ovlColength_of_sep`, `finrank_colength_eq_sum` or `coeffAt_eq_zero_of_isUnit_germ`
anywhere in the `DivisorFamilyAff*` family.  The widened `AffAdaptation` *does* carry the whole
module layer these would be about (`colength`, `ovlColength`, `gluedSubmodule`, `Glued`,
`IsCertified` clause for clause), so the obstruction is a missing transcription of the degree
argument, not a missing structure — but the transcription is not free, because the chart-typed
proof spends the two-chart covering where the widened one has only a joint `⨆ j, pieces j = ⊤`.

So the degree ledger is stated below as an explicit hypothesis `hdegAff` on the widened Abel
transformation, at exactly the shape `degAt_abelDiv` has.  It is **not** discharged here, and it
is **not** hidden inside a class whose statement omits the objects: it mentions the curve, the
widened section, the field point and the degree.  A `sorry` would have been dishonest in the
other direction — this way the obligation appears in every consumer's signature. -/

section ChartValueAff

/- Beyond the vehicle's instances, the TWIST factors need the curve's geometry: `sigmaFamily`
and `thetaFamily` (`Picard/DivSchemeAbel.lean` §Sigma, `Picard/ThetaShift.lean`) carry
`[SmoothOfRelativeDimension 1 C.hom]` and `[GeometricallyIrreducible C.hom]`.  All are standing
DD-R hypotheses; they are named here rather than inherited. -/
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
  [SmoothOfRelativeDimension 1 C.hom]

variable (C n) in
/-- **The widened chart value**: the widened Abel value shifted by the Σ-family and `m` inverse
powers of the pinned θ-family — verbatim `chartValue` with `abelDivAff'` in place of `abelDiv`.

The twist itself is cover-free: `sigmaFamily` and `thetaFamily` are built from Čech classes on
the base-changed curve and know nothing of a divisor cover, so the widening does not touch
them. -/
def chartValueAff (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s : divFamZarAff C n T) : picEt C T :=
  abelDivAff' C n T s * sigmaFamily C Z T
    * (thetaFamily C (thetaCechClass C) T ^ m)⁻¹

variable (C n) in
/-- Naturality of the widened chart value in the test object — `picEtMap_abelDivAff'` together
with the two naturalities of the twist factors. -/
theorem picEtMap_chartValueAff (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {T T' : Over (Spec (.of k))} (f : T' ⟶ T) (s : divFamZarAff C n T) :
    picEtMap C f (chartValueAff C n m Z T s)
      = chartValueAff C n m Z T' (divFamZarAff.map C n f s) := by
  rw [chartValueAff, chartValueAff, map_mul, map_mul, map_inv, map_pow, picEtMap_abelDivAff',
    sigmaFamily_natural, thetaFamily_natural]

omit [GeometricallyReduced C.hom] in
variable (C n) in
/-- **The widened chart value lands in `pic0`, GIVEN the widened degree ledger.**

`hdegAff` is the widened form of `degAt_abelDiv` and it is the single statement this file does
not prove: *the widened Abel value of a degree-`n` widened class has degree `n` at every field
point*.  Read the dependency honestly — the chart-typed ledger goes through
`DivFamZar.classDeg_picClass`, whose degree half consumes the pinned-pair covering
(`relCover_sup`, `cover₀`/`cover₁`) that R2 deletes, so this is a genuine obligation and not
bookkeeping.

Everything else in the degree-zero-ness argument transports unchanged: the three degrees still
sum to zero under the chart-index constraint, because the twist factors are cover-free. -/
theorem chartValueAff_mem_pic0Subgroup (m : ℕ)
    (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (T : Over (Spec (.of k))) (s : divFamZarAff C n T)
    (hdegAff : ∀ {K : Type u} [Field K] [Algebra k K] (t : overSpec k K ⟶ T),
      degAt (abelDivAff' C n T s) t = (n : ℤ)) :
    chartValueAff C n m Z T s ∈ pic0Subgroup C T := by
  rw [mem_pic0Subgroup_iff]
  intro K _ _ t
  rw [chartValueAff, degAt_mul, degAt_mul, degAt_inv, degAt_thetaFamily_pow,
    degAt_sigmaFamily, hdegAff t, hdeg]
  ring

omit [GeometricallyReduced C.hom] in
/-- **The widened ledger holds on the image of a chart-typed class** — so the hypothesis of
`chartValueAff_mem_pic0Subgroup` is not vacuous: it is inhabited at every widened section that
comes from a chart-typed one, by `degAt_abelDiv` transported along `abelDivAffPlus_toAff`.

This is deliberately *not* offered as evidence that the general ledger holds.  It says the
obligation has witnesses, which is what distinguishes a real hypothesis from an unsatisfiable
one; the open question is whether it holds for a widened class with no chart-typed preimage,
which is exactly the class the R2 widening exists to admit. -/
theorem degAt_abelDivAff'_toAff {π : C.left ⟶ P1 k} [IsFinite π]
    {T : Over (Spec (.of k))} (s : divFamZar C π n T) {K : Type u} [Field K] [Algebra k K]
    (t : overSpec k K ⟶ T) :
    degAt (abelDivAff' C n T (divFamZarToAffVehicle C n π s)) t = (n : ℤ) := by
  have hval : abelDivAff' C n T (divFamZarToAffVehicle C n π s) = abelDiv C π n T s := by
    refine picEt.ext fun U => ?_
    rw [abelDivAff'_val, abelDiv_val, divFamZarToAffVehicle_val, abelDivAffPlus_toAff]
  rw [hval, degAt_abelDiv]

end ChartValueAff

end

end AlgebraicGeometry
