---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.divisorVal_secRes
docstring: 'The underlying rational function of a restricted `𝒪(D)`-section (nonempty
  target) is

  unchanged: restriction is the submodule inclusion.'
file: AlgebraicJacobian/RiemannRoch/FLVQcoh.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divisorVal_secRes
type: lean
updated: '2026-07-16T21:33:29'
---
private lemma divisorVal_secRes {D : X.CurveDivisor} {V W : X.Opens} (hVW : V ≤ W)
    (hV : (V : Set X).Nonempty) (s : (X.divisorSheaf K D).obj.obj (op W)) :
    divisorVal K (secRes (X.divisorSheaf K D) hVW s) = divisorVal K s :=
  divisorPresheaf_map_val K (homOfLE hVW).op hV s

omit [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))] in