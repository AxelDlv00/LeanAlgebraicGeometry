/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffFunctorCompare
import AlgebraicJacobian.Picard.DivSchemeAbel

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

end AbelAff

end

end AlgebraicGeometry
