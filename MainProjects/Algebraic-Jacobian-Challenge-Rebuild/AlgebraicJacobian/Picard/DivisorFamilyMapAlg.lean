/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyPullbackMap

/-!
# Base change of certified divisor families and `DivFam.mapAlg` (DD-2 stage S2)

The base-changed divisor adaptation and the divisor-functor map on classes along an
ARBITRARY test change `R → R'` (`informal/spec-dd-2.md` §2) — the resolution of the
DD-1 pt-transport seam: the carrier's pointwise refinement clause `eqn_rel` is
point-free (the `DivEq` spelling), so it pulls back along arbitrary morphisms through
`Scheme.Hom.unitsAppLE`, with no surjectivity hypothesis on the comparison
`relCurveMap C R R'`.

* `Scheme.LocalEquations.divEq_pullback` — divisor equality is stable under pullback
  (common refinement and units pull back), so the map descends to classes.
* `DivisorAdaptation.pullback` — **the base-changed adaptation**: base-changed cover
  data carrying the pulled equations; `eqn_rel` transports clause-for-clause through
  `unitsAppLE` (the `divEq_pullback` pattern).
* `DivisorAdaptation.isCertified_pullback` — **certified base change**: the transported
  certificate, assembling the (c1)–(c4) clause transports of
  `DivisorFamilyPullbackCert`/`DivisorFamilyPullbackGlued` (all fields are
  definitionally the pulled apparatus).
* `CertifiedDivisorFamily.mapAlg`, `DivFam.mapAlg` — **the divisor-functor map**
  `DivFam C R π n → DivFam C R' π n` on representatives and on classes
  (`Quotient.lift`, descent by `divEq_pullback`), with the Abel-hook class law
  `DivFam.picClass_mapAlg` (`𝒪(f*D) = f*𝒪(D)`).

The functor laws `mapAlg_id`/`mapAlg_comp` (`informal/spec-dd-2.md` §2, functor-laws
rows) are the follow-on stage's brick and are not in this file yet.
-/

set_option autoImplicit false
/- Statements mix `Γ(relCurve C R, ·)` with opens produced on the product spelling
`(C ⊗ overSpec k R).left`; see `AlgebraicJacobian.Cohomology.RelativeSectionsLinear`. -/
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161), so the pinned synthesis
depth must be set in-file for the faithful per-file check. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory TopologicalSpace
open Opposite TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

/-! ## Divisor equality is stable under pullback -/

namespace Scheme.LocalEquations

/-- `appLE` of a local equation at propositionally equal base points. -/
private lemma appLE_eqn_congr {X Y : Scheme.{u}} (f : X ⟶ Y) (E : Y.LocalEquations)
    {x₁ x₂ : Y} (hx : x₁ = x₂) {W : X.Opens}
    (e₁ : W ≤ f ⁻¹ᵁ E.cover.opens x₁) (e₂ : W ≤ f ⁻¹ᵁ E.cover.opens x₂) :
    (f.appLE (E.cover.opens x₁) W e₁).hom (E.eqn x₁) =
      (f.appLE (E.cover.opens x₂) W e₂).hom (E.eqn x₂) := by
  subst hx
  rfl

