# Strategy Critic Report

## Slug
iter044

## Iteration
044

## Routes audited

### Route: FBC (`lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`)

- **Goal-alignment**: PASS — `thm:flat_base_change_pushforward` is named verbatim in `## Goal`; the route targets exactly it.
- **Mathematical soundness**: PASS — Stacks 02KH part 2 → module-level `regroupEquiv` (DONE) → globalize via finite-equalizer flat-tensor preservation is a correct decomposition.
- **Sunk-cost reasoning detected**: no — the opposite. The strategy *abandons* two routes (conjugate, tilde-transport) after exhausting them and argues affirmatively (frozen map `g'=pullback.fst` has no element normal form ⟹ any section read IS the conjugate intertwining) that no section-level bypass exists. That is genuine due diligence, not "we've sunk N iters so keep going."
- **Infrastructure-deferral detected**: yes — keystone `_legs_conj` (build composite adjunctions `adjL`/`adjR` + comparison `β` + `(conjugateEquiv adjL adjR).injective`). Required by the goal. The strategy describes it as a "multi-hundred-LOC bespoke construction unassemblable in one prover session" and parks it pending "a future dedicated mathlib-build lane" OR "a user-driven dedicated session" — no committed project-side timeline. Under the AUTONOMOUS directive (no user escalation), "awaits user session" is deferral-with-no-plan. See finding below.
- **Phantom prerequisites**: none — the conjugate calculus legs (conj-2b/2c/2d) are reported axiom-clean; `regroupEquiv` is DONE (in `## Completed`).
- **Effort honesty**: reasonable — `~250–500 LOC / 4–8 iters` for a 5-stacked-adjunction bespoke build is honest (arguably the only honest large estimate in the table).
- **Parallelism under-exploited**: yes — FBC-A2 (affine/locality reduction, blueprint EXISTS, independent of the parked A1 *and* of gap2) is marked ACTIVE but is not on the dispatched live frontier; it is buildable now.
- **Verdict**: CHALLENGE

### Route: GF (`thm:generic_flatness`, algebraic core DONE)

- **Verdict**: SOUND — algebraic core `genericFlatnessAlgebraic` DONE; geometric wrapper is a clean affine-cover + per-patch argument; key Mathlib prereq `Module.flat_of_isLocalized_maximal` VERIFIED to exist. Gated on gap2/Piece A (see concentration-risk note in Overall verdict), not on phantom infra.

### Route: QUOT (`def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable`)

- **Goal-alignment**: PASS — the four declarations are the goal's QUOT bullet.
- **Mathematical soundness**: PASS — Hilbert-poly-as-graded-Hilbert-function via `existsUnique_hilbertPoly` + `gradedHilbertSerre_rational` (DONE) is sound; `existsUnique_hilbertPoly` VERIFIED (CharZero, matches the Q3 standard-graded fence).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — `def:sectionGradedRing` tensor powers (`SheafOfModules` `L_s^{⊗m}` + lax-monoidal `Γ`). Required by the goal: `def:hilbert_polynomial` is *defined* via `m ↦ dim Γ(X_s, F_s ⊗ L_s^m)`, so the tensor powers are needed even to state it. Marked BLOCKED "Mathlib-gradient ... owed before SNAP" with no concrete start and no decomposition. See finding below.
- **Phantom prerequisites**: none confirmed — `SheafOfModules.IsQuasicoherent` / `QuasicoherentData` / `IsQuasicoherent.of_coversTop` all VERIFIED, which is exactly the cover-refinement infra Piece A is built on.
- **Effort honesty**: reasonable for gap2/Piece A (2–4 iters for a QC-pullback-stability lemma with existing `of_coversTop` support); QUOT-repr `~400–1000+ / 6–12` is honestly wide.
- **Parallelism under-exploited**: yes — SNAP tensor-powers is independent of gap2 yet sits BLOCKED behind the gap2 frontier.
- **Verdict**: CHALLENGE (on the SNAP-tensor-powers deferral within the QUOT chain; the gap2/annihilator/P2 sub-route itself is SOUND).

