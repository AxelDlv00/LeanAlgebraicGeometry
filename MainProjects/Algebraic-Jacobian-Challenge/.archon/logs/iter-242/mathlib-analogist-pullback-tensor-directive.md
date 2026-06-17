# Mathlib-analogist directive — slug `pullback-tensor`

## Mode: cross-domain-inspiration

## Context (minimal)

The project carries the Picard group on **tensor-invertibility**:
`IsInvertible M := ∃ N, Nonempty (M ⊗ N ≅ 𝒪_X)` for `M : SheafOfModules 𝒪_X` (Stacks 0B8M).
The group law `picCommGroup` is already axiom-clean. The current critical-path obligation is

  **`IsInvertible.pullback`**: for a morphism of schemes `f : Y ⟶ X` and `M` over `X`,
  `IsInvertible M → IsInvertible (f^* M)`,

where `f^* = AlgebraicGeometry.Scheme.Modules.pullback f`, defined as the **left adjoint**
`(SheafOfModules.pushforward f).leftAdjoint` (an abstract adjoint — NO sectionwise/stalkwise formula).

The unit half is DONE: `pullbackUnitIso : f^*𝒪_X ≅ 𝒪_Y` is axiom-clean (it turned out
`SheafOfModules.pullbackObjUnitToUnit f` is iso for EVERY `f`, because `(Opens.map f.base)` is always
`Final` by representable flatness). The remaining half is the **tensor comparison**.

The planned recipe given `e : M ⊗ N ≅ 𝒪_X` is the composite
`f^*M ⊗ f^*N  ≅[pullbackTensorIso⁻¹]  f^*(M ⊗ N)  ≅[f^* e]  f^*𝒪_X  ≅[pullbackUnitIso]  𝒪_Y`,
which needs **`pullbackTensorIso : f^*(M ⊗ N) ≅ f^*M ⊗ f^*N`** — i.e. that the abstract left-adjoint
pullback is strong monoidal (or at least gives an iso comparison on this one tensor).

## Structural problem

Transfer/realize a **strong-monoidal (tensorator) comparison** `F(A ⊗ B) ≅ F A ⊗ F B` for a functor
`F` defined ONLY as an abstract left adjoint between two monoidal categories whose objects are sheaves
of modules over (possibly different) sheaves of rings, where the tensor product on each side is
`sheafify(presheaf-tensor)` over a varying structure ring. There is no sectionwise value of `F` to
compute with directly.

## Failed approaches
- Sectionwise `extendScalars.Monoidal` (extension of scalars is strong monoidal on `ModuleCat`): DEAD —
  the abstract left-adjoint pullback has no sectionwise/stalkwise formula identifying it with
  `extendScalars`, so there is nothing to apply `extendScalars.Monoidal` to.
- `Adjunction.leftAdjointOplaxMonoidal` / a generic "left adjoint of a (lax) monoidal functor is oplax
  monoidal" packager: confirmed ABSENT from Mathlib at the pinned commit.
- Direct: filesystem grep confirms NO tensor-pullback comparison and NO
  `MonoidalCategory (SheafOfModules …)` at the pinned commit; `PullbackFree.lean` provides only the unit
  (`pullbackObjUnitToUnit`) and the free-module case (`pullbackObjFreeIso`).

## What I want back (ranked exploration list)

1. **Tensorator-from-adjunction precedent.** Has Mathlib built a strong/oplax-monoidal structure on a
   functor given only as an adjoint (in ANY domain — inverse image of sheaves, pullback of presheaves,
   left Kan extension, extension of scalars as adjoint, constant-sheaf functor, sheafification, etc.)?
   Name the construction, the API (`Functor.Monoidal` / `CoreMonoidal` / `LaxMonoidal` /
   `Comonoidal` / `OplaxMonoidal` builders), and how the tensorator was produced (mate of the right
   adjoint's lax structure? a universal-property / `Adjunction.homEquiv` transport?). The
   "doctrinal adjunction / monoidal adjunction" pattern is the suspected analogue — does Mathlib have it?

2. **Alternative route avoiding `pullbackTensorIso` entirely.** `IsInvertible` is Zariski-locally
   "free of rank 1". Pullback commutes with stalks: `(f^*M)_y ≅ M_{f(y)} ⊗_{𝒪_{X,f(y)}} 𝒪_{Y,y}`. Does
   Mathlib give a clean route `IsInvertible M → (locally free rank 1) → (f^*M locally free rank 1) →
   IsInvertible (f^*M)` — i.e. is there a Mathlib stalkwise/locally-free characterization of
   invertibility AND a "pullback preserves locally free of finite rank" result we can chain? Flag
   whether the "locally free rank 1 ⇒ ∃ tensor-inverse" gluing step is in Mathlib or is itself a gap
   (the project treats that gluing as off-path). Compare the LOC/risk of this route vs. building
   `pullbackTensorIso`.

3. **Bump check (decision-relevant).** Does a *recent* Mathlib (post the project's pin, ~2026-05-31)
   add either (a) a `MonoidalCategory`/monoidal-functor structure for `(Presheaf|Sheaf)OfModules.pullback`,
   or (b) `Adjunction.leftAdjointOplaxMonoidal` / monoidal-adjunction machinery, or (c) a
   pullback-respects-tensor lemma for QCoh / sheaves of modules? If so, name the declaration and
   the version, so we can weigh a bump against the in-tree build.

## Search radius
`wide` (any Mathlib domain for Q1; QCoh/sheaf/module-theory for Q2; whole library for Q3).

Persist your findings to `analogies/pullback-tensor.md`.
