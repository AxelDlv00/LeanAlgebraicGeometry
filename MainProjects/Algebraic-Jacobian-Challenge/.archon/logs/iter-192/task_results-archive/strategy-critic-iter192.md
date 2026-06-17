# Strategy Critic Report

## Slug
iter192

## Iteration
192

## Routes audited

### Route: A — Picard scheme via FGA

- **Goal-alignment**: PASS — `J := Pic⁰_{C/k}` is the canonical Albanese object for the unpointed positive-genus arm; the construction goes from `Pic_{C/k}` via FGA and selects the identity component, which is what the protected statement demands.
- **Mathematical soundness**: PASS — Kleiman §4–§5 + Nitsure §5 + Milne III §6 is the textbook decomposition, and the dependency graph is mathematically faithful.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — A.2.a (flattening stratification, 2000–3500 LOC) and A.2.b (Quot + Grassmannian, 2600–5000 LOC) are both rows whose velocity cell is "gated" with no realized-LOC/it figure, while every downstream phase (A.2.c, A.3.ii, A.3.iii–vi, A.4.d.0) is gated on them. They are required by the goal but are not being actively built by any prover lane that has produced a velocity number; this is deferral by inaction. Calling them "chapters landed" sets up a status illusion — the chapter is the easy part.
- **Phantom prerequisites**: none verified missing; the named Mathlib hooks (`IsStandardSmooth`, `KaehlerDifferential`, `Algebra.Extension.CotangentSpace`, `Geometrically/Connected.lean:100` per the directive's iter-191 analogist finding) all exist.
- **Effort honesty**: reasonable in aggregate — the strategy is candid that the 295–530 iters envelope is optimistic and below the realized cumulative rate. But individual rows hide the problem: every "gated" cell with no realized velocity is implicitly claiming the phase can be started cheaply when nothing in the file demonstrates that. Recommend adding a column-level convention: rows with no realized velocity in N consecutive iters get an explicit "stalled" tag, not just "gated".
- **Parallelism under-exploited**: yes — the dependency graph identifies five independent roots (A.1.a, A.2.a, A.3.0, A.3.i, Lane M↓) but the strategy does NOT prescribe parallel allocation of prover lanes across them. Especially: A.3.0 (200–400 LOC), A.3.i (substrate OWNED in Mathlib, 100–140 LOC remaining), and Lane M↓ (150–500 LOC) are all small, independent, and feed three different parts of the tree — they should be running concurrently.
- **Verdict**: CHALLENGE — the route is mathematically correct but its **execution ordering is implicitly top-down** (provers are dispatched at A.4.x and discover missing A.2.x / A.3.x substrate iter-by-iter, as the live user hint explicitly calls out). STRATEGY.md must add a "Bottom-up execution priority" subsection that names the **dependency roots** (A.1.a, A.2.a, A.3.0, A.3.i, Lane M↓) and prescribes that prover capacity flows to them first, only escalating to A.4.x once their downstream substrates are unblocked.

### Route: C — genus-0 rigidity via Milne §I.3

- **Goal-alignment**: PASS — `J = Spec k`, char-general, no `C(k) ≠ ∅` hypothesis required; this is the clean half of the bifurcation.
- **Mathematical soundness**: PASS — rigidity lemma + Cor 1.5 + Cor 1.2 + genus-0 ⟹ ℙ¹ via RR is standard. Substituting project-side `H¹` of skyscraper-flasque for full Riemann-Roch is sensible.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — every phase has a realized/it figure (e.g. RR.1 `~30/it`, RR.3 `~30/it`) and concrete sub-substrates.
- **Phantom prerequisites**: none — `Proj.fromOfGlobalSections`, `IsSeparated.diagonal_isClosedImmersion`, etc. are sensible Mathlib hooks.
- **Effort honesty**: reasonable — ~45–65 iters / 2200–3800 LOC for a complete pointed-witness construction over Spec k is plausible given realized velocities.
- **Parallelism under-exploited**: minor — "parallel-startable" is annotated on RR.1 but the strategy doesn't explicitly fan out RR.1 / RR.2.H¹ / RR.3 / chart-bridge body across different prover slots. This arm has ~8 small phases that could run almost fully in parallel.
- **Verdict**: CHALLENGE — the genus-0 arm is the **only complete-able sub-objective in the entire strategy** within a 1–2-month horizon. STRATEGY.md should explicitly **prioritize its closure as the next milestone**, because doing so gives `nonempty_jacobianWitness` GREEN under genus = 0 (a real proof artifact), shrinks the remaining scope to just Route A, and validates that the project's lanes can finish things. The current strategy treats it as one arm of a `by_cases` — that's the algebraic role but not the strategic role.

### Route: Lane M↓ — `isRegularLocalRing_stalk_of_smooth` (Stacks 00TT)

- **Goal-alignment**: PASS — feeds CodimOneExtension → A.4.a, which is the dominant Route A risk.
- **Mathematical soundness**: PASS — Mathlib's `Algebra.IsStandardSmooth` machinery (`RingTheory.Smooth.StandardSmooth`, `RingTheory.Smooth.StandardSmoothCotangent`) is in place and the Ω-to-regular bridge is the right substrate to build on top of it.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the lane was just re-opened as a project-side build with a concrete 8–15 iter budget.
- **Effort honesty**: reasonable — the upper-bound widening to ~500 LOC if Jacobian-to-regular needs project-side scaffolding is honest.
- **Verdict**: SOUND — but should be flagged as priority root in the bottom-up priority subsection. It is *the* unblock for A.4.a.

### Route: Format (synthetic)

- **Verdict**: SOUND — see Format compliance block below.

## Format compliance

- **Size**: 151 lines / ~10 KB — within budget.
- **Headings**: PASS — `## Goal` / `## Phases & estimations` / `## Routes` / `## Open strategic questions` / `## Mathlib gaps & new material` in correct order.
- **Per-iter narrative detected**: no — no `iter-NNN` references in the strategy proper.
- **Accumulation detected**: minor — two `REJECTED — ...` bullets under "Open strategic questions" (Sym^g, Pic⁰-functor-of-points Yoneda UP). These take up ~7 lines holding rejected-alternative reasoning that belongs in an iter sidecar, not in STRATEGY.md. Acceptable for now but worth excising at the next compaction.
- **Table discipline**: PASS — Markdown table with the six required columns; LOC cells carry both remaining and per-iter velocity (`~30/it`, `~50/it`, or "gated"); cells are short.
- **Format verdict**: COMPLIANT — with a minor DRIFT toward accumulation on the "Open strategic questions" REJECTED bullets.

## Infrastructure-deferral findings

### Deferred: A.2.b Quot scheme + Hilbert of points

- **Required by goal**: yes — Route A's A.2.c (FGA Pic_{C/k} assembly) consumes A.2.b.iii. Also, after the Sym^g → divisor-map pivot, A.4.d.0 (universal effective divisor) is now explicitly "reused from A.2.b Hilb-of-points specialised to curves", which means the divisor-map UP route inherits A.2.b as a hard prerequisite. The pivot from Sym^g traded the S_g-quotient gap for the Hilb-of-points dependency — those are genuinely different gaps, but the new gap routes through the largest unbuilt phase in the strategy (2600–5000 LOC).
- **Current plan for building it**: STRATEGY.md lists A.2.b as three sub-phases (i/ii/iii) with "chapters landed" but no realized-LOC/it velocity — no prover lane is actively building it.
- **Timeline**: vague — 75–150 iters is an envelope, not a schedule. No "start at iter-X" or "must complete by iter-Y" commitment.
- **Verdict**: CHALLENGE — the planner must either (a) start an A.2.b prover lane this iter and commit it as a long-running named lane, or (b) reconsider whether A.4.d can avoid A.2.b entirely (e.g. by constructing the universal effective divisor via Cartier divisors on `C × Pic^d` without going through Hilb-of-points; Kleiman §5 does the Jacobian construction via Pic^d's universal sheaf, not via Hilb).

### Deferred: A.2.a flattening stratification

- **Required by goal**: yes — A.2.b is gated on A.2.a.i; A.2.b.iii on A.2.a.ii–iii.
- **Current plan for building it**: chapters landed, three sub-phases enumerated, no realized velocity.
- **Timeline**: vague — 60–110 iters envelope.
- **Verdict**: CHALLENGE — same shape as A.2.b. The planner must commit a lane or admit that the Picard arm is on indefinite hold pending an upstream Mathlib PR.

## Alternative routes (suggested)

### Alternative: bottom-up Mathlib-substrate-first execution order

- **What it looks like**: STRATEGY.md adds (right after `## Phases & estimations`) a short "Execution priority" subsection that lists the dependency roots in priority order. Concretely: (1) A.3.i — substrate OWNED, nearly done, ship it; (2) A.3.0 — small (200–400 LOC), unblocks A.3.iii–iv; (3) Lane M↓ — small (150–500 LOC), unblocks A.4.a; (4) A.2.a flattening stratification — start the long-running lane now, not later; (5) A.2.b Quot — start in parallel, since A.2.b.ii only depends on A.2.a.i; (6) Genus-0 arm — fan out across RR.1 / RR.2.H¹ / RR.3 / chart-bridge body in parallel as a complete-able milestone. A.4.a / A.4.b / A.4.c / A.4.d are demoted from "headline" to "downstream of substrate landings".
- **Why it might be cheaper or sounder**: this is exactly what the live user hint asks for. Top-down execution generates per-iter "discover missing prerequisite" cycles, which the user explicitly identified as wasted motion. Bottom-up flips the polarity: prover lanes are dispatched at the roots, so when a substrate lands it unblocks everything downstream at once. It also matches the iter-191 analogist finding — A.3.i was deemed "stuck" but was actually almost done because the substrate had landed in Mathlib unbeknownst to the planner.
- **What the current strategy may have rejected**: the strategy does list dependencies but doesn't translate them into an explicit execution-order priority. There's no evidence of an explicit rejection — it's an unstated assumption.
- **Severity of the omission**: critical — this is the user's primary hint and the largest leverage available.

### Alternative: mandatory mathlib-analogist sweep every N iters

- **What it looks like**: STRATEGY.md commits to running the mathlib-analogist subagent on **all "substrate unowned" / "gated" rows** every 10 iters (or every plan phase), with a one-line "Mathlib-state check" entry in `## Open strategic questions` naming the next-due iter. The sweep checks whether any deferred substrate has been landed in Mathlib upstream since the last sweep.
- **Why it might be cheaper or sounder**: the iter-191 finding (A.3.i substrate OWNED in `Geometrically/Connected.lean:100`) shows that "stuck" status can be a planner-side stale belief, not a real obstruction. A periodic sweep amortizes that risk across the whole strategy at a tiny fixed cost (~1 analogist dispatch / 10 iters) instead of paying it as a per-phase surprise.
- **What the current strategy may have rejected**: not addressed at all in STRATEGY.md.
- **Severity of the omission**: major.

### Alternative: Cartier-divisor-on-`C×Pic^d` route for the universal effective divisor

- **What it looks like**: instead of obtaining the universal effective divisor as a specialisation of Hilb-of-points (A.2.b), construct it directly as the relative Cartier divisor associated to the universal line bundle `𝓛` on `C × Pic^d` via `𝓛 ↦ Div(𝓛)`. This is closer to Milne III §6 / Mumford abelian varieties §6 than to FGA Nitsure §5.
- **Why it might be cheaper or sounder**: removes A.2.b as a hard prerequisite of the A.4.d divisor-map UP path. If A.2.b is going to stay gated long-term, this lets A.4.d proceed in parallel with the (separate) construction of `Pic^d` via FGA.
- **What the current strategy may have rejected**: the strategy describes the universal effective divisor as "reused from A.2.b Hilb-of-points specialised to curves" — i.e. it picked the FGA decomposition uniformly. The alternative isn't named.
- **Severity of the omission**: major — directly addresses the largest infrastructure-deferral CHALLENGE above.

## Sunk-cost flags

- `A.4.d Sym^g → divisor-map pivot: divisor-map UP via Pic^d component + universal effective divisor (both substrates enumerated as A.4.d.0). Saves S_g-quotient gap.` — Not strictly sunk-cost (the pivot is mathematically real), but the framing "saves S_g-quotient gap" understates that the new route inherits A.2.b Hilb-of-points as its substrate. The pivot trades one large gap for an equally large gap that happens to lie in a phase the strategy is already nominally committed to. Recommendation: add one line acknowledging A.4.d's dependency on A.2.b being built, or pivot the universal effective divisor to a Cartier-divisor construction that doesn't route through A.2.b (alternative #3 above).

## Prerequisite verification

- `Algebra.IsStandardSmooth` / `Mathlib.RingTheory.Smooth.StandardSmooth`: VERIFIED.
- `Algebra.SubmersivePresentation.isStandardSmooth`: VERIFIED.
- `AlgebraicGeometry.IsSmooth.exists_isStandardSmooth`: VERIFIED.
- `IsLocalRing.CotangentSpace`: VERIFIED.
- `Algebra.Extension.CotangentSpace`: VERIFIED (in `Mathlib.RingTheory.Extension.Cotangent.Basic`).
- `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`: VERIFIED — directly usable for Lane M↓'s Ω-to-regular bridge.
- `AlgebraicGeometry.Scheme.stalkClosedPointTo`: VERIFIED — useful for the local-criterion phase A.3.iv.
- Stacks 00NQ `isDomain_of_regularLocal`: MISSING — strategy correctly identifies as project-side build (A.4.b).
- Flattening stratification: MISSING — strategy correctly identifies as gap (A.2.a).
- Quot / Hilbert representability: MISSING — strategy correctly identifies as gap (A.2.b).

## Must-fix-this-iter

- Route A: CHALLENGE — STRATEGY.md must add an explicit "Execution priority" subsection (or equivalent) naming dependency roots in bottom-up order: A.3.i, A.3.0, Lane M↓, A.2.a, A.2.b, plus the Genus-0 arm fan-out. The live user hint targets this exact gap. Without it, prover lanes continue to be dispatched top-down at A.4.x.
- Route A: infrastructure-deferral CHALLENGE — A.2.a flattening stratification required by goal, no concrete timeline. Planner must either start a long-running A.2.a lane this iter (committing it as a named lane in `task_pending.md`) or admit the Picard arm is on indefinite hold pending upstream Mathlib.
- Route A: infrastructure-deferral CHALLENGE — A.2.b Quot + Hilbert-of-points required by goal (consumed by A.2.c AND, post-pivot, by A.4.d.0), no concrete timeline. Same remedy as A.2.a, OR pivot A.4.d.0's universal-effective-divisor substrate to a Cartier-divisor construction on `C × Pic^d` that doesn't route through A.2.b.
- Route C: CHALLENGE — STRATEGY.md must explicitly prioritize closure of the Genus-0 arm as the **next milestone** (45–65 iters / 2200–3800 LOC), with parallel fan-out across RR.1 / RR.2.H¹ / RR.3 / RR.4 / chart-bridge body. Closing this arm gives `nonempty_jacobianWitness` GREEN under genus = 0 — a real proof artifact, validation of lane throughput, and a scope reduction to just Route A.
- Alternative "mathlib-analogist sweep" — major omission — strategy should commit to a periodic sweep of "substrate unowned" / "gated" rows so that fresh Mathlib landings (like the iter-191 A.3.i discovery) are caught proactively, not by accident.
- Alternative "Cartier-divisor universal effective divisor" — major omission — this is the cheapest way to break A.4.d's dependence on A.2.b if A.2.b stays gated.

## Overall verdict

The strategy is mathematically sound and goal-aligned on both arms, the routes are textbook-canonical, and format is COMPLIANT. The dominant strategic failure is **execution-order drift**: STRATEGY.md correctly enumerates the dependency graph and Mathlib gaps but does NOT translate them into a bottom-up execution priority, so prover lanes are dispatched top-down at A.4.x and discover missing substrates iter-by-iter — exactly the failure mode the live user hint flags. The strategy defers A.2.a (flattening stratification) and A.2.b (Quot + Hilbert), both of which are required for the stated goal, with envelope timelines but no committed long-running lanes; the recent Sym^g → divisor-map pivot at A.4.d trades one large gap for inheriting A.2.b as a hard prerequisite, which the strategy understates. Two structural additions are recommended this iter: (1) a "Bottom-up execution priority" subsection that prescribes prover allocation at the dependency roots (A.3.i, A.3.0, Lane M↓, A.2.a, A.2.b) and treats the Genus-0 arm as the next complete-able milestone with parallel fan-out, and (2) a "Mathlib-state periodic sweep" commitment so that freshly-landed Mathlib infrastructure (like the iter-191 A.3.i discovery) is caught proactively. Verdict per route: Route A CHALLENGE, Route C CHALLENGE (priority elevation), Lane M↓ SOUND, Format COMPLIANT-with-minor-drift.
