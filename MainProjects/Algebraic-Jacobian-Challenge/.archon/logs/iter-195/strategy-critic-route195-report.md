# Strategy Critic Report

## Slug
route195

## Iteration
195

## Routes audited

The directive frames four explicit decisions to verify; I audit each
in turn, treating "iter-195 routing pivot" as the synthetic route
that the plan-phase actually introduced this iter.

### Route: Iter-200 carrier-soundness commitment

- **Goal-alignment**: PARTIAL — the project's stated end-state is
  "zero inline `sorry`, kernel-only axioms (`propext`,
  `Classical.choice`, `Quot.sound`)". The carrier-soundness refactor
  is precisely the work that converts 7+ load-bearing typed
  `:= sorry` carriers (Pic0Scheme, PicScheme, QuotScheme, picSharp,
  divFunctor, abelMap, PicSharp, presheaf, PicSharp.etSheaf) from
  silent `sorryAx`-propagating data definitions to something the
  axiom-check can validate. Deferring it five iters does not break
  alignment, but ALL closure work landed in iters 195-199 on top of
  these carriers inherits the soundness problem. The refactor is on
  the critical path for the end-state contract, full stop.
- **Mathematical soundness**: PASS — the three design options
  enumerated (existential `Nonempty (Σ' S, ...)`, opaque-axiom,
  structure-of-data) are mathematically distinct and the choice
  among them is real. Consultation here is not vacuous.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — the carrier-soundness
  refactor IS the deferred construction. The stated goal (kernel-only
  axioms) requires it. STRATEGY.md does carry a concrete iter slot
  (iter-200) with rationale, so the deferral is no longer "sliding"
  per se, but the slot choice is brittle (see "Risks" below).
- **Phantom prerequisites**: none — the project already runs
  `lean_verify` and the carriers are diagnosed.
- **Effort honesty**: under-counted — the strategy does not estimate
  the LOC / iter cost of the refactor itself. "Blast radius: 5 files
  + Pic0AbelianVariety consumer + blueprint prose" is not a budget.
  A refactor that reshapes 7+ load-bearing carriers across 5 files
  with downstream consumers is realistically 2-4 iters of dedicated
  prover dispatch + 1 iter of fallout-repair on dependents. The
  strategy treats it as if it slots cleanly into a single iter-200
  plan-phase.
- **Parallelism under-exploited**: n/a — the refactor is inherently
  serial.
- **Verdict**: CHALLENGE — see two specific concerns below:
  1. **The reversal trigger is unfit for purpose.** The trigger
     reads: "if any iter-196-199 prover lane exhibits a load-bearing
     typeclass synthesis resolving to a `:= sorry` carrier, pull the
     refactor forward". The whole reason the iter-193 lean-auditor
     flagged this as a soundness issue is that the propagation is
     SILENT through typeclass synthesis — no prover lane will
     "exhibit" it because the propagation doesn't error or warn. A
     trigger that requires a symptom that by construction does not
     surface is no trigger at all.
  2. **The iter-200 slot is timing-coincidence, not principle.**
     The justification is "co-scheduled with the mandatory
     mathlib-analogist sweep". But the sweep cadence is itself an
     arbitrary every-10-iter convention. A principled slot would be
     "iter-196, because every additional iter of dispatch on the
     current carriers compounds the number of sorryAx-tainted
     downstream theorems and we have N such carriers feeding K
     active downstream lanes". The plan-phase had the option to
     fire a directed mathlib-analogist consult on JUST the carrier
     question this iter and slot the refactor at iter-196 or
     iter-197. It chose the latest defensible slot instead.

### Route: Iter-195 close-focused dispatch (Lane H + BareScheme + Lane E)

- **Goal-alignment**: PARTIAL — these three targets land project-side
  substrate, not direct sorry closures on the protected declarations.
  Lane H builds a `PreservesHomology` typeclass instance, BareScheme
  is a NEW LANE creating scaffold, Lane E builds a chart-1 evaluation
  corollary. The framing "close-focused dispatch" is misleading:
  none of these three lanes close an existing typed sorry; all three
  CREATE new substrate that will eventually be consumed by closure
  work. The diagnosis (iter-194 had 8/10 HARD BARs MET but only 1
  net sorry closure) is correctly identified as the "lazy" failure
  mode, but the prescription (these three lanes) does not actually
  address it — substrate-building remains substrate-building whether
  the LOC is 30 or 300.
