---
author: sync
content_type: theorem
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.Scheme.exists_trimmed_trivializing_of_cechPicMap_ι_eq_one
docstring: '**The trimmed trivializing cochain of a class trivial on an open subscheme**:
  if

  `mk 𝒩 γ.class` pulls back trivially to the open subscheme `D`, there is a family
  of

  units on the `D`-trimmed members `𝒩.opens b ⊓ D`, indexed by all ambient points,

  satisfying the one-sided trivializing relation `t b ⋅ γ(b,b'') = t b''` on trimmed

  pairwise overlaps — the exact field data of `Over.PieceTrivialization`.'
file: AlgebraicJacobian/Picard/EffectivityTrivialization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.exists_trimmed_trivializing_of_cechPicMap_ι_eq_one
type: lean
updated: '2026-07-31T20:15:25'
---
theorem exists_trimmed_trivializing_of_cechPicMap_ι_eq_one
    (h1 : Scheme.CechPic.map D.ι (Scheme.CechPic.mk 𝒩 γ.class) = 1) :
    ∃ t : ∀ b : Z, Γ(Z, 𝒩.opens b ⊓ D)ˣ, ∀ b b' : Z,
      Z.unitsRestrict (le_inf (inf_le_left.trans inf_le_left) inf_le_right :
          (𝒩.opens b ⊓ 𝒩.opens b') ⊓ D ≤ 𝒩.opens b ⊓ D) (t b)
        * Z.unitsRestrict (inf_le_left :
            (𝒩.opens b ⊓ 𝒩.opens b') ⊓ D ≤ 𝒩.opens b ⊓ 𝒩.opens b')
            (Scheme.unitsEvInf γ b b')
      = Z.unitsRestrict (le_inf (inf_le_left.trans inf_le_right) inf_le_right)
          (t b') := by
  classical
  -- ### the trivializing cochain of the pulled-back cocycle, on the subscheme
  rw [Scheme.CechPic.map_mk, Scheme.Hom.pullbackUnitsH1_class,
    Scheme.CechPic.mk_eq_one_iff] at h1
  have hcoh : (D.ι.pullbackUnitsCocycle γ).IsCohomologous
      (1 : (D : Scheme.{u}).unitsCocycle (𝒩.pullback D.ι)) :=
    (OneCocycle.class_eq_iff _ _).mp h1
  obtain ⟨α, hα₀⟩ := (OneCocycle.isCohomologous_iff_evInf _ _).mp hcoh
  have hα : ∀ p p' : (D : Scheme.{u}),
      (D : Scheme.{u}).unitsRestrict
          (inf_le_left : (𝒩.pullback D.ι).opens p ⊓ (𝒩.pullback D.ι).opens p'
            ≤ (𝒩.pullback D.ι).opens p) (α p)
        * D.ι.unitsAppLE (𝒩.opens (D.ι.base p) ⊓ 𝒩.opens (D.ι.base p'))
            ((𝒩.pullback D.ι).opens p ⊓ (𝒩.pullback D.ι).opens p')
            (D.ι.le_preimage_inf inf_le_left inf_le_right)
            (Scheme.unitsEvInf γ (D.ι.base p) (D.ι.base p'))
      = (D : Scheme.{u}).unitsRestrict inf_le_right (α p') := by
    intro p p'
    have h := hα₀ p p'
    rw [OneCocycle.one_evInf, one_mul] at h
    exact h
  -- ### push the cochain to ambient units on the trimmed members
  set t' : ∀ p : (D : Scheme.{u}), Γ(Z, 𝒩.opens (D.ι.base p) ⊓ D)ˣ :=
    fun p => (Scheme.Hom.unitsPreimageEquiv D.ι
        (inf_le_opensRange D (𝒩.opens (D.ι.base p)))).symm
      ((D : Scheme.{u}).unitsRestrict (preimage_le_pullback 𝒩 D p) (α p))
    with ht'
  -- the pushed units satisfy the ambient trivializing relation on subscheme pairs
  have hrel : ∀ p p' : (D : Scheme.{u}),
      Z.unitsRestrict (le_inf (inf_le_left.trans inf_le_left) inf_le_right :
          (𝒩.opens (D.ι.base p) ⊓ 𝒩.opens (D.ι.base p')) ⊓ D
            ≤ 𝒩.opens (D.ι.base p) ⊓ D) (t' p)
        * Z.unitsRestrict (inf_le_left)
            (Scheme.unitsEvInf γ (D.ι.base p) (D.ι.base p'))
      = Z.unitsRestrict (le_inf (inf_le_left.trans inf_le_right) inf_le_right)
          (t' p') := by
    intro p p'
    apply (Scheme.Hom.unitsPreimageEquiv D.ι
      (inf_le_opensRange D (𝒩.opens (D.ι.base p) ⊓ 𝒩.opens (D.ι.base p')))).injective
    rw [map_mul, ht']
    rw [Scheme.Hom.unitsRestrict_unitsPreimageEquiv_symm D.ι
        (inf_le_opensRange D (𝒩.opens (D.ι.base p))) _ _,
      Scheme.Hom.unitsRestrict_unitsPreimageEquiv_symm D.ι
        (inf_le_opensRange D (𝒩.opens (D.ι.base p'))) _ _,
      (Scheme.Hom.unitsPreimageEquiv D.ι _).apply_symm_apply,
      (Scheme.Hom.unitsPreimageEquiv D.ι _).apply_symm_apply,
      Scheme.Hom.unitsPreimageEquiv_apply]
    simp only [Scheme.unitsRestrict_unitsRestrict, Scheme.Hom.map_unitsAppLE]
    -- restrict the subscheme relation to the preimage of the overlap
    have h := congrArg
      ((D : Scheme.{u}).unitsRestrict
        (le_inf (D.ι.preimage_mono (inf_le_left.trans inf_le_left))
          (D.ι.preimage_mono (inf_le_left.trans inf_le_right)) :
          D.ι ⁻¹ᵁ ((𝒩.opens (D.ι.base p) ⊓ 𝒩.opens (D.ι.base p')) ⊓ D)
            ≤ (𝒩.pullback D.ι).opens p ⊓ (𝒩.pullback D.ι).opens p'))
      (hα p p')
    rw [map_mul] at h
    simp only [Scheme.unitsRestrict_unitsRestrict, Scheme.Hom.unitsAppLE_map] at h ⊢
    exact h
  -- ### glue the reindexed family: one unit per ambient point
  have key : ∀ b : Z, ∃ tb : Γ(Z, 𝒩.opens b ⊓ D)ˣ, ∀ p : (D : Scheme.{u}),
      Z.unitsRestrict (le_inf (inf_le_left.trans inf_le_left) inf_le_right :
          (𝒩.opens b ⊓ 𝒩.opens (D.ι.base p)) ⊓ D ≤ 𝒩.opens b ⊓ D) tb
        = Z.unitsRestrict (le_inf (inf_le_left.trans inf_le_right) inf_le_right)
            (t' p)
          * Z.unitsRestrict
              (le_inf (inf_le_left.trans inf_le_right) (inf_le_left.trans inf_le_left) :
                (𝒩.opens b ⊓ 𝒩.opens (D.ι.base p)) ⊓ D
                  ≤ 𝒩.opens (D.ι.base p) ⊓ 𝒩.opens b)
              (Scheme.unitsEvInf γ (D.ι.base p) b) := by
    intro b
    refine Scheme.exists_unitsRestrict_eq
      (W := fun p : (D : Scheme.{u}) => (𝒩.opens b ⊓ 𝒩.opens (D.ι.base p)) ⊓ D)
      (fun p => le_inf (inf_le_left.trans inf_le_left) inf_le_right)
      (fun y hy => ?_) _ (fun p q => ?_)
    · -- the trimmed members cover `𝒩.opens b ⊓ D`
      have hyD : y ∈ D.ι.opensRange := by
        rw [Scheme.Opens.opensRange_ι]
        exact hy.2
      obtain ⟨p, hp⟩ := hyD
      refine Opens.mem_iSup.mpr ⟨p, ⟨⟨hy.1, ?_⟩, hy.2⟩⟩
      rw [hp]
      exact 𝒩.mem_opens y
    · -- compatibility on pairwise overlaps: the relation plus the cocycle identity
      simp only [map_mul, Scheme.unitsRestrict_unitsRestrict]
      -- the relation between `t' p` and `t' q`, restricted
      have h1 := congrArg
        (Z.unitsRestrict (le_inf (le_inf
            (inf_le_left.trans (inf_le_left.trans inf_le_right))
            (inf_le_right.trans (inf_le_left.trans inf_le_right)))
            (inf_le_left.trans inf_le_right) :
          ((𝒩.opens b ⊓ 𝒩.opens (D.ι.base p)) ⊓ D)
              ⊓ ((𝒩.opens b ⊓ 𝒩.opens (D.ι.base q)) ⊓ D)
            ≤ (𝒩.opens (D.ι.base p) ⊓ 𝒩.opens (D.ι.base q)) ⊓ D))
        (hrel p q)
      -- the cocycle identity at `(p, q, b)`, restricted
      have h2 := congrArg
        (Z.unitsRestrict (le_inf (le_inf
            (inf_le_left.trans (inf_le_left.trans inf_le_right))
            (inf_le_right.trans (inf_le_left.trans inf_le_right)))
            (inf_le_left.trans (inf_le_left.trans inf_le_left)) :
          ((𝒩.opens b ⊓ 𝒩.opens (D.ι.base p)) ⊓ D)
              ⊓ ((𝒩.opens b ⊓ 𝒩.opens (D.ι.base q)) ⊓ D)
            ≤ 𝒩.opens (D.ι.base p) ⊓ 𝒩.opens (D.ι.base q) ⊓ 𝒩.opens b))
        (Scheme.unitsEvInf_trans γ (D.ι.base p) (D.ι.base q) b)
      rw [map_mul] at h1 h2
      simp only [Scheme.unitsRestrict_unitsRestrict] at h1 h2 ⊢
      exact reindex_core h1 h2
  choose t ht using key
  -- ### the trivializing relation for the glued family
  refine ⟨t, fun b b' => ?_⟩
  refine Scheme.unitsRestrict_eq_of_locally_eq
    (W := fun p : (D : Scheme.{u}) =>
      ((𝒩.opens b ⊓ 𝒩.opens b') ⊓ 𝒩.opens (D.ι.base p)) ⊓ D)
    (fun p => le_inf (inf_le_left.trans inf_le_left) inf_le_right)
    (fun y hy => ?_) _ _ (fun p => ?_)
  · -- the refined members cover the trimmed overlap
    have hyD : y ∈ D.ι.opensRange := by
      rw [Scheme.Opens.opensRange_ι]
      exact hy.2
    obtain ⟨p, hp⟩ := hyD
    refine Opens.mem_iSup.mpr ⟨p, ⟨⟨hy.1, ?_⟩, hy.2⟩⟩
    rw [hp]
    exact 𝒩.mem_opens y
  · -- pointwise: expand both glued values and use the cocycle identity at `(p, b, b')`
    simp only [map_mul, Scheme.unitsRestrict_unitsRestrict]
    have hb := congrArg
      (Z.unitsRestrict (le_inf (le_inf
          (inf_le_left.trans (inf_le_left.trans inf_le_left))
          (inf_le_left.trans inf_le_right))
          inf_le_right :
        ((𝒩.opens b ⊓ 𝒩.opens b') ⊓ 𝒩.opens (D.ι.base p)) ⊓ D
          ≤ (𝒩.opens b ⊓ 𝒩.opens (D.ι.base p)) ⊓ D))
      (ht b p)
    have hb' := congrArg
      (Z.unitsRestrict (le_inf (le_inf
          (inf_le_left.trans (inf_le_left.trans inf_le_right))
          (inf_le_left.trans inf_le_right))
          inf_le_right :
        ((𝒩.opens b ⊓ 𝒩.opens b') ⊓ 𝒩.opens (D.ι.base p)) ⊓ D
          ≤ (𝒩.opens b' ⊓ 𝒩.opens (D.ι.base p)) ⊓ D))
      (ht b' p)
    have hcoc := congrArg
      (Z.unitsRestrict (le_inf (le_inf
          (inf_le_left.trans inf_le_right)
          (inf_le_left.trans (inf_le_left.trans inf_le_left)))
          (inf_le_left.trans (inf_le_left.trans inf_le_right)) :
        ((𝒩.opens b ⊓ 𝒩.opens b') ⊓ 𝒩.opens (D.ι.base p)) ⊓ D
          ≤ 𝒩.opens (D.ι.base p) ⊓ 𝒩.opens b ⊓ 𝒩.opens b'))
      (Scheme.unitsEvInf_trans γ (D.ι.base p) b b')
    rw [map_mul] at hb hb' hcoc
    simp only [Scheme.unitsRestrict_unitsRestrict] at hb hb' hcoc ⊢
    rw [hb, hb']
    exact relation_core hcoc

end Scheme

variable {k : Type u} [Field k]
variable {A B : Type u} [CommRing A] [CommRing B] [Algebra k A] [Algebra k B]
  [Algebra A B] [IsScalarTower k A B]
variable (C : Over (Spec (.of k)))

set_option quotPrecheck false in
local notation "XA" => (C ⊗ overSpec k A).left
set_option quotPrecheck false in
local notation "XB" => (C ⊗ overSpec k B).left
set_option quotPrecheck false in
local notation "cg" => (C ◁ Over.overSpecMap ((Algebra.ofId A B).restrictScalars k)).left