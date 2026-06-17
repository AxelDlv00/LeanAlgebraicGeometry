# Iter-139 (Archon canonical) plan-agent run

## Headline outcome

Iter-138 prover lane returned PARTIAL with substantive Route (b)
skeleton on
`relativeDifferentialsPresheaf_basechange_along_proj_two`
(`Cotangent/GrpObj.lean:612`). Project sorry count: **6 declarations
using sorry / 7 inline sorries** (iter-138 close, verified iter-139
plan phase). Three concrete sub-sorries remain inside the piece
(i.b) Step 2 helpers + main: `d_app` at L581, `d_map` at L585, `IsIso`
at L624.

**Iter-139 PRIMARY DECISION**: prover lane on `Cotangent/GrpObj.lean`
is **DEFERRED** per `blueprint-reviewer-iter139` HARD GATE — both
`RigidityKbar.tex` AND `AlgebraicJacobian_Cotangent_GrpObj.tex` are
`complete: partial` (the iter-138 d_app + d_map closure recipes live
ONLY in the Lean docstring at `Cotangent/GrpObj.lean:489–501`, not
yet in the blueprint; the two iter-138 helpers
`basechange_along_proj_two_inv_derivation` + `basechange_along_proj_two_inv`
ship without dedicated `\lean{...}` blocks). The deferral is the
correct, intentional action — iter-140 will be the first iter the
prover lane fires against a now-complete blueprint, with the iter-139
mathlib-analogist's PROCEED-with-Route-(b'2) verdict already in hand
for the IsIso closure.

**Iter-139 is plan + 4-subagent-parallel-Wave-1 (3 critics + 1
analogist) + 1-subagent-Wave-2 (1 blueprint-writer) + intentionally
deferred prover.** No prover dispatch this iter; iter-139's `##
Current Objectives` carries the recognized marker
`(no prover dispatch this iter — see iter/iter-139/plan.md for
rationale)`.

## Wave 1 (parallel) — 4 dispatches, all returned

| Subagent | Slug | Verdict | Outcome |
|---|---|---|---|
| `blueprint-reviewer` | iter139 | **HARD GATE FIRES** on `Cotangent/GrpObj.lean` — 11 chapters audited; 2 chapters `complete: partial` (`RigidityKbar.tex` + `AlgebraicJacobian_Cotangent_GrpObj.tex`); 5 must-fix-this-iter findings concentrated on the d_app/d_map blueprint-prose expansion + the two iter-138 helpers' missing `\lean{...}` pins; 1 `sync_leanok` mis-mark concern at `RigidityKbar.tex:491` informational only | Iter-139 prover lane on `Cotangent/GrpObj.lean` **DEFERRED**; iter-139 dispatches blueprint-writer for `RigidityKbar.tex` per recommendation; pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` updated by plan agent directly (2-bullet addition, plan-write-permitted). |
| `strategy-critic` | iter139 | **CHALLENGE** (8 routes audited: M1 SOUND; M2.a + M2.body-pile + M3 CHALLENGE; iter-138 Edits 1/2/3 SOUND, Edit 4 SOUND on PR-lane but CHALLENGE on elided named-gap-sorry alt) + 3 sunk-cost flags + 4 alternative routes (2 major / 2 minor); 7 must-fix items | All 7 must-fix items **ABSORBED** via iter-139 plan-agent actions (see § Strategy-critic absorption below) — 3 STRATEGY.md edits + 4 plan.md-recorded actions/decisions; 4 alternative routes (2 major: direct chart-algebra rigidity for (i.b)+(i.c); named-gap-sorry for piece (iii)) **RECORDED FOR ITER-140 ANALOGIST DISPATCH** (see § Iter-140 prep below). |
| `progress-critic` | iter139 | **UNCLEAR leaning CONVERGING-with-watch** on Route Piece (i.b) Step 2 (1 route audited; 0 CHURNING / 0 STUCK) — strict rubric rules out CONVERGING (sorry count 3→3→2→2→3 not strictly decreasing), CHURNING-A (structural change occurred), CHURNING-B (PARTIAL count 2-of-5 < 3), STUCK (Steps 1 + 3 substantively closed during K window). Iter-140 hard gates committed: ≥2 of 3 sub-sorries closed → CONVERGING-confirmed; 0 or 1 closed → CHURNING-triggered (3rd consecutive PARTIAL); 0 closed + `pullback` chart-opacity blocker resurfaces → STUCK + route pivot. | No new corrective required (planner already adopted iter-138 progress-critic's recommended mathlib-analogist consult); iter-140 progress-critic re-dispatch will apply strict gates. The blueprint-reviewer's HARD GATE DEFERRAL of iter-139's prover lane shifts the progress-critic's iter-140 "≥2 of 3 sub-sorries" disambiguation criterion to **iter-141** (since iter-140 is now the first iter the prover lane fires post-blueprint expansion); the rest of the verdict carries over verbatim. |
| `mathlib-analogist` | isiso-routes-iter139 | **PROCEED with Route (b'2)** for the IsIso sub-sorry — 5 decisions analyzed; 1 ALIGN_WITH_MATHLIB on `tensorKaehlerEquiv` per-open idiom; LOC envelope ~195–365 LOC (Route (b'2)) vs ~240–510 LOC (Route (a)); ~50–195 LOC savings | Verdict absorbed; the iter-140 prover lane on the IsIso sub-sorry uses the 5-line `isIso_of_app_iso_module` bridge (verified-typecheck per the analogist) via `PresheafOfModules.toPresheaf` reflecting isos + `NatTrans.isIso_iff_isIso_app`. **Critical caveat the iter-138 prover did NOT flag**: `(PresheafOfModules.toPresheaf R).ReflectsIsomorphisms` needs `import Mathlib.CategoryTheory.Functor.ReflectsIso.Balanced` (transitively or directly) for typeclass synthesis to succeed; iter-140 prover directive will state this explicitly. Persistent file: `analogies/isiso-basechange-along-proj-two-inv.md`. |

