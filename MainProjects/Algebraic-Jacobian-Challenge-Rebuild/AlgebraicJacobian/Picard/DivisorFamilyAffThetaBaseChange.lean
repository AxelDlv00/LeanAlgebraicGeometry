/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.GluedSheafTermBaseChangeEquiv
import AlgebraicJacobian.Cohomology.GluedSheafAffineProjective
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaDescent

/-!
# Restriction of affine theta-section models

This file starts the module base-change bridge needed to compare the theta modules on
two members of an affine divisor cover. Its construction is intrinsic to the glued
sheaf: there is no extra hypothesis on the divisor family or on the affine opens.

The key geometric input is a finite basic-open cover of an affine subopen `W ≤ V`
which is simultaneously subordinate to the original gluing pieces. This lets later
localization arguments use the established piece-localization theorem for the glued
sheaf. We also package the canonical section restriction and its base-change linear map
with the module structures selected by `AffineSectionsModel`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]

namespace BasicOpenCocycleDatum

/-- If `W ≤ V` are affine opens, there is a finite family of basic opens of `V`
covering `W`, each subordinate to a gluing piece. After restriction to `W`, their
defining sections span the unit ideal of `Γ(W)`. -/
theorem exists_finite_basicOpen_cover_le
    (D : BasicOpenCocycleDatum C B pi)
    {V W : (relCurve C B).Opens}
    (hV : IsAffineOpen V) (hW : IsAffineOpen W) (hWV : W ≤ V) :
    ∃ (ι : Type u) (_ : Fintype ι) (f : ι → Γ(relCurve C B, V))
      (anchor : ι → relCurve C B),
      (∀ i, (relCurve C B).basicOpen (f i) ≤ W) ∧
      (∀ i, (relCurve C B).basicOpen (f i) ≤ D.pieces (D.pieceIndex (anchor i))) ∧
      Ideal.span (Set.range (fun i ↦ (relCurve C B).resHom hWV (f i))) = ⊤ := by
  classical
  let X := relCurve C B
  have hpt : ∀ p : ↥W, ∃ f : Γ(X, V),
      X.basicOpen f ≤ W ⊓ D.pieces (D.pieceIndex (p : X)) ∧
        (p : X) ∈ X.basicOpen f := fun p =>
    hV.exists_basicOpen_le
      (⟨(p : X), p.2, D.mem_pieces_pieceIndex (p : X)⟩ :
        ↥(W ⊓ D.pieces (D.pieceIndex (p : X))))
      (hWV p.2)
  choose f hfle hfmem using hpt
  have hcov : (W : Set X) ⊆ ⋃ p : ↥W, (X.basicOpen (f p) : Set X) := fun q hq =>
    Set.mem_iUnion.mpr ⟨⟨q, hq⟩, hfmem ⟨q, hq⟩⟩
  obtain ⟨t, ht⟩ := hW.isCompact.elim_finite_subcover
    (fun p : ↥W => (X.basicOpen (f p) : Set X))
    (fun p => (X.basicOpen (f p)).isOpen) hcov
  let ι := {p : ↥W // p ∈ t}
  let f' : ι → Γ(X, V) := fun i => f (i : ↥W)
  let anchor : ι → X := fun i => ((i : ↥W) : X)
  have hfW (i : ι) : X.basicOpen (f' i) ≤ W :=
    (hfle (i : ↥W)).trans inf_le_left
  have hfP (i : ι) : X.basicOpen (f' i) ≤ D.pieces (D.pieceIndex (anchor i)) :=
    (hfle (i : ↥W)).trans inf_le_right
  refine ⟨ι, inferInstance, f', anchor, hfW, hfP, ?_⟩
  apply hW.self_le_iSup_basicOpen_iff.mp
  intro q hq
  obtain ⟨p, hpt, hpq⟩ := Set.mem_iUnion₂.mp (ht hq)
  let i : ι := ⟨p, hpt⟩
  apply TopologicalSpace.Opens.mem_iSup.mpr
  refine ⟨⟨X.resHom hWV (f' i), Set.mem_range_self i⟩, ?_⟩
  rw [Scheme.basicOpen_resHom hWV]
  exact ⟨hq, hpq⟩

/-- Restriction of glued-sheaf sections between two selected affine section models,
viewed as a semilinear map along the restriction homomorphism on functions. -/
noncomputable def affineSectionsRestriction
    (D : BasicOpenCocycleDatum C B pi)
    {V W : (relCurve C B).Opens} (hWV : W ≤ V)
    (MV : D.AffineSectionsModel V) (MW : D.AffineSectionsModel W) :
    letI := MV.qcoh
    letI : Module Γ(relCurve C B, V) (D.sheaf.obj.obj (op V)) :=
      Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl V)
    letI := MW.qcoh
    letI : Module Γ(relCurve C B, W) (D.sheaf.obj.obj (op W)) :=
      Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl W)
    D.sheaf.obj.obj (op V) →ₛₗ[(relCurve C B).resHom hWV]
      D.sheaf.obj.obj (op W) := by
  letI := MV.qcoh
  letI : Module Γ(relCurve C B, V) (D.sheaf.obj.obj (op V)) :=
    Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl V)
  letI := MW.qcoh
  letI : Module Γ(relCurve C B, W) (D.sheaf.obj.obj (op W)) :=
    Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl W)
  refine
    { toFun := secRes D.sheaf hWV
      map_add' := (secRes D.sheaf hWV).map_add
      map_smul' := fun r s => ?_ }
  change secRes D.sheaf hWV
      (Scheme.QcohOn.qsmul (F := D.sheaf) (le_refl V) r s) =
    Scheme.QcohOn.qsmul (F := D.sheaf) (le_refl W)
      ((relCurve C B).resHom hWV r) (secRes D.sheaf hWV s)
  rw [MV.qsmul_eq, MW.qsmul_eq]
  exact (gluedRes_gluedQsmul B D.pieces D.unit hWV (le_refl V) r s).trans
    (gluedQsmul_res B D.pieces D.unit (le_refl W) hWV r
      (gluedRes B D.pieces D.unit hWV s)).symm

/-- The canonical base-change comparison from sections on `V` to sections on the
affine subopen `W`. Its source and target actions are exactly those carried by the
chosen `AffineSectionsModel`s. -/
noncomputable def affineSectionsBaseChange
    (D : BasicOpenCocycleDatum C B pi)
    {V W : (relCurve C B).Opens} (hWV : W ≤ V)
    (MV : D.AffineSectionsModel V) (MW : D.AffineSectionsModel W) :
    letI := MV.qcoh
    letI : Module Γ(relCurve C B, V) (D.sheaf.obj.obj (op V)) :=
      Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl V)
    letI := MW.qcoh
    letI : Module Γ(relCurve C B, W) (D.sheaf.obj.obj (op W)) :=
      Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl W)
    letI : Algebra Γ(relCurve C B, V) Γ(relCurve C B, W) :=
      ((relCurve C B).resHom hWV).toAlgebra
    Γ(relCurve C B, W) ⊗[Γ(relCurve C B, V)] D.sheaf.obj.obj (op V) →ₗ[
      Γ(relCurve C B, W)] D.sheaf.obj.obj (op W) := by
  letI := MV.qcoh
  letI : Module Γ(relCurve C B, V) (D.sheaf.obj.obj (op V)) :=
    Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl V)
  letI : Module Γ(relCurve C B, V) (D.sheaf.obj.obj (op W)) :=
    Scheme.QcohOn.moduleOfLE (F := D.sheaf) hWV
  letI := MW.qcoh
  letI : Module Γ(relCurve C B, W) (D.sheaf.obj.obj (op W)) :=
    Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl W)
  letI : Algebra Γ(relCurve C B, V) Γ(relCurve C B, W) :=
    ((relCurve C B).resHom hWV).toAlgebra
  haveI : IsScalarTower Γ(relCurve C B, V) Γ(relCurve C B, W)
      (D.sheaf.obj.obj (op W)) := by
    apply IsScalarTower.of_algebraMap_smul
    intro r s
    change Scheme.QcohOn.qsmul (F := D.sheaf) (le_refl W)
        ((relCurve C B).resHom hWV r) s =
      Scheme.QcohOn.qsmul (F := D.sheaf) hWV r s
    rw [MW.qsmul_eq, MV.qsmul_eq]
    exact gluedQsmul_res B D.pieces D.unit (le_refl W) hWV r s
  exact LinearMap.liftBaseChange Γ(relCurve C B, W)
    (Scheme.QcohOn.secResₗ (F := D.sheaf) hWV (le_refl V))

@[simp]
theorem affineSectionsBaseChange_tmul
    (D : BasicOpenCocycleDatum C B pi)
    {V W : (relCurve C B).Opens} (hWV : W ≤ V)
    (MV : D.AffineSectionsModel V) (MW : D.AffineSectionsModel W)
    (r : Γ(relCurve C B, W)) (s : D.sheaf.obj.obj (op V)) :
    letI := MV.qcoh
    letI : Module Γ(relCurve C B, V) (D.sheaf.obj.obj (op V)) :=
      Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl V)
    letI := MW.qcoh
    letI : Module Γ(relCurve C B, W) (D.sheaf.obj.obj (op W)) :=
      Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl W)
    letI : Algebra Γ(relCurve C B, V) Γ(relCurve C B, W) :=
      ((relCurve C B).resHom hWV).toAlgebra
    D.affineSectionsBaseChange hWV MV MW (r ⊗ₜ s) =
      r • secRes D.sheaf hWV s := by
  rfl

end BasicOpenCocycleDatum

end AlgebraicGeometry
