---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.exists_finset_forall_mem_span_pow_mul
docstring: '**Chart spanning.**  For a `k`-algebra map `φ : R →+* A` that is module

  finite, with `R` spanned over `k` by the powers of `x`, there is a finite set

  `G ⊆ A` such that every element of `A` lies in the `k`-span of the ladder

  `{φ(x)^n · g : n ∈ ℕ, g ∈ G}`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/FinitenessP1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.exists_finset_forall_mem_span_pow_mul
type: lean
updated: '2026-07-24T03:02:13'
---
theorem exists_finset_forall_mem_span_pow_mul
    {φ : R →+* A} (hφ : ∀ c : k, φ (algebraMap k R c) = algebraMap k A c)
    (hfin : φ.Finite) {x : R}
    (hx : ⊤ ≤ Submodule.span k (Set.range fun n : ℕ => x ^ n)) :
    ∃ G : Finset A, ∀ a : A,
      a ∈ Submodule.span k (⋃ n : ℕ, (fun z => φ x ^ n * z) '' (G : Set A)) := by
  letI : Algebra R A := φ.toAlgebra
  haveI hfin' : Module.Finite R A := hfin
  obtain ⟨G, hG⟩ := Module.finite_def.mp hfin'
  refine ⟨G, fun a => ?_⟩
  have ha : a ∈ Submodule.span R (G : Set A) := by rw [hG]; trivial
  -- the `k`-linear incarnation of `φ`
  let φₗ : R →ₗ[k] A :=
    { toFun := φ
      map_add' := φ.map_add
      map_smul' := fun c r => by
        simp only [Algebra.smul_def, map_mul, hφ, RingHom.id_apply] }
  induction ha using Submodule.span_induction with
  | mem z hz =>
    refine Submodule.subset_span (Set.mem_iUnion.mpr ⟨0, ⟨z, hz, ?_⟩⟩)
    simp
  | zero => exact zero_mem _
  | add y z hy hz ihy ihz => exact add_mem ihy ihz
  | smul r z hz ihz =>
    have hra : r • z = φ r * z := by
      rw [Algebra.smul_def, RingHom.algebraMap_toAlgebra]
    rw [hra]
    -- `φ r` lies in the `k`-span of the powers of `φ x`
    have hr : φ r ∈ Submodule.span k (Set.range fun n : ℕ => φ x ^ n) := by
      have h1 : φ r ∈ Submodule.map φₗ (Submodule.span k (Set.range fun n : ℕ => x ^ n)) :=
        Submodule.mem_map_of_mem (hx trivial)
      rw [Submodule.map_span] at h1
      refine Submodule.span_le.mpr ?_ h1
      rintro _ ⟨_, ⟨n, rfl⟩, rfl⟩
      exact Submodule.subset_span ⟨n, (map_pow φ x n).symm⟩
    -- multiply the two spans
    have hmul := Submodule.mul_mem_mul hr ihz
    rw [Submodule.span_mul_span] at hmul
    refine Submodule.span_le.mpr ?_ hmul
    rintro _ ⟨p, hp, q, hq, rfl⟩
    obtain ⟨n, rfl⟩ := hp
    simp only [Set.mem_iUnion, Set.mem_image] at hq
    obtain ⟨j, g, hg, rfl⟩ := hq
    refine Submodule.subset_span (Set.mem_iUnion.mpr ⟨n + j, ⟨g, hg, ?_⟩⟩)
    rw [pow_add]
    ring

end ChartSpan

/-! ## `k`-algebra compatibility of a morphism of `Spec k`-schemes

The pullback ring maps of a morphism `π : C ⟶ Y` in `Over (Spec k)` are
`k`-algebra maps for the structure-morphism `k`-algebra structures
(`Scheme.toModuleKSheaf.algebraSection`) on the section rings. -/

section OverAlgebra

variable {k : Type u} [Field k] {C Y : Over (Spec (CommRingCat.of k))}