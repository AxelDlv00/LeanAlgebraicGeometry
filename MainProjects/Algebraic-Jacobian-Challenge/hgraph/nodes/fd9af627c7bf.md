---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.IsAffineOpen.dCoeffModuleSectionsLinearEquiv_mk_one
docstring: 'The quasi-coherent section identification sends the localisation structure

  map `x ↦ x/1` to the presheaf restriction `Γ(M, U) → Γ(M, D(g_σ))`.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/QuasicoherentDegreeOneVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.IsAffineOpen.dCoeffModuleSectionsLinearEquiv_mk_one
type: lean
updated: '2026-07-16T21:14:26'
---
@[simp] lemma IsAffineOpen.dCoeffModuleSectionsLinearEquiv_mk_one (hU : IsAffineOpen U)
    (M : X.Modules) [M.IsQuasicoherent] {ι : Type*} (g : ι → Γ(X, U))
    {m : ℕ} (σ : Fin m → ι) (x : Γ(M, U)) :
    hU.dCoeffModuleSectionsLinearEquiv M g σ (LocalizedModule.mk x 1)
      = M.presheaf.map
          (homOfLE (X.basicOpen_le (CechLocalized.sprod g σ))).op x := by
  letI : Module Γ(X, U) Γ(M, X.basicOpen (CechLocalized.sprod g σ)) :=
    Module.compHom _ (algebraMap Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g σ)))
  letI : IsScalarTower Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g σ))
      Γ(M, X.basicOpen (CechLocalized.sprod g σ)) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  haveI := Scheme.Modules.isLocalizedModule_basicOpen M hU (CechLocalized.sprod g σ)
  exact IsLocalizedModule.iso_mk_one _ _ x