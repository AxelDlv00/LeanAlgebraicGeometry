# Strategy Critic Report

## Slug
iter191

## Iteration
191

## Routes audited

### Route: A — Picard scheme via FGA (`J := Pic⁰_{C/k}`)

- **Goal-alignment**: PASS — `Pic⁰` route delivers the unpointed witness object compatible with the char-general `[Field k]`-only signature.
- **Mathematical soundness**: PASS — Kleiman §4–§5 + Nitsure §5 + Milne III §6 is the canonical FGA construction; the A.2 / A.3 / A.4 decomposition follows the standard chain.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the previously rejected "permanent named sorry" for Lane M↓ is now re-opened as a project-side Option (a) build with explicit iter budget. The strategy explicitly enumerates A.3.0 and A.4.d.0 substrates rather than deferring.
- **Phantom prerequisites**: none verified missing — `IsRegularLocalRing` exists; `GeometricallyConnected` + `ConnectedSpace ↥(pullback f g)` instance at `Geometrically/Connected.lean:100` exists; `Over.grpObjMkPullbackSnd` exists; `Scheme.restrictFunctorIsoPullback` exists.
- **Effort honesty**: under-counted in spots — Lane M↓ and A.4.d.0 estimates are tight (see Must-fix). Total envelope 290-520 iters is arithmetically consistent with the sum of subphase ranges (computed sum 271-507), but realized velocity over 190 iters (now at 79 sorries integration-RED) is well below the implied 30-50 LOC/iter rate that 9200-16400 LOC over 290-520 iters demands.
- **Parallelism under-exploited**: no — the dependency graph (A.3.0 parallel; A.3.i parallel; A.3.v/A.3.vi parallel with A.3.iii/iv) is well decomposed; Lane M↓ is independent.
- **Verdict**: CHALLENGE — strategically sound, but effort honesty on A.4.d.0/A.4.d and Lane M↓ needs sharpening, and the cumulative-velocity reality vs. envelope should be acknowledged.

### Route: C — genus-0 rigidity via Milne §I.3 (`J = Spec k`)

- **Goal-alignment**: PASS — `J = Spec k` trivial choice is correct for the char-general genus-0 arm; bridge through Milne Prop 3.10 (no Serre duality) is documented in references.
- **Mathematical soundness**: PASS — Rigidity + 𝔾_m-scaling chart-bridge is a recognized non-Serre-duality path; RR.1–RR.4 spine matches Hartshorne IV.1 and III.5.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — H¹-skyscraper-flasque substrate is enumerated (RR.2.H¹, ~8-12 iters / ~200-400 LOC) rather than deferred to Mathlib upstream.
- **Phantom prerequisites**: none with concrete verification gap — but the `H^Module k̄`-Ext compatibility with flasque-resolution approach is not explicitly checked in STRATEGY.md; if Mathlib's `H^Module k̄` framework lacks flasque-sheaf classes the substrate may need its own subsubstrate.
- **Effort honesty**: reasonable — Total ~45-65 iters / ~2200-3800 LOC for genus-0 arm is credible at the active per-iter velocity (~30/it on RR.1 and RR.3).
- **Parallelism under-exploited**: no — RR.1, RR.3, chart-bridge collapse-body are flagged parallel-startable.
- **Verdict**: SOUND.

## Format compliance

- **Size**: 145 lines / ~12.2 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in canonical order.
- **Per-iter narrative detected**: yes — line 30: `analogist verdict iter-191: substrate OWNED in Mathlib`. This is an explicit iter-NNN tag inside a Status cell, contradicting the strategy's stated provenance-strip discipline.
- **Accumulation detected**: no — REJECTED routes listed under `## Open strategic questions` are recorded strategic decisions, not completed-phase residue.
- **Table discipline**: PASS — table columns match the canonical skeleton; LOC cells carry both remaining and realized/gated figures.
- **Format verdict**: DRIFTED — one in-table iter-NNN leak; otherwise compliant.

## Alternative routes (suggested)

### Alternative: Lane M↓ via Étale-local standard-smooth + `IsLocalization.regular_iff`

- **What it looks like**: Rather than the full 00TT chain `smooth → flat → polynomial presentation → regular sequence → regular local ring`, work directly at the stalk: for a smooth `k`-algebra `A` standardly smooth at `p`, the localization `A_p` is essentially smooth over `k`; since smooth-over-field stalks have residue field embedding into the algebraic closure and dimension equal to relative dim, regularity follows from the Jacobian criterion applied to a single standardly-smooth presentation `k[x_1,…,x_n]/(f_{c+1},…,f_n)`. This packages the chain as one lemma "Jacobian criterion ⇒ regular" without explicitly threading flat / regular-sequence intermediates.
- **Why it might be cheaper or sounder**: Mathlib's `RingTheory/Smooth/StandardSmooth` already carries the Jacobian-criterion infrastructure; the missing piece is the `Ω_{A/k}` ⇒ regular bridge at the stalk, which Stacks tag 00T7 (already in `references/summary.md`, backing BR.2-BR.5) gives in a few pages. Estimated 100-200 LOC if the Jacobian-criterion entry point lands. May halve the Lane M↓ Option (a) estimate.
- **What the current strategy may have rejected**: the strategy lists Lane M↓'s chain as "smooth → flat → polynomial presentation → regular sequence → regular local ring" — this implicitly threads via regular sequences, which adds the `gr_𝔪(R) ≅ k[x_1,…,x_d]` substrate. The standard-smooth-Jacobian route may bypass this.
- **Severity of the omission**: minor — the chosen chain is correct; the alternative is a packaging variant that may save effort.

