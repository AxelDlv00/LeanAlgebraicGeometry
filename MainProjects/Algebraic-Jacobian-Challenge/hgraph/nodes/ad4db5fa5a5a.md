---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechFreeEvalEngine_commFam
docstring: '**Differential comm-square of the engine identification.** The degreewise
  object isos

  `cechFreeEvalEngine_XFam` intertwine the evaluated free Čech differential with the
  engine

  differential `cechEngineDFam`.  This is the single comm-square upgrading the degreewise
  object

  iso to

  the chain iso `cechFreeEvalEngineIsoFam`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.cechFreeEvalEngine_commFam
type: lean
updated: '2026-07-28T13:22:16'
---
private lemma cechFreeEvalEngine_commFam
    (V : TopologicalSpace.Opens ↥X) (p : ℕ) :
    (cechFreeEvalEngine_XFam U V (p + 1)).hom ≫ cechEngineDFam U V p
      = (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map
          ((cechFreePresheafComplexFam U).d (p + 1) p) ≫ (cechFreeEvalEngine_XFam U V p).hom := by
  refine (cancel_epi (cechFreeEval_XFam U (Opposite.op V) (p + 1)).inv).mp ?_
  apply Limits.Sigma.hom_ext
  intro σ
  by_cases hσ : V ≤ coverInterOpenFam U σ
  · slice_lhs 1 3 => rw [cechFreeEvalEngine_X_inv_hom_ιFam U V (p + 1) σ hσ]
    slice_lhs 2 3 => rw [cechEngineD_ιFam]
    slice_rhs 1 2 => rw [cechFreeEval_X_ι_invFam U V (p + 1) σ]
    erw [← Functor.map_comp, cechFree_d_ιFam U p σ]
    erw [Functor.map_sum]
    rw [Preadditive.comp_sum]
    erw [Preadditive.sum_comp]
    apply Finset.sum_congr rfl
    intro i _
    erw [Preadditive.comp_zsmul, Functor.map_zsmul, Preadditive.zsmul_comp]
    congr 1
    have hσi : V ≤ coverInterOpenFam U (σ ∘ i.succAbove) :=
      le_trans hσ (coverInterOpen_comp_leFam U i.succAbove σ)
    erw [Functor.map_comp, Category.assoc, cechFreeEvalEngine_map_ιFam U V p (σ ∘ i.succAbove) hσi]
    erw [← Category.assoc,
      freeYonedaEval_iso_of_le_natural (coverInterOpen_comp_leFam U i.succAbove σ) hσ]
    rfl
  · exact (freeYonedaEval_isZero_of_not_le hσ).eq_of_src _ _