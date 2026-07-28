/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartTestPoint
import AlgebraicJacobian.Picard.DivSchemeAbel
import AlgebraicJacobian.Picard.PicEtAffFieldCollapse

/-!
# CHART-U(a): `chartLocus`, the chart-membership locus over a general test

The co-signed brick of `informal/w4-datc-worksheet.md` §3.3 (CHART-U(a)) and
`informal/w4-datb-worksheet.md` §1.6, in the SPLIT form the (a-amendment) binds:

> `t ∈ chartLocus c λ` iff for some (equivalently every) finite separable `L/κ(t)`
> splitting the collapsed plus class, the honest `L`-class of `λ_t · θ^m · (−Σ)` admits
> an effective witness divisor with vanishing `H¹`.

Everything here is over a GENERAL test `T` and an ARBITRARY plus class
`λ ∈ pic0Subgroup C T`.  That is what distinguishes it from
`Picard/Pic0ChartLocusClass.lean`'s `cechWitnessLocus`, which lives over an affine base
and reads an UNTWISTED `CechPic` class; the module header there says so, and this file is
the promised general-test article.

## The layering, and why the split predicate is a *definition* here and not a disjunction

Three separate things had to be joined, and they are joined in three steps:

1. `Over.testPoint` (`Picard/Pic0ChartTestPoint.lean`) turns a point `t : T.left` into a
   field point `overSpec k κ(t) ⟶ T`, so that `picEtMap C (testPoint t) λ` is the fibre
   class of `λ` at `t`.  Without it there is no way to even state the predicate over a
   general test.
2. `IsSplitWitness` reads a plus class over a FIELD.  A plus class over a field is
   `PicEtAff.mk E x` for an étale cover `E`, which is *not* an honest Čech class; the
   (a-amendment)'s "finite separable `L` splitting the class" is exactly
   `Algebra.EtaleCover.exists_finiteSeparableField_algHom` (`Algebra/EtaleCover.lean:287`)
   applied to `E`, after which `PicEtAff.map_mk_eq_unit_relPicMk_of_algHom`
   (`Picard/PicEtAffFieldCollapse.lean:101`) presents the class as `relPicMk` of an honest
   Čech class over `C_L`.  The predicate is then the tree's witness predicate on that Čech
   class.
3. `chartLocus` twists by the chart index `(m, Σ)` — the same twist
   `abelDiv · sigmaFamily Σ · (θ^m)⁻¹` that `chartValue` (`Picard/DivSchemeAbel.lean:351`)
   applies on the divisor side — and reads step 2 at step 1's field point.

The "some (equivalently every)" of the amendment is the honest content: the ∃-form is what
one *proves* (coverage produces one splitting, §1.2 step 6), the ∀-form is what one
*consumes* (any presenting splitting is a sound test).  Their agreement is
`isSplitWitness_iff_forall`, and it rests on
`BasicOpenCocycleDatum.hasWitnessH1Vanishing_iff_of_separable`
(`Picard/Pic0ChartLocusFibreField.lean:157`) — the separable-invariance that lane co-owned
— together with class-intrinsicity at a fixed field
(`hasWitnessH1Vanishing_congr_of_cechPicClass_eq`, `:177`).  So the definition is stated in
the ∃-form and the ∀-form is a theorem, not a second definition.

## Main declarations

* `AlgebraicGeometry.IsSplitWitness C π μ` — the split witness predicate at a class
  `μ : picEt C (overSpec k K)` over a field `K`: some finite separable `L/K` presents `μ`
  as an honest Čech class over `C_L` admitting an effective witness divisor with vanishing
  `H¹`.
* `AlgebraicGeometry.isSplitWitness_iff_forall` — the (a-amendment)'s "some (equivalently
  every)".
* `AlgebraicGeometry.chartTwist C m Σ λ` — the twisted fibre family
  `λ · sigmaFamily Σ · (θ^m)⁻¹`, i.e. the class whose chart-membership is at issue.  Its
  fibre degree is `Σ.deg − m·d₁` by the landed degree ledger, which is the degree the
  chart index is calibrated to.
