---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechFreeAug_eval_eqFam
docstring: '**Degree-`0` augmentation comm-square (engine identification).** Evaluating
  the free Čech

  augmentation `cechFreeAugFam` at `V` and the engine codiagonal `cechEngineAug0Fam`
  agree under the

  degree-`0` object identification `cechFreeEvalEngine_XFam`.  This is the degree-`0`
  analogue of

  `cechFreeEvalEngine_commFam` and the key bridge for the nonempty quasi-isomorphism:
  it identifies the

  evaluated free augmentation with the engine augmentation.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechFreeAug_eval_eqFam
type: lean
updated: '2026-07-16T21:14:26'
---
private lemma cechFreeAug_eval_eqFam
    (V : TopologicalSpace.Opens ↥X) :
    (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map (cechFreeAugFam U)
      = (cechFreeEvalEngine_XFam U V 0).hom ≫ cechEngineAug0Fam U V := by
  refine (cancel_epi (cechFreeEval_XFam U (Opposite.op V) 0).inv).mp ?_
  apply Limits.Sigma.hom_ext
  intro σ
  by_cases hσ : V ≤ coverInterOpenFam U σ
  · have hsd : Limits.Sigma.ι
          (fun σ : Fin (0 + 1) → ι => freeYoneda.obj (coverInterOpenFam U σ)) σ ≫ cechFreeAugFam U
        = freeYonedaAug (coverInterOpenFam U σ) := by
      simp only [cechFreeAugFam, Limits.Sigma.ι_desc]
    rw [reassoc_of% (cechFreeEval_X_ι_invFam U V 0 σ)]
    erw [← Functor.map_comp, hsd, PresheafOfModules.evaluation_map,
        ← freeYonedaEval_iso_of_le_hom_eq_aug hσ]
    erw [reassoc_of% (cechFreeEvalEngine_X_inv_hom_ιFam U V 0 σ hσ)]
    erw [cechEngineAug0_ιFam]
    exact (Category.comp_id _).symm
  · exact (freeYonedaEval_isZero_of_not_le hσ).eq_of_src _ _