## Sunk-cost flags

(none)

## Prerequisite verification

- `IsRegularLocalRing` (Mathlib): VERIFIED — `RingTheory/RegularLocalRing/Defs.lean`.
- `isRegularLocalRing_stalk_of_smooth` (Mathlib): MISSING — confirms Lane M↓ Option (a) project-side build is required.
- `CategoryTheory.Over.grpObjMkPullbackSnd`: VERIFIED — `CategoryTheory/Monoidal/Cartesian/Over.lean`.
- `AlgebraicGeometry.GeometricallyConnected`: VERIFIED — class + connectedSpace lemma + pullback instance at `Geometrically/Connected.lean:100` exist.
- `AlgebraicGeometry.Scheme.restrictFunctorIsoPullback`: VERIFIED — `AlgebraicGeometry/Modules/Sheaf.lean`.
- `CategoryTheory.Over.pullbackComp`: VERIFIED — `CategoryTheory/Comma/Over/Pullback.lean`.

## Must-fix-this-iter

- **Route A: CHALLENGE — A.4.d.0 effort honesty.** Estimate ~3-5 iters / ~120-250 LOC for "Pic^d component + universal effective divisor" omits the Abel-Jacobi morphism extraction `Hilb^d(C) → Pic^d` (pull-push of the universal line bundle along the Hilb-scheme structure morphism). The strategy says "universal effective divisor reused from A.2.b Hilb-of-points specialised to curves" without naming the morphism-construction step. Either (a) re-cost A.4.d.0 to ~5-8 iters / ~250-400 LOC including the Abel-Jacobi morphism, OR (b) split out an A.4.d.0.AJ sub-substrate naming the morphism construction explicitly.

- **Route A: CHALLENGE — Lane M↓ Option (a) effort honesty.** ~8-15 iters / ~150-300 LOC for the Stacks 00TT chain at Mathlib b80f227 lacks evidence that the `Ω_{A/k}`-to-regular bridge (Jacobian criterion → regular) is available without rebuilding the `gr_𝔪(R) ≅ poly` or Cohen-structure intermediate. Either (a) acknowledge the upper estimate may climb to ~400-500 LOC if `RingTheory/Smooth/StandardSmooth` doesn't carry the Jacobian-criterion-to-regular entry point, OR (b) name the specific Mathlib entry point that compresses the chain.

- **Route A: CHALLENGE — Cumulative-velocity vs. envelope.** Total positive-genus arm of 290-520 iters / 9200-16400 LOC implies ~30-50 LOC/iter velocity. At 190 iters consumed with 79 inline sorries remaining (integration RED, per directive), the realized cumulative-velocity is well below the implied rate. The strategy should either (a) acknowledge the envelope as an upper bound assuming throughput improves with infrastructure landing, OR (b) tighten the envelope to a realistic projection from the last 30-50 iters' realized rate. As stated, the envelope is internally consistent but lacks a velocity reality-check.

- **Format: DRIFTED — per-iter narrative leak.** Line 30 contains `analogist verdict iter-191: substrate OWNED in Mathlib`. Strip the `iter-191` tag from the Status cell — the substrate-OWNED claim is independent of when it was verified. Replace with e.g. `2 closures + 5 pinned scaffolds; substrate OWNED in Mathlib (Geometrically/Connected.lean:100)`.

## Overall verdict

The strategy is SOUND in its overall shape: Route A is mathematically correct and the iter-190 revisions (A.3.0 substrate split-out, A.4.d.0 enumeration, Lane M↓ re-opened as project-side, A.3.v/vi parallelism corrected) all address real prior gaps. Route C is well-decomposed and the H¹-flasque substrate is appropriately enumerated rather than deferred. **No infrastructure-deferral findings** — every previously-deferred construction (Lane M↓, A.4.d divisor-map UP, A.3.0 tangent substrate, A.4.d.0 universal effective divisor) is now on the project-side critical path with a concrete LOC estimate. Three CHALLENGE-class concerns remain: (1) A.4.d.0's ~120-250 LOC envelope appears to omit the Abel-Jacobi morphism extraction; (2) Lane M↓'s ~150-300 LOC envelope is tight if the Jacobian-criterion-to-regular bridge needs project-side scaffolding; (3) the 290-520 iter positive-genus envelope is arithmetically consistent with the subphase sum but the realized cumulative-velocity (190 iters → 79 sorries) is below the implied rate, and STRATEGY.md does not flag this gap. Format is DRIFTED on one in-table iter-NNN leak (line 30). Verdict: SOUND with CHALLENGE — planner must address the three effort-honesty concerns and strip the iter-191 tag.
