---
author: sync
content_type: theorem
created: '2026-07-19T11:31:12'
decl: AlgebraicGeometry.specMap_awayPiece_eq_of_clause
docstring: '(Implementation) **One frame piece of an overlap ring, against a clause**:
  if `v`

  satisfies the `divClassify` clause for `F` over `S₀` and the restriction of `F`
  to a

  frame piece `Localization.Away x` of a `k`/`S₀`-tower ring `B` is chart-framed,
  then

  the further restriction of `v` chart-factors there — the clause transport

  (`DivClassifyClause.extend`) at the composite tower `S₀ → B → Away x`.'
file: AlgebraicJacobian/Picard/DivRepClassifyZarCompat.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.specMap_awayPiece_eq_of_clause
type: lean
updated: '2026-07-30T15:46:01'
---
private theorem specMap_awayPiece_eq_of_clause
    {S₀ : Type u} [CommRing S₀] [Algebra k S₀]
    {B : Type u} [CommRing B] [Algebra k B] [Algebra S₀ B] [IsScalarTower k S₀ B]
    (F : DivFam C S₀ π g)
    {v : Spec (CommRingCat.of S₀) ⟶
      DivScheme k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hπ g).symm)}
    (hv : DivClassifyClause hπ g r₁ r₂ b₁ b₂ F v)
    (x : B) {i : (glueData k g r₁).J} {j : (glueData k g r₂).J}
    (ω : PairChartRing k g r₁ g r₂ i j →ₐ[k] Localization.Away x)
    (hω₁ : (Module.Grassmannian.map ω (pairTautFst k g r₁ r₂ i j)).toSubmodule
      = Submodule.map
          (LinearMap.baseChange (Localization.Away x) b₁.equivFun.toLinearMap)
          (divFamEps hπ g
            (DivFam.mapAlg (Localization.Away x) g (DivFam.mapAlg B g F))).1)
    (hω₂ : (Module.Grassmannian.map ω (pairTautSnd k g r₁ r₂ i j)).toSubmodule
      = Submodule.map
          (LinearMap.baseChange (Localization.Away x) b₂.equivFun.toLinearMap)
          (divFamEps hπ g
            (DivFam.mapAlg (Localization.Away x) g (DivFam.mapAlg B g F))).2) :
    Spec.map (CommRingCat.ofHom (algebraMap B (Localization.Away x)))
        ≫ Spec.map (CommRingCat.ofHom (algebraMap S₀ B))
        ≫ v ≫ divSchemeι k (windowS_choice π hπ g • fiberWeilDivisor π)
          (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
          (b₂.map (windowShiftEquiv hπ g).symm)
      = Spec.map (CommRingCat.ofHom ω.toRingHom) ≫ pairChartMap k g r₁ g r₂ i j := by
  -- the ambient `Algebra S₀ (Localization ‥)` instance IS the composite tower
  haveI : IsScalarTower S₀ B (Localization.Away x) :=
    IsScalarTower.of_algebraMap_eq' rfl
  haveI : IsScalarTower k B (Localization.Away x) :=
    IsScalarTower.of_algebraMap_eq' rfl
  haveI : IsScalarTower k S₀ (Localization.Away x) :=
    IsScalarTower.of_algebraMap_eq' (by
      rw [IsScalarTower.algebraMap_eq k B (Localization.Away x),
        IsScalarTower.algebraMap_eq k S₀ B,
        IsScalarTower.algebraMap_eq S₀ B (Localization.Away x),
        RingHom.comp_assoc])
  have hcomp : DivFam.mapAlg (Localization.Away x) g (DivFam.mapAlg B g F)
      = DivFam.mapAlg (Localization.Away x) g F :=
    DivFam.mapAlg_comp B g (Localization.Away x) F
  have hω₁' : (Module.Grassmannian.map ω (pairTautFst k g r₁ r₂ i j)).toSubmodule
      = Submodule.map
          (LinearMap.baseChange (Localization.Away x) b₁.equivFun.toLinearMap)
          (divFamEps hπ g (DivFam.mapAlg (Localization.Away x) g F)).1 :=
    hω₁.trans (congrArg (fun F' => Submodule.map
      (LinearMap.baseChange (Localization.Away x) b₁.equivFun.toLinearMap)
      (divFamEps hπ g F').1) hcomp)
  have hω₂' : (Module.Grassmannian.map ω (pairTautSnd k g r₁ r₂ i j)).toSubmodule
      = Submodule.map
          (LinearMap.baseChange (Localization.Away x) b₂.equivFun.toLinearMap)
          (divFamEps hπ g (DivFam.mapAlg (Localization.Away x) g F)).2 :=
    hω₂.trans (congrArg (fun F' => Submodule.map
      (LinearMap.baseChange (Localization.Away x) b₂.equivFun.toLinearMap)
      (divFamEps hπ g F').2) hcomp)
  have hmain := DivClassifyClause.extend hπ g hO hχ r₁ r₂ b₁ b₂ F hv
    (Localization.Away x) i j ω hω₁' hω₂'
  have hstep : Spec.map (CommRingCat.ofHom (algebraMap B (Localization.Away x)))
        ≫ Spec.map (CommRingCat.ofHom (algebraMap S₀ B))
      = Spec.map (CommRingCat.ofHom (algebraMap S₀ (Localization.Away x))) := by
    rw [← Spec.map_comp]
    rfl
  rw [← Category.assoc, hstep]
  exact hmain

set_option maxHeartbeats 800000 in
-- Window/clause transports unfold `divFamEps`/`DivFam.window` defeq (I-0239 precedent).
set_option maxRecDepth 8000 in
include hO hχ in