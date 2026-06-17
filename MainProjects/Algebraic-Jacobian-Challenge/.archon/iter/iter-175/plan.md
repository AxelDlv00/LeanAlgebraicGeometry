# Iter-175 plan-agent run

## Headline outcome

**The "STUCK-trigger fires on Route 1; structural refactor + analogist
structural pivot + 10-lane prover fan-out" iter.** progress-critic
`route175` returned STUCK on Route 1 (fourth consecutive PARTIAL-low,
≥10 helpers added with 0 top-level closure across 5 iters,
OVER_BUDGET 8 vs `~3–6` estimate); strategy-critic `route175` returned
CHALLENGE on Route A (sub-phase decomposition deferral for A.2.a /
A.2.b / A.4.d, LOC bands under-counted, format DRIFTED, axiomatise-then-replace
option missing). Plan-phase actions:

1. **G0BO split refactor** (deferred from iter-174 with explicit
   reversal trigger) — fires THIS iter as the structural response to
   the STUCK trigger arm.
2. **Two mathlib-analogist consults** — `chart-bridge-structural-pivot`
   (Lane A iter-175 required reading; supersedes `chart-bridge-shared-helper.md`)
   + `dvr-rationalmap-order` (Lane D iter-175 RationalMap.order body).
3. **Five blueprint-writers** — `fgapic-empty-uses-fix` (MUST FIX
   per blueprint-doctor; blocks depgraph), `rr-broken-uses-fix`
   (broken `\uses{cor:nonconstant_function_genus_zero}`),
   `g0bo-helper-pins` (LVB MAJOR; 2 missing iter-174 helper pins),
   `a4d-sym-g` (Route ii Sym^g re-dispatch — replaces moduli
   sub-lemmas), `weildivisor-doc-updates` (LVB MAJOR; junk-branch
   convention + RationalMap.order Lean-signature-scope).
4. **STRATEGY.md restructure** — absorbs all 6 strategy-critic
   CHALLENGE findings: A.2.a decomposed into A.2.a.i/ii/iii (generic
   flatness; noetherian induction; stratum glueing); A.2.b decomposed
   into A.2.b.i/ii/iii (Grassmannian; flat-locus open subscheme; Quot
   assembly); A.4.d split into A.4.d.i (Sym^g sub-build) + A.4.d.ii
   (Albanese UP wiring); LOC bands widened (A.2.a → ~2000–3500 LOC,
   A.2.b → ~2600–5000 LOC); axiomatise-then-replace recorded in
   Open Questions as TRACKED, NOT COMMITTED; `k̄→k` descent LOCKED to
   Spec-k-direct route with explicit reversal trigger; format trimmed
   under 12 KB; per-iter narrative stripped.
5. **Scoped blueprint-reviewer fast-path** after writers + refactor
   land — HARD GATE clearance for 7 file-skeleton lanes opening
   THIS iter.
6. **10 prover lanes** at cap: Lane A1 (post-split GmScaling.lean
   chart_PLB_eq Step C + chart_agreement cross), Lane B (RelativeSpec
   body), Lane D (WeilDivisor RationalMap.order body), 7 file-skeleton
   lanes on the 10 iter-174 chapters (3 deferred to iter-176).

## Critic verdicts (this iter)

| Critic | Slug | Verdict |
|---|---|---|
| progress-critic | `route175` | **Route 1 STUCK** (4 consec PARTIAL, OVER_BUDGET 8 vs ~3–6 estimate); Routes 2/3 CONVERGING; Route 4 UNCLEAR. **Primary corrective = analogist consult; secondary = G0BO split.** 3 plan-phase gates confirmed. |
| strategy-critic | `route175` | **CHALLENGE on Route A** (sub-phase deferral; LOC under-count); **SOUND on Route C**. 6 CHALLENGEs all addressed in STRATEGY.md restructure. |
| blueprint-reviewer | `iter175-whole` | 23 chapters audited. 7 file-skeleton chapters (Lanes E–K) HARD GATE CLEAR. 3 chapters must-fix flagged: `AbelianVarietyRigidity.tex` (g0bo-helper-pins writer landed mid-review; RESOLVED via fast-path); `RiemannRoch_WeilDivisor.tex` (weildivisor-doc-updates landed mid-review; RESOLVED via fast-path); `Picard_RelativeSpec.tex` (stale `\leanok` markers — `sync_leanok` queued for iter-176 investigation). |
| blueprint-reviewer | `iter175-fastpath` | Scoped re-review of AVR + WeilDivisor post-writer landings — clears HARD GATE for Lane A1 + Lane D this iter. |

