---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.CechPic.extPairs_cocycle
docstring: 'The cocycle identity for the extension pair values: on triple overlaps
  of range

  members it is the transported cocycle identity of `γ₀`; every other triple overlap
  is

  empty.'
file: AlgebraicJacobian/Picard/CechPicClopenGlue.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.Scheme.CechPic.extPairs_cocycle
type: lean
updated: '2026-07-30T15:27:58'
---
private lemma extPairs_cocycle (hdisj : w.opensRange ⊓ Ω' = ⊥) (y y' y'' : Y) :
    Y.unitsRestrict (inf_le_left :
        extOpens w Ω' 𝒰₀ y ⊓ extOpens w Ω' 𝒰₀ y' ⊓ extOpens w Ω' 𝒰₀ y''
          ≤ extOpens w Ω' 𝒰₀ y ⊓ extOpens w Ω' 𝒰₀ y') (extPairs w Ω' 𝒰₀ γ₀ y y')
        * Y.unitsRestrict (inf_le_inf_right _ inf_le_right)
            (extPairs w Ω' 𝒰₀ γ₀ y' y'')
      = Y.unitsRestrict (inf_le_inf_right _ inf_le_left)
          (extPairs w Ω' 𝒰₀ γ₀ y y'') := by
  by_cases hy : y ∈ w.opensRange
  · by_cases hy' : y' ∈ w.opensRange
    · by_cases hy'' : y'' ∈ w.opensRange
      · -- all three in the range: transport the cocycle identity of `γ₀`
        have hT : extOpens w Ω' 𝒰₀ y ⊓ extOpens w Ω' 𝒰₀ y' ⊓ extOpens w Ω' 𝒰₀ y''
            ≤ w.opensRange :=
          inf_le_left.trans (inf_le_left.trans (extOpens_le_opensRange w Ω' 𝒰₀ hy))
        apply (Scheme.Hom.unitsAppLE_bijective_of_le_opensRange w hT).injective
        rw [map_mul, extPairs_of_mem w Ω' 𝒰₀ γ₀ hy hy',
          extPairs_of_mem w Ω' 𝒰₀ γ₀ hy' hy'', extPairs_of_mem w Ω' 𝒰₀ γ₀ hy hy'']
        rw [Scheme.Hom.map_unitsAppLE, Scheme.Hom.map_unitsAppLE,
          Scheme.Hom.map_unitsAppLE, Scheme.Hom.unitsAppLE_unitsPreimageEquiv_symm,
          Scheme.Hom.unitsAppLE_unitsPreimageEquiv_symm,
          Scheme.Hom.unitsAppLE_unitsPreimageEquiv_symm,
          Scheme.unitsRestrict_unitsRestrict, Scheme.unitsRestrict_unitsRestrict,
          Scheme.unitsRestrict_unitsRestrict]
        have e := congrArg (Z.unitsRestrict
          (le_inf
            (le_inf
              ((w.preimage_mono (inf_le_left.trans inf_le_left)).trans
                (le_of_eq (preimage_extOpens_of_mem w Ω' 𝒰₀ hy)))
              ((w.preimage_mono (inf_le_left.trans inf_le_right)).trans
                (le_of_eq (preimage_extOpens_of_mem w Ω' 𝒰₀ hy'))))
            ((w.preimage_mono inf_le_right).trans
              (le_of_eq (preimage_extOpens_of_mem w Ω' 𝒰₀ hy''))) :
            w ⁻¹ᵁ (extOpens w Ω' 𝒰₀ y ⊓ extOpens w Ω' 𝒰₀ y' ⊓ extOpens w Ω' 𝒰₀ y'')
              ≤ 𝒰₀.opens hy.choose ⊓ 𝒰₀.opens hy'.choose ⊓ 𝒰₀.opens hy''.choose))
          (Scheme.unitsEvInf_trans γ₀ hy.choose hy'.choose hy''.choose)
        erw [map_mul] at e
        simp only [Scheme.unitsRestrict_unitsRestrict] at e
        exact e
      · -- `y''` off the range: the triple overlap is empty
        have hss : Subsingleton Γ(Y,
            extOpens w Ω' 𝒰₀ y ⊓ extOpens w Ω' 𝒰₀ y' ⊓ extOpens w Ω' 𝒰₀ y'')ˣ :=
          Y.subsingleton_units_of_le_bot
            ((le_inf (inf_le_left.trans inf_le_right) inf_le_right).trans
              (extOpens_overlap_le_bot w Ω' 𝒰₀ hdisj hy' hy''))
        exact @Subsingleton.elim _ hss _ _
    · -- `y'` off the range: the triple overlap is empty
      have hss : Subsingleton Γ(Y,
          extOpens w Ω' 𝒰₀ y ⊓ extOpens w Ω' 𝒰₀ y' ⊓ extOpens w Ω' 𝒰₀ y'')ˣ :=
        Y.subsingleton_units_of_le_bot
          ((inf_le_left).trans (extOpens_overlap_le_bot w Ω' 𝒰₀ hdisj hy hy'))
      exact @Subsingleton.elim _ hss _ _
  · by_cases hy'' : y'' ∈ w.opensRange
    · -- `y` off the range, `y''` in it: the triple overlap is empty
      have hss : Subsingleton Γ(Y,
          extOpens w Ω' 𝒰₀ y ⊓ extOpens w Ω' 𝒰₀ y' ⊓ extOpens w Ω' 𝒰₀ y'')ˣ :=
        Y.subsingleton_units_of_le_bot
          ((le_inf inf_le_right (inf_le_left.trans inf_le_left)).trans
            (extOpens_overlap_le_bot w Ω' 𝒰₀ hdisj hy'' hy))
      exact @Subsingleton.elim _ hss _ _
    · -- both `y` and `y''` off the range: all values are `1`
      rw [extPairs_of_notMem_left w Ω' 𝒰₀ γ₀ hy,
        extPairs_of_notMem_right w Ω' 𝒰₀ γ₀ hy'',
        extPairs_of_notMem_left w Ω' 𝒰₀ γ₀ hy, map_one, map_one, map_one, one_mul]

variable (hdisj : w.opensRange ⊓ Ω' = ⊥) (hcov : w.opensRange ⊔ Ω' = ⊤)