---
author: sync
content_type: lemma
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.Scheme.divisorPresheaf_map_val
docstring: The underlying function-field value of a restricted section (nonempty target)
  is unchanged.
file: AlgebraicJacobian/RiemannRoch/Ledger/DivisorSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.divisorPresheaf_map_val
type: lean
updated: '2026-07-28T18:12:20'
---
lemma divisorPresheaf_map_val {D : X.CurveDivisor} {U V : (X.Opens)ᵒᵖ} (i : U ⟶ V)
    (hV : (V.unop : Set X).Nonempty) (s : (divisorPresheaf K D).obj U) :
    divisorVal K ((divisorPresheaf K D).map i s) = divisorVal K s :=
  divisorSectionsRes_coe K (leOfHom i.unop) hV s