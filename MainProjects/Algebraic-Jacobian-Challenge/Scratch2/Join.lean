import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence
import AlgebraicJacobian.Picard.EtaleFieldCover
import AlgebraicJacobian.Curve.GaloisLevelRationalPoint

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

theorem isSheafFor_singleton {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']
    [Algebra.IsSeparable k k'] [Module.Finite k k']
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k))) :
    Presieve.IsSheafFor (picEt C)
      (Presieve.singleton (coverMap (k := k) (k' := k') T)) := by
  rw [Presieve.isSheafFor_iff_generate, generate_singleton_coverMap_eq]
  exact AlgebraicGeometry.Scheme.isSheafFor_picEt_pullback_presieve k' C T

/-- THE JOIN: at the level p3's producer manufactures, my cover exists and the
sheaf axiom holds there. Answers p3's caveat (a) affirmatively. -/
example {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    (T : Over (Spec (CommRingCat.of k))) :
    ∃ (k'' : Type u) (_ : Field k'') (_ : Algebra k k''),
      Scheme.HasRationalPoint (Scheme.baseChangeField C k'') ∧
      Presieve.IsSheafFor (picEt C)
        (Presieve.singleton (coverMap (k := k) (k' := k'') T)) := by
  obtain ⟨k'', hfd, hgal, hpt⟩ :=
    AlgebraicGeometry.Scheme.exists_finiteGalois_level_hasRationalPoint_of_geometricallyIntegral C
  letI := hfd
  letI := hgal
  refine ⟨k'', inferInstance, inferInstance, hpt, ?_⟩
  exact isSheafFor_singleton k'' C T

end Probe
