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

/-- The section Čech cosimplicial object as a functor in the coefficient presheaf of modules.
Project-local: packages `sectionCechCosimplicialMap` with functoriality so the induced
short-complex maps compose and respect zero. -/
noncomputable def sectionCechCosimplicialFunctor {ι : Type u}
    (U : ι → TopologicalSpace.Opens X) : X.PresheafOfModules ⥤ CosimplicialObject Ab.{u} where
  obj F := sectionCechCosimplicial U F
  map φ := sectionCechCosimplicialMap U φ
  map_id F := by
    apply NatTrans.ext
    funext n
    apply Limits.Pi.hom_ext
    intro σ
    simp only [sectionCechCosimplicialMap, Limits.Pi.map_π, Functor.map_id, NatTrans.id_app,
      CategoryTheory.CosimplicialObject.id_app, Category.comp_id, Category.id_comp]
  map_comp φ ψ := by
    apply NatTrans.ext
    funext n
    apply Limits.Pi.hom_ext
    intro σ
    simp only [sectionCechCosimplicialMap, Functor.map_comp, NatTrans.comp_app,
      CategoryTheory.CosimplicialObject.comp_app, Limits.Pi.map_π, Limits.Pi.map_π_assoc,
      Category.assoc]

/-- The section Čech cochain complex as a functor in the coefficient presheaf of modules.
Project-local: functoriality of `sectionCechComplex`, used to form the short exact sequence of
Čech complexes. -/
noncomputable def sectionCechComplexFunctor {ι : Type u}
    (U : ι → TopologicalSpace.Opens X) : X.PresheafOfModules ⥤ CochainComplex Ab.{u} ℕ :=
  sectionCechCosimplicialFunctor U ⋙ AlgebraicTopology.alternatingCofaceMapComplex Ab.{u}

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

/-! ## Project-local Mathlib supplement — product of short exact sequences in `Ab` -/

private lemma pi_π_map_apply {J : Type u} {f g : J → Ab.{u}} (φ : ∀ j, f j ⟶ g j)
    (x : ToType (∏ᶜ f)) (σ : J) :
    Limits.Pi.π g σ (Limits.Pi.map φ x) = φ σ (Limits.Pi.π f σ x) := by
  rw [← ConcreteCategory.comp_apply, Limits.Pi.map_π, ConcreteCategory.comp_apply]

/-- **A product of short exact sequences of abelian groups is short exact.** This is the AB4*
content used in the section Čech short-exact-sequence: each Čech term is a product of section
groups over basic opens, so degreewise short-exactness of the Čech complexes reduces to this.
Project-local: Mathlib has no off-the-shelf "product of short exact sequences" lemma. -/
theorem shortExact_piMap {J : Type u} (S : J → ShortComplex Ab.{u}) (h : ∀ j, (S j).ShortExact) :
    (ShortComplex.mk (Limits.Pi.map (fun j => (S j).f)) (Limits.Pi.map (fun j => (S j).g))
      (by rw [Limits.Pi.map_comp_map]
          have hz : (fun j => (S j).f ≫ (S j).g) = (fun j => (0 : (S j).X₁ ⟶ (S j).X₃)) := by
            funext j; exact (S j).zero
          rw [hz]; ext x; simp)).ShortExact := by
  haveI : ∀ j, Mono (S j).f := fun j => (h j).mono_f
  -- Epi of the product map: surjectivity, chosen componentwise
  have hepi : Epi (Limits.Pi.map (fun j => (S j).g)) := by
    rw [AddCommGrpCat.epi_iff_surjective]
    intro y
    refine ⟨(Concrete.productEquiv (fun j => (S j).X₂)).symm
      (fun σ => ((h σ).ab_surjective_g (Limits.Pi.π (fun j => (S j).X₃) σ y)).choose), ?_⟩
    refine (Concrete.productEquiv (fun j => (S j).X₃)).injective (funext fun σ => ?_)
    rw [Concrete.productEquiv_apply_apply, Concrete.productEquiv_apply_apply,
      pi_π_map_apply, Concrete.productEquiv_symm_apply_π]
    exact ((h σ).ab_surjective_g (Limits.Pi.π (fun j => (S j).X₃) σ y)).choose_spec
  haveI := hepi
  haveI hmono : Mono (Limits.Pi.map (fun j => (S j).f)) := inferInstance
  refine ShortComplex.ShortExact.mk ?_
  rw [ShortComplex.ab_exact_iff_function_exact]
  show Function.Exact (Limits.Pi.map (fun j => (S j).f)) (Limits.Pi.map (fun j => (S j).g))
  intro x
  constructor
  · intro hx
    have hcomp : ∀ σ, (S σ).g (Limits.Pi.π (fun j => (S j).X₂) σ x) = 0 := by
      intro σ
      have := congrArg (Limits.Pi.π (fun j => (S j).X₃) σ) hx
      rwa [pi_π_map_apply, map_zero] at this
    choose w hw using fun σ => (((ShortComplex.ab_exact_iff_function_exact (S σ)).mp
      (h σ).exact (Limits.Pi.π (fun j => (S j).X₂) σ x)).mp
      (hcomp σ) : Limits.Pi.π (fun j => (S j).X₂) σ x ∈ Set.range (S σ).f)
    refine ⟨(Concrete.productEquiv (fun j => (S j).X₁)).symm w, ?_⟩
    refine (Concrete.productEquiv (fun j => (S j).X₂)).injective (funext fun σ => ?_)
    rw [Concrete.productEquiv_apply_apply, Concrete.productEquiv_apply_apply,
      pi_π_map_apply, Concrete.productEquiv_symm_apply_π]
    exact hw σ
  · rintro ⟨w, rfl⟩
    rw [← ConcreteCategory.comp_apply, Limits.Pi.map_comp_map]
    have hz : (fun j => (S j).f ≫ (S j).g) = (fun j => (0 : (S j).X₁ ⟶ (S j).X₃)) := by
      funext j; exact (S j).zero
    rw [hz, show (Limits.Pi.map fun j => (0 : (S j).X₁ ⟶ (S j).X₃)) = 0 from by ext z; simp]
    rfl

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
