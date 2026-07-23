---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.LocallyFreeQuotient.rel_trans
file: AlgebraicJacobian/Picard/QuotFunctorDef.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LocallyFreeQuotient.rel_trans
type: lean
updated: '2026-07-24T03:02:11'
---
lemma rel_trans {T : Over S} {x y z : LocallyFreeQuotient V d T}
    (h1 : x.Rel y) (h2 : y.Rel z) : x.Rel z := by
  obtain ⟨f, hf⟩ := h1; obtain ⟨g, hg⟩ := h2
  exact ⟨f ≪≫ g,
    (congrArg (x.q ≫ ·) (Iso.trans_hom f g)).trans <|
      (Category.assoc x.q f.hom g.hom).symm.trans <|
        (congrArg (· ≫ g.hom) hf).trans hg⟩