* **`AlgebraicGeometry.chartLocus`** — CHART-U(a): `{t : T.left | IsSplitWitness of the
  twisted fibre class at κ(t)}`.
* `AlgebraicGeometry.mem_chartLocus_iff` / `mem_chartLocus_iff_forall` — the two readings.
* `AlgebraicGeometry.chartLocus_preimage_subset` — the naturality half that CHART-U(b)
  transport (i) consumes: a morphism of tests pulls `chartLocus` back into `chartLocus`.

## What is NOT here

`isOpen_chartLocus` (dat-b row B-4) is the *assembly* of DAT-B's transports (i)/(ii)
against DAT-C's shifted-datum half, and it lives in `Picard/Pic0ChartLocusIsOpen.lean`.
Nothing in this file is `divRep`- or certificate-gated: no `DivFamZar`, no `IsCertified`,
no `RepresentableBy` appears in the cone, per the parametric mandate of I-0494.
-/

set_option autoImplicit false
/- Statements mix `relCurve C L` with the product spelling `(C ⊗ overSpec k L).left`. -/
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161). -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

open scoped TensorProduct

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsFinite π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

/-! ## The split witness predicate at a class over a field -/

variable (C) in
/-- **The split witness predicate** (CHART-U(a) in the `w4-datb` §1.6 (a-amendment)
spelling), at a plus class `μ` over a field `K`.

A plus class over a field need not be an honest Čech class — it is `PicEtAff.mk E x` for
an étale cover `E` of `K`.  The amendment's "for some finite separable `L/κ(t)` splitting
the collapsed plus class" is this: there is a finite separable extension `L/K` over which
`μ` becomes `relPicMk` of an honest Čech class `M` on `C_L`, and `M` admits an effective
witness divisor with vanishing `H¹`.

Stated with the witness clause on a *presenting Čech class* rather than on a datum,
because the datum layer is where the shifted-datum constructor (DAT-C GAP-1) is missing;
the two agree through `Pic0ChartLocusClass.mem_cechWitnessLocus_iff_exists`. -/
def IsSplitWitness {K : Type u} [Field K] [Algebra k K]
    (μ : picEt C (overSpec k K)) : Prop :=
  ∃ (L : Type u) (_ : Field L) (_ : Algebra k L) (_ : Algebra K L)
      (_ : IsScalarTower k K L) (_ : Module.Finite K L) (_ : Algebra.IsSeparable K L)
      (M : (relCurve C L).CechPic),
    PicEtAff.map C L (picEtAffineEquiv C K μ)
        = PicEtAff.unit C L (relPicMk C (overSpec k L) M)
      ∧ ∃ W : ((C ⊗ overSpec k L).left).CurveDivisor,
          Scheme.CurveDivisor.picClass L W = M
            ∧ Subsingleton (Sheaf.HModule
                ((C ⊗ overSpec k L).left.divisorSheaf L W) 1)

/-! ## The twisted fibre family -/

variable (C) in
/-- **The twisted family whose chart-membership `chartLocus` tests**: the plus class `λ`
shifted by the Σ-family of `Z` and by `m` inverse powers of the pinned θ-family.

