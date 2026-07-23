---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Module.Finite.of_addEquiv_semilinear
docstring: '**`Module.Finite` descends along a surjective-semilinear additive

  equivalence.**  If `e : M ≃+ N` intertwines the `R`-action on `M` with the

  `S`-action on `N` through a surjective ring homomorphism `σ : R →+* S`

  (`e (r • x) = σ r • e x`) and `N` is a finite `S`-module, then `M` is a

  finite `R`-module: the preimages of a finite `S`-generating set generate

  `M` over `R`, because every `S`-scalar lifts along `σ`.'
file: AlgebraicJacobian/Picard/RigidPushforwardTransfer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Module.Finite.of_addEquiv_semilinear
type: lean
updated: '2026-07-16T21:14:27'
---
theorem Module.Finite.of_addEquiv_semilinear {R S : Type u} [Semiring R] [Semiring S]
    {M N : Type u} [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module S N]
    (σ : R →+* S) (hσ : Function.Surjective σ) (e : M ≃+ N)
    (he : ∀ (r : R) (x : M), e (r • x) = σ r • e x) (hN : Module.Finite S N) :
    Module.Finite R M := by
  obtain ⟨n, w, hw⟩ := hN.exists_fin (R := S) (M := N)
  refine Module.finite_def.mpr (Submodule.fg_def.mpr
    ⟨⇑e.symm '' Set.range w, ((Set.finite_range w).image _), ?_⟩)
  rw [eq_top_iff]
  intro x _
  have hx : e x ∈ Submodule.span S (Set.range w) := hw ▸ Submodule.mem_top
  have key : ∀ (y : N), y ∈ Submodule.span S (Set.range w) →
      e.symm y ∈ Submodule.span R (⇑e.symm '' Set.range w) := by
    intro y hy
    induction hy using Submodule.span_induction with
    | mem z hz => exact Submodule.subset_span ⟨z, hz, rfl⟩
    | zero => rw [map_zero]; exact Submodule.zero_mem _
    | add a b _ _ ha hb => rw [map_add]; exact Submodule.add_mem _ ha hb
    | smul s y hy' ih =>
      obtain ⟨r, rfl⟩ := hσ s
      have : e.symm (σ r • y) = r • e.symm y := by
        apply e.injective
        rw [he, e.apply_symm_apply, e.apply_symm_apply]
      rw [this]
      exact Submodule.smul_mem _ _ ih
  simpa using key (e x) hx

/-! ## §2. The noetherian coherence criterion (finite sections ⟹ finitely presented)

For a quasi-coherent module `N` on a locally noetherian scheme, finiteness
of the section modules over affine opens forces finite presentation: over
each affine `U` the module `N|_U` is the tilde of its (finite, hence — by
noetherianity — finitely presented) section module, and a finite module
over a noetherian ring admits a finite free presentation whose tilde is a
finite `SheafOfModules.Presentation`. -/

namespace Scheme.Modules

variable {Y : Scheme.{u}}