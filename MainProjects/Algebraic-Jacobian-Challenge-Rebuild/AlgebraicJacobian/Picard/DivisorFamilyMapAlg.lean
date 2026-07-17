/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyPullbackMap

/-!
# Base change of certified divisor families and `DivFam.mapAlg` (DD-1 stage (c) close)

The base-changed divisor adaptation and the divisor-functor map on classes
(`informal/spec-dd-1.md` §3 stage (c), final rows).

The refinement witness `pt`/`piece_le` of a `DivisorAdaptation` indexes the members of
the pulled pointed cover by points of the relative curve over `R'`; transporting it
therefore requires a point above each base point `A.pt j` — the **pt-transport seam**:

* `DivisorAdaptation.BaseChangeWitness` — the required lift data (a point of
  `relCurve C R'` above each `A.pt j`), with `BaseChangeWitness.ofSurjective`
  discharging it whenever the comparison `relCurveMap C R R'` is surjective on points
  (e.g. along faithfully flat test maps — the DD-2 covers).
* `DivisorAdaptation.ofWitness` — **the base-changed adaptation**: base-changed cover
  data, pulled equations, the witness's refinement, units through the piece comparison.
* `DivisorAdaptation.isCertified_ofWitness` — **certified base change**: the transported
  certificate, assembling the (c1)–(c4) clause transports of
  `DivisorFamilyPullbackCert`/`DivisorFamilyPullbackGlued` (all fields are
  definitionally the pulled apparatus).
* `Scheme.LocalEquations.divEq_pullback` — divisor equality is stable under pullback
  (common refinement and units pull back), so the map descends to classes:
* `DivFam.mapAlgOfSurjective` — the divisor-functor map `DivFam C R π n → DivFam C R' π n`
  along a test change with surjective comparison, with the Abel-hook class law
  `picClass_mapAlgOfSurjective` (`𝒪(f*D) = f*𝒪(D)`).

The unconditional `DivFam.mapAlg` (arbitrary test maps) is exactly the pt-transport
seam: for a non-surjective comparison a piece can be nonempty while its base point has
empty fibre, and the frozen carrier has no member of the pulled cover containing it.
Recorded as the open DD-1 seam; consumers with flat covers (DD-2) are served by the
surjective case.
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

/-! ## The refinement witness and the base-changed adaptation -/

