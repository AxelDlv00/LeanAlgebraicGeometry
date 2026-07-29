---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: RingTheory.Module.exists_minimalSurjection_finite_localRing
docstring: "For any commutative ring `R`, ideal `I`, `R`-module `M`, and nonempty\
  \ finite\ntype `ι`, the depth of the Pi module `ι → M` equals the depth of `M`:\n\
  ```\n  depth I (ι → M) = depth I M.\n```\nThis yields the `pd_R(M) = 0` case of\
  \ the Auslander–Buchsbaum formula: a nonzero\nfinite free module `M ≃ₗ[R] Fin k\
  \ → R` has `depth(M) = depth(R)`, so\n`0 + depth(M) = depth(R)` holds. -/\nlemma\
  \ depth_pi_const_eq_depth_of_nonempty\n    {R : Type u} [CommRing R] (I : Ideal\
  \ R)\n    {ι : Type*} [Finite ι] [Nonempty ι]\n    {M : Type v} [AddCommGroup M]\
  \ [Module R M] :\n    depth I (ι → M) = depth I M := by\n  unfold depth\n  by_cases\
  \ h : I • (⊤ : Submodule R (ι → M)) = ⊤\n  · rw [if_pos h, if_pos ((ideal_smul_top_pi_const_eq_top_iff\
  \ I).mp h)]\n  · rw [if_neg h, if_neg (mt (ideal_smul_top_pi_const_eq_top_iff I).mpr\
  \ h)]\n    congr 1\n    ext n\n    refine ⟨?_, ?_⟩\n    · rintro ⟨rs, hlen, hmem,\
  \ hreg⟩\n      exact ⟨rs, hlen, hmem, (isRegular_pi_const_iff_of_nonempty rs).mp\
  \ hreg⟩\n    · rintro ⟨rs, hlen, hmem, hreg⟩\n      exact ⟨rs, hlen, hmem, (isRegular_pi_const_iff_of_nonempty\
  \ rs).mpr hreg⟩\n\n/-! ### Minimal surjections onto a finite module over a local\
  \ ring\n\nFor a finite `R`-module `M` over a local ring `R`, there exists a surjective\n\
  `R`-linear map `f : (Fin n → R) →ₗ[R] M` of the **minimal possible rank**\n`n =\
  \ dim_κ (κ ⊗_R M)` (where `κ = R/\U0001D52A` is the residue field) whose **kernel\n\
  is contained in `\U0001D52A • ⊤`**. This is the first step of constructing a *minimal\n\
  finite free resolution*: iterating the construction on the kernel (which is\nitself\
  \ finitely generated when `R` is Noetherian) produces successive\nsyzygies whose\
  \ differential maps each have image in `\U0001D52A` times their target.\n\nThis\
  \ is the single-step form of Stacks `lemma-add-trivial-complex`, used in the\nAuslander–Buchsbaum\
  \ induction (`auslander_buchsbaum_formula_succ_pd`). The proof\nis the **Nakayama\
  \ lift** of a κ-basis of `κ ⊗_R M` to an `R`-spanning family in\n`M`; the kernel\
  \ containment is read off from linear independence of the basis\ncombined with the\
  \ `1 ⊗_R -` evaluation.\n\nMathlib input:\n* `IsLocalRing.span_eq_top_of_tmul_eq_basis`\
  \ — Nakayama lift of a κ-basis.\n* `TensorProduct.mk_surjective` — the `1 ⊗_R -`\
  \ map is surjective for the\n  residue-field tensor.\n* `Module.Basis.constr_range`\
  \ — range of the linear extension equals span of\n  the chosen image set.\n* `Module.Basis.linearIndependent`\
  \ — independence of a κ-basis.\n* `IsLocalRing.residue_eq_zero_iff` — `r ∈ \U0001D52A\
  \ ↔ residue r = 0`."
file: AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
generated: lean
lean_status: lean_ok
title: RingTheory.Module.exists_minimalSurjection_finite_localRing
type: lean
updated: '2026-07-29T11:05:38'
---