## STUCK-trigger response decision

Per progress-critic `route175`: "the load-bearing corrective is the
analogist consult — not the split — because the analogist's chart-bridge
structural-pivot recipe is the only action that directly closes the
iter-174 Fin syntactic mismatch."

**Decision**: dispatch BOTH the analogist consult AND the G0BO split
refactor this plan-phase. The split is an adjunct (hygiene + future
work surface) but does not close the Fin mismatch on its own; the
analogist consult is the load-bearing closure recipe.

**Re-arm for iter-176**: if iter-175 Lane A returns PARTIAL on
`Genus0BaseObjects/GmScaling.lean` with the Fin mismatch still open
OR substitutes another fresh helper for Step C, the iter-176 plan
agent MUST execute a route-pivot decision (differential
`H⁰(ℙ¹, O(-2))=0` char-0 sub-case per the iter-164 reversal trigger,
or user escalation in `TO_USER.md`). No sixth helper-substitution
iter.

## Decision made (`k̄→k` descent direction)

Per strategy-critic `route175` minor CHALLENGE: promoted the
`k̄→k` descent Open Question from "direction unconfirmed" to a
committed decision THIS iter.

**Decision**: **Route (i) — Spec-k-direct.** The genus-0 witness
body proves `IsAlbanese C P J` directly over `Over (Spec k)` by
checking the universal property at the structural morphism
`C → Spec k`. A factorisation `α : J = Spec k → A` is constant on
points; the equality `f = α ∘ P` reduces to equality on the generic
fibre, available via faithfully-flat descent along
`Spec k̄ → Spec k`. No need to build `C_{k̄} ≅ ℙ¹` as a separate
intermediate.

**Rationale**: Route (i) skips the `C_{k̄} ≅ ℙ¹` intermediate (which
the RR.1/2/3/4 sub-build supplies, but on `C_{k̄}`, not `C`); the
descent step (faithfully-flat over `Spec k̄ → Spec k`) is a small
Mathlib-available step.

**Reversal trigger**: if `genusZeroWitness.key` body fill blocks on
the descent step iter-180+, reconsider via `C_{k̄} ≅ ℙ¹`.

## Decision made (axiomatise-then-replace staging — NOT COMMITTED)

Per strategy-critic `route175` major CHALLENGE: recorded the
axiomatise-then-replace option in `## Open strategic questions` as
**TRACKED, NOT COMMITTED**.

**Rationale**: end-state still demands kernel-only axioms, so any
axiomatisation is a workflow tactic, not a strategy. The option is
worth tracking because it collapses Route A's critical path from
~80–130 iters to ~20–30 for a *working* axiomatised build, giving
an early end-to-end sanity check that the dependency graph closes.

**Decision trigger**: if iter-180 Route A velocity remains `~0/it`
on the file-skeleton lanes opening this iter, escalate to user-level
option-choice (axiomatise vs persist in-tree build) in `TO_USER.md`.

## Plan-phase subagent dispatches (all landed)

### Critics (parallel batch, all COMPLETE)

- `progress-critic route175` — COMPLETE. STUCK on Route 1 (4 consec
  PARTIAL, OVER_BUDGET 8 vs ~3–6 estimate); CONVERGING on 2, 3;
  UNCLEAR on 4. Primary corrective = analogist consult.
- `strategy-critic route175` — COMPLETE. CHALLENGE on A; SOUND on C.
  6 CHALLENGEs absorbed into STRATEGY.md restructure.
- `blueprint-reviewer iter175-whole` — COMPLETE. 23 chapters audited.
  7 file-skeleton chapters HARD GATE CLEAR. 3 must-fix flags noted
  above.

### Mathlib-analogists (parallel batch, both COMPLETE)

- `mathlib-analogist chart-bridge-structural-pivot` — COMPLETE.
  Cross-domain-inspiration mode. **Top suggestion = Option (a)
  syntactic bridge**: `simp only [Fin.isValue, Fin.zero_eta]` (case
  «0») + `simp only [Fin.isValue, Fin.mk_one]` (case «1») immediately
  after `unfold gmScalingP1_cover_X_iso gmScalingP1_cover`. Empirically
  verified via `lean_multi_attempt` on the actual iter-174 goals. ~2
  LOC, no new helpers, no structural refactor. Cross-case ring
  identity recipe (5-step Mathlib lemma chain) provided for
  `chart_agreement` `(0,1)`/`(1,0)`. Persisted to
  `analogies/chart-bridge-structural-pivot.md` (363 LOC).
