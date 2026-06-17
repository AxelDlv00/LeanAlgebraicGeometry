# Iter-137 (Archon canonical) plan-agent run

## Headline outcome

Iter-136 prover lane closed Step 3 of piece (i.b) substantively
(`relativeDifferentialsPresheaf_restrict_along_identity_section` at
L508, ~27 LOC, kernel-only). Project sorry count 6 → 5. Route 4
flipped UNCLEAR → CONVERGING. Both iter-136 review audits clean.

**Iter-137 PRIMARY DECISION**: fire prover lane on piece (i.b) Step 2
(`relativeDifferentialsPresheaf_basechange_along_proj_two` at
`Cotangent/GrpObj.lean:480`). Per iter-137 mathlib-analogist's
revised envelope: **~360–710 LOC total** (250–500 body + 110–210
factorable helpers). Closure path: universal-property-at-presheaf-
level route via `PresheafOfModules.isoMk` (NOT chart-affine-cover-
and-glue).

**Iter-137 is plan + parallel-Wave-1 (3 critics + 1 analogist) +
prover-Wave-2.** No refactor lane this iter; iter-136 minor docstring
drift in `Cotangent/GrpObj.lean` is folded into the iter-137 prover
lane's own docstring updates as a side effect (cf. § "Iter-136
carry-forward items").

