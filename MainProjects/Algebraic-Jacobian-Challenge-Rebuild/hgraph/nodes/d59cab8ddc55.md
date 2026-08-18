---
author: sync
content_type: theorem
created: '2026-08-03T13:09:52'
decl: AlgebraicGeometry.divRepPullAtAff_awayMul_compat_at
docstring: Off-diagonal chart pulls agree on every canonical double localization.
file: AlgebraicJacobian/Picard/DivRepChartRangeAff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divRepPullAtAff_awayMul_compat_at
type: lean
updated: '2026-08-18T20:50:56'
---
theorem divRepPullAtAff_awayMul_compat_at
    (hOAt : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    {gamma : Nat} (hgamma : gamma ≤ g)
    (hchiGamma : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : Int))
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZarAff C (ChartRing i j) g)
    (hU : ∀ i j,
      (divRepClassifyZarAff_at (S := ChartRing i j) (gamma := gamma)
        hpi g r1 r2 b1 b2 hgamma hchiGamma (U i j)).left = ChartMap i j)
    {S : Type u} [CommRing S] [Algebra k S] (v : overSpec k S ⟶ DivOver)
    {m : Nat} (f : Fin m → S)
    (ci : Fin m → (glueData k g r1).J) (cj : Fin m → (glueData k g r2).J)
    (cw : ∀ t, ChartRing (ci t) (cj t) →ₐ[k] Localization.Away (f t))
    (hcw : ∀ t, Spec.map (CommRingCat.ofHom (cw t).toRingHom) ≫
      ChartMap (ci t) (cj t) =
        Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away (f t)))) ≫ v.left)
    (p q : Fin m) :
    DivFamZarAff.mapAlgHom (DivFamZar.awayMulLeft (k := k) f p q)
        (divRepPullAtAff hpi g r1 r2 b1 b2 U (ci p) (cj p) (cw p)) =
      DivFamZarAff.mapAlgHom (DivFamZar.awayMulRight (k := k) f p q)
        (divRepPullAtAff hpi g r1 r2 b1 b2 U (ci q) (cj q) (cw q)) := by
  classical
  letI : Algebra (Localization.Away (f p)) (Localization.Away (f p * f q)) :=
    (DivFamZar.awayMulLeft (k := k) f p q).toRingHom.toAlgebra
  letI : Algebra (Localization.Away (f q)) (Localization.Away (f p * f q)) :=
    (DivFamZar.awayMulRight (k := k) f p q).toRingHom.toAlgebra
  haveI : IsScalarTower S (Localization.Away (f p))
      (Localization.Away (f p * f q)) :=
    IsScalarTower.of_algebraMap_eq' (RingHom.ext fun x => by
      rw [RingHom.comp_apply, RingHom.algebraMap_toAlgebra]
      exact (DivFamZar.awayMulOfDvd_algebraMap
        (k := k) (f p * f q) (f p) (f q) rfl x).symm)
  haveI : IsScalarTower S (Localization.Away (f q))
      (Localization.Away (f p * f q)) :=
    IsScalarTower.of_algebraMap_eq' (RingHom.ext fun x => by
      rw [RingHom.comp_apply, RingHom.algebraMap_toAlgebra]
      exact (DivFamZar.awayMulOfDvd_algebraMap
        (k := k) (f p * f q) (f q) (f p) (mul_comm _ _) x).symm)
  haveI : IsScalarTower k (Localization.Away (f p))
      (Localization.Away (f p * f q)) :=
    IsScalarTower.of_algebraMap_eq' (RingHom.ext fun x => by
      rw [RingHom.comp_apply, RingHom.algebraMap_toAlgebra]
      exact ((DivFamZar.awayMulLeft (k := k) f p q).commutes x).symm)
  haveI : IsScalarTower k (Localization.Away (f q))
      (Localization.Away (f p * f q)) :=
    IsScalarTower.of_algebraMap_eq' (RingHom.ext fun x => by
      rw [RingHom.comp_apply, RingHom.algebraMap_toAlgebra]
      exact ((DivFamZar.awayMulRight (k := k) f p q).commutes x).symm)
  have hL : IsScalarTower.toAlgHom k (Localization.Away (f p))
      (Localization.Away (f p * f q)) = DivFamZar.awayMulLeft (k := k) f p q :=
    AlgHom.ext fun x => by
      change algebraMap (Localization.Away (f p)) (Localization.Away (f p * f q)) x = _
      rw [RingHom.algebraMap_toAlgebra]
      rfl
  have hR : IsScalarTower.toAlgHom k (Localization.Away (f q))
      (Localization.Away (f p * f q)) = DivFamZar.awayMulRight (k := k) f p q :=
    AlgHom.ext fun x => by
      change algebraMap (Localization.Away (f q)) (Localization.Away (f p * f q)) x = _
      rw [RingHom.algebraMap_toAlgebra]
      rfl
  rw [← hL, ← hR]
  exact divRepPullAtAff_mapAlgHom_eq_of_chartFactor_at
    (hpi := hpi) (g := g) (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2)
    (hOAt := hOAt) (gamma := gamma) (hgamma := hgamma)
    (hchiGamma := hchiGamma) U hU v (cw p) (cw q) (hcw p) (hcw q)

set_option maxHeartbeats 2400000 in
-- Atlas factorization, off-diagonal gluing, and classifier naturality elaborate together.