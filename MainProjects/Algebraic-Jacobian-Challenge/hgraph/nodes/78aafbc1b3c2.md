---
author: sync
content_type: lemma
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.divisorSheaf_obj_subsingleton
docstring: Sections of `𝒪(D)` over an empty open form a subsingleton, at the sheaf
  spelling.
file: AlgebraicJacobian/RiemannRoch/Ledger/DivisorSheafQcoh.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.divisorSheaf_obj_subsingleton
type: lean
updated: '2026-07-29T06:43:23'
---
private lemma divisorSheaf_obj_subsingleton {D : X.CurveDivisor} {W : X.Opens}
    (hW : ¬ (W : Set X).Nonempty) :
    Subsingleton ((X.divisorSheaf K D).obj.obj (op W)) :=
  divisorPresheaf_obj_subsingleton K hW