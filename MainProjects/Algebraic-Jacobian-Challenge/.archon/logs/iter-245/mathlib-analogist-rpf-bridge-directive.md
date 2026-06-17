# mathlib-analogist directive — iter-245

## Mode: api-alignment

## Question

The project is about to open a parallel lane (A.1.c.fun): author the **relative Picard functor**
`RelPicFunctor` / `PicSharp` on the `IsInvertible` carrier, while the substrate lemma
`IsInvertible.pullback` is still being built (it will be supplied this iter only as a documented
typed-`sorry` bridge). The strategy-critic flagged a genuine design question we must resolve BEFORE
committing a blueprint rewrite + prover round: **what granularity must the `IsInvertible.pullback`
bridge expose so that the Picard-group-valued functor's functoriality goes through?**

Concretely, decide between:

- **(A) bare Prop:** `IsInvertible.pullback : IsInvertible M → IsInvertible (f^* M)` (a one-way
  implication of Props), relying on Mathlib's *existing* `PresheafOfModules.pullback` /
  `SheafOfModules` pullback pseudofunctor coherence (`pullbackComp`, `pullbackId`) for the
  composition/identity laws of the induced map on iso-classes; OR
- **(B) coherence data:** the bridge must additionally expose the monoidal comparison iso
  `f^*(M⊗N) ≅ f^*M ⊗ f^*N` and/or `pullbackComp` compatibility *as data*, because the functor's
  group-hom and functoriality fields cannot be assembled from the bare Prop alone.

## Relevant project facts (read these to ground your answer)

- `IsInvertible M : Prop := ∃ N, Nonempty (Scheme.Modules.tensorObj M N ≅ unit)` —
  `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:168`.
- The Picard carrier is built on iso-classes: `picSetoid` (L772), quotient = `PicGroup`, group law
  `picCommGroup` (axiom-clean, L813). So Pic(X) is a quotient of `{M // IsInvertible M}` by iso.
- `RelPicFunctor` / `PicSharp` target type and current stub fields are described in
  `AlgebraicJacobian/Picard/RelPicFunctor.lean` (header L20–175): `PicSharp` is a contravariant
  functor `(Over (Spec k))^op ⥤ AddCommGrpCat`; `PicSharp.functorial` is an `AddMonoidHom` per
  morphism; étale-sheafified. Current stubs are dishonest placeholders (`PicSharp := const PUnit`,
  `functorial := 0`) to be rewritten on the `IsInvertible` carrier.
- Mathlib `PresheafOfModules.pullback` is the abstract left adjoint of `pushforward`; it carries the
  standard pseudofunctor coherence isos (`pullbackComp`, `pullbackId`) — confirm what is actually
  available at the pin and whether those isos already act on iso-classes the way a functor to
  AddCommGrp needs.

## What I need from you

1. Whether Mathlib's idiom for a "Picard-group-valued (iso-class) functor that pulls back invertible
   sheaves" assembles functoriality from a bare Prop + existing pullback pseudofunctor coherence, or
   genuinely needs the monoidal/`pullbackComp` iso exposed as data on the bridge. Cite the Mathlib
   precedent (e.g. how `Pic`/`Picard`/invertible-sheaf functoriality, or any iso-class-quotient
   functor, is structured in Mathlib).
2. The concrete recommended *shape* of the `IsInvertible.pullback` bridge declaration (Prop vs.
   data-bearing) and, if data, exactly which coherence fields are load-bearing for the
   `RelPicFunctor` map + composition laws.
3. Whether the group-hom property of `[M] ↦ [f^*M]` (i.e. `f^*` respects ⊗ on iso-classes) needs the
   monoidal iso as data or follows from `pullbackTensorMap` (the comparison MAP, already built) plus
   the iso-class quotient washing out the coherence.

Persist your reasoning to `analogies/rpf-pullback-bridge-granularity.md`.
