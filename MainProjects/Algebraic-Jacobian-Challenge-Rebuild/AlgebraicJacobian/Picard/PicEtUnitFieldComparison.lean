/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.EffectivityClose
import AlgebraicJacobian.Picard.PicEtUnit

/-!
# The field-point comparison of the unit, LIFTED to the sheafified functor `picEt`

The (C1)/(C2) campaign is stated on the one-step plus construction `PicEtAff`:

* (C1) `PicEtAff.unit_injective` (`Picard/CechKernelLemma.lean:361`, Kleiman 2.5(1)) —
  étale separatedness, unconditional on every affine test algebra;
* (C2) `PicEtAff.unit_surjective_of_section` (`Picard/EffectivityClose.lean:141`, Kleiman
  2.5(2)) — effectivity over a section-admitting field test;
* their combination `PicEtAff.unitEquiv_of_section` — `relPic C (Spec K) ≃* PicEtAff C K`.

But every *representability consumer* meets the honest relative Picard functor through
`picEt` / `relPicFunctor`, not through `PicEtAff`: the degree-zero functor `pic0Functor`
is a subfunctor of `picEtFunctor`, and the DAT-glue → `K_s` assembly (I-0248,
`Picard/PicRepDatum.lean`) needs a representation of the sheafified functor at a
separably closed / section-admitting field.  The comparison `PicEtAff.unit` and the
functor-level unit `relPicToPicEt` are joined by `picEtAffineEquiv_relPicToPicEt`
(`Picard/PicEtUnit.lean:161`): on an affine test, evaluation at the terminal open
`picEtAffineEquiv` collapses `relPicToPicEt` to `PicEtAff.unit`.  This file carries the
campaign's two theorems across that collapse.

## Honest scope

Mathematically this is a **conjugation** of the landed `PicEtAff` results by the affine
comparison isomorphism `picEtAffineEquiv`, so it introduces **no new mathematical
content** and **no new hypothesis** — the field-point equivalence carries exactly the
curve-point hypothesis `σ` of `EffectivityClose`.  It is worth landing because the
composed statement at the level of the functor the representability headline names was
recorded nowhere, and it is the interface between the C1/C2 campaign (output on
`PicEtAff`) and the `RepresentableBy` route (input on `picEt`/`pic0`).

## Main declarations

* `AlgebraicGeometry.relPicToPicEt_injective` — (C1) at the functor level: the unit
  component `relPicToPicEt` is injective at **every** affine test, unconditionally.
* `AlgebraicGeometry.relPicToPicEtEquiv_of_section` — the functor-level unit is a group
  **isomorphism** `relPic C (Spec K) ≃* picEt C (Spec K)` over a section-admitting field
  test, with `relPicToPicEtEquiv_of_section_apply` identifying its map with
  `relPicToPicEt`.
* `AlgebraicGeometry.relPicToPicEt_bijective_of_section` /
  `relPicToPicEt_surjective_of_section` — the bijectivity/surjectivity corollaries in the
  `Function.` idiom consumers cite.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))

noncomputable section

/-! ## (C1) at the functor level: injectivity of `relPicToPicEt` -/

section injective

variable [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

omit [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom] in
/-- **`relPicToPicEt` factors through `PicEtAff.unit` by the affine comparison**: on an
affine test its value is the affine comparison's inverse applied to the plus-construction
unit.  The transported form of `picEtAffineEquiv_relPicToPicEt`. -/
theorem relPicToPicEt_apply_eq_symm_unit (A : Type u) [CommRing A] [Algebra k A]
    (z : relPic C (overSpec k A)) :
    relPicToPicEt C (overSpec k A) z
      = (picEtAffineEquiv C A).symm (PicEtAff.unit C A z) := by
  rw [← picEtAffineEquiv_relPicToPicEt C A z, MulEquiv.symm_apply_apply]

/-- **(C1) étale separatedness, functor level**: the unit component `relPicToPicEt` is
injective on **every** affine test — unconditional, exactly as `PicEtAff.unit_injective`
is.  It is the affine comparison composed with the injective plus-construction unit. -/
theorem relPicToPicEt_injective (A : Type u) [CommRing A] [Algebra k A] :
    Function.Injective (relPicToPicEt C (overSpec k A)) := fun x y h => by
  apply PicEtAff.unit_injective C A
  rw [← picEtAffineEquiv_relPicToPicEt C A x, ← picEtAffineEquiv_relPicToPicEt C A y, h]

end injective

/-! ## (C1)+(C2) at the functor level: the field-point isomorphism -/

section field

variable (K : Type u) [Field K] [Algebra k K]
variable [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

/-- **The functor-level unit is a group isomorphism over a section-admitting field test**
(Kleiman 2.5, both parts, at the level of the sheafified functor): if the curve admits a
`K`-point `σ`, the unit component `relPicToPicEt C (Spec K)` is a `MulEquiv`
`relPic C (Spec K) ≃* picEt C (Spec K)`.

It is `PicEtAff.unitEquiv_of_section` conjugated by the affine comparison
`picEtAffineEquiv`; `relPicToPicEtEquiv_of_section_apply` records that its underlying map
is `relPicToPicEt`, so nothing about the honest unit is lost in the packaging. -/
noncomputable def relPicToPicEtEquiv_of_section (σ : overSpec k K ⟶ C) :
    relPic C (overSpec k K) ≃* picEt C (overSpec k K) :=
  (PicEtAff.unitEquiv_of_section C K σ).trans (picEtAffineEquiv C K).symm

/-- The field-point isomorphism's underlying map is the functor-level unit
`relPicToPicEt` — so it is the honest unit made bijective, not a different arrow. -/
@[simp]
theorem relPicToPicEtEquiv_of_section_apply (σ : overSpec k K ⟶ C)
    (z : relPic C (overSpec k K)) :
    relPicToPicEtEquiv_of_section C K σ z = relPicToPicEt C (overSpec k K) z := by
  change (picEtAffineEquiv C K).symm (PicEtAff.unit C K z) = relPicToPicEt C (overSpec k K) z
  rw [← picEtAffineEquiv_relPicToPicEt C K z, MulEquiv.symm_apply_apply]

/-- **(C1)+(C2) bijectivity, functor level**: over a section-admitting field test the unit
component `relPicToPicEt` is bijective. -/
theorem relPicToPicEt_bijective_of_section (σ : overSpec k K ⟶ C) :
    Function.Bijective (relPicToPicEt C (overSpec k K)) := by
  have h : ⇑(relPicToPicEt C (overSpec k K))
      = ⇑(relPicToPicEtEquiv_of_section C K σ) :=
    funext fun z => (relPicToPicEtEquiv_of_section_apply C K σ z).symm
  rw [h]
  exact (relPicToPicEtEquiv_of_section C K σ).bijective

/-- **(C2) surjectivity, functor level**: over a section-admitting field test every étale
Picard class on `Spec K` comes from an honest relative Picard class. -/
theorem relPicToPicEt_surjective_of_section (σ : overSpec k K ⟶ C) :
    Function.Surjective (relPicToPicEt C (overSpec k K)) :=
  (relPicToPicEt_bijective_of_section C K σ).2

end field

end

end AlgebraicGeometry
