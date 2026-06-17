# Iter-197 plan-agent run

## Headline outcome (in flight as of writing)

**The "process iter-196 outcomes (86 → 85 sorries, −1, 16-consecutive-
zero-axiom-build streak) + address 5 lean-vs-blueprint-checker
must-fix-this-iter findings gating Lane H + Lane E + BareScheme
prover re-dispatch + dispatch 6 plan-phase subagents (3 blueprint-
writers fixing HARD-GATE-must-fixes, 1 refactor relocating BareScheme
smoothness, 1 mathlib-analogist on Pic⁰ ker(deg) pivot, 1 progress-
critic on iter-197 trajectories) + use same-iter fast-path scoped
blueprint-reviewer to clear HARD GATE for Lane H + Lane E + BareScheme
iter-197 prover dispatch + apply CRIT-3 OCofP \uses fix directly +
6 prover lanes scoped per progress-critic-respecting closure targets
with explicit unconditional fallbacks on contingent lanes" iter.**

iter-196 returned `lake build` GREEN with **85 sorries / 0 axioms**
(16th consecutive zero-axiom build). Net trajectory 86 → 85 (−1).
ALL 6 prover lanes returned `done` (no API 529 errors); 4 of 6 HARD
BARs met via substantive structural advance + named-residual
reduction; 0 top-level sorries closed. Substantive iter-196 gains:
- BareScheme: 5 axiom-clean MvPolynomial substrate decls +
  cover-reduction wrapper landed.
- Lane E: 2 of 3 substrate primitives axiom-clean
  (`Proj.awayι_preimage_basicOpen_self`,
  `Proj.awayι_eq_specMap_fromSpec`); step (ii) blocked by
  dependent-motive issue with named workaround.
- Lane H: empty branch of `constant_of_irreducible` + outer step of
  `skyscraperSheaf_eq_pushforward_const` CLOSED axiom-clean.
- Lane A: sub-claims (a)+(b) of
  `exists_nonconstant_rational_from_dim_eq_two` CLOSED axiom-clean
  via `toFunctionField_injective`; (c) EXTRACTED to typed substrate.
- Lane I: Route 2 PID-transfer body LANDED axiom-clean modulo single
  named residual `hy_ne_bot` (~5-10 LOC).
- Lane RCI: helper (a) body REFORMULATED via Mathlib
  `LocallyQuasiFinite.of_finite_preimage_singleton`; concrete
  `(φ.left ⁻¹' {x}).Finite` gap exposed.

## User hint

No user hints this iteration. The iter-192 standing user hint (push
beyond HARD BAR; mathlib-build + fine-grained modes; bottom-up build;
big progress) remains the active framing.

## Reviewer must-fix-this-iter findings (gate prover re-dispatch per HARD GATE)

iter-196 review-phase ran 6 `lean-vs-blueprint-checker` dispatches.
3 returned must-fix-this-iter findings that HARD-GATE prover re-
dispatch on the named files:

- **CRIT-0 (Lane H)** — H1V chapter (`RiemannRoch_H1Vanishing.tex`)
  has 3 must-fix items: (a) non-empty branch of
  `lem:isFlasque_constant_irreducible` sketch under-specifies the
  Mathlib sheafification-unit-iso gap; (b) `Nonempty (iso)` signature
  weakening on `skyscraperSheaf_eq_pushforward_const` undocumented;
  (c) inner-iso blocking step not pinned. BLOCKS H1Vanishing.lean
  iter-197 prover.
- **CRIT-0a (Lane E)** — AVR chapter has 1 must-fix: missing
  `\begin{lemma}` block for `Proj.basicOpenIsoSpec_inv_app_top` (the
  iter-196 prover's named missing intermediate that caused the
  dependent-motive blocker). BLOCKS AbelianVarietyRigidity.lean
  iter-197 prover.
- **CRIT-0b (BareScheme)** — consolidated AVR chapter has 1 must-fix:
  under-specified `lem:projectiveLineBar_geomIrred` sketch
  (missing Helper A: `Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K`). BLOCKS
  BareScheme.lean iter-197 prover. SAME chapter as CRIT-0a — one
  writer dispatch covers both.
- **CRIT-3 (OCofP)** — chapter has 1 broken `\uses{...}` (`\leanok`
  token inside `\uses{}` arg, blueprint-doctor confirmed) + 2 broken
  `\lean{...}` pins (`order_conditions_of_globalSection`,
  `principal_ne_zero_of_nonconstant`). Major, not must-fix. Plan
  agent applied the `\uses` fix directly this iter (1-line edit);
  blueprint-writer handles the pin renames.

