---
author: sync
content_type: structure
created: '2026-07-24T17:02:46'
decl: TwoLatticePair
docstring: 'A **two-lattice pair** over the commutative ring `R`: the curve-lite avatar
  of a

  quasi-coherent module on `ℙ¹_R`. `M₀` and `M₁` are the two chart lattices, `N` the
  overlap

  module; `t₀`, `t₁`, `tN` are the chart-coordinate actions (`t₁` acting as the *inverse*

  coordinate, and the overlap action `tN` invertible); `ι₀`, `ι₁` are the restriction
  maps

  into the overlap, satisfying the bare-handed localization axioms (denominator clearing
  and

  defect annihilation) at the powers of the respective coordinates.'
file: AlgebraicJacobian/Cohomology/RigidEngineLattice.lean
generated: lean
lean_status: lean_ok
title: TwoLatticePair
type: lean
updated: '2026-08-01T09:44:10'
---
structure TwoLatticePair where
  /-- The chart-0 coordinate action on the chart-0 lattice. -/
  t₀ : Module.End R M₀
  /-- The (inverse) chart-1 coordinate action on the chart-1 lattice. -/
  t₁ : Module.End R M₁
  /-- The invertible chart-0 coordinate action on the overlap module. -/
  tN : (Module.End R N)ˣ
  /-- The restriction of the chart-0 lattice into the overlap. -/
  ι₀ : M₀ →ₗ[R] N
  /-- The restriction of the chart-1 lattice into the overlap. -/
  ι₁ : M₁ →ₗ[R] N
  /-- `ι₀` intertwines `t₀` with the overlap action. -/
  ι₀_comm : ∀ x : M₀, ι₀ (t₀ x) = tN.val (ι₀ x)
  /-- `ι₁` intertwines `t₁` with the *inverse* overlap action. -/
  ι₁_comm : ∀ y : M₁, ι₁ (t₁ y) = tN.inv (ι₁ y)
  /-- Denominator clearing at chart 0: every overlap element comes from the chart-0
  lattice after clearing by a power of the coordinate. -/
  denom₀ : ∀ n : N, ∃ (m : ℕ) (x : M₀), (tN.val ^ m) n = ι₀ x
  /-- Denominator clearing at chart 1. -/
  denom₁ : ∀ n : N, ∃ (m : ℕ) (y : M₁), (tN.inv ^ m) n = ι₁ y
  /-- Defect annihilation at chart 0: a chart-0 section vanishing on the overlap is
  killed by a power of the coordinate. -/
  ann₀ : ∀ x : M₀, ι₀ x = 0 → ∃ m : ℕ, (t₀ ^ m) x = 0
  /-- Defect annihilation at chart 1. -/
  ann₁ : ∀ y : M₁, ι₁ y = 0 → ∃ m : ℕ, (t₁ ^ m) y = 0

namespace TwoLatticePair

variable {R M₀ M₁ N}
variable (P : TwoLatticePair R M₀ M₁ N)

/-! ### The invertible overlap action -/

@[simp]