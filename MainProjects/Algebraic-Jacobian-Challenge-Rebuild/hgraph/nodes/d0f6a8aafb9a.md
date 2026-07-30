---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.PointedCover.BasicRefinement.pic_inter
docstring: 'Refine-compare along the second projection: the merge pointed by `Q` has
  the same

  Picard class as `Q`.'
file: AlgebraicJacobian/Picard/PicAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PointedCover.BasicRefinement.pic_inter
type: lean
updated: '2026-07-30T15:46:06'
---
theorem pic_inter (P : 𝒰.BasicRefinement) (Q : 𝒱.BasicRefinement)
    (γ : X.unitsCocycle 𝒱) : (P.inter Q).pic γ = Q.pic γ := by
  letI := Q.faithfullyFlat
  letI := (P.inter Q).faithfullyFlat
  have hτ : ∀ p : P.ι × Q.ι,
      IsUnit (algebraMap Γ(X, ⊤) Γ(X, X.basicOpen ((P.inter Q).r p)) (Q.r p.2)) :=
    fun p ↦ IsLocalization.Away.isUnit_of_dvd ((P.inter Q).r p)
      (⟨P.r p.1, mul_comm _ _⟩ : Q.r p.2 ∣ (P.inter Q).r p)
  have hτT : ∀ p q : P.ι × Q.ι,
      IsUnit (algebraMap Γ(X, ⊤)
        Γ(X, X.basicOpen ((P.inter Q).r p * (P.inter Q).r q))
        (Q.r p.2 * Q.r q.2)) :=
    fun p q ↦ IsLocalization.Away.isUnit_of_dvd ((P.inter Q).r p * (P.inter Q).r q)
      (⟨P.r p.1 * P.r q.1, by simp only [inter_r]; ring⟩ :
        Q.r p.2 * Q.r q.2 ∣ (P.inter Q).r p * (P.inter Q).r q)
  have hrel : ∀ p q : P.ι × Q.ι, (P.inter Q).coverCocycle γ p q
      = Units.map (IsLocalization.AwayCover.refineOverlapAlgHom (A := Γ(X, ⊤)) (f := Q.r)
          (T := fun i j ↦ Γ(X, X.basicOpen (Q.r i * Q.r j)))
          (T' := fun p q ↦ Γ(X, X.basicOpen ((P.inter Q).r p * (P.inter Q).r q)))
          Prod.snd hτT p q).toRingHom.toMonoidHom (Q.coverCocycle γ p.2 q.2) := by
    intro p q
    have hle : X.basicOpen ((P.inter Q).r p * (P.inter Q).r q)
        ≤ X.basicOpen (Q.r p.2 * Q.r q.2) :=
      X.basicOpen_le_of_dvd ⟨P.r p.1 * P.r q.1, by simp only [inter_r]; ring⟩
    have hro : IsLocalization.AwayCover.refineOverlapAlgHom (A := Γ(X, ⊤)) (f := Q.r)
          (T := fun i j ↦ Γ(X, X.basicOpen (Q.r i * Q.r j)))
          (T' := fun p q ↦ Γ(X, X.basicOpen ((P.inter Q).r p * (P.inter Q).r q)))
          Prod.snd hτT p q
        = X.basicRes _ _ hle :=
      X.basicOpen_algHom_ext _ _ _
    rw [hro]
    have hmap : Units.map ((X.basicRes _ _ hle)).toRingHom.toMonoidHom
          (Q.coverCocycle γ p.2 q.2)
        = X.unitsRestrict hle (Q.coverCocycle γ p.2 q.2) := rfl
    rw [hmap, coverCocycle, coverCocycle, unitsRestrict_unitsRestrict]
    rfl
  rw [pic_eq_picClass, pic_eq_picClass]
  exact IsLocalization.AwayCover.picClass_map_refine (A := Γ(X, ⊤)) (f := Q.r)
    (S := fun i ↦ Γ(X, X.basicOpen (Q.r i)))
    (T := fun i j ↦ Γ(X, X.basicOpen (Q.r i * Q.r j)))
    (W := fun i j k ↦ Γ(X, X.basicOpen (Q.r i * (Q.r j * Q.r k))))
    (f' := (P.inter Q).r)
    (S' := fun p ↦ Γ(X, X.basicOpen ((P.inter Q).r p)))
    (T' := fun p q ↦ Γ(X, X.basicOpen ((P.inter Q).r p * (P.inter Q).r q)))
    Prod.snd hτ hτT
    (W' := fun p q t ↦ Γ(X, X.basicOpen ((P.inter Q).r p
      * ((P.inter Q).r q * (P.inter Q).r t))))
    (Q.isCoverCocycle γ) ((P.inter Q).isCoverCocycle γ) hrel