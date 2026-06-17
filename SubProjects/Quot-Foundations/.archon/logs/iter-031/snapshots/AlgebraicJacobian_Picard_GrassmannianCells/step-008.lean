/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Grassmannian affine charts

This file contains the single blueprint-pinned declaration for the affine
charts of the Grassmannian scheme: `AlgebraicGeometry.Grassmannian.affineChart`.

For `I ⊆ Fin r` with `#I = d`, the affine chart `U^I` of the Grassmannian
`Gr(d, r)` is the spectrum of the polynomial ring in the `d(r-d)` free matrix
entries — `Spec ℤ[x^I_{p,q}]_{q ∉ I}` — which is non-canonically isomorphic
to `𝔸^{d(r-d)}_ℤ`.

Blueprint reference: `def:gr_affine_chart`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`).
-/

set_option autoImplicit false

universe u

open AlgebraicGeometry CategoryTheory

namespace AlgebraicGeometry.Grassmannian

/- Blueprint: def:gr_affine_chart (chapters/Picard_GrassmannianCells.tex) -/

/- Planner note:
   Blueprint `def:gr_affine_chart` (Nitsure §1, "Construction by gluing together
   affine patches"): for `I ⊆ {1..r}` with `#I = d`, `X^I` is the `d×r` matrix
   whose `I`-minor is the `d×d` identity and whose other `d(r-d)` entries are
   independent indeterminates `x^I_{p,q}` over ℤ. The affine chart is
   `U^I := Spec ℤ[X^I] = Spec (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)` —
   the spectrum of the polynomial ring on the `d(r-d)` free entries; non-canonically
   `≅ 𝔸^{d(r-d)}_ℤ`. The prover should build `affineChart` as
   `AlgebraicGeometry.Spec` of that `CommRingCat` (the MvPolynomial ring on the
   free-entry index type), via
   `MvPolynomial (Fin d × {q // q ∉ I}) ℤ` or an equivalent index of cardinality
   `d(r-d)`. -/

/-- The **affine chart** `U^I` of the Grassmannian `Gr(d, r)` indexed by a
`d`-element subset `I : Finset (Fin r)`.

Concretely `U^I = Spec ℤ[x^I_{p,q}]_{p : Fin d, q ∉ I}`, the spectrum of the
polynomial ring `MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ` in the `d(r-d)`
free entries of the standard matrix representative with `I`-minor equal to the
identity. This chart is non-canonically isomorphic to `𝔸^{d(r-d)}_ℤ`.

The Grassmannian scheme is obtained by gluing the `Nat.choose r d` affine charts
`U^I` along the Plücker cocycle transition maps. -/
noncomputable def affineChart (d r : ℕ) (I : Finset (Fin r)) : Scheme :=
  AlgebraicGeometry.Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))

/-! ## Project-local Mathlib supplement — Grassmannian transition maps

The transition map `θ_{I,J}` of `def:gr_transition` is a Cramer-inverse computation
over the localised chart ring `R^I_J := ℤ[X^I, 1/P^I_J]`, followed by the universal
property of the away-localisation. We build it bottom-up over the chart ring
`R^I := MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ`, all elementary matrix algebra
over `ℤ`. The `d`-subset combinatorics are handled by the order isomorphism
`Finset.orderIsoOfFin : I.card = d → (Fin d ≃o ↥I)`.

Blueprint references: `def:gr_universal_matrix`, `def:gr_minor_det`,
`def:gr_universal_minor`, `lem:gr_minorDet_unit`, `def:gr_universalMinorInv`,
`lem:gr_universalMinorInv_identities`, `def:gr_image_matrix`, `def:gr_transition_pre`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- The **universal matrix** `X^I` (`def:gr_universal_matrix`): the `d × r` matrix
over the chart ring `R^I = MvPolynomial (Fin d × {q // q ∉ I}) ℤ` whose `I`-minor is the
`d × d` identity (read through the order iso `Fin d ≃o ↥I`) and whose remaining
`d(r-d)` entries are the free indeterminates `x^I_{p,q}` (`q ∉ I`). Project-local:
the universal point of the affine chart `affineChart d r I`. -/
noncomputable def universalMatrix (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    Matrix (Fin d) (Fin r) (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) :=
  fun p q =>
    if h : q ∈ I then (if (I.orderIsoOfFin hI p : Fin r) = q then 1 else 0)
    else MvPolynomial.X (p, ⟨q, h⟩)

/-- The **minor determinant** `P^I_J = det(X^I_J)` (`def:gr_minor_det`): the determinant
of the `d × d` submatrix of `universalMatrix d r I` whose columns are those indexed by
`J`, reindexed to `Fin d` via the order iso `Fin d ≃o ↥J`. Project-local: defines the
principal open `U^I_J = Spec R^I[1/P^I_J]`. -/
noncomputable def minorDet (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) : MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ :=
  ((universalMatrix d r I hI).submatrix id
    (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))).det

/-- The **localised `J`-minor** `X^I_J` over `R^I_J` (`def:gr_universal_minor`): the
`J`-minor of `universalMatrix d r I` with entries pushed forward along the structure map
`R^I → R^I_J = Localization.Away (minorDet d r I J)`. Project-local. -/
noncomputable def universalMinor (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    Matrix (Fin d) (Fin d) (Localization.Away (minorDet d r I J hI hJ)) :=
  ((universalMatrix d r I hI).submatrix id
    (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))).map (algebraMap _ _)

/-- The localised minor determinant is a unit (`lem:gr_minorDet_unit`): `det(X^I_J)` is the
image of `P^I_J` under the away-localisation structure map, hence a unit. Project-local. -/
theorem isUnit_det_universalMinor (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) : IsUnit (universalMinor d r I J hI hJ).det := by
  have h : (universalMinor d r I J hI hJ).det
      = (algebraMap _ (Localization.Away (minorDet d r I J hI hJ))) (minorDet d r I J hI hJ) :=
    (RingHom.map_det _ _).symm
  rw [h]
  exact IsLocalization.Away.algebraMap_isUnit _

