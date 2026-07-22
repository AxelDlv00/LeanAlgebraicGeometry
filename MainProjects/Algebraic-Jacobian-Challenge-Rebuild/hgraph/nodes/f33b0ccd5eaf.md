---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.whisker_eval_covers
file: AlgebraicJacobian/Picard/RelPicPi.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.whisker_eval_covers
type: lean
updated: '2026-07-16T21:33:28'
---
private lemma whisker_eval_covers [Finite ι] (x : (C ⊗ overSpec k (Π j, B j)).left) :
    ∃ i, x ∈ Scheme.Hom.opensRange
      (C ◁ Over.overSpecMap (Pi.evalAlgHom k B i)).left := by
  classical
  obtain ⟨i, hi⟩ := exists_mem_opensRange_overSpecMap_evalAlgHom B
    ((snd C (overSpec k (Π j, B j))).left.base x)
  refine ⟨i, ?_⟩
  change x ∈ Set.range ((C ◁ Over.overSpecMap (Pi.evalAlgHom k B i)).left).base
  rw [Over.range_whiskerLeft C (Over.overSpecMap (Pi.evalAlgHom k B i))]
  exact hi