You are scouting inside the Lean 4 project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (mathlib-based, huge: AlgebraicJacobian/Picard/*.lean, 384 files). Do NOT edit any file. Report findings only. Use `grep`/`Read` freely, and the indexed search `/home/axel/.archon-env/bin/horizon search "<query>" --json` (covers the project AND mathlib).

CONTEXT. The "DD-R certificate" lane needs, over a base ring R (a `Localization.Away r`), a `DivisorAdaptation C R pi d` together with `A.IsCertified n`. The assembler is `AlgebraicGeometry.DivisorAdaptation.isCertified_of_noLeak_of_forall_liftQ_injective` in `AlgebraicJacobian/Picard/DivSchemeCertZarKerSpan.lean` (read it). Its first hypothesis is the "no-leak" clause

  hnoLeak : ∀ (j : A.index) (s : Spec (.of R)),
    ((relCurve C R) ↘ Spec (.of R)).base ⁻¹' {s} ∩ closure (d.supportLocus ∩ (A.pieces j : Set _)) ⊆ (A.pieces j : Set _)

My question: **how do we actually produce `hnoLeak`?** I need a precise map of the available infrastructure.

Please investigate and report:

1. `AlgebraicJacobian/Picard/SupportTubeFinite.lean` — read it fully. What exactly does `Scheme.LocalEquations.exists_supportTube` say, what does `finite_colength_of_forall_fibre_closure_subset` need, and what other support/tube lemmas live there? Give exact statements (signatures) of the main declarations.

2. How is a `DivisorAdaptation` CONSTRUCTED in this project? Find every constructor/existence lemma: `exists_divisorAdaptation`, `DivisorAdaptation.ofAnchors`, anything in `DivisorFamilyExtraction.lean`, `DivSchemeFamily.lean`, `DivisorFamilyFieldSurj.lean`, `DivSchemeFrameCover.lean`, `DivSchemeKeyChart.lean`, `DivCarvePairChart.lean`. For each: exact signature, and crucially **how much freedom the caller has over the pieces** (`FinCoverData`: `m₀, h₀, a₀, partition₀` etc.). Can a caller choose the basic-open cover of the two pinned charts, e.g. force the divisor support to sit inside a single piece and be disjoint from the others? Quote the `FinCoverData` structure.

3. Is there anywhere in the project (any file) that already proves a `hnoLeak`-shaped statement NON-vacuously, i.e. produces the fibrewise-closure clause for a concrete adaptation? List them with file:line and how they did it.

4. Is there any lemma saying the trace `d.supportLocus ∩ pieces j` is CLOSED (or clopen in the support), or a lemma of the form "if support ∩ piece is closed then hnoLeak"? Also: what is `d.supportLocus` exactly (definition, and is it closed / proper over the base / finite over the base)?

5. Are there existing "packet"/idempotent/CRT-style constructions producing pieces that swallow the divisor (search for `packet`, `idempotent`, `clopen`, `CRT`, `separat`)? Give file:line and signatures.

Return a compact but precise technical report: exact Lean signatures (copy them), file:line refs, and your assessment of the shortest available route to `hnoLeak` over a shrunken base. Your final message IS the report.
