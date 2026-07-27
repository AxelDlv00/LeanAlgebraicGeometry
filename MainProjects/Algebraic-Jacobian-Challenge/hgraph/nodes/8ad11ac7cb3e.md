---
author: sync
content_type: theorem
created: '2026-07-27T16:23:54'
decl: AlgebraicGeometry.Adelic.Peel.of_list
docstring: '**Chaining one-point peels along a list.**  If every one-point bump peels
  —

  `Peel E (1·P + E)` for every prime divisor `P` and every `E` — then `D₀` peels to

  `divisorOfList L + D₀` for every list `L`, i.e. to `D₀` plus an arbitrary effective

  divisor.  Induction on `L` with `Peel.trans`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/BoundedVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.Peel.of_list
type: lean
updated: '2026-07-27T16:23:54'
---
theorem Peel.of_list (hstep : ∀ (P : X.PrimeDivisor) (E : X.WeilDivisor),
      Peel k U₀ U₁ E (pointDivisor P + E))
    (D₀ : X.WeilDivisor) (L : List X.PrimeDivisor) :
    Peel k U₀ U₁ D₀ (divisorOfList L + D₀) := by
  induction L with
  | nil =>
    have h0 : divisorOfList ([] : List X.PrimeDivisor) + D₀ = D₀ := by
      rw [divisorOfList, zero_add]
    rw [h0]
    exact Peel.refl k U₀ U₁ D₀
  | cons P L ih =>
    have hassoc : divisorOfList (P :: L) + D₀ =
        pointDivisor P + (divisorOfList L + D₀) := by
      rw [divisorOfList]; abel
    rw [hassoc]
    refine ih.trans k U₀ U₁ (hstep P (divisorOfList L + D₀)) fun Q => ?_
    exact le_add_pointDivisor (divisorOfList L + D₀) P Q