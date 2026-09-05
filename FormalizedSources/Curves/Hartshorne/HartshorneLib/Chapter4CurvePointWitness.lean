/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter1CurveStalks

/-!
# A non-generic point on a smooth curve

The relative-dimension-one chart at the generic point has a transcendental
coordinate.  If its affine section ring were a field, finite type over the
ground field would force that coordinate to be algebraic.  A nonzero prime in
the chart therefore gives a point distinct from the generic point.
-/

set_option autoImplicit false

universe u

open CategoryTheory TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k]
variable {X : Scheme.{u}}

theorem exists_ne_genericPoint_of_smoothCurve
    (f : X ⟶ Spec (CommRingCat.of k))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] :
    ∃ z : X, z ≠ genericPoint X := by
  obtain ⟨U, hU, V, hV, hxV, e, hsm⟩ :=
    SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension
      (n := 1) (f := f) (genericPoint X)
  have hUtop : U = ⊤ := by
    have hsub : Subsingleton (Spec (CommRingCat.of k)) :=
      inferInstanceAs (Subsingleton (PrimeSpectrum k))
    refine TopologicalSpace.Opens.ext (Set.eq_univ_of_forall fun y => ?_)
    exact Subsingleton.elim (f.base (genericPoint X)) y ▸ e hxV
  subst hUtop
  letI : Field Γ(Spec (CommRingCat.of k), ⊤) :=
    ((Scheme.ΓSpecIso (CommRingCat.of k)).commRingCatIsoToRingEquiv.toMulEquiv.isField
      (Field.toIsField k)).toField
  haveI : Nonempty V := ⟨⟨genericPoint X, hxV⟩⟩
  letI : (f.appLE ⊤ V e).hom.IsStandardSmoothOfRelativeDimension 1 := hsm
  algebraize [(f.appLE ⊤ V e).hom]
  letI : Algebra.IsStandardSmoothOfRelativeDimension 1
      Γ(Spec (CommRingCat.of k), ⊤) Γ(X, V) := hsm.toAlgebra
  letI : Algebra.IsStandardSmooth Γ(Spec (CommRingCat.of k), ⊤) Γ(X, V) :=
    Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth 1
  have hnf : ¬ IsField Γ(X, V) := by
    intro hfield
    letI : Field Γ(X, V) := hfield.toField
    letI : Module.Finite Γ(Spec (CommRingCat.of k), ⊤) Γ(X, V) :=
      finite_of_finite_type_of_isJacobsonRing
        Γ(Spec (CommRingCat.of k), ⊤) Γ(X, V)
    obtain ⟨t, ht⟩ :=
      Algebra.IsStandardSmoothOfRelativeDimension.exists_transcendental
        Γ(Spec (CommRingCat.of k), ⊤) Γ(X, V)
    exact ht (Algebra.IsAlgebraic.isAlgebraic t)
  obtain ⟨p, hp0, hp⟩ := Ring.not_isField_iff_exists_prime.mp hnf
  let q : PrimeSpectrum Γ(X, V) := ⟨p, hp⟩
  refine ⟨hV.fromSpec.base q, ?_⟩
  intro hq
  apply hp0
  have hqgen : q = genericPoint (Spec Γ(X, V)) := by
    apply hV.fromSpec.isOpenEmbedding.injective
    rw [genericPoint_eq_of_isOpenImmersion hV.fromSpec]
    exact hq
  have hqbot : p = (⊥ : Ideal Γ(X, V)) := by
    have := congrArg PrimeSpectrum.asIdeal hqgen
    simpa [q, genericPoint_eq_bot_of_affine] using this
  exact hqbot

/-- The non-generic-point subtype used by the Chapter IV chart construction is
nonempty under the same smooth integral curve hypotheses. -/
theorem nonempty_nonGenericPoint_of_smoothCurve
    {X : Over (Spec (CommRingCat.of k))}
    [SmoothOfRelativeDimension 1 X.hom] [IsIntegral X.left] :
    Nonempty {x : X.left // x ≠ genericPoint X.left} := by
  obtain ⟨z, hz⟩ := exists_ne_genericPoint_of_smoothCurve X.hom
  exact ⟨⟨z, hz⟩⟩

end
end Hartshorne