## Plan-phase dispatches (7 total — 6 parallel + 1 fastpath sequential)

| Subagent | Slug | Status (final) |
|---|---|---|
| blueprint-writer | `h1v-mustfix-iter197` | **COMPLETE** — 3 must-fixes + 3 majors addressed; new `lem:skyscraperSheaf_iso_constantSheaf_punit` sub-lemma block + `lem:isFlasque_injective` pin added |
| blueprint-writer | `avr-barescheme-mustfix-iter197` | **COMPLETE** — 2 must-fixes (M-1 `basicOpenIsoSpec_inv_app_top` block; M-3 `geomIrred` 5-helper recipe) + 8 majors (J-1 to J-5 pins/footnotes); Step 1 rewrite for `lem:awayi_app_basicOpen` lands |
| blueprint-writer | `ocofp-pin-cleanup-iter197` | **COMPLETE** — 3 broken pins re-anchored to existing private helpers (`globalSections_iff_mpr`, `functionField_const_of_complete_curve_of_orderZero`); old labels grep zero matches |
| refactor | `barescheme-smoothness-relocation` | **COMPLETE** — `projectiveLineBar_smoothOfRelDim` + `_smooth_chart_aux` relocated to ChartIso.lean (Option a — no new file); build GREEN; sorry count unchanged (relocation only) |
| mathlib-analogist | `pic0-ker-deg-pivot` | **COMPLETE — STRUCTURAL_OK**; pivot to `PicScheme.degComp` sanctioned via Kleiman `thm:Pphifin` / Milne III.1; saves ~10–18 iters; A.3.i excised; persistent file `analogies/pic0-ker-deg-pivot.md` |
| progress-critic | `route197` | **COMPLETE — MIXED**; 4 STUCK (BareScheme, E, A, RCI) + 2 CHURNING (H, I); must-fix corrective: HOLD Lane RCI (OVER_BUDGET); other correctives in flight |
| blueprint-reviewer | `iter197-fastpath` | **COMPLETE — HARD GATE CLEAR** for all 4 patched chapters (H1V, AVR via consolidated, BareScheme via consolidated, OCofP); 0 new must-fix; 2 "soon" non-blocking notes |

All four prover-target files cleared for iter-197 dispatch:
H1Vanishing.lean (Lane H), AbelianVarietyRigidity.lean (Lane E),
BareScheme.lean / ChartIso.lean (Lane BareScheme), OCofP.lean
(Lane A).

## Subagent skips

- **strategy-critic** — `STRATEGY.md` unchanged since iter-196
  restructure that addressed all 7 prior CHALLENGES (recorded as
  "addressed" in iter-196 plan.md); no STRATEGY.md edits planned
  this iter beyond the post-iter-197 phase-count refresh; mathlib-
  analogist `pic0-ker-deg-pivot` is the live strategic consult for
  this iter (its verdict drives STRATEGY.md edits NEXT iter).
- **blueprint-reviewer** (initial dispatch) — instead, the same-iter
  fast-path scoped review runs AFTER blueprint-writers return; the
  6 `lean-vs-blueprint-checker` per-chapter reports from iter-196
  already provide the chapter-by-chapter audit signals the plan agent
  acts on this iter.

## Strategy updates (STRATEGY.md edited iter-197 plan-phase)

1. **A.3.i — IdentityComponent EXCISED.** Per
   `mathlib-analogist pic0-ker-deg-pivot` verdict `STRUCTURAL_OK`,
   A.3.i is removed from the critical path. The "Phases &
   estimations" table row was deleted; the "Pic⁰ definition pivot"
   paragraph in Routes was rewritten from "pending consult" to
   "SANCTIONED iter-197"; dependency graph updated to make A.3.ii
   depend on A.3.vii (degree map) instead of A.3.i. Persistent
   rationale: `analogies/pic0-ker-deg-pivot.md`. Literature
   anchors: Kleiman §6 `ex:curves` (line 4665 of
   `references/kleiman-picard-src/kleiman-picard.tex`); Milne III.1
   p.87 (`references/abelian-varieties.pdf`).
