# Strategy Critic Report

## Slug
ts229

## Iteration
229

## Routes audited

### Route: A.1.c.SubT — ⊗-group law / shared slice-site sheaf equivalence (the reframe under review)

- **Goal-alignment**: PASS — closing `exists_tensorObj_inverse` + `tensorObj_assoc_iso` yields the by-hand `CommGroup` on `Pic X`, a genuine prerequisite of `J := Pic⁰`.
- **Mathematical soundness**: PARTIAL — the *site-level* "same gap" reading is sound (both bridges reduce to comparing sheaves on the over-site `(Over U)` with sheaves on `Opens ↥U`). But "build the shared site equivalence → unblocks BOTH" likely **overstates**: the bare equivalence is `Sheaf J A ≌ Sheaf K A` for a *fixed* value category `A`. The A-engine glues *morphisms of sheaves of modules* and the C-bridge transports the *slice internal-hom (dual)* — both carry an `𝒪_X`-module / `restrictScalars` layer ON TOP of the underlying-Ab site equivalence. That module-transport layer is exactly the CommRingCat/RingCat diamond and `restrictScalarsEquivalenceOfRingEquiv` friction the project has repeatedly hit, and it is plausibly still *bridge-specific* — the site equivalence is necessary but not obviously sufficient to close either bridge outright.
- **Sunk-cost reasoning detected**: no — the iter-229 reframe is the *anti*-sunk-cost move (it stops rotating between A and C and attacks the shared root). The "why we keep building rather than idle" justification rests on the harness never-idle rule + USER-gated route-swap, not on prior investment.
- **Infrastructure-deferral detected**: no (with one watch-item). The hardest prerequisite is the same before and after the reframe — but here that is *correct*: the pivot dispatches the prover directly AT the shared gap (`mathlib-build`), it does not rename-and-defer it. Watch-item: the bridge is tagged "upstream-PR candidate." It MUST be built project-side this arc; if it silently becomes "deferred pending a Mathlib PR" with no project-side timeline, that flips to a deferral finding.
- **Phantom prerequisites**: none — both named primitives verified present (see Prerequisite verification). `Over U` thinness ⇒ `Subsingleton` hom-sets is correct (`Opens X` poset ⇒ `Over U` thin), so the `Over.map` coherence really does trivialize.
- **Effort honesty**: under-counted (mild) — ~5–9 iters / ~400–700 LOC after **10 flat 0/it iters** and a documented 3× cost growth. The estimate is more credible now (single named target, verified primitives) but does not price the residual module-transport layer flagged above; if that layer is real, expect a 4th growth.
- **Parallelism under-exploited**: no (marginal) — the substrate is genuinely the sole ungated lane; everything else gates on it or is USER-paused. Marginal opportunity: A.1.c's "replace dishonest `PicSharp := const PUnit`" cleanup and the shared-bridge build are partly independent and could run as two lanes.
- **Verdict**: CHALLENGE — proceed with the shared-bridge build, but the planner must explicitly size the `𝒪_X`-module/internal-hom transport that sits ON TOP of `Sheaf J A ≌ Sheaf K A`, rather than treating the bare site equivalence as closing both bridges. Name whether the transport is shared (then "unblocks both" holds) or bridge-specific (then C still needs its own slice internal-hom transport and the estimate grows).

### Route: A.1.c — RelPic functor

- **Verdict**: SOUND — held with honest placeholder-replacement work (`PicSharp := const PUnit` / `functorial := 0` flagged as dishonest, scheduled for re-engagement). Correctly downstream of A.1.c.SubT.

### Route: A.2.c — representability + Quot fork; A.2.c-engine

- **Mathematical soundness**: PASS — RR-free Quot/Hilbert engine (Nitsure §5 + Kleiman §4) is the standard FGA construction.
- **Infrastructure-deferral detected**: no — the ~3400–5500 LOC engine is HELD behind the critical path with a concrete (large) iter estimate (~30–60), not hidden. It is the dominant strategic fact that this engine is *entirely avoidable* via the USER RR decision; the strategy surfaces this honestly.
- **Verdict**: SOUND — legitimate sequencing; the cost is the USER fork, not a planning error.

### Route: A.4 — Albanese UP (Route 2) + autoduality

- **Verdict**: CHALLENGE (pre-existing, still live) — `J^∨ ≅ J` autoduality is classically RR-dependent; if it needs RR it collides with the paused Route C and undermines the RR-free rationale for the whole substrate. The strategy lists this as an open question but invests in the substrate *before* second-verifying it. Verify autoduality RR-freeness before any Route-2 LOC is spent, since a negative result re-prices the entire RR-free arc.

### Route: A.3 / genusZero + witness body

- **Verdict**: SOUND — gated, honestly flagged as likely under-counted (scheme tangent space + Hilbert poly absent from Mathlib).

## Format compliance

