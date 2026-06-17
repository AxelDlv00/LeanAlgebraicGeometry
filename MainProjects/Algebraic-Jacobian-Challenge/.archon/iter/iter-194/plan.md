# Iter-194 plan-agent run

## Headline outcome

**The "process iter-193 outcomes (77 → 87 sorries, +10 worst-case
adjusted upper bound; 13th-consecutive-zero-axiom-build streak;
**iter-193 CRITICAL** Lane I signature still false post-`hlp`
augmentation + **lean-auditor** 7 must-fix-this-iter findings dominated
by 7+ load-bearing typed-`:= sorry` carriers across Pic0Scheme,
PicScheme, QuotScheme, picSharp, divFunctor, abelMap, PicSharp,
presheaf, PicSharp.etSheaf) + dispatch 3 plan-phase subagents
(refactor `lane-i-localparameter-signature-v2` per Option (b) drop
abstract K + uniformiser-on-ℙ¹ hypothesis hLPUnif — LANDED;
blueprint-reviewer iter194 — required since iter-193 timed out;
progress-critic route194) + DEFER carrier-soundness refactor to
iter-195+ pending design analysis (blast radius across 5 files +
Pic0AbelianVariety would need re-shaping every `Pic0Scheme C`
consumer; not safe in one iter) + dispatch 10 prover lanes covering
Lane I body post-v2, Lane H II.1.16(b)/III.2.4 substrate, Lane M↓
Stage 6 Stacks 00OE + 02JK, Lane E final 2 closures
(`kbarChart1Ring_specMap_fac` + pullback collapse), Lane F LinearEquiv
extraction, Lane B topological range containment, Lane A.3.i Stacks
037Q project-side helper + instance demotion, Lane RCI helper (a)
fibre-dim, Lane G n=0 branch substrate, Lane A first OCofP body push
— all carrying explicit `push beyond HARD BAR` framing per the
iter-192 user hint" iter.**

iter-193 returned `lake build` GREEN with **87 sorries / 0 axioms**
(13th consecutive zero-axiom build). Net trajectory 77 → 87 (+10;
worst-case adjusted upper bound +3). Composition of +10: **+5
expected** from new Pic0AbelianVariety file-skeleton + **+5 sanctioned
typed-sorrys** from iter-193 substrate-carving (Lane H +1 for
substrate split, RCI +2 for Pin 3 helpers (a)+(d), IC +1 for
`geometricallyConnected_of_connected_of_section`, AVR +1 for new
`kbarChart1Ring_specMap_fac` residual).

Iter-194 plan-phase refactor v2 LANDED: WeilDivisor 3 → 5 (+2 typed-
sorry typeclass instances on ProjectiveLineBar);
RationalCurveIso 3 → 3 (1:1 swap `?hlp` → `?hLPUnif`). **Entering
prover phase: 89 sorries.**

## User hint

No user hints this iteration. No prior `## Fallback if no user
response` section to execute. The iter-192 standing user hint (push
beyond HARD BAR; mathlib-build + fine-grained modes; bottom-up build;
big progress) remains the active framing — every iter-194 prover lane
carries an explicit "push beyond HARD BAR" directive.

## Decision made

### Lane I signature corrective v2: Option (b) — drop abstract K

Per iter-193 review's CRITICAL finding (the iter-192 + iter-193
counter-witnesses `K=K(C), t=1` and `K=K(C), t=u(u-1)` both still
admitted by the `hlp` augmentation), iter-194 plan-phase refactor
`lane-i-localparameter-signature-v2` reshapes the signature per
**Option (b)**:

1. Drop the abstract `{K : Type u} [Field K] [Algebra K
   C.left.functionField] [Module.Finite K C.left.functionField]`
   parameters.
2. Pin `t` to `(ProjectiveLineBar kbar).left.functionField`
   directly.
3. Replace `hlp : ∃ Y, order Y t = 1` with the stronger uniformiser
   hypothesis
   ```
   hLPUnif : ∃ Y₀ : (ProjectiveLineBar kbar).left.PrimeDivisor,
     Scheme.RationalMap.order Y₀ t = 1 ∧
     ∀ Y, Scheme.RationalMap.order Y t > 0 → Y = Y₀
   ```
4. Conclusion uses `Module.finrank (ProjectiveLineBar
   kbar).left.functionField C.left.functionField`.

