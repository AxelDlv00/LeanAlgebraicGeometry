---
author: sync
content_type: theorem
created: '2026-07-19T15:31:13'
decl: AlgebraicGeometry.Over.dense_baseChange_rationalPoints
docstring: '**COV-3, density of base-changed rational points** (★ B-2 keystone, worksheet

  §1.5): over a separably closed base field `k`, for every field `L ⊇ k` and every

  nonempty open `W` of the relative curve `C_L = relCurve C L`, some `k`-rational
  point

  of `C` base-changes into `W`.


  Route: pick an affine chart `U` of `C.left` under a point of `W`; its preimage chart
  of

  `C_L` is affine with sections `Γ(U) ⊗_k L` (`Over.sectionsBaseChange`); a basic
  open

  `D(f) ⊆ W` of the chart has a nonzero coordinate `a` in an `L`-basis

  (`exists_algHom_tensorPointEval_ne_zero`); `D(a)` is nonempty in the reduced curve,
  and

  DAT-P (`Over.exists_rationalPoint_mem`) supplies a rational point there whose base

  change evaluates `f` to a nonzero element of `L`

  (`gammaSpecIso_appLE_sectionsBaseChange`), hence lies in `D(f) ⊆ W`.'
file: AlgebraicJacobian/Curve/SepPointsDense.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.dense_baseChange_rationalPoints
type: lean
updated: '2026-07-31T20:15:19'
---
theorem Over.dense_baseChange_rationalPoints [IsSepClosed k]
    [SmoothOfRelativeDimension 1 C.hom] [IsIntegral C.left]
    (W : (relCurve C L).Opens) (hW : (W : Set (relCurve C L)).Nonempty) :
    ∃ (p : Spec (.of k) ⟶ C.left) (hp : p ≫ C.hom = 𝟙 (Spec (.of k))),
      (Over.rationalPointBaseChange C L p hp).base (IsLocalRing.closedPoint L) ∈ W := by
  classical
  obtain ⟨z, hzW⟩ := hW
  -- an affine chart of `C.left` under `z`, and its affine preimage chart of `C_L`
  obtain ⟨U, hU, hxU, -⟩ := exists_isAffineOpen_mem_and_subset
    (X := C.left) (U := ⊤) (x := (fst C (overSpec k L)).left.base z) trivial
  haveI : IsAffineHom (fst C (overSpec k L)).left :=
    MorphismProperty.of_isPullback (P := @IsAffineHom)
      (Over.isPullback_left C (overSpec k L)).flip
      (isAffineHom_of_isAffine (overSpec k L).hom)
  have hV : IsAffineOpen ((fst C (overSpec k L)).left ⁻¹ᵁ U) :=
    hU.preimage (fst C (overSpec k L)).left
  have hzV : z ∈ (fst C (overSpec k L)).left ⁻¹ᵁ U := hxU
  -- a basic open of the chart inside `W` around `z`
  obtain ⟨f, hfW, hzf⟩ := hV.exists_basicOpen_le
    (V := W ⊓ ((fst C (overSpec k L)).left ⁻¹ᵁ U)) ⟨z, ⟨hzW, hzV⟩⟩ hzV
  -- its tensor coordinates: `f` is nonzero, hence has a nonzero coordinate
  have hf0 : f ≠ 0 := by
    intro h0
    rw [h0, Scheme.basicOpen_zero] at hzf
    exact hzf
  have hF0 : (Over.sectionsBaseChange C L hU.isCompact hU.isQuasiSeparated).symm f
      ≠ 0 := fun h0 => hf0 (by
    rw [← (Over.sectionsBaseChange C L hU.isCompact hU.isQuasiSeparated).apply_symm_apply
      f, h0, map_zero])
  obtain ⟨a, ha0, hkey⟩ := exists_algHom_tensorPointEval_ne_zero hF0
  -- the coordinate's basic open is nonempty in the reduced curve; DAT-P fires there
  have hane : (C.left.basicOpen a : Set C.left).Nonempty := by
    by_contra h
    rw [TopologicalSpace.Opens.not_nonempty_iff_eq_bot, basicOpen_eq_bot_iff] at h
    exact ha0 h
  obtain ⟨p, hp, hpmem⟩ := Over.exists_rationalPoint_mem C (C.left.basicOpen a) hane
  have hple : ⊤ ≤ p ⁻¹ᵁ U :=
    top_le_preimage_of_closedPoint_mem p ((C.left.basicOpen_le a) hpmem)
  -- the base-changed point lies in the chart …
  have hqle : ⊤ ≤ Over.rationalPointBaseChange C L p hp ⁻¹ᵁ
      ((fst C (overSpec k L)).left ⁻¹ᵁ U) := by
    intro y _
    change (fst C (overSpec k L)).left.base
      ((Over.rationalPointBaseChange C L p hp).base y) ∈ U
    have hbase : (fst C (overSpec k L)).left.base
        ((Over.rationalPointBaseChange C L p hp).base y) =
        p.base ((Spec.map (CommRingCat.ofHom (algebraMap k L))).base y) :=
      congr(($(Over.rationalPointBaseChange_fst C L p hp)).base y)
    refine Set.mem_of_eq_of_mem hbase ?_
    have hy : (Spec.map (CommRingCat.ofHom (algebraMap k L))).base y =
        IsLocalRing.closedPoint k := Subsingleton.elim _ _
    rw [hy]
    exact (C.left.basicOpen_le a) hpmem
  -- … and evaluates `f` to a nonzero element of `L`
  have hval := gammaSpecIso_appLE_sectionsBaseChange C L p hp hU hple hqle
    ((Over.sectionsBaseChange C L hU.isCompact hU.isQuasiSeparated).symm f)
  rw [(Over.sectionsBaseChange C L hU.isCompact hU.isQuasiSeparated).apply_symm_apply f]
    at hval
  have hne0 : (Over.rationalPointBaseChange C L p hp).appLE
      ((fst C (overSpec k L)).left ⁻¹ᵁ U) ⊤ hqle f ≠ 0 := by
    intro h0
    exact hkey (Over.rationalPointEval C p hp hple)
      (Over.rationalPointEval_ne_zero_of_mem_basicOpen C p hp hple hpmem)
      (hval.symm.trans (by rw [h0, map_zero]))
  -- membership in the basic open upstairs, via the one-point space `Spec L`
  have hmemL : IsLocalRing.closedPoint L ∈ (Spec (.of L)).basicOpen
      ((Over.rationalPointBaseChange C L p hp).appLE
        ((fst C (overSpec k L)).left ⁻¹ᵁ U) ⊤ hqle f) := by
    have hnonempty : ((Spec (.of L)).basicOpen
        ((Over.rationalPointBaseChange C L p hp).appLE
          ((fst C (overSpec k L)).left ⁻¹ᵁ U) ⊤ hqle f) : Set (Spec (.of L))).Nonempty := by
      by_contra h
      rw [TopologicalSpace.Opens.not_nonempty_iff_eq_bot, basicOpen_eq_bot_iff] at h
      exact hne0 h
    obtain ⟨y, hy⟩ := hnonempty
    have hy' : y = (IsLocalRing.closedPoint L) := Subsingleton.elim _ _
    rwa [hy'] at hy
  -- transport down to the basic open of the chart, then into `W`
  have hmem2 : IsLocalRing.closedPoint L ∈
      Over.rationalPointBaseChange C L p hp ⁻¹ᵁ
        (C ⊗ overSpec k L).left.basicOpen f := by
    have heq : (Spec (.of L)).basicOpen
        ((Over.rationalPointBaseChange C L p hp).appLE
          ((fst C (overSpec k L)).left ⁻¹ᵁ U) ⊤ hqle f) =
        ⊤ ⊓ (Spec (.of L)).basicOpen
          ((Over.rationalPointBaseChange C L p hp).app
            ((fst C (overSpec k L)).left ⁻¹ᵁ U) f) := by
      have h : (Over.rationalPointBaseChange C L p hp).appLE
          ((fst C (overSpec k L)).left ⁻¹ᵁ U) ⊤ hqle f =
          (Spec (.of L)).presheaf.map (homOfLE hqle).op
            ((Over.rationalPointBaseChange C L p hp).app
              ((fst C (overSpec k L)).left ⁻¹ᵁ U) f) := rfl
      rw [h, Scheme.basicOpen_res]
    rw [heq] at hmemL
    rw [Scheme.preimage_basicOpen]
    exact hmemL.2
  exact ⟨p, hp, (hfW hmem2).1⟩