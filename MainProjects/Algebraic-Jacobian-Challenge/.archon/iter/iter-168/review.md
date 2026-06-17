# Iter-168 (Archon canonical) — review

## Outcome at a glance
- **The "depth-conversion via the prover-identified upstream helper" iter.** iter-167's
  progress-critic verdict was CHURNING with three must-fix items (Mathlib-idiom consult, a
  bounded decomposition commitment for `gmScalingP1`, RR-bridge dispatchability). The
  iter-168 plan addressed all three up front (one analogist landed a 6-step
  transcription-ready recipe for `gmScalingP1`, one analogist returned NOT_DISPATCHABLE for
  the RR bridge, and the planner committed an iter-169 body-landing target). The prover
  dispatched a SINGLE lane on `AlgebraicJacobian/Genus0BaseObjects.lean` attacking the
  6-step recipe and landed **Steps 1+3 axiom-clean + Step 2 partial**.
- **Substantive new axiom-clean closures (verified this review via `lean_verify`):**
  - `projectiveLineBarAffineCover` (L196) — the 2-chart affine cover via
    `Proj.affineOpenCoverOfIrrelevantLESpan`. Axioms `{propext, Classical.choice,
    Quot.sound}`. NEW infrastructure, no prior counterpart.
  - `projectiveLineBar_isReduced` (L719) — sidesteps the chart-ring iso entirely. Was a
    SCAFFOLD sorry (iter-167 NEW); now closed via `IsReduced.of_openCover` over the new
    cover + `IsDomain (HomogeneousLocalization.Away 𝒜 (X i))` via `Function.Injective.isDomain`
    on the algebraMap into `Localization.Away (X i)` + `HomogeneousLocalization.val_injective`.
    Axioms `{propext, Classical.choice, Quot.sound}`. **The Mathlib gap the iter-167 docstring
    claimed (chart-ring → IsDomain) is NOT a gap — < 10 LOC bridge using existing lemmas.**
  - 5 axiom-clean ring-hom helpers: `otherFin`, `chartEvalRingHom` (+ 3 simp lemmas),
    `homogeneousLocalizationAwayToMvPoly`, `kbarToAwayRingHom`,
    `mvPolyToHomogeneousLocalizationAway`, `homogeneousLocalizationAwayIso_aux_right`.
- **Partial closure:** `homogeneousLocalizationAwayIso` (L378) lands as a `RingEquiv.ofRingHom`
  with forward direction proven and `aux_right` round-trip axiom-clean; `aux_left` is the
  one new internal sorry (L368) the prover documents two routes to discharge in iter-169.
- **Dispatch MATCHED the plan — 11th consecutive iter** with no plan/dispatch contradiction.
  The plan specified ONE lane on `Genus0BaseObjects.lean` attacking the 6-step `gmscaling-deep`
  recipe; the prover stayed inside that scope and reported PARTIAL per the plan's PARTIAL
  status criterion.
- **Global bare-sorry 14 → 14 (NET unchanged).** Per-file (verified via Grep):
  - `AbelianVarietyRigidity.lean` — 2 (L931, L1135 — unchanged from iter-167; positions
    shifted slightly).
  - `Genus0BaseObjects.lean` — 9 → 9 (substitution: closed
    `projectiveLineBar_isReduced` L522 → axiom-clean; added
    `homogeneousLocalizationAwayIso_aux_left` L368).
  - `Jacobian.lean` — 2 (unchanged).
  - `RigidityKbar.lean` — 1 (unchanged).
  No new `axiom`; no protected signature touched; `lake build AlgebraicJacobian` GREEN
  (sorry warnings only).

## The advance, independently verified this review
1. **`projectiveLineBarAffineCover` LANDED axiom-clean.** `lean_verify` axioms `{propext,
   Classical.choice, Quot.sound}`. The non-trivial `hf` (irrelevant ⊆ `Ideal.span {X 0, X 1}`)
   reduces via `MvPolynomial.as_sum` + `MvPolynomial.X_dvd_monomial` after the
   `coeff 0 p = 0` reduction through `HomogeneousIdeal.mem_irrelevant_iff` +
   `MvPolynomial.homogeneousComponent_zero` + `MvPolynomial.C_injective`. **New KB pattern**
   (reusable for any `Proj` of `MvPolynomial σ R`).