**Why Option (b)** (over Option (a) keeping abstract K + adding
`IsFractionRing (Algebra.adjoin k̄ {t}) K`):

- The consumer at `RationalCurveIso.lean:560-562` already passes
  `K = (ProjectiveLineBar kbar).left.functionField` and
  `t = (localParameterAtInfty kbar).val`. Dropping K matches actual
  usage and reduces signature noise.
- Option (a) requires `IsFractionRing (Algebra.adjoin _ _) K` which is
  itself non-trivial typeclass infrastructure at the consumer.
- The uniformiser hypothesis `hLPUnif` is mathematically the canonical
  pin: `t` having a unique simple zero on ℙ¹ is exactly the
  "uniformiser at a closed point" condition Hartshorne II.6.9 names.

**Reversal signal**: if iter-194 prover or iter-195 review finds
`hLPUnif`'s uniqueness clause introduces unresolvable typeclass-friction
at the consumer (e.g. constructing `Y₀` requires further machinery
not yet in the project), iter-195 plan-phase falls back to Option (a)
via a v3 refactor.

**Cost**: +2 typed-sorry typeclass instances on `ProjectiveLineBar`
(`IsLocallyNoetherian` + `IsRegularInCodimensionOne`; both directly
derivable from `SmoothOfRelativeDimension 1` in iter-194+). WeilDivisor
3 → 5 (+2); RationalCurveIso 3 → 3 (1:1 swap). NET +2 file-level,
0 substrate-debt added (the +2 instances are needed regardless of
which K-encoding the signature uses).

### Carrier-soundness refactor — DEFERRED to iter-195+

Per lean-auditor iter-193 must-fix-this-iter findings, the project has
7+ load-bearing typed-`:= sorry` definition carriers
(`Pic0Scheme`, `PicScheme`, `QuotScheme`, `picSharp`, `divFunctor`,
`abelMap`, `PicSharp`, `presheaf`, `PicSharp.etSheaf`). These propagate
`sorryAx` silently through typeclass synthesis on downstream consumers.
The auditor recommended a `refactor pic-quot-relpic-carrier-soundness`
re-shaping each `:= sorry` into an existential `Nonempty (Σ' S : Over
(Spec k), _)` form in one atomic pass.

**Iter-194 DEFERS this refactor** because:

1. **Blast radius**: the auditor's "existential form" change to the
   carrier type is a TYPE-level change (not a definitional one). Every
   downstream consumer that uses `Pic0Scheme C : Over (Spec k)` as a
   scheme (e.g. all 5 theorem signatures in the brand-new
   `Pic0AbelianVariety.lean` file-skeleton, plus consumers in
   `IdentityComponent.lean`) would need re-shape. Estimated 50-200 LOC
   touched across 5 files + 1 blueprint chapter.
2. **Practical soundness exposure is bounded**: the silent
   `sorryAx`-propagation concern is real, but downstream consumers are
   themselves sorry-bodied (Pic0AbelianVariety.lean has 5 typed
   sorries; IdentityComponent has 9). No real (axiom-clean) consumer
   currently depends on the typeclass synthesis through these carriers.
   So the exposure is latent, not active.
3. **The iter-193 audit was sonnet-driven** and the auditor's one-line
   "existential reshape" recommendation is not a precise design — it
   needs mathlib-analogist consultation (cross-domain-inspiration mode)
   for precedents in how Mathlib handles "load-bearing sorry-bodied
   definition carrier" patterns. Iter-200 mandatory mathlib-analogist
   sweep will include this.
4. **Iter-194 already has 1 plan-phase refactor (Lane I v2) +
   10 prover lanes**. Adding a 5-file structural refactor risks
   destabilising the build mid-iter.

Iter-195 plan-phase will pick the right approach (existential vs
opaque-axiom vs structure-of-data) after iter-200's mathlib-analogist
sweep. **Iter-194 PROGRESS.md flags this carrier-soundness deferral
as a known issue** without committing to a specific fix.

The IC private-instance demotion (`identityComponent_geometricallyConnected`
at L500-507) is a narrower fix and is included in the iter-194
Lane A.3.i prover directive (the prover demotes the `instance` keyword
to a non-instance lemma + threads `letI` at consumer sites; this is
~5 LOC of structural edit).

## Tool substitutions

None this iter.

## Subagent skips

