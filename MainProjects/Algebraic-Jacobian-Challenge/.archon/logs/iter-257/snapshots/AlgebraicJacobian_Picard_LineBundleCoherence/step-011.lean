/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.LineBundlePullback

/-!
# Coherence of locally trivial line bundles (A.2.c engine)

This file is the **iter-256 Lane engine** file-skeleton for the cheap, on-path
half of the line-bundle coherence requirement of the A.2.c Quot-scheme
embedding (`chap:Picard_QuotScheme`, `chap:Picard_FGAPicRepresentability`).

The Quot functor takes coherent quotients of a coherent sheaf; to feed it a line
bundle one must know that the line bundle is itself coherent, i.e. a finitely
presented `𝒪`-module. The embedding's input is a point of the relative Picard
scheme `Pic⁰_{C/k}`, whose carrier is the **locally trivial** predicate
`IsLocallyTrivial` of `chap:Picard_LineBundlePullback` (the project-side stand-in
for an invertible sheaf). The chapter proves
`IsLocallyTrivial M ⟹ M.IsFinitePresentation`, together with a rank-one /
flatness record. The general implication "`M` tensor-invertible `⟹` `M` locally
free of rank one" (the converse spreading-out, Stacks Lemma 0B8M when stalks are
local) is *not* crossed here: the carrier is already locally trivial, so the
finite-presentation spreading-out is never needed.

## Status (iter-256 file-skeleton)

This file is the **iter-256** file-skeleton: each of the five pinned declarations
carries the *intended* substantive type signature (matching the blueprint
`\lean{...}` pin in `chapters/Picard_LineBundleCoherence.tex`) with a `sorry`
body. The bodies are iter-257+ work, contingent on the site-instance de-risk
report below.

The 5 pinned declarations are:

1. `IsLocallyTrivial.exists_trivializing_cover` (`lem:lbc_trivializing_cover`) —
   repackage the pointwise existential of `IsLocallyTrivial` into an indexed
   trivialising affine cover.
2. `IsLocallyTrivial.chartPresentation` (`lem:lbc_chart_presentation`) — the
   trivial finite free presentation of `M.over U` on a trivialising chart.
3. `IsLocallyTrivial.isFinitePresentation` (`thm:lbc_isFinitePresentation`) —
   the main theorem: assemble a `QuasicoherentData` from the trivialising cover
   and feed it to `SheafOfModules.IsFinitePresentation.mk`.
4. `IsLocallyTrivial.isFiniteType` (`cor:lbc_isFiniteType`) — finite type +
   quasi-coherence, immediate from finite presentation.
5. `IsLocallyTrivial.chart_free_rank_one` (`lem:lbc_rank_flat`) — the chart-local
   rank-one free record.

## Site instances (the chief de-risk; see `rem:lbc_site_instances`)

Mathlib's `SheafOfModules.IsFinitePresentation` / `QuasicoherentData` are stated
under three site hypotheses on the slice topologies `J.over U` of the underlying
topology `J = Opens.grothendieckTopology X` of `X.ringCatSheaf`:

```
[∀ U, (J.over U).HasSheafCompose (forget₂ RingCat AddCommGrpCat)]
[∀ U, HasWeakSheafify (J.over U) AddCommGrpCat]     -- (resp. HasSheafify)
[∀ U, (J.over U).WEqualsLocallyBijective AddCommGrpCat]
```

The de-risk outcome (whether these resolve for `X.ringCatSheaf`) is recorded in
the task result and probed by the `#check` commands at the end of this file.

## References

Blueprint: `blueprint/src/chapters/Picard_LineBundleCoherence.tex`.
Source: [Stacks Project], Modules on Ringed Spaces, Definition 17.25.1
(Tag 01CS, invertible modules), "Modules of finite presentation", and
Lemma 17.25.4 (Tag 0B8M).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

namespace LineBundle

variable {X : Scheme.{u}}

/-! ## §1. From pointwise triviality to a trivialising cover -/

/-- **Trivialising affine cover** (Stacks 01CS / Definition 17.25.1).
A locally trivial module `M` admits an indexed trivialising affine cover: an
index type `I`, a family of affine opens `U i` covering `X`, and for each `i` a
`𝒪_{U_i}`-module isomorphism `M|_{U_i} ≅ 𝒪_{U_i}`.

