---
author: sync
content_type: theorem
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.Grassmannian.specMap_ι_eq_of_map_chartTautologicalPoint_eq
docstring: '**W1 — the cross-chart converse of chart compatibility**

  (`informal/w4-g5-worksheet.md` §3.1): two affine chart maps, over possibly different

  charts `I = i.down.1` and `I'' = i''.down.1`, pulling the tautological points back
  to the

  same Grassmannian point of `B` present the same morphism `Spec B ⟶ Gr(d, r)`.


  The mapped universal matrices present the same matrix point, so they differ by a

  `GL_d(B)` factor which is the `I''`-minor of the first — hence `a` inverts the cross

  minor `P^I_{I''}` and factors through the chart overlap `U^I_{I''}`; the factored
  map

  composed with the transition pre-hom pulls the `I''`-tautological point back the
  same

  way as `a''`, so it EQUALS `a''` (DDR-7 chart hom-ext); the scheme leg is the glue-data

  pullback cone (`pullbackιIso`) and `pullback.condition`.'
file: AlgebraicJacobian/Picard/GrassmannianChartCompare.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.specMap_ι_eq_of_map_chartTautologicalPoint_eq
type: lean
updated: '2026-07-29T15:31:46'
---
theorem specMap_ι_eq_of_map_chartTautologicalPoint_eq
    (i i' : (glueData k d r).J) {B : Type u} [CommRing B] [Algebra k B]
    (a : ChartRing k d r i.down.1 →ₐ[k] B) (a' : ChartRing k d r i'.down.1 →ₐ[k] B)
    (h : Module.Grassmannian.map a (chartTautologicalPoint k d r i.down.1 i.down.2)
       = Module.Grassmannian.map a' (chartTautologicalPoint k d r i'.down.1 i'.down.2)) :
    Spec.map (CommRingCat.ofHom a.toRingHom) ≫ (glueData k d r).ι i
      = Spec.map (CommRingCat.ofHom a'.toRingHom) ≫ (glueData k d r).ι i' := by
  -- the two mapped universal matrices present the same point
  have hXs : Function.Surjective
      (matrixProj k d r B ((universalMatrix k d r i.down.1 i.down.2).map a)) :=
    matrixProj_surjective_map k d r a _ (chartTautologicalProj_surjective k d r _ _)
  have hX's : Function.Surjective
      (matrixProj k d r B ((universalMatrix k d r i'.down.1 i'.down.2).map a')) :=
    matrixProj_surjective_map k d r a' _ (chartTautologicalProj_surjective k d r _ _)
  have hpts : matrixPoint k d r B ((universalMatrix k d r i.down.1 i.down.2).map a) hXs
      = matrixPoint k d r B ((universalMatrix k d r i'.down.1 i'.down.2).map a') hX's := by
    rw [← map_matrixPoint k d r a (universalMatrix k d r i.down.1 i.down.2)
        (chartTautologicalProj_surjective k d r _ _) hXs,
      ← map_matrixPoint k d r a' (universalMatrix k d r i'.down.1 i'.down.2)
        (chartTautologicalProj_surjective k d r _ _) hX's,
      ← chartTautologicalPoint_eq_matrixPoint, ← chartTautologicalPoint_eq_matrixPoint]
    exact h
  -- the `GL_d` factor and the cross minor
  obtain ⟨U, hU, hXU⟩ := exists_isUnit_mul_of_matrixPoint_eq k d r B _ _ hXs hX's hpts
  have hminor' : frameMinor k d r B ((universalMatrix k d r i'.down.1 i'.down.2).map a')
      i'.down.1 i'.down.2 = 1 := by
    rw [frameMinor, Matrix.submatrix_map, universalMatrix_submatrix_self,
      Matrix.map_one _ (map_zero a') (map_one a')]
  have hminorX : frameMinor k d r B ((universalMatrix k d r i.down.1 i.down.2).map a)
      i'.down.1 i'.down.2 = U := by
    have hstep : frameMinor k d r B ((universalMatrix k d r i.down.1 i.down.2).map a)
        i'.down.1 i'.down.2
        = U * frameMinor k d r B ((universalMatrix k d r i'.down.1 i'.down.2).map a')
            i'.down.1 i'.down.2 := by
      simp only [frameMinor]
      rw [hXU, mul_submatrix_col]
    rw [hstep, hminor', Matrix.mul_one]
  -- `a` inverts the cross minor `P^I_{I'}`
  have hunit : IsUnit (a (minorDet k d r i.down.1 i'.down.1 i.down.2 i'.down.2)) := by
    have hdet : a (minorDet k d r i.down.1 i'.down.1 i.down.2 i'.down.2)
        = (frameMinor k d r B ((universalMatrix k d r i.down.1 i.down.2).map a)
            i'.down.1 i'.down.2).det := by
      rw [minorDet, frameMinor, Matrix.submatrix_map]
      exact RingHom.map_det a.toRingHom _
    rw [hdet, hminorX]
    exact hU
  -- `a` factors through the chart overlap `U^I_{I'}`
  set ψ : Localization.Away (minorDet k d r i.down.1 i'.down.1 i.down.2 i'.down.2) →ₐ[k] B :=
    awayLiftAlgHom _ a hunit with hψdef
  have hψ1 : ψ.comp (Algebra.algHom k (ChartRing k d r i.down.1)
      (Localization.Away (minorDet k d r i.down.1 i'.down.1 i.down.2 i'.down.2))) = a :=
    awayLiftAlgHom_comp_algHom _ a hunit
  -- the factored map composed with the transition pre-hom is `a'`
  have hψ2 : ψ.comp (transitionPreMap k d r i.down.1 i'.down.1 i.down.2 i'.down.2) = a' := by
    apply algHom_ext_of_map_chartTautologicalPoint_eq k d r i'.down.1 i'.down.2
    calc Module.Grassmannian.map
          (ψ.comp (transitionPreMap k d r i.down.1 i'.down.1 i.down.2 i'.down.2))
          (chartTautologicalPoint k d r i'.down.1 i'.down.2)
        = Module.Grassmannian.map ψ (Module.Grassmannian.map
            (transitionPreMap k d r i.down.1 i'.down.1 i.down.2 i'.down.2)
            (chartTautologicalPoint k d r i'.down.1 i'.down.2)) := by
          rw [Module.Grassmannian.map_comp]
      _ = Module.Grassmannian.map ψ (Module.Grassmannian.map
            (Algebra.algHom k (ChartRing k d r i.down.1)
              (Localization.Away (minorDet k d r i.down.1 i'.down.1 i.down.2 i'.down.2)))
            (chartTautologicalPoint k d r i.down.1 i.down.2)) := by
          rw [map_transitionPreMap_chartTautologicalPoint]
      _ = Module.Grassmannian.map (ψ.comp (Algebra.algHom k (ChartRing k d r i.down.1)
            (Localization.Away (minorDet k d r i.down.1 i'.down.1 i.down.2 i'.down.2))))
            (chartTautologicalPoint k d r i.down.1 i.down.2) := by
          rw [Module.Grassmannian.map_comp]
      _ = Module.Grassmannian.map a (chartTautologicalPoint k d r i.down.1 i.down.2) := by
          rw [hψ1]
      _ = Module.Grassmannian.map a' (chartTautologicalPoint k d r i'.down.1 i'.down.2) :=
          h
  -- ring-level composition forms
  have hψ1c : CommRingCat.ofHom (algebraMap (ChartRing k d r i.down.1)
        (Localization.Away (minorDet k d r i.down.1 i'.down.1 i.down.2 i'.down.2)))
        ≫ CommRingCat.ofHom ψ.toRingHom
      = CommRingCat.ofHom a.toRingHom := by
    rw [← CommRingCat.ofHom_comp]
    exact congrArg CommRingCat.ofHom (congrArg AlgHom.toRingHom hψ1)
  have hψ2c : CommRingCat.ofHom
        (transitionPreMap k d r i.down.1 i'.down.1 i.down.2 i'.down.2).toRingHom
        ≫ CommRingCat.ofHom ψ.toRingHom
      = CommRingCat.ofHom a'.toRingHom := by
    rw [← CommRingCat.ofHom_comp]
    exact congrArg CommRingCat.ofHom (congrArg AlgHom.toRingHom hψ2)
  -- the scheme leg through the chart-overlap pullback
  set φ : Spec (CommRingCat.of B) ⟶
      Limits.pullback ((glueData k d r).ι i) ((glueData k d r).ι i') :=
    Spec.map (CommRingCat.ofHom ψ.toRingHom) ≫ (pullbackιIso k d r i i').inv with hφdef
  have hfst : φ ≫ Limits.pullback.fst ((glueData k d r).ι i) ((glueData k d r).ι i')
      = Spec.map (CommRingCat.ofHom a.toRingHom) :=
    (Category.assoc _ _ _).trans
      ((congrArg (Spec.map (CommRingCat.ofHom ψ.toRingHom) ≫ ·)
          (pullbackιIso_inv_fst k d r i i')).trans
        ((Spec.map_comp _ _).symm.trans (congrArg Spec.map hψ1c)))
  have hsnd : φ ≫ Limits.pullback.snd ((glueData k d r).ι i) ((glueData k d r).ι i')
      = Spec.map (CommRingCat.ofHom a'.toRingHom) :=
    (Category.assoc _ _ _).trans
      ((congrArg (Spec.map (CommRingCat.ofHom ψ.toRingHom) ≫ ·)
          (pullbackιIso_inv_snd k d r i i')).trans
        ((congrArg (Spec.map (CommRingCat.ofHom ψ.toRingHom) ≫ ·)
            (chartTransition_comp_chartIncl k d r i.down.1 i'.down.1
              i.down.2 i'.down.2)).trans
          ((Spec.map_comp _ _).symm.trans (congrArg Spec.map hψ2c))))
  calc Spec.map (CommRingCat.ofHom a.toRingHom) ≫ (glueData k d r).ι i
      = φ ≫ Limits.pullback.fst ((glueData k d r).ι i) ((glueData k d r).ι i')
          ≫ (glueData k d r).ι i :=
        (congrArg (· ≫ (glueData k d r).ι i) hfst.symm).trans (Category.assoc _ _ _)
    _ = φ ≫ Limits.pullback.snd ((glueData k d r).ι i) ((glueData k d r).ι i')
          ≫ (glueData k d r).ι i' :=
        congrArg (φ ≫ ·) Limits.pullback.condition
    _ = Spec.map (CommRingCat.ofHom a'.toRingHom) ≫ (glueData k d r).ι i' :=
        (Category.assoc _ _ _).symm.trans
          (congrArg (· ≫ (glueData k d r).ι i') hsnd)