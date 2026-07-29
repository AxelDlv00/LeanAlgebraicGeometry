---
author: sync
content_type: definition
created: '2026-07-17T21:31:16'
decl: AlgebraicGeometry.pic0CrossBaseEquiv
docstring: '**The base-field comparison of the degree-zero subgroups**: for an `L`-test
  `T`,

  degree-zero classes of `C_L` on `T` correspond to degree-zero classes of `C` on
  the

  pushed test `(Over.map σ).obj T` — the component of θ, in the direction the frozen

  `baseChangeIso` consumes.'
file: AlgebraicJacobian/Picard/Pic0ThetaAssembly.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.pic0CrossBaseEquiv
type: lean
updated: '2026-07-29T15:26:30'
---
noncomputable def pic0CrossBaseEquiv (T : Over (Spec (.of L))) :
    pic0Subgroup ((baseChange k L).obj C) T
      ≃* pic0Subgroup C
          ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj T) where
  toFun lam :=
    ⟨picEtCrossBaseInv k L C T (lam : picEt ((baseChange k L).obj C) T), by
      refine (mem_pic0Subgroup_picEtCrossBase_iff k L C _).mpr ?_
      have h : picEtCrossBase k L C T
          (picEtCrossBaseInv k L C T (lam : picEt ((baseChange k L).obj C) T))
          = (lam : picEt ((baseChange k L).obj C) T) :=
        (picEtCrossBaseEquiv k L C T).apply_symm_apply _
      rw [h]
      exact lam.2⟩
  invFun mu :=
    ⟨picEtCrossBase k L C T (mu : picEt C
        ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj T)),
      (mem_pic0Subgroup_picEtCrossBase_iff k L C _).mp mu.2⟩
  left_inv lam := Subtype.ext ((picEtCrossBaseEquiv k L C T).apply_symm_apply _)
  right_inv mu := Subtype.ext ((picEtCrossBaseEquiv k L C T).symm_apply_apply _)
  map_mul' lam mu := Subtype.ext (map_mul (picEtCrossBaseInv k L C T) _ _)

@[simp]