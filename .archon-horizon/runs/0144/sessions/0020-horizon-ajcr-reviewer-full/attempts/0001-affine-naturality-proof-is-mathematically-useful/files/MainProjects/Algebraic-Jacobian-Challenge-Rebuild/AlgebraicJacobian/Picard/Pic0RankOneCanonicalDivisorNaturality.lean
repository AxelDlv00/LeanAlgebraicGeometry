/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorFree

/-!
# Naturality of the canonical rank-one divisor on affine tests

The Noetherian-free canonical divisor commutes with arbitrary affine base change.  This is the
affine naturality input required to assemble the canonical evaluation divisor on general tests.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Opposite

namespace AlgebraicGeometry

attribute [local instance] Over.sectionsAlgebra Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable (pi : C.left ⟶ P1 k) [IsFinite pi]

noncomputable section

/-- The canonical rank-one divisor commutes with arbitrary affine base change. -/
theorem canonicalRankOneDivisorOfMem_mapAlgHom
    (hpi : pi ≫ P1.structureMap k = C.hom)
    {A B : Type u} [CommRing A] [Algebra k A] [CommRing B] [Algebra k B]
    (φ : A →ₐ[k] B)
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (hlam : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k A))) :
    DivFamZarAff.mapAlgHom φ (canonicalRankOneDivisorOfMem pi hpi hlam) =
      canonicalRankOneDivisorOfMem pi hpi
        (picRankOneOpen_map_mem pi (Over.overSpecMap φ).op hlam) := by
  apply canonicalRankOneDivisorOfMem_unique pi hpi
    (picRankOneOpen_map_mem pi (Over.overSpecMap φ).op hlam)
  rw [← abelDivAffPlus_mapAlgHom,
    canonicalRankOneDivisorOfMem_abel,
    ← picEtAffineEquiv_naturality]

end

end AlgebraicGeometry
