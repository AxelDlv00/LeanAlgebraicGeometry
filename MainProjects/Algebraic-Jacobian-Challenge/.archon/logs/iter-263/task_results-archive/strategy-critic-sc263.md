# Strategy Critic Report

## Slug
sc263

## Iteration
263

## Routes audited

### Route: A.1.c.sub — comparison iso on line bundles

- **Goal-alignment**: PASS — the comparison iso `f^*(M⊗N)≅f^*M⊗f^*N` is the genuine substrate prerequisite for `IsInvertible.pullback`, which the group/functor layers consume.
- **Mathematical soundness**: PASS — the chart-reduction (upgrade δ to iso via `isIso_of_isIso_restrict` over `{f⁻¹(Uᵢ)}`, each chart reducing to the unit pair via `pullbackUnitIso`) is the standard local-triviality argument.
- **Sunk-cost reasoning detected**: no — the "budget elapsed 26 vs orig ~6–11" overrun is stated honestly as a slip, not used to justify continuation.
- **Effort honesty**: under-counted-but-flagged — the `~0/it` velocity after 26 iters is the single biggest velocity signal in the table; the strategy correctly diagnoses it as a "monolith metric artifact" and prescribes the right fix (decompose `sliceDualTransport` and the comparison-iso paste into landable leg-A/leg-B sub-lemmas). This mitigation must actually be executed this iter, else the row is a stagnation flag.
- **Verdict**: SOUND

### Route: A.1.c.fun — RelPic functor on `IsLocallyTrivial`

- **Goal-alignment**: PASS — RPF on the loc-triv carrier feeds A.2.c representability; the inverse staying inside the carrier (`exists_tensorObj_inverse` returns a loc-triv witness) is the correct closure property.
- **Mathematical soundness**: PASS — `map_add`←comparison iso, `map_zero`←`pullbackUnitIso`, inverse←dual, all on `{M // IsLocallyTrivial M}`, is coherent.
- **Verdict**: SOUND (authored against a typed-sorry bridge; full close correctly gated on A.1.c.sub D4′).

### Route: A.2.c — representability scaffolding (held)

- **Verdict**: SOUND — `⟨sorry⟩`-constructor typeclass scaffolding with Route-A proceeding under it is a legitimate held-phase pattern; discharge fork is explicit.

### Route: A.2.c-engine — Quot/Cartier + `Rⁱf_*` Čech lane

- **Goal-alignment**: PASS — `Rⁱf_*` (i≥1) is the deepest root of A.2.c representability on the RR-free critical path; it is genuinely required, not optional.
- **Mathematical soundness**: PASS — backbone (`Arrow.augmentedCechNerve` + nerve→complex plumbing) is verified Mathlib + axiom-clean project plumbing; the push-pull functor `CechNerve.G` is the standard construction.
- **Infrastructure-deferral detected**: no — the engine is the dominant pole but is NOT deferred-to-upstream: project Čech build (~800–1200 LOC) is the DEFAULT with a concrete LOC figure and an active blueprint chapter (`Cohomology_CechHigherDirectImage`). The "Mathlib PR supersedes if it lands" is a nice-to-have, not the plan. The `Iters left: ?` / `~0→?/it` cells do NOT trip the stagnation rule because there is concrete progress (backbone axiom-clean, blueprint authored, brick to land now).
- **Effort honesty**: under-counted-but-flagged — `~85–140 iters at an UNDEMONSTRATED ~40/it` is honestly labelled undemonstrated with `Iters left: ?`. See the systemic velocity note below.
- **Parallelism under-exploited**: no — opening the brick now is the correct anti-deferral move for the largest pole.
- **Verdict**: SOUND

**Direct answer to the directive's engine question.** Parallel-opening the `Rⁱf_*` lane NOW is **genuine (but marginal) throughput, not busywork** — with one condition. The reasoning:

1. The coupling claim is correct and the sequencing is right. `CechNerve.G.map_comp` for a push-pull functor needs the *bare composition coherence* `pullbackComp`/`pushforwardComp` (the `f^*g^* ≅ (g∘f)^*` iso), and D3′'s remaining `Sq1 sheafificationCompPullback_comp` is exactly that bare pullback composition coherence. So `G`'s hard step genuinely consumes a brick D3′ is building anyway — "consume, don't re-derive" is sound and avoids duplicated cost. Note one subtlety the strategy slightly over-states: `G`'s functor laws need the *bare* `pullbackComp`/`pushforwardComp`, NOT necessarily their *tensor* compatibilities (`pullbackComp_δ`, `pushforwardComp_lax_μ`), which are D3′-specific. The shared piece is the composition iso (Sq1), so the coupling is real but possibly *narrower* than "the same machinery as D3′" implies — meaning `G` may unblock as soon as Sq1 lands, slightly ahead of full D3′. This is upside, and reinforces "land the brick now."

2. The `Gobj`/`Gmap` brick is definition-only (object/morphism assignments), genuinely independent, in a separate file from the substrate. It will be needed regardless. Landing it costs essentially nothing on the critical path.

3. The *only* failure mode is preemption: because the engine's dominant cost (`G` coherence + ~800–1200 LOC Čech build) is sequenced behind D3′ and is not on the binding critical path until much later, the marginal value of the brick landing a few iters early is near-zero for the project end-date. So the brick is legitimate **iff** it consumes idle prover-parallelism and does NOT displace a prover slot from D3′/Sq1 or the dual leg-A/leg-B (the actual critical path). If `loop.max_parallel` is tight, the brick yields. Recommend the strategy state this non-preemption priority explicitly so the row is not later mis-billed as reducing the total iter count.