/-- The **Cramer inverse** `(X^I_J)⁻¹` (`def:gr_universalMinorInv`): the Mathlib
nonsingular inverse of the localised `J`-minor. Its entries lie in `R^I_J` by Cramer's
rule. Project-local. -/
noncomputable def universalMinorInv (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    Matrix (Fin d) (Fin d) (Localization.Away (minorDet d r I J hI hJ)) :=
  (universalMinor d r I J hI hJ)⁻¹

/-- The Cramer inverse is a two-sided inverse (`lem:gr_universalMinorInv_identities`):
since `det(X^I_J)` is a unit, `(X^I_J)⁻¹` is a genuine left and right inverse.
Project-local. -/
theorem universalMinorInv_mul_cancel (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    universalMinorInv d r I J hI hJ * universalMinor d r I J hI hJ = 1 ∧
    universalMinor d r I J hI hJ * universalMinorInv d r I J hI hJ = 1 :=
  ⟨Matrix.nonsing_inv_mul _ (isUnit_det_universalMinor d r I J hI hJ),
   Matrix.mul_nonsing_inv _ (isUnit_det_universalMinor d r I J hI hJ)⟩

/-- The **image matrix** `M = (X^I_J)⁻¹ X^I` (`def:gr_image_matrix`): the product of the
Cramer inverse with the universal matrix base-changed to `R^I_J`. Its entries are the
prospective images of the indeterminates `x^J_{p,q}` under `θ_{I,J}`. Project-local. -/
noncomputable def imageMatrix (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    Matrix (Fin d) (Fin r) (Localization.Away (minorDet d r I J hI hJ)) :=
  universalMinorInv d r I J hI hJ * (universalMatrix d r I hI).map (algebraMap _ _)

/-- The **pre-localisation hom** `θ̃_{I,J} : R^J → R^I_J` (`def:gr_transition_pre`): the
`ℤ`-algebra map out of the chart ring of `J` sending each free indeterminate `x^J_{p,q}`
to the `(p,q)`-entry of the image matrix `M = (X^I_J)⁻¹ X^I`. Project-local. -/
noncomputable def transitionPreMap (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ →ₐ[ℤ]
      Localization.Away (minorDet d r I J hI hJ) :=
  MvPolynomial.aeval (fun e => imageMatrix d r I J hI hJ e.1 e.2.1)

/-- The `I`-minor of the universal matrix `X^I` is the `d × d` identity (`P^I_I = 1`
underlies `lem:gr_transition_self`): the `I`-columns of `X^I` read through the order iso
`Fin d ≃o ↥I` form the identity block. Project-local. -/
theorem universalMatrix_submatrix_self (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    (universalMatrix d r I hI).submatrix id
      (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) = 1 := by
  ext p p'
  simp only [Matrix.submatrix_apply, id_eq, universalMatrix]
  rw [dif_pos (I.orderIsoOfFin hI p').2, Matrix.one_apply]
  have hiff : ((I.orderIsoOfFin hI p : Fin r) = (I.orderIsoOfFin hI p')) ↔ (p = p') := by
    rw [Subtype.coe_inj, EmbeddingLike.apply_eq_iff_eq]
  by_cases h : p = p'
  · rw [if_pos (hiff.mpr h), if_pos h]
  · rw [if_neg (hiff.not.mpr h), if_neg h]

/-- Submatrix on the columns of a right matrix factor commutes with the product
(rows reindexed by `id`). Project-local helper: avoids a matrix-multiplication
instance-keying issue that blocks the generic `rw` of Mathlib's submatrix-mul lemmas. -/
private lemma mul_submatrix_col {d r : ℕ} {R : Type*} [CommRing R]
    (A : Matrix (Fin d) (Fin d) R) (B : Matrix (Fin d) (Fin r) R) (g : Fin d → Fin r) :
    (A * B).submatrix id g = A * B.submatrix id g := by
  ext i j; simp [Matrix.mul_apply, Matrix.submatrix_apply]

/-- The `J`-minor of the image matrix `M = (X^I_J)⁻¹ X^I` is the identity: `M_J =
(X^I_J)⁻¹ X^I_J = 1` (`def:gr_image_matrix`, used in the cocycle/transition arguments).
Project-local. -/
theorem imageMatrix_submatrix_self (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    (imageMatrix d r I J hI hJ).submatrix id
      (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r)) = 1 := by
  have h1 : (imageMatrix d r I J hI hJ).submatrix id
        (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))
      = universalMinorInv d r I J hI hJ *
        (((universalMatrix d r I hI).map (algebraMap _ _)).submatrix id
          (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))) := mul_submatrix_col _ _ _
  rw [h1, Matrix.submatrix_map]
  exact (universalMinorInv_mul_cancel d r I J hI hJ).1

/-- The `I`-minor of the image matrix `M = (X^I_J)⁻¹ X^I` is the Cramer inverse:
`M_I = (X^I_J)⁻¹ X^I_I = (X^I_J)⁻¹` (`def:gr_image_matrix`). Project-local. -/
theorem imageMatrix_submatrix_I (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    (imageMatrix d r I J hI hJ).submatrix id
      (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) = universalMinorInv d r I J hI hJ := by
  have h1 : (imageMatrix d r I J hI hJ).submatrix id
        (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))
      = universalMinorInv d r I J hI hJ *
        (((universalMatrix d r I hI).map (algebraMap _ _)).submatrix id
          (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) := mul_submatrix_col _ _ _
  rw [h1, Matrix.submatrix_map, universalMatrix_submatrix_self,
    Matrix.map_one _ (map_zero _) (map_one _), mul_one]

/-- The pre-localisation hom realises the matrix formula `θ̃_{I,J}(X^J) = (X^I_J)⁻¹ X^I`:
applying `θ̃_{I,J}` entrywise to the universal matrix `X^J` yields the image matrix `M`
(`def:gr_transition_pre`, `def:gr_image_matrix`). Project-local. -/
theorem universalMatrix_map_transitionPreMap (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    (universalMatrix d r J hJ).map (transitionPreMap d r I J hI hJ)
      = imageMatrix d r I J hI hJ := by
  ext p q
  simp only [Matrix.map_apply, universalMatrix]
  by_cases hq : q ∈ J
  · rw [dif_pos hq]
    set k := (J.orderIsoOfFin hJ).symm ⟨q, hq⟩ with hk
    have hqk : (J.orderIsoOfFin hJ k : Fin r) = q := by simp [hk]
    have himg : imageMatrix d r I J hI hJ p q = (1 : Matrix (Fin d) (Fin d) _) p k := by
      have e := congrFun (congrFun (imageMatrix_submatrix_self d r I J hI hJ) p) k
      rw [Matrix.submatrix_apply, id_eq] at e
      rw [← hqk]; exact e
    rw [himg, Matrix.one_apply, apply_ite (transitionPreMap d r I J hI hJ), map_one, map_zero]
    have hcond : ((J.orderIsoOfFin hJ p : Fin r) = q) ↔ (p = k) := by
      conv_lhs => rw [← hqk]
      rw [Subtype.coe_inj, EmbeddingLike.apply_eq_iff_eq]
    by_cases hpk : p = k
    · rw [if_pos (hcond.mpr hpk), if_pos hpk]
    · rw [if_neg (hcond.not.mpr hpk), if_neg hpk]
  · rw [dif_neg hq, transitionPreMap, MvPolynomial.aeval_X]

/-- The pre-hom sends `P^J_I` to a unit (`lem:gr_transition_pre_unit`):
`θ̃_{I,J}(P^J_I) = det((X^I_J)⁻¹) = det(X^I_J)⁻¹ = 1/P^I_J`, a unit of `R^I_J`. This is the
hypothesis that lets `θ̃_{I,J}` extend along the away-localisation `R^J[1/P^J_I]`.
Project-local. -/
theorem isUnit_transitionPreMap_minorDet (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) : IsUnit (transitionPreMap d r I J hI hJ (minorDet d r J I hJ hI)) := by
  have e1 : transitionPreMap d r I J hI hJ (minorDet d r J I hJ hI)
      = (((universalMatrix d r J hJ).submatrix id
          (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))).map
            (transitionPreMap d r I J hI hJ)).det :=
    RingHom.map_det (transitionPreMap d r I J hI hJ).toRingHom _
  rw [e1, ← Matrix.submatrix_map, universalMatrix_map_transitionPreMap, imageMatrix_submatrix_I]
  have hmul : (universalMinorInv d r I J hI hJ).det * (universalMinor d r I J hI hJ).det = 1 := by
    rw [← Matrix.det_mul, (universalMinorInv_mul_cancel d r I J hI hJ).1, Matrix.det_one]
  exact IsUnit.of_mul_eq_one _ hmul

/-- The **transition map** `θ_{I,J} : R^J[1/P^J_I] → R^I[1/P^I_J]` (`def:gr_transition`):
the away-localisation lift of the pre-hom `θ̃_{I,J}` along `P^J_I`, available because
`θ̃_{I,J}(P^J_I)` is a unit (`isUnit_transitionPreMap_minorDet`). It is the comorphism of
the chart-overlap isomorphism `U^I_J → U^J_I`. Project-local. -/
noncomputable def transitionMap (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    Localization.Away (minorDet d r J I hJ hI) →+* Localization.Away (minorDet d r I J hI hJ) :=
  IsLocalization.Away.lift (minorDet d r J I hJ hI)
    (g := (transitionPreMap d r I J hI hJ).toRingHom)
    (isUnit_transitionPreMap_minorDet d r I J hI hJ)

/-- `θ_{I,I}` is the identity (`lem:gr_transition_self`): since `P^I_I = 1` the minor
`X^I_I = 1` is its own Cramer inverse, so the pre-hom is the structure map and its
away-localisation lift is the identity ring homomorphism. Project-local. -/
theorem transitionMap_self (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    transitionMap d r I I hI hI = RingHom.id (Localization.Away (minorDet d r I I hI hI)) := by
  have hmin1 : universalMinor d r I I hI hI = 1 := by
    simp only [universalMinor, universalMatrix_submatrix_self]
    exact Matrix.map_one _ (map_zero _) (map_one _)
  have hinv1 : universalMinorInv d r I I hI hI = 1 := by
    simp only [universalMinorInv, hmin1]
    exact inv_one
  have himg : imageMatrix d r I I hI hI = (universalMatrix d r I hI).map (algebraMap _ _) := by
    rw [imageMatrix, hinv1]
    exact Matrix.one_mul _
  have hpre : (transitionPreMap d r I I hI hI).toRingHom
      = algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
          (Localization.Away (minorDet d r I I hI hI)) := by
    apply MvPolynomial.ringHom_ext
    · intro n
      change transitionPreMap d r I I hI hI (MvPolynomial.C n) = algebraMap _ _ (MvPolynomial.C n)
      rw [transitionPreMap, MvPolynomial.aeval_C,
        IsScalarTower.algebraMap_apply ℤ (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
          (Localization.Away (minorDet d r I I hI hI)), MvPolynomial.algebraMap_eq]
    · intro e
      change transitionPreMap d r I I hI hI (MvPolynomial.X e) = algebraMap _ _ (MvPolynomial.X e)
      rw [transitionPreMap, MvPolynomial.aeval_X, himg, Matrix.map_apply]
      congr 1
      rw [universalMatrix, dif_neg e.2.2]
  apply IsLocalization.ringHom_ext (Submonoid.powers (minorDet d r I I hI hI))
  simp only [transitionMap, IsLocalization.Away.lift_comp, RingHom.id_comp]
  exact hpre

/-! ## Project-local Mathlib supplement — triple-overlap rings and the cocycle

The cocycle condition `θ_{I,K} = θ_{I,J} ∘ θ_{J,K}` cannot be stated as a naive
composition of the landed `transitionMap`s: the codomain of `transitionMap d r J K`
(`R^J[1/P^J_K]`) differs from the domain of `transitionMap d r I J` (`R^J[1/P^J_I]`).
The identity therefore lives over the *triple-overlap* rings obtained by inverting BOTH
relevant minors in each chart ring:
`S_K := R^K[1/(P^K_I P^K_J)]`, `S_J := R^J[1/(P^J_I P^J_K)]`, `S_I := R^I[1/(P^I_J P^I_K)]`.
We build the localised transition maps `Θ_{I,J} : S_J →+* S_I`, `Θ_{J,K} : S_K →+* S_J`,
`Θ_{I,K} : S_K →+* S_I` over these rings and verify the cocycle.

Blueprint reference: `lem:gr_cocycle` (`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- A ring homomorphism carries the nonsingular (Cramer) inverse to the nonsingular
inverse, provided the determinant is a unit. Project-local helper: Mathlib has no direct
`map`-`nonsingular inverse` compatibility lemma. -/
private lemma map_nonsing_inv {n : ℕ} {R S : Type*} [CommRing R] [CommRing S] (f : R →+* S)
    (A : Matrix (Fin n) (Fin n) R) (h : IsUnit A.det) :
    (A.map f)⁻¹ = A⁻¹.map f := by
  have hmul : (A.map f) * (A⁻¹.map f) = 1 := by
    rw [← Matrix.map_mul, Matrix.mul_nonsing_inv A h, Matrix.map_one f (map_zero f) (map_one f)]
  exact Matrix.inv_eq_right_inv hmul

/-- Inclusion of the away-localisation at `x` into the away-localisation at `x * y`
(inverting the extra factor `y`). Project-local: the structure map of the triple overlap
relative to a double-localisation. -/
noncomputable def awayInclLeft {R : Type*} [CommRing R] (x y : R) :
    Localization.Away x →+* Localization.Away (x * y) :=
  IsLocalization.Away.lift (S := Localization.Away x) x
    (g := algebraMap R (Localization.Away (x * y)))
    (by
      have h : IsUnit (algebraMap R (Localization.Away (x * y)) (x * y)) :=
        IsLocalization.Away.algebraMap_isUnit _
      rw [map_mul] at h
      exact isUnit_of_mul_isUnit_left h)

/-- Inclusion of the away-localisation at `y` into the away-localisation at `x * y`
(inverting the extra factor `x`). Project-local. -/
noncomputable def awayInclRight {R : Type*} [CommRing R] (x y : R) :
    Localization.Away y →+* Localization.Away (x * y) :=
  IsLocalization.Away.lift (S := Localization.Away y) y
    (g := algebraMap R (Localization.Away (x * y)))
    (by
      have h : IsUnit (algebraMap R (Localization.Away (x * y)) (x * y)) :=
        IsLocalization.Away.algebraMap_isUnit _
      rw [map_mul] at h
      exact isUnit_of_mul_isUnit_right h)

/-- `awayInclLeft` is the canonical map over `R`: it intertwines the two structure maps.
Project-local. -/
lemma awayInclLeft_comp_algebraMap {R : Type*} [CommRing R] (x y : R) :
    (awayInclLeft x y).comp (algebraMap R (Localization.Away x)) =
      algebraMap R (Localization.Away (x * y)) := by
  rw [awayInclLeft]; exact IsLocalization.Away.lift_comp x _

/-- `awayInclRight` is the canonical map over `R`: it intertwines the two structure maps.
Project-local. -/
lemma awayInclRight_comp_algebraMap {R : Type*} [CommRing R] (x y : R) :
    (awayInclRight x y).comp (algebraMap R (Localization.Away y)) =
      algebraMap R (Localization.Away (x * y)) := by
  rw [awayInclRight]; exact IsLocalization.Away.lift_comp y _

/-- The image of a general minor determinant `P^B_C` under the pre-localisation hom
`θ̃_{A,B}` is the determinant of the `C`-minor of the image matrix `M = (X^A_B)⁻¹ X^A`
(generalises the `C = A` computation underlying `lem:gr_transition_pre_unit`). Project-local. -/
theorem transitionPreMap_minorDet (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    transitionPreMap d r I J hI hJ (minorDet d r J K hJ hK)
      = ((imageMatrix d r I J hI hJ).submatrix id
          (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r))).det := by
  have e1 : transitionPreMap d r I J hI hJ (minorDet d r J K hJ hK)
      = (((universalMatrix d r J hJ).submatrix id
          (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r))).map
            (transitionPreMap d r I J hI hJ)).det :=
    RingHom.map_det (transitionPreMap d r I J hI hJ).toRingHom _
  rw [e1, ← Matrix.submatrix_map, universalMatrix_map_transitionPreMap]

/-- The "cross" minor `P^B_C` is sent by `θ̃_{A,B}`, then pushed into a double localisation
`D` (in which `P^A_C` is a unit), to a unit. Concretely
`θ̃_{A,B}(P^B_C) = det((X^A_B)⁻¹ X^A_C) = det((X^A_B)⁻¹) · P^A_C`, a product of two units
once `P^A_C` is inverted. This is the cross-factor input to each triple-overlap transition
lift. Project-local. -/
private lemma isUnit_incl_transitionPreMap_cross
    (d r : ℕ) (A B C : Finset (Fin r)) (hA : A.card = d) (hB : B.card = d) (hC : C.card = d)
    {D : Type*} [CommRing D] [Algebra (MvPolynomial (Fin d × {q : Fin r // q ∉ A}) ℤ) D]
    (incl : Localization.Away (minorDet d r A B hA hB) →+* D)
    (hincl : incl.comp (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ A}) ℤ)
        (Localization.Away (minorDet d r A B hA hB)))
        = algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ A}) ℤ) D)
    (hunit : IsUnit (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ A}) ℤ) D
        (minorDet d r A C hA hC))) :
    IsUnit (incl (transitionPreMap d r A B hA hB (minorDet d r B C hB hC))) := by
  have hsub : (imageMatrix d r A B hA hB).submatrix id
        (fun j : Fin d => (C.orderIsoOfFin hC j : Fin r))
      = universalMinorInv d r A B hA hB *
        (((universalMatrix d r A hA).map (algebraMap _ _)).submatrix id
          (fun j : Fin d => (C.orderIsoOfFin hC j : Fin r))) := mul_submatrix_col _ _ _
  rw [transitionPreMap_minorDet, hsub, Matrix.det_mul, map_mul]
  refine IsUnit.mul ?_ ?_
  · refine IsUnit.map incl ?_
    refine IsUnit.of_mul_eq_one (universalMinor d r A B hA hB).det ?_
    rw [← Matrix.det_mul, (universalMinorInv_mul_cancel d r A B hA hB).1, Matrix.det_one]
  · have hdet : (((universalMatrix d r A hA).map
            (algebraMap _ (Localization.Away (minorDet d r A B hA hB)))).submatrix id
            (fun j : Fin d => (C.orderIsoOfFin hC j : Fin r))).det
          = algebraMap _ (Localization.Away (minorDet d r A B hA hB)) (minorDet d r A C hA hC) := by
      rw [Matrix.submatrix_map]
      exact (RingHom.map_det _ _).symm
    rw [hdet]
    have hcomp : incl (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ A}) ℤ)
        (Localization.Away (minorDet d r A B hA hB)) (minorDet d r A C hA hC))
        = algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ A}) ℤ) D (minorDet d r A C hA hC) :=
      RingHom.congr_fun hincl _
    rw [hcomp]
    exact hunit

/-- The left factor of a product is a unit in the away-localisation at that product.
Project-local. -/
private lemma isUnit_algebraMap_away_left {R : Type*} [CommRing R] (x y : R) :
    IsUnit (algebraMap R (Localization.Away (x * y)) x) := by
  have h : IsUnit (algebraMap R (Localization.Away (x * y)) (x * y)) :=
    IsLocalization.Away.algebraMap_isUnit _
  rw [map_mul] at h
  exact isUnit_of_mul_isUnit_left h

/-- The right factor of a product is a unit in the away-localisation at that product.
Project-local. -/
private lemma isUnit_algebraMap_away_right {R : Type*} [CommRing R] (x y : R) :
    IsUnit (algebraMap R (Localization.Away (x * y)) y) := by
  have h : IsUnit (algebraMap R (Localization.Away (x * y)) (x * y)) :=
    IsLocalization.Away.algebraMap_isUnit _
  rw [map_mul] at h
  exact isUnit_of_mul_isUnit_right h

/-- The triple-overlap transition map `Θ_{I,J} : S_J →+* S_I`, where
`S_J = R^J[1/(P^J_I P^J_K)]` and `S_I = R^I[1/(P^I_J P^I_K)]`: the away-localisation lift of
`θ̃_{I,J}` (post-composed into `S_I`) along the doubly-inverted minor `P^J_I P^J_K`.
Project-local. -/
noncomputable def cocycleΘIJ (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    Localization.Away (minorDet d r J I hJ hI * minorDet d r J K hJ hK) →+*
      Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK) :=
  IsLocalization.Away.lift (minorDet d r J I hJ hI * minorDet d r J K hJ hK)
    (g := (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
            (transitionPreMap d r I J hI hJ).toRingHom)
    (by
      rw [map_mul]
      refine IsUnit.mul ?_ ?_
      · exact (isUnit_transitionPreMap_minorDet d r I J hI hJ).map
          (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
      · exact isUnit_incl_transitionPreMap_cross d r I J K hI hJ hK
          (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
          (awayInclLeft_comp_algebraMap _ _)
          (isUnit_algebraMap_away_right _ _))

/-- The triple-overlap transition map `Θ_{J,K} : S_K →+* S_J`, where
`S_K = R^K[1/(P^K_I P^K_J)]` and `S_J = R^J[1/(P^J_I P^J_K)]`. Project-local. -/
noncomputable def cocycleΘJK (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    Localization.Away (minorDet d r K I hK hI * minorDet d r K J hK hJ) →+*
      Localization.Away (minorDet d r J I hJ hI * minorDet d r J K hJ hK) :=
  IsLocalization.Away.lift (minorDet d r K I hK hI * minorDet d r K J hK hJ)
    (g := (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)).comp
            (transitionPreMap d r J K hJ hK).toRingHom)
    (by
      rw [map_mul]
      refine IsUnit.mul ?_ ?_
      · exact isUnit_incl_transitionPreMap_cross d r J K I hJ hK hI
          (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))
          (awayInclRight_comp_algebraMap _ _)
          (isUnit_algebraMap_away_left _ _)
      · exact (isUnit_transitionPreMap_minorDet d r J K hJ hK).map
          (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))

/-- The triple-overlap transition map `Θ_{I,K} : S_K →+* S_I`, where
`S_K = R^K[1/(P^K_I P^K_J)]` and `S_I = R^I[1/(P^I_J P^I_K)]`. Project-local. -/
noncomputable def cocycleΘIK (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    Localization.Away (minorDet d r K I hK hI * minorDet d r K J hK hJ) →+*
      Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK) :=
  IsLocalization.Away.lift (minorDet d r K I hK hI * minorDet d r K J hK hJ)
    (g := (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
            (transitionPreMap d r I K hI hK).toRingHom)
    (by
      rw [map_mul]
      refine IsUnit.mul ?_ ?_
      · exact (isUnit_transitionPreMap_minorDet d r I K hI hK).map
          (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
      · exact isUnit_incl_transitionPreMap_cross d r I K J hI hK hJ
          (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
          (awayInclRight_comp_algebraMap _ _)
          (isUnit_algebraMap_away_left _ _))

/-- Mapping a base-changed matrix through a further ring hom collapses to a single base change
when the homs compose correctly. Project-local helper. -/
private lemma map_map_eq_of_comp {m n : ℕ} {R A D : Type*} [CommRing R] [CommRing A] [CommRing D]
    (M : Matrix (Fin m) (Fin n) R) (f : R →+* A) (g : A →+* D) (h : R →+* D)
    (hcomp : g.comp f = h) : (M.map f).map g = M.map h := by
  rw [Matrix.map_map, ← RingHom.coe_comp, hcomp]

/-- Mapping the image matrix `M = (X^I_X)⁻¹ X^I` through any ring hom `incl` lying over the
structure map `R^I → D` (i.e. `incl ∘ (R^I → R^I_X) = (R^I → D)`) yields `(Y_X)⁻¹ Y`, where
`Y := X^I` base-changed to `D`. The key reusable step in the cocycle computation. Project-local. -/
private lemma imageMatrix_map_eq (d r : ℕ) (I X : Finset (Fin r)) (hI : I.card = d)
    (hX : X.card = d) {D : Type*} [CommRing D]
    [Algebra (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) D]
    (incl : Localization.Away (minorDet d r I X hI hX) →+* D)
    (hincl : incl.comp (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
        (Localization.Away (minorDet d r I X hI hX)))
        = algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) D) :
    (imageMatrix d r I X hI hX).map incl
      = (((universalMatrix d r I hI).map
            (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) D)).submatrix id
          (fun j : Fin d => (X.orderIsoOfFin hX j : Fin r)))⁻¹ *
        (universalMatrix d r I hI).map
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) D) := by
  have hmm : (imageMatrix d r I X hI hX).map incl
      = (universalMinorInv d r I X hI hX).map incl
        * ((universalMatrix d r I hI).map
            (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
              (Localization.Away (minorDet d r I X hI hX)))).map incl := by
    rw [imageMatrix]; exact Matrix.map_mul
  rw [hmm, map_map_eq_of_comp _ _ _ _ hincl, universalMinorInv,
    ← map_nonsing_inv incl (universalMinor d r I X hI hX)
        (isUnit_det_universalMinor d r I X hI hX)]
  congr 1
  rw [universalMinor, map_map_eq_of_comp _ _ _ _ hincl, ← Matrix.submatrix_map]

/-- Matrix cancellation `(B⁻¹ A)(A⁻¹ M) = B⁻¹ M` when `A` is invertible. Project-local helper
for the final step of the cocycle. -/
private lemma inv_mul_inv_mul_cancel {d e : ℕ} {R : Type*} [CommRing R]
    (A B : Matrix (Fin d) (Fin d) R) (M : Matrix (Fin d) (Fin e) R) (hA : IsUnit A.det) :
    (B⁻¹ * A) * (A⁻¹ * M) = B⁻¹ * M := by
  rw [Matrix.mul_assoc B⁻¹ A (A⁻¹ * M), ← Matrix.mul_assoc A A⁻¹ M,
    Matrix.mul_nonsing_inv A hA, Matrix.one_mul]

/-- The central matrix identity behind the cocycle condition: over the triple-overlap ring
`S_I`, the image matrix `(X^I_K)⁻¹ X^I` of `θ_{I,K}` equals `θ_{I,J}` applied entrywise to the
image matrix `(X^J_K)⁻¹ X^J` of `θ_{J,K}`. Both reduce to `(Y_K)⁻¹ Y` with `Y = X^I` over
`S_I`. Project-local. -/
private lemma cocycle_imageMatrix_eq (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (imageMatrix d r I K hI hK).map
        (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
      = (imageMatrix d r J K hJ hK).map
          ((cocycleΘIJ d r I J K hI hJ hK).comp
            (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))) := by
  -- LHS = (Y_K)⁻¹ * Y, where `Y := X^I` over `S_I`.
  have hLHS := imageMatrix_map_eq d r I K hI hK
    (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
    (awayInclRight_comp_algebraMap _ _)
  -- `(imageMatrix I J).map (awayInclLeft …) = (Y_J)⁻¹ Y`.
  have hMJimg := imageMatrix_map_eq d r I J hI hJ
    (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
    (awayInclLeft_comp_algebraMap _ _)
  set Y := (universalMatrix d r I hI).map
      (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
        (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK))) with hY
  -- Unit facts for the two minors of `Y`.
  have hYJ : IsUnit (Y.submatrix id (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))).det := by
    have e : (Y.submatrix id (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))).det
        = algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
            (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK))
            (minorDet d r I J hI hJ) := by
      rw [hY, Matrix.submatrix_map]
      exact (RingHom.map_det _ _).symm
    rw [e]; exact isUnit_algebraMap_away_left _ _
  -- `M^J := θ_{I,J}(X^J) = (Y_J)⁻¹ Y` over `S_I`.
  have hχ : ((cocycleΘIJ d r I J K hI hJ hK).comp
        (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))).comp
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ)
            (Localization.Away (minorDet d r J K hJ hK)))
      = (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
          (transitionPreMap d r I J hI hJ).toRingHom := by
    rw [RingHom.comp_assoc, awayInclRight_comp_algebraMap, cocycleΘIJ]
    exact IsLocalization.Away.lift_comp _ _
  have hMJ : (universalMatrix d r J hJ).map
        ((awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
          (transitionPreMap d r I J hI hJ).toRingHom)
      = (Y.submatrix id (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r)))⁻¹ * Y := by
    have e1 : (universalMatrix d r J hJ).map
          ((awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
            (transitionPreMap d r I J hI hJ).toRingHom)
        = (imageMatrix d r I J hI hJ).map
            (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) := by
      rw [← map_map_eq_of_comp (universalMatrix d r J hJ)
          (transitionPreMap d r I J hI hJ).toRingHom
          (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) _ rfl]
      congr 1
      exact universalMatrix_map_transitionPreMap d r I J hI hJ
    rw [e1, hMJimg]
  -- RHS = (M^J_K)⁻¹ M^J = (Y_K)⁻¹ Y.
  have hRHS : (imageMatrix d r J K hJ hK).map
        ((cocycleΘIJ d r I J K hI hJ hK).comp
          (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))
      = (Y.submatrix id (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r)))⁻¹ * Y := by
    have hmm : (imageMatrix d r J K hJ hK).map
          ((cocycleΘIJ d r I J K hI hJ hK).comp
            (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))
        = (universalMinorInv d r J K hJ hK).map
            ((cocycleΘIJ d r I J K hI hJ hK).comp
              (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))
          * ((universalMatrix d r J hJ).map
              (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ)
                (Localization.Away (minorDet d r J K hJ hK)))).map
                  ((cocycleΘIJ d r I J K hI hJ hK).comp
                    (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))) := by
      rw [imageMatrix]; exact Matrix.map_mul
    rw [hmm, map_map_eq_of_comp _ _ _ _ hχ, hMJ, universalMinorInv,
      ← map_nonsing_inv _ _ (isUnit_det_universalMinor d r J K hJ hK), universalMinor,
      map_map_eq_of_comp _ _ _ _ hχ, ← Matrix.submatrix_map, hMJ,
      mul_submatrix_col (Y.submatrix id (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r)))⁻¹ Y
        (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r)),
      Matrix.mul_inv_rev, Matrix.nonsing_inv_nonsing_inv _ hYJ,
      inv_mul_inv_mul_cancel _ _ _ hYJ]
  rw [hLHS, hRHS]

/-- **Cocycle condition** (`lem:gr_cocycle`): over the triple overlap, the transition maps satisfy
`Θ_{I,K} = Θ_{I,J} ∘ Θ_{J,K}` as ring homs `S_K →+* S_I`. Together with `θ_{I,I} = id`
(`transitionMap_self`) this is the gluing datum for the Grassmannian charts. -/
theorem cocycleCondition (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    cocycleΘIK d r I J K hI hJ hK
      = (cocycleΘIJ d r I J K hI hJ hK).comp (cocycleΘJK d r I J K hI hJ hK) := by
  apply IsLocalization.ringHom_ext
    (Submonoid.powers (minorDet d r K I hK hI * minorDet d r K J hK hJ))
  have hIK : (cocycleΘIK d r I J K hI hJ hK).comp
      (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ K}) ℤ)
        (Localization.Away (minorDet d r K I hK hI * minorDet d r K J hK hJ)))
      = (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
          (transitionPreMap d r I K hI hK).toRingHom := by
    rw [cocycleΘIK]; exact IsLocalization.Away.lift_comp _ _
  have hJK : (cocycleΘJK d r I J K hI hJ hK).comp
      (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ K}) ℤ)
        (Localization.Away (minorDet d r K I hK hI * minorDet d r K J hK hJ)))
      = (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)).comp
          (transitionPreMap d r J K hJ hK).toRingHom := by
    rw [cocycleΘJK]; exact IsLocalization.Away.lift_comp _ _
  rw [hIK, RingHom.comp_assoc, hJK]
  apply MvPolynomial.ringHom_ext
  · intro n
    exact RingHom.congr_fun (RingHom.ext_int
      (((awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
        (transitionPreMap d r I K hI hK).toRingHom).comp MvPolynomial.C)
      (((cocycleΘIJ d r I J K hI hJ hK).comp
        ((awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)).comp
          (transitionPreMap d r J K hJ hK).toRingHom)).comp MvPolynomial.C)) n
  · intro e
    have h := congrFun (congrFun (cocycle_imageMatrix_eq d r I J K hI hJ hK) e.1) e.2.1
    simpa [Matrix.map_apply, transitionPreMap, MvPolynomial.aeval_X, RingHom.comp_apply] using h

/-! ## Project-local Mathlib supplement — scheme-level charts and the glue data

We assemble the affine charts (`affineChart`), their principal-open overlaps
`U^I_J = Spec R^I[1/P^I_J]`, the transition isomorphisms (`transitionMap`), and
the cocycle (`cocycleCondition`) into the data of
`AlgebraicGeometry.Scheme.GlueData`, whose `.glued` is the Grassmannian scheme
`Gr(d,r)` over `ℤ`.

Blueprint reference: `def:gr_glued_scheme`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- `P^I_I = 1`: the `I`-minor determinant of the universal matrix `X^I` is the
unit `1`, since `X^I_I` is the identity (`universalMatrix_submatrix_self`).
Project-local. -/
theorem minorDet_self (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    minorDet d r I I hI hI = 1 := by
  rw [minorDet, universalMatrix_submatrix_self, Matrix.det_one]

/-- The principal-open overlap `U^I_J = Spec R^I[1/P^I_J]` as a scheme: the affine
spectrum of the away-localisation of the chart ring `R^I` at the minor determinant
`P^I_J`. Project-local: the `V`-object of the Grassmannian glue data. -/
noncomputable def chartOverlap (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) : Scheme :=
  Spec (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ)))

/-- The canonical open immersion `U^I_J → U^I` of the principal open into the chart,
the comorphism of the structure map `R^I → R^I[1/P^I_J]`. Project-local: the `f`-field
of the Grassmannian glue data. -/
noncomputable def chartIncl (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) : chartOverlap d r I J hI hJ ⟶ affineChart d r I :=
  Spec.map (CommRingCat.ofHom
    (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
      (Localization.Away (minorDet d r I J hI hJ))))

instance chartIncl_isOpenImmersion (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) : IsOpenImmersion (chartIncl d r I J hI hJ) :=
  inferInstanceAs (IsOpenImmersion (Spec.map (CommRingCat.ofHom
    (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
      (Localization.Away (minorDet d r I J hI hJ))))))

/-- The self-inclusion `U^I_I → U^I` is an isomorphism: since `P^I_I = 1`
(`minorDet_self`) the away-localisation is the identity, so its `Spec` is an iso.
Project-local: the `f_id`-field of the Grassmannian glue data. -/
theorem chartIncl_self_isIso (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    IsIso (chartIncl d r I I hI hI) := by
  have hx : IsUnit (minorDet d r I I hI hI) := by rw [minorDet_self]; exact isUnit_one
  have e : MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ ≃ₐ[_]
      Localization.Away (minorDet d r I I hI hI) :=
    IsLocalization.atUnit _ (Localization.Away (minorDet d r I I hI hI)) _ hx
  have hbij : Function.Bijective
      (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
        (Localization.Away (minorDet d r I I hI hI))) := by
    have hfun : (⇑(algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
        (Localization.Away (minorDet d r I I hI hI)))) = ⇑e := by
      funext y; simp [← e.commutes y]
    rw [hfun]; exact e.bijective
  have : IsIso (CommRingCat.ofHom
      (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
        (Localization.Away (minorDet d r I I hI hI)))) :=
    (ConcreteCategory.isIso_iff_bijective _).mpr hbij
  change IsIso (Spec.map (CommRingCat.ofHom
    (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
      (Localization.Away (minorDet d r I I hI hI)))))
  infer_instance

/-- The scheme-level transition `U^I_J → U^J_I`, the comorphism (`Spec.map`) of the
ring transition map `θ_{I,J} : R^J[1/P^J_I] → R^I[1/P^I_J]`. Project-local: the
`t`-field of the Grassmannian glue data. -/
noncomputable def chartTransition (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) : chartOverlap d r I J hI hJ ⟶ chartOverlap d r J I hJ hI :=
  Spec.map (CommRingCat.ofHom (transitionMap d r I J hI hJ))

/-- `t_{I,I} = id`: the self-transition is the identity, from `transitionMap_self`.
Project-local: the `t_id`-field of the Grassmannian glue data. -/
theorem chartTransition_self (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    chartTransition d r I I hI hI
      = CategoryTheory.CategoryStruct.id (chartOverlap d r I I hI hI) := by
  rw [chartTransition, transitionMap_self, CommRingCat.ofHom_id, Spec.map_id]
  rfl

/-- The pullback of two principal-open inclusions
`Spec R[1/x] → Spec R ← Spec R[1/y]` is `Spec R[1/(xy)]`: combine `pullbackSpecIso`
(the pullback is `Spec` of the tensor product `R[1/x] ⊗_R R[1/y]`) with the
localisation identification `R[1/x] ⊗_R R[1/y] ≅ R[1/(xy)]`
(`IsLocalization.Away.mul'`, `IsLocalization.algEquiv`). Project-local helper for the
triple-overlap pullbacks of the Grassmannian glue data; stated over a general base ring
so its proof term carries the needed `IsScalarTower` instances (avoiding a typeclass
timeout over the heavy chart ring). -/
noncomputable def awayPullbackIso {A : Type*} [CommRing A] (x y : A) :
    Limits.pullback
        (Spec.map (CommRingCat.ofHom (algebraMap A (Localization.Away x))))
        (Spec.map (CommRingCat.ofHom (algebraMap A (Localization.Away y)))) ≅
      Spec (CommRingCat.of (Localization.Away (x * y))) :=
  letI : IsLocalization.Away (x * y)
      (TensorProduct A (Localization.Away x) (Localization.Away y)) :=
    IsLocalization.Away.mul' (Localization.Away x) _ x y
  (pullbackSpecIso A (Localization.Away x) (Localization.Away y)) ≪≫
    Scheme.Spec.mapIso
      ((IsLocalization.algEquiv (Submonoid.powers (x * y))
        (TensorProduct A (Localization.Away x) (Localization.Away y))
        (Localization.Away (x * y))).toRingEquiv.toCommRingCatIso).symm.op

/-- The first leg of `awayPullbackIso` is the left away-inclusion: under the
identification `pullback ≅ Spec R[1/(xy)]`, the projection to `Spec R[1/x]` is
`Spec.map` of `awayInclLeft x y`. Project-local: the `pullback.fst`-compatibility
needed for the `t_fac` field of the Grassmannian glue data. -/
theorem awayPullbackIso_inv_fst {A : Type*} [CommRing A] (x y : A) :
    (awayPullbackIso x y).inv ≫
        Limits.pullback.fst
          (Spec.map (CommRingCat.ofHom (algebraMap A (Localization.Away x))))
          (Spec.map (CommRingCat.ofHom (algebraMap A (Localization.Away y))))
      = Spec.map (CommRingCat.ofHom (awayInclLeft x y)) := by
  letI : IsLocalization.Away (x * y)
      (TensorProduct A (Localization.Away x) (Localization.Away y)) :=
    IsLocalization.Away.mul' (Localization.Away x) _ x y
  rw [awayPullbackIso, Iso.trans_inv, Category.assoc, pullbackSpecIso_inv_fst,
    show (Scheme.Spec.mapIso ((IsLocalization.algEquiv (Submonoid.powers (x * y))
        (TensorProduct A (Localization.Away x) (Localization.Away y))
        (Localization.Away (x * y))).toRingEquiv.toCommRingCatIso).symm.op).inv
      = Spec.map ((IsLocalization.algEquiv (Submonoid.powers (x * y))
        (TensorProduct A (Localization.Away x) (Localization.Away y))
        (Localization.Away (x * y))).toRingEquiv.toCommRingCatIso).hom from rfl,
    ← Spec.map_comp]
  congr 1
  apply CommRingCat.hom_ext
  simp only [CommRingCat.hom_comp, CommRingCat.hom_ofHom, RingEquiv.toCommRingCatIso_hom]
  apply IsLocalization.ringHom_ext (Submonoid.powers x)
  ext w
  simp only [RingHom.coe_comp, Function.comp_apply, awayInclLeft,
    Algebra.TensorProduct.includeLeftRingHom_apply, IsLocalization.Away.lift_eq,
    ← Algebra.TensorProduct.algebraMap_apply]
  exact (IsLocalization.algEquiv (Submonoid.powers (x * y))
    (TensorProduct A (Localization.Away x) (Localization.Away y))
    (Localization.Away (x * y))).commutes w

/-- The second leg of `awayPullbackIso` is the right away-inclusion: under the
identification `pullback ≅ Spec R[1/(xy)]`, the projection to `Spec R[1/y]` is
`Spec.map` of `awayInclRight x y`. Project-local: the `pullback.snd`-compatibility
needed for the `t_fac` field of the Grassmannian glue data. -/
theorem awayPullbackIso_inv_snd {A : Type*} [CommRing A] (x y : A) :
    (awayPullbackIso x y).inv ≫
        Limits.pullback.snd
          (Spec.map (CommRingCat.ofHom (algebraMap A (Localization.Away x))))
          (Spec.map (CommRingCat.ofHom (algebraMap A (Localization.Away y))))
      = Spec.map (CommRingCat.ofHom (awayInclRight x y)) := by
  letI : IsLocalization.Away (x * y)
      (TensorProduct A (Localization.Away x) (Localization.Away y)) :=
    IsLocalization.Away.mul' (Localization.Away x) _ x y
  rw [awayPullbackIso, Iso.trans_inv, Category.assoc, pullbackSpecIso_inv_snd,
    show (Scheme.Spec.mapIso ((IsLocalization.algEquiv (Submonoid.powers (x * y))
        (TensorProduct A (Localization.Away x) (Localization.Away y))
        (Localization.Away (x * y))).toRingEquiv.toCommRingCatIso).symm.op).inv
      = Spec.map ((IsLocalization.algEquiv (Submonoid.powers (x * y))
        (TensorProduct A (Localization.Away x) (Localization.Away y))
        (Localization.Away (x * y))).toRingEquiv.toCommRingCatIso).hom from rfl,
    ← Spec.map_comp]
  congr 1
  apply CommRingCat.hom_ext
  simp only [CommRingCat.hom_comp, CommRingCat.hom_ofHom, RingEquiv.toCommRingCatIso_hom]
  apply IsLocalization.ringHom_ext (Submonoid.powers y)
  ext w
  simp only [RingHom.coe_comp, Function.comp_apply, awayInclRight,
    RingHom.coe_coe,
    Algebra.TensorProduct.includeRight_apply, IsLocalization.Away.lift_eq]
  rw [show (1 : Localization.Away x) ⊗ₜ[A] (algebraMap A (Localization.Away y) w)
      = algebraMap A (TensorProduct A (Localization.Away x) (Localization.Away y)) w from by
        rw [Algebra.TensorProduct.algebraMap_apply, Algebra.algebraMap_eq_smul_one,
          Algebra.algebraMap_eq_smul_one, TensorProduct.tmul_smul, TensorProduct.smul_tmul']]
  exact (IsLocalization.algEquiv (Submonoid.powers (x * y))
    (TensorProduct A (Localization.Away x) (Localization.Away y))
    (Localization.Away (x * y))).commutes w

/-- The product-commutativity equivalence `R[1/(xy)] ≃+* R[1/(yx)]`: the two
away-localisations agree because `Submonoid.powers (x*y) = Submonoid.powers (y*x)`.
Project-local: resolves the product-order mismatch between `cocycleΘIJ` (domain
`R[1/(P^J_I · P^J_K)]`) and the target `awayPullbackIso` (codomain `R[1/(P^J_K · P^J_I)]`)
in the triple-overlap `t'`-field of the Grassmannian glue data. -/
noncomputable def awayMulCommEquiv {A : Type*} [CommRing A] (x y : A) :
    Localization.Away (x * y) ≃+* Localization.Away (y * x) := by
  haveI : IsLocalization.Away (y * x) (Localization.Away (x * y)) := by
    rw [mul_comm y x]; infer_instance
  exact (IsLocalization.algEquiv (Submonoid.powers (y * x))
    (Localization.Away (x * y)) (Localization.Away (y * x))).toRingEquiv

/-! ## Project-local Mathlib supplement — the Grassmannian glue data

We assemble the affine charts, their principal-open overlaps, the transition
isomorphisms and the cocycle into `AlgebraicGeometry.Scheme.GlueData`, indexed by
the size-`d` subsets `{I : Finset (Fin r) // I.card = d}`. Its `.glued` is the
Grassmannian scheme `Gr(d,r)` over `ℤ`.

Blueprint reference: `def:gr_glued_scheme`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- The triple-overlap `t'`-field of the Grassmannian glue data
(`def:gr_glued_scheme`): the morphism
`U^I_J ×_{U^I} U^I_K ⟶ U^J_K ×_{U^J} U^J_I` reconciling the two pullbacks via the
away-pullback identification, the localised transition `Θ_{I,J}`, and the
order-swap isomorphism. Project-local. -/
noncomputable def chartTransition' (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    Limits.pullback (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK) ⟶
      Limits.pullback (chartIncl d r J K hJ hK) (chartIncl d r J I hJ hI) :=
  (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom ≫
    Spec.map (CommRingCat.ofHom (cocycleΘIJ d r I J K hI hJ hK)) ≫
    Spec.map (CommRingCat.ofHom
      (awayMulCommEquiv (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).toRingHom) ≫
    (awayPullbackIso (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).inv

/-- `awayMulCommEquiv` lies over the base ring: it intertwines the two structure maps
`R → R[1/(xy)]` and `R → R[1/(yx)]`. Project-local helper for the `t_fac`/cocycle
ring computations. -/
lemma awayMulCommEquiv_comp_algebraMap {A : Type*} [CommRing A] (x y : A) :
    (awayMulCommEquiv x y).toRingHom.comp (algebraMap A (Localization.Away (x * y)))
      = algebraMap A (Localization.Away (y * x)) := by
  haveI : IsLocalization.Away (y * x) (Localization.Away (x * y)) := by
    rw [mul_comm y x]; infer_instance
  ext a
  exact (IsLocalization.algEquiv (Submonoid.powers (y * x))
    (Localization.Away (x * y)) (Localization.Away (y * x))).commutes a

/-- The ring-hom identity underlying the `t_fac` coherence field of the Grassmannian
glue data: over the triple-overlap rings, the localised transition `Θ_{I,J}`
pre-composed with the order-swap and right inclusion equals the left inclusion
post-composed with the plain transition `θ_{I,J}`. Both reduce to
`ι^L ∘ θ̃_{I,J}`. Project-local. -/
theorem chartTransition'_ringIdentity (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (cocycleΘIJ d r I J K hI hJ hK).comp
        ((awayMulCommEquiv (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).toRingHom.comp
          (awayInclRight (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)))
      = (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
          (transitionMap d r I J hI hJ) := by
  apply IsLocalization.ringHom_ext (Submonoid.powers (minorDet d r J I hJ hI))
  -- Reduce both sides to `ι^L ∘ θ̃_{I,J}` after precomposing with the structure map of
  -- `R^J[1/P^J_I]`.
  rw [RingHom.comp_assoc, RingHom.comp_assoc, awayInclRight_comp_algebraMap,
    awayMulCommEquiv_comp_algebraMap,
    cocycleΘIJ, IsLocalization.Away.lift_comp, RingHom.comp_assoc,
    transitionMap, IsLocalization.Away.lift_comp]

set_option maxHeartbeats 1600000 in
-- The `erw` through the `HasPullback` instance diamond on the heavy `MvPolynomial`
-- localisation objects is defeq-expensive; the raised limit covers it.
/-- The `t_fac`-compatibility field of the Grassmannian glue data
(`def:gr_glued_scheme`): the triple-overlap transition `t'` is compatible with the
projections, `t'_{I,J,K} ≫ pr₂ = pr₁ ≫ t_{I,J}`. Reduces, both pullbacks being
affine, to the ring identity `chartTransition'_ringIdentity` via the leg lemmas.
Project-local. -/
theorem chartTransition'_fac (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    chartTransition' d r I J K hI hJ hK ≫
        Limits.pullback.snd (chartIncl d r J K hJ hK) (chartIncl d r J I hJ hI)
      = Limits.pullback.fst (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK) ≫
          chartTransition d r I J hI hJ := by
  -- Rewrite the source `pr₁` via the iso (keeping a single `awayPullbackIso` term so the
  -- `HasPullback` instance is consistent), then cancel the leg via the iso identity.
  have hfstc : (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).inv ≫
        Limits.pullback.fst (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK)
      = Spec.map (CommRingCat.ofHom
          (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))) :=
    awayPullbackIso_inv_fst _ _
  have hfst := (Iso.inv_comp_eq _).mp hfstc
  -- The pure ring/`Spec` content: the three localised pieces equal the plain transition.
  have hXY : Spec.map (CommRingCat.ofHom (cocycleΘIJ d r I J K hI hJ hK)) ≫
        Spec.map (CommRingCat.ofHom
          (awayMulCommEquiv (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).toRingHom) ≫
          Spec.map (CommRingCat.ofHom
            (awayInclRight (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)))
      = Spec.map (CommRingCat.ofHom
            (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))) ≫
          Spec.map (CommRingCat.ofHom (transitionMap d r I J hI hJ)) := by
    rw [← Spec.map_comp, ← Spec.map_comp, ← Spec.map_comp, ← CommRingCat.ofHom_comp,
      ← CommRingCat.ofHom_comp, ← CommRingCat.ofHom_comp, chartTransition'_ringIdentity]
  rw [hfst, chartTransition']
  simp only [Category.assoc]
  -- `erw` (defeq) to fire the snd-leg lemma through the `HasPullback` instance diamond.
  erw [awayPullbackIso_inv_snd]
  simp only [chartTransition]
  -- `congrArg` + defeq associativity closes it (syntactic `rw`/`Category.assoc` are blocked
  -- by the Scheme-category instance diamond on these heavy localisation objects).
  exact congrArg (_ ≫ ·) hXY

/-! ## Project-local Mathlib supplement — the rotated triple-overlap ring cocycle `Φ = id`

The `cocycle` field of the Grassmannian glue data reduces (after stripping the conjugating
pullback isomorphisms) to a single ring identity `Φ = id` over the triple-overlap ring
`S_I = R^I[1/(P^I_J P^I_K)]`, where
`Φ := Θ_{I,J,K} ∘ swap_J ∘ Θ_{J,K,I} ∘ swap_K ∘ Θ_{K,I,J} ∘ swap_I` (rotated index triples).
We prove it by telescoping with the cocycle condition `cocycleCondition` (collapsing
`θ_{I,J} ∘ θ_{J,K} = θ_{I,K}`) down to a single inverse pair `θ_{I,K} ∘ θ_{K,I} = id`,
which is closed by the matrix computation `transitionInvImageMatrix` (the `(Y_K)⁻¹ Y` collapse
of `cocycle_imageMatrix_eq`, run for the inverse pair).

Blueprint reference: `lem:gr_cocycle_phi_id`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- The order-swap absorbs a left away-inclusion into a right one:
`swap_{x,y} ∘ ι^L_{x,y} = ι^R_{y,x}` as maps `R[1/x] → R[1/(yx)]`. Project-local helper for
the rotation lemma `rotMid`. -/
lemma awayMulCommEquiv_comp_awayInclLeft {A : Type*} [CommRing A] (x y : A) :
    (awayMulCommEquiv x y).toRingHom.comp (awayInclLeft x y) = awayInclRight y x := by
  apply IsLocalization.ringHom_ext (Submonoid.powers x)
  rw [RingHom.comp_assoc, awayInclLeft_comp_algebraMap, awayMulCommEquiv_comp_algebraMap,
    awayInclRight_comp_algebraMap]

/-- The two order-swaps are mutually inverse: `swap_{y,x} ∘ swap_{x,y} = id` on `R[1/(xy)]`.
Project-local helper. -/
lemma awayMulCommEquiv_comp_symm {A : Type*} [CommRing A] (x y : A) :
    (awayMulCommEquiv y x).toRingHom.comp (awayMulCommEquiv x y).toRingHom
      = RingHom.id (Localization.Away (x * y)) := by
  apply IsLocalization.ringHom_ext (Submonoid.powers (x * y))
  rw [RingHom.comp_assoc, awayMulCommEquiv_comp_algebraMap, awayMulCommEquiv_comp_algebraMap,
    RingHom.id_comp]

/-- **Rotation lemma** for the triple-overlap transitions: conjugating the rotated
`Θ_{J,K,I}` by the two order-swaps recovers the `J,K`-transition `Θ_{J,K}` in the `I,J,K`
frame. Both sides are lifts of `θ̃_{J,K}`; checked on the chart ring `R^K`. Project-local. -/
private lemma rotMid (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    ((awayMulCommEquiv (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).toRingHom.comp
        (cocycleΘIJ d r J K I hJ hK hI)).comp
        (awayMulCommEquiv (minorDet d r K I hK hI) (minorDet d r K J hK hJ)).toRingHom
      = cocycleΘJK d r I J K hI hJ hK := by
  apply IsLocalization.ringHom_ext
    (Submonoid.powers (minorDet d r K I hK hI * minorDet d r K J hK hJ))
  rw [RingHom.comp_assoc, awayMulCommEquiv_comp_algebraMap, RingHom.comp_assoc, cocycleΘIJ,
    IsLocalization.Away.lift_comp, ← RingHom.comp_assoc, awayMulCommEquiv_comp_awayInclLeft,
    cocycleΘJK, IsLocalization.Away.lift_comp]

/-- The matrix collapse behind the inverse pair `θ_{I,K} ∘ θ_{K,I} = id`: pushing the image
matrix `(X^K_I)⁻¹ X^K` of `θ_{K,I}` forward along `θ_{I,K}` (realised as
`cocycleΘIK ∘ ι^L`) recovers the universal matrix `X^I` over the triple-overlap ring `S_I`.
Both reduce to `W = X^I` over `S_I` via the `(W_K)⁻¹ W` computation, using `W_I = 1`.
Project-local. -/
private lemma transitionInvImageMatrix (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (imageMatrix d r K I hK hI).map
        ((cocycleΘIK d r I J K hI hJ hK).comp
          (awayInclLeft (minorDet d r K I hK hI) (minorDet d r K J hK hJ)))
      = (universalMatrix d r I hI).map
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
            (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK))) := by
  set incl := (cocycleΘIK d r I J K hI hJ hK).comp
    (awayInclLeft (minorDet d r K I hK hI) (minorDet d r K J hK hJ)) with hincldef
  have hcomp : incl.comp (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ K}) ℤ)
        (Localization.Away (minorDet d r K I hK hI)))
      = (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
          (transitionPreMap d r I K hI hK).toRingHom := by
    rw [hincldef, RingHom.comp_assoc, awayInclLeft_comp_algebraMap, cocycleΘIK,
      IsLocalization.Away.lift_comp]
  set W := (universalMatrix d r I hI).map
      (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
        (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK))) with hW
  have hWK : IsUnit (W.submatrix id (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r))).det := by
    have e : (W.submatrix id (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r))).det
        = algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
            (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK))
            (minorDet d r I K hI hK) := by
      rw [hW, Matrix.submatrix_map]
      exact (RingHom.map_det _ _).symm
    rw [e]; exact isUnit_algebraMap_away_right _ _
  have hMK : (universalMatrix d r K hK).map
        ((awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
          (transitionPreMap d r I K hI hK).toRingHom)
      = (W.submatrix id (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r)))⁻¹ * W := by
    have e1 : (universalMatrix d r K hK).map
          ((awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
            (transitionPreMap d r I K hI hK).toRingHom)
        = (imageMatrix d r I K hI hK).map
            (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) := by
      rw [← map_map_eq_of_comp (universalMatrix d r K hK)
          (transitionPreMap d r I K hI hK).toRingHom
          (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) _ rfl]
      congr 1
      exact universalMatrix_map_transitionPreMap d r I K hI hK
    rw [e1, imageMatrix_map_eq d r I K hI hK
      (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
      (awayInclRight_comp_algebraMap _ _), hW]
  have hWI : W.submatrix id (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) = 1 := by
    rw [hW, Matrix.submatrix_map, universalMatrix_submatrix_self]
    exact Matrix.map_one _ (map_zero _) (map_one _)
  have hmm : (imageMatrix d r K I hK hI).map incl
      = (universalMinorInv d r K I hK hI).map incl
        * ((universalMatrix d r K hK).map
            (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ K}) ℤ)
              (Localization.Away (minorDet d r K I hK hI)))).map incl := by
    rw [imageMatrix]; exact Matrix.map_mul
  rw [hmm, map_map_eq_of_comp _ _ _ _ hcomp, hMK, universalMinorInv,
    ← map_nonsing_inv incl (universalMinor d r K I hK hI) (isUnit_det_universalMinor d r K I hK hI),
    universalMinor, map_map_eq_of_comp _ _ _ _ hcomp, ← Matrix.submatrix_map, hMK,
    mul_submatrix_col (W.submatrix id (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r)))⁻¹ W
      (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)),
    hWI, mul_one, Matrix.nonsing_inv_nonsing_inv _ hWK, ← Matrix.mul_assoc,
    Matrix.mul_nonsing_inv _ hWK, Matrix.one_mul]

/-- The inverse-pair ring identity `θ_{I,K} ∘ θ_{K,I} = id` over the triple-overlap ring
`S_I = R^I[1/(P^I_J P^I_K)]`, phrased through the localised transitions and the order-swap:
`Θ_{I,J,K} ∘ Θ_{K,I,J} ∘ swap_I = id`. Closed on chart-ring generators by the matrix
collapse `transitionInvImageMatrix`. Project-local. -/
private lemma transitionInvPair (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (cocycleΘIK d r I J K hI hJ hK).comp
        ((cocycleΘIJ d r K I J hK hI hJ).comp
          (awayMulCommEquiv (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).toRingHom)
      = RingHom.id (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK)) := by
  have hLHScomp : ((cocycleΘIK d r I J K hI hJ hK).comp
        ((cocycleΘIJ d r K I J hK hI hJ).comp
          (awayMulCommEquiv (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).toRingHom)).comp
        (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
          (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK)))
      = ((cocycleΘIK d r I J K hI hJ hK).comp
          (awayInclLeft (minorDet d r K I hK hI) (minorDet d r K J hK hJ))).comp
          (transitionPreMap d r K I hK hI).toRingHom := by
    rw [RingHom.comp_assoc, RingHom.comp_assoc, awayMulCommEquiv_comp_algebraMap, cocycleΘIJ,
      IsLocalization.Away.lift_comp, ← RingHom.comp_assoc]
  apply IsLocalization.ringHom_ext
    (Submonoid.powers (minorDet d r I J hI hJ * minorDet d r I K hI hK))
  rw [RingHom.id_comp, hLHScomp]
  apply MvPolynomial.ringHom_ext
  · intro n
    exact RingHom.congr_fun (RingHom.ext_int
      (((cocycleΘIK d r I J K hI hJ hK).comp
        (awayInclLeft (minorDet d r K I hK hI) (minorDet d r K J hK hJ))).comp
          ((transitionPreMap d r K I hK hI).toRingHom.comp MvPolynomial.C))
      ((algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
          (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK))).comp
            MvPolynomial.C)) n
  · intro e
    have h := congrFun (congrFun (transitionInvImageMatrix d r I J K hI hJ hK) e.1) e.2.1
    rw [Matrix.map_apply, Matrix.map_apply, universalMatrix, dif_neg e.2.2] at h
    simpa [RingHom.comp_apply, transitionPreMap, MvPolynomial.aeval_X] using h

/-- **The rotated triple-overlap ring cocycle** `Φ = id` (`lem:gr_cocycle_phi_id`): over the
triple-overlap ring `S_I = R^I[1/(P^I_J P^I_K)]`, the composite
`Θ_{I,J,K} ∘ swap_J ∘ Θ_{J,K,I} ∘ swap_K ∘ Θ_{K,I,J} ∘ swap_I` is the identity. This is the
ring identity underlying the `cocycle` field of the Grassmannian glue data. Proved by
telescoping: the middle `swap_J ∘ Θ_{J,K,I} ∘ swap_K` collapses to `Θ_{J,K}` (`rotMid`), then
`Θ_{I,J} ∘ Θ_{J,K} = Θ_{I,K}` (`cocycleCondition`), leaving the inverse pair
`Θ_{I,K} ∘ Θ_{K,I} ∘ swap_I = id` (`transitionInvPair`). -/
theorem cocyclePhiId (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (cocycleΘIJ d r I J K hI hJ hK).comp
        ((awayMulCommEquiv (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).toRingHom.comp
          ((cocycleΘIJ d r J K I hJ hK hI).comp
            ((awayMulCommEquiv (minorDet d r K I hK hI) (minorDet d r K J hK hJ)).toRingHom.comp
              ((cocycleΘIJ d r K I J hK hI hJ).comp
                (awayMulCommEquiv (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).toRingHom))))
      = RingHom.id (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK)) := by
  have hΦ : (cocycleΘIJ d r I J K hI hJ hK).comp
        ((awayMulCommEquiv (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).toRingHom.comp
          ((cocycleΘIJ d r J K I hJ hK hI).comp
            ((awayMulCommEquiv (minorDet d r K I hK hI) (minorDet d r K J hK hJ)).toRingHom.comp
              ((cocycleΘIJ d r K I J hK hI hJ).comp
                (awayMulCommEquiv (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).toRingHom))))
      = (cocycleΘIK d r I J K hI hJ hK).comp
          ((cocycleΘIJ d r K I J hK hI hJ).comp
            (awayMulCommEquiv (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).toRingHom) := by
    rw [show (awayMulCommEquiv (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).toRingHom.comp
          ((cocycleΘIJ d r J K I hJ hK hI).comp
            ((awayMulCommEquiv (minorDet d r K I hK hI) (minorDet d r K J hK hJ)).toRingHom.comp
              ((cocycleΘIJ d r K I J hK hI hJ).comp
                (awayMulCommEquiv (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).toRingHom)))
        = (cocycleΘJK d r I J K hI hJ hK).comp
            ((cocycleΘIJ d r K I J hK hI hJ).comp
              (awayMulCommEquiv (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).toRingHom) from by
        rw [← RingHom.comp_assoc, ← RingHom.comp_assoc, rotMid],
      ← RingHom.comp_assoc, ← cocycleCondition]
  rw [hΦ]
  exact transitionInvPair d r I J K hI hJ hK

/- HANDOFF — the `cocycle` field of the glue data (`def:gr_glued_scheme`) and the final
`theGlueData`/`scheme` assembly are NOT yet added. The categorical reduction is solved:
  `simp only [chartTransition', Category.assoc, Iso.inv_hom_id_assoc]`
cancels the two internal `apXY.inv ≫ apXY.hom` pairs (both originate from the
`chartTransition'` def, so they share the instance and `simp` fires), reducing
  `t' I J K ≫ t' J K I ≫ t' K I J = 𝟙`
to the conjugated form
  `apᴵᴶ.hom ≫ (Spec.map Θ_{IJK} ≫ Spec.map swap_J ≫ Spec.map Θ_{JKI} ≫ Spec.map swap_K
              ≫ Spec.map Θ_{KIJ} ≫ Spec.map swap_I) ≫ apᴵᴶ.inv = 𝟙`,
where `apᴵᴶ = awayPullbackIso (minorDet I J) (minorDet I K)`, `Θ_{XYZ} = cocycleΘIJ d r X Y Z`,
`swap_X = awayMulCommEquiv …`.  Stripping the conjugating iso (`Iso`-cancellation, both ends
from the def so consistent) and collapsing the six `Spec.map`s via `← Spec.map_comp` /
`← CommRingCat.ofHom_comp` leaves the RING obligation
  `Φ = RingHom.id (Localization.Away (minorDet I J * minorDet I K))`,
  `Φ := (cocycleΘIJ d r I J K).comp (swap_J.comp ((cocycleΘIJ d r J K I).comp
        (swap_K.comp ((cocycleΘIJ d r K I J).comp swap_I))))`.
This is a rotated analogue of `cocycleCondition`; prove it by
`IsLocalization.ringHom_ext (Submonoid.powers (minorDet I J * minorDet I K))` reducing to the
chart ring generators, then the matrix-cocycle identity (`cocycle_imageMatrix_eq`-style).
Once `cocycle` lands, assemble `AlgebraicGeometry.Scheme.GlueData` with
`U := affineChart`, `V := chartOverlap`, `f := chartIncl`, `t := chartTransition`,
`t_id := chartTransition_self`, `t' := chartTransition'`, `t_fac := chartTransition'_fac`,
indexed by `{I : Finset (Fin r) // I.card = d}`, and set
`Grassmannian.scheme := theGlueData.glued`. -/

end AlgebraicGeometry.Grassmannian
