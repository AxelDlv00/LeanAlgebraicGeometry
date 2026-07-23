---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.glueTripleBaseChangeIso_inv_app_app
docstring: 'Sections of the triple-overlap base change, inverse side: on sections
  over

  `V ⊆ U_i`, the inverse of `β_ipq` is the restriction map of `N` along the opens

  identity `glueData_preimage_image_eq₃`. Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.glueTripleBaseChangeIso_inv_app_app
type: lean
updated: '2026-07-24T03:02:10'
---
lemma glueTripleBaseChangeIso_inv_app_app (D : Scheme.GlueData.{0}) (i p q : D.J)
    (N : (D.V (p, q)).Modules) (V : (D.U i).Opens) :
    (((glueTripleBaseChangeIso D i p q).inv.app N).app V :
        Γ(N, (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)) ''ᵁ
            ((pullback.fst (D.f i p) (D.f i q) ≫ D.f i p) ⁻¹ᵁ V))
          ⟶ Γ(N, (D.f p q ≫ D.ι p) ⁻¹ᵁ ((D.ι i) ''ᵁ V)))
      = N.presheaf.map (eqToHom (glueData_preimage_image_eq₃ D i p q V)).op := by
  ext x
  rfl