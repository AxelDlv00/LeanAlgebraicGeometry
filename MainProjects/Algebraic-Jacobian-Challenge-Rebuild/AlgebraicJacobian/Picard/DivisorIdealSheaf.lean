/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorIdealSections
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaDescent
import Mathlib.AlgebraicGeometry.IdealSheaf.Functorial

/-!
# The Cartier ideal sheaf of a widened divisor adaptation

The principal ideal on each affine piece of a widened adaptation is pushed to the ambient
relative curve, and their finite infimum is the global Cartier ideal.  The construction is
intrinsic to the arbitrary affine cover: it uses neither a chart typing nor `SwallowedBy`.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Opposite TopologicalSpace

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}

namespace AffAdaptation

/-- The principal ideal sheaf cut out by the adapted equation on one affine piece. -/
noncomputable def localCartierIdeal (A : AffAdaptation D d) (j : D.index) :
    (D.pieces j : Scheme).IdealSheafData :=
  Scheme.IdealSheafData.ofIdealTop
    (Ideal.span {(D.pieces j).topIso.inv.hom (A.eqn j)})

/-- The global Cartier ideal obtained by pushing the local principal ideals to the
relative curve and intersecting them. -/
noncomputable def cartierIdeal (A : AffAdaptation D d) :
    (relCurve C R).IdealSheafData :=
  iInf fun j : D.index => (A.localCartierIdeal j).map (D.pieces j).ι

/-- Inclusion of an affine piece in the relative curve is quasi-compact. -/
theorem quasiCompact_piece_ι [IsProper C.hom] (j : D.index) :
    QuasiCompact (D.pieces j).ι := by
  rw [quasiCompact_iff_forall_isAffineOpen]
  intro U hU
  have hpre : IsAffineOpen ((D.pieces j).ι ⁻¹ᵁ U) := by
    apply ((D.pieces j).ι.isAffineOpen_iff_of_isOpenImmersion).mp
    rw [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
    exact Over.isAffineOpen_inf C (D.isAffineOpen j) hU
  exact hpre.isCompact

/-- The inverse image of one adapted affine piece inside another is affine. -/
theorem isAffineOpen_piece_preimage [IsProper C.hom] (i j : D.index) :
    IsAffineOpen ((D.pieces j).ι ⁻¹ᵁ D.pieces i) := by
  apply ((D.pieces j).ι.isAffineOpen_iff_of_isOpenImmersion).mp
  rw [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
  exact Over.isAffineOpen_inf C (D.isAffineOpen j) (D.isAffineOpen i)

end AffAdaptation

end AlgebraicGeometry
