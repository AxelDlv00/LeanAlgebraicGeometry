/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.QuasiProjectiveFiniteInAffine
import AlgebraicJacobian.Picard.SectionGradedRing

/-!
# Demand ledger for projective-morphism infrastructure

This file records the projective infrastructure demanded by the Picard
representability seam.  It is a ledger, not a second projectivity API.

## The seam-facing demand

`Scheme.PointedPicSharpRep` asks for a representing scheme that is locally of
finite type and satisfies `Scheme.FiniteInAffine`.  It does not ask for a line
bundle.  The existing project-local route supplies those two side conditions
from a coproduct of H-quasi-projective pieces:

* `Scheme.Hom.IsHQuasiProjective` is the universe-polymorphic embedding
  predicate from `Picard/ProjectiveMorphismBasic.lean`;
* `Scheme.locallyOfFiniteType_sigma` and
  `Scheme.finiteInAffine_over_sigma_of_isHQuasiProjective` aggregate the two
  side conditions in `Picard/QuasiProjectiveFiniteInAffine.lean`;
* at `Scheme.{0}`, `Scheme.Hom.IsHQuasiProjective.exists_isHQuasiProjectiveWith`
  adds a carried pullback of `O(1)`.  Thus the existing
  `IsHQuasiProjectiveWith` is already the required very-ample output; defining
  an alias named `IsVeryAmple` would only re-spell it.

The one missing terminal producer is therefore
`pointedPicSharpQuasiProjectivePieces_demand`: it constructs the representing
coproduct and proves H-quasi-projectivity piecewise.  The two proved adapters
below show, without a `RepresentableBy` argument in either signature, that this
producer closes `PointedPicSharpRep` and then the exact statement of
`Scheme.fgaPicardRepresentability`.

## Conditional section-Proj route

Mathlib's `AlgebraicGeometry.Proj` is the Proj of an `N`-graded commutative
ring, with `Proj.toSpecZero`, `Proj.map`, and `Proj.fromOfGlobalSections`.  It is
not a relative Proj of a sheaf of graded algebras.  The project already builds
the section components `Scheme.Modules.sectionDeg L`, their tensor-power
multiplication, and a `DirectSum.GCommSemiring`.  The first missing statements
needed even to instantiate Mathlib's `Proj` on that section ring are the two
open declarations in the final section: a graded commutative ring structure and
the canonical internal grading by the direct-sum summands.

Those declarations are conditional infrastructure: the seam-facing producer
above does not mention a section ring, relative Proj, or ampleness.  A general
relative-Proj gluing theory or a general ample predicate must not be built until
a Picard-piece construction exposes a narrower consumer.  The whole Picard
scheme must also not be strengthened to `IsProjective`: its degree-graded
coproduct is not quasi-compact, as recorded by
`Picard/AmbientPicNotProper.lean` and `Scheme.PointedPicSharpRepProjective`.

## Existing inputs

Curve projectivity is already produced by
`Adelic.isProjective_of_smoothProperGeometricallyIntegral`.  The carried
`O(1)`, base-change and open-image transport, `FiniteInAffine` transport, and
Over-coproduct assembly remain owned by the established Picard modules and are
imported here read-only.
-/

open CategoryTheory Limits

noncomputable section

universe u

namespace AlgebraicGeometry
namespace Scheme

/-- The exact projective presentation that the pointed Picard reduction can
consume at every universe: `picSharp` is represented by a coproduct of
H-quasi-projective schemes over the ground field.

The integer index records the intended degree pieces without introducing a
second, currently nonexistent `picSharpDeg` functor.  This closed proposition
contains the representation witness in its conclusion; no downstream theorem
takes an explicit representation-witness argument. -/
def PointedPicSharpQuasiProjectivePieces : Prop :=
  ∀ {K : Type u} [Field K] (E : Over (Spec (CommRingCat.of K))),
    ∀ [SmoothOfRelativeDimension 1 E.hom] [IsProper E.hom]
      [GeometricallyIntegral E.hom],
      HasRationalPoint E →
        ∃ X : ℤ → Over (Spec (CommRingCat.of K)),
          Nonempty ((PicScheme.picSharp E).RepresentableBy (∐ X)) ∧
            ∀ d, (X d).hom.IsHQuasiProjective

/-- A piecewise H-quasi-projective representation supplies exactly the local
finite type and `FiniteInAffine` conjuncts of `PointedPicSharpRep`.

This is the seam-side consumption check for the ledger. -/
theorem pointedPicSharpRep_of_quasiProjectivePieces
    (H : PointedPicSharpQuasiProjectivePieces.{u}) :
    PointedPicSharpRep.{u} := by
  intro K _ E _ _ _ hpt
  obtain ⟨X, hrep, hX⟩ := H E hpt
  refine ⟨∐ X, hrep, ?_, ?_⟩
  · exact locallyOfFiniteType_sigma X fun d => (hX d).locallyOfFiniteType
  · exact finiteInAffine_over_sigma_of_isHQuasiProjective X hX

/-- The ledger producer implies the central seam verbatim, with no rational
point binder on the target theorem. -/
theorem fgaPicardRepresentability_of_quasiProjectivePieces
    {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom]
    (H : PointedPicSharpQuasiProjectivePieces.{u}) :
    (∃ X : Over (Spec (CommRingCat.of k)),
        Nonempty ((PicScheme.picEt C).RepresentableBy X) ∧
          LocallyOfFiniteType X.hom ∧ IsSeparated X.hom) ∧
      (HasRationalPoint C → IsIso (PicScheme.picEtComparison C)) :=
  fgaPicardRepresentability_of_pointedPicSharpRep C
    (pointedPicSharpRep_of_quasiProjectivePieces H)

/-- **Open terminal demand.** Construct the pointed Picard representer as a
coproduct of H-quasi-projective pieces.  This is the only sorry in the
seam-facing part of the demand ledger. -/
theorem pointedPicSharpQuasiProjectivePieces_demand :
    PointedPicSharpQuasiProjectivePieces.{u} := by
  sorry

end Scheme

namespace Scheme.Modules

variable {X : Scheme.{u}}

/-- **Conditional section-Proj demand 1.** Upgrade the already-built graded
commutative semiring on the section components of an invertible sheaf to the
graded commutative ring required by Mathlib's `Proj`. -/
theorem sectionGradedRing_gcommRing_demand (L : X.Modules) [IsInvertibleGr L] :
    Nonempty (DirectSum.GCommRing (sectionDeg L)) := by
  sorry

/-- **Conditional section-Proj demand 2.** The canonical summands of the
section-ring direct sum form an internal `N`-grading.  Together with
`sectionGradedRing_gcommRing_demand`, this is the data needed for the term
`AlgebraicGeometry.Proj` to elaborate on the section ring. -/
theorem sectionGradedRing_gradedRing_demand (L : X.Modules) [IsInvertibleGr L]
    (hR : DirectSum.GCommRing (sectionDeg L)) :
    letI := hR
    Nonempty (GradedRing (fun n => AddMonoidHom.range
      (DirectSum.of (fun m => sectionDeg L m) n))) := by
  sorry

end Scheme.Modules
end AlgebraicGeometry
