---
author: sync
content_type: lemma
created: '2026-07-18T21:01:13'
decl: AlgebraicGeometry.resHom_smul_rel'
docstring: '(Implementation) Restriction commutes with the `Scheme.overModule` action
  on the

  relative curve.'
file: AlgebraicJacobian/Picard/DivisorFamilyWindowBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.resHom_smul_rel'
type: lean
updated: '2026-08-01T09:44:14'
---
lemma resHom_smul_rel' (S : Type u) [CommRing S] [Algebra k S]
    {W V : (relCurve C S).Opens} (h : W ≤ V) (s : S) (y : Γ(relCurve C S, V)) :
    (relCurve C S).resHom h (s • y) = s • (relCurve C S).resHom h y := by
  rw [Scheme.overModule_smul_def, map_mul, Scheme.overModule_smul_def]
  congr 1
  exact (relCurve C S).overAlgebraMap_apply_res S (homOfLE h).op s