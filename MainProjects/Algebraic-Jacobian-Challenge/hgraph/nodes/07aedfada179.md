---
author: sync
content_type: structure
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Grassmannian.RankQuotient
docstring: 'A **rank-`d` quotient of `O_T^r`** on a scheme `T`: a sheaf of modules
  `F` on `T`,

  locally free of rank `d`, together with an epimorphism `q : O_T^r ↠ F`. This is
  the

  unbundled datum whose equivalence classes form the value of the Grassmannian functor.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.RankQuotient
type: lean
updated: '2026-07-24T17:02:57'
---
structure RankQuotient (r d : ℕ) (T : Scheme.{0}) where
  /-- The quotient sheaf. -/
  F : T.Modules
  /-- The quotient map out of the trivial rank-`r` bundle. -/
  q : SheafOfModules.free (R := T.ringCatSheaf) (Fin r) ⟶ F
  /-- The quotient map is an epimorphism (surjective). -/
  epi : Epi q
  /-- The quotient sheaf is locally free of rank `d`. -/
  locFree : SheafOfModules.IsLocallyFreeOfRank F d