## Wave 1 (parallel) — all 4 returned

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| `strategy-critic` | iter137 | **SOUND-with-1-CHALLENGE** (7 routes audited, 0 REJECT). CHALLENGE on piece (i.c) bundling under a single 200–500 LOC envelope — needs explicit (i.c.1/i.c.2/i.c.3) decomposition before iter-137+ scaffolding. 3 minor alternatives: (i.c) sub-decomp (tied to CHALLENGE), pre-commit path (b) of iter-139/140 consult, over-k re-frame to "operationally defaulted, bounded revert cost". | CHALLENGE **ABSORBED** via STRATEGY.md edit #1 (sequencing-table piece (i.c) row split into 3 sub-rows: i.c.1 chart-localisation identification ~100–200 LOC, i.c.2 `omega_free` ~50–150 LOC, i.c.3 `omega_rank_eq_dim` ~50–150 LOC). Minor alt "pre-commit path (b)" **REBUTTED-WITH-SCOPE-NOTE**: defensible suggestion the iter-139/140 consult will likely return, no iter-137-action; recorded as sidecar note for iter-138 plan agent. Minor alt "over-k re-framing" **REBUTTED-WITH-SCOPE-NOTE**: outcome-equivalent document-streamlining; no iter-137 action. Minor alt "genus-1 fast path within M3" deferred (M3 off-critical-path). |
| `blueprint-reviewer` | iter137 | **HARD GATE CLEAR** on `Cotangent/GrpObj.lean`. 11 chapters audited; 0 must-fix-this-iter; 1 soon (optional preventive % NOTE near `RigidityKbar.tex:490` materially covered by 3 existing places already); 3 informational carry-overs (iter-135+iter-136 unchanged): `Jacobian.tex:400` stale citation, `Cohomology_StructureSheafModuleK.tex` label-prefix asymmetry, `Jacobian.tex` C.2.d second-bullet thinness. | HARD GATE CLEAR; iter-137 prover dispatch proceeds. The 1 soon item is documented enough already (in `AlgebraicJacobian_Cotangent_GrpObj.tex:34–42` + iter-135 NOTE at `RigidityKbar.tex:452–463` + iter-136 NOTE at `RigidityKbar.tex:505–518`); a 4th `% NOTE` near L490 is informational ergonomic value, not gate-blocking. Iter-137 plan: **DEFER**; iter-138+ blueprint pass can fold it in. 3 informational carry-overs unchanged. |
| `progress-critic` | iter137 | **UNCLEAR overall (1 CONVERGING + 2 UNCLEAR-by-design + 1 UNCLEAR-trending-CONVERGING)**; 0 CHURNING / 0 STUCK. Route 1 (piece (i.a)) CONVERGING (closed iter-132, stable 4 iters). Routes 2 + 3 UNCLEAR-by-design (gated). Route 4 (piece (i.b)) UNCLEAR-trending-CONVERGING — strict-rule reading does not flip to CONVERGING because the iter-135 +2 sorry intervention breaks monotonicity. 2 PROACTIVE SOFT MUST-FIX items: (i) Iter-137 plan must bind explicit LOC budget on Step 2 prover lane cross-referencing strategy's (a')/(c) 600 LOC trigger; (ii) gate Wave-2 prover-lane dispatch on Wave-1 mathlib-analogist returning PROCEED. | **(i) ABSORBED** via PROGRESS.md objective directive's "LOC budget guardrail" section + STRATEGY.md edit #2 (LOC trigger arm renormalised to 1000 LOC cumulative per the iter-137 mathlib-analogist's revised envelope). Original cap of 200 LOC delta (recommended by progress-critic) is renormalised against the iter-137 analogist's revised envelope: prover bound to ship Step 2 body alone within ~400 LOC + factor helpers as separate declarations (per analogist Decision 5 advice); PARTIAL-with-diagnosis triggered if body alone exceeds 400 LOC without close-in-sight. **(ii) ABSORBED**: Wave-1 analogist returned PROCEED on signature + NEEDS_MATHLIB_GAP_FILL on body + ALIGN_WITH_MATHLIB on assembly idiom — effectively PROCEED for the prover dispatch (the body's NEEDS_MATHLIB_GAP_FILL nature IS the lane's purpose, with explicit 5-step closure recipe + named Mathlib lemmas + persistent `analogies/kaehler-tensorequiv-presheafpullback.md`). Wave-2 may fire. |
| `mathlib-analogist` | kaehler-tensorequiv-presheafpullback-iter137 | **PROCEED on iter-135 signature** (signature correct, no refactor needed) + **NEEDS_MATHLIB_GAP_FILL on body** + **ALIGN_WITH_MATHLIB on assembly idiom (`PresheafOfModules.isoMk`)**. Critical strategy decision (Decision 4): **universal-property-at-presheaf-level route** (define a chart-wise derivation `D_V`, apply `KaehlerDifferential.lift`, glue via `isoMk`) — NOT the chart-affine-cover-and-glue route the blueprint prose hints at, because `relativeDifferentialsPresheaf` is a presheaf (not a sheaf) and `isoMk`'s naturality must hold over all opens, not just affine ones. **Revised LOC envelope: ~250–500 LOC body + ~110–210 LOC factorable helpers = ~360–710 LOC total**, widened from iter-133's 150–300 LOC by ~200 LOC. **Recommended stall threshold for follow-up analogist: body alone > 400 LOC without close-in-sight.** 5-step closure recipe + 2 factorable helpers named: (1) chart-level `Algebra.IsPushout`-from-affine-product ~80–150 LOC, (2) `PresheafOfModules.pullback` chart unfolding ~30–60 LOC, (3) chart-wise derivation `D_V` ~50–80 LOC, (4) `KaehlerDifferential.lift` ~30–50 LOC, (5) inverse + `isoMk` assembly ~80–150 LOC. Persistent file: `analogies/kaehler-tensorequiv-presheafpullback.md`. | **Wave 2 prover directive ABSORBS the analogist's 5-step recipe** + the universal-property-route guidance + the LOC budget + the helper-factoring guidance (helpers may be added to `Cotangent/GrpObj.lean` or split into a separate utility section). STRATEGY.md edits #2 + #3 + #4 absorb the revised LOC envelope into the strategy's sequencing table + the (i.b) gap-inventory entry + the trigger (a')/(c) LOC arm. |

## STRATEGY.md edits this iter (4 substantive)

1. **§ Sequencing — piece (i.c) row split into 3 sub-rows** per
   `strategy-critic-iter137` CHALLENGE absorption. New rows:
   - i.c.1 chart-localisation identification (~100–200 LOC, pushed
     in from (i.b)), 1 iter.
   - i.c.2 `omega_free` (~50–150 LOC), 1 iter (can co-fire with i.c.3).
   - i.c.3 `omega_rank_eq_dim` (~50–150 LOC), 1 iter (can co-fire
     with i.c.2).

2. **§ Sequencing — piece (i.b) row revised** per the iter-137
   mathlib-analogist's revised LOC envelope. The iter-134+ piece (i.b)
   prover-lane row was updated to show:
   - Step 1 ~50 LOC (DONE iter-134).
   - Step 2 ~360–710 LOC total (universal-property route; iter-137
     target).
   - Step 3 ~27 LOC (DONE iter-136).
   - Main Compose ~20–40 LOC (iter-138+ target).
   - Total ~410–810 LOC across iter-134→iter-138 (3–5 iter envelope).

3. **§ Mathlib gap inventory — Step 2 entry revised** with the
   iter-137 analogist's revised envelope, the universal-property-
   route guidance, the persistent file pointer, and the renormalised
   LOC trigger arm.

4. **§ Direct over-k rigidity ▸ Watchpoint (LOC trigger renormalised)**
   per the iter-137 mathlib-analogist's revised envelope. The
   iter-134-calibrated 600 LOC cap was renormalised to 1000 LOC
   cumulative — the original cap was calibrated against the iter-133
   150–300 LOC envelope which assumed a chart-affine-cover route
   Mathlib's `PresheafOfModules.pullback` opacity rules out. Under
   the iter-137 universal-property route, the 600 LOC cap would
   fire mechanically on the envelope itself — sunk-cost-shaped
   over-revert. The renormalisation to 1000 LOC (~316 LOC iter-136
   baseline + ~710 LOC upper envelope + ~30% slack) keeps the LOC
   arm a genuine watchpoint. Trigger (a')'s non-LOC components
   (a'.1 pointwise-translation through `k̄`-rational points; a'.2
   pivot to value-level-stalk RHS) are retained unchanged.
   **`strategy-critic-iter138` re-verification of this renormalisation
   committed.**

## Rebuttals to strategy-critic minor alternatives

### Minor alternative "Pre-commit path (b) of iter-139/140 consult"

`strategy-critic-iter137` suggests pre-committing piece (ii) to
path (b) (direct `KaehlerDifferential` exactness route via
`KaehlerDifferential.exact_kerCotangentToTensor_mapBaseChange` +
kernel-of-derivation) rather than waiting for the iter-139/140
analogist consult. Rationale: path (a) (install `Differential B`
typeclass via splitting) is structurally awkward — `Differential B`
is a derivation `B → B` valued in `B`, used for differential rings;
installing it via a splitting requires picking a non-canonical
splitting whose `ContainConstants` is a property of the choice, not
intrinsic.

**Plan-agent verdict (iter-137): REBUT WITH SCOPE NOTE**. The
suggestion is defensible and the iter-139/140 analogist will likely
return PROCEED on path (b) for exactly the structural-awkwardness
reason the strategy-critic names. However:

- Pre-committing now risks the iter-139/140 analogist surfacing a
  third option (e.g., a `KaehlerDifferential`-side `IsContainConstants`
  predicate not yet on the strategy's radar). The consult's value is
  the breadth of options it surveys, not just the verdict.
- The iter-139/140 schedule was set iter-136 with the explicit
  constraint "MUST dispatch before iter-141+ piece-(ii) scaffolding".
  Pre-committing means iter-138/139/140 plan agents lose the
  opportunity to course-correct on freshly-seen Mathlib evidence
  if the consult reveals path (c) or (d) under the iter-137 snapshot.
- One analogist iter is a cheap insurance premium against
  structural-design mistakes that cost 10× more iters to undo.
- The strategy as currently written (iter-136 row) is honestly
  evaluating both options at the consult; no structural-awkwardness
  framing is locked in.

**Recommendation**: leave the iter-139/140 row as-is (analogist
consult with both paths under evaluation). Record the iter-137
strategy-critic's path-(b) preference in this sidecar; the iter-139/140
analogist will see it via the iter-by-iter context window.

### Minor alternative "Over-k re-frame to operationally defaulted, bounded revert cost"

`strategy-critic-iter137` suggests acknowledging the over-k
commitment is at quantitative lower-bound-zero (per strategy
line 487) and re-framing as a *bounded-cost operational default*
(stay because reverting also costs ~1 iter; savings zero either
way) rather than a *defended strategic choice*. This is the framing
the strategy is "90% of the way towards" (lines 506–514 already
demote ground (iii) to risk mitigation; lines 508–509 honestly name
ground (ii) as switching-cost-flavored).

**Plan-agent verdict (iter-137): REBUT WITH SCOPE NOTE**.
Document-streamlining recommendation; outcome-equivalent. The
strategy's three-trigger machinery (a')/(b)/(c) IS decision-quality
machinery — it distinguishes causes, which the operational-default
collapse loses. **The iter-137 plan agent prefers retaining the
three-trigger machinery for the iter-138+ revert-decision distinguishability.**

Recording this rebuttal alone; no STRATEGY.md edit. The
strategy-critic's framing is correct that the *defense* is
operationally-defaulted; the *triggers* remain decision-quality
machinery worth keeping wired. If the iter-138 strategy-critic
re-issues, the iter-138 plan agent can revisit.

### Minor alternative "Genus-1 fast path within M3"

`strategy-critic-iter137` suggests sub-casing M3 into a genus-1 arm
(easier; identifying `C` with its own Jacobian if a `k`-point exists)
and a genus ≥ 2 arm (still hard; Route A or B). **Plan-agent verdict
(iter-137): DEFER**. M3 is off the critical path (M2 first; M3 after);
the sub-casing decision waits until M2.b body close concrete + user-
escalation routes picked. Recorded for iter-150+ planner via this
sidecar.

## Wave 2 (prover lane) — pending dispatch

| File | Target | Envelope | Closure path | Binding constraints |
|---|---|---|---|---|
| `AlgebraicJacobian/Cotangent/GrpObj.lean` | `relativeDifferentialsPresheaf_basechange_along_proj_two` (L480) | Step 2 body ~250–500 LOC + 2 factorable helpers ~110–210 LOC; ~360–710 LOC total | Universal-property-at-presheaf-level route via `PresheafOfModules.isoMk`; chain `KaehlerDifferential.tensorKaehlerEquiv` (algebra-side) with `PresheafOfModules.pullback` (presheaf-side); 5-step recipe per `analogies/kaehler-tensorequiv-presheafpullback.md`. | (a) **LOC budget**: aim for ≤ 400 LOC for body alone; PARTIAL-with-diagnosis if body alone exceeds 400 LOC without close-in-sight. (b) **Helper-factoring**: factor (1) chart-level `Algebra.IsPushout`-from-affine-product as a separate `def`/`lemma` (~80–150 LOC, reusable beyond Step 2), (2) `PresheafOfModules.pullback` chart-unfolding as a separate `def`/`lemma` (~30–60 LOC). May add these to `Cotangent/GrpObj.lean` directly (~110–210 LOC) or, if the prover deems them more useful as utility infrastructure, propose a new file (the iter-138 plan agent will dispatch the refactor). (c) **NO chart-affine-cover-and-glue route** — the analogist explicitly rules this out. (d) **NO hand-rolled `Iso.mk`** — use `PresheafOfModules.isoMk`. (e) Honest-scaffold-convention guardrail (iter-135 codified): if the analogist's 5-step recipe doesn't close within the envelope, ship PARTIAL with the residual diagnosis documented in `task_results/Cotangent_GrpObj.md`; the iter-138 plan agent will dispatch the corrective subagent. NEVER ship a hollow-tautology placeholder. |

## Iter-136 carry-forward items (status check entering iter-137)

- **Iter-136 minor docstring drift in `Cotangent/GrpObj.lean`** (3
  sites per `lean-auditor-review136` + `lean-vs-blueprint-checker-cotangent-grpobj-review136`):
  - L506 "below" → "above" on `relativeDifferentialsPresheaf_restrict_along_identity_section`.
  - L596–L597 "Steps 2 and 3" → "Step 2" on `mulRight_globalises_cotangent`.
  - L427–L432 section-header "Bodies are `sorry` — closure is
    iter-136+ work" → updated to reflect "Step 2 + Main remain
    `sorry`; Step 3 closed iter-136".
  - **Iter-137 plan**: prover directive will instruct the prover to
    fold these 3 docstring fixes into the Step 2 closure pass as a
    side effect (the prover will naturally rewrite the section header
    L427–L432 when Step 2's status changes from `sorry` to `closure`,
    will flip L596–L597 from "Step 2" to either "closed" or unchanged
    depending on Step 2's outcome, and L506 is fixed by trivial
    "below" → "above" edit). Bundled into prover directive's
    "side-effect cleanup" section.

- **Iter-135 carry-over file-header line-anchor drift** at
  L61/L107/L146/L155/L160 ("line 244 below" / "line 198 below" stale
  by ~+12 from iter-136 baseline): the iter-137 prover lane will
  extend this drift further (Step 2 closure adds ~360–710 LOC,
  pushing the L256 `cotangentSpaceAtIdentity_finrank_eq` target
  further). **Iter-137 plan**: bundled into prover directive's
  "side-effect cleanup" section — prover instructed to refresh the
  5 file-header line anchors after Step 2 closes (cheap to do once
  the new line numbers are stable).

- **Iter-136 optional MED-C blueprint % NOTE near `RigidityKbar.tex:490`**
  distinguishing `schemeHomRingCompatibility` from the
  `toRingCatSheafHom`-route: **DEFERRED iter-138+** per
  blueprint-reviewer-iter137 verdict (covered in 3 places already).

- **META-PATTERN TRIPWIRE** (iter-132 non-promise: no 4th body reshape
  on `cotangentSpaceAtIdentity`): **HOLDS** — iter-137 prover lane
  targets `_basechange_along_proj_two` (NEW declaration body, not
  piece (i.a)).

- **Trigger (a')/(c) LOC arm renormalised iter-137** from 600 LOC
  to 1000 LOC cumulative (per STRATEGY.md edit #4 above). Iter-137
  prover lane firing at the revised envelope does NOT fire the LOC
  arm. Future iter-138+ on Main composition (~20–40 LOC) lands well
  under the renormalised cap.

- **Iter-135–138 mathlib-analogist consults scheduled** — (a)
  no-Frobenius / higher-Kähler-vanishing alternative for piece (iii);
  (b) ℙ¹-specific rigidity hedge for M2.b `C(k) ≠ ∅` branch. **NOT
  dispatched this iter** — iter-137 already dispatches one analogist
  (Step 2 bridge) and the analogist-budget is tight. **Schedule push
  to iter-138**: dispatch one or both then if iter-137 piece (i.b)
  Step 2 returns on-trajectory. Advance to iter-137 ONLY if Step 2
  returns PARTIAL or INCOMPLETE (which would re-prioritise the iter-138
  plan agent's bandwidth).

- **Future TO_USER candidate (iter-151+)**: partial-result shipping
  consultation per `strategy-critic-iter136` minor alternative.
  Carry forward; not surfaced this iter.

## Watch criteria committed for iter-138

1. **Iter-138 mandatory progress-critic**: Route 4 verdict should
   resolve:
   - **PASS criterion (iter-136 → iter-137)**: Step 2 (L480)
     substantively closed (sorry → 0 on that declaration, kernel-
     only axioms). If iter-137 closes Step 2 substantively, Route 4
     flips UNCLEAR-trending-CONVERGING → CONVERGING; iter-138 picks
     up Main (`mulRight_globalises_cotangent`, L599, ~20–40 LOC
     composition).
   - **PARTIAL criterion (Route 4 stays UNCLEAR)**: Step 2 returns
     PARTIAL but with structural progress (e.g. body ships >50% LOC,
     names the load-bearing Mathlib lemmas used, identifies the
     residual sub-piece). Iter-138 plan re-dispatches prover on
     the residual (no new helpers; the iter-137 analogist's 5-step
     recipe remains the recipe).
   - **FAIL criterion (flips Route 4 to CHURNING)**: Step 2 returns
     INCOMPLETE without structural progress; iter-138 plan must STOP
     the helper round and either (i) dispatch another analogist on
     the residual gap-fill, OR (ii) request a blueprint-writer
     expansion of `RigidityKbar.tex` § Step 2 proof prose with
     finer-grained chart-cofinality detail.

2. **Iter-138 mandatory blueprint-reviewer**: confirm `RigidityKbar.tex`
   stays `complete: true` / `correct: true` after iter-137 prover phase.
   The iter-135 NOTE on `lem:GrpObj_omega_basechange_proj` (statement
   block, L452–L462) will need rewriting if Step 2 closes. `sync_leanok`
   handles `\leanok`.

3. **Iter-138 mandatory strategy-critic re-verification**: confirm
   iter-137 STRATEGY.md edits absorbed correctly:
   - Edit #1 (piece (i.c) 3-row split per `strategy-critic-iter137`
     CHALLENGE): re-verify the i.c.1/i.c.2/i.c.3 decomposition is
     sound and complete.
   - Edit #2 (piece (i.b) sequencing row LOC envelope): re-verify
     the ~410–810 LOC total / 3–5 iter envelope.
   - Edit #3 (gap inventory entry): re-verify the LOC-trigger
     renormalisation rationale.
   - Edit #4 (trigger (a')/(c) LOC arm renormalisation to 1000 LOC):
     re-verify the renormalisation is honest (not sunk-cost-shaped
     over-rationalisation).
   - Three minor alternatives `strategy-critic-iter137` raised that
     this iter REBUTTED-WITH-SCOPE-NOTE rather than absorbed (pre-
     commit path (b), over-k re-frame, genus-1 fast path): if
     iter-138 critic re-issues, the iter-138 plan agent should
     re-evaluate (the rebuttals are operationally-equivalent
     framings; iter-138 may decide otherwise).

4. **Iter-138 piece (i.b) prover dispatch (if iter-137 Step 2 closes
   substantively)**: attack Main `mulRight_globalises_cotangent` at
   L599 (~20–40 LOC composition of Steps 1+2+3). Closure: per
   `RigidityKbar.tex` § Piece (i.b) `lem:GrpObj_mulRight_globalises`
   proof, Compose step. Should be the cheapest piece (assembly only,
   no NEEDS_MATHLIB_GAP_FILL).

5. **Iter-138 review of iter-137 docstring drift bundle**: the
   iter-137 prover directive instructs the prover to fold the
   3 docstring drift + 5 file-header line-anchor refreshes into
   Step 2 closure pass. If the prover fails to absorb these, the
   iter-138 review will re-flag.

6. **Iter-135–138 deferred analogist consults (a + b)**: iter-138
   plan phase dispatches if iter-137 Step 2 returns on-trajectory;
   advances to iter-137 only if Step 2 returns PARTIAL/INCOMPLETE.

7. **Iter-139 or iter-140 mathlib-analogist on piece-(ii)
   `Differential.ContainConstants` alignment**: carry forward.
   Note: `strategy-critic-iter137` minor alt suggests pre-committing
   to path (b) (direct `KaehlerDifferential` exactness); iter-137
   plan REBUTTED-WITH-SCOPE-NOTE (defensible but loses the consult's
   breadth value). Iter-138+ plan agent may revisit.

8. **Iter-137 prover-target sync_leanok flip**: `sync_leanok` between
   prover + review phases this iter should add `\leanok` to
   `lem:GrpObj_omega_basechange_proj` statement+proof blocks IF
   iter-137 prover closes L480.

## Fallback if no user response

This iter does NOT require user input. The plan absorbs all Wave-1
verdicts via STRATEGY.md edits + sidecar rebuttals; the Wave-2
prover dispatch is unconditional. No TO_USER banner this iter
(the future TO_USER candidate iter-151+ partial-result shipping
remains scheduled, unchanged).
