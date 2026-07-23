---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushPull_binary_coprod_prod
docstring: 'Push–pull on a binary coproduct of two legs is the binary product of the
  two leg push–pulls.

  The forward map is the canonical `prod.lift` of the two push–pull maps of the coproduct
  inclusions

  (the mandatory framing the downstream section-identification needs); it is shown
  to be an

  isomorphism by matching it leg-by-leg, via the per-leg coherence

  `pushPull_binary_leg_coherence` (★), against the manifestly-invertible reference
  chain through the

  binary disjoint-union decomposition `coprodDecompMap`.  Project-local L2 assembly

  (blueprint `lem:pushPull_binary_coprod_prod`).'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushPull_binary_coprod_prod
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def pushPull_binary_coprod_prod (F : X.Modules) (Y₀ Y₁ : Over X) :
    pushPullObj F (Over.mk (Limits.coprod.desc Y₀.hom Y₁.hom)) ≅
      pushPullObj F Y₀ ⨯ pushPullObj F Y₁ := by
  set q : Y₀.left ⨿ Y₁.left ⟶ X := Limits.coprod.desc Y₀.hom Y₁.hom with hq
  set M := (Scheme.Modules.pullback q).obj F with hM
  have wInl : (Limits.coprod.inl : Y₀.left ⟶ _) ≫ q = Y₀.hom := Limits.coprod.inl_desc _ _
  have wInr : (Limits.coprod.inr : Y₁.left ⟶ _) ≫ q = Y₁.hom := Limits.coprod.inr_desc _ _
  set overInl : Y₀ ⟶ Over.mk q := Over.homMk Limits.coprod.inl wInl with hoverInl
  set overInr : Y₁ ⟶ Over.mk q := Over.homMk Limits.coprod.inr wInr with hoverInr
  haveI : IsIso (coprodDecompMap M) := isIso_coprodDecompMap M
  -- The per-leg identifications.  Their codomains are pinned to `pushPullObj F Y₀`/`Y₁`
  -- (defeq to the `pushPullObj F (Over.mk Y₀.hom)` produced by `pushPullCoprodLegIso`); the
  -- syntactic pin is essential so the `Category.assoc`/`prod.map_fst` rewrites below can match
  -- the trailing `prod.fst` on `pushPullObj F Y₀ ⨯ pushPullObj F Y₁`.
  set idiso₀ : (pushforward q).obj ((pushforward Limits.coprod.inl).obj (M.restrict Limits.coprod.inl))
      ≅ pushPullObj F Y₀ :=
    pushPullCoprodLegIso q Limits.coprod.inl Y₀.hom wInl F with hidiso0
  set idiso₁ : (pushforward q).obj ((pushforward Limits.coprod.inr).obj (M.restrict Limits.coprod.inr))
      ≅ pushPullObj F Y₁ :=
    pushPullCoprodLegIso q Limits.coprod.inr Y₁.hom wInr F with hidiso1
  have hcoh0 : pushPullMap F overInl
      = (pushforward q).map ((Scheme.Modules.restrictAdjunction Limits.coprod.inl).unit.app M)
          ≫ idiso₀.hom := by
    rw [hidiso0]; exact pushPull_binary_leg_coherence q Limits.coprod.inl Y₀.hom wInl F
  have hcoh1 : pushPullMap F overInr
      = (pushforward q).map ((Scheme.Modules.restrictAdjunction Limits.coprod.inr).unit.app M)
          ≫ idiso₁.hom := by
    rw [hidiso1]; exact pushPull_binary_leg_coherence q Limits.coprod.inr Y₁.hom wInr F
  set chainIso : (pushforward q).obj M ≅ pushPullObj F Y₀ ⨯ pushPullObj F Y₁ :=
    (pushforward q).mapIso (asIso (coprodDecompMap M)) ≪≫
      Limits.PreservesLimitPair.iso (pushforward q) _ _ ≪≫
      Limits.prod.mapIso idiso₀ idiso₁ with hchain
  -- Match the canonical comparison against the reference chain entirely through `prod.lift`
  -- identities (`prod.lift_map`, `prod.comp_lift`, and `prodComparison = prod.lift (q_* fst)
  -- (q_* snd)`), avoiding any `≫ prod.fst` projection that the surrounding pushforward objects
  -- make awkward to reassociate.
  have hcmp : Limits.prod.lift (pushPullMap F overInl) (pushPullMap F overInr) = chainIso.hom := by
    rw [hcoh0, hcoh1, hchain, Iso.trans_hom, Iso.trans_hom, Functor.mapIso_hom, asIso_hom,
      Limits.prod.mapIso_hom, Limits.PreservesLimitPair.iso_hom]
    show Limits.prod.lift _ _ =
      (pushforward q).map (coprodDecompMap M) ≫
        Limits.prod.lift ((pushforward q).map Limits.prod.fst) ((pushforward q).map Limits.prod.snd)
          ≫ Limits.prod.map idiso₀.hom idiso₁.hom
    rw [Limits.prod.lift_map, Limits.prod.comp_lift, ← Functor.map_comp_assoc,
      ← Functor.map_comp_assoc, coprodDecompMap, Limits.prod.lift_fst, Limits.prod.lift_snd]
    rfl
  haveI : IsIso (Limits.prod.lift (pushPullMap F overInl) (pushPullMap F overInr)) := by
    rw [hcmp]; infer_instance
  exact asIso (Limits.prod.lift (pushPullMap F overInl) (pushPullMap F overInr))