- `strategy-critic`: STRATEGY.md SHA unchanged from iter-193; prior
  verdict was SOUND with all CHALLENGEs (Bottom-up execution priority,
  A.4.d.0 Cartier-divisor pivot, A.2.a/b stalled tag) ACTIONED inline
  iter-192/193 plan-phase. No live CHALLENGE remains. Per descriptor
  `dispatcher_notes` skip conditions: all three conditions met (SHA
  unchanged AND prior verdict SOUND AND prior CHALLENGEs addressed).

- `mathlib-analogist` × N: deferred to iter-200 mandatory periodic
  sweep per STRATEGY.md commitment. Iter-194 prover lanes can attempt
  their HARD BARs without analogist verdicts; partial-information
  attempts are acceptable for the planner-set "push beyond HARD BAR"
  framing.

## Subagent dispatches this phase

1. **`refactor lane-i-localparameter-signature-v2`** — COMPLETE.
   WeilDivisor 3 → 5 (+2); RationalCurveIso 3 → 3 (1:1 swap). Build
   GREEN. Net entering iter-194 prover phase: **89 sorries**.

2. **`blueprint-reviewer iter194`** ([HIGHLY RECOMMENDED]) —
   DISPATCHED. Report (when landed) read for HARD GATE evaluation on
   iter-194 prover dispatch list.

3. **`progress-critic route194`** ([HIGHLY RECOMMENDED]) — DISPATCHED.
   Report (when landed) read for per-route CONVERGING / CHURNING /
   STUCK verdicts + dispatch-sanity on the 10-lane proposal.

## Critic verdicts (this iter, plan-phase)

| Critic | Slug | Verdict |
|---|---|---|
| refactor | `lane-i-localparameter-signature-v2` | COMPLETE — Option (b) signature reshape landed; WeilDivisor 3 → 5; RationalCurveIso 3 → 3. Build GREEN. |
| blueprint-reviewer | `iter194` | COMPLETE — 8 of 10 lanes PASS HARD GATE. **2 lanes FAIL**: Lane H (H1Vanishing.tex iter-193 substrate helpers unpinned, WD-1) + Lane M↓ (CodimOneExtension.tex 3 blockers, WD-2). 2 non-blocking must-fix (WD-3 IdentityComponent carrier-soundness doc + WD-4 Pic0AbelianVariety stale note). Iter-194 plan-phase DROPPED Lane H + Lane M↓ from prover dispatch; DISPATCHED 2 blueprint-writers (WD-1 + WD-2) for the chapters. WD-3 + WD-4 deferred to iter-195. |
| progress-critic | `route194` | COMPLETE — **0 CONVERGING, 6 CHURNING (H, E, F, B, RCI, G), 3 STUCK (I, M↓, A.3.i), 1 UNCLEAR (Pic0AV)**. OVER_BUDGET on E, RCI, A.3.i. Five must-fix-this-iter findings: (1) Route I CHURNING resolved by iter-194 refactor v2 landing; (2) Route M↓ STUCK → moot because Lane M↓ DROPPED by blueprint-reviewer HARD GATE; (3) Route A.3.i STUCK → blueprint expansion DONE iter-194 plan-phase (`lem:geometricallyConnected_of_connected_of_section` added to `Picard_IdentityComponent.tex`); (4) STRATEGY.md OVER_BUDGET re-estimates on E, RCI, A.3.i (DONE iter-194 plan-phase); (5) Lane 1 reframed from "body close" to "≥1 substrate helper" (DONE in PROGRESS.md). |
| blueprint-writer | `h1v-substrate-pins` (WD-1) | COMPLETE — added 2 `\lemma` blocks + `\lean{...}` pins to RiemannRoch_H1Vanishing.tex; removed stale "ancillary lemmas not given their own pin" disclaimer; corrected the directive's namespace sketch (one helper lives at `AlgebraicGeometry.*`, not `AlgebraicGeometry.Scheme.*`). |
| blueprint-writer | `codimoneext-stage6-pins` (WD-2) | COMPLETE — M-1: NOTE block on `lem:smooth_to_regular_local_ring` documenting Stacks 00TT gap; M-2: 2 Stage 5a/5b `\lemma` blocks (Stage 5a/5b helpers are `private theorem` — Lean access visibility iter-195+ cleanup task per writer flag); M-3: NOTE block on `thm:weil_divisor_obstruction` documenting absent Lean correspondent (iter-195+ decision: commission new Lean lemma or move to Out of scope). |
| blueprint-reviewer | `iter194-fastpath` | COMPLETE — **HARD GATE: both PASS**. H1Vanishing fully cleared (`\lean{...}` pins verified against actual public axiom-clean Lean declarations). CodimOneExtension cleared with M-1 + M-2 + M-3 documented; quality note about `private theorem` access visibility flagged for iter-195+. Lane H + Lane M↓ ADDED BACK to iter-194 prover dispatch via same-iter fast path. |

