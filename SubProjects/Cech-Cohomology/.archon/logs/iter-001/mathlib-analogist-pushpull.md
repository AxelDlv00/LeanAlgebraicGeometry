# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
pushpull

## Design question

The project hand-rolls a contravariant functor
`G : (Over X)ᵒᵖ ⥤ X.Modules`, `(Y, p) ↦ p_* p^* F` ("push–pull functor"), out of the
adjunction units and the pushforward/pullback comparison isomorphisms, gluing them with
two `eqToHom` transports along the over-triangle `ḡ ≫ p₁ = p₂`. The object map
(`pushPullObj`) and morphism map (`pushPullMap`) are defined by hand, and the functor laws
must then be proved by hand: `pushPullMap_id` is closed, but the composition law
`pushPullMap_comp` (a pseudofunctor "pentagon" calculation over `eqToHom` transports) has
resisted ~5 iterations — first a kernel `whnf` blow-up (now bypassed via a free-hypothesis
`subst` reformulation), now a pervasively *defeq-not-syntactic* regime where
`rw`/`erw`/`reassoc_of%`/`congr`/`pseudofunctor_associativity` all either fail to match
visually-identical terms or `whnf`-explode `pullbackComp` into its raw
`TwoSquare.equivNatTrans`/`mateEquiv` mate definition.

**The question**: does Mathlib already provide the functoriality of
`p ↦ p_* p^* F` (or the closely-related `p ↦ p_* p^*`) for sheaves of modules on schemes,
so that we should NOT be hand-rolling `pushPullMap`/`pushPullMap_comp` at all? Concretely:

1. Mathlib organizes pullback/pushforward of sheaves of modules as a pseudofunctor
   `LocallyDiscrete(Schemeᵒᵖ) → Adj Cat` (the project cites
   `Scheme.Modules.pseudofunctor_associativity`, `pushforwardComp`, `pullbackComp`,
   `conjugateEquiv_pullbackComp_inv`, all in `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`).
   Given a pseudofunctor and a fixed object `F`, is there a Mathlib construction that turns
   the assignment `p ↦ p_* p^* F` into an honest `Functor` (or the "fibrewise / pointwise"
   functor of a pseudofunctor applied to a fixed object) WITHOUT the consumer re-deriving the
   pentagon? Search for: pseudofunctor → functor "straightening"/"pointwise" constructions,
   `mateEquiv`/conjugate-of-adjunctions functoriality, `Functor` out of `(Over X)ᵒᵖ` built
   from an adjunction-valued pseudofunctor, comma-category / over-category direct-image
   functors, relative `Γ`/pushforward over a cover.

2. Is there a Mathlib idiom for "the cosimplicial object / Čech nerve obtained by applying a
   (pseudo)functor to the simplicial nerve of a cover arrow" that would let the project build
   `CechNerve` directly from `coverCechNerve` (the augmented Čech nerve of the cover arrow,
   already built) WITHOUT first assembling the standalone functor `G` and its `map_comp`?
   I.e. does the genuine obstacle (`pushPullMap_comp`) even need to be on the critical path,
   or is there a more direct Mathlib route from the simplicial scheme to the cosimplicial
   module object?

3. If the hand-rolled approach IS the right one, is the `pushPullMap` DEFINITION shape itself
   the problem (the two over-triangle `eqToHom` transports)? Would defining `pushPullMap`
   through the adjunction transpose / `homEquiv`, or via `rawPushPullMap` with the
   over-triangle as a free hypothesis from the start (so the `Over X` packaging is only added
   at the very end), give a transport-light definition whose `map_comp` is provable by
   `pseudofunctor_associativity` without hitting the defeq wall?

## Project artifact(s) under question
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:157-181` — `pushPullObj`,
  `pushPullMap` (the object/morphism bricks).
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:210-265` — `pushPullMap_id`
  (the proven identity law; template for the open `pushPullMap_comp`).
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:267-471` — the extensive
  in-file comment block documenting the `pushPullMap_comp` recipe, the kernel-wall bypass,
  and the current dead-ends; plus the helper bricks `pushPull_unit_mate`,
  `pushPull_transport_cancel`, `pushPull_unit_comp`, `pushforwardComp_hom_app_id`,
  `rawPushPullMap`, `pushPullMap_eq_raw`.
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:83-91` — `CechNerve` (the
  `sorry` that `pushPullMap_comp` is meant to unblock) and `124-135` — `coverArrow`,
  `coverCechNerve` (the already-built geometric backbone).
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`, §"The
  three-part construction" (paragraphs (1)-(3)) and `lem:push_pull_functor`.

## Why now

`pushPullMap_comp` is the documented rate-limiter for `CechNerve`/`CechComplex` and has
stalled ~5 iterations on a definitional/coherence wall — exactly the "design-shape
suspected" situation. Before dispatching yet another prover grind, I want to know whether
Mathlib already supplies this functoriality (so we delete the hand-rolled machinery and
align), or whether the `pushPullMap` definition shape should be refactored to dodge the
defeq wall. Write your persistent rationale to `analogies/pushpull-functoriality.md`.
