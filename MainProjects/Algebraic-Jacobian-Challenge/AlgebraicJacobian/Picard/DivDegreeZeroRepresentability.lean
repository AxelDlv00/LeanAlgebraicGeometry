/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.FiniteSupportVanishing

/-!
# The degree-zero relative divisor functor

For a smooth proper geometrically integral relative curve, an effective divisor
of fibre degree zero is empty. Its degree-zero divisor functor is consequently
represented by the base scheme. This is the elementary degree-zero companion
to the positive-degree strata in Kleiman, *The Picard scheme*, Section 3,
`ex:DivC`, using his relative effective divisor definition `df:red`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace AlgebraicGeometry.Scheme.Modules

/-- A finitely presented module vanishes if its pullback to every fibre vanishes.
The support of a finitely presented module commutes with arbitrary base change. -/
theorem isZero_of_forall_isZero_fiberModule
    {X S : Scheme.{u}} (f : X ⟶ S) (F : X.Modules) [F.IsFinitePresentation]
    (hF : ∀ s : S, IsZero (f.fiberModule s F)) : IsZero F := by
  apply isZero_of_isEmpty_schematicSupport
  refine ⟨fun z => ?_⟩
  let x : X := schematicSupportι F z
  let s : S := f x
  let y : f.fiber s := (f.fiberHomeo s).symm ⟨x, rfl⟩
  have hx : x ∈ (annihilator F).support := by
    change x ∈ ((annihilator F).support : Set X)
    rw [← (annihilator F).range_subschemeι]
    exact ⟨z, rfl⟩
  have hy : y ∈ (annihilator (f.fiberModule s F)).support := by
    rw [show (annihilator (f.fiberModule s F)).support =
        (annihilator F).support.preimage (f.fiberι s).continuous from
      annihilator_pullback_support_eq_preimage (f.fiberι s) F]
    change f.fiberι s y ∈ (annihilator F).support
    simpa [y] using hx
  have hemp := isEmpty_schematicSupport_of_isZero (hF s)
  change y ∈ ((annihilator (f.fiberModule s F)).support : Set (f.fiber s)) at hy
  rw [← (annihilator (f.fiberModule s F)).range_subschemeι] at hy
  obtain ⟨w, _⟩ := hy
  exact hemp.false w

end AlgebraicGeometry.Scheme.Modules

namespace AlgebraicGeometry.Scheme

variable {S X : Scheme.{u}} {π : X ⟶ S}
  [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]

/-- A relative effective divisor of fibre degree zero on a smooth proper
geometrically integral relative curve has zero structure sheaf. No restriction
on the test scheme, such as being reduced or noetherian, is needed. -/
theorem DivFamily.isZero_of_hasFiberDeg_zero
    {T : Over S} (x : DivFamily π T) (hx : x.HasFiberDeg 0) : IsZero x.F := by
  letI : x.F.IsFinitePresentation := x.isFinitePresentation
  apply Modules.isZero_of_forall_isZero_fiberModule (pullback.snd π T.hom)
  intro t
  let f := pullback.snd π T.hom
  letI : (f.fiberModule t x.F).IsFinitePresentation :=
    Modules.pullback_isFinitePresentation (f.fiberι t) x.F x.isFinitePresentation
  exact Modules.isZero_of_finrank_globalSections_eq_zero_of_isFinite_schematicSupport
    (Field.toIsField (T.left.residueField t)) (f.fiberToSpecResidueField t)
    (f.fiberModule t x.F) (DivFamily.isFinite_schematicSupport_fiberModule_of_curve T π x t)
    (hx t)

/-- The only relative effective divisor of fibre degree zero is the empty divisor. -/
theorem DivFamily.rel_zero_of_hasFiberDeg_zero
    {T : Over S} (x : DivFamily π T) (hx : x.HasFiberDeg 0) :
    x.Rel (DivFamily.zero π T) :=
  DivFamily.rel_zero_of_isZero π T (x.isZero_of_hasFiberDeg_zero hx)

/-- The base scheme represents the degree-zero divisor functor of a smooth
proper geometrically integral relative curve. The representing bijection
sends the unique base morphism to the empty divisor. -/
noncomputable def divFunctorDegZero_representableBy_of_curve :
    (DivFunctorDeg π 0).RepresentableBy (Over.mk (𝟙 S)) :=
  divFunctorDegZero_representableByTerminal π
    (fun _ x hx => x.rel_zero_of_hasFiberDeg_zero hx)

end AlgebraicGeometry.Scheme