- **Mathematical soundness**: PASS — each of the three targets has a
  defensible mathematical content.
- **Sunk-cost reasoning detected**: yes — "iter-194 isolated [X] —
  a single-step closure surface" appears for all three lanes.
  Treating prior-iter isolation as a reason to dispatch THIS iter
  is the very momentum-reasoning the strategy-critic exists to
  flag. The right question is "which lanes have the highest
  expected-sorry-closure-per-iter", which is not the same as "which
  lanes did iter-194 narrow most successfully".
- **Infrastructure-deferral detected**: no (for these lanes
  specifically — see the bottom-up route below for the deferred
  roots).
- **Phantom prerequisites**: I did not spot-verify
  `(sheafCompose forget₂).PreservesHomology` in Mathlib — the plan
  should have done this before committing Lane H as a project-side
  build. There may be an existing instance that makes Lane H a
  one-line `inferInstance` rather than a 50-120 LOC project build.
  The mathlib-analogist sweep that's been pushed to iter-200 is
  precisely the kind of pre-flight check that should have run
  this iter.
- **Effort honesty**: reasonable — the per-lane LOC bands are
  modest and consistent with one-iter closure work.
- **Parallelism under-exploited**: no — three lanes is a defensible
  parallel fan-out for the typical Archon prover-pool capacity.
- **Verdict**: CHALLENGE — re-frame as substrate-building, not
  "close-focused", and pre-flight Lane H via a directed
  mathlib-analogist or `lean_loogle` query before dispatch. The
  re-framing matters because it makes clear that this iter is
  spending its capacity on substrate while the actual root substrate
  (A.3.i, Lane M↓, A.4.b) sits idle — see next route.

### Route: Bottom-up execution priority (honored vs. abandoned)

- **Goal-alignment**: FAIL — STRATEGY.md's own `## Bottom-up
  execution priority` section lists six roots in priority order:
  (1) A.3.i, (2) Lane M↓, (3) A.4.b, (4) A.3.0, (5) A.2.a,
  (6) A.2.b. The iter-195 dispatch covers exactly zero of those
  six. Lane I substrate (BareScheme) is NOT on the priority list;
  Lane H and Lane E are NOT on the priority list. Roots #1-#3 are
  explicitly deferred to iter-200 with the blanket rationale "all
  are Mathlib-gap-blocked". This rationale does not survive
  scrutiny:
  - **A.3.i** (root #1): the strategy table itself says "substrate
    OWNED in Mathlib (`Geometrically/Connected.lean:100`); 1 helper
    Stacks 04KU + plumbing remaining". Not Mathlib-blocked — the
    helper is a project-side build.
  - **Lane M↓** (root #2): strategy table reports ~50/it velocity
    with Stages 1-2 axiom-clean iter-191 and
    `IsStandardSmooth.iff_exists_basis_kaehlerDifferential` ✓
    (present in Mathlib). Not Mathlib-blocked.
  - **A.4.b** (root #3): strategy table reports ~50/it velocity
    with "G1 cotangent dim drop landed; G2 substrate narrowed;
    route (iii) unlocked iter-191". Not Mathlib-blocked.
  The plan-phase's blanket rationale contradicts the strategy
  table on three of three counts.
- **Mathematical soundness**: PASS — the priority order itself is
  defensible; the issue is that it's not being followed.
- **Sunk-cost reasoning detected**: yes — "iter-194 narrowed [X]
  to a single shared idiom blocker" is being used to JUSTIFY
  iter-195 dispatch on non-priority lanes. The narrowing happened;
  that does not by itself argue for spending iter-195 capacity on
  these lanes rather than on the priority roots that have HIGHER
  velocity (Lane M↓ + A.4.b both at ~50/it vs. the iter-195 lanes
  at ~30-50 LOC each).
- **Infrastructure-deferral detected**: yes — see "Infrastructure-
  deferral findings" below for A.3.i, Lane M↓, A.4.b specifically.
- **Phantom prerequisites**: none in the priority order itself.
- **Effort honesty**: under-counted at the meta-level — the
  strategy claims iter-195 is "close-focused" but the lanes
  dispatched are substrate-building, while the lanes that would
  actually close sorries (Lane M↓ has cumulative ~50/it, A.4.b
  has cumulative ~50/it) are deferred.
- **Parallelism under-exploited**: yes — the priority order
  explicitly says "cheapest-first; mostly parallel" for roots #1-#4
  (A.3.i, Lane M↓, A.4.b, A.3.0). The iter-195 dispatch serializes
  these behind the iter-200 sweep. Three to four of these roots
  could be dispatched in parallel with the iter-195 lanes; the
  strategy gives no reason why they aren't.
- **Verdict**: CHALLENGE — the iter-195 plan either honors the
  bottom-up priority (in which case Lane M↓ and A.4.b dispatch
  this iter alongside the three close-focused lanes) or it
  explicitly amends the priority order in STRATEGY.md with a
  rationale. Silently deferring roots #1-#3 while citing a
  rationale that contradicts the strategy table is not acceptable.

## Format compliance

- **Size**: 227 lines / 18 368 bytes — over budget (~250 lines OK
  but ~12 KB budget exceeded by 53%; bytes are the binding limit).
- **Headings**: FAIL — canonical skeleton is `## Goal`,
  `## Phases & estimations`, `## Routes`, `## Open strategic
  questions`, `## Mathlib gaps & new material`. STRATEGY.md adds
  two extra top-level sections: `## Bottom-up execution priority`
  and `## Iter-195 routing pivot (recorded)`. The bottom-up
  section is strategy content that belongs as a prose paragraph
  inside `## Routes`. The iter-195 routing-pivot section is
  per-iter narrative that belongs in `iter/iter-195/plan.md`,
  NEVER in STRATEGY.md.
