/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.JacobianData

/-!
# Base change of the Jacobian representability datum (Wave 7, W7-B5/B6a/B6b)

For a field embedding `k → L`, the curve bundle `C` over `k`, and a Jacobian datum
`d : JacobianData C`, this file transports `d` across the base change `σ = Spec L → Spec k`
to a Jacobian datum on the base-changed curve `C_L = (baseChange k L).obj C`, and packages
the resulting canonical isomorphism as the datum-level input of the frozen `baseChangeIso`.

* `AlgebraicGeometry.JacobianData.baseChange` (**W7-B5**): the transported datum
  `JacobianData ((baseChange k L).obj C)` with representing object
  `(baseChange k L).obj d.J`.  Its universal datum is the verbatim mathlib
  adjunction-transport `(Over.mapPullbackAdj σ).representableBy d.J` moved by
  `RepresentableBy.ofIso` first along the whisker of `d.rep`'s Yoneda iso, then along the
  Type form of θ (`Picard/Pic0ThetaAssembly.lean`).  The two construction certificates
  transport by `MorphismProperty.baseChange_obj` (the frozen file's own pattern).

This file is the SOLE OWNER of the R-W7-4 instance-keying seams at the frozen spelling.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Opposite Limits

namespace AlgebraicGeometry

variable {k : Type u} [Field k]
variable {C : Over (Spec (.of k))}
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- **The transported Jacobian datum** (Wave-7 brick W7-B5): base change of the Jacobian
representability datum `d : JacobianData C` along a field embedding `k → L`.  The
representing object is `(baseChange k L).obj d.J`; its universal datum is the mathlib
adjunction transport `(Over.mapPullbackAdj σ).representableBy d.J` (representing
`T ↦ ((Over.map σ).obj T ⟶ d.J)`), moved by `RepresentableBy.ofIso` along the whisker of
`d.rep`'s Yoneda iso and then along θ's Type form `pic0ThetaType` to represent
`pic0TypeFunctor C_L`.  The certificates transport by base-change stability. -/
noncomputable def JacobianData.baseChange (d : JacobianData C)
    (L : Type u) [Field L] [Algebra k L] :
    JacobianData ((AlgebraicGeometry.baseChange k L).obj C) where
  J := (AlgebraicGeometry.baseChange k L).obj d.J
  rep :=
    (((Over.mapPullbackAdj (Spec.map (CommRingCat.ofHom (algebraMap k L)))).representableBy
        d.J).ofIso
      (Functor.isoWhiskerLeft
          (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).op d.rep.toIso
        ≪≫ (pic0ThetaType k L C).symm))
  locallyOfFiniteType := by
    letI := d.locallyOfFiniteType
    exact MorphismProperty.baseChange_obj (Spec.map (CommRingCat.ofHom (algebraMap k L))) d.J
      inferInstance
  quasiCompact := by
    letI := d.quasiCompact
    exact MorphismProperty.baseChange_obj (Spec.map (CommRingCat.ofHom (algebraMap k L))) d.J
      inferInstance

/-! ## A general lemma: object isos intertwining two group-valued representations -/

section GeneralLemma

universe w u₁

open CartesianMonoidalCategory MonObj

/-- **The `IsMonHom` seam** (the one small general lemma the B-6b packaging needs): if an
object isomorphism `e : X ≅ X'` intertwines the universal `homEquiv`s of two representability
data `α`, `α'` for the *same* presheaf of monoids `F`, then `e.hom` is a morphism of the
induced `MonObj.ofRepresentableBy` monoid-object structures.  Proved elementwise through the
universal bijections, never diagram-chasing in `Mon _`/`Grp _` (R3 discipline). -/
theorem isMonHom_hom_of_representableBy {D : Type u₁} [Category.{w} D]
    [CartesianMonoidalCategory D] (F : Dᵒᵖ ⥤ MonCat.{w}) {X X' : D}
    (α : (F ⋙ CategoryTheory.forget _).RepresentableBy X)
    (α' : (F ⋙ CategoryTheory.forget _).RepresentableBy X')
    (e : X ≅ X')
    (h : ∀ {T : D} (f : T ⟶ X), α'.homEquiv (f ≫ e.hom) = α.homEquiv f) :
    letI := MonObj.ofRepresentableBy X F α
    letI := MonObj.ofRepresentableBy X' F α'
    IsMonHom e.hom := by
  letI := MonObj.ofRepresentableBy X F α
  letI := MonObj.ofRepresentableBy X' F α'
  constructor
  · apply α'.homEquiv.injective
    rw [h]
    simp only [MonObj.ofRepresentableBy_one, Functor.RepresentableBy.homEquiv']
    rw [Equiv.apply_symm_apply, Equiv.apply_symm_apply]
  · have key : ∀ {T : D} (f : T ⟶ X), α'.homEquiv' (f ≫ e.hom) = α.homEquiv' f := fun f => h f
    apply α'.homEquiv'.injective
    rw [key, MonObj.ofRepresentableBy_mul, Equiv.apply_symm_apply, α'.homEquiv'_comp,
      MonObj.ofRepresentableBy_mul, Equiv.apply_symm_apply, map_mul, ← α'.homEquiv'_comp,
      ← α'.homEquiv'_comp, CartesianMonoidalCategory.tensorHom_fst,
      CartesianMonoidalCategory.tensorHom_snd, key, key]

end GeneralLemma

/-! ## B-6a: the mapGrp group structure agrees with the transported representation -/

section MonObjBridge

universe w u₁ u₂

open CartesianMonoidalCategory MonObj

/-- **The monoidal-transport ↔ adjunction-representation bridge** (the mathlib-gift-free core
of B-6a): for an adjunction `F ⊣ G` with `G` monoidal (cartesian) and a monoid object `Y`, the
monoid-object structure that `G` transports onto `G.obj Y` is exactly the one induced by the
adjunction representation `G.obj Y` represents `T ↦ (F.obj T ⟶ Y)`.  The `mul` diagram is a
`hom_ext` chase through the counit naturality and the lax-monoidal projection lemmas
`Functor.Monoidal.μ_fst`/`μ_snd`. -/
theorem monObjObj_eq_ofRepresentableBy {C₁ : Type u₁} {D₁ : Type u₂}
    [Category.{w} C₁] [Category.{w} D₁] [CartesianMonoidalCategory C₁]
    [CartesianMonoidalCategory D₁] {F : C₁ ⥤ D₁} {G : D₁ ⥤ C₁} (adj : F ⊣ G)
    [G.Monoidal] (Y : D₁) [MonObj Y] :
    Functor.monObjObj (F := G) (X := Y)
      = MonObj.ofRepresentableBy (G.obj Y) (F.op ⋙ yonedaMonObj Y) (adj.representableBy Y) := by
  refine MonObj.ext _ _ ?_
  rw [MonObj.ofRepresentableBy_mul, eq_comm, Equiv.symm_apply_eq]
  change (adj.homEquiv (MonoidalCategoryStruct.tensorObj (G.obj Y) (G.obj Y)) Y).symm
          (fst (G.obj Y) (G.obj Y))
        * (adj.homEquiv (MonoidalCategoryStruct.tensorObj (G.obj Y) (G.obj Y)) Y).symm
          (snd (G.obj Y) (G.obj Y))
      = (adj.homEquiv (MonoidalCategoryStruct.tensorObj (G.obj Y) (G.obj Y)) Y).symm
          (Functor.LaxMonoidal.μ G Y Y ≫ G.map μ[Y])
  rw [Hom.mul_def, Adjunction.homEquiv_counit, Adjunction.homEquiv_counit,
    Adjunction.homEquiv_counit, Functor.map_comp, Category.assoc, Adjunction.counit_naturality,
    ← Category.assoc (F.map (Functor.LaxMonoidal.μ G Y Y))]
  congr 1
  refine CartesianMonoidalCategory.hom_ext _ _ ?_ ?_
  · rw [CartesianMonoidalCategory.lift_fst, ← Functor.Monoidal.μ_fst, Functor.map_comp,
      Category.assoc, adj.counit_naturality, Category.assoc]
  · rw [CartesianMonoidalCategory.lift_snd, ← Functor.Monoidal.μ_snd, Functor.map_comp,
      Category.assoc, adj.counit_naturality, Category.assoc]

end MonObjBridge

end AlgebraicGeometry