## Progress-critic correctives APPLIED iter-194 plan-phase

Per the route194 verdict, the planner applied the following correctives
inline before dispatching the prover round:

1. **STRATEGY.md re-estimates**: Routes E (Genus-0 chart-bridge) +
   RR.4 (RCI) + A.3.i (IdentityComponent) — all three OVER_BUDGET
   `Iters left` columns revised upward to honest projections (20-28 /
   20-26 / 5-8 respectively). The carrier-soundness deferred refactor
   added to Open Strategic Questions.

2. **Blueprint expansion (Route A.3.i)**: added
   `lem:geometricallyConnected_of_connected_of_section` as a
   FIRST-CLASS blueprint lemma in
   `blueprint/src/chapters/Picard_IdentityComponent.tex` (~50 LOC of
   prose with full Stacks 037Q proof sketch); previously the obligation
   was a substrate footnote inside the body of
   `thm:identity_component_base_change_commutes`. The new lemma block
   is `\lean{...}`-pinned to the existing Lean helper at
   `IdentityComponent.lean:414`; iter-194 prover (Lane 7) targets the
   project-side ~30-50 LOC body close.

3. **Lane M↓ STUCK directive re-scope** (in `PROGRESS.md` Lane 3 +
   `objectives.md` Lane M↓): explicit "DO NOT add more helper layers
   around Stages 5-6; INCOMPLETE the lane if Stacks 00OE/02JK Mathlib
   bridges are not immediately buildable from current Mathlib".

4. **Lane I CHURNING resolved**: the iter-194 refactor v2 landing fixes
   the signature problem at the source. Lane 1 directive scoped to ≥1
   substrate helper (NOT body close in 1 iter).

5. **Lane 10 (OCofP) UNCLEAR**: blueprint chapter verified to exist
   (`RiemannRoch_OCofP.tex`); lane dispatched with explore-and-
   commit-partial framing.

## Rebuttals to progress-critic findings

None this iter — all 5 must-fix-this-iter findings actioned inline as
above. The critic's recommendations were SOUND and the planner
applied them all.

## Iter-194 sorry projection

Entering iter-194 prover phase: **89 sorries / GREEN** (= 87 post-
iter-193 + 2 typed-sorry typeclass instances on `ProjectiveLineBar`
from refactor v2).

Prover phase projections (10 effective lanes — Lane H + Lane M↓ ADDED
BACK via same-iter fast path):

- **Best case** (all 10 HARD BARs met + ≥3 push-beyond closures): 89
  → **~80-83** (−6 to −9).
- **Realistic** (6-7 HARD BARs met + 1-2 push-beyond): 89 → **~83-87**
  (−2 to −6).
- **Worst case** (deep lanes I body, M↓ Stage 6, A.3.i, RCI helper a
  all stuck; mechanical lanes only): 89 → **~86-89** (−0 to −3).

**Target: realistic-or-best band**, per user-hint mandate of big
progress.

## Same-iter fast path executed

Per the blueprint-reviewer descriptor's HARD GATE fast-path
affordance, the iter-194 plan-phase executed:

1. Dispatched 2 writers (WD-1 + WD-2) for the 2 chapters flagged FAIL
   by the whole-blueprint review (both completed within ~9 minutes
   total via the serialised dispatch).
2. Re-dispatched `blueprint-reviewer iter194-fastpath` scoped to the 2
   chapters only.
3. Fast-path returned **HARD GATE: both PASS** with one residual
   quality flag (private-theorem access visibility on Stage 5a/5b
   helpers — iter-195+ cleanup, non-blocking for iter-194 prover
   dispatch).
4. Lane H + Lane M↓ ADDED BACK to iter-194 prover dispatch.

Net cost of the fast-path: ~17 minutes additional wall-clock
(3 minutes writer-1 + 6 minutes writer-2 + 5 minutes scoped reviewer
+ ~3 min orchestration). Benefit: 10 effective lanes vs 8 (a 25%
dispatch-throughput improvement this iter).