- **Per-iter narrative detected**: yes — pervasive. Representative
  quotes verbatim:
  - "iter-194 progress-critic STUCK + OVER_BUDGET (re-est 14→20
    against 14 elapsed since iter-180; total proj 28-34 iters —
    fantasy band); iter-194 corrective: ELEVATE Stacks 037Q as
    first-class blueprint obligation (chapter edit landed iter-194
    plan-phase)" — in the A.3.i row alone.
  - "iter-191 SUCCESS — 4 of 8 decls axiom-clean from skeleton;
    iter-192 Hartshorne III.2.5 body push" — RR.2.H¹ row.
  - "iter-194 progress-critic CHURNING + OVER_BUDGET (16 elapsed;
    total proj 32-38 — extreme); iter-194 corrective:
    blueprint-expansion (sub-lemma decomposition for Pin 3 Step 2
    helpers (a)+(d) at iter-195+)" — RR.4 row.
  - The entire `## Iter-195 routing pivot (recorded)` section.
- **Accumulation detected**: yes — A.1.b row reads "DONE iter-188
  (axiom-clean) | — | — | — | —" which is a placeholder for a
  completed phase that should have been EXCISED from the table
  once done. Completed phases must shrink the file, not occupy
  rows with dashes.
- **Table discipline**: FAIL — multiple cells contain multi-clause
  prose with embedded semicolons, parentheticals, and iter-tag
  narrative (A.3.i, RR.4, A.4.d.0). The canonical rule is "one
  short line per cell". The A.3.i status cell alone is ~200
  characters across multiple semantic clauses.
- **Appendix sections**: `## Iter-195 routing pivot (recorded)`
  functions as an appendix and is a clear violation.
- **Format verdict**: NON-COMPLIANT — restructure this iter, not
  next iter. The pattern of inlining iter-NNN narrative into
  cells is what makes STRATEGY.md grow without bound, which in
  turn bleeds into every future plan-agent context window.

## Infrastructure-deferral findings

### Deferred: Carrier-soundness refactor (7+ load-bearing typed `:= sorry` carriers)

- **Required by goal**: yes — the stated end-state contract is
  "zero inline `sorry`, kernel-only axioms". Silent
  `sorryAx`-propagation through typeclass synthesis means downstream
  proofs that appear sorry-free at the source level still depend on
  `sorryAx` in their kernel term. The challenge file's protected
  declarations have to pass `lean_verify` with kernel-only axioms;
  any carrier feeding their type or data lineage must therefore be
  refactored.
- **Current plan for building it**: STRATEGY.md commits iter-200,
  co-scheduled with the mathlib-analogist sweep. The three design
  options (existential / opaque-axiom / structure-of-data) are
  enumerated.
- **Timeline**: concrete (iter-200) BUT the per-iter LOC budget for
  the refactor itself is not estimated, and the reversal trigger is
  unfit for purpose (a silent-propagation failure mode cannot
  produce the visible symptom the trigger requires).