2. **A.3.ii — Pic⁰ via degComp** repackaged: `Pic⁰_{C/k} :=
   PicScheme.degComp C 0`, the degree-0 stratum from Kleiman's
   Hilbert-polynomial decomposition (`thm:Pphifin`). Total iter
   savings: ~10–18 iters. ABI of `Pic0Scheme C` preserved
   (downstream consumers compile unchanged). The "Pic⁰ = identity
   component" equivalence becomes a deferrable theorem.
3. **Lane RCI HELD iter-197** per progress-critic OVER_BUDGET
   verdict; STRATEGY.md row updated to reflect prover-HELD status.

## Decision made (immediate, iter-197)

### Decision D-1: Honor the lean-vs-blueprint-checker HARD GATE

The reviewer reports gate Lane H + Lane E + BareScheme prover re-
dispatch until the blueprint chapters are patched. Plan agent
dispatched blueprint-writers in plan phase + will follow with scoped
fastpath review. If fastpath clears, prover dispatches proceed THIS
iter. If fastpath fails (writer didn't fully address must-fix), the
gated files defer to iter-198. This is the iter-196 review's
prescribed unblock path; the plan agent commits to it.

**Why over alternatives**:
- Bypassing the HARD GATE and dispatching provers anyway would
  re-encounter the iter-196 dependent-motive blocker on Lane E
  (already documented) and the underspecified Mathlib gaps on Lane
  H — wasting another iter's prover budget.
- Deferring all 3 lanes to iter-198 (skip writer dispatches + scoped
  review) burns an entire iter on plan-phase work alone, which is
  the failure mode the same-iter fast path is designed to avoid.
- The writer dispatches are tightly scoped (single chapter each, ≤
  150 LOC growth budget); risk of writer-induced regression is low.

### Decision D-2: BareScheme smoothness relocation

The iter-196 prover task report explicitly recommended relocating
`projectiveLineBar_smoothOfRelDim` to a downstream file where the
chart-ring iso `homogeneousLocalizationAwayIso` is in scope, enabling
~10 LOC closure of the per-chart sorry via
`Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv`. Refactor
subagent dispatched with explicit "do not close sorries" directive.
Prover then closes the per-chart sorry in iter-197+ as a separate
lane.

**Why over alternatives**:
- Duplicating `homogeneousLocalizationAwayIso` in BareScheme.lean
  would be ~80+ LOC of code duplication — wasteful and brittle.
- Leaving the per-chart sorry indefinitely defers the BareScheme
  cascade that gates Lane RCI helper (a) "smooth-dim-1 ⟹ 0-dim
  fibre" route.

### Decision D-3: Lane A multi-iter substrate-build commit

The iter-196 Lane A close required extracting
`functionField_const_of_complete_curve_of_orderZero` as a typed
substrate (Stacks 02P0 / Hartshorne I.3.4 gap, ~80-150 LOC
project-side build over 2 sub-helpers: algebraic Hartogs + Γ=k̄).
iter-197 commits the FIRST sub-helper (algebraic Hartogs at codim-1
on a Noetherian regular-in-codim-one scheme).

**Why over alternatives**:
- Indefinitely deferring the substrate-build leaves Lane A's
  headline result `exists_nonconstant_genusZero` gated on a sorry
  with no closure path — the standing "owed iter-N+" gap.
- The Mathlib gradient strategy (`prover.md` § Mathlib gradient)
  says: every sorry must EITHER have no proof route OR have an
  explicit next-objective substrate-build. Lane A pivots from the
  former (waiting) to the latter (building) this iter.

### Decision D-4: Lane RCI HELD iter-197 (REVISED post-progress-critic)

**Initial draft**: narrow dispatch on generic-point branch
(~30 LOC).
**Final**: HELD per progress-critic `route197` STUCK + OVER_BUDGET
must-fix verdict.

**Why I reversed**:
- progress-critic's verbatim guidance: *"deploying a prover to a
  route the strategy explicitly marks as paused and OVER_BUDGET,
  without first revising the strategy, undermines the OVER_BUDGET
  mechanism. The single well-scoped target (generic-point branch,
  ~30 LOC) does not justify bypassing the strategic checkpoint."*
- The narrow closure does NOT unblock the headline goal
  `nonempty_jacobianWitness` — RCI feeds RR.4, which is itself
  paused pending USER escalation. Closing the generic-point branch
  while RR.4 is paused is value-misaligned work.
- The discipline of HOLD → revise → re-open is what makes the
  OVER_BUDGET flag meaningful. Continuing to dispatch erodes the
  flag's force.

**Effect**: Lane RCI dropped from iter-197 prover objectives.
STRATEGY.md row updated to reflect HELD status. iter-198 re-engages
only after STRATEGY.md decision on `IsNormalScheme` scope + LQF
closed-point scope OR after USER RR.4 input.

## Carrier-soundness probe status (iter-196 commitment)

iter-196 plan-phase landed `refactor carrier-soundness-fgapic`:
6 carriers → `Functor.IsRepresentable` pattern; sorry count
unchanged. iter-197 has NO new probe activity scheduled. Per the
strategy-critic iter-196 abort criterion: if `lean_verify` shows
silent `sorryAx` propagation through typeclass synthesis at iter-198
(probe end), revert. Lean-auditor iter-196 flagged the
`HasPicScheme → HasPicSharp` co-dependency as **major (M1)** —
worth a `lean_verify` smoke check in iter-198 review phase. Plan
agent commits to that smoke check as part of iter-197 review
phase OR iter-198 plan phase (whichever happens first).

## CRIT-3 OCofP \uses fix (applied directly this iter)

Patch in chapter `RiemannRoch_OCofP.tex` line 692-695: moved
`\leanok` from inside the `\uses{...}` arg to a separate line
immediately preceding the `\uses{...}`. Verified the change with
`Edit`. This unblocks the blueprint-doctor finding for iter-197.

## Tool substitutions

None this iter.

## Iter-197 prover objectives (FINAL — all dispatches returned + HARD GATE CLEAR)

5 prover lanes (Lane RCI dropped per Decision D-4). All HARD-GATE-
blocked lanes are CLEAR per `blueprint-reviewer iter197-fastpath`.
Per-lane details: `.archon/iter/iter-197/objectives.md`.

1. `ChartIso.lean` — close per-chart smoothness aux (~10 LOC)
   post-relocation. [prover-mode: prove]
2. `AbelianVarietyRigidity.lean` — Lane E build 3 helpers +
   2 consumer closures (~25-45 LOC). [prover-mode: prove]
3. `WeilDivisor.lean` — Lane I close `hy_ne_bot` (~5-10 LOC) +
   exploration of `degree_positivePart_principal_eq_finrank`.
   [prover-mode: prove]
4. `OCofP.lean` — Lane A begin substrate-build for algebraic
   Hartogs sub-helper (~30-60 LOC). [prover-mode: mathlib-build]
5. `H1Vanishing.lean` — Lane H Route A (constantSheaf Full/Faithful
   on IrreducibleSpace) OR Route B (direct pointwise construction
   of inner iso) (~50-80 LOC). [prover-mode: mathlib-build]

(File count: 5 — within cap of 10.)

## Prior critique status

- **strategy-critic iter-196 CHALLENGE** — 7 fronts addressed in
  iter-196 STRATEGY.md restructure (recorded as "addressed").
- **progress-critic iter-196 MIXED** — 8 must-fix items, all
  addressed in iter-196 plan phase OR pulled forward to iter-197
  (Lane H scope reduction LANDED; Lane E analogue consult LANDED;
  Lane A blueprint expansion LANDED; Lane I refactor LANDED; Lane
  RCI scope reduction LANDED; Lane F blueprint expansion LANDED).
  Re-dispatched this iter as `progress-critic route197`.
- **lean-auditor iter-196 NO MUST-FIX** — 3 prior must-fix items
  RESOLVED via iter-196 must-fix-demotions refactor. M1 (FGAPicRep
  carrier co-dependency) flagged as major; `lean_verify` smoke
  check scheduled iter-197 review or iter-198 plan.

## Estimation update (will reflect in STRATEGY.md only if changed)

No STRATEGY.md edits this iter. The phase Iters-left + velocity
figures remain as set in iter-196. Pic⁰ pivot consult landing
mid-iter could trigger a STRATEGY.md restructure NEXT iter — that
edit is gated on the analogist verdict.

## Notes for iter-197 review phase

- Run `lean_verify` on a sample protected declaration consuming
  `[HasPicScheme C]` to check for silent sorryAx propagation through
  the carrier-soundness chain. This is the iter-196 strategy-critic
  abort-criterion check; surfacing it explicitly so the review agent
  doesn't miss it.
- Dispatch `lean-auditor` and per-file `lean-vs-blueprint-checker`
  for any file modified by iter-197 provers.
- The Pic⁰ analogist file `analogies/pic0-ker-deg-pivot.md` should
  exist by review time; the review agent should skim it as context
  for STRATEGY revisions.