/-- **Divisor equality is stable under pullback**: a common refinement with pointwise
units pulls back to a common refinement with pulled units (`Scheme.Hom.unitsAppLE`). -/
theorem divEq_pullback {X Y : Scheme.{u}} (f : Y ⟶ X) {d₁ d₂ : X.LocalEquations}
    (h : DivEq d₁ d₂)
    (hreg₁ : ∀ (y z : Y) (hz : z ∈ (d₁.cover.pullback f).opens y),
      (Y.presheaf.germ ((d₁.cover.pullback f).opens y) z hz).hom (pullbackEqn f d₁ y)
        ∈ nonZeroDivisors (Y.presheaf.stalk z))
    (hreg₂ : ∀ (y z : Y) (hz : z ∈ (d₂.cover.pullback f).opens y),
      (Y.presheaf.germ ((d₂.cover.pullback f).opens y) z hz).hom (pullbackEqn f d₂ y)
        ∈ nonZeroDivisors (Y.presheaf.stalk z)) :
    DivEq (d₁.pullback f hreg₁) (d₂.pullback f hreg₂) := by
  obtain ⟨𝒲, h₁, h₂, H⟩ := h
  refine ⟨𝒲.pullback f, fun y => Scheme.Hom.preimage_mono f (h₁ (f.base y)),
    fun y => Scheme.Hom.preimage_mono f (h₂ (f.base y)), fun y => ?_⟩
  obtain ⟨u, hu⟩ := H (f.base y)
  have hle : (𝒲.pullback f).opens y ≤ f ⁻¹ᵁ 𝒲.opens (f.base y) := le_rfl
  refine ⟨f.unitsAppLE (𝒲.opens (f.base y)) ((𝒲.pullback f).opens y) hle u, ?_⟩
  -- both sides collapse to `appLE` of the base equations at the pulled member
  have hres₁ : (Y.presheaf.map (homOfLE
      (Scheme.Hom.preimage_mono f (h₁ (f.base y)) :
        (𝒲.pullback f).opens y ≤ (d₁.cover.pullback f).opens y)).op).hom
      ((d₁.pullback f hreg₁).eqn y) =
      (f.appLE (d₁.cover.opens (f.base y)) ((𝒲.pullback f).opens y)
        (hle.trans (Scheme.Hom.preimage_mono f (h₁ (f.base y))))).hom
        (d₁.eqn (f.base y)) :=
    pullbackEqn_res f d₁ y _
  have hres₂ : (Y.presheaf.map (homOfLE
      (Scheme.Hom.preimage_mono f (h₂ (f.base y)) :
        (𝒲.pullback f).opens y ≤ (d₂.cover.pullback f).opens y)).op).hom
      ((d₂.pullback f hreg₂).eqn y) =
      (f.appLE (d₂.cover.opens (f.base y)) ((𝒲.pullback f).opens y)
        (hle.trans (Scheme.Hom.preimage_mono f (h₂ (f.base y))))).hom
        (d₂.eqn (f.base y)) :=
    pullbackEqn_res f d₂ y _
  -- the pre-restriction collapse on both sides
  have e₁ := congr(($(Scheme.Hom.map_appLE f hle (homOfLE (h₁ (f.base y))).op)).hom
    (d₁.eqn (f.base y)))
  have e₂ := congr(($(Scheme.Hom.map_appLE f hle (homOfLE (h₂ (f.base y))).op)).hom
    (d₂.eqn (f.base y)))
  -- transport the unit relation through `appLE`
  have key := congrArg (f.appLE (𝒲.opens (f.base y)) ((𝒲.pullback f).opens y) hle).hom hu
  rw [map_mul] at key
  refine hres₁.trans (e₁.symm.trans (key.trans (congrArg₂ (· * ·) rfl
    (e₂.trans hres₂.symm))))

end Scheme.LocalEquations

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']
variable {π : C.left ⟶ P1 k} [IsAffineHom π]

namespace DivisorAdaptation

variable {d : (relCurve C R).LocalEquations} (A : DivisorAdaptation C R π d)

/-! ## The base-changed adaptation -/

