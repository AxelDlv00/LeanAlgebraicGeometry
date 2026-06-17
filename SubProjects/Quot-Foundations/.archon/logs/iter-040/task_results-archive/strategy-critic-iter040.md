# Strategy Critic Report

## Slug
iter040

## Iteration
040

## Routes audited

### Route: FBC (FBC-A affine lemma + FBC-B globalization)

- **Goal-alignment**: PASS — both obligations terminate at `IsIso pushforwardBaseChangeMap`, which is exactly `lem:affine_base_change_pushforward` / `thm:flat_base_change_pushforward`.
- **Mathematical soundness**: PASS — the reduction to `regroupEquiv` (done) and the mate/conjugate calculus are coherent; the open work is genuinely wiring, not missing math.
- **Sunk-cost reasoning detected**: yes (mild) — see Sunk-cost flags. The proven legs are real reusable assets, but the framing "reused by whichever wins" + escalation-ordering carries a preserve-the-investment tilt.
- **Infrastructure-deferral detected**: no — the affine-reduction obligation (1) is named as a live owed build, not deferred to "future work"/upstream.
- **Phantom prerequisites**: none. `CategoryTheory.Adjunction.leftAdjointCompIso` (+`_hom_app`) VERIFIED in `Mathlib.CategoryTheory.Adjunction.CompositionIso`, so fallback (B) is buildable on real infra.
- **Effort honesty**: under-counted at the low end — "2–5 iters left" with TWO untested fallbacks (A/B) AND a separate, untouched, Mathlib-absent obligation (1) (the A2 affine reduction / restriction-compatibility). The "2" assumes the consult picks right and one fallback closes BOTH obligations in one round; that is optimistic. The 3–5 band is honest.
- **Parallelism under-exploited**: no — FBC-B eqLocus sub-lane is correctly run in parallel with FBC-A.
- **Verdict**: CHALLENGE

The kill-criterion discipline is applied **correctly**: the 3-iter stop fired on the *idiom* (the conjugate-COMPONENT `.injective` reframing), not on the FBC route or the three proven legs. The wall is diagnosed as pure-wiring (the section composite is not a syntactic `conjugateEquiv` value), so additional prover rounds on the same idiom would be sunk cost. Retiring the idiom while keeping conj-2b/2c/2d as a change-of-rings dictionary is the right move — NOT premature.

The CHALLENGE is narrower and concerns **escalation sequencing**, which the directive flags directly. The strategy gates the affine tilde-equivalence transport (the only route that bypasses `gstar_transpose` entirely) strictly behind "the consult's pick closes nothing in its first prover round." But (i) both fallbacks A and B are *conjugate/mate-class* discharges of the same `gstar_transpose`-shaped obligation — A makes the discharge elementwise, B restructures the codomain so `.injective` applies — whereas tilde-transport attacks the prior that `gstar_transpose` is itself the wrong framing; (ii) the idiom that just died was *also* a "make the conjugate machinery close" approach, so there is a non-trivial prior that A/B inherit the same friction; (iii) widening the iter-040 api-alignment consult to score **three** routes (A vs B vs tilde-transport) costs essentially the same as scoring two. Cheapest corrective: have the consult rank A/B/tilde in one pass and surface obligation (1) (the affine reduction) as a parallel lane, rather than pre-committing to A/B and discovering after 2–3 more iters that they share the wall before tilde gets a look.

### Route: GF (generic flatness, geometric wrapper)

- **Verdict**: SOUND — algebraic core done axiom-clean; the geometric wrapper (affine open → finite affine cover → per-patch algebraic form → `D(∏fⱼ)`) is the standard Nitsure §4 globalization; `Module.flat_of_isLocalized_maximal` and `IsLocalization.flat` VERIFIED. G1 is honestly gated on the shared gap1 node rather than duplicated.

### Route: QUOT (Hilbert poly / Quot defs / gap1 producer)

- **Goal-alignment**: PASS — routes through `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`.
- **Mathematical soundness**: PASS — Hilbert-poly encoding via `Polynomial.existsUnique_hilbertPoly` (VERIFIED, `[CharZero]`) + the done graded Hilbert–Serre rationality; gap1 producer = Stacks `lemma-invert-f-sections` (Hartshorne II.5.3).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — gap1's keystone descent is built (consumers axiom-clean); the residual is a concrete decomposed build, not a deferral.
- **Phantom prerequisites**: none verified-missing. `Scheme.Modules.restrictFunctor`/`pullback` asserted present (strategy self-corrected the "no restriction functor" false obstacle); the four sub-gaps a–d are project-side coherence lemmas.
- **Effort honesty**: borderline — see honesty note below. "3–7 iters left, ~180–500 LOC" is a wide band for a phase row that bundles gap1-producer + P2 rank-`r` local-freeness + the annihilator char + def assembly.
- **Parallelism under-exploited**: no — the four QUOT files import only Mathlib and are flagged authorable in parallel; the GF-G1 ∩ QUOT shared gap1 node is correctly slated to be built ONCE QUOT-side.
- **Verdict**: SOUND (with a minor honesty note)

The directive's design-shape question — "should section-transport be done at the sheaf level once, not reassembled per basic open?" — is **answered, not avoided**: the general-`U` cover form is a *known unprovable trap* (recorded as such), so the per-basic-open `Hfr` form is the deliberately-chosen tractable shape, and the 4-iter feeder accretion reflects building the consumers axiom-clean around it, not a producer that keeps growing. The sub-gaps a–d are a *closed* enumeration tied to one geometric construction (basic-open `Hfr`), and the route is backed by a correctly-cited reference (`lemma-invert-f-sections`, stacks-properties §"Sections over principal opens"). This is an honest single remaining geometric build.