- **Verdict**: CHALLENGE — accept the iter-200 slot only if (a) the
  reversal trigger is rewritten to fire on something observable
  (e.g., "if iter-196-199 lands ≥ K downstream theorems that
  `lean_verify` shows depend on a carrier's sorryAx, pull forward")
  and (b) the strategy carries a concrete LOC + iter estimate for
  the refactor itself. Otherwise pull it forward to iter-196 or
  iter-197.

### Deferred: A.3.i helper + Lane M↓ + A.4.b (bottom-up priority roots #1-#3)

- **Required by goal**: yes — A.3.i is required for `Pic⁰` to be a
  group scheme (the entire A.3 chain); Lane M↓ is required for
  smoothness chain (CodimOneExtension); A.4.b is required for
  Albanese UP / Thm 3.2 assembly.
- **Current plan for building it**: STRATEGY.md positions all three
  as iter-200 mathlib-analogist sweep candidates and dispatches none
  of them this iter.
- **Timeline**: absent for iter-195; vague ("iter-200 sweep") going
  forward. The sweep itself does not BUILD the substrate — it only
  audits Mathlib for fresh landings.
- **Verdict**: CHALLENGE — at least one of Lane M↓ or A.4.b should
  dispatch this iter (both have ~50/it realized velocity per the
  strategy table; neither is Mathlib-gap-blocked). Deferring root #1
  (A.3.i) is defensible if the planner judges the helper-accumulation
  pattern justifies a pause, but deferring all three with a
  contradictory rationale is not.

## Alternative routes (suggested)

### Alternative: Pull carrier-soundness refactor to iter-196 with a directed mathlib-analogist consult this iter

- **What it looks like**: this iter, fire a `mathlib-analogist`
  subagent narrowly scoped to "which of {existential, opaque-axiom,
  structure-of-data} is the right encoding for the 7+ load-bearing
  Pic / Quot / Pic⁰ carriers in this project?". Receive verdict
  this iter. Iter-196 dispatches the refactor. Iter-197 onward
  resumes downstream lane work on now-sound carriers.
- **Why it might be cheaper or sounder**: it spends ≤1 mathlib-
  analogist dispatch this iter to unblock iter-196 instead of
  waiting 5 iters for the periodic sweep. It limits the downstream-
  sorryAx-pollution window to 1 iter instead of 5. The refactor
  cost is the same; only the timing shifts.
- **What the current strategy may have rejected**: the strategy
  treats the mathlib-analogist sweep as a single combined
  "audit-all-substrates + answer-carrier-question" event. A
  directed iter-195 consult is a feasible decomposition the
  strategy did not consider.
- **Severity of the omission**: major.

### Alternative: Use this iter's substrate-building capacity on Lane M↓ + A.4.b in parallel with one of the three iter-195 lanes

- **What it looks like**: drop one of {Lane H, BareScheme, Lane E}
  (whichever has the largest mathlib-coverage uncertainty — likely
  Lane H), and dispatch Lane M↓ and A.4.b instead. Both have
  ~50/it realized velocity; both are bottom-up priority roots;
  neither is Mathlib-gap-blocked.
- **Why it might be cheaper or sounder**: it actually honors the
  bottom-up priority that STRATEGY.md itself ordained, instead of
  contradicting it. It also gets two priority-root lanes off
  "stalled" status, which is what iter-194's progress-critic
  apparently flagged in the first place.
- **What the current strategy may have rejected**: the strategy
  appears to interpret iter-194's "8 BARs MET but 1 net closure"
  signal as "spend iter-195 on lanes where iter-194 narrowed
  things", which biases toward continuing the most-recently-touched
  lanes. The bottom-up priority is a more durable allocation
  signal than recent-narrowing.
- **Severity of the omission**: major.

## Sunk-cost flags

- `"iter-194 isolated SAb.Exact — a single typeclass goal ...
  iter-195 dispatch: direct attack"` — Why this is sunk-cost: the
  argument leans on prior-iter narrowing as the reason to dispatch
  this iter, rather than independently justifying the lane against
  alternatives. Recommendation: re-justify against the bottom-up
  priority list; if Lane H wins on merits, fine, but the
  narrowing-in-iter-194 fact alone is not the reason.

