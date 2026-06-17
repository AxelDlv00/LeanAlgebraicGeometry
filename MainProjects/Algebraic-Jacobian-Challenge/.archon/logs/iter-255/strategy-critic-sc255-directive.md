# Strategy-critic directive — iter-255

Read, verbatim, as your ONLY inputs:
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md`
- Blueprint chapter inventory (titles/topics) — skim `blueprint/src/chapters/*.tex` first lines only.

Do NOT read iter sidecars, task_*.md, PROGRESS.md, or any recent prover/review narrative. Judge the
strategy as a fresh mathematician would.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: nine protected declarations headed by
`AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object
uniform over the `k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`
(`[Field k]` only). `J := Pic⁰_{C/k}` built unconditionally; only `isAlbaneseFor` quantified over the
pointing. End-state: zero inline `sorry` in the dependency cone of each protected decl, 0 project
axioms, kernel-only axioms. Riemann–Roch is frozen by a permanent USER pause (Route C); the chosen
posture (c) forwards the Route-A Picard substrate to avoid RR.

## Focused challenge for this run

The critical-path bottom layer A.1.c.sub (the loc-triv pullback–tensor comparison iso on line bundles,
in `Picard/TensorObjSubstrate.lean` + `DualInverse.lean`) has now run ~21 iters vs an original 6–11
estimate (OVER_BUDGET), with 4 consecutive parallel iters closing helper lemmas but not their assigned
canonical targets. The recurring obstacle is NOT new mathematics — it is carrier/ring-spelling friction
(two defeq `MonoidalCategory` instances on `X.ringCatSheaf.obj` vs `X.presheaf ⋙ forget₂ CommRingCat
RingCat`; RingCat-vs-scheme action duality on defeq carriers). The strategy's stated justification for
the by-hand chart-chase (rather than Mathlib's generic `Sheaf.monoidalCategory`) is that scheme module
sheaves are valued over a RINGCAT-valued structure sheaf with varying-ring module tensor, so no
fixed-`A` `MonoidalCategory` instance applies.

Challenge, specifically:
1. Is the by-hand chart-chase A.1.c.sub route still the right call, or does the 4-iter carrier-spelling
   churn signal a DESIGN-level mismatch (e.g. the comparison-map definitions should be stated on the
   canonical `⋙ forget₂` spelling from the start; or the whole `pullbackTensorMap` should be built as a
   genuine monoidal-functor δ on a pinned spelling rather than assembled from sheafification pieces)?
2. Is the substrate genuinely on the critical path to the PRIMARY GOAL (Pic_{C/k} representability,
   A.2.c), or is the group-law/inverse substrate (A.1.c.sub feeding `RPF.addCommGroup`) a layer that
   could be deferred/decoupled while A.2.c representability scaffolding proceeds on the already-built
   `IsLocallyTrivial` carrier?
3. Any other route-level concern: the engine cost estimate (A.2.c ~3400–5500 LOC), the Route-1 vs
   Route-2 Albanese contingency, the genus-0 arm — flag anything that reads as a sunk-cost trap or a
   miscalibrated estimate.

Return SOUND / CHALLENGE / REJECT per concern, with the cheapest signal that would change your read.