- **Size**: 144 lines / 13646 bytes — **over budget** (13.3 KB > 12 KB).
- **Headings**: PASS — the canonical five in order (`## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`).
- **Per-iter narrative detected**: yes — pervasive. E.g. `"iter-229 REFRAME — two independent analogists (ts229slice C, ts229glue A) CONVERGED"`; `"RESOLVED in shape (iter-226)"`; `"the iter-226 analogist's cheap … mirror was FALSIFIED iter-228"`. Iter numbers and `ts###` analogist slugs belong in `iter/iter-NNN/plan.md`, never in STRATEGY.md.
- **Accumulation detected**: yes — the `A.1.c.SubT.dual` row is fully RETIRED/"merged up" with `~0` everything; a zero-content row kept as a placeholder. Delete it.
- **Table discipline**: FAIL — the A.1.c.SubT Status and Risks cells are multi-sentence paragraphs (the Status cell alone is ~12 lines of prose with embedded iter/slug history), not "one short line per cell."
- **Format verdict**: NON-COMPLIANT

## Alternative routes (suggested)

### Alternative: `Equivalence.sheafCongr` instead of hand-assembling via `IsDenseSubsite.sheafEquiv`

- **What it looks like**: `TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U` is already a categorical equivalence. Mathlib's `CategoryTheory.Equivalence.sheafCongr` consumes an equivalence `e : C ≌ D` (plus an `IsDenseSubsite K J e.inverse` instance) and returns `Sheaf J A ≌ Sheaf K A` directly. This may give the slice-site sheaf equivalence with less bespoke `IsDenseSubsite`-instance plumbing than routing through `sheafEquiv` from scratch.
- **Why it might be cheaper or sounder**: it specialises the equivalence-of-sites machinery to the case the strategy actually has (an honest categorical equivalence, not just a dense subsite), potentially shaving the ~200–350 LOC.
- **What the current strategy may have rejected**: unclear — the strategy names `IsDenseSubsite.sheafEquiv` but not `sheafCongr`; the prover should compare both before committing.
- **Severity of the omission**: minor.

## Prerequisite verification

- `CategoryTheory.Functor.IsDenseSubsite.sheafEquiv`: VERIFIED — `Mathlib.CategoryTheory.Sites.DenseSubsite.SheafEquiv`.
- `TopologicalSpace.Opens.overEquivalence`: VERIFIED — `Mathlib.Topology.Sheaves.Over` (`Over U ≌ Opens ↥U`); confirms the named TODO file is real.
- `CategoryTheory.Equivalence.sheafCongr`: VERIFIED — `Mathlib.CategoryTheory.Sites.Equivalence` (suggested alternative route).

## Must-fix-this-iter

- Route A.1.c.SubT: CHALLENGE — the planner must distinguish the *underlying-Ab site equivalence* (shared) from the *`𝒪_X`-module/internal-hom transport on top of it* (possibly bridge-specific). Either show the transport is shared (justifying "unblocks both") or budget C's slice internal-hom transport separately. Do not assume the bare site equivalence closes both bridges.
- Route A.4: CHALLENGE (still live) — second-verify autoduality `J^∨ ≅ J` RR-freeness before any Route-2 investment; a negative result re-prices the entire RR-free substrate rationale.
- Format: NON-COMPLIANT — restructure STRATEGY.md in-place this iter: (1) strip all `iter-NNN` / `ts###` per-iter narrative from `## Phases` and `## Routes` into the iter sidecar; (2) collapse the A.1.c.SubT Status/Risks cells to one short line each; (3) delete the empty merged `A.1.c.SubT.dual` row; (4) trim under 12 KB.

## Overall verdict

The iter-229 reframe is structurally the *right* move: after 10 flat iters of rotating between the A-engine and C-bridge, dispatching the prover directly at the single shared root — the open-immersion↔slice sheaf-site equivalence — is anti-churn, not avoidance, and both named Mathlib primitives (`Opens.overEquivalence`, `IsDenseSubsite.sheafEquiv`) are verified real, with `Over U` thinness genuinely trivializing the coherence. The decomposition is sound at the *site* level. The hidden risk the planner must not gloss: the bare equivalence is `Sheaf J A ≌ Sheaf K A` for a fixed value category, while the two bridges each carry an `𝒪_X`-module / slice-internal-hom transport on top — the very CommRingCat/`restrictScalars` friction the project keeps hitting — so "build it once, unblock both" may understate the work and risks a 4th cost growth; the planner must size that transport layer explicitly. Separately, the strategy is honest that the entire RR-free substrate (~400–700 LOC here, ~3400–5500 LOC engine downstream) is *discarded* if the USER lifts the Route-C pause in favour of the cheaper divisor `Pic⁰` route — the cost asymmetry favouring the divisor route is credible and is correctly framed as a USER-only escalation the planner cannot act on; recommend making that escalation maximally salient since it dominates total cost. Finally, the document is NON-COMPLIANT on format: pervasive per-iter/analogist-slug narrative, paragraph-sized table cells, an empty merged row, and bytes over budget — restructure in-place this iter.
