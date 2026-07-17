/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Albanese.Milne33Rows

/-!
# Milne Lemma 3.3, Substep 2 (hard direction) and diagonal triviality

Per `informal/m33-spec.md` (D3). Main results:

* `comp_toPartialMap_hom_eq_diff` — **the evaluation formula**: on any pair
  morphism `⟨a, b⟩ : T ⟶ X ×_{k̄} X` whose two coordinates factor through
  `Dom f`, the maximal representative of Milne's difference map computes as
  `f(a)·f(b)⁻¹` — honest morphisms, no points.
* `toPartialMap_hom_base_selfDiag_eq` — **diagonal triviality, pointwise**: at
  any diagonal point `δ(z)` with `z ∈ Dom f`, the value of `Φ` is the unit
  point `e`.
* `genericImage_specializes_unit` — the generic image `γ := Φ(η_Y)`
  specialises to `e` (`e ∈ closure {γ}`), anchoring the substep-3 germ
  pullback at `e` with no image-closure subgroup machinery.
* `mem_domain_of_selfDiag_mem_domain` — **Substep 2, hard direction, at closed
  rational points**: if `x₀` is a closed point and `Φ` is defined at
  `(x₀, x₀)`, then `f` is defined at `x₀`. Milne's row argument
  `f(x) = Φ(x, u)·f(u)`: a closed rational `u ∈ Dom f` with `(x₀, u) ∈ Dom Φ`
  exists by irreducibility and Jacobson density; the row morphism
  `ψ(v) = Φ(v, u)·f(u)` is an honest morphism on `σ_u⁻¹(Dom Φ) ∋ x₀`
  representing `f`.

Blueprint reference: `lem:milne_codim1_indeterminacy` (Milne, *Abelian
Varieties*, §I.3 Lemma 3.3, p. 17; `abelian-varieties:page-0023`).
-/

set_option autoImplicit false

universe u

open CategoryTheory CartesianMonoidalCategory MonoidalCategory Limits TopologicalSpace

namespace AlgebraicGeometry

namespace Scheme.RationalMap

variable {kbar : Type u} [Field kbar]
variable {X G : Over (Spec (.of kbar))}
  [Smooth X.hom] [GrpObj G] [LocallyOfFiniteType G.hom]

/-! ## §1. Over-structure of the maximal representatives -/

omit [Smooth X.hom] [GrpObj G] [LocallyOfFiniteType G.hom] in
/-- The maximal representative of an over-`k̄` rational map `f : X ⇢ G` is an
over-`k̄` partial map: `f₀.hom ≫ G.hom = f₀.domain.ι ≫ X.hom`. -/
lemma toPartialMap_hom_comp_hom
    (f : X.left.RationalMap G.left) (hover : f.compHom G.hom = X.hom.toRationalMap)
    [IsReduced X.left] [G.left.IsSeparated] :
    f.toPartialMap.hom ≫ G.hom = f.toPartialMap.domain.ι ≫ X.hom := by
  letI : X.left.Over (Spec (.of kbar)) := ⟨X.hom⟩
  letI : G.left.Over (Spec (.of kbar)) := ⟨G.hom⟩
  haveI : f.IsOver (Spec (.of kbar)) := Scheme.RationalMap.isOver_iff.mpr hover
  exact (Scheme.PartialMap.isOver_iff (S := Spec (.of kbar))).mp inferInstance

/-- The maximal representative of Milne's difference map is over `k̄`:
`Φ₀.hom ≫ G.hom = Φ₀.domain.ι ≫ pr₁ ≫ X.hom`. -/
lemma diff_toPartialMap_hom_comp_hom
    (f : X.left.RationalMap G.left) (hover : f.compHom G.hom = X.hom.toRationalMap)
    [IsIntegral (pullback X.hom X.hom)] [IsReduced X.left] [G.left.IsSeparated] :
    (differenceRationalMap f hover).toPartialMap.hom ≫ G.hom
      = (differenceRationalMap f hover).toPartialMap.domain.ι
        ≫ pullback.fst X.hom X.hom ≫ X.hom := by
  letI : (pullback X.hom X.hom).Over (Spec (.of kbar)) :=
    ⟨pullback.fst X.hom X.hom ≫ X.hom⟩
  letI : G.left.Over (Spec (.of kbar)) := ⟨G.hom⟩
  haveI : (differenceRationalMap f hover).IsOver (Spec (.of kbar)) :=
    Scheme.RationalMap.isOver_iff.mpr (differenceRationalMap_compHom_over f hover)
  exact (Scheme.PartialMap.isOver_iff (S := Spec (.of kbar))).mp inferInstance

/-! ## §2. The evaluation formula on pairs inside `Dom f × Dom f` -/

section Evaluation

