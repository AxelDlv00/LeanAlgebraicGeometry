# mathlib-analogist directive — iter-245 (slug: loctriv-bridge)

## Mode: api-alignment

## Why this matters (stakes)

The project is about to spend ~20–38 iterations / ~400–750 LOC building a *general* concrete
strong-monoidal inverse-image pullback for presheaves of modules (`pullback₀ = Lan F.op` + a
Mathlib-absent filtered-colimit/⊗ interchange), to produce the comparison iso
`f^*(M⊗N) ≅ f^*M ⊗ f^*N` for ALL modules M,N. The downstream consumer (the relative Picard
functor) only ever needs that iso on **line bundles** (invertible / locally-trivial rank-1 sheaves).
A separate analyst (slug rpf-bridge) found Mathlib's `CommRing.Pic.mapAlgebra.map_mul'` builds the
Picard group-hom from the comparison ISO, and suggested the iso on invertible pairs is a *cheap
chart-chase* via the project's already-proven `IsLocallyTrivial.pullback`, collapsing to the unit
comparison on a common trivializing cover. If that is right, the 20–38-iter general build is
unnecessary and the bridge closes in a few iters. I need you to adjudicate this rigorously before I
sink the budget.

## The two competing verdicts to adjudicate

- **iter-243/244 verdict (the reason the general build was committed):** the route via local
  triviality is blocked because the FORWARD BRIDGE `IsInvertible M ⟹ IsLocallyTrivial M` for
  `M : Scheme.Modules` (i.e. tensor-invertible ⟹ locally free rank 1) is "Mathlib-scale": it needs
  *finite-presentation spreading-out* for `SheafOfModules` on a scheme, which Mathlib has only at the
  CommRing/`LocalizedModule` level, and M's finite presentation is "not even part of the
  SheafOfModules data."
- **analyst rpf-bridge (this iter):** cited `Module.Invertible` and
  `Module.Invertible.instLocalizationLocalizedModule` (module-level invertible base-change
  stability) and called the invertible-pair comparison iso a cheap chart-chase.

## Project facts (verify against the actual files)

- `IsInvertible M : Prop := ∃ N, Nonempty (Scheme.Modules.tensorObj M N ≅ unit)` —
  `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:168`.
- `IsLocallyTrivial M : Prop := ∀ x, ∃ U, x∈U ∧ IsAffineOpen U ∧ Nonempty (M.restrict U.ι ≅ unit)` —
  `AlgebraicJacobian/Picard/LineBundlePullback.lean:115`.
- `IsLocallyTrivial.pullback` (pullback preserves local triviality) is FULLY PROVEN by chart-chase at
  `LineBundlePullback.lean:156–193` (`i1 ≪≫ … ≪≫ i7`; the "typed sorry" docstring is stale). Confirm
  its axiom profile.
- `pullbackUnitIso` (`f^*𝒪 ≅ 𝒪` for all f) is axiom-clean (`TensorObjSubstrate.lean:1045`).

## Questions

1. **Forward bridge cost.** Is `IsInvertible M ⟹ IsLocallyTrivial M` for `Scheme.Modules` cheaply
   achievable using Mathlib's module-level invertible machinery (`Module.Invertible` ⟹ finitely
   generated projective ⟹ locally free; invertible module over a local ring is free) lifted
   stalk-locally, OR is the iter-243 "Mathlib-scale / needs bespoke finite-presentation spreading-out
   for SheafOfModules" verdict correct? Specifically: does `IsInvertible M` (∃N, M⊗N≅𝒪) supply
   finite-presentation of M as a SheafOfModules through any Mathlib lemma, and does Mathlib have a
   stalk-iso ⟹ neighborhood-iso spreading-out usable for `SheafOfModules`? Name the exact lemmas if
   they exist, or confirm the gap if they don't.
2. **Comparison iso on locally-trivial pairs.** Independent of Q1: can
   `f^*(M⊗N) ≅ f^*M ⊗ f^*N` be proven for *locally trivial* M,N by the SAME chart-chase as
   `IsLocallyTrivial.pullback` (common affine trivializing cover where both sides reduce to
   `pullbackUnitIso`), with no general filtered-colimit machinery? Sketch the chart-chase and estimate
   LOC. Note the subtlety: M⊗N's trivializing cover is the common refinement of M's and N's covers.
3. **Bottom line.** Is there a route to the `pullbackTensorIso` bridge **restricted to the
   invertible/locally-trivial pairs the consumer needs** that is materially cheaper (a few iters) than
   the committed general strong-monoidal build (20–38 iters)? If yes, give the decomposition. If no,
   confirm the general build is necessary and say which sub-step is the irreducible blocker.

Be adversarial and precise — I will pivot a 20–38-iter plan on your answer, so do not overclaim a
cheap route that secretly re-imports the Mathlib-scale forward bridge, and do not rubber-stamp the
expensive build if a chart-chase genuinely suffices.

Persist reasoning to `analogies/invertible-loctriv-bridge.md`.
