---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.glueTransition_self
docstring: '**(C1)**: the diagonal transition isomorphism is the canonical cast.  Both

  sides are gluing isomorphisms for the same pair of restrictions, and gluing

  isomorphisms are unique.'
file: AlgebraicJacobian/Picard/GrassmannianZariskiSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.glueTransition_self
type: lean
updated: '2026-07-26T05:02:39'
---
lemma glueTransition_self (k : κ) :
    glueTransition hcpt k k = eqToIso (congrArg
      (fun φ => (Scheme.Modules.pullback φ).obj (y k).F)
      (show (covGD W hW).f k k
          = (covGD W hW).t k k ≫
            (covGD W hW).f k k by
        rw [(covGD W hW).t_id k, Category.id_comp])) :=
  IsGlueIso.eq (glueTransition_isGlueIso hcpt k k)
    (isGlueIso_eqToIso (y := y) k
      (show (covGD W hW).f k k
          = (covGD W hW).t k k ≫
            (covGD W hW).f k k by
        rw [(covGD W hW).t_id k, Category.id_comp])
      rfl (glueSnd_ι W hW k k))

omit [IsLocallyNoetherian S] in