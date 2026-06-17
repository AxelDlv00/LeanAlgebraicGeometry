# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
ts-assoc-gate210

## Design question
The relative-Picard group law on schemes is being built via the ⊗-invertibility
idiom (a line object is `∃ N, M ⊗_X N ≅ 𝒪_X`, mirroring Mathlib's
`CommRing.Pic = Units (Skeleton (ModuleCat R))`). The group axioms on
iso-classes are *propositions* (`Nonempty (… ≅ …)`) and need four
existence-of-iso lemmas: associator, unit, braiding, inverse. The tensor is
`Scheme.Modules.tensorObj := sheafification ∘ PresheafOfModules.Monoidal.tensorObj`.

Unitors + braiding are confirmed cheap (`sheafification.mapIso (Monoidal.<iso>)`,
~15 LOC, no nesting). The OPEN, load-bearing question is the **associator**.
The current blueprint states it for ARBITRARY `M,N,P` and (per an honest
`% NOTE`) that route nests a sheafification inside the presheaf tensor, requiring
the "absorption iso" `sheafification(ptensor(sheafification A, B)) ≅
sheafification(ptensor A B)` = the whiskering-stability of the sheafification
localizer for an arbitrary module = the verified-absent
`MonoidalClosed (PresheafOfModules R₀)` wall.

**The decision**: scope the associator to INVERTIBLE (locally-free rank-1, hence
flat) objects only — which is all the group law consumes. Under that scope:

1. Is the associator existence-iso `(M⊗N)⊗P ≅ M⊗(N⊗P)` for invertible `M,N,P`
   buildable from PRESENT Mathlib WITHOUT `MonoidalClosed (PresheafOfModules R₀)`?
2. Which of these three realizations should we formalize?
   - **(1) Local-trivialization (direct):** each invertible object is locally
     `𝒪`, so the iterated tensor is locally `𝒪⊗𝒪⊗𝒪 = 𝒪`; build the iso on a
     common affine trivializing cover from the structure-sheaf associator and
     glue. (This is exactly the technique already PROVEN in
     `lem:tensorobj_preserves_locally_trivial`.) No monoidal category at all.
   - **(2) Flat-exactness whiskerLeft:** the flat-restricted `whiskerLeft :
     W g → W (F ◁ g)` via `Module.Flat.lTensor_preserves_injective_linearMap`
     + right-exactness, as `analogies/ts-design206.md` Decision A argues.
   - **(3) `J.W.IsMonoidal` on the flat subcategory** (gate of Mathlib's
     `CategoryTheory.Sheaf.monoidalCategory`).
3. Does realization (1) genuinely AVOID the absorption-iso wall (because the
   gluing of local structure-sheaf associators is canonical/coherent and does
   not re-invoke the arbitrary-`F` whiskering stability), or does the global
   gluing secretly require the same absorption iso?

**Reversal signal we explicitly want tested:** if even the invertible-subcategory
associator bottoms out in a renamed `MonoidalClosed` wall (e.g. the cocycle
gluing forces the arbitrary-module absorption iso globally), say so plainly —
that is the recorded iter-209 reversal trigger (pause this lane, pivot focus to
the Quot engine).

## Project artifact(s) under question
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — the `Scheme.Modules.tensorObj`
  substrate and its (sorry'd) group-law consumers.
- blueprint `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`:
  - `lem:tensorobj_assoc_iso` (L531) — currently ARBITRARY `M,N,P`, with the
    `% NOTE` admitting the absorption-iso / `MonoidalClosed` route.
  - `lem:tensorobj_preserves_locally_trivial` (L504) — ALREADY proven by local
    trivialization (common affine cover, tensor of free rank-1 = free rank-1).
  - `def:scheme_modules_isinvertible` (L795) — the `∃ N, M⊗N≅𝒪` predicate.
  - `lem:tensorobj_isoclass_commgroup` (L859) — the consumer; uses the associator
    only on INVERTIBLE objects.

## Why now
About to dispatch an engine-fix blueprint-writer to re-scope `lem:tensorobj_assoc_iso`
from arbitrary to invertible objects with whichever realization you recommend,
then a prover. Four prior iters (205–208) on this lane each DISPROVEN at the first
absent-Mathlib ingredient; we must confirm the re-scoped associator is genuinely
buildable from present Mathlib and pick the right realization before the prover round.

## Hints
- `analogies/ts-design206.md` (Decision A: flat-exactness route; named lemma
  `Module.Flat.lTensor_preserves_injective_linearMap`).
- `Mathlib.RingTheory.PicardGroup` (`CommRing.Pic`, `Module.Invertible`).
- `Mathlib.CategoryTheory.Monoidal.Skeleton`, `Mathlib.CategoryTheory.Sites.Monoidal`.
- Stacks tags: invertible-module `∃N` characterisation 0B8K; Picard group 01CX.

## Severity expectation
high-stakes
