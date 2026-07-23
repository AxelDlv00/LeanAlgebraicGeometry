---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: RingTheory.Module.exists_minimalSurjection_finite_localRing
docstring: "**Main iter-194 Lane G closure.** For any commutative ring `R`, ideal\
  \ `I`,\n`R`-module `M`, and nonempty finite type `ι`, the depth of the Pi module\n\
  `ι → M` equals the depth of `M`:\n```\n  depth I (ι → M) = depth I M.\n```\nThis\
  \ is the substrate for the `pd_R(M) = 0` case of the Auslander–Buchsbaum\nformula:\
  \ a finite free module `M ≃ₗ[R] Fin k → R` has `depth(M) = depth(R)`,\nso `0 + depth(M)\
  \ = depth(R)` holds. -/\nlemma depth_pi_const_eq_depth_of_nonempty\n    {R : Type\
  \ u} [CommRing R] (I : Ideal R)\n    {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty\
  \ ι]\n    {M : Type v} [AddCommGroup M] [Module R M] :\n    depth I (ι → M) = depth\
  \ I M := by\n  unfold depth\n  by_cases h : I • (⊤ : Submodule R (ι → M)) = ⊤\n\
  \  · rw [if_pos h, if_pos ((ideal_smul_top_pi_const_eq_top_iff I).mp h)]\n  · rw\
  \ [if_neg h, if_neg (mt (ideal_smul_top_pi_const_eq_top_iff I).mpr h)]\n    congr\
  \ 1\n    ext n\n    refine ⟨?_, ?_⟩\n    · rintro ⟨rs, hlen, hmem, hreg⟩\n     \
  \ exact ⟨rs, hlen, hmem, (isRegular_pi_const_iff_of_nonempty rs).mp hreg⟩\n    ·\
  \ rintro ⟨rs, hlen, hmem, hreg⟩\n      exact ⟨rs, hlen, hmem, (isRegular_pi_const_iff_of_nonempty\
  \ rs).mpr hreg⟩\n\n/-! ### Helper iter-199 Lane AB-gap1 (axiom-clean): minimal surjection\
  \ substrate.\n\nFor a finite `R`-module `M` over a local ring `R`, there exists\
  \ a surjective\n`R`-linear map `f : (Fin n → R) →ₗ[R] M` of the **minimal possible\
  \ rank**\n`n = dim_κ (κ ⊗_R M)` (where `κ = R/\U0001D52A` is the residue field)\
  \ whose **kernel\nis contained in `\U0001D52A • ⊤`**. This is the first step of\
  \ constructing a *minimal\nfinite free resolution*: iterating the construction on\
  \ the kernel (which is\nitself finitely generated when `R` is Noetherian) produces\
  \ successive\nsyzygies whose differential maps each have image in `\U0001D52A` times\
  \ their target.\n\nThis is the first substrate piece of gap (1) (Stacks\n`lemma-add-trivial-complex`)\
  \ in the Auslander–Buchsbaum closure chain\n(`auslander_buchsbaum_formula_succ_pd`).\
  \ It packages the basic\n**Nakayama-lift** of a κ-basis of `κ ⊗_R M` to an `R`-spanning\
  \ family in `M`\nand reads off the kernel-containment from linear independence of\
  \ the basis\ncombined with the `1 ⊗_R -` evaluation.\n\nMathlib substrate used (all\
  \ axiom-clean):\n* `IsLocalRing.span_eq_top_of_tmul_eq_basis` — Nakayama lift of\
  \ a κ-basis.\n* `TensorProduct.mk_surjective` — the `1 ⊗_R -` map is surjective\
  \ for the\n  residue-field tensor.\n* `Module.Basis.constr_range` — range of the\
  \ linear extension equals span of\n  the chosen image set.\n* `Module.Basis.linearIndependent`\
  \ — independence of a κ-basis.\n* `IsLocalRing.residue_eq_zero_iff` — `r ∈ \U0001D52A\
  \ ↔ residue r = 0`."
file: AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
generated: lean
lean_status: lean_ok
title: RingTheory.Module.exists_minimalSurjection_finite_localRing
type: lean
updated: '2026-07-16T21:14:25'
---