- `mathlib-analogist dvr-rationalmap-order` — COMPLETE. Api-alignment
  mode. **Recipe** = `WithZero.log (Ring.ordFrac (X.presheaf.stalk
  Y.point) f)` with `[Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]`
  explicit typeclass argument (Decision 3 NEEDS_MATHLIB_GAP_FILL on
  `Order.coheight = 1 → KrullDimLE 1` bridge; workaround = explicit
  typeclass arg). Persisted to `analogies/dvr-rationalmap-order.md`
  (190 LOC).

### Refactor (COMPLETE)

- `refactor g0bo-split` — COMPLETE. Split
  `AlgebraicJacobian/Genus0BaseObjects.lean` (1321 LOC actual) into
  4 sub-files (`BareScheme.lean` 225 LOC / `ChartIso.lean` 380 LOC
  / `Points.lean` 268 LOC / `GmScaling.lean` 538 LOC) + a 4-import
  re-export shim. `lake build AlgebraicJacobian` exits 0; project-wide
  sorry-warning count unchanged at 30 (per refactor report). Visibility
  tweak: lifted `private` modifier on `otherFin` and
  `homogeneousLocalizationAwayIso_algebraMap` (cross-module
  consumption from `GmScaling.lean`); no other declaration changes.
  Extended `% archon:covers` on AVR chapter to list all 4 new
  sub-files (verified by reviewer).

### Blueprint writers (all 5 COMPLETE)

- `blueprint-writer fgapic-empty-uses-fix` — COMPLETE. Both empty
  `\uses{}` matches were prose mentions of the syntax (L619 + L640
  inside the "Internal-consistency check" section), not real
  annotations; rewritten as `\texttt{\textbackslash uses}` so plastex
  no longer parses them as commands. depgraph build unblocked.
- `blueprint-writer rr-broken-uses-fix` — COMPLETE. Branch A applied:
  added alias `\label{cor:nonconstant_function_genus_zero}` on the
  existing `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero`
  corollary in `RiemannRoch_OCofP.tex` (single 3-line additive edit).
  Both broken `\uses{}` sites in `RationalCurveIso.tex` now resolve.
- `blueprint-writer g0bo-helper-pins` — COMPLETE. Added 2 missing
  `\lean{...}` blocks: `homogeneousLocalizationAwayIso_algebraMap`
  at L1187 + `gmScalingP1_chart_PLB_eq` at L1441 of
  `AbelianVarietyRigidity.tex`. iter-175 LVB MAJOR finding closed.
- `blueprint-writer a4d-sym-g` — COMPLETE. End-to-end Route ii
  refactor of `Albanese_AlbaneseUP.tex`: removed
  `lem:poincare_bundle_pullback` + `lem:moduli_pullback_morphism`
  (moved to `% NOTE: Alternative route history` block at end);
  added `def:symmetric_power_curve`, `lem:symmetric_product_av_map`,
  `lem:symmetric_product_to_jacobian`,
  `lem:descent_through_birational_sigma`; refactored main
  `thm:albanese_universal_property` `\uses{}` and proof body to
  follow Milne Prop 6.1 Sym^g chain. Per `iter175-whole` reviewer:
  HARD GATE CLEARS.
- `blueprint-writer weildivisor-doc-updates` — COMPLETE.
  (1) Rewrote L412-L446 "Lean signature scope" of
  `def:divisor_closed_point` to document the iter-174 junk-branch
  convention with `\begin{cases}` formalisation.
  (2) Added `lem:ofClosedPoint_eq_single` (L449-L471) +
  `lem:ofClosedPoint_eq_zero` (L473-L496) bridge equation lemma
  pins.
  (3) Added Lean-signature-scope paragraph to `def:order_at_point`
  (L297+) integrating the analogist recipe verbatim (Ring.ordFrac
  + WithZero.log + KrullDimLE 1 explicit typeclass).

### Scoped blueprint-reviewer fast-path (COMPLETE)

