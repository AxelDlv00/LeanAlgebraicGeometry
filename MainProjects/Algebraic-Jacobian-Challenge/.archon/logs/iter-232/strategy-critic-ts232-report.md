# Strategy Critic Report

## Slug
ts232

## Iteration
232

## Routes audited

### Route: A.1.c.SubT — ⊗-group law (the sole active lane)

- **Goal-alignment**: PASS — a `CommGroup` on iso-classes of invertible `𝒪_X`-modules is genuinely needed to give `Pic⁰_{C/k}` its group structure.
- **Mathematical soundness**: PARTIAL — the *dual-based* inverse (`L ⊗ ℋom(L,𝒪) ≅ 𝒪`) is mathematically correct but is the **hardest** of three equivalent ways to discharge the inverse axiom, and the strategy presents it (and its FAIL-pivot, cocycle gluing) as if those were the only options.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The route is justified by the apparatus already built around it, not by being the cheapest way to get the inverse.
- **Infrastructure-deferral detected**: no (for this lane specifically — `dual_restrict_iso` is being built, not deferred).
- **Phantom prerequisites**: none — `existsUnique_gluing`, `restrictScalarsEquivalenceOfRingEquiv` both VERIFIED in Mathlib.
- **Effort honesty**: under-counted on *probability*, not LOC. The cell reads `~150–300 · ~0/it`: 14 iters at a realized velocity of ~0/it is not "incremental progress about to start", it is a route that has not moved. The file-split reduces context cost but does not change the LOC that must be proven.
- **Parallelism under-exploited**: no (this lane is intrinsically sequential).
- **Verdict**: CHALLENGE — the structural reset treats the stall as a *context/packaging* problem (file too big, gate too coarse). The likelier root cause is the **choice of carrier predicate**: building the group on the *locally-trivial* predicate forces you to manufacture an inverse object (dual, or cocycle gluing), whereas building it on the *tensor-invertibility* predicate (`∃ N, L ⊗ N ≅ 𝒪_X`) makes the inverse, identity, closure, and well-definedness all near-trivial. The strategy never considers this. See Alternative "tensor-invertibility carrier".

### Route: A.1.c — RelPic functor

- **Verdict**: SOUND — honestly flagged as held with dishonest placeholder bodies (`PicSharp := const PUnit`, `functorial := 0`) to be replaced once the group lands. Correctly gated behind A.1.c.SubT. No issue beyond the inherited substrate stall.

### Route: A.2.c — representability (scaffolding) + Quot/Cartier engine

- **Goal-alignment**: PASS — Pic representability is the PRIMARY goal node.
- **Mathematical soundness**: PASS — Quot/Hilbert → Pic representability is the standard FGA route (Kleiman §4, Nitsure §5), correctly sourced.
- **Infrastructure-deferral detected**: borderline — the ~3400–5500 LOC engine is the true mass of the project and is "HELD behind A.1.c.SubT→A.1.c". One sub-lane (`Cohomology_FlatBaseChange`) is being seeded, which is good, but the *gating* is the problem (see Parallelism).
- **Parallelism under-exploited**: **yes** — the engine foundations (`R^i f_*`, Relative Proj, CM-regularity, flattening, Grassmannian, Quot representability, relative Cartier, flat base change) do **not** depend on the abstract group law on iso-classes. They are being serialized behind a ~150–300 LOC substrate detail that has been stuck for 14 iters. See Parallelism finding.
- **Effort honesty**: reasonable for the LOC magnitude; the iter estimate (~30–60) is plausibly optimistic for that much Mathlib-absent material but is honestly the project's dominant cost.
- **Verdict**: CHALLENGE — de-gate the engine foundations from the substrate and run them in parallel. The substrate is small; the engine is the mountain, and most of it is independent of the substrate.

### Route: Albanese UP — Route 2 (autoduality + Galois descent)

