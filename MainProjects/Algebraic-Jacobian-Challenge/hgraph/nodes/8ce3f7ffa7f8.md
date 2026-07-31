---
author: sync
content_type: definition
created: '2026-07-31T08:04:18'
decl: AlgebraicGeometry.Scheme.DivFamily.twistQuotientMap
docstring: Tensor the divisor quotient `O -> O_D` with the pulled-back twist.
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.twistQuotientMap
type: lean
updated: '2026-07-31T08:04:18'
---
noncomputable def twistQuotientMap (L : X.Modules) (x : DivFamily π T) :
    (Modules.pullback (pullback.fst π T.hom)).obj L ⟶ x.twist L :=
  (Modules.tensorObj_right_unitor _).inv ≫
    Modules.tensorObj_functoriality (𝟙 _)
      ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q)