## Format compliance

- **Size**: 135 lines / ~9 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — pervasive in `## Routes` and `## Open strategic questions` prose: `"conjugate route EXHAUSTED (5 iters 037–041)"`, `"PIVOT — affine tilde-transport — DIED (iter-043)"`, `"Element-ext (iter-035) also dead"`, `"7 in-loop iters (037–043) could not assemble"`, `"iter-044: a focused mathlib-analogist de-risks"`, `"Piece B ... DONE iter-043"`, `"decomposed into a route-1 5-step chain iter-044"`. Per-iter history belongs in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: yes (mild) — the `## Routes` FBC subsection retains two excised dead routes (conjugate, tilde-transport) as prose obituaries; and the `## Phases & estimations` Risks cells carry multi-clause prose with embedded iter refs (e.g. FBC-A1 Risks: `"in-loop prover exhausted (037–043). Needs dedicated bottom-up build of adjL/adjR/β; iter-044 analogist de-risk."`). Both should compress to the strategic fact, with the iter history living in the sidecar.
- **Table discipline**: PARTIAL — columns are correct, but several Risks / Key-Mathlib cells are bloated multi-sentence prose rather than one short line.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: FBC keystone `_legs_conj` (`adjL`/`adjR`/`β` + `conjugateEquiv` injective)

- **Required by goal**: yes — it is the sole remaining gap between `regroupEquiv` (done) and `thm:flat_base_change_pushforward`, which `## Goal` names verbatim.
- **Current plan for building it**: decomposed in prose (adjL/adjR + β + injective) and an analogist de-risks the Mathlib idiom THIS iter — but the actual build is assigned to "a future dedicated mathlib-build lane" or "a user-driven dedicated session," i.e. no committed iter.
- **Timeline**: vague — phase row says `4–8 iters left` but Status is PARKED with no dispatch trigger; the prose explicitly conditions the build on a future/user lane.
- **Verdict**: CHALLENGE — Parking as a *sequencing* choice this iter is defensible (FBC blocks no other route; QUOT/GF are the converging frontier; the analogist is a sound first step). What is NOT acceptable is treating `_legs_conj` as one monolithic "unassemblable in a single session" block deferred indefinitely. The fix is exactly the decomposition the deferral-rule demands: commit `adjL` → `adjR` → `β` → `(conjugateEquiv …).injective` as *separate sequential prover lanes across iters* with per-step estimates, contingent on the analogist's verdict. "Unassemblable in one session" is an argument FOR multi-iter decomposition, not for parking.

### Deferred: SNAP `def:sectionGradedRing` / `SheafOfModules` tensor powers `L_s^{⊗m}` + lax-monoidal `Γ`

- **Required by goal**: yes — `def:hilbert_polynomial` (a `## Goal` declaration) is defined through `Γ(X_s, F_s ⊗ L_s^m)`; without the tensor powers the definition cannot be stated, and QUOT-repr further consumes SNAP.
- **Current plan for building it**: none with a timeline — "Mathlib-gradient sub-build owed before SNAP," not decomposed, BLOCKED behind the gap2 frontier despite being independent of gap2.
- **Timeline**: absent.
- **Verdict**: CHALLENGE — this is buildable-now Mathlib-gradient infra that is gated on nothing but prover attention. It should be decomposed (define `L_s^{⊗m}`; establish the graded structure on `⨁_m Γ(L_s^{⊗m})`; lax-monoidal `Γ`) and a first sub-phase started in parallel with gap2, rather than sitting in indefinite BLOCKED.

## Sunk-cost flags

(none — the FBC route is the rare case of *correctly abandoning* sunk routes; do not let the CHALLENGE above be misread as "keep grinding the conjugate route.")

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED — `[Field F] [CharZero F]`, matches the Q3 standard-graded/CharZero fence.
- `Module.flat_of_isLocalized_maximal`: VERIFIED — `Mathlib.RingTheory.Flat.Localization`, the flat-locality assembly GF-geo G3 needs.
- `SheafOfModules.IsQuasicoherent`, `…QuasicoherentData`, `IsQuasicoherent.of_coversTop`: VERIFIED — the exact cover-refinement infra Piece A (`isQuasicoherent_pullback_fromSpec`) is built on; the pullback-stability lemma itself is correctly reported Mathlib-absent.

