# Strategy-Critic Directive — Slug `routefork170`

## Why we are dispatching you

The genus-0 base-case sub-build has been stalled for 5 consecutive iters (iter-165 → iter-169) with the headline `gmScalingP1` body untouched. iter-169 was the "armed-trigger escalation" iter where THREE independent routes to that body were each tried and each terminated at a different Mathlib gap. The planner must now decide between three escalation options, all of which are non-trivial. We are NOT asking you to ratify a comfortable extension of the current plan — we are asking you to evaluate the strategic fork itself, fresh-context.

We are dispatching you per your dispatcher-notes "verdict was SOUND with no live CHALLENGE" skip condition — that condition no longer holds, because the iter-169 evidence (three routes, three different gaps) is qualitatively new strategic information that the previous SOUND verdict could not have weighed.

## Strategy state

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` is verbatim:

[Read this file directly, in full.]

## References summary

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md` is verbatim:

[Read this file directly, in full. Key entries: Milne `references/abelian-varieties.pdf` for §I.1 Rigidity Lemma + §I.3 Mor(ℙ¹,A) constant; Hartshorne `references/hartshorne-algebraic-geometry.pdf` for IV.1.3.5 genus-0⟹ℙ¹.]

## Blueprint summary

Chapters under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/`:

- `AbelianVarietyRigidity.tex` — the Route C (Milne §I.3) AV-rigidity stack: Rigidity Lemma, Cor 1.5 (additivity), Cor 1.2 (AV maps are homs), Albanese-UP feeder lemmas, and the genus-0 base case via the 𝔾_m-scaling shortcut (PRIMARY). Also covers `Genus0BaseObjects.lean` via `% archon:covers`.
- `Genus.lean.tex` — arithmetic genus = `dim_k H^1(C, 𝒪_C)`.
- `Jacobian.tex` — genus-0 + positive-genus witness object skeletons + Route A (Picard scheme) plan.
- `AbelJacobi.tex`, `RigidityKbar.tex`, `Cotangent_*.tex`, `Differentials.tex`, `Cohomology_*.tex`, `Rigidity.tex` — supporting / fallback infrastructure.

## Project's stated goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`): nine protected declarations headlined by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` — the existence of an Albanese/Jacobian object uniform over the `k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`, with NO `C(k) ≠ ∅` hypothesis. End-state: zero inline `sorry`, kernel-only axioms.

## The strategic fork (this is what we want your verdict on)

After iter-169's three-route exploration of `gmScalingP1 : ℙ¹ × 𝔾_m → ℙ¹` (the `𝔾_m`-scaling action that is the ONLY new ingredient needed for the genus-0 base case via Route C's 𝔾_m-scaling shortcut), the project faces three options:

(a) **Commit to an upstream Mathlib sub-build** providing the missing pieces: `Algebra.TensorProduct` `CommRing` instance for `HomogeneousLocalization.Away`-rings; relative-Proj base-change iso `Proj(MvPoly (Fin n) R) ≅ Proj(MvPoly (Fin n) k) ×_{Spec k} Spec R`. The prover estimates this as a ~5-iter detour to upstream Mathlib (PR review cycles excluded). Strategic value: unblocks both Option B chart-glue AND Functoriality-of-Proj routes simultaneously.

(b) **Accept `[CharZero]` as a temporary hypothesis** and use the existing `rigidity_over_kbar` (in `RigidityKbar.lean`, `[CharZero]`-gated, currently 1 sorry) as the genus-0 char-0-only artifact. This effectively reverts to fallback route (a) — the Serre-duality/differential route that was demoted in iter-156 for being char-restricted AND because Mathlib lacks the dualizing sheaf / Riemann-Roch / genus↔Ω bridge that the differential route needs.

(c) **Inline chart-glue at scale**: commit to building Option B inline in `Genus0BaseObjects.lean` over 2-3 iters (~200-300 LOC), without upstreaming to Mathlib. The chart morphism + cross-chart agreement gets built directly as named declarations using `pullbackSpecIso`, `Proj.fromOfGlobalSections`, `Scheme.Cover.glueMorphisms`. The mathematician's analogies file `analogies/gmscaling-deep.md` already lays out the 6-step decomposition with explicit Mathlib citations.

## iter-169 evidence (verbatim from prover task result)

Attempt 1: direct `Proj.fromOfGlobalSections` from whole pullback — FAILED. `Γ(ℙ¹ × Gm, ⊤) = k̄[t, t⁻¹]` (since `Γ(ℙ¹, ⊤) = k̄`), so any morphism via this route factors through the affineification, producing `(x, λ) ↦ [λ : 1] = λ` (the embedding Gm ↪ ℙ¹), NOT the scaling action `(x, λ) ↦ λ·x`.

Attempt 2: chart-glue (Option B) — FAILED on LOC budget (~200 LOC needed inside one iter). Specific blockers cited:
- `TensorProduct kbar (HomogeneousLocalization.Away 𝒜 _) (GmRing kbar)` `CommRing`/`Algebra` instance NOT picked up via `inferInstance` as configured (open question: synthesis-friction or real gap?).
- Cocycle on `D₊(X 0 · X 1)` needs `Proj.basicOpen`-cover-restriction lemmas not specialised to `affineOpenCoverOfIrrelevantLESpan`.

Attempt 3: Functoriality-of-Proj route — FAILED on missing Mathlib piece. `Proj.map : (𝒜 →+*ᵍ ℬ) → (Proj ℬ ⟶ Proj 𝒜)` exists (`ProjectiveSpectrum/Functor.lean:144`); but identifying `Proj (MvPoly (Fin 2) (GmRing kbar)) ≅ ProjectiveLineBar ⊗ Gm` requires the relative-Proj base-change iso, which is absent in Mathlib (verified `Glob`/`Grep`: no `Proj.iso_pullback_Spec`, `ProjPolynomial`, `relativeProj`).

## Specific questions for your fresh-context evaluation

1. **Is Route C still the right route?** Given that:
   - all three Mathlib gaps surfaced iter-169 are concrete and named,
   - option (a) is a ~5-iter Mathlib detour but unblocks both the iso AND functoriality route,
   - option (c) is a ~3-iter inline detour that delivers ONLY the chart-glue (not the cleaner functoriality route),
   should the project continue Route C, or should it pivot back to one of the off-path fallbacks (differential `df=0`, theorem of the cube, FGA-`Pic⁰` byproduct)? Be explicit if you challenge Route C; do not hedge.

2. **Choosing among (a)/(b)/(c).** If Route C is still right, which option do you recommend, and on what evidence? Note: option (b) `[CharZero]` is misleadingly named — the `rigidity_over_kbar` artifact it would consume is ITSELF unproved (1 sorry, Serre-duality-gated, on a route the project demoted for good reason). So (b) doesn't actually close the project; it just trades one stalled route for another. Confirm or refute this assessment.

3. **STRATEGY.md update obligations.** STRATEGY.md was last edited iter-167. Its `genus-0 rigidity` row reads `~5–12` iters left at `~390 LOC iter-165` velocity. We're now at iter-170 with the base-case scaffold in place but no body. Is the "5-12 iters" estimate still defensible, or does it need a >30% revision (the threshold that licenses an edit)? Be concrete about what the new estimate should be under each of (a)/(b)/(c).

4. **Are we missing an option (d)?** The three options surfaced are exhaustive ONLY against the current decomposition. Is there an option (d) — a different decomposition of `gmScalingP1`, a different proof of the `Mor(ℙ¹, A) = const` lemma that bypasses `gmScalingP1` entirely, or a different overall genus-0 strategy — that the iter-169 prover and the iter-165→168 planners missed? Be willing to challenge the entire `σ_×` setup. (Sub-question: would `σ : ℙ¹ × 𝔾_a → ℙ¹` translation help, given the project rejected it for needing `Hom(𝔾_a, A) = 0`? Why is `Hom(𝔾_a, A) = 0` HARDER than `gmScalingP1`'s chart-glue construction?)

## Output expected

Standard strategy-critic report. Be willing to CHALLENGE Route C wholesale if the iter-169 evidence warrants it. Be specific about the LOC/iters trade-offs for each option. Provide your single ranked recommendation among (a)/(b)/(c)/(d?) with concrete signals that would reverse it.

Verbatim file paths and Mathlib citations are welcome.

Output to `task_results/strategy-critic-routefork170.md`.