/-- **The base-changed divisor adaptation** along an ARBITRARY test change (the DD-2
resolution of the DD-1 pt-transport seam, `informal/spec-dd-2.md` §2): the base-changed
cover data carrying the pulled equations. The pointwise refinement clause `eqn_rel`
transports clause-for-clause: the target overlap is the `relCurveMap`-preimage of the
source overlap, and the source clause pulls through `Scheme.Hom.unitsAppLE` — the
`divEq_pullback` pattern. -/
noncomputable def pullback (hproj : ∀ j, Module.Projective R (A.colength j)) :
    DivisorAdaptation C R' π (A.pulledEquations R' hproj) where
  toFinCoverData := A.toFinCoverData.baseChange R'
  eqn := A.pulledEqn R'
  eqn_rel := fun j y' => by
    obtain ⟨u, hu⟩ := A.eqn_rel j ((relCurveMap C R R').base y')
    have hle₁ : (A.toFinCoverData.baseChange R').pieces j ⊓
        (A.pulledEquations R' hproj).cover.opens y' ≤
        relCurveMap C R R' ⁻¹ᵁ A.pieces j :=
      inf_le_left.trans (A.toFinCoverData.baseChange_pieces_le_preimage R' j)
    have hle₂ : (A.toFinCoverData.baseChange R').pieces j ⊓
        (A.pulledEquations R' hproj).cover.opens y' ≤
        relCurveMap C R R' ⁻¹ᵁ d.cover.opens ((relCurveMap C R R').base y') :=
      inf_le_right
    have hle : (A.toFinCoverData.baseChange R').pieces j ⊓
        (A.pulledEquations R' hproj).cover.opens y' ≤
        relCurveMap C R R' ⁻¹ᵁ
          (A.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base y')) :=
      (relCurveMap C R R').le_preimage_inf hle₁ hle₂
    refine ⟨(relCurveMap C R R').unitsAppLE
      (A.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base y'))
      ((A.toFinCoverData.baseChange R').pieces j ⊓
        (A.pulledEquations R' hproj).cover.opens y') hle u, ?_⟩
    -- LHS: the restricted pulled equation collapses to `appLE` of the piece equation
    have hres₁ : ((relCurve C R').presheaf.map (homOfLE (inf_le_left :
        (A.toFinCoverData.baseChange R').pieces j ⊓
          (A.pulledEquations R' hproj).cover.opens y' ≤
          (A.toFinCoverData.baseChange R').pieces j)).op).hom (A.pulledEqn R' j) =
        ((relCurveMap C R R').appLE (A.pieces j)
          ((A.toFinCoverData.baseChange R').pieces j ⊓
            (A.pulledEquations R' hproj).cover.opens y') hle₁).hom (A.eqn j) := by
      rw [show A.pulledEqn R' j = ((relCurveMap C R R').appLE (A.pieces j)
          ((A.toFinCoverData.baseChange R').pieces j)
          (A.toFinCoverData.baseChange_pieces_le_preimage R' j)).hom (A.eqn j) from rfl,
        ← CommRingCat.comp_apply, Scheme.Hom.appLE_map]
    -- RHS: the restricted pulled system equation collapses to `appLE` of `d`'s equation
    have hres₂ : ((relCurve C R').presheaf.map (homOfLE (inf_le_right :
        (A.toFinCoverData.baseChange R').pieces j ⊓
          (A.pulledEquations R' hproj).cover.opens y' ≤
          (A.pulledEquations R' hproj).cover.opens y')).op).hom
        ((A.pulledEquations R' hproj).eqn y') =
        ((relCurveMap C R R').appLE (d.cover.opens ((relCurveMap C R R').base y'))
          ((A.toFinCoverData.baseChange R').pieces j ⊓
            (A.pulledEquations R' hproj).cover.opens y') hle₂).hom
          (d.eqn ((relCurveMap C R R').base y')) :=
      Scheme.LocalEquations.pullbackEqn_res (relCurveMap C R R') d y' _
    -- the pre-restriction collapse on both sides
    have e₁ := congr(($(Scheme.Hom.map_appLE (relCurveMap C R R') hle
      (homOfLE (inf_le_left : A.pieces j ⊓
        d.cover.opens ((relCurveMap C R R').base y') ≤ A.pieces j)).op)).hom (A.eqn j))
    have e₂ := congr(($(Scheme.Hom.map_appLE (relCurveMap C R R') hle
      (homOfLE (inf_le_right : A.pieces j ⊓
        d.cover.opens ((relCurveMap C R R').base y') ≤
        d.cover.opens ((relCurveMap C R R').base y'))).op)).hom
      (d.eqn ((relCurveMap C R R').base y')))
    -- transport the unit relation through `appLE`
    have key := congrArg ((relCurveMap C R R').appLE
      (A.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base y'))
      ((A.toFinCoverData.baseChange R').pieces j ⊓
        (A.pulledEquations R' hproj).cover.opens y') hle).hom hu
    rw [map_mul] at key
    exact hres₁.trans (e₁.symm.trans (key.trans (congrArg₂ (· * ·) rfl
      (e₂.trans hres₂.symm))))

/-! ## Certified base change -/

/-- **Certified base change**: the base-changed adaptation carries the transported
certificate — every clause is the corresponding pulled-apparatus transport of
`DivisorFamilyPullbackCert`/`DivisorFamilyPullbackGlued` (all fields of `pullback` are
definitionally the pulled apparatus). -/
theorem isCertified_pullback {n : ℕ} (hc : A.IsCertified n) :
    (A.pullback R' hc.projective_colength).IsCertified n := by
  haveI hc3 : Module.Flat R (A.chartProd ⧸ A.gluedSubmodule) := hc.flat_coker_incl
  haveI hc4 : Module.Flat R
      (A.ovlProd ⧸ LinearMap.range (A.deltaLeft - A.deltaRight)) := hc.flat_coker_diff
  exact
    { finite_colength := A.finite_pulledColength R' hc.finite_colength
      projective_colength := A.projective_pulledColength R' hc.projective_colength
      finite_glued := A.finite_pulledGlued R' hc.finite_glued
      projective_glued := A.projective_pulledGlued R' hc.projective_glued
      rankAtStalk_glued := A.rankAtStalk_pulledGlued R' hc.finite_glued
        hc.projective_glued hc.rankAtStalk_glued
      flat_coker_incl := A.flat_pulledCokerIncl R'
      flat_coker_diff := A.flat_pulledCokerDiff R' }

end DivisorAdaptation

variable (n : ℕ)

/-- **Base change of a certified divisor family** along an arbitrary test change:
pulled equations, base-changed adaptation, transported certificate. -/
noncomputable def CertifiedDivisorFamily.mapAlg (F : CertifiedDivisorFamily C R π n) :
    CertifiedDivisorFamily C R' π n where
  eqns := F.adaptation.pulledEquations R' F.certified.projective_colength
  adaptation := F.adaptation.pullback R' F.certified.projective_colength
  certified := F.adaptation.isCertified_pullback R' F.certified

/-- **The divisor-functor map on classes** along an ARBITRARY test change
(`informal/spec-dd-2.md` §2 — the total `mapAlg` closing the DD-1 pt-transport seam).
Well defined by `divEq_pullback`. -/
noncomputable def DivFam.mapAlg : DivFam C R π n → DivFam C R' π n :=
  Quotient.lift
    (fun F : CertifiedDivisorFamily C R π n => DivFam.mk (F.mapAlg R' n))
    (fun _ _ hFG => DivFam.mk_eq_mk_iff.mpr
      (Scheme.LocalEquations.divEq_pullback (relCurveMap C R R') hFG _ _))

@[simp]
lemma DivFam.mapAlg_mk (F : CertifiedDivisorFamily C R π n) :
    DivFam.mapAlg R' n (DivFam.mk F) = DivFam.mk (F.mapAlg R' n) :=
  rfl

/-- **The Abel-hook class law**: the divisor-functor map intertwines the Picard classes
with the Čech-Picard pullback, `𝒪(f*D) = f*𝒪(D)`. -/
lemma DivFam.picClass_mapAlg (F : DivFam C R π n) :
    (DivFam.mapAlg R' n F).picClass =
      Scheme.CechPic.map (relCurveMap C R R') F.picClass := by
  induction F using Quotient.inductionOn with
  | h F =>
      exact F.adaptation.picClass_pulledEquations R' F.certified.projective_colength

end AlgebraicGeometry
