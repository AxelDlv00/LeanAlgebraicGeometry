---
author: sync
content_type: theorem
created: '2026-07-16T21:14:29'
decl: AlgebraicGeometry.rigidity_snd_lift
docstring: '**Cartesian-monoidal identity underlying the rigidity lemma.** Post-composing
  the

  second projection `snd : X ⊗ Y ⟶ Y` with the slice section `y ↦ (x₀, y)` is the
  "collapse the

  `X`-axis onto `x₀`" endomorphism `(x, y) ↦ (x₀, y)` of `X ⊗ Y`:

  `snd ≫ lift (toUnit Y ≫ x₀) (𝟙 Y) = lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y)`.


  Pure cartesian-monoidal algebra (no geometry): `comp_lift` distributes the `snd`,
  the

  `𝟙 Y` component simplifies by `Category.comp_id`, and the `toUnit Y` component collapses
  by

  uniqueness of maps into the terminal object.'
file: AlgebraicJacobian/RigidityLemma.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rigidity_snd_lift
type: lean
updated: '2026-07-27T01:33:12'
---
theorem rigidity_snd_lift
    {X Y : Over (Spec (.of kbar))}
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X) :
    snd X Y ≫ lift (toUnit Y ≫ x₀) (𝟙 Y) =
      lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) := by
  ext1 <;> simp