## Wave 2 (sequential after Wave 1) — 1 dispatch

| Subagent | Slug | Verdict | Outcome |
|---|---|---|---|
| `blueprint-writer` | rigiditykbar-iter139 | **COMPLETE** (~9.6 min / $4.50) | All 6 directive edits landed in `RigidityKbar.tex` between the proof block of `lem:GrpObj_omega_basechange_proj` (L489–L639 pre-edit) and `lem:GrpObj_omega_restrict_to_identity_section` (L641 pre-edit): (1) iter-138 closure-shape NOTE (L505–L593); (2) d_app closure recipe NOTE (L594–L651); (3) d_map closure recipe NOTE (L653+); (4) Route (b'2) sub-paragraph in IsIso NOTE block (with 5-line bridge spelled out + iter-140 build order + Mathlib API verified iter-139); (5) two new `\lean{...}` lemma blocks for `basechange_along_proj_two_inv_derivation` (L969–L1046) and `basechange_along_proj_two_inv` (L1049+); (6) `% NOTE iter-139:` flag on `\leanok` mis-mark concern at L491–L504. Chapter grew 754 → 1222 LOC (+468 LOC). Balanced LaTeX verified by writer (12/12 lemma blocks, 12/12 proof blocks, 19/19 theorem/remark/definition blocks, 7/7 itemize, no uncommented enumerate/align/verbatim). No dangling `\uses{...}` / `\cref{...}` references; no new macros added. Plan agent also updated `AlgebraicJacobian_Cotangent_GrpObj.tex` directly (pointer-chapter 2-bullet addition listing the two iter-138 helpers). |

## Strategy-critic absorption (7 must-fix items)

### Must-fix #1: §534 4-axis re-eval with MEASURED Step 2 LOC

**`strategy-critic-iter139`**: STRATEGY.md §534 says "iter-138-close
4-axis re-evaluation MUST run after iter-138 prover lane returns"
with the **measured** (not projected) Step 2 body+helpers LOC. The
strategy is ambiguous on whether to count the current skeleton state
(~92 LOC body + ~50 LOC docstring) or the eventual closed state
(~300–500 LOC by projection).

**Iter-139 plan-agent decision**: run with BOTH measurements; record
both readings to expose the comparison.

**Measurement #1: Current skeleton state (iter-138 close)**:
- Step 2 body content delta this iter: +92 LOC (helper `_inv_derivation`
  ~38 LOC + helper `_inv` ~15 LOC + main body refactor ~14 LOC +
  internal `letI` ~5 LOC).
- Step 2 docstring delta this iter: +50 LOC.
- Cumulative (i.b)-side build iter-134→iter-138 (per iter-138 review):
  **~408 LOC**.

**Measurement #2: Projected closure state (iter-138 close + iter-140
projection)**:
- iter-140 Route (b'2) envelope per iter-139 analogist: ~195–365 LOC
  (5-line bridge + chart-level `Algebra.IsPushout` ~80–150 LOC +
  chart-unfolding helper `pullbackObjEquivTensor` ~30–60 LOC +
  per-open identification ~80–150 LOC).
- iter-140 d_app + d_map closure envelope per
  `task_results/Cotangent_GrpObj.lean.md`: ~60–160 LOC (~30–80 LOC
  each).
- Projected cumulative (i.b)-side build at iter-140 close:
  ~408 + ~255–525 = **~663–933 LOC**.

**4-axis re-eval against renormalised 1000 LOC cap**:

| Axis | Replacement (B) [iter-138 skeleton] | Replacement (B) [iter-140 projection] | Fibre-free |
|---|---|---|---|
| (1) LOC for (i.b)+(i.c) | ~408 LOC cumulative (well below 1000 LOC cap; ~50% of 810 envelope upper bound) | ~663–933 LOC cumulative (below 1000 LOC cap; 82–115% of 810 envelope upper bound — slight envelope overrun on projection) | ~400–800 LOC estimate (iter-132 STRATEGY.md baseline; could be tighter per the alternative direct-chart-algebra route below) |
| (2) Canonicity | Non-canonical (chart-`Classical.choose`-dependent); the iter-131 `_eq_extendScalars` lemma exposes structural shape | Same — non-canonical, structurally-exposed | Canonical (avoids named "cotangent at identity" object) |
| (3) Blueprint alignment | High (iter-138 NOTE block + iter-139 blueprint-writer expansion) | High (iter-139 blueprint-writer covers d_app + d_map + Route (b'2)) | Low (~150–300 LOC of blueprint rewrite) |
| (4) Downstream API shape | Concrete named-object `cotangentSpaceAtIdentity G`; iter-132 `_finrank_eq` already references it | Same | Loses named object; downstream consumers need ad-hoc extraction |

**Iter-139 trigger evaluation**:
- Skeleton LOC ~408 < 567 (70% × 810 envelope) < 1000 — **the
  unconditional fibre-free fire trigger does NOT fire**.
- Projected LOC ~663–933 hits 82–115% of envelope upper bound at the
  upper tail; this is informational, not gating, since the cap is
  1000 LOC and projection upper bound is 933 LOC.

**Iter-139 4-axis verdict**: **STAY ON (B)**. Axis (1) projection
upper bound 933 LOC is just under the 1000 LOC cap. Axis (2) is the
only one where fibre-free wins (qualitative, recovered partially by
`_eq_extendScalars`). Axes (3)+(4) decisively favor (B) under iter-139
blueprint state. **Forward-merit-weighted scoring (per iter-134
`strategy-critic-iter134` CHALLENGE 2)**: axes (1)+(2) [forward
merit] = mixed (LOC tight, canonicity favors fibre-free); axes
(3)+(4) [switching cost + speculative consumers] = strongly (B). With
forward-merit weighting, (B) still wins because axis (1) does NOT
flip against the cap.

**Pivot trigger watchpoint**: if iter-140 prover lane on the d_app
+ d_map + IsIso sub-sorries crosses 1000 LOC cumulative (i.b)-side
build without converging, **the renormalised cap fires**; the
iter-141 plan agent MUST re-run this scorecard with the new MEASURED
LOC. No re-renormalisation without a new analogist consult (per
STRATEGY.md § Soundness rules iter-138 renormalisation discipline
guardrail).

### Must-fix #2: §519 over-k auto-flag re-discussion

**`strategy-critic-iter139`**: STRATEGY.md §519 says "if iter-138
returns PARTIAL again, ground (iv) stays scope-narrow and the
cumulative weight of 'single piece of empirical tractability evidence
after 11 iter of build' warrants explicit re-discussion in iter-139
plan phase (not auto-revert, but auto-flag)." Iter-138 returned
PARTIAL with substantive body cut — the auto-flag gate fires.

**Iter-139 plan-agent re-discussion** (per the §519 contract):

(i) **Single-piece-tractability acknowledgement**: 11 iters of
over-k build (iter-128 → iter-138) have produced exactly **two**
substantively closed targets that reference content-bearing Mathlib
chains: piece (i.a) (`cotangentSpaceAtIdentity_finrank_eq`, iter-132)
and piece (i.b) Step 3
(`relativeDifferentialsPresheaf_restrict_along_identity_section`,
iter-136). Step 1 (`shearMulRight`, iter-134) is closed but is a
clean categorical-shear construction that would have worked equally
over `k̄`; it is route-agnostic. Step 2 returned PARTIAL twice
(iter-137 + iter-138). Pieces (i.c)/(ii)/(iii) remain entirely
scaffolded but with no body-closure work yet. **The empirical
tractability evidence over k is now: 1 piece + 1 sub-step (Step 3)
of a 5-piece pile** — slightly broader than iter-138's "single piece"
framing, still scope-narrow against the full pile.

(ii) **Explicit position on revert vs continue**: **CONTINUE with
over-k**, with the following honest acknowledgements:
- The quantitative case lower bound remains zero (iter-128 baseline).
- The qualitative case is now (ii) blueprint cleanliness as switching
  cost + (iv) piece (i.a)+(i.b)-Step-3 tractability evidence. (i.b)
  Step 2 PARTIAL is the **expected** Step 2 trajectory under the
  iter-137 `kaehler-tensorequiv-presheafpullback-iter137` revised
  envelope (Step 2's complexity was scoped to 360–710 LOC even before
  Route (a)→(b) pivot); two iters of PARTIAL on a 360–710 LOC closure
  IS the iter-138 progress-critic's "first substantive attempt iter"
  pattern, not a stall.
- The cost of revert is preserved as ~1 iter of strategic backtrack
  + restoration of M2.c rows; revert wiring (trigger (a'), (b), (c))
  is in place but no trigger has fired.

(iii) **Named criterion for the next re-discussion (iter-140+ checkpoint)**:
- **If iter-140 closes ≥2 of 3 piece (i.b) Step 2 sub-sorries
  substantively** (d_app + d_map at minimum) AND the projected
  cumulative (i.b)-side build stays below 1000 LOC: ground (iv)
  extends to "(i.a)+(i.b)-substantive" (two pieces of empirical
  tractability evidence; the iter-138 "auto-flag" gate is satisfied
  by genuine progress).
- **If iter-140 closes 0 or 1 sub-sorries** (third consecutive
  PARTIAL in the piece (i.b) Step 2 family): iter-141 progress-critic
  fires CHURNING-trigger (per `progress-critic-iter139` watch
  criterion) AND the iter-141 plan agent re-opens the over-k vs
  over-`k̄` decision with a mid-iter strategy-critic re-dispatch on
  the route-pivot question (NOT silent absorption).
- **If iter-140 returns INCOMPLETE without structural progress** AND
  `pullback` chart-opacity blocker phrase resurfaces: trigger
  STUCK-route pivot per `progress-critic-iter139` watch criterion.

(iv) **Re-frame "operationally defaulted" with quantitative
specifics**: the operational-default framing (per iter-138 STRATEGY.md
Edit 3) is reaffirmed for iter-139 with the addition that the next
ground-extension or revert is gated on the iter-140 prover lane
outcome (not on iter-141+ deliberation). This binds the auto-flag to
the iter-140 prover lane's measurable result, not to indefinite
wait-and-see.

### Must-fix #3: M3 plan reconciliation

**`strategy-critic-iter139`**: M3 is treated as "wait for M2, then
user-escalate" with no iter-by-iter critical-path schedule. The
strategy needs either (i) a credible iter-by-iter plan for at least
M3 Route A's smallest gating piece (relative Spec functor, 700–1100
LOC per iter-123 audit), or (ii) explicit acknowledgement that
zero-sorry end-state is unreachable on the autonomous loop.

**Iter-139 plan-agent decision**: adopt **option (i) light** — name
the Relative Spec functor as the **off-loop PR lane to open iter-139+
in parallel with M2**, structurally analogous to the M1.d off-loop
PR-extraction precedent. The lane runs in parallel with the M2
critical-path build and produces upstream-PR drafts; it does NOT
gate M2 closure. **Schedule**: opens iter-139+ (now), produces
incremental upstream-PR turnaround over iter-139→iter-156 (~17
iters of upstream review turnaround), feeds into M3 body closure
post-M2-iter-157+.

**Why option (i) light is the right balance**:
- Option (i) full (in-loop iter-by-iter plan for M3 alongside M2)
  doubles iter-by-iter complexity and risks M2 throughput.
- Option (ii) (zero-sorry-end-state-unreachable) is premature — the
  iter-123 audit's 6500-LOC midpoint is large but not impossible at
  AI/loop scale, and the iter-126 user hint explicitly endorsed "do
  the work, ~6500–9000 LOC may not be that much for an AI".
- The iter-139 ConcreteCommit: **open the Relative Spec functor
  off-loop PR lane this iter** (record in iter-139 plan.md as
  prep-only; the prover does not work on M3 this iter; the off-loop
  lane runs independently of the main prover dispatch sequence).

**Recorded action item for iter-139+**: when the M3 off-loop lane is
opened (this iter), the iter-139 plan agent's `## Off-critical-path
work this iter` block (see PROGRESS.md) names the Relative Spec
functor (M3 Route A Hilbert/Quot dependency) as the first off-loop
PR target. The Mathlib status: `Mathlib.AlgebraicGeometry.RelativeSpec`
does not exist; the project would scaffold this in
`AlgebraicJacobian/M3PrelimRelativeSpec.lean` (NEW file, off-loop
build) with iter-by-iter LOC accountability tracked separately from
the M2 critical path.

**Honest revision**: iter-139 names the off-loop lane but does not
yet **dispatch** a prover on it (because M3 is genuinely off-critical-
path until M2 closes; the off-loop lane is owned by the project as
"PR-extraction work in parallel with M2", not by an in-loop prover
dispatch). The next iter where the off-loop lane materially advances
is whenever the project's PR-extraction-readiness criteria are met;
that schedule is recorded in iter-139 plan.md but does NOT enter the
iter-by-iter prover dispatch sequence.

**Strategy-critic's challenge addressed**: the zero-sorry end-state
is now defended by a concrete iter-139-opened off-loop lane (not by
"wait-and-see").

### Must-fix #4: Direct chart-algebra rigidity alternative for (i.b)+(i.c)

**`strategy-critic-iter139`**: strategy commits to (i.b)+(i.c) at
810–1540 LOC global cotangent trivialisation without comparison to
a plausibly half-cost local-only direct chart-algebra rigidity route.

**Iter-139 plan-agent decision**: **record alternative for
iter-140 mathlib-analogist consult**; do NOT dispatch this iter
(the iter-139 capacity is already 4 critics + 1 writer + the
analogist-on-IsIso). The iter-140 plan agent SHOULD dispatch a
mathlib-analogist with directive: "compare direct chart-algebra
rigidity vs piece (i.b)+(i.c) global trivialisation for the
`rigidity_over_kbar` argument — given `f : C → A` with `df = 0` and
`A` smooth proper geom-irr `G/k` of relative dim n, restrict `f^#`
to each affine chart of `A`, use Kähler-freeness of the standard-
smooth `A_loc/k` to conclude `f^#` factors through k chart-by-chart,
glue via `Scheme.Over.ext_of_eqOnOpen`. Envelope estimate, Mathlib
infrastructure check, comparison to existing (i.b)+(i.c) path".

**Recorded as iter-140 plan agent dispatch obligation**: see § Iter-140
prep below.

### Must-fix #5: Named-gap sorry for piece (iii)

**`strategy-critic-iter139`**: strategy buries the iter-138
`mathlib-analogist-p1-hedge-iter138`'s explicit recommendation of
named-gap sorry as a "stall fallback" while committing to in-tree
800–1500 LOC of scheme-level absolute Frobenius. The analogist's
explicit recommendation was that named-gap sorry IS the cheaper
escape hatch.

**Iter-139 plan-agent re-discussion**:

- **The iter-121 zero-sorry-end-state pivot** is the canonical
  reason in-tree build is currently committed. The pivot was made
  with explicit acknowledgement that some pieces would be expensive;
  the iter-126 user hint reaffirmed this with "do the work, no
  axioms; ~6500–9000 LOC may not be that much for an AI".
- **The §398 user-hint citation-discipline rule** says the iter-126
  hint applies to the M3 user-escalation TO_USER banner specifically,
  not as a generic blanket for all expensive in-tree paths. By that
  rule, piece (iii)'s 800–1500 LOC in-tree build needs justification
  on the merits.
- **On the merits (iter-139 honest accounting)**:
  - In-tree build cost: 800–1500 LOC over 4–7 iter, scheme-level
    absolute Frobenius from ring-side `Mathlib.Algebra.CharP.Frobenius`.
    Produces a Mathlib-PR candidate (the upstream-PR-extraction lane
    iter-144+ per iter-138 Edit 4).
  - Named-gap sorry cost: ~0 LOC + 0 iter; documents the gap in
    blueprint; downstream consumers (the body of `rigidity_over_kbar`
    after piece (iii) place) carry one residual named gap. Does NOT
    produce a Mathlib-PR candidate (the named gap is the
    counterfactual to building the PR).

- **Iter-139 plan-agent verdict**: **maintain in-tree commitment**
  as the operational default — but with **honest acknowledgement** that
  this is a switching-cost+zero-sorry-end-state-commitment-driven
  decision, not a "in-tree is cheaper" decision. The analogist's
  explicit recommendation is recorded in STRATEGY.md as an active
  alternative (not as a stall fallback), and the iter-144+ piece
  (iii) build is gated on "iter-141 piece (i.c) closure + iter-143
  piece (ii) closure both substantive"; if either of those returns
  PARTIAL across 2+ iters, the iter-144+ plan re-opens this decision
  before committing the 800–1500 LOC in-tree build.

### Must-fix #6: Analogist-overhead axis on M2.body-pile cost accounting

**`strategy-critic-iter139`**: strategy doesn't acknowledge that
piece (i.b) Step 2 has consumed 4 analogist consults across iter-133
→ iter-139 (iter-133 mulright-globalises, iter-135 phi-compatibility,
iter-137 kaehler-tensorequiv, iter-139 IsIso-routes). This is a
route-difficulty smoke signal.

**Iter-139 plan-agent decision**: **add the analogist-overhead axis
to STRATEGY.md** as part of the M2.body-pile cost accounting.
Concrete addition (see STRATEGY.md edit below): cumulative analogist
consults per piece is tracked alongside LOC; threshold rule "5
consults on a single sub-piece, or 3 consults that each widen the
envelope" re-raises the route-pivot question.

**Iter-139 status check against the new rule**: piece (i.b) Step 2
has 4 analogist consults; if iter-140 returns PARTIAL and a 5th
consult is needed, the rule fires.

### Must-fix #7: Sunk-cost flags (1+2+3)

All three flags are absorbed via must-fix #2 (flag #1 — over-k
operationally defaulted), must-fix #6 (flag #2 — analogist overhead),
and must-fix #5 (flag #3 — piece (iii) in-tree default).

## STRATEGY.md edits this iter

(Targeted, surgical; preserve all other content.)

### Edit 1: §519 over-k auto-flag execution recorded as conditional ground extension

Add to the end of §519 (just before the "Conditional ground extension"
paragraph):

> **Iter-139 §519 auto-flag execution** (per `strategy-critic-iter139`
> Must-fix #2): iter-138 returned PARTIAL on piece (i.b) Step 2 with
> substantive structural body cut; the §519 "auto-flag" gate has
> fired. Iter-139 plan-agent re-discussion concludes **CONTINUE with
> over-k** with the named criterion that **iter-140 must close ≥2 of
> 3 piece (i.b) Step 2 sub-sorries (d_app + d_map at minimum) for
> ground (iv) to extend from "(i.a) only" to "(i.a)+(i.b)-substantive"**.
> If iter-140 closes 0 or 1 sub-sorries (third consecutive PARTIAL),
> iter-141 plan agent fires CHURNING-trigger AND re-opens the over-k
> vs over-`k̄` decision with mid-iter strategy-critic re-dispatch on
> route-pivot. Full re-discussion at `iter/iter-139/plan.md § "§519
> over-k auto-flag re-discussion"`.

### Edit 2: § Soundness rules — add analogist-overhead axis to M2.body-pile cost accounting

Add a new bullet to § Soundness rules (after the "LOC trigger arm
renormalisation discipline" bullet at L399 in current numbering):

> - **Analogist-overhead axis on M2.body-pile cost accounting (added
>   iter-139 per `strategy-critic-iter139` sunk-cost flag #2).** The
>   cumulative analogist consult count per sub-piece is a route-
>   difficulty smoke signal alongside LOC. **Threshold rule**: if a
>   single sub-piece consumes ≥5 analogist consults, OR ≥3 consults
>   that each widen the envelope (i.e. an envelope-widening pattern
>   on the consults, not just consult quantity), **the route-pivot
>   question must be re-raised on its merits** with explicit
>   strategy-critic re-dispatch on the pivot question (mid-iter).
>   Iter-139 baseline: piece (i.b) Step 2 carries 4 consults
>   (iter-133 mulright-globalises, iter-135 phi-compatibility,
>   iter-137 kaehler-tensorequiv, iter-139 IsIso-routes); none of
>   the 4 widened the envelope (the iter-137 consult widened it, the
>   iter-139 consult validated and refined the closure path). The
>   5-consult threshold fires if iter-140 PARTIAL triggers a 5th
>   consult.

### Edit 3: § Off-critical-path — open M3 Relative Spec functor off-loop PR lane

Add to § Off-critical-path block (around L562–L584 in current line
numbering):

> - **M3 Route A Relative Spec functor off-loop PR lane (NEW iter-139
>   per `strategy-critic-iter139` Must-fix #3)**. The iter-123 M3
>   audit identified `Mathlib.AlgebraicGeometry.RelativeSpec`
>   (relative spectrum functor as a covariant functor on quasi-
>   coherent algebras) as the smallest extractable PR piece useful
>   regardless of M3 route (~700–1100 LOC; foundational for Hilbert
>   scheme representability and Picard functor representability).
>   **Open lane iter-139+** in parallel with M2 critical-path build,
>   structurally analogous to M1.d off-loop PR-extraction precedent.
>   The lane runs independently of the iter-by-iter prover dispatch;
>   no in-loop prover assignment until M2 closes (then folds into
>   M3 body closure). **Schedule**: iter-139 names lane; PR-extraction
>   readiness criteria (chapter scaffolding + Mathlib idiom alignment
>   draft) are an off-loop responsibility, tracked separately from
>   M2 closure. **Zero-sorry-end-state defense**: this off-loop lane
>   concretises the project's "zero-sorry end-state" commitment for
>   M3 — it is not pure wait-and-see post-M2-closure.

## PROGRESS.md updates this iter

(See PROGRESS.md changes in same plan-phase commit.)

- `## Current Objectives` carries the recognized marker
  `(no prover dispatch this iter — see iter/iter-139/plan.md for
  rationale)` — the blueprint-reviewer HARD GATE is the rationale.
- `## Off-limits this iteration` retains the 3 existing items (Main
  in GrpObj, Jacobian.lean 2 sorries, RigidityKbar.lean 1 sorry)
  PLUS a NEW item: `Cotangent/GrpObj.lean` — iter-139 prover DEFERRED
  pending blueprint expansion.
- `## Watch criteria committed for iter-140`:
  - (a) Iter-140 mandatory blueprint-reviewer: confirm
    `RigidityKbar.tex` + `AlgebraicJacobian_Cotangent_GrpObj.tex`
    BOTH `complete: true` after iter-139 blueprint-writer + plan-agent
    direct edits land. HARD GATE check.
  - (b) Iter-140 prover lane on the THREE sub-sorries (d_app + d_map
    + IsIso) bundled OR split into two prover lanes (d_app + d_map
    in one lane, IsIso in a separate lane). The mathlib-analogist
    iter-139 verdict (PROCEED with Route (b'2)) is in hand and
    provides the IsIso closure recipe; ≥2 of 3 sub-sorries closed →
    CONVERGING-confirmed per iter-139 progress-critic watch criterion.
  - (c) Iter-140 plan agent MUST dispatch the direct chart-algebra
    rigidity vs (i.b)+(i.c) alternative analogist consult (iter-139
    strategy-critic must-fix #4).
  - (d) Iter-140 plan agent MUST verify the §519 over-k auto-flag
    follow-up: ground (iv) extension fires conditionally on iter-140
    prover lane outcome per the iter-139 §519 re-discussion.
  - (e) `sync_leanok` mis-mark on `RigidityKbar.tex:491` — iter-140
    or iter-141 doctor-skill consult on the `letI ... := sorry`
    handling.

## Iter-140 prep

Iter-140 is the first iter where the prover lane fires post-blueprint
expansion. Key dispatch responsibilities (recorded for iter-140 plan
agent inheritance):

1. **3 mandatory critics** (strategy-critic, blueprint-reviewer,
   progress-critic) — usual pattern.
2. **mathlib-analogist on direct chart-algebra rigidity vs
   (i.b)+(i.c) alternative** (per iter-139 strategy-critic
   must-fix #4). This is a route-evaluation consult; envelope
   estimate + Mathlib infrastructure check + comparison to existing
   (i.b)+(i.c) path. **Dispatch in parallel Wave 1 with the 3
   mandatory critics.**
3. **prover lane on `Cotangent/GrpObj.lean`** (the three sub-sorries
   at L581 + L585 + L624; bundled-or-split decision left to iter-140
   plan agent; recommend bundle if total LOC envelope projects under
   ~250 LOC, split otherwise). The mathlib-analogist iter-139 verdict
   provides the IsIso closure recipe via Route (b'2); the blueprint-
   writer iter-139 expansion provides the d_app + d_map recipes.
4. **§519 follow-up**: ground (iv) extension or auto-flag re-fire
   gated on the iter-140 prover lane outcome.
5. **§534 4-axis follow-up**: re-run with the iter-140 MEASURED
   cumulative LOC.

## Sorry inventory at iter-139 plan-phase close

| File | Decl using sorry | Inline sorry count | Notes |
|---|---|---|---|
| `Cotangent/GrpObj.lean` | 3 (`basechange_along_proj_two_inv_derivation` + `_basechange_along_proj_two` + `mulRight_globalises_cotangent`) | 4 (L581 + L585 + L624 + L752) | iter-140 prover lane targets L581+L585+L624; L752 (Main) gated on Step 2 closure |
| `Jacobian.lean` | 2 (`genusZeroWitness` + `positiveGenusWitness`) | 2 (L197 + L223) | M2.b + M3 scaffolds; off-critical-path |
| `RigidityKbar.lean` | 1 (`rigidity_over_kbar`) | 1 (L87) | M2.a scaffold; gated on pile closure |
| **Total** | **6 decls** | **7 inline** | unchanged from iter-138 close (no prover dispatch this iter) |

## Iter-139 verification

| Check | Status (iter-139 plan-phase close) |
|---|---|
| Sorry count per file | unchanged from iter-138 close (3 GrpObj + 2 Jacobian + 1 RigidityKbar = **6 decls / 7 inline**) — no prover dispatch this iter |
| `archon-protected.yaml` | unchanged (9 protected declarations); no protected signature touched this plan phase |
| New axioms | none introduced this plan phase |
| `USER_HINTS.md` | empty entering iter-139 (per the captured content in the invocation prompt); not modified by plan agent this iter |
| `STRATEGY.md` | 3 substantive edits this iter (§519 auto-flag execution + analogist-overhead axis + M3 off-loop PR lane); see § STRATEGY.md edits above |
| `lake build` | green at iter-138 close; iter-139 plan-agent edits are non-Lean (blueprint chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` 2-bullet addition + STRATEGY.md edits + plan.md sidecar). Blueprint chapter `RigidityKbar.tex` edited by Wave 2 writer (754 → 1222 LOC, +468 LOC; balanced LaTeX verified by writer). |
| Mandatory critics | 3 of 3 dispatched + returned + absorbed this iter; HARD GATE FIRES verdict from blueprint-reviewer absorbed via blueprint-writer dispatch + prover-lane deferral |
| Subagents dispatched this iter | 5 total (3 mandatory critics + 1 mathlib-analogist on IsIso routes + 1 blueprint-writer on `RigidityKbar.tex`) |
| HARD GATE per blueprint-reviewer | FIRES on `Cotangent/GrpObj.lean` — iter-139 prover lane DEFERRED to iter-140; blueprint-writer running this iter to clear gate |

## Response to iter-138 progress-critic watch flags (carried forward to iter-140 / iter-141)

- **Watch flag (i)** "single-blocker-doubling rule" (same
  `PresheafOfModules.pullback opacity` phrase across iters): **NOT
  TRIPPED iter-139** (no prover lane; the blocker phrase has not
  resurfaced in any iter-139 work product). Carries forward to
  iter-140.
- **Watch flag (ii)** "helper-construction acceptance test" (helper-
  only without body cut forbidden): **N/A iter-139** (no prover
  lane). Carries forward to iter-140 prover dispatch.

## Off-loop work this iter

- **M3 Route A Relative Spec functor lane opened** (per § STRATEGY.md
  Edit 3 above); off-loop work begins iter-139+; PR-extraction
  readiness criteria are tracked separately from M2 closure schedule.
- **M1.d Mathlib-PR candidate** (`kaehler_quotient_localization_iso`
  + `kaehler_localization_subsingleton`) continues off-loop from
  `analogies/relative-differentials-presheaf-bridge.md`; no plan-
  agent dispatch this iter.

## Rebuttal to strategy-critic CHALLENGE items not fully absorbed

The 4 alternative routes the strategy-critic surfaced have varying
severity; iter-139 absorbs the 2 major and 2 minor as follows:

- **Major alt 1: Direct chart-algebra rigidity bypassing (i.b)+(i.c)**:
  RECORDED for iter-140 mathlib-analogist dispatch (Must-fix #4
  absorbed by deferral to iter-140 Wave 1).
- **Major alt 2: Named-gap sorry for piece (iii)**: RECORDED in
  STRATEGY.md as an active alternative (not stall fallback) per
  Must-fix #5; in-tree commitment maintained with honest acknowledgement.
- **Minor alt 3: Upstream-first PR strategy for piece (iii)**: NOT
  ACTIONED iter-139 (the strategy-critic's own verdict is "the
  in-tree-first strategy is defensible"; a one-paragraph explicit
  comparison would close the gap but is not load-bearing this iter).
  Deferred to iter-144+ piece (iii) lane planning.
- **Minor alt 4: M3 Relative Spec functor as off-loop lane starting
  iter-139+**: ABSORBED via STRATEGY.md Edit 3 (Must-fix #3); this
  is the iter-139 ConcreteCommit.

## Soundness audit (final check)

- No new axioms proposed.
- No protected signatures touched.
- Plan-agent did NOT edit `.lean` files (only blueprint chapters +
  STRATEGY.md + PROGRESS.md + iter sidecar).
- Plan-agent did NOT write or test Lean proof bodies.
- Blueprint-reviewer HARD GATE absorbed cleanly (writer dispatch
  this iter; prover lane DEFERRED to iter-140 with the marker).
- 4-axis re-eval recorded explicitly per strategy-critic Must-fix
  #1 (both skeleton and projected LOC measurements, with axis
  weighting per iter-134 forward-merit guideline).
- §519 over-k auto-flag executed explicitly per Must-fix #2 (single-
  piece-tractability acknowledged, position taken, criterion named).
- All 7 strategy-critic must-fix items addressed (3 STRATEGY.md
  edits + 4 plan.md-recorded actions/decisions).
