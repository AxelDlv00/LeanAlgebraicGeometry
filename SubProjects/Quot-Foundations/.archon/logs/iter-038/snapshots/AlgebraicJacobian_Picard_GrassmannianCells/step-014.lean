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
              (awayMulCommEquiv (minorDet d r I J hI hJ)
                (minorDet d r I K hI hK)).toRingHom) from by
        rw [← RingHom.comp_assoc, ← RingHom.comp_assoc, rotMid],
      ← RingHom.comp_assoc, ← cocycleCondition]
  rw [hΦ]
  exact transitionInvPair d r I J K hI hJ hK

set_option maxHeartbeats 1600000 in
-- The `simp`/`Iso.inv_hom_id_assoc` cancellation of the conjugating pullback isomorphisms
-- over the heavy `MvPolynomial` away-localisation objects is defeq-expensive; raised limit.
/-- The **scheme-level cocycle** field of the Grassmannian glue data
(`def:gr_glued_scheme`): the threefold composite of triple-overlap transitions is the
identity. The two internal conjugating-pullback pairs cancel (`Iso.inv_hom_id_assoc`),
the six `Spec`-arrows collapse into a single `Spec` of the rotated ring cocycle `Φ`, and
`cocyclePhiId` (`Φ = id`) closes it, leaving `ap.hom ≫ ap.inv = 𝟙`. Project-local. -/
theorem chartTransition'_cocycle (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    chartTransition' d r I J K hI hJ hK ≫ chartTransition' d r J K I hJ hK hI ≫
        chartTransition' d r K I J hK hI hJ
      = CategoryTheory.CategoryStruct.id
          (Limits.pullback (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK)) := by
  have h6 : Spec.map (CommRingCat.ofHom (cocycleΘIJ d r I J K hI hJ hK)) ≫
        Spec.map (CommRingCat.ofHom (awayMulCommEquiv (minorDet d r J K hJ hK)
          (minorDet d r J I hJ hI)).toRingHom) ≫
        Spec.map (CommRingCat.ofHom (cocycleΘIJ d r J K I hJ hK hI)) ≫
        Spec.map (CommRingCat.ofHom (awayMulCommEquiv (minorDet d r K I hK hI)
          (minorDet d r K J hK hJ)).toRingHom) ≫
        Spec.map (CommRingCat.ofHom (cocycleΘIJ d r K I J hK hI hJ)) ≫
        Spec.map (CommRingCat.ofHom (awayMulCommEquiv (minorDet d r I J hI hJ)
          (minorDet d r I K hI hK)).toRingHom)
      = CategoryTheory.CategoryStruct.id (Spec (CommRingCat.of (Localization.Away
          (minorDet d r I J hI hJ * minorDet d r I K hI hK)))) := by
    rw [← Spec.map_comp, ← Spec.map_comp, ← Spec.map_comp, ← Spec.map_comp, ← Spec.map_comp,
      ← CommRingCat.ofHom_comp, ← CommRingCat.ofHom_comp, ← CommRingCat.ofHom_comp,
      ← CommRingCat.ofHom_comp, ← CommRingCat.ofHom_comp, cocyclePhiId, CommRingCat.ofHom_id,
      Spec.map_id]
  simp only [chartTransition', Category.assoc, Iso.inv_hom_id_assoc]
  rw [reassoc_of% h6, Iso.hom_inv_id]

/-! ## Project-local Mathlib supplement — the Grassmannian glue data and scheme

Assemble the affine charts, principal-open overlaps, transition isomorphisms, and the
cocycle into `AlgebraicGeometry.Scheme.GlueData`, indexed by the size-`d` subsets
`{I : Finset (Fin r) // I.card = d}`; its `.glued` is the Grassmannian scheme `Gr(d,r)`
over `ℤ`. Blueprint reference: `def:gr_glued_scheme`. -/

/-- The **Grassmannian glue data** (`def:gr_glued_scheme`): the `Scheme.GlueData` whose
charts are `affineChart`, overlaps `chartOverlap`, inclusions `chartIncl`, transitions
`chartTransition`, with cocycle `chartTransition'_cocycle`. Indexed by the size-`d` subsets
of `Fin r`. Project-local. -/
noncomputable def theGlueData (d r : ℕ) : Scheme.GlueData where
  J := {I : Finset (Fin r) // I.card = d}
  U I := affineChart d r I.1
  V p := chartOverlap d r p.1.1 p.2.1 p.1.2 p.2.2
  f I J := chartIncl d r I.1 J.1 I.2 J.2
  f_id I := chartIncl_self_isIso d r I.1 I.2
  f_open I J := chartIncl_isOpenImmersion d r I.1 J.1 I.2 J.2
  t I J := chartTransition d r I.1 J.1 I.2 J.2
  t_id I := chartTransition_self d r I.1 I.2
  t' I J K := chartTransition' d r I.1 J.1 K.1 I.2 J.2 K.2
  t_fac I J K := chartTransition'_fac d r I.1 J.1 K.1 I.2 J.2 K.2
  cocycle I J K := chartTransition'_cocycle d r I.1 J.1 K.1 I.2 J.2 K.2

/-- The **Grassmannian scheme** `Gr(d,r)` over `ℤ` (`def:gr_glued_scheme`): the scheme glued
from the `Nat.choose r d` affine charts `U^I` along the Plücker transition isomorphisms.
Project-local. -/
noncomputable def scheme (d r : ℕ) : Scheme :=
  (theGlueData d r).glued

/-! ## Project-local Mathlib supplement — the restricted diagonal and separatedness

Following Nitsure §1, "Separatedness": the Grassmannian is separated over `ℤ` because on
each affine patch `U^I ×_ℤ U^J` of `Gr(d,r) ×_ℤ Gr(d,r)` the restricted diagonal is a
closed immersion, equivalently the comorphism ring map
`δ_{I,J} : ℤ[X^I] ⊗_ℤ ℤ[X^J] → R^I_J = ℤ[X^I, 1/P^I_J]`,
`X^I ⊗ 1 ↦ X^I`, `1 ⊗ X^J ↦ (X^I_J)⁻¹ X^I` (the comorphism `θ_{I,J}`), is surjective.
We build `δ_{I,J}` as the tensor-product lift of the structure map `R^I → R^I_J` and the
pre-localisation transition hom `θ̃_{I,J}`, and prove it surjective: its image contains
`X^I` (left factor) and `1/P^I_J = δ_{I,J}(1 ⊗ P^J_I)` (the `I`-minor determinant of
`(X^I_J)⁻¹ X^I`), hence all of `R^I_J`.

Blueprint reference: `lem:gr_separated`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- The pre-hom sends `P^J_I` to the multiplicative inverse of (the image of) `P^I_J`:
`θ̃_{I,J}(P^J_I) · P^I_J = 1` in `R^I_J`. This refines `isUnit_transitionPreMap_minorDet`
to the explicit two-sided inverse, used to realise `1/P^I_J` in the image of the diagonal
ring map. Project-local. -/
theorem transitionPreMap_minorDet_swap_mul (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    transitionPreMap d r I J hI hJ (minorDet d r J I hJ hI) *
        algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
          (Localization.Away (minorDet d r I J hI hJ)) (minorDet d r I J hI hJ) = 1 := by
  have e1 : transitionPreMap d r I J hI hJ (minorDet d r J I hJ hI)
      = (((universalMatrix d r J hJ).submatrix id
          (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))).map
            (transitionPreMap d r I J hI hJ)).det :=
    RingHom.map_det (transitionPreMap d r I J hI hJ).toRingHom _
  rw [e1, ← Matrix.submatrix_map, universalMatrix_map_transitionPreMap, imageMatrix_submatrix_I]
  have hu : (universalMinor d r I J hI hJ).det
      = algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
          (Localization.Away (minorDet d r I J hI hJ)) (minorDet d r I J hI hJ) :=
    (RingHom.map_det _ _).symm
  rw [← hu, ← Matrix.det_mul, (universalMinorInv_mul_cancel d r I J hI hJ).1, Matrix.det_one]

/-- The **restricted-diagonal ring map** `δ_{I,J} : ℤ[X^I] ⊗_ℤ ℤ[X^J] → R^I_J`
(`lem:gr_separated`): the comorphism of the restricted diagonal
`Δ^{-1}(U^I ×_ℤ U^J) = U^I_J → U^I ×_ℤ U^J`. It is the tensor-product lift of the
structure map `R^I → R^I_J` (first factor) and the pre-localisation transition hom
`θ̃_{I,J} : R^J → R^I_J` (second factor), so `X^I ⊗ 1 ↦ X^I` and
`1 ⊗ X^J ↦ (X^I_J)⁻¹ X^I`. Project-local. -/
noncomputable def diagonalRingMap (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :=
  Algebra.TensorProduct.lift
    (IsScalarTower.toAlgHom ℤ (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
      (Localization.Away (minorDet d r I J hI hJ)))
    (transitionPreMap d r I J hI hJ)
    (fun _ _ => Commute.all _ _)

/-- `δ_{I,J}` on the left factor is the structure map: `δ_{I,J}(a ⊗ 1) = a` in `R^I_J`.
Project-local. -/
theorem diagonalRingMap_left (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (a : MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) :
    diagonalRingMap d r I J hI hJ (a ⊗ₜ[ℤ] 1)
      = algebraMap _ (Localization.Away (minorDet d r I J hI hJ)) a := by
  rw [diagonalRingMap, Algebra.TensorProduct.lift_tmul, map_one, mul_one]
  rfl

/-- `δ_{I,J}` on the right factor is the pre-localisation transition hom:
`δ_{I,J}(1 ⊗ b) = θ̃_{I,J}(b)`. Project-local. -/
theorem diagonalRingMap_right (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (b : MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ) :
    diagonalRingMap d r I J hI hJ (1 ⊗ₜ[ℤ] b) = transitionPreMap d r I J hI hJ b := by
  rw [diagonalRingMap, Algebra.TensorProduct.lift_tmul, map_one, one_mul]

/-- The **restricted-diagonal ring map is surjective** (`lem:gr_separated`): the comorphism
`δ_{I,J} : ℤ[X^I] ⊗_ℤ ℤ[X^J] → R^I_J` of the restricted diagonal is surjective, so the
restricted diagonal `U^I_J → U^I ×_ℤ U^J` is a closed immersion. The image contains the
structure-map image of `R^I` (left factor) and `1/P^I_J = δ_{I,J}(1 ⊗ P^J_I)` (right
factor), which together generate `R^I_J = R^I[1/P^I_J]`. Project-local. -/
theorem diagonalRingMap_surjective (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) : Function.Surjective (diagonalRingMap d r I J hI hJ) := by
  intro z
  -- `z · uⁿ = algebraMap a` for some `a` and `n = ` power of `P^I_J`, by the localisation
  -- property, where `u := P^I_J` in `R^I_J`.
  obtain ⟨⟨a, s⟩, hs⟩ := IsLocalization.surj (Submonoid.powers (minorDet d r I J hI hJ)) z
  obtain ⟨n, hn⟩ := s.2
  -- The witness pushes the power into the second tensor factor: `a ⊗ (P^J_I)ⁿ`, avoiding
  -- any arithmetic in the tensor-product ring.
  refine ⟨a ⊗ₜ[ℤ] (minorDet d r J I hJ hI ^ n), ?_⟩
  -- `v := θ̃_{I,J}(P^J_I)` is the inverse of `u := P^I_J` in `R^I_J`.
  have hvu : transitionPreMap d r I J hI hJ (minorDet d r J I hJ hI) *
      algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
        (Localization.Away (minorDet d r I J hI hJ)) (minorDet d r I J hI hJ) = 1 :=
    transitionPreMap_minorDet_swap_mul d r I J hI hJ
  -- `algebraMap ↑s = uⁿ`.
  have hsu : algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
      (Localization.Away (minorDet d r I J hI hJ)) (s : _)
      = (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
          (Localization.Away (minorDet d r I J hI hJ)) (minorDet d r I J hI hJ)) ^ n := by
    rw [← hn, map_pow]
  -- `algebraMap a = z · uⁿ`.
  have key : algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
      (Localization.Away (minorDet d r I J hI hJ)) a
      = z * (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
          (Localization.Away (minorDet d r I J hI hJ)) (minorDet d r I J hI hJ)) ^ n := by
    rw [← hs, hsu]
  -- `δ(a ⊗ (P^J_I)ⁿ) = algebraMap a · vⁿ = z · uⁿ · vⁿ = z · (u·v)ⁿ = z`.
  rw [diagonalRingMap, Algebra.TensorProduct.lift_tmul, map_pow,
    IsScalarTower.coe_toAlgHom', key, mul_assoc, ← mul_pow, mul_comm _
      (transitionPreMap d r I J hI hJ (minorDet d r J I hJ hI)), hvu, one_pow, mul_one]

/-- The intersection pullback `U^I ∩ U^J = pullback (ι i) (ι j)` is the chart overlap
`U^I_J = Spec R^I[1/P^I_J]` (`lem:gr_separated`, source identification): from the glue-data
universal property `theGlueData.vPullbackConeIsLimit`, whose cone point is `V (i,j) = chartOverlap`.
This is the `e₂` source iso of the restricted-diagonal closed-immersion argument. Project-local. -/
noncomputable def pullbackιIso (d r : ℕ) (i j : (theGlueData d r).J) :
    Limits.pullback ((theGlueData d r).ι i) ((theGlueData d r).ι j) ≅
      chartOverlap d r i.1 j.1 i.2 j.2 :=
  (Limits.limit.isLimit _).conePointUniqueUpToIso
    ((theGlueData d r).vPullbackConeIsLimit i j)

/-! ### Separatedness of the Grassmannian scheme

The blueprint target `lem:gr_separated` (`Grassmannian.isSeparated : (scheme d r).IsSeparated`)
is proved via the **structure morphism** `toSpecZ : scheme d r ⟶ Spec ℤ` (`scheme` is a
`Scheme.{0}`, so `Spec ℤ` is genuinely terminal — `specZIsTerminal` — and `toSpecZ` is its unique
map). We show `IsSeparated toSpecZ` by the Proj template (`AlgebraicGeometry.Proj.isSeparated`,
`Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Proper.lean`): on each patch `U^I ×_ℤ U^J` of the
cover `Pullback.openCoverOfLeftRight (theGlueData d r).openCover (theGlueData d r).openCover`,
`pullbackDiagonalMapIdIso` rewrites the restricted diagonal to the affine `Spec.map δ_{I,J}`,
a closed immersion by `IsClosedImmersion.spec_of_surjective` and `diagonalRingMap_surjective`. Then
`Scheme.IsSeparated` follows because `Spec ℤ` is affine (hence separated over the terminal). -/

/-- The **structure morphism** `Gr(d,r) → Spec ℤ` (`def:gr_glued_scheme`): the unique morphism to
the terminal object `Spec ℤ` (the Grassmannian scheme is a `Scheme.{0}`, so `specZIsTerminal`
applies). Project-local: the genuine base over which the Grassmannian is separated and proper. -/
noncomputable def toSpecZ (d r : ℕ) : scheme d r ⟶ Spec (CommRingCat.of ℤ) :=
  specZIsTerminal.from (scheme d r)

/-- The chart inclusion composed with the structure morphism is the affine structure map
`Spec ℤ[X^I] → Spec ℤ` (`Spec.map` of `ℤ → R^I`): both are morphisms to the terminal `Spec ℤ`.
Project-local: the `e₁`-leg input of the separatedness patch computation. -/
theorem ι_toSpecZ (d r : ℕ) (i : (theGlueData d r).J) :
    (theGlueData d r).ι i ≫ toSpecZ d r
      = Spec.map (CommRingCat.ofHom
          (algebraMap ℤ (MvPolynomial (Fin d × {q : Fin r // q ∉ i.1}) ℤ))) :=
  specZIsTerminal.hom_ext _ _

/-- First leg of the source iso `pullbackιIso`: `e₂⁻¹ ≫ pr₁ = chartIncl I J` (the `V (i,j) ⟶ U i`
leg of the glue-data pullback cone). Project-local: the `pullback.fst`-coherence for the
restricted-diagonal computation. -/
theorem pullbackιIso_inv_fst (d r : ℕ) (i j : (theGlueData d r).J) :
    (pullbackιIso d r i j).inv ≫
        Limits.pullback.fst ((theGlueData d r).ι i) ((theGlueData d r).ι j)
      = chartIncl d r i.1 j.1 i.2 j.2 := by
  have := (Limits.limit.isLimit
      (Limits.cospan ((theGlueData d r).ι i)
        ((theGlueData d r).ι j))).conePointUniqueUpToIso_inv_comp
    ((theGlueData d r).vPullbackConeIsLimit i j) Limits.WalkingCospan.left
  simpa [pullbackιIso, Limits.pullback.fst, Limits.PullbackCone.mk,
    Grassmannian.theGlueData] using this

/-- Second leg of the source iso `pullbackιIso`: `e₂⁻¹ ≫ pr₂ = chartTransition I J ≫ chartIncl J I`
(the `V (i,j) ⟶ U j` leg of the glue-data pullback cone, which is `t ≫ f`). Project-local. -/
theorem pullbackιIso_inv_snd (d r : ℕ) (i j : (theGlueData d r).J) :
    (pullbackιIso d r i j).inv ≫
        Limits.pullback.snd ((theGlueData d r).ι i) ((theGlueData d r).ι j)
      = chartTransition d r i.1 j.1 i.2 j.2 ≫ chartIncl d r j.1 i.1 j.2 i.2 := by
  have := (Limits.limit.isLimit
      (Limits.cospan ((theGlueData d r).ι i)
        ((theGlueData d r).ι j))).conePointUniqueUpToIso_inv_comp
    ((theGlueData d r).vPullbackConeIsLimit i j) Limits.WalkingCospan.right
  simpa [pullbackιIso, Limits.pullback.snd, Limits.PullbackCone.mk,
    Grassmannian.theGlueData] using this

/-- The overlap-to-chart composite `t_{I,J} ≫ ι_{J,I}` is the comorphism of the pre-localisation
transition hom `θ̃_{I,J}` (`Spec.map`): `chartTransition I J ≫ chartIncl J I = Spec.map θ̃_{I,J}`.
Both reduce to `θ̃_{I,J} = θ_{I,J} ∘ (R^J → R^J_I)` (`IsLocalization.Away.lift_comp`).
Project-local: the `pullback.snd`-leg comorphism of the restricted-diagonal computation. -/
theorem chartTransition_comp_chartIncl (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    chartTransition d r I J hI hJ ≫ chartIncl d r J I hJ hI
      = Spec.map (CommRingCat.ofHom (transitionPreMap d r I J hI hJ).toRingHom) := by
  rw [chartTransition, chartIncl,
    show CommRingCat.ofHom (transitionPreMap d r I J hI hJ).toRingHom
        = CommRingCat.ofHom (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ)
            (Localization.Away (minorDet d r J I hJ hI))) ≫
          CommRingCat.ofHom (transitionMap d r I J hI hJ)
      from by
        rw [← CommRingCat.ofHom_comp]
        congr 1
        rw [transitionMap]
        exact (IsLocalization.Away.lift_comp _ _).symm]
  exact (Spec.map_comp _ _).symm

set_option maxHeartbeats 3200000 in
-- The patch computation traverses the `pullbackDiagonalMapIdIso` / `pullbackSpecIso` instance
-- diamonds over the heavy `MvPolynomial` localisation objects (defeq-expensive `erw`s); raised limit.
set_option backward.isDefEq.respectTransparency false in
open TensorProduct CategoryTheory.Limits in
/-- The structure morphism `Gr(d,r) → Spec ℤ` is **separated** (`lem:gr_separated`, morphism form).
Following the Proj template (`AlgebraicGeometry.Proj.isSeparated`): on each patch
`U^I ×_ℤ U^J` of `Pullback.openCoverOfLeftRight` the restricted diagonal is, via
`pullbackDiagonalMapIdIso`, the affine morphism `Spec.map δ_{I,J}`, a closed immersion because
`δ_{I,J}` is surjective (`diagonalRingMap_surjective`). Project-local. -/
theorem isSeparatedToSpecZ (d r : ℕ) : IsSeparated (toSpecZ d r) := by
  refine ⟨IsZariskiLocalAtTarget.of_openCover (Scheme.Pullback.openCoverOfLeftRight
    (theGlueData d r).openCover (theGlueData d r).openCover (toSpecZ d r) (toSpecZ d r)) ?_⟩
  intro ⟨i, j⟩
  dsimp only [Scheme.Cover.pullbackHom]
  refine (MorphismProperty.cancel_left_of_respectsIso (P := @IsClosedImmersion)
    (f := (pullbackDiagonalMapIdIso ..).inv) _).mp ?_
  let e₁ : pullback ((theGlueData d r).openCover.f i ≫ toSpecZ d r)
        ((theGlueData d r).openCover.f j ≫ toSpecZ d r) ≅
        Spec (.of (TensorProduct ℤ
          (MvPolynomial (Fin d × {q : Fin r // q ∉ i.1}) ℤ)
          (MvPolynomial (Fin d × {q : Fin r // q ∉ j.1}) ℤ))) :=
    pullback.congrHom (ι_toSpecZ d r i) (ι_toSpecZ d r j) ≪≫ pullbackSpecIso ℤ _ _
  let e₂ : pullback ((theGlueData d r).openCover.f i) ((theGlueData d r).openCover.f j) ≅
        Spec (.of (Localization.Away (minorDet d r i.1 j.1 i.2 j.2))) :=
    pullbackιIso d r i j
  rw [← MorphismProperty.cancel_right_of_respectsIso (P := @IsClosedImmersion) _ e₁.hom,
    ← MorphismProperty.cancel_left_of_respectsIso (P := @IsClosedImmersion) e₂.inv]
  let F : TensorProduct ℤ
        (MvPolynomial (Fin d × {q : Fin r // q ∉ i.1}) ℤ)
        (MvPolynomial (Fin d × {q : Fin r // q ∉ j.1}) ℤ) →+*
        Localization.Away (minorDet d r i.1 j.1 i.2 j.2) :=
    (diagonalRingMap d r i.1 j.1 i.2 j.2).toRingHom
  have hsurj : Function.Surjective F := diagonalRingMap_surjective d r i.1 j.1 i.2 j.2
  convert IsClosedImmersion.spec_of_surjective (CommRingCat.ofHom F) hsurj using 1
  rw [← cancel_mono (pullbackSpecIso ℤ _ _).inv]
  apply pullback.hom_ext
  · simp only [e₂, e₁, Iso.trans_hom, pullback.congrHom_hom, Category.assoc, Iso.hom_inv_id,
      Category.comp_id, pullbackSpecIso_inv_fst, ← Spec.map_comp]
    rw [pullback.lift_fst, Category.comp_id]
    erw [pullbackDiagonalMapIdIso_inv_snd_fst]
    erw [pullbackιIso_inv_fst]
    rw [chartIncl]
    congr 1
    rw [← CommRingCat.ofHom_comp]
    congr 1
    refine RingHom.ext fun a => ?_
    rw [RingHom.comp_apply, Algebra.TensorProduct.includeLeftRingHom_apply]
    exact (diagonalRingMap_left d r i.1 j.1 i.2 j.2 a).symm
  · simp only [e₂, e₁, Iso.trans_hom, pullback.congrHom_hom, Category.assoc, Iso.hom_inv_id,
      Category.comp_id, pullbackSpecIso_inv_snd, ← Spec.map_comp]
    rw [pullback.lift_snd, Category.comp_id]
    erw [pullbackDiagonalMapIdIso_inv_snd_snd]
    erw [pullbackιIso_inv_snd]
    rw [chartTransition_comp_chartIncl]
    congr 1
    rw [← CommRingCat.ofHom_comp]
    congr 1
    refine RingHom.ext fun b => ?_
    exact (diagonalRingMap_right d r i.1 j.1 i.2 j.2 b).symm

/-- **The Grassmannian `Gr(d,r)` is separated over `ℤ`** (`lem:gr_separated`): the keystone
separatedness statement. Since the Grassmannian scheme is a `Scheme.{0}`, `Spec ℤ` is genuinely
terminal (`specZIsTerminal`); the structure morphism `toSpecZ` is separated
(`isSeparatedToSpecZ`) and `Spec ℤ` is affine (hence separated over the terminal), so the
composite `toSpecZ ≫ (Spec ℤ → ⊤)` — which is the terminal map of `Gr(d,r)` — is separated. -/
theorem isSeparated (d r : ℕ) : (scheme d r).IsSeparated := by
  have hsep : IsSeparated (toSpecZ d r) := isSeparatedToSpecZ d r
  rw [Scheme.isSeparated_iff]
  have he : Limits.terminal.from (scheme d r)
      = toSpecZ d r ≫ Limits.terminal.from (Spec (CommRingCat.of ℤ)) :=
    Limits.terminal.hom_ext _ _
  rw [he]
  infer_instance

/-! ## Project-local Mathlib supplement — properness scaffold (`scaffold` GrassmannianCells.lean)

Following Nitsure §1, "Properness" (`lem:gr_proper`): the structure morphism
`toSpecZ : Gr(d,r) → Spec ℤ` is **proper**. We discharge proper-ness through the Mathlib
valuative criterion `IsProper.of_valuativeCriterion`, which reduces `IsProper toSpecZ` to four
ingredients over `toSpecZ`:
* `QuasiCompact` — from the finite affine chart cover (`compactSpace_scheme`);
* `QuasiSeparated` — free from `isSeparatedToSpecZ` (`[IsSeparated f] : QuasiSeparated f`);
* `LocallyOfFiniteType` — each chart map `ℤ → R^I = ℤ[x^I_{p,q}]` is of finite type;
* `ValuativeCriterion` = `Existence ⊓ Uniqueness`, with `Uniqueness` free from separatedness
  (`IsSeparated.valuativeCriterion`) and `Existence` the genuine Nitsure chart-selection content.

This section builds the three "cheap" ingredients axiom-clean and isolates the existence
obligation; see the task-result handoff for the precise decomposition of the existence part.

Blueprint reference: `lem:gr_proper`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- The Grassmannian scheme is quasi-compact: it is glued from the finitely many
(`Nat.choose r d`) affine charts `U^I`, each `Spec` of a ring (hence compact).
Project-local: feeds `QuasiCompact (toSpecZ d r)` for properness. -/
instance compactSpace_scheme (d r : ℕ) : CompactSpace (scheme d r) := by
  haveI : Finite (theGlueData d r).openCover.I₀ :=
    inferInstanceAs (Finite {I : Finset (Fin r) // I.card = d})
  haveI : ∀ i, CompactSpace ((theGlueData d r).openCover.X i) := fun i =>
    inferInstanceAs (CompactSpace
      (Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ i.1}) ℤ))))
  exact (theGlueData d r).openCover.compactSpace

/-- The structure morphism `Gr(d,r) → Spec ℤ` is **quasi-compact**: `Spec ℤ` is affine and the
Grassmannian scheme is a compact space (`compactSpace_scheme`). Project-local: the `QuasiCompact`
input to the valuative criterion for properness. -/
theorem quasiCompact_toSpecZ (d r : ℕ) : QuasiCompact (toSpecZ d r) := by
  have : CompactSpace (scheme d r) := compactSpace_scheme d r
  exact HasAffineProperty.iff_of_isAffine.mpr this

/-- The structure morphism `Gr(d,r) → Spec ℤ` is **locally of finite type**: on each chart the
composite `U^I → Gr → Spec ℤ` is `Spec.map` of the structure map `ℤ → R^I = ℤ[x^I_{p,q}]`, a
finitely generated `ℤ`-algebra. Project-local: the `LocallyOfFiniteType` input to the valuative
criterion for properness. -/
theorem locallyOfFiniteType_toSpecZ (d r : ℕ) : LocallyOfFiniteType (toSpecZ d r) := by
  apply IsZariskiLocalAtSource.of_openCover (theGlueData d r).openCover
  intro i
  rw [show (theGlueData d r).openCover.f i ≫ toSpecZ d r
      = Spec.map (CommRingCat.ofHom
          (algebraMap ℤ (MvPolynomial (Fin d × {q : Fin r // q ∉ i.1}) ℤ))) from ι_toSpecZ d r i]
  exact (HasRingHomProperty.Spec_iff (P := @LocallyOfFiniteType)).mpr
    (RingHom.finiteType_algebraMap.mpr inferInstance)

/-- The structure morphism `Gr(d,r) → Spec ℤ` is **quasi-separated**: this is free from
separatedness (`isSeparatedToSpecZ`), as every separated morphism is quasi-separated.
Project-local: the `QuasiSeparated` input to the valuative criterion for properness. -/
theorem quasiSeparated_toSpecZ (d r : ℕ) : QuasiSeparated (toSpecZ d r) := by
  haveI : IsSeparated (toSpecZ d r) := isSeparatedToSpecZ d r
  infer_instance

/-- The **uniqueness part** of the valuative criterion for `toSpecZ` is free from separatedness:
`IsSeparated.valuativeCriterion` says every separated morphism satisfies the uniqueness part
(two `Spec R`-lifts agreeing on the generic point `Spec K` coincide). Project-local: the
`Uniqueness` half of `ValuativeCriterion (toSpecZ d r)`. -/
theorem valuativeUniqueness_toSpecZ (d r : ℕ) :
    ValuativeCriterion.Uniqueness (toSpecZ d r) := by
  haveI : IsSeparated (toSpecZ d r) := isSeparatedToSpecZ d r
  exact IsSeparated.valuativeCriterion (toSpecZ d r)

/-- **The minor-ratio identity** `θ̃_{I,J}(P^J_{K'}) · P^I_J = P^I_{K'}` over `R^I_J`
(generalises `transitionPreMap_minorDet_swap_mul`, the `K' = I` case where `P^I_I = 1`): the
pre-localisation transition hom sends the `K'`-minor of `X^J` to `det((X^I_J)⁻¹ X^I_{K'}) =
P^I_{K'} / P^I_J`. This is the algebraic core of the valuative-criterion existence argument
(Nitsure §1): pulling back through a `K`-point `f : R^I → K` it yields
`g(P^J_{K'}) = f(P^I_{K'}) / f(P^I_J)`, whose valuation `≥ 0` (Nitsure additive) / `≤ 1`
(multiplicative) by minimality drives the entries of `g(X^J)` into the valuation ring.
Project-local: feeds the existence half of `ValuativeCriterion (toSpecZ d r)`. -/
theorem transitionPreMap_minorDet_mul (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    transitionPreMap d r I J hI hJ (minorDet d r J K hJ hK) *
        algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
          (Localization.Away (minorDet d r I J hI hJ)) (minorDet d r I J hI hJ)
      = algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
          (Localization.Away (minorDet d r I J hI hJ)) (minorDet d r I K hI hK) := by
  rw [transitionPreMap_minorDet]
  have hsub : (imageMatrix d r I J hI hJ).submatrix id
        (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r))
      = universalMinorInv d r I J hI hJ *
        (((universalMatrix d r I hI).map (algebraMap _ _)).submatrix id
          (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r))) := mul_submatrix_col _ _ _
  rw [hsub, Matrix.det_mul]
  have hdet : (((universalMatrix d r I hI).map
          (algebraMap _ (Localization.Away (minorDet d r I J hI hJ)))).submatrix id
          (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r))).det
        = algebraMap _ (Localization.Away (minorDet d r I J hI hJ)) (minorDet d r I K hI hK) := by
    rw [Matrix.submatrix_map]; exact (RingHom.map_det _ _).symm
  rw [hdet]
  have hu : (universalMinor d r I J hI hJ).det
      = algebraMap _ (Localization.Away (minorDet d r I J hI hJ)) (minorDet d r I J hI hJ) :=
    (RingHom.map_det _ _).symm
  have hone : (universalMinorInv d r I J hI hJ).det *
      algebraMap _ (Localization.Away (minorDet d r I J hI hJ)) (minorDet d r I J hI hJ) = 1 := by
    rw [← hu, ← Matrix.det_mul, (universalMinorInv_mul_cancel d r I J hI hJ).1, Matrix.det_one]
  rw [mul_assoc, mul_comm _ (algebraMap _ _ (minorDet d r I J hI hJ)), ← mul_assoc, hone, one_mul]

/-- **Properness reduced to the existence part of the valuative criterion** (`lem:gr_proper`,
reduction form): the structure morphism `toSpecZ : Gr(d,r) → Spec ℤ` is proper as soon as the
*existence* part of the valuative criterion holds. The three "cheap" ingredients —
`QuasiCompact` (`quasiCompact_toSpecZ`), `QuasiSeparated` (`quasiSeparated_toSpecZ`),
`LocallyOfFiniteType` (`locallyOfFiniteType_toSpecZ`) — and the *uniqueness* part
(`valuativeUniqueness_toSpecZ`, free from separatedness) are discharged here, so the only
remaining obligation for `Grassmannian.isProper` is the Nitsure chart-selection existence
statement `ValuativeCriterion.Existence (toSpecZ d r)`. Project-local. -/
theorem isProper_of_valuativeExistence (d r : ℕ)
    (hE : ValuativeCriterion.Existence (toSpecZ d r)) : IsProper (toSpecZ d r) := by
  haveI : QuasiCompact (toSpecZ d r) := quasiCompact_toSpecZ d r
  haveI : QuasiSeparated (toSpecZ d r) := quasiSeparated_toSpecZ d r
  haveI : LocallyOfFiniteType (toSpecZ d r) := locallyOfFiniteType_toSpecZ d r
  apply IsProper.of_valuativeCriterion
  exact ValuativeCriterion.iff.mpr ⟨hE, valuativeUniqueness_toSpecZ d r⟩

/-! ## Existence step E1 — chart selection (`scaffold` GrassmannianCells.lean)

The existence half of the valuative criterion for `toSpecZ` (Nitsure §1, "Properness") is
the genuine geometric content. Its first step (E1) is the chart-selection factorization:
a `K`-point of `Gr(d,r)` for a field `K` factors through a single affine chart
`U^I = Spec R^I`. Since `Spec K` is a single point and the chart immersions jointly cover
`Gr(d,r)`, the image point lies in the range of some chart immersion, and a morphism out of
`Spec K` whose image lies in the range of an open immersion factors through it
(`IsOpenImmersion.lift`); affineness of the chart turns the lift into `Spec` of a ring map
(`Spec.preimage`).

Blueprint reference: `lem:gr_existence_chart_factorization`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- **E1 — the `K`-point factors through a single chart**
(`lem:gr_existence_chart_factorization`): for a field `K`, any morphism
`i₁ : Spec K ⟶ Gr(d,r)` factors as `Spec(f) ≫ ι_I` through a single chart immersion `ι_I` of
the glue datum (`theGlueData`), for some size-`d` subset `I` and ring homomorphism
`f : R^I = ℤ[X^I] → K`. Project-local: step E1 of the valuative-criterion existence argument
(Nitsure §1, "Properness"). -/
theorem existence_chart_factorization (d r : ℕ) {K : Type} [Field K]
    (i₁ : Spec (CommRingCat.of K) ⟶ scheme d r) :
    ∃ (I : (theGlueData d r).J)
      (f : MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ →+* K),
      i₁ = Spec.map (CommRingCat.ofHom f) ≫ (theGlueData d r).ι I := by
  obtain ⟨x₀⟩ : Nonempty (↥(Spec (CommRingCat.of K))) := inferInstance
  obtain ⟨I, y, hy⟩ := (theGlueData d r).ι_jointly_surjective (i₁.base x₀)
  have hrange : Set.range i₁.base ⊆ Set.range ((theGlueData d r).ι I).base := by
    rintro z ⟨x', rfl⟩
    rw [Subsingleton.elim x' x₀]
    exact ⟨y, hy⟩
  haveI hoi : IsOpenImmersion ((theGlueData d r).ι I) := (theGlueData d r).ι_isOpenImmersion I
  refine ⟨I, (Spec.preimage
    (@IsOpenImmersion.lift _ _ _ ((theGlueData d r).ι I) i₁ hoi hrange)).hom, ?_⟩
  rw [CommRingCat.ofHom_hom, Spec.map_preimage]
  exact (@IsOpenImmersion.lift_fac _ _ _ ((theGlueData d r).ι I) i₁ hoi hrange).symm

/-- **E2 — minimal-valuation chart selection** (`lem:gr_existence_minimal_valuation`):
given a valuation ring `R` with fraction field `K`, valuation `v := ValuationRing.valuation R K`,
a chart index `I` and a ring hom `f : R^I → K`, there is a chart index `J` *maximising*
`v (f (P^I_J))` over the finite index set of size-`d` subsets, and at the maximiser
`f (P^I_J) ≠ 0` (so the matrix `f(X^I_J)` is invertible over `K`). Since `P^I_I = 1`
(`minorDet_self`) the value at `I` is `v 1 = 1`, so the maximum is `≥ 1 > 0`. Project-local:
step E2 of the valuative-criterion existence argument (Nitsure §1, "Properness"). -/
theorem existence_minimal_valuation (d r : ℕ)
    {R K : Type} [CommRing R] [IsDomain R] [ValuationRing R] [Field K]
    [Algebra R K] [IsFractionRing R K]
    (I : (theGlueData d r).J)
    (f : MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ →+* K) :
    ∃ J : (theGlueData d r).J,
      (∀ J' : (theGlueData d r).J,
        ValuationRing.valuation R K (f (minorDet d r I.1 J'.1 I.2 J'.2))
          ≤ ValuationRing.valuation R K (f (minorDet d r I.1 J.1 I.2 J.2)))
      ∧ f (minorDet d r I.1 J.1 I.2 J.2) ≠ 0 := by
  haveI : Nonempty (theGlueData d r).J := ⟨I⟩
  haveI : Finite (theGlueData d r).J :=
    inferInstanceAs (Finite {I : Finset (Fin r) // I.card = d})
  set v := ValuationRing.valuation R K with hv
  obtain ⟨J, hJmax⟩ := Finite.exists_max
    (fun J' : (theGlueData d r).J => v (f (minorDet d r I.1 J'.1 I.2 J'.2)))
  refine ⟨J, hJmax, ?_⟩
  have h1 : v (f (minorDet d r I.1 I.1 I.2 I.2)) = 1 := by
    rw [minorDet_self d r I.1 I.2, map_one, Valuation.map_one]
  have hle : (1 : ValuationRing.ValueGroup R K) ≤ v (f (minorDet d r I.1 J.1 I.2 J.2)) := by
    have := hJmax I; rwa [h1] at this
  have hne : v (f (minorDet d r I.1 J.1 I.2 J.2)) ≠ 0 := by
    intro h; rw [h] at hle; exact (not_le.mpr zero_lt_one) hle
  exact (Valuation.ne_zero_iff v).mp hne

/-- **E3 ratio core — the pulled-back minor-ratio identity**
(displayed equation of `lem:gr_existence_factor_through_valuation_ring`): for a ring hom
`f : R^I → F` under which the minor `P^I_J` is a unit, let `f' : R^I_J → F` be its
away-localisation lift (`IsLocalization.Away.lift`). Then `g := f' ∘ θ̃_{I,J}` satisfies, for
every third subset `K`,
`g(P^J_K) · f(P^I_J) = f(P^I_K)`, i.e. `g(P^J_K) = f(P^I_K) / f(P^I_J)`.
This is `f'` applied to the ring-level minor-ratio identity `transitionPreMap_minorDet_mul`.
Project-local: the algebraic core of step E3; together with the valuation bound from E2 it
drives the entries of `g(X^J)` into the valuation ring. (The remaining step — that every free
entry `x^J_{p,q}` is, up to sign, such a minor `P^J_K` via cofactor expansion of a
column-substituted identity — is the one matrix-algebra gap still open for E3.) -/
theorem existence_lift_transitionPreMap_minorDet_mul (d r : ℕ) (I J K : Finset (Fin r))
    (hI : I.card = d) (hJ : J.card = d) (hK : K.card = d) {F : Type} [CommRing F]
    (f : MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ →+* F)
    (hf : IsUnit (f (minorDet d r I J hI hJ))) :
    (IsLocalization.Away.lift (minorDet d r I J hI hJ) hf)
        (transitionPreMap d r I J hI hJ (minorDet d r J K hJ hK))
        * f (minorDet d r I J hI hJ)
      = f (minorDet d r I K hI hK) := by
  have h := congrArg (IsLocalization.Away.lift (minorDet d r I J hI hJ) hf)
    (transitionPreMap_minorDet_mul d r I J K hI hJ hK)
  rwa [map_mul, IsLocalization.Away.lift_eq, IsLocalization.Away.lift_eq] at h

/-! ## Existence step E3 — cofactor expansion (`scaffold` GrassmannianCells.lean)

The remaining matrix-algebra gap of `lem:gr_existence_factor_through_valuation_ring`:
each free entry `x^J_{p,q}` of the universal matrix `X^J` (`q ∉ J`) equals, up to sign,
the minor `P^J_{K'}` with `K' = (J \ {j_p}) ∪ {q}` — the determinant obtained by replacing
the `p`-th identity column of `X^J_J` by column `q`. Cofactor expansion of a column-substituted
identity matrix: `det((1).updateCol p v) = v p`.

Blueprint reference: `lem:gr_existence_factor_through_valuation_ring`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- The determinant of the identity matrix with column `p` replaced by the vector `v`
is the `p`-th entry `v p` (cofactor expansion along the substituted column). Project-local:
Mathlib has `Matrix.cramer_apply` but no direct `det (1.updateCol …)` lemma. -/
private lemma det_one_updateCol {d : ℕ} {R : Type*} [CommRing R]
    (p : Fin d) (v : Fin d → R) :
    ((1 : Matrix (Fin d) (Fin d) R).updateCol p v).det = v p := by
  rw [← Matrix.cramer_apply]
  have h : (1 : Matrix (Fin d) (Fin d) R).cramer v = v := by
    have := Matrix.mulVec_cramer (1 : Matrix (Fin d) (Fin d) R) v
    rwa [Matrix.one_mulVec, Matrix.det_one, one_smul] at this
  rw [h]

/-- **Cofactor expansion of a free entry as a signed minor**: for `q ∉ J` and a row index
`p`, the free indeterminate `x^J_{p,q}` of the universal matrix `X^J` equals, up to a sign,
the minor `P^J_{K'}` where `K' = insert q (J.erase j_p)` (replace the `p`-th column `j_p` of
`X^J_J` by column `q`). Since `X^J_J` is the identity, the column-substituted minor is the
determinant of `(1).updateCol p (column q)`, namely `x^J_{p,q}`, up to the sign of the
column-reindexing permutation. Project-local: the matrix-algebra core of step E3
(`lem:gr_existence_factor_through_valuation_ring`). -/
theorem exists_minorDet_eq_free_entry (d r : ℕ) (J : Finset (Fin r)) (hJ : J.card = d)
    (p : Fin d) (q : Fin r) (hq : q ∉ J) :
    ∃ (K' : Finset (Fin r)) (hK' : K'.card = d),
      minorDet d r J K' hJ hK' = MvPolynomial.X (p, ⟨q, hq⟩) ∨
      minorDet d r J K' hJ hK' = - MvPolynomial.X (p, ⟨q, hq⟩) := by
  classical
  set jp : Fin r := (J.orderIsoOfFin hJ p : Fin r) with hjp
  have hjpJ : jp ∈ J := (J.orderIsoOfFin hJ p).2
  set K' : Finset (Fin r) := insert q (J.erase jp) with hK'def
  have hqnoterase : q ∉ J.erase jp := fun h => hq (Finset.mem_of_mem_erase h)
  have hd1 : 1 ≤ d := Nat.pos_of_ne_zero (fun h => by subst h; exact Fin.elim0 p)
  have hK' : K'.card = d := by
    rw [hK'def, Finset.card_insert_of_notMem hqnoterase, Finset.card_erase_of_mem hjpJ, hJ]
    omega
  refine ⟨K', hK', ?_⟩
  -- Injectivity of the order embedding `Fin d → Fin r` through `J`.
  have hJinj : ∀ k k' : Fin d,
      (J.orderIsoOfFin hJ k : Fin r) = (J.orderIsoOfFin hJ k' : Fin r) ↔ k = k' := by
    intro k k'; rw [Subtype.coe_inj, EmbeddingLike.apply_eq_iff_eq]
  -- The column-index map used to read off the substituted-identity minor.
  set colMap : Fin d → Fin r :=
    fun k => if k = p then q else (J.orderIsoOfFin hJ k : Fin r) with hcm
  -- `colMap k ∈ K'`.
  have hmem : ∀ k, colMap k ∈ K' := by
    intro k
    simp only [hcm]
    by_cases hk : k = p
    · rw [if_pos hk, hK'def]; exact Finset.mem_insert_self _ _
    · rw [if_neg hk, hK'def, Finset.mem_insert]
      refine Or.inr ?_
      rw [Finset.mem_erase]
      refine ⟨?_, (J.orderIsoOfFin hJ k).2⟩
      rw [hjp]; intro hcontra
      exact hk ((hJinj k p).mp hcontra)
  -- Injectivity of `colMap`.
  have hcmInj : Function.Injective colMap := by
    intro k k' hkk'
    simp only [hcm] at hkk'
    by_cases hk : k = p <;> by_cases hk' : k' = p
    · rw [hk, hk']
    · exfalso
      rw [if_pos hk, if_neg hk'] at hkk'
      exact hq (hkk' ▸ (J.orderIsoOfFin hJ k').2)
    · exfalso
      rw [if_neg hk, if_pos hk'] at hkk'
      exact hq (hkk'.symm ▸ (J.orderIsoOfFin hJ k).2)
    · rw [if_neg hk, if_neg hk'] at hkk'
      exact (hJinj k k').mp hkk'
  -- The order-reindexing permutation `σ` with `oiK' ∘ σ = colMap`.
  set oiK' : Fin d → Fin r := fun k => (K'.orderIsoOfFin hK' k : Fin r) with hoiK'
  set σfun : Fin d → Fin d :=
    fun k => (K'.orderIsoOfFin hK').symm ⟨colMap k, hmem k⟩ with hσfun
  have hσInj : Function.Injective σfun := by
    intro k k' h
    simp only [hσfun] at h
    have h2 : (⟨colMap k, hmem k⟩ : ↥K') = ⟨colMap k', hmem k'⟩ :=
      (K'.orderIsoOfFin hK').symm.injective h
    exact hcmInj (Subtype.mk_eq_mk.mp h2)
  set σ : Equiv.Perm (Fin d) :=
    Equiv.ofBijective σfun (Finite.injective_iff_bijective.mp hσInj) with hσ
  have hσprop : ∀ k, oiK' (σ k) = colMap k := by
    intro k
    simp only [hoiK', hσ, Equiv.ofBijective_apply, hσfun]
    rw [OrderIso.apply_symm_apply]
  -- The substituted-identity matrix and its determinant.
  set v : Fin d → MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ :=
    fun k' => universalMatrix d r J hJ k' q with hv
  have hBupd : (universalMatrix d r J hJ).submatrix id colMap
      = (1 : Matrix (Fin d) (Fin d)
          (MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ)).updateCol p v := by
    apply Matrix.ext
    intro k' k
    rw [Matrix.submatrix_apply, id_eq, Matrix.updateCol_apply]
    simp only [hcm]
    by_cases hk : k = p
    · simp only [if_pos hk, hv]
    · simp only [if_neg hk, universalMatrix]
      rw [dif_pos (J.orderIsoOfFin hJ k).2, Matrix.one_apply]
      by_cases hkk : k' = k
      · rw [if_pos ((hJinj k' k).mpr hkk), if_pos hkk]
      · rw [if_neg (fun h => hkk ((hJinj k' k).mp h)), if_neg hkk]
  have hdetB : ((universalMatrix d r J hJ).submatrix id colMap).det
      = MvPolynomial.X (p, ⟨q, hq⟩) := by
    rw [hBupd, det_one_updateCol]
    simp only [hv, universalMatrix, dif_neg hq]
  -- Relate `colMap` to the `K'`-minor via the permutation `σ`.
  have hcolEq : oiK' ∘ σ = colMap := funext hσprop
  have hsubEq : (universalMatrix d r J hJ).submatrix id colMap
      = ((universalMatrix d r J hJ).submatrix id oiK').submatrix id (σ : Fin d → Fin d) := by
    rw [Matrix.submatrix_submatrix, Function.comp_id, hcolEq]
  have hminor : ((universalMatrix d r J hJ).submatrix id oiK').det = minorDet d r J K' hJ hK' := by
    rw [minorDet]
  have hsign : MvPolynomial.X (p, ⟨q, hq⟩)
      = (↑(↑(Equiv.Perm.sign σ) : ℤ) : MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ)
        * minorDet d r J K' hJ hK' := by
    rw [← hdetB, hsubEq, Matrix.det_permute', hminor]
  rcases Int.units_eq_one_or (Equiv.Perm.sign σ) with hs | hs
  · left
    rw [hsign, hs]; simp
  · right
    rw [hsign, hs]; simp

/-- **E3 — entries land in `R`; `g` factors through the valuation ring**
(`lem:gr_existence_factor_through_valuation_ring`): for a valuation ring `R` with fraction
field `K`, a chart index `I` with a `K`-point `f : R^I → K`, and the minimal-valuation chart
index `J` (so `f(P^I_J)` is a unit and `v(f(P^I_{J'})) ≤ v(f(P^I_J))` for all `J'`), the
composite `g := f' ∘ θ̃_{I,J}` (where `f' = lift f along P^I_J`) sends every element of
`R^J = ℤ[X^J]` into the subring `(algebraMap R K).range ⊆ K`. Hence `g` factors through `R`.

Proof: by `MvPolynomial` induction it suffices to check the constants (in `ℤ ⊆ R`) and the
free generators `x^J_{p,q}`. Each generator equals `± P^J_{K'}` (`exists_minorDet_eq_free_entry`),
and `g(P^J_{K'}) = f(P^I_{K'})/f(P^I_J)` has valuation `≤ 1` by the maximality of `J`, hence lies
in `R = v.integer` (`ValuationRing.range_algebraMap_eq`). Project-local: the genuine geometric
content of the existence half of the valuative criterion for `toSpecZ` (Nitsure §1). -/
theorem existence_factor_through_valuationRing (d r : ℕ)
    {R K : Type} [CommRing R] [IsDomain R] [ValuationRing R] [Field K]
    [Algebra R K] [IsFractionRing R K]
    (I J : (theGlueData d r).J)
    (f : MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ →+* K)
    (hJmax : ∀ J' : (theGlueData d r).J,
        ValuationRing.valuation R K (f (minorDet d r I.1 J'.1 I.2 J'.2))
          ≤ ValuationRing.valuation R K (f (minorDet d r I.1 J.1 I.2 J.2)))
    (hf : IsUnit (f (minorDet d r I.1 J.1 I.2 J.2))) :
    ∀ x : MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ,
      ((IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf).comp
        (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom) x ∈ (algebraMap R K).range := by
  set g : MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ →+* K :=
    (IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf).comp
      (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom with hg
  have key : ∀ x, g x = (IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf)
      (transitionPreMap d r I.1 J.1 I.2 J.2 x) := fun _ => rfl
  set v := ValuationRing.valuation R K with hv
  -- Each value `g(P^J_{K'})` lies in `R`.
  have hminorR : ∀ (K' : Finset (Fin r)) (hK' : K'.card = d),
      g (minorDet d r J.1 K' J.2 hK') ∈ (algebraMap R K).range := by
    intro K' hK'
    rw [← ValuationRing.range_algebraMap_eq R K, Valuation.mem_integer_iff]
    have hmul : g (minorDet d r J.1 K' J.2 hK') * f (minorDet d r I.1 J.1 I.2 J.2)
        = f (minorDet d r I.1 K' I.2 hK') := by
      rw [key]
      exact existence_lift_transitionPreMap_minorDet_mul d r I.1 J.1 K' I.2 J.2 hK' f hf
    have hmax : v (f (minorDet d r I.1 K' I.2 hK'))
        ≤ v (f (minorDet d r I.1 J.1 I.2 J.2)) := hJmax ⟨K', hK'⟩
    have hc : v (f (minorDet d r I.1 J.1 I.2 J.2)) ≠ 0 :=
      (Valuation.ne_zero_iff v).mpr hf.ne_zero
    have hvmul : v (g (minorDet d r J.1 K' J.2 hK')) * v (f (minorDet d r I.1 J.1 I.2 J.2))
        ≤ v (f (minorDet d r I.1 J.1 I.2 J.2)) := by
      rw [← Valuation.map_mul, hmul]; exact hmax
    have h' : v (g (minorDet d r J.1 K' J.2 hK')) * v (f (minorDet d r I.1 J.1 I.2 J.2))
        ≤ 1 * v (f (minorDet d r I.1 J.1 I.2 J.2)) := by rwa [one_mul]
    exact le_of_mul_le_mul_right h' (zero_lt_iff.mpr hc)
  -- The free generators land in `R` via the cofactor identity.
  have hgen : ∀ n : Fin d × {q : Fin r // q ∉ J.1},
      g (MvPolynomial.X n) ∈ (algebraMap R K).range := by
    rintro ⟨pp, ⟨qq, hqq⟩⟩
    obtain ⟨K', hK', hcase⟩ := exists_minorDet_eq_free_entry d r J.1 J.2 pp qq hqq
    have hmemR := hminorR K' hK'
    rcases hcase with h | h
    · have hX : g (MvPolynomial.X (pp, ⟨qq, hqq⟩)) = g (minorDet d r J.1 K' J.2 hK') := by
        rw [h]
      rw [hX]; exact hmemR
    · have hX : g (MvPolynomial.X (pp, ⟨qq, hqq⟩)) = - g (minorDet d r J.1 K' J.2 hK') := by
        rw [h, map_neg, neg_neg]
      rw [hX]; exact neg_mem hmemR
  -- Induction over `MvPolynomial`.
  intro x
  induction x using MvPolynomial.induction_on with
  | C a =>
    refine ⟨(a : R), ?_⟩
    have h1 : g (MvPolynomial.C a) = (a : K) :=
      RingHom.congr_fun (RingHom.ext_int (g.comp MvPolynomial.C) (Int.castRingHom K)) a
    rw [map_intCast, h1]
  | add p q hp hq => rw [map_add]; exact add_mem hp hq
  | mul_X p n hp => rw [map_mul]; exact mul_mem hp (hgen n)

/-! ## Existence step E4 — the filler and its two triangles (`scaffold` GrassmannianCells.lean)

The final step of the valuative-criterion existence argument (Nitsure §1, "Properness"):
having factored the generic-point morphism `i₁` through a chart `I` with ring map `f`
(E1, `existence_chart_factorization`), selected the minimal-valuation chart `J` (E2,
`existence_minimal_valuation`), and factored the transported ring map `g := f' ∘ θ̃_{I,J}`
through the valuation ring as `g = (R ↪ K) ∘ g'` (E3, `existence_factor_through_valuationRing`),
the diagonal filler of the valuative square is

  `ℓ := Spec.map g' ≫ ι_J : Spec R ⟶ Gr(d,r)`.

Its **top triangle** (`Spec.map (algebraMap R K) ≫ ℓ = i₁`) is the genuine geometric content:
it reduces to the *K-point identity* `Spec.map g ≫ ι_J = Spec.map f ≫ ι_I`
(`existence_chart_kpoint_eq`), proved via the glue condition
(`Scheme.GlueData.glue_condition`: `t ≫ f' ≫ ι = f ≫ ι`), the comorphism identity
`chartTransition_comp_chartIncl` (`Spec.map θ̃_{I,J} = t_{I,J} ≫ ι_{J,I}`), and the
away-localisation lift property `f' ∘ (R^I → R^I_J) = f`. Its **bottom triangle**
(`ℓ ≫ toSpecZ = i₂`) is free: both sides land in the terminal `Spec ℤ` (`specZIsTerminal`).

Blueprint reference: `lem:gr_existence_lift`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- **E4 K-point identity** (top-triangle core of `lem:gr_existence_lift`): for a field `K`,
chart indices `I, J`, a ring hom `f : R^I → K` under which the minor `P^I_J` is a unit, the
transported `K`-point `g := f' ∘ θ̃_{I,J}` (with `f' := IsLocalization.Away.lift f along P^I_J`)
presents the *same* `K`-point through chart `J` as `f` does through chart `I`:
`Spec.map g ≫ ι_J = Spec.map f ≫ ι_I`. Proved by the glue condition
(`t_{I,J} ≫ ι_{J,I} ≫ ι_J = ι_{I,J} ≫ ι_I`), the comorphism identity
`chartTransition_comp_chartIncl`, and `IsLocalization.Away.lift_comp`. Project-local: the
geometric core of step E4 of the valuative-criterion existence argument (Nitsure §1). -/
theorem existence_chart_kpoint_eq (d r : ℕ) {K : Type} [Field K] (I J : (theGlueData d r).J)
    (f : MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ →+* K)
    (hf : IsUnit (f (minorDet d r I.1 J.1 I.2 J.2))) :
    Spec.map (CommRingCat.ofHom
        ((IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf).comp
          (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom)) ≫ (theGlueData d r).ι J
      = Spec.map (CommRingCat.ofHom f) ≫ (theGlueData d r).ι I := by
  set f' : Localization.Away (minorDet d r I.1 J.1 I.2 J.2) →+* K :=
    IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf with hf'def
  -- `ofHom (f' ∘ θ̃) = ofHom θ̃ ≫ ofHom f'`, so `Spec.map (ofHom (f' ∘ θ̃))`
  -- `= Spec.map (ofHom f') ≫ Spec.map (ofHom θ̃)`.
  rw [show CommRingCat.ofHom (f'.comp (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom)
        = CommRingCat.ofHom (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom ≫ CommRingCat.ofHom f'
      from by rw [← CommRingCat.ofHom_comp], Spec.map_comp, Category.assoc,
    ← chartTransition_comp_chartIncl d r I.1 J.1 I.2 J.2]
  -- `Spec.map (ofHom f') ≫ (t_{I,J} ≫ ι_{J,I}) ≫ ι_J`; apply the glue condition.
  have hglue : (chartTransition d r I.1 J.1 I.2 J.2 ≫ chartIncl d r J.1 I.1 J.2 I.2)
        ≫ (theGlueData d r).ι J
      = chartIncl d r I.1 J.1 I.2 J.2 ≫ (theGlueData d r).ι I := by
    rw [Category.assoc]; exact (theGlueData d r).glue_condition I J
  -- The glue step (via `congrArg` — `rw`/`Category.assoc`/`Spec.map_comp` are blocked by the
  -- Scheme-category instance diamond on these heavy localisation objects, as in
  -- `chartTransition'_fac`; the whole tail is therefore term-mode).
  refine (congrArg (Spec.map (CommRingCat.ofHom f') ≫ ·) hglue).trans ?_
  -- `Spec.map (ofHom f') ≫ ι_{I,J} = Spec.map (ofHom f)`, via `f' ∘ (R^I → R^I_J) = f`.
  have hfI : Spec.map (CommRingCat.ofHom f') ≫ chartIncl d r I.1 J.1 I.2 J.2
      = Spec.map (CommRingCat.ofHom f) := by
    have e1 : CommRingCat.ofHom (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
          (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))) ≫ CommRingCat.ofHom f'
        = CommRingCat.ofHom f := by
      rw [← CommRingCat.ofHom_comp]
      exact congrArg CommRingCat.ofHom (IsLocalization.Away.lift_comp _ hf)
    calc Spec.map (CommRingCat.ofHom f') ≫ chartIncl d r I.1 J.1 I.2 J.2
        = Spec.map (CommRingCat.ofHom (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
              (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))) ≫ CommRingCat.ofHom f') :=
          (Spec.map_comp _ _).symm
      _ = Spec.map (CommRingCat.ofHom f) := congrArg Spec.map e1
  calc Spec.map (CommRingCat.ofHom f') ≫ chartIncl d r I.1 J.1 I.2 J.2 ≫ (theGlueData d r).ι I
      = (Spec.map (CommRingCat.ofHom f') ≫ chartIncl d r I.1 J.1 I.2 J.2)
          ≫ (theGlueData d r).ι I := (Category.assoc _ _ _).symm
    _ = Spec.map (CommRingCat.ofHom f) ≫ (theGlueData d r).ι I :=
        congrArg (· ≫ (theGlueData d r).ι I) hfI

/-- **E4 — the diagonal filler and its two triangles** (`lem:gr_existence_lift`): given a
valuative square over `toSpecZ` whose generic-point morphism `i₁` factors as
`Spec.map f ≫ ι_I` through chart `I` (E1, `existence_chart_factorization`), with `P^I_J` a unit
under `f` (E2, `existence_minimal_valuation`) and the transported ring map `g := f' ∘ θ̃_{I,J}`
factored through the valuation ring as `g = (R ↪ K) ∘ g'` (E3,
`existence_factor_through_valuationRing`), the morphism `ℓ := Spec.map g' ≫ ι_J : Spec R ⟶ Gr(d,r)`
is a diagonal lift of the square. The **top triangle**
`Spec.map (algebraMap R K) ≫ ℓ = i₁` is `existence_chart_kpoint_eq` (the `K`-point identity)
after collapsing `algebraMap ∘ g' = g`; the **bottom triangle** `ℓ ≫ toSpecZ = i₂` is free, both
legs landing in the terminal `Spec ℤ` (`specZIsTerminal`). Project-local: step E4 of the
valuative-criterion existence argument (Nitsure §1, "Properness"). -/
noncomputable def existence_lift (d r : ℕ)
    {R K : Type} [CommRing R] [IsDomain R] [ValuationRing R] [Field K]
    [Algebra R K] [IsFractionRing R K]
    (I J : (theGlueData d r).J)
    (i₁ : Spec (CommRingCat.of K) ⟶ scheme d r)
    (i₂ : Spec (CommRingCat.of R) ⟶ Spec (CommRingCat.of ℤ))
    (sq : CommSq i₁ (Spec.map (CommRingCat.ofHom (algebraMap R K))) (toSpecZ d r) i₂)
    (f : MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ →+* K)
    (hi₁ : i₁ = Spec.map (CommRingCat.ofHom f) ≫ (theGlueData d r).ι I)
    (hf : IsUnit (f (minorDet d r I.1 J.1 I.2 J.2)))
    (g' : MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ →+* R)
    (hg' : (algebraMap R K).comp g'
      = (IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf).comp
          (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom) :
    sq.LiftStruct where
  l := Spec.map (CommRingCat.ofHom g') ≫ (theGlueData d r).ι J
  fac_left := by
    -- `Spec.map (ofHom algebraMap) ≫ Spec.map (ofHom g') = Spec.map (ofHom g)`,
    -- via `algebraMap ∘ g' = g`.
    have hcomp : Spec.map (CommRingCat.ofHom (algebraMap R K)) ≫ Spec.map (CommRingCat.ofHom g')
        = Spec.map (CommRingCat.ofHom
            ((IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf).comp
              (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom)) := by
      have e : CommRingCat.ofHom g' ≫ CommRingCat.ofHom (algebraMap R K)
          = CommRingCat.ofHom ((IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf).comp
              (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom) := by
        rw [← CommRingCat.ofHom_comp]; exact congrArg CommRingCat.ofHom hg'
      exact (Spec.map_comp _ _).symm.trans (congrArg Spec.map e)
    rw [hi₁]
    -- Term-mode (Scheme-category instance diamond on the heavy localisation objects).
    calc Spec.map (CommRingCat.ofHom (algebraMap R K)) ≫
            (Spec.map (CommRingCat.ofHom g') ≫ (theGlueData d r).ι J)
        = (Spec.map (CommRingCat.ofHom (algebraMap R K)) ≫ Spec.map (CommRingCat.ofHom g'))
            ≫ (theGlueData d r).ι J := (Category.assoc _ _ _).symm
      _ = Spec.map (CommRingCat.ofHom
            ((IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf).comp
              (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom)) ≫ (theGlueData d r).ι J :=
            congrArg (· ≫ (theGlueData d r).ι J) hcomp
      _ = Spec.map (CommRingCat.ofHom f) ≫ (theGlueData d r).ι I :=
            existence_chart_kpoint_eq d r I J f hf
  fac_right := specZIsTerminal.hom_ext _ _

/-! ## Existence step E5 — the existence half of the valuative criterion
(`scaffold` GrassmannianCells.lean)

Assemble E1–E4 into the existence part of the valuative criterion for `toSpecZ`: every valuative
square admits a diagonal lift. Given a `ValuativeCommSq (toSpecZ d r)` with valuation ring `R` and
fraction field `K`, factor the generic-point morphism through a chart (E1), select the
minimal-valuation chart `J` (E2), factor the transported `K`-point through `R` (E3, giving `g'`),
and feed everything to the filler (E4).

Blueprint reference: `lem:gr_valuativeExistence_toSpecZ`
(`blueprint/src/chapters/Picard_GrassmannianCells.tex`). -/

/-- A ring hom `φ : A → K` into the fraction field `K` of a domain `R`, with image contained in the
subring `(algebraMap R K).range`, corestricts to a ring hom `A → R`. Project-local helper for
assembling `g'` (the valuation-ring factorisation of the transported `K`-point) in step E5. -/
private noncomputable def liftToBaseOfMemRange {A R K : Type*} [CommRing A] [CommRing R]
    [Field K] [Algebra R K] [IsFractionRing R K] (φ : A →+* K)
    (hmem : ∀ x, φ x ∈ (algebraMap R K).range) : A →+* R :=
  letI hinj : Function.Injective (algebraMap R K).rangeRestrict := fun a b h =>
    IsFractionRing.injective R K (by
      have hv := congrArg Subtype.val h
      rwa [RingHom.coe_rangeRestrict, RingHom.coe_rangeRestrict] at hv)
  (RingEquiv.ofBijective (algebraMap R K).rangeRestrict
    ⟨hinj, (algebraMap R K).rangeRestrict_surjective⟩).symm.toRingHom.comp
    (φ.codRestrict (algebraMap R K).range hmem)

/-- The defining property of `liftToBaseOfMemRange`: composing the corestriction back with the
structure map `R ↪ K` recovers the original `φ`. Project-local. -/
private lemma algebraMap_comp_liftToBaseOfMemRange {A R K : Type*} [CommRing A] [CommRing R]
    [Field K] [Algebra R K] [IsFractionRing R K] (φ : A →+* K)
    (hmem : ∀ x, φ x ∈ (algebraMap R K).range) :
    (algebraMap R K).comp (liftToBaseOfMemRange φ hmem) = φ := by
  letI hinj : Function.Injective (algebraMap R K).rangeRestrict := fun a b h =>
    IsFractionRing.injective R K (by
      have hv := congrArg Subtype.val h
      rwa [RingHom.coe_rangeRestrict, RingHom.coe_rangeRestrict] at hv)
  set e := RingEquiv.ofBijective (algebraMap R K).rangeRestrict
    ⟨hinj, (algebraMap R K).rangeRestrict_surjective⟩ with he
  ext x
  change algebraMap R K (e.symm (φ.codRestrict (algebraMap R K).range hmem x)) = φ x
  have happ : (algebraMap R K).rangeRestrict (e.symm (φ.codRestrict (algebraMap R K).range hmem x))
      = φ.codRestrict (algebraMap R K).range hmem x := by
    rw [← RingEquiv.ofBijective_apply (algebraMap R K).rangeRestrict
      ⟨hinj, (algebraMap R K).rangeRestrict_surjective⟩, ← he, RingEquiv.apply_symm_apply]
  have hv := congrArg Subtype.val happ
  rwa [RingHom.coe_rangeRestrict] at hv

/-- **E5 — the existence half of the valuative criterion for `toSpecZ`**
(`lem:gr_valuativeExistence_toSpecZ`): every valuative square over the structure morphism
`toSpecZ : Gr(d,r) → Spec ℤ` admits a diagonal lift. Assembles the chart factorization (E1,
`existence_chart_factorization`), the minimal-valuation chart selection (E2,
`existence_minimal_valuation`), the valuation-ring factorization of the transported `K`-point (E3,
`existence_factor_through_valuationRing`, corestricted to `g'` via `liftToBaseOfMemRange`), and the
filler (E4, `existence_lift`). Project-local: the genuine geometric content of properness; feeds
`isProper_of_valuativeExistence` to close `Grassmannian.isProper`. -/
theorem valuativeExistence_toSpecZ (d r : ℕ) :
    ValuativeCriterion.Existence (toSpecZ d r) := by
  intro S
  -- E1: factor the generic-point morphism through a chart `I`.
  obtain ⟨I, f, hi₁⟩ := existence_chart_factorization d r S.i₁
  -- E2: select the minimal-valuation chart `J` (`f (P^I_J) ≠ 0`).
  obtain ⟨J, hJmax, hne⟩ := existence_minimal_valuation d r (R := S.R) I f
  -- In the field `K`, nonzero means unit.
  have hf : IsUnit (f (minorDet d r I.1 J.1 I.2 J.2)) := isUnit_iff_ne_zero.mpr hne
  -- E3: the transported `K`-point `g` lands in `R`; corestrict to `g'`.
  have hmem := existence_factor_through_valuationRing d r I J f hJmax hf
  have hg' : (algebraMap S.R S.K).comp
        (liftToBaseOfMemRange
          ((IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf).comp
            (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom) hmem)
      = (IsLocalization.Away.lift (minorDet d r I.1 J.1 I.2 J.2) hf).comp
          (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom :=
    algebraMap_comp_liftToBaseOfMemRange _ hmem
  -- E4: the filler is a lift structure for the square.
  exact ⟨⟨existence_lift d r I J S.i₁ S.i₂ S.commSq f hi₁ hf _ hg'⟩⟩

end AlgebraicGeometry.Grassmannian
