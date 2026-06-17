# Iter-009 objectives

## Prover lane (1 file — closes P4)

### `AlgebraicJacobian/Cohomology/AcyclicResolution.lean` [prover-mode: mathlib-build]
Build the 2 remaining TARGET-3 leaves (both absent from Lean; build, do not "fill sorry"):

1. `CategoryTheory.Functor.rightDerivedOneIsoCokerOfAcyclic` (`lem:acyclic_one_iso_coker`).
   `(R¹G)(A) ≅ coker(G(J)→G(Z))`. Recipe: horseshoe-lift the SES, read the BOTTOM of the homology
   LES at (0,1), kill `H¹(GI_J)=0`, extract the cokernel iso. Hard sub-step: `H⁰(GI_J)→H⁰(GI_Z)` ≡
   `G.map ses.g` via `R⁰G≅G` naturality — effort-break this square if it resists, leave a real partial.
2. `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution` (`lem:acyclic_resolution_computes_derived`,
   TARGET 3, depends on (1)). `(Rⁿ G)(A) ≅ Hⁿ(G(K•))` ∀n. Straight-line `Nat.rec` assembly off the
   3 closed cosyzygy leaves + (1) + `rightDerivedShiftIsoOfAcyclic`. Input type per prover's design
   decision (bare `K` + `e : A ≅ K.cycles 0` + `hexact` + acyclic/additive/PreservesFiniteLimits).

Full recipe + signatures in PROGRESS.md `## Current Objectives`; provenance:
`.archon/analogies/p4-derived-les.md` + iter-007 task result (`logs/iter-007/`).

## Blueprint work done this iter (no prover; forward investment)

- `Cohomology_CechHigherDirectImage.tex`: 3 proof blocks de-spectral-sequenced to Route-A
  (blueprint-writer `p5a-deSS` + blueprint-clean `p5a`). Opens P5a as a parallel lane next iter after
  a scoped gate re-review + frontier-leaf scaffold.

## STRATEGY.md edits
- P5a row re-scoped/re-estimated; basis-lemma sub-prerequisites enumerated; reduced-scope route
  committed; P3↔basis non-circularity confirmed; "independent of P3" corrected. (strategy-critic
  must-fix addressed.)

## Not dispatched this iter (with reason)
- P5a prover/scaffold lanes — chapter was `partial/partial` at dispatch; gate needs a fresh
  complete+correct verdict (next iter, after the de-SS rewrite is re-reviewed).
- P3 (`CechAcyclic.affine`) — statement gap (general OpenCover vs standard cover); focused refactor
  when P3 activates.
- File split of `CechHigherDirectImage.lean` — deferred until P3/P5 activate.
