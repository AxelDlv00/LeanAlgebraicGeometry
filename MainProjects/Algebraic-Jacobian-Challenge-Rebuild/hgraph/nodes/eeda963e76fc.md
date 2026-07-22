---
author: sync
content_type: definition
created: '2026-07-17T23:01:28'
decl: AlgebraicGeometry.eCurve
docstring: 'The iso-grade curve transport at the tower composite: `pic0PullbackNat`
  of the frozen

  `baseChange.compIso`.'
file: AlgebraicJacobian/Picard/Pic0ThetaCocycle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.eCurve
type: lean
updated: '2026-07-18T00:01:13'
---
noncomputable def eCurve :
    pic0Functor ((baseChange k M).obj C)
      ≅ pic0Functor ((baseChange k L ⋙ baseChange L M).obj C) where
  hom := pic0PullbackNat ((baseChange.compIso k L M).app C).inv
  inv := pic0PullbackNat ((baseChange.compIso k L M).app C).hom
  hom_inv_id := by rw [← pic0PullbackNat_comp, Iso.hom_inv_id, pic0PullbackNat_id]
  inv_hom_id := by rw [← pic0PullbackNat_comp, Iso.inv_hom_id, pic0PullbackNat_id]

/-- The σ-side reassociation: the `Over.mapComp` mirror of `baseChange.compIso`, on the
covariant `Over.map` side at `σ_{kM}`. -/
noncomputable def σMapCompIso :
    Over.map (Spec.map (CommRingCat.ofHom (algebraMap k M)))
      ≅ Over.map (Spec.map (CommRingCat.ofHom (algebraMap L M)))
          ⋙ Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L))) :=
  eqToIso (by rw [show Spec.map (CommRingCat.ofHom (algebraMap k M))
      = Spec.map (CommRingCat.ofHom (algebraMap L M))
          ≫ Spec.map (CommRingCat.ofHom (algebraMap k L)) by
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, ← IsScalarTower.algebraMap_eq]]) ≪≫
    Over.mapComp _ _

/-- The op-side bridge: `(σ_{LM}).op ⋙ (σ_{kL}).op = (σ_{LM} ≫ σ_{kL}).op` is definitional
(`eqToIso rfl`), composed with the op of the `Over.mapComp` reassociation. -/
noncomputable def αOp :
    (Over.map (Spec.map (CommRingCat.ofHom (algebraMap L M)))).op
        ⋙ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).op
      ≅ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k M)))).op :=
  eqToIso rfl ≪≫ (NatIso.op (σMapCompIso k L M))