### Route: A.3 / A.4 / genusZero (gated)

- **Goal-alignment**: PARTIAL (acknowledged) — A.4 Route-1 RR-freeness rests on a divisor↔Pic⁰ dictionary that may transitively pull paused `RiemannRoch_{WeilDivisor,OcOfD}` decls; and the no-`C(k)` `k̄→k` Galois descent for uniform `isAlbaneseFor` is unverified. Both are correctly listed as open questions, not hidden.
- **Effort honesty**: under-counted (self-flagged "likely under-counted" / "absent in Mathlib").
- **Verdict**: SOUND (gated; risks acknowledged as open questions).

### Route: dual route-2 (`sliceDualTransport` by-hand) — RPF group inverse

- **Goal-alignment**: PASS — the dual closes "loc-triv ⟹ ∃ loc-triv inverse with `M⊗N≅𝒪`", which A.1.c.fun's `addCommGroup` inverse requires.
- **Mathematical soundness**: PASS — the obstruction is correctly identified: `Sheaf.monoidalCategory` needs a FIXED `MonoidalCategory A`, but the section-ring-varying tensor has none, so the generic monoidal-dual is unavailable and a by-hand construction is forced. Route-2 (sectionwise: leg-A slice-Hom base-change ∘ leg-B unit ε-iso) vs Plan-B (stalkwise, a fresh `stalkTensorIso`-magnitude build) — route-2 being cheaper is plausible: leg-A is built and leg-B frictions resolved, whereas stalkwise restarts a 6+-decl colimit construction.
- **Cheapest-path re-verification (fresh)**: I checked whether the dual is avoidable. It is NOT: starting from "M loc-triv" (the RPF carrier), you must *construct* the witness `N` — the chart argument "N≅𝒪 locally" presupposes a witness you don't yet have. Building `N` = taking the dual (or an equivalent Čech-glue of inverted transitions, which is no cheaper). And `dual_restrict_iso` is the single linchpin closing BOTH loc-triv-of-dual and the eval-iso local pieces. So route-2's by-hand dual is the right and cheapest linchpin.
- **Verdict**: SOUND

## Format compliance

- **Size**: 148 lines / ~11–12 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — `"COUPLED to D3′ (REFINED iter-263)"` (line 100/102) and `"sc262 confirmed route-2 cheaper"` (line 48) embed explicit iter/slug references; `ma-legb262.md`, `engine252.md` embed iter numbers in pointers (borderline). Per-iter markers belong in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: no — Route C (paused) and genus-0 arm (b) are retained as live architectural context (the RR-free path exists *because* RR is paused), not as dead routes; "DONE axiom-clean" mentions are contextual justification, not stale phases.
- **Table discipline**: PASS-with-drift — proper Markdown table with the correct columns, but several `Status` cells carry multi-clause prose (esp. A.1.c.sub and A.2.c-engine) rather than "one short line."
- **Format verdict**: DRIFTED

## Effort honesty — systemic note

The entire ~120–230-iter total rests on an assumed ~40–50 LOC/it future velocity (A.2.c-engine `~40/it`; A.3 implies ~40–47, A.4 ~50). The only *active* phase (A.1.c.sub) is realizing this at `~0/it` (even granting the monolith-artifact explanation). Every other row reads `0/it` only because it is not yet started. So no row carries demonstrated velocity matching the schedule's assumption. This is not a fantasy *within any single row* (each is internally consistent and the engine row honestly marks `Iters left: ?`), but the *aggregate* total is optimistic. Recommendation: treat the decomposition of A.1.c.sub into landable leg-A/leg-B/Sq1 sub-lemmas this iter as the velocity proof-of-concept; if those land at a real rate, the ~40/it assumption gains evidence; if they too stall at ~0/it, the total must widen.

## Overall verdict

The strategy is SOUND. The directive's central call — open the `Rⁱf_*` engine lane's independent `Gobj`/`Gmap` brick in parallel now, but sequence `CechNerve.G`'s coherence after D3′ to consume (not re-derive) the shared `pullbackComp`/`pushforwardComp`/Sq1 composition coherence — is correct: it is genuine (if marginal) throughput and the *right anti-deferral move* for the project's largest pole, NOT busywork, provided the brick consumes idle parallelism and does not preempt the true critical path (D3′/Sq1 + dual leg-A/leg-B). The coupling is real but possibly narrower than stated (G needs the bare composition iso, not D3′'s tensor δ/μ compatibilities), which is upside. The dual route-2 by-hand `sliceDualTransport` is re-confirmed as the cheapest linchpin to the RPF group inverse — the dual is unavoidable (the loc-triv carrier forces *constructing* the witness) and `dual_restrict_iso` closes the whole remaining inverse chain. No row's estimate is internally fantastical, but the aggregate ~120–230-iter total rests on an undemonstrated ~40–50 LOC/it; the A.1.c.sub decomposition this iter is the test of that assumption. The only must-fix is cosmetic-but-real: format is DRIFTED — strip the `iter-263`/`sc262` per-iter references and shorten the long `Status` cells in-place.

## Must-fix-this-iter

- Format: DRIFTED — strip per-iter references (`(REFINED iter-263)`, `sc262 confirmed route-2 cheaper`) and shorten the multi-clause `Status` cells in A.1.c.sub / A.2.c-engine. In-place edit, no restructure needed.
- A.2.c-engine row: add an explicit non-preemption priority — the `Gobj`/`Gmap` brick runs only on idle parallel capacity and must not displace a prover slot from D3′/Sq1 or dual leg-A/leg-B; do not bill the lane as reducing the total iter count until D3′ lands.
