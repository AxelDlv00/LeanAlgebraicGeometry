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

open AlgebraicGeometry

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

end AlgebraicGeometry.Grassmannian
