---
author: sync
content_type: theorem
created: '2026-07-30T10:29:03'
decl: AlgebraicGeometry.isLocallySurjective_oneChart
docstring: '**Antecedent 2, de-coproducted at one chart**: local surjectivity of `Sigma.desc`
  for a

  `PUnit`-indexed family gives local surjectivity of the chart itself.


  The image sieve of `Sigma.desc` is contained in that of the single chart, because
  a section of

  the coproduct presheaf resolves into a section of the one summand

  (`FunctorToTypes.jointly_surjective''`, the lemma `Pic0ChartBotRefute.lean` first
  brought into

  this project) and `Sigma.ι_desc` identifies the two readings.


  This is what makes the one-chart restriction a restriction on the *index* only:
  a lane holding

  the instance the seam consumes holds this.'
file: AlgebraicJacobian/Picard/Pic0ChartSeamCollapse.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.isLocallySurjective_oneChart
type: lean
updated: '2026-07-31T20:14:50'
---
theorem isLocallySurjective_oneChart {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (h : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun _ : PUnit.{u+1} => f))) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology f := by
  haveI := h
  constructor
  intro T s
  refine Scheme.zariskiTopology.superset_covering ?_
    (Presheaf.imageSieve_mem (J := Scheme.zariskiTopology)
      (Sigma.desc (fun _ : PUnit.{u+1} => f)) s)
  intro Y g hg
  obtain ⟨t, ht⟩ := hg
  obtain ⟨i, y, rfl⟩ := CategoryTheory.FunctorToTypes.jointly_surjective'
    (Discrete.functor fun _ : PUnit.{u+1} => yoneda.obj X) (op Y) t
  refine ⟨y, ?_⟩
  rw [← ht, ← NatTrans.comp_app_apply]
  simpa using
    (NatTrans.congr_app (Sigma.ι_desc (fun _ : PUnit.{u+1} => f) i.as) (op Y)).symm ▸ rfl

/-! ## The collapse -/

variable (C) in