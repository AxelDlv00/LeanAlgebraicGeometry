---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.PicEtAff.mapFun_mul
file: AlgebraicJacobian/Picard/PicEtAffMap.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.PicEtAff.mapFun_mul
type: lean
updated: '2026-07-30T15:46:06'
---
private lemma mapFun_mul (a b : PicEtAff C A) :
    mapFun C A' (a * b) = mapFun C A' a * mapFun C A' b := by
  induction a using ind with | _ E x =>
  induction b using ind with | _ F y =>
  have h₁ : mapFun C A' (mk C E x)
      = mk C ((E.prod F).baseChange A')
          (descentBaseChange C A' (E.prod F) (descentMap C (E.prodInl F) x)) := by
    rw [← mk_descentMap C (E.prodInl F) x, mapFun_mk]
  have h₂ : mapFun C A' (mk C F y)
      = mk C ((E.prod F).baseChange A')
          (descentBaseChange C A' (E.prod F) (descentMap C (E.prodInr F) y)) := by
    rw [← mk_descentMap C (E.prodInr F) y, mapFun_mk]
  rw [mk_mul_mk, mapFun_mk, map_mul, ← mk_mul_mk_same, h₁, h₂]