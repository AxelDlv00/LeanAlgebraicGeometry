# Iter-168 plan-agent run

## Headline outcome

**The "depth-conversion via the prover-identified upstream helper" iter.** The
iter-167 progress-critic verdict on Route C was CHURNING with three must-fix
items: (i) Mathlib-idiom consult on `gmScalingP1` body's chartwise glue, (ii) a
bounded decomposition commitment for `gmScalingP1` body landing, (iii) explicit
statement on whether `genusZero_curve_iso_P1` (RR bridge) is dispatchable. All
three are addressed this iter:

1. **`mathlib-analogist gmscaling-deep`** landed a transcription-ready 6-step
   recipe: `~190-265 LOC` for the full `gmScalingP1` build, with the long pole
   = `homogeneousLocalizationAwayIso` helper (Q2, NEEDS_MATHLIB_GAP_FILL, but
   transcription-ready skeleton, `~60-90 LOC` — iter-167 under-estimated this at
   30 LOC). Q1/Q3/Q4/Q5/Q6 all PROCEED with concrete code paths. Persistent
   file: `analogies/gmscaling-deep.md`.
2. **`mathlib-analogist rrbridge`** landed: `genusZero_curve_iso_P1` is **NOT
   dispatchable as a Lane B prover lane this iter**. Mathlib lacks the
   divisor/RR/Pic stack at scheme level; `CommRing.Pic` is ring-level only;
   all 4 Hartshorne IV.1.3.5 ingredients (divisor of a closed point, RR
   dimension formula, linear equivalence, "rational ⟹ ≅ ℙ¹") are absent at the
   scheme level. **Verdict: defer to upstream Mathlib.** Persistent file:
   `analogies/rrbridge-survey.md`.
