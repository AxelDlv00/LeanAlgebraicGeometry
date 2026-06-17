# Strategy Critic Report

## Slug
sc262

## Iteration
262

## Routes audited

### Route: A.1.c.sub — comparison iso on line bundles (incl. dual-inverse route-2)

- **Goal-alignment**: PASS — a representable group functor needs inverses; the RPF inverse (`exists_tensorObj_inverse`) is genuinely required for `GrpObj (Jacobian C)`.
- **Mathematical soundness**: PASS — the loc-triv comparison iso and the dual evaluation iso are standard (Stacks 0B8K/01CR); the chart-chase justification ("`Sheaf.monoidalCategory` needs a FIXED `MonoidalCategory A`; the varying-ring tensor has none") is correct.
- **Sunk-cost reasoning detected**: no — the route-1→route-2 pivot is justified on merits (route-1's shared root provably carries no internal-hom/dual content), not by prior investment.
- **Infrastructure-deferral detected**: no — route-2 builds the missing piece (`sliceDualTransport`) directly with a concrete two-leg recipe; the hardest prerequisite (a dual/internal-hom commutation with reindexing) is NOT the same as route-1's (consume a dual-free overEquivalence). The pivot solves the gap rather than renaming it.
- **Phantom prerequisites**: `restrictScalarsRingIsoDualEquiv` and `sliceDualTransport` are project-internal (not in Mathlib) — expected, since this is the new material being built. `isIso_of_isIso_restrict` not directly locatable by loogle but is a standard sheaf-local criterion; treat as low-risk, not phantom.
- **Effort honesty**: reasonable — ~80–250 LOC remaining at ~25/it is internally consistent (8–14 iters).
- **Parallelism under-exploited**: yes (minor) — `sliceDualTransport` is one monolithic decl; leg-A and leg-B are separable and should be landed as independent lemmas so progress registers on the single-decl metric (see Must-fix).
- **Verdict**: SOUND

**On the directive's specific question (route-2-primary vs stalk-Plan-B).** Keep route-2 primary. The stalk alternative requires a *fresh* `stalkTensorIso`-magnitude build *plus* a stalk-dual commutation — strictly more new infrastructure than route-2's two named, tactical frictions (a CommRing-instance recovery and a unit-section defeq bridge), with leg-A already built. Pivoting to the stalk route now would be the avoidance move: abandoning near-complete work for a larger build. The two remaining frictions are tactical (recipe-level), not structural, so the ordering is correct. The "no formal sorry closed for multiple iters" signal is a **metric artifact of the monolith**, not evidence the route is wrong — which is exactly why the decomposition below matters.

**On "is there a cheaper architecture for the RPF inverse that STRATEGY is missing?"** I checked the obvious candidate — route the RPF inverse through the already-done `picCommGroup` (group inverse = `IsInvertible` witness) plus an `IsLocallyTrivial ⟺ IsInvertible` bridge. It does **not** shortcut anything: `IsLocallyTrivial M ⟹ IsInvertible M` *is* the inverse-existence problem (you must exhibit some `N` with `M⊗N≅𝒪`), and the only canonical construction of that `N` for a loc-triv sheaf is the dual `M^∨` with the evaluation iso `M⊗M^∨≅𝒪` (which holds because it holds locally) — i.e. `dual_restrict_iso` itself. So the dual is genuinely on the critical path; there is no cheaper architecture. STRATEGY is correct here.

### Route: A.1.c.fun — relative Picard functor on `IsLocallyTrivial`

- **Goal-alignment**: PASS — RPF group structure is the bridge from line-bundle classes to `Pic⁰` as a group scheme.
- **Mathematical soundness**: PASS — `map_add`←comparison iso, `map_zero`←`pullbackUnitIso`, inverse←`exists_tensorObj_inverse` (returns a loc-triv witness, so closure stays in the carrier). Template `CommRing.Pic.mapAlgebra`/`.functor` VERIFIED to exist in Mathlib.
- **Verdict**: SOUND — but velocity is `0/it` while "OPENING"; acceptable for a just-starting phase, re-check next iter that it actually moves.

### Route: A.2.c — representability + Quot fork (held)

- **Goal-alignment**: PASS — `Jacobian C : Over (Spec k)` must be an actual scheme, so representability is non-negotiable and correctly on the critical path.
- **Mathematical soundness**: PASS.
- **Verdict**: SOUND (held behind A.1.c is a legitimate ordering).

### Route: A.2.c-engine — Quot/Cartier (RR-free)

- **Goal-alignment**: PASS — RR-free representability forces this engine; given the permanent RR pause it is the only path and is correctly the dominant pole.
- **Mathematical soundness**: PASS — Nitsure §5 / Kleiman §4 is the right source.
- **Infrastructure-deferral detected**: yes (by inaction) — the dominant pole (`Rⁱf_*`, Relative Proj, CM-regularity, flattening, Quot, relative Cartier) sits at `~0/it` and is described as running "in PARALLEL" while in practice it idles behind the substrate; the strategy's own open question concedes "the group-law-independent pole must not idle behind the substrate." The on-path entry `IsLocallyTrivial⟹IsFinitePresentation` is done, but the `Rⁱf_*` Čech scaffold ("opens when capacity frees") has a concrete next step that has not started.
- **Effort honesty**: under-counted AND internally inconsistent — `Iters left: ~85–140` is computed as `~3400–5500 ÷ ~40/it`, but the realized velocity in the LOC cell is `~0/it`. A finite iters-left at `~0/it` realized velocity is the dishonest-estimate signal: the figure is derived from an aspirational 40/it that has not been demonstrated on this engine. The strategy honestly flags "likely optimistic," but the table still presents 85–140 as a schedule, not a hope.
- **Parallelism under-exploited**: yes — `Rⁱf_*`, Relative Proj, CM-regularity, semi-continuity, flattening, Grassmannian, Quot, relative Cartier are largely mutually independent and group-law-independent, yet are routed through a single held/serial phase behind A.1.c.
- **Verdict**: CHALLENGE

### Route: A.4 — Albanese UP (Route 1 RR-free primary)

- **Goal-alignment**: PASS for the UP node (`exists_unique_ofCurve_comp`).
- **Mathematical soundness**: PARTIAL — Route 1's RR-freeness is self-flagged as unverified (the divisor-sum map presupposes a `𝒪_C(D)` divisor↔Pic⁰ dictionary that may transitively pull a paused `RiemannRoch_{WeilDivisor,OcOfD}` decl). The strategy correctly defers this to an A.4-entry disjointness check.
- **Verdict**: SOUND (gated; the disjointness check is the right gate). Re-examine when A.4 opens — if the Route-1 cone does pull a paused RR decl, "Route 1 is RR-free" is false and the whole RR-free architecture's last mile breaks.

### Route: Route C — Riemann–Roch (paused)

- **Verdict**: SOUND — permanent USER pause; the architecture routes around it. Not contestable here.

### Route: Genus-0 arm

- **Verdict**: SOUND — arm (a) transits A.2.c; arm (b) paused (USER).

## Format compliance

- **Size**: 150 lines / 13062 bytes — **over budget** (~12 KB / 12288 bytes; ~774 bytes over).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: no (borderline) — no `iter-NNN` tags, but phase-age/budget phrases like `(~25 iters in-phase)` and `budget elapsed 25 vs orig ~6–11` lean toward history; acceptable as status metrics but trim if they grow.
- **Accumulation detected**: yes (mild) — completed items still occupy prose space: "`picCommGroup` axiom-clean" / "group law is DONE" repeated, and the "SHARED ROOT … CLOSED axiom-clean" bullet still holds a full paragraph in `## Mathlib gaps`. The file should shrink as items close.
- **Table discipline**: PARTIAL — columns are correct and both LOC figures are present, but several Status cells are multi-sentence paragraphs (the A.1.c.sub and A.2.c-engine Status cells especially). Long prose in cells is a discipline drift; compress to one short line each.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: A.2.c-engine cohomology/Quot stack (`Rⁱf_*` i≥1, Relative Proj, CM-regularity, flattening, Quot, relative Cartier)

- **Required by goal**: yes — RR-free representability of `Pic⁰` (hence `Jacobian C` as a scheme) requires it, and RR is permanently paused so no alternative path exists.
- **Current plan for building it**: a project Čech `Rⁱf_*` build (~800–1200 LOC) with a blueprint chapter authored but "broken internal refs being repaired, then file-skeleton scaffold"; the rest of the engine is held.
- **Timeline**: vague — `~85–140` iters quoted but at `~0/it` realized velocity, so the timeline is aspirational, not demonstrated.
- **Verdict**: CHALLENGE — the planner must either open the `Rⁱf_*` Čech lane in parallel this iter (it is group-law-independent and does not need A.1.c) or stop presenting the engine as "running in parallel." A dominant pole at `~0/it` is the project's true schedule risk, far more than the dual-inverse friction the directive foregrounds.

## Sunk-cost flags

- `25 vs orig ~6–11` (A.1.c.sub budget overrun, stated in the Risks cell) — not itself sunk-cost reasoning (the row does not argue "continue because we've spent 25"), but it is the place a sunk-cost argument would hide. The decision to keep route-2 is correctly justified on merits (stalk is larger), so no live sunk-cost flag — noting it only so the planner keeps the route-2 decision merit-based, not overrun-based.

## Prerequisite verification

- `CommRing.Pic` / `CommRing.Pic.mapAlgebra` / `CommRing.Pic.functor`-analogues: VERIFIED (Mathlib.RingTheory.PicardGroup) — the A.1.c.fun template is real. NB: this is the *affine* Picard group with `Module.Invertible`; the relative/scheme-level RPF is genuinely absent, as the strategy assumes.
- `Module.Invertible` (+ `rank_eq_one`, `free_iff_linearEquiv`): VERIFIED — backs the algebraic analog of invertible⟹loc-free-rank-1.
- `isIso_of_isIso_restrict`: not located by loogle (likely a `TopCat.Sheaf`/local-iso lemma under a different name); LOW risk — the sheaf-local iso criterion is standard. Planner should confirm the exact name before relying on it in D3′/D4′.
- `restrictScalarsRingIsoDualEquiv`, `sliceDualTransport`: project-internal (being built) — not phantom.

## Must-fix-this-iter

- Route A.2.c-engine: CHALLENGE — `Iters left: 85–140` at `~0/it` realized velocity is arithmetically incoherent (finite schedule derived from an undemonstrated 40/it). Either record realized velocity honestly (and mark iters-left `?`) or open the `Rⁱf_*` lane so velocity becomes nonzero.
- Route A.2.c-engine: infrastructure-deferral CHALLENGE — the engine is required by the goal (RR-free representability) yet idles behind the substrate despite being group-law-independent. Open the `Rⁱf_*` Čech scaffold in parallel this iter or drop the "runs in PARALLEL" claim.
- Route A.1.c.sub: throughput CHALLENGE (minor) — decompose `sliceDualTransport` into separately-landable leg-A (Beck–Chevalley slice-Hom base-change) and leg-B (`restrictScalarsRingIsoDualEquiv`) lemmas so progress registers; the "no sorry closed for N iters" signal is a monolith artifact, not a wrong-route signal.
- Format: DRIFTED — file is ~774 bytes over the 12 KB budget; compress the multi-sentence Status cells (A.1.c.sub, A.2.c-engine) to one line each and move closed-item detail (SHARED ROOT, `picCommGroup` DONE) out of inline prose into iter sidecars. Not NON-COMPLIANT; fix opportunistically.

## Overall verdict

The dual-inverse route-2 ordering the directive asks about is the soundest call and should NOT be pivoted: the stalk Plan-B is strictly larger new infrastructure, leg-A is built, and the two remaining leg-B frictions are tactical. I verified there is no cheaper architecture for the RPF group inverse — routing through `picCommGroup` plus an `IsLocallyTrivial⟺IsInvertible` bridge collapses back to the same inverse-existence problem, whose only canonical witness for a loc-triv sheaf is the dual evaluation iso (`dual_restrict_iso`), so the dual is genuinely on the critical path. The real strategic risk is elsewhere: the strategy defers the A.2.c-engine cohomology/Quot stack, which is required for the stated goal (RR-free representability of `Pic⁰`, hence `Jacobian C` as a scheme, with RR permanently paused), to a `~0/it` "parallel" phase whose `85–140`-iter schedule is derived from an undemonstrated velocity — this dominant pole, not the dual friction, is what most threatens completion within the stated envelope. Verdict: SOUND on the dual question; CHALLENGE on the A.2.c-engine sizing/parallelism and the monolith metric; format DRIFTED (minor, over-budget + prose-stuffed cells).
