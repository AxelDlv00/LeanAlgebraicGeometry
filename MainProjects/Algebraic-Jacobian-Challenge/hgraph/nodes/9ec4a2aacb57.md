---
author: sync
content_type: theorem
created: '2026-08-01T02:08:34'
decl: AlgebraicGeometry.Scheme.Modules.epi_of_appTop_baseChange_surjective_of_finite
docstring: 'Finite target sections discharge the cokernel condition in the native

  top-section-ring fibrewise-surjectivity criterion.'
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.epi_of_appTop_baseChange_surjective_of_finite
type: lean
updated: '2026-08-01T02:08:34'
---
theorem epi_of_appTop_baseChange_surjective_of_finite
    {R : CommRingCat.{u}} {M N : (Spec R).Modules}
    [M.IsQuasicoherent] [N.IsQuasicoherent]
    (q : M ⟶ N)
    [Module.Finite Γ(Spec R, (⊤ : (Spec R).Opens))
      Γ(N, (⊤ : (Spec R).Opens))]
    (hfib : ∀ (m : Ideal Γ(Spec R, (⊤ : (Spec R).Opens))), m.IsMaximal →
      Function.Surjective
        ((show Γ(M, (⊤ : (Spec R).Opens)) →ₗ[Γ(Spec R, (⊤ : (Spec R).Opens))]
            Γ(N, (⊤ : (Spec R).Opens)) from
          (q.val.app (.op (⊤ : (Spec R).Opens))).hom).baseChange
            (Γ(Spec R, (⊤ : (Spec R).Opens)) ⧸ m))) :
    Epi q := by
  apply epi_of_appTop_baseChange_surjective q
  exact hfib

set_option backward.isDefEq.respectTransparency false in