This is the *class-side* half of `chartValue` (`Picard/DivSchemeAbel.lean:351`): where
`chartValue` twists the Abel class of a divisor family, `chartTwist` twists an arbitrary
plus class by the same two factors.  A point of `chartLocus` is precisely a point at which
`chartTwist` is realised by an effective divisor with no `H¹` — i.e. at which `λ` itself is
a chart value, after undoing the twist. -/
def chartTwist (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (lam : picEt C T) : picEt C T :=
  lam * sigmaFamily C Z T * (thetaFamily C (thetaCechClass C) T ^ m)⁻¹

/-- **The degree ledger of the twist**: at every field point the twisted family has fibre
degree `deg Z − m·d₁` when `λ` is degree-zero.  With the chart-index constraint
`deg Z = m·d₁ − g` this is `−g`; the chart-side `chartValue` lands at `n + deg Z − m·d₁`
(`degAt_chartValue`, `DivSchemeAbel.lean:368`), so the two agree at `n = 0` — which is why
`chartLocus` tests the class `λθ^m(−Σ)` and not `λ` itself. -/
theorem degAt_chartTwist (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {T : Over (Spec (.of k))} {lam : picEt C T} (hlam : lam ∈ pic0Subgroup C T)
    {K : Type u} [Field K] [Algebra k K] (t : overSpec k K ⟶ T) :
    degAt (chartTwist C m Z T lam) t
      = Scheme.CurveDivisor.deg k Z - (m : ℤ) * classDeg k (thetaCechClass C) := by
  rw [chartTwist, degAt_mul, degAt_inv, degAt_mul, degAt_thetaFamily_pow,
    degAt_sigmaFamily, (mem_pic0Subgroup_iff.mp hlam) K t]
  ring

/-! ## CHART-U(a): the locus -/

variable (C) in
/-- **CHART-U(a), `chartLocus`** (`w4-datc` §3.3, co-signed `w4-datb` §1.6): the set of
points of a general test `T` at which the twisted fibre class `λ_t · θ^m · (−Σ)` has, after
some finite separable splitting of the collapsed plus class at `κ(t)`, an effective witness
divisor with vanishing `H¹`.

The three layers, each supplied by a named brick:
* the *point-to-field-point* passage is `Over.testPoint` (input 0 of this brick — the one
  nothing in the tree had);
* the *twist* is `chartTwist`, the class-side avatar of `chartValue`;
* the *split witness reading over a field* is `IsSplitWitness`.

This is the RESERVED name of `Pic0ChartLocusClass.lean`'s header, now defined.  Note it is
strictly stronger than `cechWitnessLocus`: general test, twisted class, split predicate. -/
def chartLocus (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {T : Over (Spec (.of k))} (lam : picEt C T) : Set T.left :=
  {t : T.left | IsSplitWitness C
    (picEtMap C (Over.testPoint t) (chartTwist C m Z T lam))}

theorem mem_chartLocus_iff (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left) :
    t ∈ chartLocus C m Z lam ↔ IsSplitWitness C
      (picEtMap C (Over.testPoint t) (chartTwist C m Z T lam)) :=
  Iff.rfl

/-! ## The datum-layer reading

The witness clause of `IsSplitWitness` is stated on a presenting Čech class over `C_L`.
The tree's *engine-facing* predicate is stated on a `BasicOpenCocycleDatum`
(`BasicOpenCocycleDatum.HasWitnessH1Vanishing`, `Pic0ChartLocusFibreField.lean:115`), and
the two are joined by `exists_cechPicClass_eq` (every class is presented) plus
class-intrinsicity.  This is the seam CHART-U(b) crosses to reach
`datumRigidEngine_isOpen_vanishing`, so it is recorded here as a lemma of the definition
rather than left implicit in the openness proof. -/

/-- **The witness clause at a splitting field, in datum form**: for a Čech class `M` over
`C_L`, admitting an effective witness divisor with vanishing `H¹` is exactly
`HasWitnessH1Vanishing` of any datum presenting `M` — as a class over the base `L` itself,
where `relCurveMap C L L` is the identity comparison.

Note the datum lives over the *field* `L` as base ring, which is the affine base the
engine's `PrimeSpectrum L` has a unique point of; that is why the fibre reading and the
base reading coincide here. -/
theorem exists_witness_iff_hasWitnessH1Vanishing_of_datum
    {L : Type u} [Field L] [Algebra k L]
    (D : BasicOpenCocycleDatum C L π) {M : (relCurve C L).CechPic}
    (hD : Scheme.CechPic.map (relCurveMap C L L) D.cechPicClass
      = Scheme.CechPic.map (relCurveMap C L L) M) :
    (∃ W : ((C ⊗ overSpec k L).left).CurveDivisor,
        Scheme.CurveDivisor.picClass L W = Scheme.CechPic.map (relCurveMap C L L) M
          ∧ Subsingleton (Sheaf.HModule
              ((C ⊗ overSpec k L).left.divisorSheaf L W) 1))
      ↔ D.HasWitnessH1Vanishing L := by
  rw [BasicOpenCocycleDatum.HasWitnessH1Vanishing, hD]

/-- **Upward closure of the witness clause along a separable extension of the splitting
field** — the substantive half of the (a-amendment)'s "some (equivalently every)".

If a Čech class `M` over `C_L` has an effective witness divisor with vanishing `H¹`, then
so does its base change to any finite separable `L'/L`.  This is what makes two splittings
of the same plus class comparable: pass to a common separable extension and compare there,
rather than comparing the two splittings directly.

Proof: present `M` by a datum `D` over `L` (`exists_cechPicClass_eq`); the witness clause at
`L` is `D.HasWitnessH1Vanishing L`, which transfers to `L'` by the co-owned separable
invariance `hasWitnessH1Vanishing_iff_of_separable`
(`Pic0ChartLocusFibreField.lean:157` — itself resting only on faithful flatness of a field
extension, so separability is packaging, not content). -/
theorem exists_witness_of_separable_extension (π : C.left ⟶ P1 k) [IsFinite π]
    {L : Type u} [Field L] [Algebra k L]
    {L' : Type u} [Field L'] [Algebra k L'] [Algebra L L'] [IsScalarTower k L L']
    [Algebra.IsSeparable L L'] (M : (relCurve C L).CechPic)
    (h : ∃ W : ((C ⊗ overSpec k L).left).CurveDivisor,
        Scheme.CurveDivisor.picClass L W = M
          ∧ Subsingleton (Sheaf.HModule
              ((C ⊗ overSpec k L).left.divisorSheaf L W) 1)) :
    ∃ W' : ((C ⊗ overSpec k L').left).CurveDivisor,
      Scheme.CurveDivisor.picClass L' W' = Scheme.CechPic.map (relCurveMap C L L') M
        ∧ Subsingleton (Sheaf.HModule
            ((C ⊗ overSpec k L').left.divisorSheaf L' W') 1) := by
  obtain ⟨D, hD⟩ := BasicOpenCocycleDatum.exists_cechPicClass_eq (C := C) (B := L) (π := π) M
  obtain ⟨W, hW, hW1⟩ := h
  -- the witness clause at `L` is the datum predicate at `L`: `relCurveMap C L L` acts as
  -- the identity comparison on classes, since it is `Spec` of the identity algebra map.
  have hid : Scheme.CechPic.map (relCurveMap C L L) D.cechPicClass = D.cechPicClass := by
    have : relCurveMap C L L = 𝟙 (relCurve C L) := by
      rw [relCurveMap]
      have hom : overSpecMap (k := k) L L = 𝟙 (overSpec k L) :=
        Over.OverMorphism.ext (by simp)
      rw [hom, MonoidalCategory.whiskerLeft_id]
      rfl
    rw [this, Scheme.CechPic.map_id]
    rfl
  have hL : D.HasWitnessH1Vanishing L := ⟨W, by rw [hid, hD, hW], hW1⟩
  -- transfer along the separable extension, then read it back as a witness clause
  obtain ⟨W', hW', hW1'⟩ :=
    (D.hasWitnessH1Vanishing_iff_of_separable L L').mp hL
  exact ⟨W', by rw [hW', hD], hW1'⟩

/-! ## Naturality — the half CHART-U(b) transport (i) consumes -/

/-- **`chartLocus` is compatible with restriction of the class**: the twist commutes with
`picEtMap`, so restricting `λ` along a morphism of tests restricts the twisted family too.

This is `sigmaFamily_natural` + `thetaFamily_natural` and nothing else; it is stated
separately because transport (i) of `w4-datb` §1.6 (the descent-preimage step) is exactly
this identity read at the field point of a point over the source. -/
theorem picEtMap_chartTwist (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {T T' : Over (Spec (.of k))} (f : T' ⟶ T) (lam : picEt C T) :
    picEtMap C f (chartTwist C m Z T lam)
      = chartTwist C m Z T' (picEtMap C f lam) := by
  rw [chartTwist, chartTwist, map_mul, map_inv, map_mul, map_pow,
    sigmaFamily_natural, thetaFamily_natural]

end

end AlgebraicGeometry
