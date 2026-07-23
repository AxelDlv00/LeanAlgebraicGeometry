---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechFreeEvalEngine_X_inv_hom_
docstring: '**Reduced action of the engine identification on a surviving injection.**
  For a multi-index

  `σ` with `V ≤ U_σ`, transporting the `σ`-injection through `(cechFreeEval_XFam).inv`
  and the engine

  identification `cechFreeEvalEngine_XFam` lands on the engine injection of the lift

  `k ↦ ⟨σ k, _⟩ : Fin (p+1) → I₁(V)`, precomposed by the augmentation `freeYonedaAug`
  at `V`.

  This is the summand bookkeeping feeding the differential comm-square.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechFreeEvalEngine_X_inv_hom_
type: lean
updated: '2026-07-23T18:59:37'
---
private lemma cechFreeEvalEngine_X_inv_hom_ιFam
    (V : TopologicalSpace.Opens ↥X) (p : ℕ) (σ : Fin (p + 1) → ι)
    (hσ : V ≤ coverInterOpenFam U σ) :
    Limits.Sigma.ι (fun σ : Fin (p + 1) → ι =>
        (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj
          (freeYoneda.obj (coverInterOpenFam U σ))) σ
      ≫ (cechFreeEval_XFam U (Opposite.op V) p).inv ≫ (cechFreeEvalEngine_XFam U V p).hom
      = (freeYonedaEval_iso_of_le hσ).hom
        ≫ Limits.Sigma.ι (fun _ : Fin (p + 1) → {i : ι // V ≤ U i} =>
            coverSectionModule V) (fun k => ⟨σ k, (le_coverInterOpen_iffFam U V σ).1 hσ k⟩) := by
  rw [cechFreeEvalEngine_XFam]
  simp only [Iso.trans_hom, Iso.symm_hom, Iso.inv_hom_id_assoc]
  rw [← Category.assoc]
  simp only [cechFreeEvalDropZerosFam, Limits.Sigma.ι_desc, dif_pos hσ, Limits.Sigma.whiskerEquiv,
    Limits.Sigma.ι_comp_map']
  congr 1