3. **Bounded decomposition commitment**: iter-168 prover attacks
   `gmScalingP1` body via the 6-step decomposition. Target landing iter for
   the body is **iter-169** if the iter-168 prover lands at least steps 1+2
   (cover + iso helper, both axiom-clean); **iter-168** if it can transcribe
   the full 6 steps in one lane (the prover prompt says "push as far as
   possible"). If iter-168 closes nothing toward the body and the iso helper
   exceeds the analogist's 120-LOC drop-warning, iter-169 escalates to
   user-decision.

## Decision made (lane count + scope)

**ONE prover lane on `Genus0BaseObjects.lean`, attacking `gmScalingP1` body via
the 6-step `gmscaling-deep` recipe; NOT a parallel Lane B on
`AbelianVarietyRigidity.lean`'s RR bridge.**

Reasoning:

- The RR-bridge analogist explicitly answered NOT_DISPATCHABLE for iter-168.
  Opening a Lane B on it would burn API time on a target the prover cannot
  close without missing Mathlib infrastructure that the project itself does
  not yet have. The honest move is to record the gap and not dispatch.
- The single Lane A drill on `Genus0BaseObjects.lean` IS the depth-conversion
  the critic asked for. It attacks the body, not yet-more-helpers.
- The prover's PRIMARY target is steps 1+2 (axiom-clean cover + iso helper);
  HIGH is steps 3-5 (chart-side morphism, cross-chart agreement, glue); HIGH
  also = `gmScalingP1` body itself (one-line glue) + `gmScalingP1_collapse_at_zero`
  body (step 6); OPT-IN = `ga_grpObj` (FREE via `AffineSpace.homOverEquiv` per
  iter-167's gm-grpobj analogist) and the 3 NEW iter-167 scaffold sorries
  unlocked by the iso helper (`projectiveLineBar_isReduced` via
  `IsReduced.of_openCover` over `Proj.affineOpenCover` once each chart is a
  domain).
- Single-file scope is correct because Lane B's outstanding residual
  (`iotaGm_isDominant` on AVR L934) is *file-disjoint but body-dependent on
  Lane A's `gmScalingP1`*. It cannot be discharged until Lane A's
  `gmScalingP1` body lands.

**Cheapest reversal signal**: if the iter-168 prover hits the analogist's
120-LOC drop-warning on Q2 (`homogeneousLocalizationAwayIso`) AND cannot
land step 1 (the cover) axiom-clean, the route flips from CHURNING to STUCK.
Iter-169's first action is then user-escalation (not another helper round).

## Prior critique status

- **progress-critic `routec168` verdict CHURNING (Route C)** with 3 must-fix
  items:
  - **must-fix #1 — Mathlib-idiom consult on `σ_× : ℙ¹ × 𝔾_m → ℙ¹` chartwise
    glue**: ADDRESSED this iter via `mathlib-analogist gmscaling-deep`. See
    `analogies/gmscaling-deep.md`.
  - **must-fix #2 — bounded decomposition commitment for `gmScalingP1` body
    landing iter**: ADDRESSED in this `## Headline outcome` section above —
    target landing is iter-168 (full transcription) or iter-169 (after
    iter-168 lands ≥steps 1+2 of the recipe), with explicit STUCK escalation
    if iter-168 produces no body progress.
  - **must-fix #3 — dispatch CHALLENGE on `genusZero_curve_iso_P1`**:
    ADDRESSED via `mathlib-analogist rrbridge`. Explicit verdict: NOT
    dispatchable this iter. Defer to upstream Mathlib. The project's RR
    sub-build option is multi-iter and would re-prioritize against Lane A's
    work; not entering this iter.

- **lean-auditor `iter167` 2 iter-167-specific status-tag bumps + 5 re-flagged
  stale-narrative blocks**: DEFERRED. The 2 status-tag bumps (AVR.lean L1090,
  L1156) are cosmetic (the iter-167 NOTE is already present in the blueprint;
  the Lean docstring iter tag is stale-by-one). The 5 stale-narrative blocks
  remain in fallback-route files (`Cotangent/GrpObj.lean`,
  `Cotangent/ChartAlgebra.lean`, `RigidityKbar.lean`, `Jacobian.lean`); all
  carry sound code, only the framing prose is stale. Defer to a future
  hygiene-only iter. The lean-auditor itself classified all of these as
  major-not-must-fix.

- **lean-vs-blueprint-checker `avr-iter167` 3 minor recommendations**: DEFERRED
  to recommendations.md. The iter-167 NOTE on `prop:morphism_P1_to_AV_constant`
  (L1417-1432 of AVR.tex) was ALREADY refreshed by iter-167's blueprint-writer
  (L1433-1443 contains the iter-167 NOTE — see Read I did this iter). The
  3 broken `\lean{...}` hooks (rationalMap_to_av_extends, hom_Ga_to_av_trivial,
  morphism_Ga_to_av_const) are on off-critical-path blocks; documented as
  future blueprint-writer hygiene.

- **lean-vs-blueprint-checker `g0bo-iter167` 2 minor recommendations**:
  DEFERRED. Both are typeclass-scaffolding informational items not requiring
  blueprint nodes; the chapter prose adequately documents them.

## Subagent skips

- **blueprint-reviewer**: NO chapter under `blueprint/src/chapters/` had
  content-substantive edits since the iter-165 fastpath2 dispatch
  (iter-167's blueprint-writer added only per-decl `\lean{...}` hooks +
  a new lemma block for `gmScalingP1_collapse_at_zero` — coverage extensions,
  not content changes). The fastpath2 verdict cleared the HARD GATE for AVR.
  iter-167's lean-vs-blueprint-checker `avr-iter167` + `g0bo-iter167` both
  returned no must-fix findings (only minor recommendations, deferred above).
  All three skip-conditions met.

- **strategy-critic**: STRATEGY.md content unchanged from iter-167 (verbatim).
  Prior verdict from `basecase-reopen` (iter-162) and re-verified iter-163
  was SOUND. No new strategic question raised by the iter-168 analogist
  consults (`rrbridge` confirmed the long pole the strategy already names; no
  route pivot). All skip-conditions met.

## State of play (iter-168 entry)

**Per-file sorry counts**:

| File | Iter-167 entry | Iter-167 exit | Δ |
|---|---|---|---|
| `AbelianVarietyRigidity.lean` | 6 | 2 | −4 |
| `Genus0BaseObjects.lean` | 6 | 9 | +3 |
| `Jacobian.lean` | 2 | 2 | 0 |
| `RigidityKbar.lean` | 1 | 1 | 0 |
| **GLOBAL** | **15** | **14** | **−1** |

**AVR L934 `iotaGm_isDominant`**: gated on Lane A's `gmScalingP1` body. Will
auto-close once iter-168/169 lands `gmScalingP1`.

**AVR L1141 `genusZero_curve_iso_P1`**: deferred to upstream Mathlib per
`rrbridge` analogist verdict. Documented as the named project RR gap; no
prover dispatch.

**G0BO sorry breakdown (9)**:

- L177 `projectiveLineBar_geomIrred` (OPT-IN, demoted)
- L184 `projectiveLineBar_smoothOfRelDim` (OPT-IN, Mathlib gap)
- L335 `ga_grpObj` (OPT-IN, FREE via `AffineSpace.homOverEquiv` per analogist —
  iter-168 attempts)
- L420 `gm_grpObj` (3-iter-deferred, but DOWNGRADED to OPT-IN once `gmScalingP1`
  lands: the rigidity proof body just needs `[GrpObj A]` for the *target*
  abelian variety, not for `Gm` itself, so the rigidity proof DOES NOT
  require `gm_grpObj` — let me re-verify this claim before next iter)
- L459 `gmScalingP1` body (iter-168 PRIMARY — attack via 6-step recipe)
- L476 `gmScalingP1_collapse_at_zero` body (iter-168 HIGH, step 6 of recipe)
- L522 `projectiveLineBar_isReduced` (iter-168 HIGH, unlocks via Q2 helper)
- L532 `gm_geomIrred` (iter-168 OPT-IN, requires tensor-localization bridge)
- L564 `projGm_isReduced` (iter-168 OPT-IN, requires `Smooth →
  GeometricallyReduced` bridge — Mathlib gap, deferred)

**On `gm_grpObj`**: I need to re-verify the claim that the rigidity proof
body does NOT consume `[GrpObj (Gm kbar)]` (just `[GrpObj A]` on the target).
Looking at `morphism_P1_to_grpScheme_const_aux` (AVR.lean ~L958): it applies
`hom_additive_decomp_of_rigidity` with `V = ProjectiveLineBar`, `W = Gm`.
That function signature (`AVR.lean:814`) carries `[GrpObj A]` where `A` is
the *target* (the abelian variety). The 𝔾_m W-side appears only as the
non-grouplike second factor `W` — no `GrpObj W` instance is consumed (just
a `LocallyOfFiniteType`, `GeometricallyIrreducible`, etc. on the product).
**Confirmed**: `gm_grpObj` is NOT on the genus-0 critical path. It was kept
as OPT-IN purely to install the symmetric "Gm is a group scheme" instance
for completeness. It can stay deferred indefinitely without harming the
rigidity closure. The critic's 3-iter-defer flag on `gm_grpObj` is real but
the item itself is genuinely off-critical-path (and the planner should be
clearer about that in iter-168's PROGRESS.md).

## iter-168 prover lane

**ONE lane**, file = `AlgebraicJacobian/Genus0BaseObjects.lean`.

**Target order** (the prover should attack in this order — the recipe is
chained):

1. **PRIMARY** — `projectiveLineBarAffineCover` (the 2-chart cover via
   `affineOpenCoverOfIrrelevantLESpan`). ~15-20 LOC, axiom-clean. Per
   analogist Q1 PROCEED.
2. **PRIMARY** — `homogeneousLocalizationAwayIso :
   HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (X i) ≃+*
   MvPolynomial Unit kbar`. ~60-90 LOC (analogist's revised estimate;
   transcription-ready skeleton in `analogies/gmscaling-deep.md` Decision Q2).
   This is the single lever unlocking 3 downstream items. **120-LOC
   drop-warning** per analogist — if Q2 exceeds 120 LOC, pause and
   reconsider upstreaming. Axiom-clean.
3. **HIGH** — `projectiveLineBar_isReduced` body (close the L522 scaffold
   sorry via `IsReduced.of_openCover` over `Proj.affineOpenCover` + the Q2
   iso). Axiom-clean.
4. **HIGH** — chart-side morphism (analogist Q3, ~30 LOC) — the two
   `Spec.map`-of-ring-map definitions on charts 0 and 1.
5. **HIGH** — cross-chart agreement (analogist Q4, ~40 LOC) — the ring-level
   equation closure.
6. **HIGH** — `gmScalingP1` body via `Scheme.Cover.glueMorphisms` (analogist
   Q5, ~1-line bridging code).
7. **HIGH** — `gmScalingP1_collapse_at_zero` body (analogist Q6, ~30-50 LOC,
   the chart-1 direct computation).
8. **OPT-IN** — `ga_grpObj` (~2-3 LOC via `AffineSpace.homOverEquiv` per
   iter-167 analogist).

**Status target**: COMPLETE if PRIMARY (steps 1+2) lands axiom-clean. PARTIAL
if step 1 lands but step 2 exceeds the 120-LOC drop-warning. INCOMPLETE only
if step 1 itself fails — that signals a Mathlib-API mismatch the analogist
missed.

**Total LOC budget**: the analogist estimates ~190-265 LOC for steps 1-7
(without step 8). The prover should attempt as much as possible. If steps
1-2 land axiom-clean AND steps 3-6 close enough to make `gmScalingP1` body
sorry-free (axiom-clean propagation if step 2 propagates the gap, or
strict axiom-clean if step 2 is fully done), this iter ALSO collapses AVR's
`iotaGm_isDominant` (via the auto-resolution path the iter-167 prover
identified) — so we'd close 2-3 G0BO sorries + 1 AVR sorry + several
downstream ones (a net GLOBAL drop of 3-5).

## Constraints

- **NO new axioms**.
- **NO protected signature touches**.
- Every new `sorry` must be the body of a top-level named declaration —
  NEVER buried in a `letI`/`have :=`/anonymous-`fun` inside a closing proof.
- The 6-step recipe in `analogies/gmscaling-deep.md` is the prover's primary
  reference. The previous `gm-grpobj-and-friends.md` is the BASELINE, the
  new file is the EXTENSION with transcription-ready code skeletons.
- If the prover hits the analogist's 120-LOC drop-warning on Q2, pause and
  report PARTIAL with the residual line count + obstacle. Do NOT bail
  preemptively.
- Build must end green (`lake build AlgebraicJacobian.Genus0BaseObjects`
  exit 0; downstream `AlgebraicJacobian.AbelianVarietyRigidity` should also
  remain green since the iso-helper landing is upstream and won't break
  Lane B's `infer_instance` chain).

## What this iter does NOT do

- **No Lane B prover dispatch.** The RR-bridge analogist returned
  NOT_DISPATCHABLE for `genusZero_curve_iso_P1`. The AVR file is unchanged.
- **No blueprint chapter edits.** The iter-167 NOTEs are sufficient; the
  iter-167 lean-vs-blueprint-checker `avr-iter167` already verified
  coverage. The 2 minor recommendations from that checker (the iter-166
  NOTE refresh + the 3 broken `\lean{...}` hooks on off-path blocks) are
  deferred to a future blueprint-hygiene iter.
- **No `gm_grpObj` push.** Re-classified as off-critical-path per the
  analysis above (the rigidity proof body only consumes `[GrpObj A]` on
  the target, not on `Gm` itself). The 3-iter-defer flag is real but the
  item is genuinely orthogonal to the genus-0 closure path.
- **No stale-narrative purge** (the 5 lean-auditor majors). Future
  hygiene iter.

## Reversal signal / iter-169 escalation rule

- If iter-168 lands step 1 (cover) and step 2 (iso helper) BOTH axiom-clean,
  iter-169 picks up steps 3-7 and the `gmScalingP1` body lands iter-169.
  4-iter total from iter-165 NEW-file scaffold to body axiom-clean.
- If iter-168 lands ONLY step 1 (Q2 exceeds 120 LOC and the prover pauses),
  iter-169 surfaces the user-decision: (a) push the iso helper further in
  one prover lane (knowing the LOC is unexpectedly heavy), OR (b)
  contribute the iso to upstream Mathlib as a focused PR (multi-week
  out-of-loop work).
- If iter-168 lands NOTHING (step 1 itself fails), iter-169 STUCK and
  escalate to user-decision immediately.

## User-visible side effect (TO_USER fodder)

- Route C is mid-way through depth conversion. The two main risks are
  (i) the `homogeneousLocalizationAwayIso` helper being substantially
  heavier than estimated, and (ii) the RR bridge `genusZero_curve_iso_P1`
  being a genuine multi-iter Mathlib gap. (i) is testable iter-168; (ii)
  is a known long-pole that requires either upstream Mathlib growth or a
  project-side RR sub-build (multi-iter). The decision on the RR bridge
  is NOT this iter; this iter focuses on Lane A's `gmScalingP1`.