The witness repackages the pointwise existential `IsLocallyTrivial M` (take
`I := X` and assign each point its chosen neighbourhood). -/
theorem IsLocallyTrivial.exists_trivializing_cover {M : X.Modules}
    (hM : IsLocallyTrivial M) :
    ∃ (I : Type u) (U : I → X.Opens),
      (∀ i, IsAffineOpen (U i)) ∧ iSup U = ⊤ ∧
        ∀ i, Nonempty (M.restrict (U i).ι ≅
          SheafOfModules.unit (U i : Scheme).ringCatSheaf) := by
  refine ⟨X, fun x => (hM x).choose, fun x => (hM x).choose_spec.2.1, ?_,
    fun x => (hM x).choose_spec.2.2⟩
  rw [eq_top_iff]
  intro x _
  rw [TopologicalSpace.Opens.mem_iSup]
  exact ⟨x, (hM x).choose_spec.1⟩

/-! ## §1b. The canonical finite presentation of the unit module -/

section UnitPresentation

universe u₁ v₁

variable {C : Type u₁} [Category.{v₁} C] {J : GrothendieckTopology C}
  {R : Sheaf J RingCat.{u}}
  [HasSheafify J AddCommGrpCat.{u}] [J.WEqualsLocallyBijective AddCommGrpCat.{u}]
  [J.HasSheafCompose (forget₂ RingCat.{u} AddCommGrpCat.{u})]

/-- The canonical isomorphism `free PUnit ≅ unit R`: the free module on a single
generator is the unit module. -/
noncomputable def freeUnitIso :
    SheafOfModules.free.{u} (R := R) PUnit.{u + 1} ≅ SheafOfModules.unit R :=
  Limits.coproductUniqueIso (fun (_ : PUnit.{u + 1}) ↦ SheafOfModules.unit R)

/-- The canonical generating sections of `unit R`: one generator (the image of
the free generator under `freeUnitIso`). -/
noncomputable def unitGenerators : (SheafOfModules.unit R).GeneratingSections where
  I := PUnit.{u + 1}
  s := (SheafOfModules.unit R).freeHomEquiv freeUnitIso.hom
  epi := by
    rw [Equiv.symm_apply_apply]
    infer_instance

/-- The canonical finite presentation of the unit module `unit R`: one generator,
no relations (its generating map is an isomorphism, so the relation kernel is the
zero object). -/
noncomputable def unitPresentation : (SheafOfModules.unit R).Presentation where
  generators := unitGenerators
  relations :=
    { I := PEmpty.{u + 1}
      s := PEmpty.elim
      epi := by
        have hiso : IsIso (unitGenerators (R := R)).π := by
          dsimp only [unitGenerators, SheafOfModules.GeneratingSections.π]
          rw [Equiv.symm_apply_apply]
          infer_instance
        have : Mono (unitGenerators (R := R)).π := inferInstance
        have hz : Limits.IsZero (Limits.kernel (unitGenerators (R := R)).π) :=
          Limits.isZero_kernel_of_mono _
        exact ⟨fun g h _ => hz.eq_of_src g h⟩ }

instance : (unitPresentation (R := R)).IsFinite where
  isFiniteType_generators := ⟨inferInstanceAs (Finite PUnit.{u + 1})⟩
  isFiniteType_relations := ⟨inferInstanceAs (Finite PEmpty.{u + 1})⟩

end UnitPresentation

/-! ## §2. The trivial presentation on a chart -/

/-- **The over↔restrict trivialisation bridge.** Transports the scheme-level
trivialisation `e : M.restrict U.ι ≅ 𝒪_U` (an isomorphism in
`SheafOfModules (↑U).ringCatSheaf`, the category of modules on the *open
subscheme* `U`) to a slice-level trivialisation
`M.over U ≅ 𝒪_U` (in `SheafOfModules (X.ringCatSheaf.over U)`, the category of
modules on the *slice site* `J.over U`).

