/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffSwallow
import AlgebraicJacobian.Picard.DivisorFamilyAffExtraction

/-!
# `SwallowedBy` from the Stacks `0B8B` input ALONE (R2, human decision I-0492)

`AffCoverData.SwallowedBy` (`DivisorFamilyAffSwallow.lean`) is the hypothesis that some piece
contains the whole support locus **and every other piece misses it**.  Stated that way it looks
like two inputs, and `DivisorFamilyAffSwallow.lean`'s `ofSwallowingPiece` assembles a cover from
a straddling affine open `W` plus an arbitrary cover of the rest — leaving `SwallowedBy` itself
still to be supplied.

**The second half is free.**  The support locus is CLOSED (`Scheme.LocalEquations.
isClosed_supportLocus`), so its complement is open; choose the other pieces inside that
complement and they miss the support by construction.  Since affine opens are a basis and the
relative curve is quasi-compact for a proper `C` (`DivisorFamilyAffExtraction.lean`), such a
family exists and is finite.

So the ONLY geometric input `SwallowedBy` needs is the Stacks `0B8B` half:

> `supp D` is finite over `R`, hence lies in a single affine open `W` of `C ×_k Spec R`.

which is exactly what protection I-0492 clause 2 says to USE rather than re-derive.  This file
narrows the obligation to that one statement and discharges everything around it.

## Main declarations

* `AlgebraicGeometry.exists_affCoverData_swallowedBy` — from an affine open `W ⊇ supp d`, a
  widened cover with `W` as a piece which `SwallowedBy d`.
* `AlgebraicGeometry.AffCoverData.swallowedBy_ofSwallowingPiece` — the same conclusion for the
  explicit `ofSwallowingPiece` cover, when the other pieces avoid the support.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory TopologicalSpace Opposite

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (R : Type u) [CommRing R] [Algebra k R]

namespace AffCoverData

variable {C R}

/-- **`SwallowedBy` for the explicit straddling cover**, given that the other pieces avoid the
support.  This is bookkeeping over `Fin.snoc`: the last piece is `W`, which contains the
support; every other index is a `castSucc`, whose piece is disjoint from it. -/
theorem swallowedBy_ofSwallowingPiece {d : (relCurve C R).LocalEquations}
    {W : (relCurve C R).Opens} (hW : IsAffineOpen W) {m : ℕ}
    {Ws : Fin m → (relCurve C R).Opens} (hWs : ∀ i, IsAffineOpen (Ws i))
    (hcover : W ⊔ (⨆ i, Ws i) = ⊤)
    (hsub : d.supportLocus ⊆ (W : Set (relCurve C R)))
    (hmiss : ∀ i, Disjoint d.supportLocus (Ws i : Set (relCurve C R))) :
    (ofSwallowingPiece W hW Ws hWs hcover).SwallowedBy d := by
  refine ⟨Fin.last m, ?_, ?_⟩
  · show d.supportLocus ⊆ ((Fin.snoc Ws W : Fin (m + 1) → _) (Fin.last m) : Set _)
    rw [Fin.snoc_last]
    exact hsub
  · intro j hj
    obtain ⟨i, rfl⟩ := Fin.exists_castSucc_eq.mpr hj
    show Disjoint d.supportLocus ((Fin.snoc Ws W : Fin (m + 1) → _) i.castSucc : Set _)
    rw [Fin.snoc_castSucc]
    exact hmiss i

end AffCoverData

/-- **`SwallowedBy` from the Stacks `0B8B` input alone.**  Given an affine open `W` containing
the support locus — the one geometric datum protection I-0492 clause 2 directs the lane to use
rather than re-derive — there IS a widened cover swallowed by `d`.

The rest is free, and the reason is that the support locus is CLOSED: cover the complement
`supportLocusᶜ`, which is open, by affine opens contained in it, so they miss the support by
construction; quasi-compactness (free for proper `C`) makes the family finite.  No fibre
analysis, no support tube, no packet idempotent, and no chart. -/
theorem exists_affCoverData_swallowedBy [IsProper C.hom]
    (d : (relCurve C R).LocalEquations) {W : (relCurve C R).Opens}
    (hW : IsAffineOpen W) (hsub : d.supportLocus ⊆ (W : Set (relCurve C R))) :
    ∃ D : AffCoverData C R, D.SwallowedBy d := by
  classical
  -- the complement of the support is open, and contains everything outside `W`
  let U : (relCurve C R).Opens := ⟨d.supportLocusᶜ, d.isClosed_supportLocus.isOpen_compl⟩
  -- an affine open inside `U` around each point of `U`
  have hV : ∀ z : U, ∃ V : (relCurve C R).Opens, IsAffineOpen V ∧ (z : relCurve C R) ∈ V
      ∧ V ≤ U := by
    intro z
    obtain ⟨V, hVmem, hzV, hVle⟩ :=
      Opens.isBasis_iff_nbhd.mp (relCurve C R).isBasis_affineOpens z.2
    exact ⟨V, hVmem, hzV, hVle⟩
  choose V hVaff hzV hVle using hV
  -- `W` together with those affine opens covers the curve: a point is in the support (hence in
  -- `W`) or in `U`
  have hcov : (Set.univ : Set (relCurve C R)) ⊆
      (W : Set (relCurve C R)) ∪ ⋃ z : U, (V z : Set (relCurve C R)) := by
    intro z _
    by_cases hz : z ∈ d.supportLocus
    · exact Or.inl (hsub hz)
    · exact Or.inr (Set.mem_iUnion.mpr ⟨⟨z, hz⟩, hzV ⟨z, hz⟩⟩)
  -- extract a finite subfamily of the `V`s
  have hWU : IsCompact ((W : Set (relCurve C R))ᶜ) :=
    (isClosed_compl_iff.mpr W.isOpen).isCompact
  have hsubU : (W : Set (relCurve C R))ᶜ ⊆ ⋃ z : U, (V z : Set (relCurve C R)) := by
    intro z hz
    rcases hcov (Set.mem_univ z) with h | h
    · exact absurd h hz
    · exact h
  obtain ⟨t, ht⟩ := hWU.elim_finite_subcover
    (fun z : U => (V z : Set (relCurve C R))) (fun z => (V z).isOpen) hsubU
  set e : Fin (Fintype.card {z // z ∈ t}) ≃ {z // z ∈ t} :=
    (Fintype.equivFin {z // z ∈ t}).symm with he
  -- assemble and verify the two clauses
  refine ⟨AffCoverData.ofSwallowingPiece W hW (fun j => V (e j).1)
    (fun j => hVaff (e j).1) ?_, ?_⟩
  · refine top_le_iff.mp fun z _ => ?_
    by_cases hz : z ∈ (W : Set (relCurve C R))
    · exact (Opens.mem_sup ..).mpr (Or.inl hz)
    · obtain ⟨s, hs, hzs⟩ := Set.mem_iUnion₂.mp (ht hz)
      exact (Opens.mem_sup ..).mpr (Or.inr
        (Opens.mem_iSup.mpr ⟨e.symm ⟨s, hs⟩, by rw [Equiv.apply_symm_apply]; exact hzs⟩))
  · refine AffCoverData.swallowedBy_ofSwallowingPiece hW _ _ hsub fun j => ?_
    refine Set.disjoint_left.mpr fun z hzsupp hzV => ?_
    exact (hVle (e j).1 hzV) hzsupp

end AlgebraicGeometry