- `blueprint-reviewer iter175-fastpath` — COMPLETE. **HARD GATE
  CLEARS — no findings.** Both AVR + WeilDivisor chapters audited
  `complete: true, correct: true`. Lane A1 + Lane D unblocked this
  iter. Lane B's `Picard_RelativeSpec.tex` stale `\leanok` remains a
  sync_leanok concern (out of scope for writers; queued for iter-176
  sync_leanok investigation per project CLAUDE.md). Lane B proceeds:
  the prover lane targets the iter-173 weaker Lean encodings, which is
  what the iter-174 review documented as a "stepping-stone before the
  full Yoneda-bijection refinement" — the body-fill is consistent with
  the Lean signatures even if the chapter's `\leanok` markers
  overpromise.

## Plan-phase gates — all 3 confirmed

Per progress-critic `route175` requirement:

1. **G0BO split landed green**: ✓ `lake build AlgebraicJacobian` exits
   0 per refactor report; 30 sorry warnings unchanged. 4 sub-files +
   re-export shim verified.
2. **DVR analogist consult landed**: ✓
   `analogies/dvr-rationalmap-order.md` exists with concrete recipe.
3. **Scoped blueprint-reviewer HARD GATE clears**: ✓ both AVR +
   WeilDivisor cleared by `iter175-fastpath`; 7 file-skeleton chapters
   already cleared by `iter175-whole`. All 10 prover lanes go.

### Strategy-critic round 2 (DEFERRED)

Not re-dispatched this iter. STRATEGY.md restructure addresses all 6
CHALLENGEs; the re-dispatch criterion (SHA-changed + still-live
CHALLENGE) is met by the restructure. Re-evaluate iter-176 plan-phase.

## Prover lane scope (iter-175)

10 prover lanes total, at the dispatch cap. Composition: 3 body
lanes + 7 file-skeleton lanes. Details in
`iter/iter-175/objectives.md`.

### Body lanes (3)

- **Lane A1** — `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
  (post-split target). Close `gmScalingP1_chart_PLB_eq` Step C `i=0`/`i=1`
  cases + `gmScalingP1_chart_agreement` cross cases `(0,1)`/`(1,0)`
  via the analogist `chart-bridge-structural-pivot` recipe.
  **Required reading**: `analogies/chart-bridge-structural-pivot.md`
  (supersedes `chart-bridge-shared-helper.md`). Lane is authorised to
  **restructure `gmScalingP1_cover_X_iso`** if the analogist
  recommends.

- **Lane B** — `AlgebraicJacobian/Picard/RelativeSpec.lean`. Open
  body lane on the 5 downstream sorries: subset to attack is
  `RelativeSpec` body (L160), `structureMorphism` (L171),
  `affine_base_iff` (L230) per the iter-174 review's `analogies/qcohalgebra-structure.md`
  recipe. Hard scope-discipline: 3 sorries max attacked.

- **Lane D** — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`. Open
  body lane on `RationalMap.order` (L140) per the analogist
  `dvr-rationalmap-order` recipe.
  **Required reading**: `analogies/dvr-rationalmap-order.md`.

### File-skeleton lanes (7, priority by parallel-startability)

- **Lane E** — `AlgebraicJacobian/Picard/FlatteningStratification.lean`
  (A.2.a — top parallel-startable Route A).
- **Lane F** — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
  (A.4.b — independently startable on Mathlib side).
- **Lane G** — `AlgebraicJacobian/Picard/RelPicFunctor.lean`
  (A.1.c — wires A.1.a + A.1.b).
- **Lane H** — `AlgebraicJacobian/Picard/QuotScheme.lean`
  (A.2.b — Grassmannian sub-build inside chapter; file-skeleton viable
  even though body gated on A.2.a).
- **Lane I** — `AlgebraicJacobian/Picard/FGAPicRepresentability.lean`
  (A.2.c — small assembly chapter).
- **Lane J** — `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean`
  (A.4.c — small assembly).
- **Lane K** — `AlgebraicJacobian/RiemannRoch/OCofP.lean`
  (RR.3 — extracts non-constant function via genus-0 RR).

### Deferred to iter-176

- `Albanese/CodimOneExtension.lean` — A.4.a, risk-dominant; complex
  chapter; deferred to spread risk.
