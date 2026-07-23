---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.LocallyFreeQuotient.toRankQuotient
docstring: 'Re-present a rank-`d` locally free quotient of the pulled-back free module

  `(T.hom)^* O_S^r` as an absolute rank-`d` quotient of `O_T^r`

  (`AlgebraicGeometry.Grassmannian.RankQuotient`), through

  `Scheme.Modules.pullbackFreeIso`.'
file: AlgebraicJacobian/Picard/GrassmannianRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LocallyFreeQuotient.toRankQuotient
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def toRankQuotient {r d : ℕ} {T : Over S}
    (x : LocallyFreeQuotient
      (SheafOfModules.free (R := S.ringCatSheaf) (Fin r)) d T) :
    AlgebraicGeometry.Grassmannian.RankQuotient r d T.left where
  F := x.F
  q := (Scheme.Modules.pullbackFreeIso T.hom (Fin r)).inv ≫ x.q
  epi :=
    @CategoryTheory.epi_comp _ _ _ _ _
      (Scheme.Modules.pullbackFreeIso T.hom (Fin r)).inv inferInstance
      x.q x.epi
  locFree := x.locFree