---
author: sync
content_type: theorem
created: '2026-07-28T19:44:59'
decl: AlgebraicGeometry.Over.relSectionsMap_sectionsBaseChange_tmul
docstring: '**The `ε ↦ 0` reduction on a pure tensor**: the relative sections comparison
  map along

  `k[ε] → k` carries the base change of `s ⊗ a` to the base change of `s ⊗ fst a`.


  Proved entirely from the landed `relSectionsMap` calculus: split the base change
  of a pure

  tensor into the curve pullback times the structure pullback

  (`Over.sectionsBaseChange_tmul` and `Over.sectionsBaseChange_one_tmul_overAlgebraMap`),
  then

  apply `relSectionsMap_pullback` to the first factor and `relSectionsMap_overAlgebraMap`
  to the

  second. No new geometry.'
file: AlgebraicJacobian/Tangent/DualNumberCarrierReduction.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.relSectionsMap_sectionsBaseChange_tmul
type: lean
updated: '2026-07-30T15:28:03'
---
theorem Over.relSectionsMap_sectionsBaseChange_tmul {W : C.left.Opens}
    (hW : IsCompact (W : Set C.left)) (hW' : IsQuasiSeparated (W : Set C.left))
    (s : Γ(C.left, W)) (a : DualNumber k) :
    relSectionsMap C (DualNumber k) k W
        (Over.sectionsBaseChange C (DualNumber k) hW hW' (s ⊗ₜ a))
      = Over.sectionsBaseChange C k hW hW' (s ⊗ₜ algebraMap (DualNumber k) k a) := by
  have h1 : Over.sectionsBaseChange C (DualNumber k) hW hW' (s ⊗ₜ a)
      = relPullbackSection C (DualNumber k) W s
        * (relCurve C (DualNumber k)).overAlgebraMap (DualNumber k)
            ((fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ W) a := by
    rw [Over.sectionsBaseChange_tmul]; rfl
  have h2 : Over.sectionsBaseChange C k hW hW' (s ⊗ₜ algebraMap (DualNumber k) k a)
      = relPullbackSection C k W s
        * (relCurve C k).overAlgebraMap k ((fst C (overSpec k k)).left ⁻¹ᵁ W)
            (algebraMap (DualNumber k) k a) := by
    rw [Over.sectionsBaseChange_tmul]; rfl
  rw [h1, h2, map_mul, relSectionsMap_pullback, relSectionsMap_overAlgebraMap]

/-! ## (b-coeff): the reduction is `fst` -/