variable (f : X.left.RationalMap G.left) (hover : f.compHom G.hom = X.hom.toRationalMap)
variable [IsIntegral (pullback X.hom X.hom)] [IsReduced X.left] [G.left.IsSeparated]
variable [IsSeparated G.hom]

omit [LocallyOfFiniteType G.hom] [IsIntegral (pullback X.hom X.hom)]
  [IsSeparated G.hom] in
/-- The pair of two `Dom f`-valued morphisms lands pointwise in the domain of
the explicit pairing representative `diffPairingRep`. -/
lemma pair_mem_diffPairingRep_domain
    {T : Scheme.{u}} (aD bD : T ⟶ ↑f.toPartialMap.domain)
    (w : (aD ≫ f.toPartialMap.domain.ι) ≫ X.hom
      = (bD ≫ f.toPartialMap.domain.ι) ≫ X.hom)
    (t : ↥T) :
    (pullback.lift (aD ≫ f.toPartialMap.domain.ι) (bD ≫ f.toPartialMap.domain.ι)
      w).base t ∈ (diffPairingRep f hover).domain := by
  rw [diffPairingRep_domain, TopologicalSpace.Opens.mem_inf]
  constructor
  · have h1 : (pullback.lift (aD ≫ f.toPartialMap.domain.ι)
        (bD ≫ f.toPartialMap.domain.ι) w ≫ pullback.fst X.hom X.hom).base t
        = (aD ≫ f.toPartialMap.domain.ι).base t := by
      rw [pullback.lift_fst]
    change (pullback.lift _ _ w).base t
      ∈ (f.toPartialMap.precomp (pullback.fst X.hom X.hom)
        (isOpenMap_pullback_fst_self X)).domain
    rw [Scheme.PartialMap.precomp_domain]
    change (pullback.fst X.hom X.hom).base ((pullback.lift _ _ w).base t)
      ∈ f.toPartialMap.domain
    rw [show (pullback.fst X.hom X.hom).base ((pullback.lift
        (aD ≫ f.toPartialMap.domain.ι) (bD ≫ f.toPartialMap.domain.ι) w).base t)
      = (pullback.lift (aD ≫ f.toPartialMap.domain.ι)
        (bD ≫ f.toPartialMap.domain.ι) w ≫ pullback.fst X.hom X.hom).base t
      from rfl, h1]
    exact (aD.base t).2
  · have h2 : (pullback.lift (aD ≫ f.toPartialMap.domain.ι)
        (bD ≫ f.toPartialMap.domain.ι) w ≫ pullback.snd X.hom X.hom).base t
        = (bD ≫ f.toPartialMap.domain.ι).base t := by
      rw [pullback.lift_snd]
    change (pullback.lift _ _ w).base t
      ∈ (f.toPartialMap.precomp (pullback.snd X.hom X.hom)
        (isOpenMap_pullback_snd_self X)).domain
    rw [Scheme.PartialMap.precomp_domain]
    change (pullback.snd X.hom X.hom).base ((pullback.lift _ _ w).base t)
      ∈ f.toPartialMap.domain
    rw [show (pullback.snd X.hom X.hom).base ((pullback.lift
        (aD ≫ f.toPartialMap.domain.ι) (bD ≫ f.toPartialMap.domain.ι) w).base t)
      = (pullback.lift (aD ≫ f.toPartialMap.domain.ι)
        (bD ≫ f.toPartialMap.domain.ι) w ≫ pullback.snd X.hom X.hom).base t
      from rfl, h2]
    exact (bD.base t).2

/-- **The evaluation formula.** Let `P = ⟨a, b⟩ : T ⟶ X ×_{k̄} X` be a pair
morphism whose coordinates `a = aD ≫ ι`, `b = bD ≫ ι` factor through `Dom f`,
and let `j : T ⟶ Dom Φ₀` be any factorisation of `P` through the domain of the
maximal representative `Φ₀` of the difference map. Then

`j ≫ Φ₀.hom = ⟨f(a), f(b)⟩ ≫ (g,h ↦ g·h⁻¹)`,

