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

end AlgebraicGeometry