## Active monitors

- **Lane I body**: refactor v2 LANDED with truthful signature. iter-194
  prover [fine-grained] attempts the Hartshorne II.6.9 body close
  using the 8 iter-193 axiom-clean substrate helpers + Y₀ extraction.
  If `prove` budget wall hit, iter-195 considers a sub-helper carve
  via the affine-chart `Spec A ⊂ ℙ¹` substrate.
- **Lane H substrate**: 2 named typed-sorry helpers
  (`shortExact_app_surjective` Hartshorne II.1.16(b) +
  `injective_flasque` Hartshorne III Lemma 2.4). Both [mathlib-build]
  this iter; estimated ~150-200 LOC each.
- **Lane M↓ Stage 6**: depends on Mathlib gap (Stacks 00OE + 02JK);
  [mathlib-build]. If 0 closures iter-194, iter-200 mathlib-analogist
  sweep covers it.
- **Lane E final closures**: `kbarChart1Ring_specMap_fac` +
  pullback collapse; both Mathlib-clean per iter-193 review.
- **Lane F LinearEquiv extraction**: post the 5-step sheaf-level
  iso chain; should be the final residual.
- **Lane B topological range containment**: closed-points/density
  route preferred per iter-193 task report.
- **Lane A.3.i**: Stacks 037Q iff-direction (~30-50 LOC project-side
  build) + IC instance demotion.
- **Lane RCI helper (a)**: fibre-dim via Mathlib
  `LocallyQuasiFinite.of_fiberToSpecResidueField`.
- **Lane G n=0 branch**: residual `depth(Fin k → R) = depth(R)`.
- **Lane A first OCofP body push**: 3 sorries downstream of Lane H;
  iter-193 H body chained structurally, so OCofP body proceeds with
  transitive sorryAx (the Lane H II.1.16 + III.2.4 helpers close
  iter-194+ to make the chain axiom-clean).
- **Carrier-soundness deferral**: monitor across iter-194 prover
  outcomes. If a prover lane is blocked by a `:= sorry` carrier
  (e.g. Pic0AbelianVariety body close cannot proceed without
  `Pic0Scheme` being a real scheme), escalate to iter-195 plan-phase
  with concrete blocker.

## Iter-195 preliminary commitments

1. **CRITICAL refactor** `pic-quot-relpic-carrier-soundness` — design
   the existential reshape after iter-200 mathlib-analogist verdict;
   single atomic pass across Pic0Scheme + PicScheme + QuotScheme +
   picSharp + divFunctor + abelMap + PicSharp + presheaf +
   PicSharp.etSheaf.
2. Lane I body close if iter-194 [fine-grained] returns INCOMPLETE
   on the affine-chart `Ideal.sum_ramification_inertia` chain.
3. Lane H 2 substrate helpers (Hartshorne II.1.16(b) + III.2.4) —
   continue from iter-194 if not fully landed.
4. Lane M↓ Stage 6 (gated on mathlib-analogist Stacks 00OE / 02JK
   verdict).
5. Mandatory iter-195 critics: blueprint-reviewer + progress-critic;
   conditional on STRATEGY.md changes, strategy-critic.

## Iter-200 preliminary commitments

- **Mandatory mathlib-analogist sweep** per STRATEGY.md commitment.
  Covers all "substrate unowned"/"gated" rows + the carrier-soundness
  precedent question (cross-domain-inspiration mode).

## Carrier-soundness pattern (for review's `% NOTE` consideration)

The lean-auditor iter-193 surfaced 7+ load-bearing typed-`:= sorry`
on definition carriers as the project's largest soundness exposure.
Iter-194 plan-phase records this finding here (and as a note in
task_pending.md) but **defers the refactor to iter-195+** pending
design analysis. Review may consider:

- Adding `% NOTE (iter-193 lean-auditor)` annotations to the affected
  blueprint chapters (`Picard_IdentityComponent.tex`,
  `Picard_FGAPicRepresentability.tex`, `Picard_QuotScheme.tex`,
  `Picard_RelPicFunctor.tex`, `Picard_Pic0AbelianVariety.tex`) so
  consumers see the soundness-exposure caveat.
- Setting up an iter-200+ `axiom_sweep` (the `loop.axiom_sweep` config
  flag) as a soundness gate — this is a config change, not blueprint.

These are review-time decisions; plan agent flags them for review's
attention but does not act on them.