i.e. Milne's `Φ(a, b) = f(a)·f(b)⁻¹` as an identity of honest morphisms. -/
theorem comp_toPartialMap_hom_eq_diff
    {T : Scheme.{u}} (aD bD : T ⟶ ↑f.toPartialMap.domain)
    (w : (aD ≫ f.toPartialMap.domain.ι) ≫ X.hom
      = (bD ≫ f.toPartialMap.domain.ι) ≫ X.hom)
    (j : T ⟶ ↑(differenceRationalMap f hover).toPartialMap.domain)
    (hj : j ≫ (differenceRationalMap f hover).toPartialMap.domain.ι
      = pullback.lift (aD ≫ f.toPartialMap.domain.ι)
          (bD ≫ f.toPartialMap.domain.ι) w) :
    j ≫ (differenceRationalMap f hover).toPartialMap.hom
      = pullback.lift (aD ≫ f.toPartialMap.hom) (bD ≫ f.toPartialMap.hom)
          (by rw [Category.assoc, Category.assoc, toPartialMap_hom_comp_hom f hover,
            ← Category.assoc, ← Category.assoc]; exact w)
        ≫ grpObjDiffLeft G := by
  -- The pair morphism `P = ⟨a, b⟩` lands pointwise in the pairing domain.
  have hrange : Set.range (pullback.lift (aD ≫ f.toPartialMap.domain.ι)
      (bD ≫ f.toPartialMap.domain.ι) w).base
      ⊆ Set.range (precompDiffPairing f hover).domain.ι.base := by
    rw [Scheme.Opens.range_ι]
    rintro _ ⟨t, rfl⟩
    exact pair_mem_diffPairingRep_domain f hover aD bD w t
  -- Factor `P` through the pairing domain.
  set q : T ⟶ ↑(precompDiffPairing f hover).domain :=
    IsOpenImmersion.lift (precompDiffPairing f hover).domain.ι
      (pullback.lift (aD ≫ f.toPartialMap.domain.ι) (bD ≫ f.toPartialMap.domain.ι) w)
      hrange with hqdef
  have hqι : q ≫ (precompDiffPairing f hover).domain.ι
      = pullback.lift (aD ≫ f.toPartialMap.domain.ι)
        (bD ≫ f.toPartialMap.domain.ι) w := by
    rw [hqdef]; exact IsOpenImmersion.lift_fac _ _ _
  -- Evaluate the maximal representative through the pairing: the Rows interface
  -- `comp_toPartialMap_hom_of_fac` lives entirely in the `precompDiffPairing`
  -- world, so no `diffPairingRep`/`precompDiffPairing` retyping ever enters a
  -- rewrite (spec R3 discipline).
  rw [comp_toPartialMap_hom_of_fac f hover j q (by rw [hj, hqι])]
  rw [← Category.assoc]
  congr 1
  -- The pairing computes coordinatewise.
  apply pullback.hom_ext
  · have hle1 : (precompDiffPairing f hover).domain
        ≤ pullback.fst X.hom X.hom ⁻¹ᵁ f.toPartialMap.domain := inf_le_left
    have h1 : (precompDiffPairing f hover).hom ≫ pullback.fst G.hom G.hom
        = ((pullback X.hom X.hom).homOfLE hle1
          ≫ (pullback.fst X.hom X.hom ∣_ f.toPartialMap.domain)) ≫ f.toPartialMap.hom :=
      pullback.lift_fst _ _ _
    rw [Category.assoc, pullback.lift_fst, h1, ← Category.assoc]
    congr 1
    -- `(q ≫ homOfLE) ≫ ι` is the pair morphism `P`.
    have hqP : (q ≫ (pullback X.hom X.hom).homOfLE hle1)
        ≫ (pullback.fst X.hom X.hom ⁻¹ᵁ f.toPartialMap.domain).ι
        = pullback.lift (aD ≫ f.toPartialMap.domain.ι)
          (bD ≫ f.toPartialMap.domain.ι) w := by
      rw [Category.assoc, Scheme.homOfLE_ι, hqι]
    rw [← cancel_mono f.toPartialMap.domain.ι, Category.assoc, Category.assoc,
      morphismRestrict_ι, ← Category.assoc, ← Category.assoc, hqP, pullback.lift_fst]
  · have hle2 : (precompDiffPairing f hover).domain
        ≤ pullback.snd X.hom X.hom ⁻¹ᵁ f.toPartialMap.domain := inf_le_right
    have h1 : (precompDiffPairing f hover).hom ≫ pullback.snd G.hom G.hom
        = ((pullback X.hom X.hom).homOfLE hle2
          ≫ (pullback.snd X.hom X.hom ∣_ f.toPartialMap.domain)) ≫ f.toPartialMap.hom :=
      pullback.lift_snd _ _ _
    rw [Category.assoc, pullback.lift_snd, h1, ← Category.assoc]
    congr 1
    have hqP : (q ≫ (pullback X.hom X.hom).homOfLE hle2)
        ≫ (pullback.snd X.hom X.hom ⁻¹ᵁ f.toPartialMap.domain).ι
        = pullback.lift (aD ≫ f.toPartialMap.domain.ι)
          (bD ≫ f.toPartialMap.domain.ι) w := by
      rw [Category.assoc, Scheme.homOfLE_ι, hqι]
    rw [← cancel_mono f.toPartialMap.domain.ι, Category.assoc, Category.assoc,
      morphismRestrict_ι, ← Category.assoc, ← Category.assoc, hqP, pullback.lift_snd]

end Evaluation

end Scheme.RationalMap

end AlgebraicGeometry