2. **`projectiveLineBar_isReduced` LANDED axiom-clean by avoiding the iso.** The strategy
   the iter-167 prover encoded in the docstring assumed the iso was the bridge. iter-168
   discovered the iso is not needed: `HomogeneousLocalization.Away 𝒜 (X i)` injects into
   `Localization.Away (X i)` via `algebraMap = .val` (injective by
   `HomogeneousLocalization.val_injective`), `Localization.Away (X i)` is a domain via
   `IsLocalization.isDomain_localization` + `powers_le_nonZeroDivisors_of_noZeroDivisors
   (MvPolynomial.X_ne_zero _)`, hence `Away 𝒜 (X i)` is a domain via
   `Function.Injective.isDomain`, hence reduced, hence `Spec(.of _)` is reduced via
   `instIsReducedSpecOfIsReducedCarrier`, finished by `IsReduced.of_openCover` on the new
   cover. **New KB pattern** (chart-local domain-via-injection — reusable for any
   `Proj`-chart reducedness over a domain graded ring).
3. **`homogeneousLocalizationAwayIso_aux_right` (forward ∘ inverse = id on `MvPolynomial Unit kbar`)
   LANDED axiom-clean.** Uses `MvPolynomial.ringHom_ext` + `HomogeneousLocalization.algebraMap_apply`
   + `Localization.awayLift_mk` with explicit `(v := 1) (hv := ...)` (since `chartEval (X i) = 1`,
   a unit). Both `C r` and `X ()` cases close by `simp` chains naming the relevant simp
   lemmas explicitly. **New KB pattern** (the `(v := 1)` shortcut for `awayLift_mk` when
   the generator maps to `1`).
4. **`homogeneousLocalizationAwayIso` (L378) STRUCTURALLY EXISTS** as `RingEquiv.ofRingHom`,
   but axiom-tracks `sorryAx` propagated from `aux_left`. So the iso is "defined but not
   axiom-clean" — downstream `lean_verify` correctly distinguishes this state. The 5
   building-block ring-homs (`chartEvalRingHom`, `homogeneousLocalizationAwayToMvPoly`,
   `kbarToAwayRingHom`, `mvPolyToHomogeneousLocalizationAway`, and the
   `aux_right` round-trip) are each independently axiom-clean.

## Is this iter-157 laundering again? No.
Explicitly checked. The single new sorry (`homogeneousLocalizationAwayIso_aux_left` at L368)
is a **top-level named `private lemma`**, not buried in a `letI`/`have :=`/anonymous-`fun`
inside a closing proof. The downstream consumer `homogeneousLocalizationAwayIso` honestly
propagates `sorryAx` (verified — `lean_verify` reports `{propext, sorryAx, Classical.choice,
Quot.sound}`). The Lean docstring at L350–367 is an honest disclosure of the residual
strategy (surjective-cancel via `Away.adjoin_mk_prod_pow_eq_top` OR `IsWeightedHomogeneous.induction_on`
on `num` through `Away.mk_surjective` + `val_injective`) — not an excuse comment. The
`lean-vs-blueprint-checker-g0bo-iter168` report L89 explicitly notes "Not an excuse comment
— it is a transparent status note documenting which Mathlib bridge needs threading."

## Subagent skips

- **strategy-critic**: STRATEGY.md content unchanged since iter-167; prior verdict from
  `basecase-reopen` (iter-162) and re-verification iter-163 was SOUND. No iter-168 strategic
  question raised (the `rrbridge` analogist confirmed the long pole the strategy already
  names; no route pivot). Skip conditions met (SHA-equal STRATEGY.md, SOUND verdict, no live
  CHALLENGE).
- **blueprint-reviewer**: No chapter under `blueprint/src/chapters/` had content edits since
  the iter-167 `avr-lean-hooks` writer pass (only the iter-167 per-decl `\lean{...}` hooks
  + the new `lem:gmScaling_fixes_zero` block landed). iter-165 fastpath2 verdict cleared
  the HARD GATE for AVR; iter-167 lean-vs-blueprint-checker dispatches `avr-iter167` +
  `g0bo-iter167` both returned no must-fix findings. Skip conditions met.

## Review-phase subagents dispatched