- **Verdict**: SOUND with a live caveat the strategy already records — autoduality `J^∨≅J` is classically RR-dependent and its RR-freeness is UNVERIFIED. Correctly held behind a deletion gate. Keep the gate closed; this is the right posture.

### Route: Route C — Riemann–Roch (PAUSED by user)

- **Verdict**: SOUND as a posture — the pause is exogenous (user-imposed), so the planner cannot reopen it. But see the cost-asymmetry note in Overall verdict: the strategy's own numbers suggest the paused route may be *cheaper* than the RR-free engine, which is worth surfacing to the user rather than silently absorbing.

## Format compliance

- **Size**: 146 lines / ~11 KB — within budget.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in canonical order.
- **Per-iter narrative detected**: **yes** — pervasive. Representative verbatim: "iter-232 STRUCTURAL RESET: file-split the leaf"; "the all-or-nothing 150–300 LOC gate that stalled iters 227–231"; "iter-230's binding probe **half-falsified** that thesis"; "iter-232 reset (file-split EXECUTED + incremental sub-build)"; "iter-231 FAIL corrective". This is iter-sidecar content living in STRATEGY.md.
- **Accumulation detected**: yes — multiple inline "Dead ends" / "Dead-end (do NOT re-attempt)" enumerations with iter tags, the vestigial whiskering/stalk apparatus narration, and the retained Route-1 cone reasoning read as history accumulation rather than forward strategy.
- **Table discipline**: FAIL — the A.1.c.SubT `Status` cell is a multi-clause prose paragraph ("STUCK route → iter-232 STRUCTURAL RESET: file-split the leaf + incremental sub-build of the C-bridge (axiom-clean sub-lemma per iter, not all-or-nothing)") and the `Iters left` cell holds prose, not a number. Cells must be one short line.
- **Format verdict**: NON-COMPLIANT

## Alternative routes (suggested)

### Alternative: tensor-invertibility carrier (inverse-for-free)