- `Albanese/AlbaneseUP.lean` — A.4.d, file-skeleton waits for
  `blueprint-writer a4d-sym-g` to land Sym^g sub-lemma pins THIS iter,
  but the file-skeleton lane fires iter-176 (avoids race condition with
  writer's chapter rewrite).
- `RiemannRoch/RationalCurveIso.lean` — RR.4, gated on RR.3 spec
  refinement + RR.1 body landing.

## Plan-phase gate sequence (per progress-critic `route175`)

Before opening the prover phase, plan agent confirms:

1. **G0BO split landed green**: `lake build AlgebraicJacobian` exits
   0 after refactor returns. Sub-files `BareScheme.lean`,
   `ChartIso.lean`, `Points.lean`, `GmScaling.lean` exist and import
   the right prefixes. Re-export shim at `Genus0BaseObjects.lean`
   compiles. If split fails, Lane A1 DEFERS to iter-176; plan agent
   records the deferral in the iter sidecar and dispatches a refactor
   cleanup directive iter-176.

2. **DVR analogist consult landed**: `analogies/dvr-rationalmap-order.md`
   exists with concrete Mathlib API recipe. If absent, Lane D DEFERS
   to iter-176.

3. **Scoped blueprint-reviewer HARD GATE clear**: scoped review of
   the 10 iter-174 chapters returns each as `complete: true AND
   correct: true AND no must-fix-this-iter`. Per-chapter: if any of
   the 7 file-skeleton-target chapters fails the gate, drop that
   file-skeleton lane (replacement: scale to 6 or 5; do NOT lower
   lane count below 3 body lanes + 4 file-skeletons).

## Alternative dispatch shapes considered

- **Skip G0BO split this iter, defer to iter-176**: rejected. iter-174
  plan committed to firing G0BO split iter-175 with an explicit
  reversal trigger (the trigger required Lane A iter-174 to land
  COMPLETE; it returned PARTIAL-low; per the trigger, the split fires
  iter-175). Skipping would be 6th consecutive iter without structural
  change on Route 1 — STUCK-by-inaction.
- **Skip the 7 file-skeleton fan-out, focus on 3 body lanes only**:
  rejected. iter-174 plan-phase landed 10 chapters and committed
  file-skeleton lanes to iter-175. Without the fan-out, every iter
  shows ~3 file objectives, choking Route A's parallel-startability.
- **Open 10 body lanes instead of 3 body + 7 file-skeletons**:
  rejected. No body lane is ready on the 7 chapters whose `.lean`
  files don't exist yet. File-skeletons are the prerequisite.
- **Replace the chart-bridge analogist consult with a `convert ... using N` ad-hoc patch**:
  rejected per progress-critic STUCK verdict and analogist consult
  recommendation. The Fin syntactic mismatch is a Mathlib-API alignment
  issue; a structural recipe from the analogist is the right closure.

## Strategy-modifying findings (post-restructure)

STRATEGY.md restructure absorbs strategy-critic `route175`'s 6
CHALLENGEs. No new findings surfaced beyond those addressed.

If iter-175 writer `a4d-sym-g` surfaces a Sym^g-sub-build issue
inconsistent with the A.4.d.i decomposition, the iter-176 plan agent
re-issues a writer directive splitting A.4.d.i further into its own
sub-phases. Currently treating A.4.d.i as a ~400–700 LOC sub-build.

## Iter-176 commitments (preliminary)

1. **Lane A1 post-mortem & re-arm**: if iter-175 returns PARTIAL again
   on `Genus0BaseObjects/GmScaling.lean` with Fin mismatch still open,
   execute route-pivot decision (no sixth helper-substitution round).
2. **`Albanese/CodimOneExtension.lean`** file-skeleton (A.4.a —
   deferred from iter-175 to spread risk).
3. **`Albanese/AlbaneseUP.lean`** file-skeleton (post-`a4d-sym-g`
   writer landing iter-175).
4. **`RiemannRoch/RationalCurveIso.lean`** file-skeleton (post-RR.3
   spec refinement).
5. **Body lanes on chapters whose file-skeletons landed iter-175**:
   prioritise A.1.c, A.4.b, A.4.c (small assemblies).
6. **`iotaGm_isDominant`** (AVR L86): `infer_instance`-closeable once
   GmScaling Lane A iter-175 lands `gmScalingP1` axiom-clean.
7. **`gmScalingP1_collapse_at_zero`** (GmScaling.lean L1202 post-split):
   gated on Lane A iter-175 Step C closure.
8. **Strategy-critic round 2**: re-dispatch if iter-175 widens any
   LOC band or surfaces a new strategy-modifying writer finding.

## Subagent skips

(none — all 3 highly-recommended plan-phase subagents dispatched.)

## Tool substitutions

(none — `archon-informal-agent.py` not invoked this iter; mathlib-analogist
provides the substantive consult content.)