## Alternative routes (suggested)

(No fresh *proof* alternative for FBC — the strategy's frozen-map normal-form argument credibly closes off section-level bypasses, and I could not find a section-free route the strategy hasn't already considered. The actionable corrective is decomposition/parallelization, captured under the deferral findings, not a new route.)

## Must-fix-this-iter

- Route FBC: infrastructure-deferral CHALLENGE — keystone `_legs_conj` required by goal, parked with no committed timeline ("future lane / user session"). Planner must either (a) commit a decomposed multi-iter build plan (adjL → adjR → β → injective as sequential lanes, contingent on this iter's analogist verdict) with per-step estimates, or (b) record an explicit rebuttal in `iter/iter-044/plan.md` justifying continued parking AND naming the concrete event that will trigger the build.
- Route QUOT: infrastructure-deferral CHALLENGE — `def:sectionGradedRing` tensor powers required by goal (`def:hilbert_polynomial`), BLOCKED with no decomposition though independent of gap2. Planner must decompose it and either start a sub-phase in parallel or record why it waits.
- Parallelism: SNAP tensor-powers AND FBC-A2 are independent of the gap2/Piece A frontier yet idle. The live frontier is over-concentrated on a single Mathlib-absent lemma (Piece A) that feeds BOTH QUOT-annihilator AND GF-G1 — a single point of failure. Dispatch at least one independent infra lane in parallel.
- Format: DRIFTED — strip per-iter narrative from `## Routes` / `## Open strategic questions` prose into `iter/iter-044/plan.md`; compress bloated Risks cells and the two dead-route obituaries to the strategic fact only. (Bare iter numbers in the `## Completed` `Iters` cell are fine — those stay.)
- Hidden prerequisite (Q3): `thm:relative_spec_univ` (RelativeSpec, `Picard_RelativeSpec.tex`) underpins QUOT-repr (`Grassmannian.RepresentableBy`) but is neither a phase row nor in `## Completed`, and `references/summary.md` flags real tag uncertainty for its source (01LL is a section label, 01LO is transitivity-not-affine, 01LR is the defining eqn; the true affine-base-case tags 01LM/01LP/01LT are only "likely"). Surface RelativeSpec as its own tracked obligation and pin the Stacks tag before QUOT-repr is dispatched.

## Overall verdict

The leg-fan strategy is fundamentally sound and goal-aligned: every named deliverable maps to a route, the load-bearing Mathlib prerequisites I checked (`existsUnique_hilbertPoly`, `flat_of_isLocalized_maximal`, the `IsQuasicoherent`/`QuasicoherentData`/`of_coversTop` stack) all exist, and the FBC abandonment of two exhausted routes is disciplined rather than sunk-cost. No route is rejected. But two infrastructure-deferral CHALLENGES must be named explicitly: **the strategy defers the FBC keystone `_legs_conj`, which is required for the stated goal `thm:flat_base_change_pushforward`**, to an uncommitted "future lane / user session" rather than decomposing it into startable sequential sub-lanes; and **the strategy defers the SNAP `def:sectionGradedRing` tensor powers, which are required for the stated goal `def:hilbert_polynomial`**, to an undated "Mathlib-gradient sub-build" though it is independent of the current frontier. Parking FBC this iter is acceptable purely as a sequencing decision (it blocks nothing, QUOT/GF converge, the analogist de-risks) — it is NOT acceptable as indefinite deferral of a headline deliverable; the corrective is a committed decomposition, not a different proof route. Separately, the live frontier is over-concentrated on the single Mathlib-absent lemma Piece A (feeding both QUOT and GF), while two independent infra builds sit idle — parallelize. Format has DRIFTED: per-iter narrative has colonized `## Routes` and `## Open strategic questions`; move it to the iter sidecar and compress the bloated table cells.