- **What it looks like**: Define the underlying set of `Pic X` as iso-classes of `𝒪_X`-modules satisfying the predicate `∃ N, L ⊗ N ≅ 𝒪_X` (Stacks **0B8K** — the characterization the project already cites in `references/stacks-modules.md`, and tag **01CX**'s actual definition of `Pic(X)`). Then: identity `[𝒪_X]` from `𝒪⊗𝒪≅𝒪`; closure from `(L⊗N)⊗(L'⊗N')≅(L⊗L')⊗(N⊗N')≅𝒪`; **inverse `[L]⁻¹ := [N]`, free from the membership witness**; well-definedness of `(·)⁻¹` because `N` is determined up to iso (`N ≅ N⊗𝒪 ≅ N⊗(L'⊗N') ≅ (N⊗L)⊗N' ≅ 𝒪⊗N' ≅ N'`); assoc/comm from the existing associator/braiding. **No dual, no `dual_restrict_iso`, no `dual_isLocallyTrivial`, no internal-hom, no cocycle gluing.**
- **Why it might be cheaper or sounder**: it dissolves the entire 14-iter stall. The stall exists *only* because the carrier was chosen to be "locally trivial", which forces you to *manufacture* the witness `N` (either as the internal-hom dual — the stuck route — or by cocycle gluing `g_ij⁻¹` — the FAIL-pivot, which is just proving "locally-trivial ⟹ tensor-invertible" by hand). Tensor-invertibility *is* the Stacks definition of an invertible module / of `Pic`, so it is at least as faithful, not a weakening.
- **What the current strategy may have rejected**: unclear — the strategy never names the carrier-predicate choice as a decision point. It treats "the dual for inverses" as forced. If a downstream consumer genuinely needs *local triviality* (e.g. Poincaré bundle in A.3), prove `tensor-invertible ⟹ locally-free-rank-1` as a separate lemma *when that consumer is reached* — that is the clean-local-computation direction, not the stuck one.
- **Severity of the omission**: critical

## Sunk-cost flags

- `"the dual for inverses"` / `"the monoidal-localizer/whiskering/stalk apparatus is vestigial"` — Why this is sunk-cost: the strategy continues routing the inverse through the dual/internal-hom while simultaneously admitting the surrounding apparatus is vestigial; the route is being kept because it is built, not because it is the cheapest path to the inverse axiom. Recommendation: evaluate the tensor-invertibility carrier on its merits — it needs none of this apparatus.
- `"FAIL pivot still live (no further re-scope). Route II — build Linv by cocycle gluing"` — Why this is sunk-cost: the only named fallback still constructs an explicit inverse object under the locally-trivial carrier, re-deriving exactly what the membership predicate could give for free. Recommendation: the real fork is *carrier choice*, not *which way to build the dual*.

## Prerequisite verification

- `TopCat.Sheaf.existsUnique_gluing`: VERIFIED (`Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing`)
- `ModuleCat.restrictScalarsEquivalenceOfRingEquiv`: VERIFIED (`Mathlib.Algebra.Category.ModuleCat.ChangeOfRings`)

## Must-fix-this-iter

- Route A.1.c.SubT: CHALLENGE — before sinking a 15th iter into `dual_restrict_iso`, the planner must either (a) adopt the tensor-invertibility carrier (`∃N, L⊗N≅𝒪`) so the inverse is free, or (b) record an explicit rebuttal in `plan.md` naming the specific downstream consumer that *requires* the locally-trivial carrier and cannot accept tensor-invertibility. "We already built the dual apparatus" is not a valid rebuttal.
- Route A.2.c: parallelism CHALLENGE — de-gate the engine foundations (`R^i f_*`, Relative Proj, CM-regularity, flattening, Grassmannian, Quot, relative Cartier, flat base change) from the substrate; they are independent of the group law and are currently serialized behind a stuck ~150–300 LOC lane.
- Alternative "tensor-invertibility carrier": critical omission — the strategy considers only dual vs. cocycle gluing, both under the locally-trivial carrier; the cheapest sound route (free inverse from the membership predicate) is unconsidered.
- Format: NON-COMPLIANT — strip per-iter narrative ("iter-232 STRUCTURAL RESET", "stalled iters 227–231", "iter-230's binding probe half-falsified", "iter-231 FAIL corrective") into the iter sidecar; collapse the A.1.c.SubT `Status`/`Iters left` table cells to one short line each; move the inline "Dead ends" enumerations to the sidecar. Restructure in-place this iter.

## Overall verdict

The file-split + incremental-sub-build reset is a reasonable response to *context cost*, but it misdiagnoses the 14-iter stall as a packaging problem when the evidence points at a **construction-choice problem**. The strategy treats "the dual for inverses" as forced and offers only one fallback (cocycle gluing) that re-solves the same hard problem under the same locally-trivial carrier — a textbook "pivot that moves the same hard problem one layer deeper". The unconsidered alternative — carry `Pic X` on the tensor-invertibility predicate `∃N, L⊗N≅𝒪_X` (Stacks 0B8K/01CX, which the project already cites) — makes the inverse axiom free and dissolves the stall; it is at least as faithful to the Stacks definition of `Pic`, not a weakening. Separately, **the strategy serializes the A.2.c engine foundations behind the A.1.c.SubT substrate, but those foundations (`R^i f_*`, flattening, Quot, relative Cartier, …) are independent of the group law** — running them in parallel is a planning obligation the strategy is not meeting, and the substrate's smallness next to the engine's mass makes the misallocation stark. Finally, the strategy's own cost numbers show the paused RR/divisor route (~2600–5000 LOC) is plausibly *cheaper* than the RR-free engine (~3550–5800 LOC) it exists to avoid — worth surfacing to the user, since the pause is the only thing forcing the costlier path. Format is NON-COMPLIANT (pervasive iter narrative + prose table cells) and must be restructured in-place this iter.
