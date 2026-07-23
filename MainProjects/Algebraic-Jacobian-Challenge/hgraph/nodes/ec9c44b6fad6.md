---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.glueTripleBaseChangeIso_hom_app_app
docstring: Hom-side companion of `glueTripleBaseChangeIso_inv_app_app`. Project-local.
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.glueTripleBaseChangeIso_hom_app_app
type: lean
updated: '2026-07-24T03:02:10'
---
lemma glueTripleBaseChangeIso_hom_app_app (D : Scheme.GlueData.{0}) (i p q : D.J)
    (N : (D.V (p, q)).Modules) (V : (D.U i).Opens) :
    (((glueTripleBaseChangeIso D i p q).hom.app N).app V :
        Γ(N, (D.f p q ≫ D.ι p) ⁻¹ᵁ ((D.ι i) ''ᵁ V))
          ⟶ Γ(N, (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i)) ''ᵁ
            ((pullback.fst (D.f i p) (D.f i q) ≫ D.f i p) ⁻¹ᵁ V)))
      = N.presheaf.map (eqToHom (glueData_preimage_image_eq₃ D i p q V).symm).op := by
  ext x
  rfl

/-! ### Bridges between the geometric and the site-level adjunction

`Scheme.Modules.pullbackPushforwardAdjunction f` (the geometric adjunction, with the
sheafification-built pullback) and `restrictAdjunction f` (the site-level adjunction
along an open immersion, with concrete unit/counit) share the right adjoint
`pushforward f`; `restrictFunctorIsoPullback f` is their `leftAdjointUniq`. The next
lemmas transport units, counits and congruence casts across that identification —
they are the vehicle by which the descent obligations are reduced to section-level
computations. -/

/-- **Unit comparison**: the geometric adjunction unit is the (concrete) site-level
unit followed by the pushforward of the `leftAdjointUniq` comparison. Project-local. -/
@[reassoc]