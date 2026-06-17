# Strategy Critic Report

## Slug
iter150

## Iteration
150

## Routes audited

### Route: Route C (M2 critical path) — chart-algebra piece (ii)

- **Goal-alignment**: PARTIAL — Chart-algebra (KDM + constants + β-core MV) is on the path to closing `rigidity_over_kbar`, which feeds `genusZeroWitness`, which feeds the genus-stratified body of `nonempty_jacobianWitness`. The chain is sound at the topological level. The PARTIAL is for substep 3: the route stakes the closure of `constants_integral_over_base_field` on the strong form `RingHom.range (appTop.hom) = ⊤` (i.e. `Γ(X, O_X) ≅ k`), but the document itself flags an open question (H1Cotangent vanishing) that might let the downstream consumer `rigidity_over_kbar` consume something strictly weaker. If the weaker form suffices, a chunk of the substep-3 effort is goal-misaligned overhead.
- **Mathematical soundness**: PARTIAL — The (KDM p2) char-0 path via the `Differential.ContainConstants` typeclass is mathematically real, and the bridge from `KaehlerDifferential.D` to a `Differential B` instance via basis projection on `Algebra.IsStandardSmooth.free_kaehlerDifferential` is plausible. The (S3.pi.1)/(S3.sep.*)/(S3.pi.2) factorisation of substep 3 cites Stacks Tags 02KH, 0BJF, 05DH, 030V, 0334, 04QM correctly at the right granularity. **Caveat:** the "Honesty note" on line 70–72 — "path (b) does NOT bypass the flat-base-change content of path (a) step (e)" — is attributed in-text to `references/literature-crosscheck-iter149.md`, which the dispatcher informs me was a **fabricated** file that has since been deleted. The attribution is therefore invalid as supporting evidence. The underlying mathematical claim ((S3.pi.1) = flat base change of Γ for proper schemes = same content as path-(a) step (e), specialised to H⁰) is on its face plausible — it is the same Stacks Tag 02KH content either way — but the strategy must not cite a deleted source.
- **Sunk-cost reasoning detected**: yes — the phrase "**Merit-based justification.**" appearing twice in the Routes section (once for Route C, once for Route A) is a defensive tell. The label is fine when the content under it is genuinely merit-based, but its prominence suggests the author is rebutting a prior sunk-cost charge rather than persuading a fresh reader. Specifically, the Route C justification ends with "the cotangent-side application is budgeted under `## Mathlib gaps & new material` as the β-core sub-piece, not as a separate target" — this is a budgeting reframe, not a merit argument: the work is the same work; redrawing the column under which it is counted does not make it cheaper. See `## Sunk-cost flags` below.
- **Phantom prerequisites**: none beyond the deleted-source citation. All named Mathlib names verified (see `## Prerequisite verification`).
- **Effort honesty**: under-counted — the "Iters left" column for the chart-algebra envelope reads "5–9" while the LOC column reads "380–800 (remaining)". At a sustained throughput of ~80–150 LOC/iter (typical for this project's prover lanes inferred from the LOC granularity in the table), 800 LOC is closer to 6–10 iters of pure body work, not counting structural false starts on KDM (BR.3)/(BR.4)/(BR.5) and the four (S3.*) sub-claims of substep 3. The range is plausible at its upper end but optimistic at its lower end; the planner should not treat "5" as a budgetable midpoint.
- **Verdict**: CHALLENGE — fix the phantom citation to the deleted fabricated source, and either ground the "Honesty note" in a real cross-check (e.g. a `reference-retriever` dispatch's output) or strike it as planner opinion. Independently, address the under-counted iter range.

### Route: Route A (M3 off-critical-path) — Picard scheme via FGA

- **Goal-alignment**: PASS — Route A produces the Picard scheme + identity component → Jacobian, which is exactly `positiveGenusWitness`. The genus-stratified body cleanly hands off to it.
- **Mathematical soundness**: PASS — Hilbert/Quot → Picard → identity component is the standard FGA construction; the decomposition A.1–A.4 in `Jacobian.tex` matches the literature.
- **Sunk-cost reasoning detected**: no — the "Merit-based justification over Route B" content actually reasons about Mathlib-gap headcount and cross-utility for downstream AG consumers, which is a forward-looking merit argument, not a sunk-cost one. Acceptable.
- **Phantom prerequisites**: none verified. Hilbert/Quot representability, identity-component subgroup, fppf/étale topologies, flattening, coherent-of-finite-type are honestly enumerated as **Mathlib gaps** to be built in-tree, not assumed present.
- **Effort honesty**: reasonable — ~6070 LOC midpoint for the full chain is the right order of magnitude for FGA-style infrastructure in a fresh formalisation; the analogy file `m3-route-a-refresh-iter145.md` is cited for per-sub-piece breakdown.
- **Verdict**: SOUND.

### Route: Alternative — over-$\bar k$ + Galois descent for M2.a

- **Goal-alignment**: PASS — if executed, base-change to $\bar k$ + descent does close M2.a uniformly over arbitrary `C/k`. The strategy correctly acknowledges the route would require building Mathlib's fpqc-descent-of-morphisms infrastructure.
- **Mathematical soundness**: PASS — descent of morphisms along fpqc covers is standard; the route's prerequisite (genus-0 over $\bar k$ implies $\mathbb{P}^1_{\bar k}$) is a clean classical fact.
- **Sunk-cost reasoning detected**: no — the strategy fairly notes that chart-algebra's β-core MV is "a one-time investment that pays for itself across the M2.a + M2.b chain," which is a genuine merit argument for the chosen route, not a "we already did it" claim.
- **Phantom prerequisites**: none asserted; the route is explicitly gated on building fpqc descent.
- **Effort honesty**: under-specified — the route has no LOC estimate. If the planner considers triggering this re-evaluation seriously at the 1200-LOC threshold, they need a concrete number for fpqc descent + Galois cocycle infrastructure to compare against the remaining chart-algebra spend. Without that number, the trigger is decorative.
- **Verdict**: CHALLENGE — the rolling re-evaluation trigger is only operational if the alternative's LOC budget exists. Without one, "if cumulative crosses 1200 LOC, re-open" is unfalsifiable — re-opening will yield the same indecision because there is no measured counter-bid to compare against.

## Format compliance

- **Size**: 249 lines / 14723 bytes — **over budget** on bytes (14.4 KB vs ~12 KB allowance), within budget on lines.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` match the canonical skeleton in the correct order.
- **Per-iter narrative detected**: yes — five references to specific iter numbers leak iter narrative into the supposedly iter-agnostic document:
  - Line 70: `references/literature-crosscheck-iter149.md` (citation, file additionally deleted)
  - Line 107: `analogies/m3-route-a-refresh-iter145.md`
  - Line 154: "the iter-149+ commitment"
  - Line 166: "Investigate before committing to substep 3 closure beyond iter-149"
  - Line 213: `analogies/m3-route-a-refresh-iter145.md` (second occurrence)
  Citing analogy files whose filenames bake in the iter number is the same violation as writing the iter number inline.
- **Accumulation detected**: no — STRATEGY.md correctly delegates closed sub-piece summaries to iter sidecars ("Closed sub-pieces are summarised in the iter sidecar where each closed; STRATEGY.md tracks only remaining work").
- **Table discipline**: PASS — `## Phases & estimations` is a Markdown table with the required columns Phase | Status | Iters left | LOC | Key Mathlib needs | Risks, one short line per cell.
- **Format verdict**: DRIFTED — core skeleton intact, but the five iter-NNN leaks and the 2.4 KB byte-budget overage are real and should be cleaned up this iter without a full restructure. Replace iter-stamped analogy citations with their content-bearing slugs (e.g. rename `m3-route-a-refresh-iter145.md` to `m3-route-a-refresh.md`, or cite the route content directly), and delete the "iter-149+ commitment" / "beyond iter-149" anchors in favour of an unconditional commitment phrasing.

## Alternative routes (suggested)

### Alternative: Derivation-level rigidity bypassing `Γ ≅ k` entirely

- **What it looks like**: The downstream consumer `rigidity_over_kbar` ultimately uses `Γ(X, O_X) ≅ k` to conclude that a "constant derivation" (a derivation that vanishes on a dominating open) is zero. The required input is not the ring-level isomorphism but the conclusion that the only derivations `O_X → M` with vanishing image on a dominating affine are zero. On a smooth proper curve, this can be reached via `Subsingleton (Algebra.H1Cotangent A B)` (verified in Mathlib via `Algebra.FormallySmooth.subsingleton_h1Cotangent`) applied locally, paired with the dominating-source rigidity packaged in `Rigidity.lean`'s `ext_of_eqOnOpen`. The strategy already half-mentions this in "Open strategic questions" as a research item.
- **Why it might be cheaper or sounder**: It would entirely skip substep 3 of the chart-algebra envelope (~310–550 LOC for path (b), or ~250–300 for path (a)), the (S3.pi.1) flat-base-change-for-proper-schemes Mathlib gap (~150–250 LOC, the largest single sub-piece), and the (S3.sep.*)/(S3.pi.2) factorisation. The verified Mathlib name `Algebra.FormallySmooth.subsingleton_h1Cotangent` already exists; the project-side work would be packaging it at the scheme level.
- **What the current strategy may have rejected**: The strategy flags it but defers ("investigate before committing"). The reasons for not pursuing it as the primary path are not stated — the H1Cotangent direction is in `## Open strategic questions`, but the planner has nonetheless committed to substep 3 closure on path (b) per the same section.
- **Severity of the omission**: **major** — if the H1Cotangent route is viable, the project is committed to building ~310–550 LOC of project material whose consumer doesn't actually need it. The cost of a 1–2 iter feasibility study (write a Lean stub showing how `rigidity_over_kbar`'s body would consume `H1Cotangent`-vanishing in place of `Γ ≅ k`) is far smaller than committing to substep 3 path (b) and discovering after the fact that the body never needed it. **Concrete recommendation**: before any substep-3 prover dispatch this iter, dispatch a 1-iter prover lane to draft the `rigidity_over_kbar` body skeleton in both shapes (consuming `Γ ≅ k` vs consuming `H1Cotangent` vanishing) — the shape comparison alone resolves the substep-3 commitment question.

### Alternative: Concrete LOC bid for the over-$\bar k$ + Galois descent alternative

- **What it looks like**: A one-shot scoping pass that estimates the LOC for the missing fpqc-descent-of-morphisms infrastructure (Stacks Tag 04WV chain) + Galois cocycle bookkeeping, so the "1200-LOC trigger" actually has a counter-bid to compare against.
- **Why it might be cheaper or sounder**: The current rolling trigger is unfalsifiable — when 1200 LOC is crossed and the alternative is "re-opened", the planner will still have no number to weigh against the remaining chart-algebra spend. A one-iter scoping by the analogist (with `archon-informal-agent` if a paper sketch is wanted) would convert the trigger from decorative to operational.
- **What the current strategy may have rejected**: Likely the planner's view that the trigger condition will not fire in practice, so investing in the alternative's bid is wasted. But that itself is a bet, not an argument.
- **Severity of the omission**: minor — does not threaten the headline goal, but it does mean the strategy contains a control that cannot actually steer.

## Sunk-cost flags

- `**Merit-based justification.** Chart-algebra closes the \`df = 0\` derivation chain at three layers ...` (line 88) — Why this is sunk-cost: the heading "Merit-based justification" pre-emptively rebuts a sunk-cost charge that no current reader has made; the contents are mostly forward-looking, but the rhetorical framing reveals defensive posture. Recommendation: drop the heading; let the three layers speak for themselves on their merits. The β-core MV "budgeted under `## Mathlib gaps & new material` as the β-core sub-piece, not as a separate target" clause is a budget-reframe that does not change the actual work; either delete it or move it to a project bookkeeping note out of the Routes section.
- `Project commits to char-0 first.` (line 55) — Why this is sunk-cost: the commitment is asserted, not argued from merit. The strategy elsewhere notes the char-p path is ~140–230 LOC and the char-0 path is ~100–200 LOC; on size alone the difference is within noise. Recommendation: state the actual reason for the char-0 first ordering (e.g. "char-0 lets us discharge via Mathlib's `Differential.ContainConstants` typeclass directly, char-p requires a project-side Frobenius-iteration patch we have not scaffolded"). The current phrasing reads like a default rather than a choice.

## Prerequisite verification

- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: **VERIFIED** — exists in `Mathlib.RingTheory.Smooth.StandardSmoothCotangent` with signature `{R S : Type*} [CommRing R] [CommRing S] [Algebra R S] [Algebra.IsStandardSmooth R S] : Module.Free S Ω[S⁄R]`. Matches the strategy's [verified] annotation.
- `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`: **VERIFIED** — exists in `Mathlib.FieldTheory.PurelyInseparable.Basic` with signature `(F E) [CommRing F] [Ring E] [Algebra F E] [IsPurelyInseparable F E] [Algebra.IsSeparable F E] : Function.Surjective (algebraMap F E)`. Discharges the path (b) substep-3 closure step as the strategy claims.
- `Algebra.FormallySmooth.subsingleton_h1Cotangent`: **VERIFIED** — exists in `Mathlib.RingTheory.Smooth.Basic`. Confirms the H1Cotangent alternative's Mathlib backstop.
- `Differential.ContainConstants`: **VERIFIED** — typeclass exists in `Mathlib.RingTheory.Derivation.DifferentialRing` (constructor `Differential.ContainConstants.mk : (∀ {x : B}, x′ = 0 → x ∈ (algebraMap A B).range) → Differential.ContainConstants A B`). The strategy's claim that it is parameterised by an abstract derivation `B → B`, not by the universal Kähler derivation, is **accurate** — the typeclass derivation comes from a `Differential B` instance providing `'`, so the project-built bridge (BR.3)/(BR.4)/(BR.5) is genuinely required.
- `RingHom.iterateFrobenius_comm`: **not spot-checked this iter** (rate limit) — the strategy uses it for the (KDM p1) char-p alternative which is not the primary path; defer to a future audit.

## Must-fix-this-iter

- Route C: CHALLENGE — strip or replace the line-70–72 citation of `references/literature-crosscheck-iter149.md` (the file was a fabrication and has been deleted; the dispatcher confirmed a `reference-retriever` dispatch is in flight to repopulate references). Either ground the "Honesty note" in a verified source or rewrite it as planner judgement without the spurious citation.
- Route C: CHALLENGE — recalibrate the "Iters left: 5–9" range against the "380–800 LOC remaining" range; the lower end is optimistic given the structural setup work on (BR.3)/(BR.4)/(BR.5) + four (S3.*) sub-claims still to come.
- Alternative (over-$\bar k$): CHALLENGE — without a concrete LOC bid for fpqc descent + Galois cocycle infra, the 1200-LOC rolling trigger is decorative. Either scope it (1 iter, analogist or `archon-informal-agent`) or remove the trigger and recast the alternative as "documented but not in the decision-loop".
- Alternative (H1Cotangent rigidity): major — the strategy must either (a) commit a 1-iter feasibility prover dispatch this iter to draft `rigidity_over_kbar`'s body in both shapes (consuming `Γ ≅ k` vs consuming `H1Cotangent` vanishing) before approving any further substep-3 work, or (b) record an explicit rebuttal in `iter/iter-150/plan.md` naming the concrete reason the H1Cotangent route does not apply at the scheme level. Committing ~310–550 LOC to substep 3 path (b) without first checking whether the consumer needs it is a major planning hazard.
- Format: DRIFTED — strip the five iter-NNN leaks (lines 70, 107, 154, 166, 213) and trim the 2.4 KB byte overage. Rename/replace the two `*-iter145.md` and `*-iter149.md` analogy citations with content-bearing slugs or inline the relevant content.

## Overall verdict

A fresh mathematician would approve the **shape** of the strategy — the Route A/Route C split is sensible, the chart-algebra envelope's mathematical content is real (not phantom), the named Mathlib infrastructure all verifies, and the document's headings match the canonical skeleton in the correct order. But three material concerns prevent SOUND: (i) the chart-algebra route's "Honesty note" rests on a deleted-fabricated citation and must be either re-grounded or struck; (ii) the H1Cotangent alternative, surfaced in the strategy's own Open Strategic Questions, plausibly bypasses ~310–550 LOC of committed substep-3 work, and committing to substep 3 before testing the H1Cotangent shape against `rigidity_over_kbar`'s body is a planning hazard; (iii) the over-$\bar k$ + descent alternative's rolling trigger has no counter-bid, making it unfalsifiable. Format is DRIFTED, not non-compliant — clean up the five iter-NNN leaks and the byte overage in-place this iter.

**Net verdict: CHALLENGE.** Three CHALLENGE-class findings on Route C, one major alternative omission, one CHALLENGE on the alternative's broken trigger, and DRIFTED format. Must be addressed before the iter-150 prover dispatch.
