---
author: sync
content_type: lemma
created: '2026-07-29T02:23:55'
decl: AlgebraicGeometry.divFunctorAff_map
file: AlgebraicJacobian/Picard/DivisorFamilyAffMap.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divFunctorAff_map
type: lean
updated: '2026-07-31T20:14:52'
---
lemma divFunctorAff_map {T T' : (Over (Spec (.of k)))ᵒᵖ} (g : T ⟶ T')
    (s : divFamZarAff C n T.unop) :
    (divFunctorAff C n).map g s = divFamZarAff.map C n g.unop s :=
  rfl

end Functor

/-! ## Naturality of the widened affine comparison -/

section AffineNaturality

variable {A B : Type u} [CommRing A] [Algebra k A] [CommRing B] [Algebra k B]