- `"iter-194 narrowed the chart-1 Proj.awayι.appIso ⊤ .inv
  evaluation residual to a single shared idiom blocker"` — Why
  this is sunk-cost: same pattern. The "single shared idiom"
  framing may or may not be true, but the iter-194 narrowing is
  not a strategy-level reason to dispatch.

## Must-fix-this-iter

- Route "Iter-200 carrier-soundness commitment": CHALLENGE —
  rewrite the reversal trigger to fire on an observable signal
  (e.g., `lean_verify` showing N downstream theorems depend on a
  carrier's sorryAx), AND add a concrete LOC + iter estimate for
  the refactor. If neither can be done, pull forward to iter-196.
- Route "Iter-195 close-focused dispatch": CHALLENGE — re-frame
  as "substrate-building dispatch" (these three lanes are not
  closing existing sorries), and run a pre-flight mathlib-check
  on Lane H's `(sheafCompose forget₂).PreservesHomology` before
  committing project-side LOC.
- Route "Bottom-up execution priority": CHALLENGE — either
  dispatch at least one of {Lane M↓, A.4.b} this iter (both have
  ~50/it velocity and are NOT Mathlib-gap-blocked per the strategy
  table itself), or amend the priority order in STRATEGY.md with
  a rationale that does not contradict the table.
- Infrastructure-deferral (carrier-soundness): CHALLENGE — see
  reversal-trigger fix above.
- Infrastructure-deferral (A.3.i helper + Lane M↓ + A.4.b): CHALLENGE
  — the blanket rationale "all are Mathlib-gap-blocked" contradicts
  STRATEGY.md's own table. Either fix the table (if the lanes are
  in fact blocked) or fix the dispatch (if they aren't).
- Alternative "directed mathlib-analogist consult this iter":
  major omission — the strategy did not consider decomposing the
  iter-200 sweep into a directed iter-195 consult + full sweep
  later.
- Alternative "Lane M↓ + A.4.b in parallel with one iter-195 lane":
  major omission.
- Format: NON-COMPLIANT — (1) excise `## Bottom-up execution
  priority` and `## Iter-195 routing pivot (recorded)` as
  top-level sections; merge the bottom-up content into `## Routes`
  as one prose paragraph and move the iter-195 pivot text to
  `iter/iter-195/plan.md`. (2) Strip per-iter narrative from
  table cells (especially A.3.i, RR.4, A.4.d.0) — replace with
  "stalled (helper-accumulation)" or "stalled (over-budget)" tags
  and let the iter sidecars hold the per-iter detail. (3) Excise
  the A.1.b "DONE" placeholder row. Target 12 KB / ≤200 lines.

## Overall verdict

CHALLENGE. The plan-phase made two real improvements this iter
(pinning carrier-soundness to a concrete slot, and explicitly
naming three iter-195 lane targets), but each comes with a
defect:

1. **The strategy defers carrier-soundness refactor to iter-200**,
   which is required for the stated goal of kernel-only axioms.
   The deferral is acceptable in principle but the reversal trigger
   ("if any iter-196-199 prover lane exhibits a load-bearing
   typeclass synthesis resolving to a `:= sorry` carrier") cannot
   fire because the failure mode is silent by construction.
   Either rewrite the trigger or pull the slot forward to iter-196.
2. **The strategy defers bottom-up execution priority roots #1-#3
   (A.3.i helper, Lane M↓, A.4.b)** with a rationale ("all are
   Mathlib-gap-blocked") that contradicts the strategy's own table
   (Lane M↓ and A.4.b both show ~50/it realized velocity with
   project-side substrate, not Mathlib gaps). Either the table is
   wrong or the dispatch is wrong; both cannot stand simultaneously.
3. **The iter-195 dispatch is not "close-focused" — it is
   substrate-building** (Lane H builds a typeclass instance,
   BareScheme is a NEW LANE, Lane E builds a chart-1 evaluation
   corollary). The diagnosis of iter-194's "1 net closure"
   problem is correctly identified but the prescription does not
   address it.
4. **Format is NON-COMPLIANT**: 18 KB vs. 12 KB budget; two extra
   top-level sections (one of which is per-iter narrative); table
   cells containing multi-clause iter-tagged prose; a "DONE"
   placeholder row that should have been excised.

The strategy IS coherent enough to dispatch from — none of the
findings rise to REJECT. But the planner owes (a) explicit rebuttal
or amendment for each of the three route CHALLENGEs, (b) the
infrastructure-deferral trigger fix, and (c) the format
restructure this iter.