Honesty note (not a CHALLENGE): the word "**sole residual**" in the Phases/Risks prose applies to gap1's *descent*, but the QUOT-defs *phase row* still owes P2 rank-`r` local-freeness ("NEXT" in the same Risks cell). The phrasing slightly conflates "gap1 is the sole residual of the descent" with "gap1 is the sole residual of QUOT-defs." Tighten the wording so the estimate is read against the full phase contents.

### Route: GR-proper (Grassmannian properness)

- **Verdict**: SOUND — `AlgebraicGeometry.UniversallyClosed.of_valuativeCriterion` and `IsProper.of_valuativeCriterion` (with `QuasiCompact`/`QuasiSeparated`/`LocallyOfFiniteType` hypotheses) VERIFIED in `Mathlib.AlgebraicGeometry.ValuativeCriterion`. Separatedness done; the Existence valuative criterion (Nitsure §1 DVR-filler) is the real residual and is correctly scoped.

## Format compliance

- **Size**: 156 lines / ~13 KB — within line budget; marginally over the ~12 KB byte hint (dense tables/prose).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order; `## Completed` correctly between Phases and Routes.
- **Per-iter narrative detected**: yes — backward iter-number narrative has colonized the Routes / Phases-Risks / Open-questions prose. Representative: `"did NOT close across iters 037–039 (kill-criterion fired)"`, `"the iter-035 bare element-ext failed for lack of a change-of-rings normal form"`, `"P1 (per-affine local-tilde) DONE iter-034"`, `"kill-criterion fired iter-039"`. (Forward-looking `"iter-040 api-alignment consult"` is planning, acceptable; the backward references are the drift.)
- **Accumulation detected**: no — `## Completed` has 7 rows (within bound), no completed phase lingering in the active table, no excised route still occupying a Routes subsection.
- **Table discipline**: PASS — both tables carry the required columns with short cells; `Status` uses inline tags, `LOC` is a remaining-range.
- **Format verdict**: DRIFTED

Structure, headings, and tables are all compliant; the only drift is the backward per-iter narrative threaded through prose. Cheapest fix: strip the iter numbers from the four phrases above (e.g. replace "did NOT close across iters 037–039 (kill-criterion fired)" with "is exhausted — the conjugate-COMPONENT reframing did not close (kill-criterion fired)"; "P1 … DONE iter-034" → "P1 … DONE"). The "which iter it happened" belongs in the iter sidecar; STRATEGY should state the *current standing* only.

## Sunk-cost flags

- `"the proven conj scaffold (conj-1a/1b/2b/2c/2d, conjPullbackFactor, param helpers) is reused by whichever wins"` — Why this is mild sunk-cost: it frames the fork around preserving the conjugate investment, which biases toward A/B (both conjugate-class) and against the structurally-different tilde-transport route. Recommendation: the legs are genuinely reusable as a change-of-rings *dictionary* regardless of route — keep them on those merits, but let the consult score tilde-transport on equal footing rather than as escalation-only.

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib.RingTheory.Polynomial.HilbertPoly`, `[Field][CharZero]`).
- `AlgebraicGeometry.UniversallyClosed.of_valuativeCriterion`: VERIFIED (`Mathlib.AlgebraicGeometry.ValuativeCriterion`).
- `AlgebraicGeometry.IsProper.of_valuativeCriterion`: VERIFIED (same module; qcqs+LFT ⟹ proper).
- `Module.flat_of_isLocalized_maximal`: VERIFIED (`Mathlib.RingTheory.Flat.Localization`).
- `IsLocalization.flat`: VERIFIED (`Mathlib.RingTheory.Flat.Localization`).
- `CategoryTheory.Adjunction.leftAdjointCompIso` (+ `_hom_app`): VERIFIED (`Mathlib.CategoryTheory.Adjunction.CompositionIso`) — fallback (B) is not phantom.

## Must-fix-this-iter

- Route FBC: CHALLENGE — widen the iter-040 api-alignment consult to score **A vs B vs affine tilde-equivalence transport** in one pass (the cost is ~zero and tilde is the only route that questions the `gstar_transpose` framing the dead idiom shared), and surface obligation (1) (the A2 affine reduction, Mathlib-absent) as a named parallel lane rather than an afterthought. Either adjust STRATEGY's escalation ordering or record an explicit rebuttal in plan.md.
- Format: DRIFTED — strip backward per-iter narrative ("…across iters 037–039", "the iter-035 bare element-ext failed", "DONE iter-034", "fired iter-039") from Routes/Risks/Open-questions prose; state current standing only.

## Overall verdict

The strategy is fundamentally sound and well-aligned with the goal: every named Mathlib prerequisite I checked exists, GF/GR-proper/QUOT rest on real infrastructure and correctly-cited references, and the kill-criterion was applied at the right granularity (retiring the exhausted conjugate-COMPONENT *idiom* while keeping the three proven legs — not premature, because the wall is diagnosed as pure wiring with no missing ingredient). No infrastructure-deferral pattern was found; the QUOT gap1 producer is a genuine single decomposed geometric build, and the directive's "do it at the sheaf level once" question is answered — the sheaf-level cover form is a known unprovable trap, so the per-basic-open shape is deliberate, not accretive avoidance. Two correctives are owed this iter: (1) FBC-A's escalation sequencing — let the iter-040 consult rank the structurally-different tilde-transport route alongside A/B now instead of gating it behind both fallbacks failing, since A and B are both conjugate-class approaches to the same `gstar_transpose` obligation and the FBC-A "2-iter" low-end is optimistic given obligation (1) is still untouched; and (2) a light format cleanup to strip backward per-iter narrative from the prose. Neither is a REJECT — the routes are buildable as written; these are sharpenings, not redirects.
