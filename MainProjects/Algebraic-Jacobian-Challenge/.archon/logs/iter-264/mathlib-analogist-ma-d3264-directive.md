# Mathlib-analogist directive — ma-d3264

## Mode: api-alignment

## Question
The D3′ Sq1 tail in `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (helper lemma
`sheafificationCompPullback_comp_tail`, ~L2475) needs a composite-adjunction-unit composition coherence.
The ENGINE lane (`Cohomology/CechHigherDirectImage.lean`) independently discovered that Mathlib's
`Pseudofunctor (LocallyDiscrete Schemeᵒᵖ) (Adj Cat)` packaging supplies the pushforward/pullback
composition coherences directly — named lemmas `conjugateEquiv_pullbackComp_inv`
(`conjugate(pullbackComp.inv) = pushforwardComp.hom`), `conjugateEquiv_pullbackId_hom`,
`pseudofunctor_left_unitality`, `pseudofunctor_right_unitality`, `pseudofunctor_associativity`.

**Does this Mathlib pseudofunctor coherence apply to the D3′ tail, which has an EXTRA sheafification
layer?** Concretely: the D3′ tail's units are units of the COMPOSITE adjunction
`B_φ := (PrPbPushAdj φ').comp sheafAdj` — the presheaf pullback-pushforward adjunction composed with the
sheafification adjunction `sheafAdj` — whereas the engine's `pushPullMap` laws are about the bare
`Scheme.Modules.pullback`/`pushforward` adjunctions. The tail goal is
`B_{h≫f}.unit.app P = sheafAdj_X.unit P ≫ (forget ⋙ restrictScalars).map (U ≫ pushforward(h≫f).map (R1 ≫
R5 ≫ δ_pre))` where `U` carries `(pushforwardComp h f).hom`, `R1 = (pullback h).map (sheafCompPb f).hom`,
`R5 = (sheafCompPb h).hom`, and `sheafCompPb φ := sheafificationCompPullback φ` is the project's
`leftAdjointUniq` comparison.

Specifically tell me:
1. Is `Scheme.Modules.pullback`/`pushforward` (which IS `sheafify ∘ presheaf-pullback` / pushforward at
   the sheaf level) ALREADY the pseudofunctor's 1-cell, so the engine's coherence lemmas
   (`pseudofunctor_associativity` etc.) operate at the SHEAF level and absorb the sheafification layer
   automatically — meaning the D3′ tail can be closed the SAME way as the engine functor laws, NOT via a
   bespoke project mate calculus?
2. If NOT (the project's `PrPbPushAdj`/`sheafCompPb`/`sheafificationCompPullback` are a parallel
   re-derivation of something Mathlib already bundles), name the Mathlib idiom the project SHOULD be
   consuming, and whether the right move is to re-express `B_φ` / `sheafCompPb` in terms of the Mathlib
   pseudofunctor 1-cells so the coherence lemmas fire — i.e. is the project carrying a parallel API here?
3. The concrete next-step lemma names a prover should reach for to close
   `sheafificationCompPullback_comp_tail`, given your finding.

## Why this matters
D3′ Sq1 has had 3 consecutive PARTIALs with the same R1/R5-tail blocker; the prover's documented route is
a ~50–80 LOC project-local mate calculus. If the engine's Mathlib-pseudofunctor route applies (absorbing
the sheafification layer), the tail closes cheaply via existing Mathlib coherence instead — turning a
near-STUCK lane into a routine close. I need to know which world we are in before dispatching the prover.

## Files to read
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — `sheafificationCompPullback_comp_tail` (~L2475),
  `sheafificationCompPullback_comp` (~L2532), `sheafificationCompPullback` /
  `sheafificationCompPullback_eq_leftAdjointUniq`, `pullbackObjUnitToUnit_comp` (~L915–1001, the bare-
  adjunction analog that IS `rfl` sectionwise), `PrPbPushAdj`, `sheafAdj`.
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` — `pushPullMap` (~L175) + the deferred
  functor-law comment block (~L189–212) naming the Mathlib pseudofunctor lemmas.
- Mathlib: `Pseudofunctor (LocallyDiscrete Schemeᵒᵖ) (Adj Cat)` and the `conjugateEquiv_*` /
  `pseudofunctor_*` coherence API; `Scheme.Modules.pullback`/`pushforward`/`pullbackComp`/
  `pushforwardComp` in `AlgebraicGeometry/Modules/Sheaf.lean`.

Write your findings to `analogies/ma-d3264.md` and the task report.