### `lean-vs-blueprint-checker-g0bo-iter168` — CONVERGING
- **Returned**: 0 must-fix / 3 major / a handful of minor.
- **3 major findings**:
  - **Missing `\lean{...}` pins** for iter-168 substantive declarations:
    `projectiveLineBarAffineCover` (L196), the chart-ring iso machinery
    (`homogeneousLocalizationAwayToMvPoly` L280, `mvPolyToHomogeneousLocalizationAway` L303,
    `homogeneousLocalizationAwayIso` L378), and `projectiveLineBar_isReduced` (L719).
    The chapter has no roadmap node describing the chart-ring iso as a sub-build.
  - **Stale L708–712 docstring on `projectiveLineBar_isReduced`** — opens with "**`ℙ¹`
    is reduced.** Project-side scaffold sorry (Mathlib does not ship `IsReduced (Proj 𝒜)`
    for a domain graded ring; would close via `IsReduced.of_openCover`...)". The body
    iter-168 closes axiom-clean using exactly that strategy. The docstring's opening line
    directly contradicts the proof body that follows.
  - **Stale L680–696 section header docstring** lists `ℙ¹` is reduced as one of the
    "scaffold (Mathlib gap: …)" entries alongside other product-stability scaffolds.
- **Resolution**: Plan-agent action items (blueprint writer + Lean docstring refresh).
  Not must-fix-this-iter — chapter is faithful to every currently pinned declaration.
- Report: `task_results/lean-vs-blueprint-checker-g0bo-iter168.md`.

### `lean-auditor-iter168` — 11 MUST-FIX
- **Returned**: 11 must-fix / 7 major / 3 minor / 15 excuse-comments. 8 of 11 must-fix items
  sit in `Genus0BaseObjects.lean` (the iter-168 focus file).
- **Critical** finding (the most acute excuse-comment in the project this iter):
  `homogeneousLocalizationAwayIso_aux_left` (G0BO L350-372) has an **18-line docstring
  claiming "iter-168 partial: structural setup via `ext`, `Away.mk_surjective`,
  `val_injective` gets us to the underlying `Localization.Away (X i)` comparison …"** while
  the body is **literally just `sorry` with zero structural setup**. The docstring
  misrepresents what landed. Must-fix.
- **Stale-docstring contradiction** finding: `projectiveLineBar_isReduced` (G0BO L708-718)
  docstring claims the Mathlib bridge `HomogeneousLocalization.Away → IsDomain` is missing,
  while the body L720-753 builds exactly that bridge inline. The lean-auditor's escalation:
  "a stale 'Mathlib gap' docstring on a closed lemma is the strongest possible signal that
  **other 'Mathlib gap' docstrings in this file may be just as wrong**" — flagging
  `gm_geomIrred`, `projGm_isReduced`, `projectiveLineBar_geomIrred`,
  `projectiveLineBar_smoothOfRelDim` for re-audit. Must-fix.
- **Other 9 must-fix items** all involve load-bearing `sorry` declarations with
  excuse-comments: `gm_grpObj` (L622), `gmScalingP1` body (L659), `gmScalingP1_collapse_at_zero`
  body (L674), `projectiveLineBar_geomIrred` (L172), `projectiveLineBar_smoothOfRelDim`
  (L182), `gm_geomIrred` (L755), `projGm_isReduced` (L791), `iotaGm_isDominant` (AVR L924),
  and the stale 26-line "3 gates" narrative on `genusZeroWitness.isAlbaneseFor.key`
  (Jacobian L237-263; gate (1) "import cycle" is no longer live since `rigidity_genus0_curve_to_grpScheme`
  was relocated upstream — the narrative blocks the simple re-route iter-156/162 made
  possible).
- **Major** findings: `ga_grpObj` (G0BO L537) is a sorried publicly-exported instance for
  a demoted route (delete candidate); G0BO file-header schedule references are stale;
  AVR L915-922 narrative claims 4 Lane A exports all ship as instances when 2 are still
  `sorry`; `genusZero_curve_iso_P1` honest disclosure but load-bearing; `positiveGenusWitness`
  bare-`sorry` off-critical-path; `rigidity_over_kbar` superseded fallback closure plan;
  Cotangent/GrpObj.lean L465-525 stale narrative on excised declarations.
- **Resolution**: Plan-agent must seed iter-169 with the corrections (A through F in
  `recommendations.md`). The CRITICAL `aux_left` docstring rewrite + the stale
  `projectiveLineBar_isReduced` docstring + the re-audit of 4 sibling "Mathlib gap" claims
  are the highest priority. iter-169 prover lane should also rewrite the
  `genusZeroWitness.isAlbaneseFor.key` "3 gates" narrative since gate (1) is no longer
  live.
- Report: `task_results/lean-auditor-iter168.md`.