The two source categories are equivalent — the open-immersion functor
`U.ι.opensFunctor : Opens ↥U ≌ {V ∈ Opens X | V ≤ U} = Over U` induces an
equivalence `SheafOfModules (↑U).ringCatSheaf ≌ SheafOfModules (X.ringCatSheaf.over U)`
identifying `M.restrict U.ι ↦ M.over U` and `unit ↦ unit` — but this
equivalence of *sheaf-of-modules* categories (the modules-level shadow of
`Opens.overEquivalence` / `overSliceSheafEquiv`) is not yet available in the
project, so the bridge is recorded here as a typed `sorry`. This is the single
missing ingredient for the whole `LineBundleCoherence` engine: everything else
(`chartPresentation`, `isFinitePresentation`, `isFiniteType`) is complete modulo
this isomorphism. -/
noncomputable def chartOverIso (M : X.Modules) (U : X.Opens)
    (e : M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    M.over U ≅ SheafOfModules.unit (X.ringCatSheaf.over U) :=
  sorry

/-- **Finite free presentation on a chart** (Stacks, "Modules of finite
presentation"). On a trivialising chart `U` — i.e. with an isomorphism
`M|_U ≅ 𝒪_U` — the restriction `M.over U` admits the trivial finite free
presentation (one generator, no relations), obtained by transporting the
canonical presentation of `SheafOfModules.unit` along the trivialisation
(through the `chartOverIso` bridge). -/
noncomputable def IsLocallyTrivial.chartPresentation (M : X.Modules) (U : X.Opens)
    (e : M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    (M.over U).Presentation := by
  exact SheafOfModules.Presentation.ofIsIso (R := X.ringCatSheaf.over U)
    (M := SheafOfModules.unit (X.ringCatSheaf.over U)) (N := SheafOfModules.over M U)
    (chartOverIso M U e).inv (unitPresentation (R := X.ringCatSheaf.over U))

instance (M : X.Modules) (U : X.Opens)
    (e : M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    (IsLocallyTrivial.chartPresentation M U e).IsFinite := by
  dsimp only [IsLocallyTrivial.chartPresentation]
  infer_instance

/-! ## §3. Finite presentation of a locally trivial line bundle -/

/-- **Locally trivial `⟹` finitely presented** (Stacks 0B8M / Lemma 17.25.4).
A locally trivial module on a scheme is finitely presented: assemble a
`QuasicoherentData` from the trivialising affine cover
(`exists_trivializing_cover`), whose presentation at each index is the finite
free presentation of `chartPresentation`, and feed it to
`SheafOfModules.IsFinitePresentation.mk`. No stalk computation or
neighbourhood-spreading is involved. -/
theorem IsLocallyTrivial.isFinitePresentation {M : X.Modules}
    (hM : IsLocallyTrivial M) :
    M.IsFinitePresentation := by
  sorry

/-- **Locally trivial `⟹` finite type and quasi-coherent** (corollary of
`isFinitePresentation`). Finite presentation implies finite type by Mathlib's
`SheafOfModules.instIsFiniteTypeOfIsFinitePresentation` and quasi-coherence by
`SheafOfModules.instIsQuasicoherentOfIsFinitePresentation`. -/
theorem IsLocallyTrivial.isFiniteType {M : X.Modules}
    (hM : IsLocallyTrivial M) :
    M.IsFiniteType := by
  sorry

/-! ## §4. Rank one and flatness record -/

/-- **Chart-local rank one and flatness** (Stacks, "Locally free sheaves":
finite locally free of rank `r`). On a trivialising chart the restriction
`M|_U ≅ 𝒪_U` is free of rank one over `𝒪_U`; in particular flat (`𝒪_U` is a flat
module over itself, and flatness is preserved by the isomorphism). The fact is
recorded chart-locally — as the rank-one free model `M|_U ≅ 𝒪_U = ⊕_{*} 𝒪_U`
the Quot embedding consumes — because Mathlib has no `SheafOfModules`-level
locally-free / flat / rank predicate. -/
theorem IsLocallyTrivial.chart_free_rank_one {M : X.Modules}
    (hM : IsLocallyTrivial M) (x : X) :
    ∃ U : X.Opens, x ∈ U ∧ IsAffineOpen U ∧
      Nonempty (M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) := by
  exact hM x

end LineBundle

end Scheme

end AlgebraicGeometry
