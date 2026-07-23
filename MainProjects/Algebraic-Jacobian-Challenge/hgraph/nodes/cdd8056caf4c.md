---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.injective_cech_acyclicFam
docstring: '**Injective sheaves are Čech-acyclic** (family form of `injective_cech_acyclic`,

  blueprint `lem:injective_cech_acyclic`, Stacks `lemma-injective-trivial-cech`).


  For an injective `O_X`-module `I` and any finite family `U : ι → Opens ↥X` (no covering

  hypothesis), the section Čech cohomology of `I` vanishes in every positive degree
  `p > 0`:

  `Ȟᵖ(U, I) = 0`.  This is the cover-agnostic mirror of `injective_cech_acyclic`,
  consuming

  Lane-A''s `cechFreeComplex_quasiIsoFam`; it discharges `BasisCovSystem.injective_acyclic`

  over covers of any open directly.


  Project-local: Mathlib has no Čech complex of sections of a presheaf of modules.'
file: AlgebraicJacobian/Cohomology/CechBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.injective_cech_acyclicFam
type: lean
updated: '2026-07-24T03:02:09'
---
theorem injective_cech_acyclicFam (I : X.Modules) [Injective I] (p : ℕ) (hp : 0 < p) :
    IsZero ((sectionCechComplex U
      ((Scheme.Modules.toPresheafOfModules X).obj I)).homology p) := by
  haveI : QuasiIso (cechFreeComplexAugFam U) := cechFreeComplex_quasiIsoFam U
  haveI : Injective ((Scheme.Modules.toPresheafOfModules X).obj I) :=
    injective_toPresheafOfModules I
  set F := (Scheme.Modules.toPresheafOfModules X).obj I with hF
  -- map the opposite of the augmentation through `Hom(-, I)`; quasi-iso preserved (Part 1)
  set ψ := ((preadditiveYoneda.obj F).mapHomologicalComplex (ComplexShape.down ℕ).symm).map
      ((HomologicalComplex.opFunctor X.PresheafOfModules (ComplexShape.down ℕ)).map
        (cechFreeComplexAugFam U).op) with hψdef
  haveI : QuasiIso ψ := quasiIso_map_preadditiveYoneda_of_injective F _
  -- transport the target onto the section Čech complex of `I`
  set Θ := ψ ≫ (sectionCechComplexMapOpIsoFam U F).hom with hΘdef
  haveI : QuasiIso Θ := inferInstance
  haveI : QuasiIsoAt Θ p := QuasiIso.quasiIsoAt p
  obtain ⟨n, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hp.ne'
  -- the source complex is `Hom(-, I)` of a degree-`0`-concentrated complex: zero in degree `> 0`
  have hX : IsZero ((((preadditiveYoneda.obj F).mapHomologicalComplex
      (ComplexShape.down ℕ).symm).obj ((HomologicalComplex.opFunctor X.PresheafOfModules
        (ComplexShape.down ℕ)).obj (Opposite.op
          ((ChainComplex.single₀ X.PresheafOfModules).obj (coverStructurePresheafFam U))))).X
        (n + 1)) := by
    rw [Functor.mapHomologicalComplex_obj_X]
    apply Functor.map_isZero
    simp only [HomologicalComplex.opFunctor_obj, HomologicalComplex.op_X]
    exact (HomologicalComplex.isZero_single_obj_X (ComplexShape.down ℕ) 0
      (coverStructurePresheafFam U) (n + 1) (Nat.succ_ne_zero n)).op
  have hsrcZero : IsZero ((((preadditiveYoneda.obj F).mapHomologicalComplex
      (ComplexShape.down ℕ).symm).obj ((HomologicalComplex.opFunctor X.PresheafOfModules
        (ComplexShape.down ℕ)).obj (Opposite.op
          ((ChainComplex.single₀ X.PresheafOfModules).obj
            (coverStructurePresheafFam U))))).homology (n + 1)) := by
    rw [← HomologicalComplex.exactAt_iff_isZero_homology, HomologicalComplex.exactAt_iff]
    exact ShortComplex.exact_of_isZero_X₂ _ hX
  -- transfer vanishing across the quasi-isomorphism `Θ`
  exact hsrcZero.of_iso (asIso (HomologicalComplex.homologyMap Θ (n + 1))).symm