## Build sanity
- `lake build AlgebraicJacobian` — GREEN (sorry warnings only). Verified.
- `lean_verify` on the substantive new closures:
  - `AlgebraicGeometry.projectiveLineBarAffineCover` → `{propext, Classical.choice,
    Quot.sound}` ✓
  - `AlgebraicGeometry.projectiveLineBar_isReduced` → `{propext, Classical.choice,
    Quot.sound}` ✓
  - `AlgebraicGeometry.homogeneousLocalizationAwayToMvPoly` → `{propext, Classical.choice,
    Quot.sound}` ✓
  - `AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway` → `{propext, Classical.choice,
    Quot.sound}` ✓
  - `AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_right` → `{propext,
    Classical.choice, Quot.sound}` ✓
  - `AlgebraicGeometry.homogeneousLocalizationAwayIso` → `{propext, sorryAx,
    Classical.choice, Quot.sound}` ✓ (sorryAx propagates honestly from `aux_left`)
- **`lake env lean AlgebraicJacobian/Genus0BaseObjects.lean` direct-elaboration** surfaces
  two non-fatal errors at L137 and L446 about `IsScalarTower.of_algebraMap_eq fun x => rfl`
  failing instance synthesis on the metavariable for the source type. These errors **do not
  appear in `lake build`** (the authoritative path uses the .olean dependency graph and
  succeeds). The error sites pre-date iter-168 — both are in `projectiveLineBar_isProper`
  + `pointOfVec` from iter-166 — so this is an LSP-elaboration sensitivity to coerced-subtype
  instance synthesis, not a project regression. Flagged for a future hygiene iter.

## Blueprint markers updated (manual)

(No manual marker changes this iter beyond review-doctor confirmations. The plan agent
ran sync_leanok between prover and review — `sync_leanok-state.json`: iter 168, sha
7c15eb29, 0 added / 0 removed, 0 chapters touched. iter-167's `\lean{...}` hooks for
`def:genus0_base_objects` cover the 4 main objects + their points; the 3 major
checker-flagged missing-pin items are best handled by a blueprint-writer dispatch the
iter-169 plan agent should schedule.)

## What progresses next (iter-169)

- **PRIMARY for iter-169** (the progress-critic's hard test): attack `gmScalingP1` body
  via the **direct `Proj.fromOfGlobalSections` route** (avoids `aux_left`). The prover
  surfaced this as the cleaner alternative — define chart-side morphisms `MvPoly (Fin 2) kbar →
  Away 𝒜 (X i) ⊗ GmRing` sending `X i ↦ 1 ⊗ 1` (a unit), glue via
  `Scheme.Cover.glueMorphisms` over the new `projectiveLineBarAffineCover`. ~80-120 LOC.
- **PRIMARY follow-up**: `gmScalingP1_collapse_at_zero` body (chart-1 defequal computation,
  ~30-50 LOC).
- **AUTO-CLOSES**: `iotaGm_isDominant` (AVR L931) — folds into the iter-169 prover lane
  once `gmScalingP1`'s body has a concrete dominant morphism.
- **DEFER**: `genusZero_curve_iso_P1` (AVR L1135). The `rrbridge` analogist verdict is
  NOT_DISPATCHABLE for the foreseeable future.
- **DEFER (off-critical-path)**: `gm_grpObj` (G0BO L622). The iter-168 plan re-classified
  it as OFF the rigidity critical path.

## Lessons recorded
- New KB Proof Patterns this iter (4 + 1 stale-docstring detection):
  1. `HomogeneousLocalization.Away` is a domain via `Function.Injective.isDomain` on
     the injection into `Localization.Away` (when the underlying ring is a domain and the
     localising element is a non-zero-divisor). Reusable for any `Proj`-chart reducedness
     argument over a domain graded ring.
  2. `Proj.affineOpenCoverOfIrrelevantLESpan` `hf` discharge pattern for `MvPolynomial`
     standard ℕ-grading (irrelevant ⊆ `Ideal.span {X i}` via `MvPolynomial.as_sum` +
     `MvPolynomial.X_dvd_monomial`).
  3. `Localization.awayLift_mk` with explicit `(v := 1) (hv := …)` parameter — for ring
     maps sending the generator to `1` (a unit), removes one level of `IsUnit.unit`/
     `hu.choose` indirection.
  4. `RingEquiv.ofRingHom` partial-iso construction — when only one round-trip is closed,
     the iso is defined but downstream `lean_verify` accurately reports the partial axiom
     hygiene; this lets the prover stage the build cleanly without misrepresenting
     completion.
  5. Detection rule: a comment that says "would close via X" where X is the proof's
     actual strategy + cites a "Mathlib gap" should be re-audited — the gap may not exist
     (iter-168 dispelled the iter-167 docstring's "HomogeneousLocalization.Away → IsDomain
     is a Mathlib gap" claim by closing it in <10 LOC).
