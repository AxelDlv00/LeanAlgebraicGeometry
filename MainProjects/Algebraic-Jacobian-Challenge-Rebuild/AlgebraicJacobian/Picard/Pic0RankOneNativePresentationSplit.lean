/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.Pic0RankOneFamilyCertificatesActualDatum
import AlgebraicJacobian.Picard.Pic0RankOneNativeBaseChangeCartesian
import AlgebraicJacobian.Picard.Pic0RankOneNativePresentationField
import AlgebraicJacobian.Picard.Pic0VanishingAffineReduction

/-!
# Native presentations for split field classes

A split genus-degree class over a field stays split after every affine coefficient extension.
For each such extension, the lambda-tied cocycle datum supplies its own arbitrary-ring
cohomology and rank certificates.  The native all-cartesian base-change theorem then completes
the corresponding `PicRankOneNativePresentation`.

The final theorem is the direct public consumer: a split field class belongs to
`PicRankOneOpen`, because every affine pullback receives the presentation constructed here.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite MonoidalCategory
  CartesianMonoidalCategory

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

/-- The arbitrary-affine pullback of a split field class has a complete native presentation.

The datum is the representative extracted from the displayed pullback `lam`.  Its residue-field
H¹ witnesses come from `hsplit`, while its degree law comes from the equality with `lam`.
Consequently all four cohomology/rank fields and the native base-change field concern the same
cocycle datum. -/
theorem PicRankOneNativePresentation.nonempty_of_fieldPullback
    {K A : Type u} [Field K] [Algebra k K] [CommRing A] [Algebra k A]
    {pi : C.left ⟶ P1 k} [IsFinite pi]
    (hpi : pi ≫ P1.structureMap k = C.hom)
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (e : K →ₐ[k] A) (nu : picEt C (overSpec k K))
    (hlam : lam.1 = picEtMap C (Over.overSpecMap e) nu)
    (hsplit : IsSplitWitness C nu) :
    Nonempty (PicRankOneNativePresentation pi lam) := by
  obtain ⟨P⟩ := PicRankOneNativeDatum.nonempty (C := C) pi lam
  let cert : RankOneFamilyCertificates P.datum :=
    RankOneFamilyCertificates.ofActualDatum P.datum hpi
      (P.residueH1Witness_of_fieldPullback e nu hlam hsplit)
      (fun L ↦ P.classDeg_baseChange L)
  refine ⟨PicRankOneNativePresentation.ofCertificates
    P.cover P.representative P.represents P.datum P.datum_class ?_ cert⟩
  intro T' X' g f' g' sq
  exact P.datum.isIso_canonicalBaseChangeMap_nativeModule
    ((subsingleton_datumPair_h1_iff P.datum).mpr cert.h1_vanishing)
    g f' g' sq

/-- A split genus-degree class over a field belongs to the public rank-one Picard locus.

Every affine test morphism into `Spec K` is induced by a `k`-algebra map `K → A`; the
preceding producer therefore supplies the exact native presentation required on that pullback.
-/
theorem mem_picRankOneOpen_of_isSplitWitness
    (pi : C.left ⟶ P1 k) [IsFinite pi]
    (hpi : pi ≫ P1.structureMap k = C.hom)
    {K : Type u} [Field K] [Algebra k K]
    (lam : picDegLayer C (genus C : ℤ) (overSpec k K))
    (hsplit : IsSplitWitness C lam.1) :
    lam ∈ (PicRankOneOpen pi).obj (op (overSpec k K)) := by
  apply mem_picRankOneOpen_of_nativePresentations pi
  intro A _ _ t
  obtain ⟨e, rfl⟩ := exists_algHom_eq_of_overSpec_hom (k := k) K A t
  exact PicRankOneNativePresentation.nonempty_of_fieldPullback
    (C := C) hpi e lam.1 rfl hsplit

end

end AlgebraicGeometry
