---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.pullbackUnitIso_trans_symm_eqToIso
docstring: 'Iso-level structure-sheaf-pullback cancellation: for equal base morphisms,

  `pullbackUnitIso φ ≪≫ (pullbackUnitIso ψ).symm` is the `eqToIso` transport

  (the rank-one analogue of `pullbackFreeIso_trans_symm_eqToIso`).'
file: AlgebraicJacobian/Picard/SerreTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.pullbackUnitIso_trans_symm_eqToIso
type: lean
updated: '2026-07-24T03:02:12'
---
lemma pullbackUnitIso_trans_symm_eqToIso {T' T : Scheme.{u}} {φ ψ : T' ⟶ T} (h : φ = ψ) :
    Scheme.Modules.pullbackUnitIso φ ≪≫ (Scheme.Modules.pullbackUnitIso ψ).symm
      = eqToIso (congrArg
          (fun α => (Scheme.Modules.pullback α).obj
            (SheafOfModules.unit T.ringCatSheaf)) h) := by
  subst h; simp