/-- **The pt-transport witness**: a point of the relative curve over `R'` above each
refinement base point of the adaptation. This is the DD-1 pt-transport seam: the pulled
pointed cover indexes its members by points of `relCurve C R'`, so the base-changed
adaptation needs a point above each `A.pt j`. -/
structure BaseChangeWitness : Type u where
  /-- A point above each refinement base point. -/
  pt : A.index → relCurve C R'
  /-- The points lie above the adaptation's base points. -/
  base_pt : ∀ j, (relCurveMap C R R').base (pt j) = A.pt j

/-- A surjective comparison (e.g. along a faithfully flat test map) yields a witness. -/
noncomputable def BaseChangeWitness.ofSurjective
    (hsurj : Function.Surjective (relCurveMap C R R').base) :
    A.BaseChangeWitness R' where
  pt j := (hsurj (A.pt j)).choose
  base_pt j := (hsurj (A.pt j)).choose_spec

/-- The base-changed pieces refine the pulled cover through the witness: the piece is
the preimage of a piece contained in the member at the base point, which is the member
at the witness point. -/
lemma witness_piece_le (hproj : ∀ j, Module.Projective R (A.colength j))
    (w : A.BaseChangeWitness R') (j : A.index) :
    (A.toFinCoverData.baseChange R').pieces j ≤
      (A.pulledEquations R' hproj).cover.opens (w.pt j) := by
  have h1 : (A.toFinCoverData.baseChange R').pieces j =
      relCurveMap C R R' ⁻¹ᵁ A.pieces j :=
    A.toFinCoverData.pieces_baseChange R' j
  have h2 : relCurveMap C R R' ⁻¹ᵁ A.pieces j ≤
      relCurveMap C R R' ⁻¹ᵁ d.cover.opens ((relCurveMap C R R').base (w.pt j)) := by
    rw [w.base_pt j]
    exact Scheme.Hom.preimage_mono _ (A.piece_le j)
  rw [h1]
  exact h2

/-- **The base-changed divisor adaptation**, given a refinement witness: the
base-changed cover data carrying the pulled equations, refining the pulled system
through the witness, with comparison units the piece comparisons of the units. -/
noncomputable def ofWitness (hproj : ∀ j, Module.Projective R (A.colength j))
    (w : A.BaseChangeWitness R') :
    DivisorAdaptation C R' π (A.pulledEquations R' hproj) where
  toFinCoverData := A.toFinCoverData.baseChange R'
  eqn := A.pulledEqn R'
  pt := w.pt
  piece_le := A.witness_piece_le R' hproj w
  unit := fun j =>
    Units.map (A.toFinCoverData.piecesMap R' j).toMonoidHom (A.unit j)
  eqn_eq := fun j => by
    have hle₁ : (A.toFinCoverData.baseChange R').pieces j ≤
        relCurveMap C R R' ⁻¹ᵁ d.cover.opens (A.pt j) :=
      (A.toFinCoverData.baseChange_pieces_le_preimage R' j).trans
        (Scheme.Hom.preimage_mono _ (A.piece_le j))
    -- LHS: the pulled equation is the pulled unit times `appLE` of `d`'s equation
    have hLHS : A.pulledEqn R' j =
        (Units.map (A.toFinCoverData.piecesMap R' j).toMonoidHom (A.unit j) :
            Γ(relCurve C R', (A.toFinCoverData.baseChange R').pieces j)ˣ)
          * ((relCurveMap C R R').appLE (d.cover.opens (A.pt j))
              ((A.toFinCoverData.baseChange R').pieces j) hle₁).hom (d.eqn (A.pt j)) := by
      have hmap : A.pulledEqn R' j =
          A.toFinCoverData.piecesMap R' j
            ((A.unit j : Γ(relCurve C R, A.pieces j))
              * ((relCurve C R).presheaf.map (homOfLE (A.piece_le j)).op).hom
                (d.eqn (A.pt j))) := by
        rw [← A.eqn_eq j]
        rfl
      have hcol := congr(($(Scheme.Hom.map_appLE (relCurveMap C R R')
        (A.toFinCoverData.baseChange_pieces_le_preimage R' j)
        (homOfLE (A.piece_le j)).op)).hom (d.eqn (A.pt j)))
      rw [hmap, map_mul]
      exact congrArg₂ (· * ·) rfl hcol
    -- RHS: the restriction of the pulled system's equation at the witness point is the
    -- same `appLE`, with the base point swapped along the witness
    have hRHS : ((relCurve C R').presheaf.map
        (homOfLE (A.witness_piece_le R' hproj w j)).op).hom
        ((A.pulledEquations R' hproj).eqn (w.pt j)) =
        ((relCurveMap C R R').appLE (d.cover.opens (A.pt j))
          ((A.toFinCoverData.baseChange R').pieces j) hle₁).hom (d.eqn (A.pt j)) := by
      have hres := Scheme.LocalEquations.pullbackEqn_res (relCurveMap C R R') d (w.pt j)
        (A.witness_piece_le R' hproj w j)
      have heqn : (A.pulledEquations R' hproj).eqn (w.pt j) =
          Scheme.LocalEquations.pullbackEqn (relCurveMap C R R') d (w.pt j) := rfl
      rw [heqn]
      exact hres.trans (Scheme.LocalEquations.appLE_eqn_congr (relCurveMap C R R') d
        (w.base_pt j) _ hle₁)
    rw [hRHS]
    exact hLHS

/-! ## Certified base change -/

/-- **Certified base change**: the base-changed adaptation carries the transported
certificate — every clause is the corresponding pulled-apparatus transport of
`DivisorFamilyPullbackCert`/`DivisorFamilyPullbackGlued` (all fields of `ofWitness` are
definitionally the pulled apparatus). -/
theorem isCertified_ofWitness {n : ℕ} (hc : A.IsCertified n)
    (w : A.BaseChangeWitness R') :
    (A.ofWitness R' hc.projective_colength w).IsCertified n := by
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

/-- **Base change of a certified divisor family** along a test change with surjective
comparison: pulled equations, base-changed adaptation through the surjectivity witness,
transported certificate. -/
noncomputable def CertifiedDivisorFamily.baseChangeOfSurjective
    (F : CertifiedDivisorFamily C R π n)
    (hsurj : Function.Surjective (relCurveMap C R R').base) :
    CertifiedDivisorFamily C R' π n where
  eqns := F.adaptation.pulledEquations R' F.certified.projective_colength
  adaptation := F.adaptation.ofWitness R' F.certified.projective_colength
    (DivisorAdaptation.BaseChangeWitness.ofSurjective R' F.adaptation hsurj)
  certified := F.adaptation.isCertified_ofWitness R' F.certified _

/-- **The divisor-functor map on classes** along a test change with surjective
comparison (`informal/spec-dd-1.md` §3 stage (c), the `mapAlg` row; the unconditional
case is the recorded pt-transport seam). Well defined by `divEq_pullback`. -/
noncomputable def DivFam.mapAlgOfSurjective
    (hsurj : Function.Surjective (relCurveMap C R R').base) :
    DivFam C R π n → DivFam C R' π n :=
  Quotient.lift
    (fun F : CertifiedDivisorFamily C R π n =>
      DivFam.mk (F.baseChangeOfSurjective R' n hsurj))
    (fun _ _ hFG => DivFam.mk_eq_mk_iff.mpr
      (Scheme.LocalEquations.divEq_pullback (relCurveMap C R R') hFG _ _))

@[simp]
lemma DivFam.mapAlgOfSurjective_mk
    (hsurj : Function.Surjective (relCurveMap C R R').base)
    (F : CertifiedDivisorFamily C R π n) :
    DivFam.mapAlgOfSurjective R' n hsurj (DivFam.mk F) =
      DivFam.mk (F.baseChangeOfSurjective R' n hsurj) :=
  rfl

/-- **The Abel-hook class law**: the divisor-functor map intertwines the Picard classes
with the Čech-Picard pullback, `𝒪(f*D) = f*𝒪(D)`. -/
lemma DivFam.picClass_mapAlgOfSurjective
    (hsurj : Function.Surjective (relCurveMap C R R').base) (F : DivFam C R π n) :
    (DivFam.mapAlgOfSurjective R' n hsurj F).picClass =
      Scheme.CechPic.map (relCurveMap C R R') F.picClass := by
  induction F using Quotient.inductionOn with
  | h F =>
      exact F.adaptation.picClass_pulledEquations R' F.certified.projective_colength

end AlgebraicGeometry
