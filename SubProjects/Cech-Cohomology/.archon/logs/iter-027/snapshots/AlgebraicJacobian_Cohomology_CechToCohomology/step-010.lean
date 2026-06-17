/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.CechBridge
import AlgebraicJacobian.Cohomology.AbsoluteCohomology

/-!
# Čech-to-cohomology comparison on a basis (Stacks 01EO) — L1/L2 chain

Project-local: builds the section-Čech short-exact-sequence (L1) and the
quotient-vanishing step (L2) of the 01EO dimension-shift argument.
-/

universe u

open CategoryTheory Limits CategoryTheory.Abelian

namespace AlgebraicGeometry

variable {X : Scheme.{u}}

/-! ## Project-local Mathlib supplement — functoriality of the section Čech complex -/

/-- The cosimplicial morphism of section Čech objects induced by a morphism `φ` of
presheaves of modules, acting coordinatewise by the underlying presheaf morphism on each
basic-open section group. Project-local: `sectionCechCosimplicial` has no functoriality in
Mathlib. -/
noncomputable def sectionCechCosimplicialMap {ι : Type u} (U : ι → TopologicalSpace.Opens X)
    {F G : X.PresheafOfModules} (φ : F ⟶ G) :
    sectionCechCosimplicial U F ⟶ sectionCechCosimplicial U G where
  app n := Limits.Pi.map (fun σ : Fin (n.len + 1) → ι =>
    ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map φ).app (Opposite.op (⨅ k, U (σ k))))
  naturality {m n} f := by
    apply Limits.Pi.hom_ext
    intro σ
    simp only [sectionCechCosimplicial, Category.assoc, Limits.Pi.map_π, Limits.Pi.lift_π,
      Limits.Pi.map_π_assoc, Limits.Pi.lift_π_assoc]
    congr 1
    exact ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map φ).naturality _

/-- The chain map of section Čech complexes induced by a morphism `φ` of presheaves of
modules. Project-local: functoriality of `sectionCechComplex` in the coefficient presheaf. -/
noncomputable def sectionCechComplexMap {ι : Type u} (U : ι → TopologicalSpace.Opens X)
    {F G : X.PresheafOfModules} (φ : F ⟶ G) :
    sectionCechComplex U F ⟶ sectionCechComplex U G :=
  (AlgebraicTopology.alternatingCofaceMapComplex Ab.{u}).map (sectionCechCosimplicialMap U φ)

/-- **{\v C}ech cohomology accessor** `Ȟ^p(𝒰, F)`: the degree-`p` homology of the section
Čech complex, packaged as a named `Ab`-object. Project-local thin wrapper so the 01EO chain
can refer to `Ȟ^p` uniformly. -/
noncomputable def cechCohomology {ι : Type u} (U : ι → TopologicalSpace.Opens X)
    (F : X.PresheafOfModules) (p : ℕ) : Ab.{u} :=
  (sectionCechComplex U F).homology p

/-! ## Project-local Mathlib supplement — L2 homological core (quotient vanishing) -/

/-- **Quotient preserves vanishing higher cohomology (homological core, Stacks 01EO L2).**
Given a short exact sequence of cochain complexes `0 → X₁ → X₂ → X₃ → 0` in which the middle
term `X₂` has vanishing positive homology (the injective/acyclic term) and the left term `X₁`
has vanishing positive homology (condition (3)), the right term `X₃` (the quotient) again has
vanishing positive homology. Proved by the homology long exact sequence: the connecting map
gives `Hᵖ(X₃) ≅ Hᵖ⁺¹(X₁) = 0`. Project-local: the 01EO dimension-shift needs this abstract
shape; it is then instantiated at the section Čech complexes. -/
theorem cechHomology_quotient_vanishing (T : ShortComplex (CochainComplex Ab.{u} ℕ))
    (hT : T.ShortExact) (hI : ∀ p, 0 < p → IsZero (T.X₂.homology p))
    (hF : ∀ p, 0 < p → IsZero (T.X₁.homology p)) :
    ∀ p, 0 < p → IsZero (T.X₃.homology p) := by
  intro p hp
  have hrel : (ComplexShape.up ℕ).Rel p (p + 1) := rfl
  have hiso : T.X₃.homology p ≅ T.X₁.homology (p + 1) :=
    hT.δIso p (p + 1) hrel (hI p hp) (hI (p + 1) (Nat.succ_pos p))
  exact (hF (p + 1) (Nat.succ_pos p)).of_iso hiso

end AlgebraicGeometry
