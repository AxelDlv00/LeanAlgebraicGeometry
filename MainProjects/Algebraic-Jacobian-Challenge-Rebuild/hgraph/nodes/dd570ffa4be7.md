---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.CechPic.pic_pullback_eq_mapRingHom
docstring: 'The core comparison behind `toPic_map`: for a morphism `g : X ⟶ Y` of
  affine schemes,

  the Picard class of the pulled-back cocycle along the product refinement equals
  the base

  change of `P.pic γ` along `g.appTop`.'
file: AlgebraicJacobian/Picard/CechPicToPicNaturality.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.Scheme.CechPic.pic_pullback_eq_mapRingHom
type: lean
updated: '2026-07-30T15:28:04'
---
private lemma pic_pullback_eq_mapRingHom [IsAffine X] [IsAffine Y] (g : X ⟶ Y)
    {𝒰 : Y.PointedCover} (γ : Y.unitsCocycle 𝒰)
    (P : 𝒰.BasicRefinement) (Q : (𝒰.pullback g).BasicRefinement) :
    (prodRefinement g P Q).pic (g.pullbackUnitsCocycle γ)
      = CommRing.Pic.mapRingHom g.appTop.hom (P.pic γ) := by
  letI algA : Algebra Γ(Y, ⊤) Γ(X, ⊤) := g.appTop.hom.toAlgebra
  set γ' := g.pullbackUnitsCocycle γ with hγ'def
  set R := prodRefinement g P Q with hRdef
  -- primed (X-side) base-change models on the family `f' i = g.appTop (P.r i)`
  letI algAS' : ∀ i, Algebra Γ(Y, ⊤)
      Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))) :=
    fun i => ((algebraMap Γ(X, ⊤) Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)))).comp
      (algebraMap Γ(Y, ⊤) Γ(X, ⊤))).toAlgebra
  haveI towerS' : ∀ i, @IsScalarTower Γ(Y, ⊤) Γ(X, ⊤)
      Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))) _ _ (algAS' i).toSMul :=
    fun i => IsScalarTower.of_algebraMap_eq fun _ => rfl
  letI algAT' : ∀ i j, Algebra Γ(Y, ⊤)
      Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))) :=
    fun i j => ((algebraMap Γ(X, ⊤) _).comp (algebraMap Γ(Y, ⊤) Γ(X, ⊤))).toAlgebra
  haveI towerT' : ∀ i j, @IsScalarTower Γ(Y, ⊤) Γ(X, ⊤)
      Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j)))
      _ _ (algAT' i j).toSMul :=
    fun i j => IsScalarTower.of_algebraMap_eq fun _ => rfl
  haveI awayT' : ∀ i j, IsLocalization.Away
      (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))
      Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))) :=
    fun i j => isLocalization_away_of_isAffine _
  letI algAW' : ∀ i j k, Algebra Γ(Y, ⊤)
      Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
        * (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r k)))) :=
    fun i j k => ((algebraMap Γ(X, ⊤) _).comp (algebraMap Γ(Y, ⊤) Γ(X, ⊤))).toAlgebra
  haveI towerW' : ∀ i j k, @IsScalarTower Γ(Y, ⊤) Γ(X, ⊤)
      Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
        * (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r k))))
      _ _ (algAW' i j k).toSMul :=
    fun i j k => IsScalarTower.of_algebraMap_eq fun _ => rfl
  haveI awayW' : ∀ i j k, IsLocalization.Away
      (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
        * (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r k)))
      Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
        * (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r k)))) :=
    fun i j k => isLocalization_away_of_isAffine _
  haveI ffP : Module.FaithfullyFlat Γ(Y, ⊤) (∀ i, Γ(Y, Y.basicOpen (P.r i))) := P.faithfullyFlat
  haveI ffP' : Module.FaithfullyFlat Γ(X, ⊤)
      (∀ i, Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)))) :=
    Module.FaithfullyFlat.pi_of_span_eq_top _
      (IsLocalization.AwayCover.span_range_algebraMap_eq_top Γ(X, ⊤) P.r P.span_eq_top)
  haveI ffR : Module.FaithfullyFlat Γ(X, ⊤) (∀ p, Γ(X, X.basicOpen (R.r p))) := R.faithfullyFlat
  -- Step C: `mapRingHom g.appTop (P.pic γ)` is the class of the base-changed cover cocycle.
  have hC : CommRing.Pic.mapRingHom g.appTop.hom (P.pic γ)
      = (IsLocalization.AwayCover.isDescentCocycle_cocycleUnit
          (A := Γ(X, ⊤)) (fun i => algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))
          (fun i => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))))
          (fun i j => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
            * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))))
          (fun i j k => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
            * (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r k)))))
          (IsLocalization.AwayCover.IsCoverCocycle.baseChange (A := Γ(Y, ⊤)) Γ(X, ⊤) P.r
            (fun i => Γ(Y, Y.basicOpen (P.r i)))
            (fun i => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))))
            (fun i j => Γ(Y, Y.basicOpen (P.r i * P.r j)))
            (fun i j => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
              * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))))
            (fun i j k => Γ(Y, Y.basicOpen (P.r i * (P.r j * P.r k))))
            (fun i j k => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
              * (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r k)))))
            (P.isCoverCocycle γ))).picClass := by
    change CommRing.Pic.mapAlgebra Γ(Y, ⊤) Γ(X, ⊤) (P.pic γ) = _
    rw [P.pic_eq_picClass γ]
    exact (IsLocalization.AwayCover.pic_baseChange (A := Γ(Y, ⊤)) Γ(X, ⊤) P.r
      (fun i => Γ(Y, Y.basicOpen (P.r i)))
      (fun i => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))))
      (fun i j => Γ(Y, Y.basicOpen (P.r i * P.r j)))
      (fun i j => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
        * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))))
      (fun i j k => Γ(Y, Y.basicOpen (P.r i * (P.r j * P.r k))))
      (fun i j k => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
        * (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r k)))))
      (P.isCoverCocycle γ) P.span_eq_top).symm
  -- geometric bookkeeping for the product refinement `R`
  have hRr : ∀ p : P.ι × Q.ι, R.r p = g.appTop.hom (P.r p.1) * Q.r p.2 := fun _ => rfl
  have hRleP : ∀ p : P.ι × Q.ι, X.basicOpen (R.r p) ≤ g ⁻¹ᵁ 𝒰.opens (P.pt p.1) := by
    intro p
    have h1 : X.basicOpen (R.r p) ≤ X.basicOpen (g.appTop.hom (P.r p.1)) := by
      rw [hRr p]; exact (X.basicOpen_mul _ _).trans_le inf_le_left
    refine h1.trans ?_
    rw [← g.preimage_basicOpen_top (P.r p.1)]
    exact g.preimage_mono (P.basicOpen_le p.1)
  have hΘle : ∀ p q : P.ι × Q.ι,
      X.basicOpen (R.r p * R.r q) ≤ g ⁻¹ᵁ (𝒰.opens (P.pt p.1) ⊓ 𝒰.opens (P.pt q.1)) := fun p q =>
    g.le_preimage_inf ((R.mul_le_left p q).trans (hRleP p)) ((R.mul_le_right p q).trans (hRleP q))
  -- the geometric cover cocycle `Θ` on `R`'s family: the pushed evaluations at `P`-points
  set Θ : ∀ p q : P.ι × Q.ι, Γ(X, X.basicOpen (R.r p * R.r q))ˣ := fun p q =>
    g.unitsAppLE (𝒰.opens (P.pt p.1) ⊓ 𝒰.opens (P.pt q.1)) (X.basicOpen (R.r p * R.r q))
      (hΘle p q) (unitsEvInf γ (P.pt p.1) (P.pt q.1)) with hΘdef
  -- restriction of `Θ` to a smaller open is again a pushed evaluation
  have hΘres : ∀ (p q : P.ι × Q.ι) (U : X.Opens) (hUR : U ≤ X.basicOpen (R.r p * R.r q))
      (hUV : U ≤ g ⁻¹ᵁ (𝒰.opens (P.pt p.1) ⊓ 𝒰.opens (P.pt q.1))),
      X.unitsRestrict hUR (Θ p q)
        = g.unitsAppLE (𝒰.opens (P.pt p.1) ⊓ 𝒰.opens (P.pt q.1)) U hUV
            (unitsEvInf γ (P.pt p.1) (P.pt q.1)) := by
    intro p q U hUR hUV
    rw [hΘdef]
    exact Scheme.Hom.unitsAppLE_map g (hΘle p q) (homOfLE hUR).op (unitsEvInf γ _ _)
  -- diagonal-restricts-to-`1` for a pushed evaluation at a repeated point
  have hdiagSelf : ∀ (a : Y) (U : X.Opens) (hUa : U ≤ g ⁻¹ᵁ 𝒰.opens a)
      (e : U ≤ g ⁻¹ᵁ (𝒰.opens a ⊓ 𝒰.opens a)),
      g.unitsAppLE (𝒰.opens a ⊓ 𝒰.opens a) U e (unitsEvInf γ a a) = 1 := by
    intro a U hUa e
    have h1 := congrArg (g.unitsAppLE (𝒰.opens a) U hUa)
      (unitsRestrict_unitsEvInf_self γ a (le_refl (𝒰.opens a)))
    rw [map_one, Scheme.Hom.map_unitsAppLE] at h1
    exact h1
  -- `Θ` is a cover cocycle on the finite localization cover `R.r`
  have hΘcc : IsLocalization.AwayCover.IsCoverCocycle (A := Γ(X, ⊤)) (f := R.r)
      (S := fun p => Γ(X, X.basicOpen (R.r p)))
      (T := fun p q => Γ(X, X.basicOpen (R.r p * R.r q)))
      (W := fun p q t => Γ(X, X.basicOpen (R.r p * (R.r q * R.r t)))) Θ := by
    constructor
    · intro p
      rw [R.diag_eq_basicRes, ← coe_unitsRestrict_basicOpen,
        hΘres p p _ (R.basicOpen_le_mul_self p)
          ((R.basicOpen_le_mul_self p).trans (hΘle p p))]
      exact congrArg Units.val (hdiagSelf (P.pt p.1) _ (hRleP p) _)
    · intro p q t
      have h23 := congrArg Units.val (hΘres q t _ (R.triple_le₂₃ p q t)
        ((R.triple_le₂₃ p q t).trans (hΘle q t)))
      have h12 := congrArg Units.val (hΘres p q _ (R.triple_le₁₂ p q t)
        ((R.triple_le₁₂ p q t).trans (hΘle p q)))
      have h13 := congrArg Units.val (hΘres p t _ (R.triple_le₁₃ p q t)
        ((R.triple_le₁₃ p q t).trans (hΘle p t)))
      rw [R.face₂₃_eq_basicRes, R.face₁₂_eq_basicRes, R.face₁₃_eq_basicRes,
        ← coe_unitsRestrict_basicOpen, ← coe_unitsRestrict_basicOpen,
        ← coe_unitsRestrict_basicOpen, h23, h12, h13, ← Units.val_mul]
      exact congrArg Units.val ((mul_comm _ _).trans
        (pullback_evInf_trans g γ (P.pt p.1) (P.pt q.1) (P.pt t.1) _ _ _))
  -- Step D: the base-change map on double overlaps is the pullback restriction along `g`.
  have happ : ∀ x : Γ(Y, ⊤), algebraMap Γ(Y, ⊤) Γ(X, ⊤) x = g.appTop x := fun _ => rfl
  have hbo : ∀ i j : P.ι, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
        * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j)) = g ⁻¹ᵁ Y.basicOpen (P.r i * P.r j) := by
    intro i j
    rw [happ, happ, ← map_mul, ← g.preimage_basicOpen_top]
  have hbcval : ∀ i j : P.ι,
      Units.map (IsLocalization.AwayCover.mapOverlap (A := Γ(Y, ⊤)) Γ(X, ⊤) P.r
        (fun i j => Γ(Y, Y.basicOpen (P.r i * P.r j)))
        (fun i j => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
          * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j)))) i j).toRingHom.toMonoidHom
          (P.coverCocycle γ i j)
        = g.unitsAppLE (𝒰.opens (P.pt i) ⊓ 𝒰.opens (P.pt j))
            (X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
              * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j)))
            ((le_of_eq (hbo i j)).trans (g.preimage_mono (P.overlap_le i j)))
            (unitsEvInf γ (P.pt i) (P.pt j)) := by
    intro i j
    let gRes : Γ(Y, Y.basicOpen (P.r i * P.r j)) →ₐ[Γ(Y, ⊤)]
        Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
          * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))) :=
      { toRingHom := (g.appLE (Y.basicOpen (P.r i * P.r j))
          (X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
            * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))) (le_of_eq (hbo i j))).hom
        commutes' := fun s => by
          change (g.appLE (Y.basicOpen (P.r i * P.r j)) _ _).hom
              ((Y.presheaf.map (homOfLE (Y.basicOpen_le (P.r i * P.r j))).op).hom s)
            = (algebraMap Γ(X, ⊤) _).comp (algebraMap Γ(Y, ⊤) Γ(X, ⊤)) s
          rw [← CommRingCat.comp_apply, Scheme.Hom.map_appLE]
          change (g.appLE ⊤ _ _).hom s = _
          rw [Scheme.Hom.appLE, CommRingCat.comp_apply]
          rfl }
    have hbridge : IsLocalization.AwayCover.mapOverlap (A := Γ(Y, ⊤)) Γ(X, ⊤) P.r
        (fun i j => Γ(Y, Y.basicOpen (P.r i * P.r j)))
        (fun i j => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
          * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j)))) i j = gRes :=
      Y.basicOpen_algHom_ext (P.r i * P.r j) _ _
    rw [hbridge, coverCocycle]
    exact Scheme.Hom.map_unitsAppLE g (le_of_eq (hbo i j)) (homOfLE (P.overlap_le i j)).op
      (unitsEvInf γ (P.pt i) (P.pt j))
  -- Step E (refine): `Θ` is the first-projection refinement of the base-changed cocycle.
  have hτ : ∀ p : P.ι × Q.ι,
      IsUnit (algebraMap Γ(X, ⊤) Γ(X, X.basicOpen (R.r p))
        (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r p.1))) := fun p =>
    IsLocalization.Away.isUnit_of_dvd (R.r p) ⟨Q.r p.2, by rw [hRr, happ]⟩
  have hτT : ∀ p q : P.ι × Q.ι,
      IsUnit (algebraMap Γ(X, ⊤) Γ(X, X.basicOpen (R.r p * R.r q))
        (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r p.1) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r q.1))) := fun p q =>
    IsLocalization.Away.isUnit_of_dvd (R.r p * R.r q)
      ⟨Q.r p.2 * Q.r q.2, by rw [hRr, hRr, happ, happ]; ring⟩
  have hrefine :
      (IsLocalization.AwayCover.isDescentCocycle_cocycleUnit (A := Γ(X, ⊤)) R.r
          (fun p => Γ(X, X.basicOpen (R.r p)))
          (fun p q => Γ(X, X.basicOpen (R.r p * R.r q)))
          (fun p q t => Γ(X, X.basicOpen (R.r p * (R.r q * R.r t)))) hΘcc).picClass
        = (IsLocalization.AwayCover.isDescentCocycle_cocycleUnit
            (A := Γ(X, ⊤)) (fun i => algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))
            (fun i => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))))
            (fun i j => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
              * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))))
            (fun i j k => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
              * (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r k)))))
            (IsLocalization.AwayCover.IsCoverCocycle.baseChange (A := Γ(Y, ⊤)) Γ(X, ⊤) P.r
              (fun i => Γ(Y, Y.basicOpen (P.r i)))
              (fun i => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))))
              (fun i j => Γ(Y, Y.basicOpen (P.r i * P.r j)))
              (fun i j => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
                * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))))
              (fun i j k => Γ(Y, Y.basicOpen (P.r i * (P.r j * P.r k))))
              (fun i j k => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
                * (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r k)))))
              (P.isCoverCocycle γ))).picClass := by
    refine IsLocalization.AwayCover.picClass_map_refine (A := Γ(X, ⊤))
      (fun i => algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))
      (fun i => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))))
      (fun i j => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
        * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))))
      (fun i j k => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
        * (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j) * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r k)))))
      R.r (fun p => Γ(X, X.basicOpen (R.r p)))
      (fun p q => Γ(X, X.basicOpen (R.r p * R.r q))) Prod.fst hτ hτT
      (fun p q t => Γ(X, X.basicOpen (R.r p * (R.r q * R.r t))))
      (IsLocalization.AwayCover.IsCoverCocycle.baseChange (A := Γ(Y, ⊤)) Γ(X, ⊤) P.r _ _ _ _ _ _
        (P.isCoverCocycle γ)) hΘcc ?_
    intro p q
    have hle' : X.basicOpen (R.r p * R.r q) ≤ X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r p.1)
        * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r q.1)) :=
      X.basicOpen_le_of_dvd ⟨Q.r p.2 * Q.r q.2, by rw [hRr, hRr, happ, happ]; ring⟩
    have hro : IsLocalization.AwayCover.refineOverlapAlgHom (A := Γ(X, ⊤))
        (fun i => algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i))
        (fun i j => Γ(X, X.basicOpen (algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r i)
          * algebraMap Γ(Y, ⊤) Γ(X, ⊤) (P.r j))))
        (fun p q => Γ(X, X.basicOpen (R.r p * R.r q))) Prod.fst hτT p q
        = X.basicRes _ _ hle' :=
      X.basicOpen_algHom_ext _ _ _
    rw [hΘdef, hro, hbcval p.1 q.1]
    exact (Scheme.Hom.unitsAppLE_map g _ (homOfLE hle').op
      (unitsEvInf γ (P.pt p.1) (P.pt q.1))).symm
  -- Step E (coboundary): `R.coverCocycle γ'` and `Θ` differ by the cross evaluations
  -- `γ (g.base (Q.pt p.2), P.pt p.1)` pulled back through `g`.
  have hRpt : ∀ p : P.ι × Q.ι, R.pt p = Q.pt p.2 := fun _ => rfl
  have hRleQ : ∀ p : P.ι × Q.ι, X.basicOpen (R.r p) ≤ g ⁻¹ᵁ 𝒰.opens (g.base (Q.pt p.2)) := by
    intro p
    have h := R.basicOpen_le p
    rwa [hRpt, PointedCover.pullback_opens] at h
  have hRccle : ∀ p q : P.ι × Q.ι, X.basicOpen (R.r p * R.r q)
      ≤ g ⁻¹ᵁ (𝒰.opens (g.base (Q.pt p.2)) ⊓ 𝒰.opens (g.base (Q.pt q.2))) := fun p q =>
    g.le_preimage_inf ((R.mul_le_left p q).trans (hRleQ p)) ((R.mul_le_right p q).trans (hRleQ q))
  have hRccval : ∀ p q : P.ι × Q.ι, R.coverCocycle γ' p q
      = g.unitsAppLE (𝒰.opens (g.base (Q.pt p.2)) ⊓ 𝒰.opens (g.base (Q.pt q.2)))
          (X.basicOpen (R.r p * R.r q)) (hRccle p q)
          (unitsEvInf γ (g.base (Q.pt p.2)) (g.base (Q.pt q.2))) := by
    intro p q
    have h : R.coverCocycle γ' p q = X.unitsRestrict
        (show X.basicOpen (R.r p * R.r q) ≤ (𝒰.pullback g).opens (Q.pt p.2)
            ⊓ (𝒰.pullback g).opens (Q.pt q.2) from R.overlap_le p q)
        (unitsEvInf (g.pullbackUnitsCocycle γ) (Q.pt p.2) (Q.pt q.2)) := rfl
    rw [h, Scheme.Hom.pullbackUnitsCocycle_unitsEvInf, Scheme.Hom.unitsAppLE_map]
  have hβle : ∀ p : P.ι × Q.ι,
      X.basicOpen (R.r p) ≤ g ⁻¹ᵁ (𝒰.opens (g.base (Q.pt p.2)) ⊓ 𝒰.opens (P.pt p.1)) :=
    fun p => g.le_preimage_inf (hRleQ p) (hRleP p)
  set β : ∀ p : P.ι × Q.ι, Γ(X, X.basicOpen (R.r p))ˣ := fun p =>
    g.unitsAppLE (𝒰.opens (g.base (Q.pt p.2)) ⊓ 𝒰.opens (P.pt p.1)) (X.basicOpen (R.r p))
      (hβle p) (unitsEvInf γ (g.base (Q.pt p.2)) (P.pt p.1)) with hβdef
  -- restriction of `β` to a smaller open is again a pushed cross evaluation
  have hβres : ∀ (p : P.ι × Q.ι) (U : X.Opens) (hUR : U ≤ X.basicOpen (R.r p))
      (hUV : U ≤ g ⁻¹ᵁ (𝒰.opens (g.base (Q.pt p.2)) ⊓ 𝒰.opens (P.pt p.1))),
      X.unitsRestrict hUR (β p)
        = g.unitsAppLE (𝒰.opens (g.base (Q.pt p.2)) ⊓ 𝒰.opens (P.pt p.1)) U hUV
            (unitsEvInf γ (g.base (Q.pt p.2)) (P.pt p.1)) := by
    intro p U hUR hUV
    rw [hβdef]
    exact Scheme.Hom.unitsAppLE_map g (hβle p) (homOfLE hUR).op
      (unitsEvInf γ (g.base (Q.pt p.2)) (P.pt p.1))
  -- the units-level coboundary identity
  have key : ∀ p q : P.ι × Q.ι, R.coverCocycle γ' p q
      = X.unitsRestrict (R.mul_le_left p q) (β p)
        * (Θ p q * X.unitsRestrict (R.mul_le_right p q) ((β q)⁻¹)) := by
    intro p q
    rw [hRccval p q,
      show Θ p q = g.unitsAppLE (𝒰.opens (P.pt p.1) ⊓ 𝒰.opens (P.pt q.1))
          (X.basicOpen (R.r p * R.r q)) (hΘle p q) (unitsEvInf γ (P.pt p.1) (P.pt q.1)) from rfl,
      map_inv,
      hβres p _ (R.mul_le_left p q) (g.le_preimage_inf ((R.mul_le_left p q).trans (hRleQ p))
        ((R.mul_le_left p q).trans (hRleP p))),
      hβres q _ (R.mul_le_right p q) (g.le_preimage_inf ((R.mul_le_right p q).trans (hRleQ q))
        ((R.mul_le_right p q).trans (hRleP q)))]
    have pt1 := pullback_evInf_trans g γ (g.base (Q.pt p.2)) (P.pt p.1) (P.pt q.1)
      (g.le_preimage_inf ((R.mul_le_left p q).trans (hRleQ p))
        ((R.mul_le_left p q).trans (hRleP p)))
      (g.le_preimage_inf ((R.mul_le_left p q).trans (hRleP p))
        ((R.mul_le_right p q).trans (hRleP q)))
      (g.le_preimage_inf ((R.mul_le_left p q).trans (hRleQ p))
        ((R.mul_le_right p q).trans (hRleP q)))
    have pt2 := pullback_evInf_trans g γ (g.base (Q.pt p.2)) (P.pt q.1) (g.base (Q.pt q.2))
      (g.le_preimage_inf ((R.mul_le_left p q).trans (hRleQ p))
        ((R.mul_le_right p q).trans (hRleP q)))
      (g.le_preimage_inf ((R.mul_le_right p q).trans (hRleP q))
        ((R.mul_le_right p q).trans (hRleQ q)))
      (hRccle p q)
    have pt3 := (pullback_evInf_trans g γ (P.pt q.1) (g.base (Q.pt q.2)) (P.pt q.1)
      (g.le_preimage_inf ((R.mul_le_right p q).trans (hRleP q))
        ((R.mul_le_right p q).trans (hRleQ q)))
      (g.le_preimage_inf ((R.mul_le_right p q).trans (hRleQ q))
        ((R.mul_le_right p q).trans (hRleP q)))
      (g.le_preimage_inf ((R.mul_le_right p q).trans (hRleP q))
        ((R.mul_le_right p q).trans (hRleP q)))).trans
      (hdiagSelf (P.pt q.1) _ ((R.mul_le_right p q).trans (hRleP q)) _)
    rw [← pt2, ← pt1, mul_eq_one_iff_eq_inv.mp pt3, mul_assoc]
  -- assemble: refinement invariance (`hrefine`) after coboundary invariance
  rw [hC, R.pic_eq_picClass γ']
  refine Eq.trans ?_ hrefine
  exact IsLocalization.AwayCover.picClass_eq_of_coboundary (A := Γ(X, ⊤)) R.r
    (fun p => Γ(X, X.basicOpen (R.r p)))
    (fun p q => Γ(X, X.basicOpen (R.r p * R.r q)))
    (fun p q t => Γ(X, X.basicOpen (R.r p * (R.r q * R.r t)))) hΘcc (R.isCoverCocycle γ') β
    (fun p q => by
      rw [R.inclLeft_eq_basicRes, R.inclRight_eq_basicRes, ← coe_unitsRestrict_basicOpen,
        ← coe_unitsRestrict_basicOpen, key p q, Units.val_mul, Units.val_mul])