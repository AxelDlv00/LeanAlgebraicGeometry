---
author: sync
content_type: theorem
created: '2026-07-28T04:57:35'
decl: AlgebraicGeometry.Adelic.sectionSub_divisorOfList_replicate_of_notMem
docstring: '**An open missing `P` sees no change along the whole tower `n·P`.**  Iterate

  `sectionSub_add_pointDivisor_of_notMem`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/ChiUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.sectionSub_divisorOfList_replicate_of_notMem
type: lean
updated: '2026-07-28T04:57:35'
---
theorem sectionSub_divisorOfList_replicate_of_notMem (U : X.Opens)
    {P : X.PrimeDivisor} (hP : P.point ∉ U) (E : X.WeilDivisor) (n : ℕ) :
    sectionSub k U (divisorOfList (List.replicate n P) + E) = sectionSub k U E := by
  induction n with
  | zero => simp only [List.replicate_zero, divisorOfList, zero_add]
  | succ m ih =>
    rw [List.replicate_succ]
    simp only [divisorOfList]
    rw [show pointDivisor P + divisorOfList (List.replicate m P) + E
          = pointDivisor P + (divisorOfList (List.replicate m P) + E) by abel,
      sectionSub_add_pointDivisor_of_notMem k U hP, ih]

variable (U₀ U₁ : X.Opens)