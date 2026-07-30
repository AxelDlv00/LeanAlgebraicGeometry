---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: IsLocalization.AwayCover.IsCoverCocycle.baseChange
docstring: '**Base change of a Čech 1-cocycle of units.** Pushing a cover cocycle
  for `f` forward

  along `A → A''` yields a cover cocycle for the pushed family `f'' i = algebraMap
  A A'' (f i)`.'
file: AlgebraicJacobian/Algebra/LocalizationCocycleBaseChange.lean
generated: lean
lean_status: lean_ok
title: IsLocalization.AwayCover.IsCoverCocycle.baseChange
type: lean
updated: '2026-07-30T15:45:59'
---
theorem IsCoverCocycle.baseChange {γ : ∀ i j, (T i j)ˣ}
    (hγ : IsCoverCocycle (f := f) (S := S) (W := W) γ) :
    IsCoverCocycle (A := A') (f := fun i => algebraMap A A' (f i)) (S := S') (W := W')
      (fun i j => Units.map (mapOverlap A' f T T' i j).toRingHom.toMonoidHom (γ i j)) where
  diag_eq_one i := by
    change diag (A := A') (fun i => algebraMap A A' (f i)) S' T' i
        (mapOverlap A' f T T' i i (γ i i).val) = 1
    rw [diag_naturality_apply A' f S S' T T' i (γ i i).val, hγ.diag_eq_one i, map_one]
  cocycle i j k := by
    change face₂₃ (A := A') (fun i => algebraMap A A' (f i)) T' W' i j k
          (mapOverlap A' f T T' j k (γ j k).val)
        * face₁₂ (A := A') (fun i => algebraMap A A' (f i)) T' W' i j k
          (mapOverlap A' f T T' i j (γ i j).val)
      = face₁₃ (A := A') (fun i => algebraMap A A' (f i)) T' W' i j k
          (mapOverlap A' f T T' i k (γ i k).val)
    rw [face₂₃_naturality_apply A' f T T' W W' i j k (γ j k).val,
      face₁₂_naturality_apply A' f T T' W W' i j k (γ i j).val,
      face₁₃_naturality_apply A' f T T' W W' i j k (γ i k).val, ← map_mul, hγ.cocycle i j k]

/-! ## The base-change map of cover algebras and the keystone -/