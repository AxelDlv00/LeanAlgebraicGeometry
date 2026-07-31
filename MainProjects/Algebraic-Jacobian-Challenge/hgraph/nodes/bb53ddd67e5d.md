---
author: sync
content_type: theorem
created: '2026-08-01T02:08:34'
decl: AlgebraicGeometry.Scheme.Modules.epi_of_appTop_baseChange_surjective
docstring: 'Top-section-ring form of `epi_of_baseChange_surjective`.


  This spelling uses the native `Gamma(Spec R, top)`-linear map carried by a

  sheaf morphism.  It interfaces directly with residue-field evaluation on the

  test scheme and with the existing affine pullback section formula, avoiding

  an extra transport through `GammaSpecIso` in geometric fibre arguments.'
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.epi_of_appTop_baseChange_surjective
type: lean
updated: '2026-08-01T02:08:34'
---
theorem epi_of_appTop_baseChange_surjective
    {R : CommRingCat.{u}} {M N : (Spec R).Modules}
    [M.IsQuasicoherent] [N.IsQuasicoherent]
    (q : M ⟶ N)
    [Module.Finite Γ(Spec R, (⊤ : (Spec R).Opens))
      (Γ(N, (⊤ : (Spec R).Opens)) ⧸
        LinearMap.range (q.val.app (.op (⊤ : (Spec R).Opens))).hom)]
    (hfib : ∀ (m : Ideal Γ(Spec R, (⊤ : (Spec R).Opens))), m.IsMaximal →
      Function.Surjective
        ((show Γ(M, (⊤ : (Spec R).Opens)) →ₗ[Γ(Spec R, (⊤ : (Spec R).Opens))]
            Γ(N, (⊤ : (Spec R).Opens)) from
          (q.val.app (.op (⊤ : (Spec R).Opens))).hom).baseChange
            (Γ(Spec R, (⊤ : (Spec R).Opens)) ⧸ m))) :
    Epi q := by
  apply epi_of_globalSections_surjective q
  change Function.Surjective (q.val.app (.op (⊤ : (Spec R).Opens))).hom
  exact AlgebraicJacobian.TwoTerm.surjective_of_baseChange_quotient_surjective
    (A := Γ(Spec R, (⊤ : (Spec R).Opens)))
    (d := (show Γ(M, (⊤ : (Spec R).Opens)) →ₗ[Γ(Spec R, (⊤ : (Spec R).Opens))]
      Γ(N, (⊤ : (Spec R).Opens)) from
        (q.val.app (.op (⊤ : (Spec R).Opens))).hom)) hfib

set_option backward.isDefEq.respectTransparency false in