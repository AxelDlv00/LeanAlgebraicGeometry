/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamily
import AlgebraicJacobian.Picard.FlatCokernel
import AlgebraicJacobian.Cohomology.GluedSheafDatumBaseChange
import AlgebraicJacobian.Cohomology.RelativeH1BaseChange

/-!
# Base change of certified divisor families (the DD-1 stage (c) pullback,
`informal/spec-dd-1.md` §3 stage (c))

Along a test-ring change `R → R'` (a `k`-algebra map, packaged as `[Algebra R R']`
`[IsScalarTower k R R']`), a certified divisor family over `R` pulls back to one over
`R'` through the relative-curve comparison morphism `relCurveMap C R R'`. This file builds
the geometric half of that pullback — the cover data and adaptation push forward through
the sections comparison `relSectionsMap` (`Scheme.Hom.appLE`), pieces to pieces
(`relSectionsMap_basicOpen`), partitions by `map_sum`/`map_mul`/`map_one` — and prepares
the certificate transport that turns it into `DivFam.mapAlg`.

* `AlgebraicGeometry.FinCoverData.baseChange` — the `Fin`-indexed cover data pushes
  forward: generators/partition coefficients go through `relSectionsMap`, the partition
  witnesses by ring-hom functoriality (the `Fin`-indexed mirror of
  `BasicOpenCoverData.baseChange`).
* `AlgebraicGeometry.FinCoverData.pieces_baseChange` — pieces base-change to pieces
  (`relSectionsMap_basicOpen`): `(D.baseChange R').pieces j = relCurveMap ⁻¹ᵁ D.pieces j`.

The module structures are the local instances of the DD-1 carrier (`Scheme.overModule`,
`Scheme.overSectionsAlgebra`, house rule); the mixed `relCurve`/product spellings force
`backward.isDefEq.respectTransparency false`, as in `RelativeSectionsLinear`.
-/

set_option autoImplicit false
/- Statements mix `Γ(relCurve C R, ·)` with opens produced on the product spelling
`(C ⊗ overSpec k R).left`; see `AlgebraicJacobian.Cohomology.RelativeSectionsLinear`. -/
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory TopologicalSpace
open Opposite TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']
variable {π : C.left ⟶ P1 k} [IsAffineHom π]

/-! ## The cover data base change -/

namespace FinCoverData

variable (D : FinCoverData C R π)

