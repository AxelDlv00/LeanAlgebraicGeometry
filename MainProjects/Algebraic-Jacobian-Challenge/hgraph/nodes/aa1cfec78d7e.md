---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: Module.MatrixPresentation.fiberRank_le
docstring: 'An `e`-generator presentation bounds the fiber rank at every prime by

  `e`: the base-changed projection is a surjection `κ(p)^e ↠ κ(p) ⊗ M`.'
file: AlgebraicJacobian/Picard/EntryIdealStratum.lean
generated: lean
lean_status: lean_ok
title: Module.MatrixPresentation.fiberRank_le
type: lean
updated: '2026-07-24T03:02:10'
---
theorem fiberRank_le (P : MatrixPresentation R M e m) (p : Ideal R)
    [p.IsPrime] : p.fiberRank M ≤ e := by
  have hsurj := (P.baseChange p.ResidueField).surjective_proj
  have h := LinearMap.finrank_le_finrank_of_surjective
    (f := (P.baseChange p.ResidueField).proj) hsurj
  simpa [Ideal.fiberRank] using h

end Congr

end Module.MatrixPresentation

namespace Ideal

section FiberRankCongr

variable {R : Type u} [CommRing R] {M : Type u} [AddCommGroup M] [Module R M]
variable {N : Type u} [AddCommGroup N] [Module R N]