---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: RingHom.Flat.mem_nonZeroDivisors
docstring: '**The `IsSMulRegular` bridge.** A flat ring homomorphism carries nonzerodivisors
  to

  nonzerodivisors: if `r ∈ R⁰` and `f : R →+* S` is flat, then `f r ∈ S⁰`. Scalar

  multiplication by `r` is injective on the flat `R`-module `S`

  (`Module.Flat.isSMulRegular_of_nonZeroDivisors`), and `r • · = f r * ·`.'
file: AlgebraicJacobian/Algebra/DiagonalRegular.lean
generated: lean
lean_status: lean_ok
stale: true
title: RingHom.Flat.mem_nonZeroDivisors
type: lean
updated: '2026-07-29T15:26:32'
---
lemma mem_nonZeroDivisors {R S : Type*} [CommRing R] [CommRing S] {f : R →+* S}
    (hf : f.Flat) {r : R} (hr : r ∈ R⁰) : f r ∈ S⁰ := by
  letI : Algebra R S := f.toAlgebra
  have hflat : Module.Flat R S := hf
  have hreg : IsSMulRegular S r := Module.Flat.isSMulRegular_of_nonZeroDivisors hr
  have key : ∀ y : S, f r * y = 0 → y = 0 := by
    intro y hy
    refine hreg ?_
    change r • y = r • 0
    rw [smul_zero, Algebra.smul_def, RingHom.algebraMap_toAlgebra]
    exact hy
  exact mem_nonZeroDivisors_iff.mpr ⟨key, fun y hy => key y (by rw [mul_comm]; exact hy)⟩

end RingHom.Flat

namespace AlgebraicJacobian.Diagonal

variable {k B : Type*} [CommRing k] [CommRing B] [Algebra k B]
  [Algebra (Polynomial k) B] [IsScalarTower k (Polynomial k) B] [Module.Flat (Polynomial k) B]