/-- **Base change of the `Fin`-indexed cover data** along `R → R'`: the generators and
partition coefficients push forward through the sections comparison `relSectionsMap`; the
partition witnesses are carried by `map_sum`/`map_mul`/`map_one` (the `Fin`-indexed mirror
of `BasicOpenCoverData.baseChange`). -/
noncomputable def baseChange : FinCoverData C R' π where
  m₀ := D.m₀
  m₁ := D.m₁
  h₀ j := relSectionsMap C R R' (fiberChart₀ π) (D.h₀ j)
  h₁ j := relSectionsMap C R R' (fiberChart₁ π) (D.h₁ j)
  a₀ j := relSectionsMap C R R' (fiberChart₀ π) (D.a₀ j)
  a₁ j := relSectionsMap C R R' (fiberChart₁ π) (D.a₁ j)
  partition₀ := by
    have h := congrArg (relSectionsMap C R R' (fiberChart₀ π)) D.partition₀
    rw [map_sum, map_one] at h
    rw [← h]
    exact Finset.sum_congr rfl fun j _ => (map_mul _ _ _).symm
  partition₁ := by
    have h := congrArg (relSectionsMap C R R' (fiberChart₁ π)) D.partition₁
    rw [map_sum, map_one] at h
    rw [← h]
    exact Finset.sum_congr rfl fun j _ => (map_mul _ _ _).symm

@[simp]
lemma baseChange_h₀ (j : Fin D.m₀) :
    (D.baseChange R').h₀ j = relSectionsMap C R R' (fiberChart₀ π) (D.h₀ j) := rfl

@[simp]
lemma baseChange_h₁ (j : Fin D.m₁) :
    (D.baseChange R').h₁ j = relSectionsMap C R R' (fiberChart₁ π) (D.h₁ j) := rfl

/-- **Pieces base-change to pieces**: the pieces of the base-changed cover data are the
`relCurveMap`-preimages of the pieces (`relSectionsMap_basicOpen`). -/
theorem pieces_baseChange (j : D.index) :
    (D.baseChange R').pieces j = relCurveMap C R R' ⁻¹ᵁ D.pieces j := by
  cases j with
  | inl j => exact relSectionsMap_basicOpen C R R' (fiberChart₀ π) (D.h₀ j)
  | inr j => exact relSectionsMap_basicOpen C R R' (fiberChart₁ π) (D.h₁ j)

/-- The base-changed pieces are below the preimages of the pieces (the `≤`-form of
`pieces_baseChange` consumed by `appLE`). -/
lemma baseChange_pieces_le_preimage (j : D.index) :
    (D.baseChange R').pieces j ≤ relCurveMap C R R' ⁻¹ᵁ D.pieces j :=
  (D.pieces_baseChange R' j).le

/-- Double overlaps of base-changed pieces are below the preimages of the double
overlaps. -/
lemma baseChange_inf_le_preimage (i j : D.index) :
    (D.baseChange R').pieces i ⊓ (D.baseChange R').pieces j ≤
      relCurveMap C R R' ⁻¹ᵁ (D.pieces i ⊓ D.pieces j) := by
  rw [Scheme.Hom.preimage_inf]
  exact inf_le_inf (D.baseChange_pieces_le_preimage R' i)
    (D.baseChange_pieces_le_preimage R' j)

end FinCoverData

/-! ## The chart-ring base change, as an algebra equivalence

`relTermBaseChange` is the `R'`-linear base change of chart sections; on the chart charts
it is in fact multiplicative (the underlying map `r' ⊗ y ↦ r' • relSectionsMap y` is a
ring homomorphism because `relSectionsMap` is), so it promotes to an `R'`-algebra
equivalence. This is the ring-level input to the piece-level term identification (the
away-localization base change of `IsLocalization.Away.tensorProductEquivTMulRight`). -/

/-- **The chart-ring base change**, as an `R'`-algebra equivalence
`R' ⊗[R] Γ(C_R, V_R) ≃ₐ[R'] Γ(C_{R'}, V_{R'})`: the promotion of the `R'`-linear
`relTermBaseChange` (multiplicative because `relSectionsMap` is a ring homomorphism). -/
noncomputable def relTermBaseChangeAlg (V : C.left.Opens)
    (hV : IsCompact (V : Set C.left)) (hV' : IsQuasiSeparated (V : Set C.left)) :
    R' ⊗[R] Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V) ≃ₐ[R']
      Γ(relCurve C R', (fst C (overSpec k R')).left ⁻¹ᵁ V) :=
  AlgEquiv.ofLinearEquiv (relTermBaseChange C R R' V hV hV')
    (by
      rw [Algebra.TensorProduct.one_def, relTermBaseChange_tmul, one_smul, map_one])
    (by
      intro x y
      induction x with
      | zero => rw [zero_mul, map_zero, zero_mul]
      | add x₁ x₂ hx₁ hx₂ => rw [add_mul, map_add, hx₁, hx₂, map_add, add_mul]
      | tmul a s =>
        induction y with
        | zero => rw [mul_zero, map_zero, mul_zero]
        | add y₁ y₂ hy₁ hy₂ => rw [mul_add, map_add, hy₁, hy₂, map_add, mul_add]
        | tmul b t =>
          rw [Algebra.TensorProduct.tmul_mul_tmul, relTermBaseChange_tmul,
            relTermBaseChange_tmul, relTermBaseChange_tmul, map_mul, smul_mul_smul_comm])

@[simp]
lemma relTermBaseChangeAlg_tmul (V : C.left.Opens)
    (hV : IsCompact (V : Set C.left)) (hV' : IsQuasiSeparated (V : Set C.left))
    (r' : R') (y : Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V)) :
    relTermBaseChangeAlg (R := R) R' V hV hV' (r' ⊗ₜ y) = r' • relSectionsMap C R R' V y :=
  relTermBaseChange_tmul C R R' hV hV' r' y

/-! ## The piece-level term identification (the certificate linchpin)

For a section `h` of an affine chart `V_R`, the piece `D(h)` sections are the away
localization of `Γ(V_R)` at `h`; base change commutes with this localization, so
`R' ⊗[R] Γ(D(h)) ≃ₐ[R'] Γ(D(h'))` where `h' = relSectionsMap h`. This is the
`IsLocalization.Away.tensorProductEquivTMulRight` base change transported along the
chart-ring iso `relTermBaseChangeAlg`. -/

section Piece

variable (V : C.left.Opens)
variable (hV : IsCompact (V : Set C.left)) (hV' : IsQuasiSeparated (V : Set C.left))
variable (hVaff : IsAffineOpen ((fst C (overSpec k R)).left ⁻¹ᵁ V))
variable (hVaff' : IsAffineOpen ((fst C (overSpec k R')).left ⁻¹ᵁ V))
variable (h : Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V))

/-- The `R`-to-piece scalar tower: the structure map `R → Γ(D(h))` factors through the
chart ring `Γ(V_R)`. -/
lemma isScalarTower_R_chart_piece :
    IsScalarTower R Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V)
      Γ(relCurve C R, (relCurve C R).basicOpen h) := by
  refine IsScalarTower.of_algebraMap_eq fun r => ?_
  rw [Scheme.algebraMap_overSectionsAlgebra, Scheme.algebraMap_overSectionsAlgebra]
  exact ((relCurve C R).overAlgebraMap_apply_res R
    (homOfLE ((relCurve C R).basicOpen_le h)).op r).symm

/-- **The piece-level term identification** (the certificate linchpin,
`informal/spec-dd-1.md` §3 stage (c), "localization commutes with base change at the
pieces"): base change of the piece sections `Γ(D(h))` is the piece sections of the
base-changed generator, `R' ⊗[R] Γ(D(h)) ≃ₐ[R'] Γ(D(h'))` with `h' = relSectionsMap h`.
Assembled from the away-localization base change
`IsLocalization.Away.tensorProductEquivTMulRight` (source is `Away (1 ⊗ h)` over
`R' ⊗[R] Γ(V_R)`) transported along the chart-ring iso `relTermBaseChangeAlg`
(sending `1 ⊗ h ↦ h'`), which exhibits `Γ(D(h'))` as the same away localization. -/
noncomputable def pieceTermBaseChangeAlg :
    R' ⊗[R] Γ(relCurve C R, (relCurve C R).basicOpen h) ≃ₐ[R']
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)) := by
  haveI := isScalarTower_R_chart_piece (R := R) V h
  haveI hLoc : IsLocalization.Away h Γ(relCurve C R, (relCurve C R).basicOpen h) :=
    hVaff.isLocalization_basicOpen h
  haveI hLoc' : IsLocalization.Away (relSectionsMap C R R' V h)
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)) :=
    hVaff'.isLocalization_basicOpen (relSectionsMap C R R' V h)
  -- the base-ring iso, and the fact that it carries `1 ⊗ h` to `h'`
  set e := relTermBaseChangeAlg (C := C) (R := R) R' V hV hV' with he
  have heh : e ((1 : R') ⊗ₜ[R] h) = relSectionsMap C R R' V h := by
    rw [he, relTermBaseChangeAlg_tmul, one_smul]
  -- exhibit `Γ(D(h'))` as the away localization of `R' ⊗[R] Γ(V_R)` at `1 ⊗ h`
  letI algPK : Algebra (R' ⊗[R] Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V))
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)) :=
    ((algebraMap Γ(relCurve C R', (fst C (overSpec k R')).left ⁻¹ᵁ V)
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h))).comp
        e.toAlgHom.toRingHom).toAlgebra
  haveI hLocPK : IsLocalization.Away ((1 : R') ⊗ₜ[R] h)
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)) := by
    refine IsLocalization.of_ringEquiv_left e.toRingEquiv
      (M₂ := Submonoid.powers ((1 : R') ⊗ₜ[R] h))
      ?_ (fun x => rfl) (M₁ := Submonoid.powers (relSectionsMap C R R' V h))
    rw [Submonoid.map_powers]
    exact congrArg Submonoid.powers heh
  -- the `R'`-scalar towers for `restrictScalars`
  haveI tR' : IsScalarTower R' Γ(relCurve C R', (fst C (overSpec k R')).left ⁻¹ᵁ V)
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)) :=
    isScalarTower_R_chart_piece (R := R') V (relSectionsMap C R R' V h)
  haveI : IsScalarTower R' (R' ⊗[R] Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V))
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)) := by
    refine IsScalarTower.of_algebraMap_eq fun r' => ?_
    change _ = algebraMap Γ(relCurve C R', (fst C (overSpec k R')).left ⁻¹ᵁ V) _
      (e (algebraMap R' _ r'))
    rw [AlgEquiv.commutes, ← IsScalarTower.algebraMap_apply]
  -- the two localizations of `R' ⊗[R] Γ(V_R)` at `1 ⊗ h` are algebra-equivalent
  exact (IsLocalization.Away.tensorProductEquivTMulRight R R' h
    Γ(relCurve C R, (relCurve C R).basicOpen h)).trans
    ((IsLocalization.algEquiv (Submonoid.powers ((1 : R') ⊗ₜ[R] h))
      (Localization.Away ((1 : R') ⊗ₜ[R] h))
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h))).restrictScalars R')

end Piece

end AlgebraicGeometry
