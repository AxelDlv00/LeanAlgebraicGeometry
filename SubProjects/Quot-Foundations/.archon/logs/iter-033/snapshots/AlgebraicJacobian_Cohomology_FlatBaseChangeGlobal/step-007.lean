/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.FlatBaseChange

/-!
# Flat base change for the pushforward, global (`H⁰`-as-equalizer) chain

This file builds the global ("FBC-B") leg of the `i = 0` flat-base-change package:
`H⁰(X, F) = Γ(X, F)` of a quasi-compact, quasi-separated scheme is the equalizer of
a *finite* affine cover, and flat base change commutes with that finite equalizer.

It is the companion of `AlgebraicJacobian.Cohomology.FlatBaseChange`, which it imports
read-only (using the affine global-sections comparison as a per-term black box).

See `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (FBC-B section).
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## Project-local Mathlib supplement — finite affine covers with quasi-compact overlaps -/

/-- A quasi-compact scheme admits a *finite* affine open cover; when it is moreover
quasi-separated, every pairwise intersection of cover members is quasi-compact.

Project-local: packages `isCompact_iff_finite_and_eq_biUnion_affineOpens` (finite affine
subcover of `⊤`) with `quasiSeparatedSpace_iff_forall_affineOpens` (quasi-compact overlaps)
into the single combinatorial input feeding the finite sheaf-condition equalizer of the
`H⁰` flat-base-change argument. -/
theorem Scheme.exists_finite_affineCover_inter_isQuasiCompact (X : Scheme.{u})
    [CompactSpace X] [QuasiSeparatedSpace X] :
    ∃ s : Set X.affineOpens, s.Finite ∧ (⨆ i ∈ s, (i : X.Opens)) = ⊤ ∧
      ∀ U ∈ s, ∀ V ∈ s, IsCompact ((U : Set X) ∩ (V : Set X)) := by
  obtain ⟨s, hs, he⟩ :=
    (isCompact_iff_finite_and_eq_biUnion_affineOpens (U := (⊤ : X.Opens))).mp
      (by simpa using isCompact_univ (X := ↥X))
  refine ⟨s, hs, he.symm, ?_⟩
  intro U _ V _
  exact quasiSeparatedSpace_iff_forall_affineOpens.mp ‹_› U V

/-! ## Project-local Mathlib supplement — the global sections as a sheaf-condition equalizer -/

open TopCat.Presheaf SheafConditionEqualizerProducts in
/-- For `M : X.Modules` and any open cover `U : ι → X.Opens`, the sheaf-condition fork
of the underlying abelian-group presheaf of `M` is a limit (an equalizer of products):
```
Γ(M, ⨆ i, U i) ⟶ ∏ i, Γ(M, U i) ⇉ ∏ (i,j), Γ(M, U i ⊓ U j).
```
This is the equalizer-products form of the sheaf condition specialised to the abelian
presheaf `M.presheaf` of a sheaf of `𝒪_X`-modules. Combined with the finite affine cover
of `Scheme.exists_finite_affineCover_inter_isQuasiCompact` it computes `Γ(X, M) = Γ(M, ⊤)`
as a *finite* equalizer; that finiteness is what the flat-base-change argument needs to
commute `- ⊗_A B` past the equalizer.

Project-local: packages `M.isSheaf` through Mathlib's
`isSheaf_iff_isSheafEqualizerProducts` at the level of `X.Modules`. -/
noncomputable def Modules.gammaIsLimitSheafConditionFork {X : Scheme.{u}} (M : X.Modules)
    {ι : Type u} (U : ι → X.Opens) :
    IsLimit (fork M.presheaf U) :=
  ((isSheaf_iff_isSheafEqualizerProducts M.presheaf).mp M.isSheaf U).some

/-- Consolidation of the two preceding supplements: for a quasi-compact, quasi-separated
scheme `X` and `M : X.Modules`, there is a *finite* affine open cover `U : ι → X.Opens`
(`ι` finite, each `U i` affine, `⨆ i, U i = ⊤`, all pairwise intersections quasi-compact)
for which `Γ(X, M) = Γ(M, ⊤)` is the equalizer of the finite sheaf-condition fork of `U`.

Project-local: combines `Scheme.exists_finite_affineCover_inter_isQuasiCompact` (L1) with
`Modules.gammaIsLimitSheafConditionFork` (L2) into the directly-usable "global sections as a
finite equalizer" input of the flat-base-change argument. -/
open TopCat.Presheaf SheafConditionEqualizerProducts in
theorem Modules.exists_finite_affineCover_isLimit_sheafConditionFork (X : Scheme.{u})
    [CompactSpace X] [QuasiSeparatedSpace X] (M : X.Modules) :
    ∃ (ι : Type u) (_ : Finite ι) (U : ι → X.Opens),
      (∀ i, IsAffineOpen (U i)) ∧ (⨆ i, U i = ⊤) ∧
      (∀ i j, IsCompact ((U i : Set X) ∩ (U j : Set X))) ∧
      Nonempty (IsLimit (fork M.presheaf U)) := by
  obtain ⟨s, hs, hcov, hqc⟩ := X.exists_finite_affineCover_inter_isQuasiCompact
  have hfin : Finite ↥s := hs.to_subtype
  refine ⟨↥s, hfin, fun i => ((i : X.affineOpens) : X.Opens), fun i => i.1.2, ?_, ?_,
    fun i j => hqc i.1 i.2 j.1 j.2, ⟨M.gammaIsLimitSheafConditionFork _⟩⟩
  · rw [← hcov, iSup_subtype']
  · rintro ⟨i, hi⟩ ⟨j, hj⟩
    exact hqc i hi j hj

end AlgebraicGeometry
