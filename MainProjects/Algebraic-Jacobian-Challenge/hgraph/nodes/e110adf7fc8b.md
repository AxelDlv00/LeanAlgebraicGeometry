---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.injective_cech_acyclic
docstring: '**Injective sheaves are {\v C}ech-acyclic** (blueprint `lem:injective_cech_acyclic`,

  Stacks `lemma-injective-trivial-cech`).


  For an injective `O_X`-module `I` and any finite open cover `𝒰` of (an open of)
  `X`, the

  section {\v C}ech cohomology of `I` vanishes in every positive degree `p > 0`:

  `Ȟᵖ(𝒰, I) = 0`.  Concretely the degree-`p` homology of the section {\v C}ech complex
  of the

  underlying presheaf of modules `Scheme.Modules.toPresheafOfModules X |>.obj I` is
  a zero

  object.


  The proof is the one-step op-transport assembly: the free {\v C}ech resolution

  `cechFreeComplexAug 𝒰` is a quasi-isomorphism (`cechFreeComplex_quasiIso`); since
  `I` is

  injective as a presheaf of modules (`injective_toPresheafOfModules`), applying

  `preadditiveYoneda.obj I` to its opposite preserves the quasi-isomorphism

  (`quasiIso_map_preadditiveYoneda_of_injective`); transporting across

  `sectionCechComplexMapOpIso` identifies the section {\v C}ech complex with the mapped

  opposite of a degree-`0`-concentrated complex, whose positive-degree homology vanishes.


  Project-local: Mathlib has no {\v C}ech complex of sections of a presheaf of modules.'
file: AlgebraicJacobian/Cohomology/CechBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.injective_cech_acyclic
type: lean
updated: '2026-07-24T03:02:09'
---
theorem injective_cech_acyclic (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (I : X.Modules) [Injective I]
    (p : ℕ) (hp : 0 < p) :
    IsZero ((sectionCechComplex (coverOpen 𝒰)
      ((Scheme.Modules.toPresheafOfModules X).obj I)).homology p) := by
  haveI : QuasiIso (cechFreeComplexAug 𝒰) := cechFreeComplex_quasiIso 𝒰
  haveI : Injective ((Scheme.Modules.toPresheafOfModules X).obj I) :=
    injective_toPresheafOfModules I
  set F := (Scheme.Modules.toPresheafOfModules X).obj I with hF
  -- map the opposite of the augmentation through `Hom(-, I)`; quasi-iso preserved (Part 1)
  set ψ := ((preadditiveYoneda.obj F).mapHomologicalComplex (ComplexShape.down ℕ).symm).map
      ((HomologicalComplex.opFunctor X.PresheafOfModules (ComplexShape.down ℕ)).map
        (cechFreeComplexAug 𝒰).op) with hψdef
  haveI : QuasiIso ψ := quasiIso_map_preadditiveYoneda_of_injective F _
  -- transport the target onto the section Čech complex of `I`
  set Θ := ψ ≫ (sectionCechComplexMapOpIso 𝒰 F).hom with hΘdef
  haveI : QuasiIso Θ := inferInstance
  haveI : QuasiIsoAt Θ p := QuasiIso.quasiIsoAt p
  obtain ⟨n, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hp.ne'
  -- the source complex is `Hom(-, I)` of a degree-`0`-concentrated complex: zero in degree `> 0`
  have hX : IsZero ((((preadditiveYoneda.obj F).mapHomologicalComplex
      (ComplexShape.down ℕ).symm).obj ((HomologicalComplex.opFunctor X.PresheafOfModules
        (ComplexShape.down ℕ)).obj (Opposite.op
          ((ChainComplex.single₀ X.PresheafOfModules).obj (coverStructurePresheaf 𝒰))))).X
        (n + 1)) := by
    rw [Functor.mapHomologicalComplex_obj_X]
    apply Functor.map_isZero
    simp only [HomologicalComplex.opFunctor_obj, HomologicalComplex.op_X]
    exact (HomologicalComplex.isZero_single_obj_X (ComplexShape.down ℕ) 0
      (coverStructurePresheaf 𝒰) (n + 1) (Nat.succ_ne_zero n)).op
  have hsrcZero : IsZero ((((preadditiveYoneda.obj F).mapHomologicalComplex
      (ComplexShape.down ℕ).symm).obj ((HomologicalComplex.opFunctor X.PresheafOfModules
        (ComplexShape.down ℕ)).obj (Opposite.op
          ((ChainComplex.single₀ X.PresheafOfModules).obj
            (coverStructurePresheaf 𝒰))))).homology (n + 1)) := by
    rw [← HomologicalComplex.exactAt_iff_isZero_homology, HomologicalComplex.exactAt_iff]
    exact ShortComplex.exact_of_isZero_X₂ _ hX
  -- transfer vanishing across the quasi-isomorphism `Θ`
  exact hsrcZero.of_iso (asIso (HomologicalComplex.homologyMap Θ (n + 1))).symm

/-! ## Project-local Mathlib supplement — family-parameterized Čech bridge

The entire Čech bridge chain above is re-parameterized here from an `X.OpenCover` `𝒰`
(via `coverOpen 𝒰`, `coverInterOpen 𝒰`, `cechFreeSimplicial 𝒰`, …) to a **raw finite
family** `{ι : Type u} [Finite ι] (U : ι → Opens ↥X)` with **no covering hypothesis**,
consuming Lane-A's `…Fam` chain in `FreePresheafComplex.lean`
(`cechFreeSimplicialFam`, `cechFreePresheafComplexFam`, `cechFreeComplexAugFam`,
`coverStructurePresheafFam`, `coverInterOpenFam`, `cechFreeComplex_quasiIsoFam`).
The substitution is the mechanical mirror Lane A applied on the free side:
`𝒰.I₀ ↦ ι`, `coverOpen 𝒰 ↦ U`, `coverInterOpen 𝒰 ↦ coverInterOpenFam U`,
`cechFree… 𝒰 ↦ cechFree…Fam U`.  The open-indexed building blocks
(`freeYoneda`, `freeYonedaHomAddEquiv`, `opCoproductIsoProduct`, `piComparison`,
`opFunctor`) and the generic helpers `pi_mapIso_hom_eq` /
`freeYonedaHomAddEquiv_naturality` are reused unchanged.  The `X.OpenCover`-named
declarations above are kept byte-identical (so downstream consumers stay green).

Delivers the cover-agnostic `sectionCechComplexMapOpIsoFam` and
`injective_cech_acyclicFam`; the latter discharges `BasisCovSystem.injective_acyclic`
over covers of *any* open (e.g. a basic open `D(f)`) directly, without a
restriction-of-injectives detour.

Project-local: same content as the `X.OpenCover` bridge, but cover-agnostic. -/

section FamilyParameterizedBridge

set_option linter.unusedSectionVars false

variable {ι : Type u} [Finite ι] (U : ι → TopologicalSpace.Opens ↥X)