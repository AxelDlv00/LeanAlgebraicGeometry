# Recommendations for iter-169 plan agent

## CRITICAL (must address before any prover dispatch)

### A. Rewrite the `homogeneousLocalizationAwayIso_aux_left` docstring (G0BO.lean:350-367) — lean-auditor must-fix critical

The 18-line docstring opens with **"iter-168 partial: structural setup via `ext`, `Away.mk_surjective`, `val_injective` gets us to the underlying `Localization.Away (X i)` comparison; the residual identity reduces to a monomial-by-monomial check using `Localization.mk_eq_mk_iff` …"**. The body L368-372 is bare `sorry` — **zero structural setup actually landed**.

This is the critical lean-auditor finding (the most acute excuse-comment in the project this iter). Action: **the planner must instruct iter-169's prover to either land the claimed scaffold or rewrite the docstring to `TODO — no body landed this iter` BEFORE any other prover work**. Leaving a misleading docstring in place misleads downstream readers and future provers and is exactly the pattern the audit rubric flags as critical.

### B. Refresh the L708-718 docstring on `projectiveLineBar_isReduced` (G0BO.lean)

The docstring claims "Project-side scaffold sorry (Mathlib does not ship `IsReduced (Proj 𝒜)` … would close via `IsReduced.of_openCover` … once `HomogeneousLocalization.Away` is bridged to `IsDomain` for the standard ℕ-grading …)" — but the iter-168 body (L720-753) **closes the lemma** by building exactly that bridge inline in <10 LOC. The docstring's opening line directly contradicts the proof body that follows. Stale narrative on a now-closed lemma.

Action: the next prover lane touching this file should rewrite the docstring to describe the actual landed strategy.

### C. Re-audit the 4 sibling "Mathlib gap" claims (G0BO.lean)

Given the iter-168 lesson on `projectiveLineBar_isReduced` (the cited Mathlib gap was not real), the auditor flagged 4 more "Mathlib gap" claims in the same file that should be re-audited rather than presumed:

- `projectiveLineBar_geomIrred` (L172-177) — "Mathlib does not ship `GeometricallyIrreducible` for `Proj` of a polynomial ring"
- `projectiveLineBar_smoothOfRelDim` (L179-184) — "Mathlib does not ship `SmoothOfRelativeDimension 1` for `Proj`"
- `gm_geomIrred` (L755-763) — "the direct `GeometricallyIrreducible` consequence of `IrreducibleSpace + Spec(domain over alg closed)` is not bridged"
- `projGm_isReduced` (L779-795) — "the `Smooth → GeometricallyReduced` bridge is missing at scheme level"

Action: dispatch a `mathlib-analogist` (api-alignment mode) to re-check each cited Mathlib gap BEFORE accepting any of them as genuine multi-iter blockers.

## Hard-test reminder from `progress-critic-routec168`

The critic's iter-168→iter-169 escalation rule: **if the planner defers `gmScalingP1` body with the same phrasing a fourth time, escalate to user.** iter-168 did NOT close the body, but DID land Steps 1+3 axiom-clean and Step 2 partial — meaningful depth conversion. **iter-169 MUST attack the body.** A fourth deferral (without a body-attempt task result) trips STUCK escalation.

## Closest-to-completion targets (iter-169 PRIMARY)

### 1. `gmScalingP1` body (G0BO.lean:659) — PRIMARY, body-attempt mandatory

The prover surfaced two routes; pick the cheaper one.

**Route A — direct `Proj.fromOfGlobalSections` (RECOMMENDED, avoids `aux_left`)**:
- Define chart-side morphisms via `Proj.fromOfGlobalSections` of ring maps `MvPoly (Fin 2) kbar → Away 𝒜 (X i) ⊗ GmRing` sending `X i ↦ 1 ⊗ 1` (a unit, so the irrelevant-ideal-maps-to-top condition holds). One ring map per chart `i ∈ Fin 2`.
- Glue via `Scheme.Cover.glueMorphisms` over the existing `projectiveLineBarAffineCover`.
- No dependency on the chart-ring iso. ~80-120 LOC.

**Route B — iso route** (closes `aux_left` first, then uses the iso):
- Close `aux_left` via the surjective-cancel trick (image = `Algebra.adjoin (𝒜 0) {isLocalizationElem}` = `⊤` by `Away.adjoin_mk_prod_pow_eq_top` with `d = 1, v = ![X 0, X 1], dv = ![1, 1]`).
- Then build `gmScalingP1` via `pullbackSpecIso` + `homogeneousLocalizationAwayIso.symm` + `Proj.awayι` per analogist Q3-Q5.
- Total ~110-150 LOC (50 LOC for `aux_left` + 60-100 LOC for the glue).

**Recommendation**: Route A. It's cheaper, decouples from `aux_left`, and the prover's task report explicitly names it as the cleaner alternative (Recommendation 2).

### 2. `gmScalingP1_collapse_at_zero` body (G0BO.lean:674) — PRIMARY (gated on (1))

Once Route A's chart-side morphism is in place, the chart-1 direct computation `(0, λ) ↦ λ · 0 = 0` is a defequal ring-map check. ~30-50 LOC.

### 3. `iotaGm_isDominant` (AVR.lean:931) — AUTO-CLOSE (downstream)

The iter-167 named bridge depends on `gmScalingP1`'s body landing. Once (1) lands, this becomes provable by direct dominance-of-a-known-morphism reasoning. Should fold into the iter-169 prover lane as a follow-up (no separate dispatch).

## HIGH (lean-auditor must-fix items that block downstream)

### D. `genusZeroWitness.isAlbaneseFor.key` stale "3 gates" narrative (Jacobian.lean:237-263)

The 26-line "3 gates" comment claims gate (1) (import cycle) is live. **It is NOT**: per `AbelianVarietyRigidity.lean` L19-21, the rigidity stack has been relocated upstream as `rigidity_genus0_curve_to_grpScheme`, which IS importable from `Jacobian.lean`. The narrative blocks the simple re-route iter-156/162 made possible.

Action: dispatch a `refactor` subagent to (a) replace the 26-line narrative with a one-line citation routing to `rigidity_genus0_curve_to_grpScheme`, and (b) wire the actual sorry-bodied close (the remaining substantive gap is the base-change-to-`k̄` step, much narrower than gate (3) claims). The remaining sorry can stay until the chain ahead of it discharges, but the narrative must reflect reality.

### E. `rigidity_over_kbar` (RigidityKbar.lean:70-88) — superseded fallback

The iter-126 closure plan ("iter-129+ cotangent-vanishing pile") is superseded by the route (c) commit per AbelianVarietyRigidity.lean. The declaration is a fallback artifact.

Action: either mark with a `// SUPERSEDED — fallback route artifact` docstring update, or schedule a refactor to delete it. The lean-auditor's preferred action: mark as superseded; full deletion is out of scope this iter.

### F. `iotaGm_isDominant` excuse-comment (AVR.lean:924-934)

Body is bare `sorry` with docstring "Project-side bridge pending Lane A's concrete `gmScalingP1` body". Action: this excuse-comment naturally clears when Lane A lands `gmScalingP1` (item 1 above) — schedule on the iter-169 prover lane.

## MEDIUM (deferred but flagged)

### G. Blueprint coverage gaps (from `lean-vs-blueprint-checker-g0bo-iter168`)

Three major checker findings, all blueprint-writer domain:

- Add `\lean{...}` pin to `prop:projectiveLineBar_isReduced` (NEW substantive iter-168 closure, no chapter coverage).
- Add a roadmap subsection / `\lean{...}` blocks for the chart-ring iso machinery (`projectiveLineBarAffineCover`, `homogeneousLocalizationAwayToMvPoly`, `mvPolyToHomogeneousLocalizationAway`, `homogeneousLocalizationAwayIso`) — these are substantive iter-168 infrastructure that the chapter is silent on.
- Optionally pin `projectiveLineBar_geomIrred` and `projectiveLineBar_smoothOfRelDim` as named Mathlib-gap obligations.

Action: dispatch `blueprint-writer` slug `g0bo-iter169-coverage` targeting `AbelianVarietyRigidity.tex` (which covers `Genus0BaseObjects.lean` per `% archon:covers`).

### H. Stale file-header / schedule references (G0BO.lean:33-34)

File-header docstring lists "scaffold `sorry`s for iter-166+" and refers 5 times to "iter-166" as target iter for scaffold closures; iter-168 state has closed several. Stale schedule narrative — major from auditor. Action: refresh during the iter-169 prover lane's housekeeping pass.

## Promising approaches needing more work

### I. `aux_left` via surjective-cancel (G0BO.lean:368) — HIGH (only if Route B chosen)

Strategy detailed in the task report:
- `Lemma`: `Function.Surjective (mvPolyToHomogeneousLocalizationAway kbar i)`.
- Proof: image = `Algebra.adjoin (𝒜 0) {isLocalizationElem}`, then `Away.adjoin_mk_prod_pow_eq_top` with `d = 1, v = ![X 0, X 1], dv = ![1, 1]` gives `= ⊤`.
- Then `aux_left` follows from `aux_right` + cancel-surjective.

**Open question** for upstream: should `homogeneousLocalizationAwayIso` be promoted to a Mathlib PR (`Mathlib.RingTheory.GradedAlgebra.HomogeneousLocalization.PolynomialQuotient`)? Not a blocker for iter-169 — Route A doesn't need this.

## Blocked targets (plan agent should NOT re-assign without structural change)

### J. `genusZero_curve_iso_P1` (AVR.lean:1135) — STILL BLOCKED (RR-bridge Mathlib gap)

iter-168 dispatched `mathlib-analogist rrbridge`; verdict was NOT_DISPATCHABLE because all 4 Hartshorne IV.1.3.5 ingredients are absent at the scheme level. Persistent file: `analogies/rrbridge-survey.md`. **Do NOT open a prover lane on this.** Defer to user-strategy decision when Lane A's body closures land.

### K. `gm_grpObj` (G0BO.lean:622) — STILL DEFERRED, OFF the critical path

The iter-168 plan re-classified: the rigidity proof body only consumes `[GrpObj A]` on the *target* abelian variety, NOT on `Gm`. The 3-iter-defer flag remains accurate but the item is orthogonal to genus-0 closure. **Lean-auditor flagged it as must-fix-load-bearing**, but the planner's iter-168 reclassification stands (the rigidity body proof only needs `gm_grpObj` if we route through it, which the iter-166 helper does NOT). Keep deferred; the auditor's flag is sound on the literal "exported instance is sorry" reading but the criticality is real-time-low.

### L. `ga_grpObj` (G0BO.lean:537) — DELETE candidate

Lean-auditor major finding: "a sorried instance kept for a 'demoted route' should be deleted rather than left publicly exported". The iter-167 mathlib-analogist surfaced a ~2-3 LOC closure via `AffineSpace.homOverEquiv`, but no consumer needs it. Action: either close it cheaply via the analogist's recipe OR delete the declaration. The latter is the cleanest.

## Reusable proof patterns discovered iter-168

- **`HomogeneousLocalization.Away` is a domain** via `Function.Injective.isDomain` over `Localization.Away` (when the underlying ring is a domain and the localising element is a non-zero-divisor). Generalises to any `Proj` chart of a domain graded ring. Reusable for chart-local `IsReduced` arguments.
- **`Proj.affineOpenCoverOfIrrelevantLESpan` `hf` discharge** for `MvPolynomial` standard ℕ-grading: `MvPolynomial.as_sum` + `MvPolynomial.X_dvd_monomial` reduces "irrelevant ⊆ `Ideal.span {X i}`" to the `coeff 0 p = 0` monomial check.
- **`Localization.awayLift_mk` with explicit `v` parameter** — for ring maps sending the generator to a unit, `(v := 1) (hv := …)` removes one level of `IsUnit.unit`/`hu.choose` indirection.
- **`RingEquiv.ofRingHom` partial-iso construction** — even when only one round-trip is closed, the iso is defined and downstream `lean_verify` accurately reports the partial axiom hygiene.
- **Stale-docstring detection rule**: comments that say "would close via X" where X is the proof's actual strategy + cite a "Mathlib gap" should be re-audited — the gap may not exist (the iter-168 prover dispelled iter-167's "HomogeneousLocalization.Away → IsDomain is a Mathlib gap" claim in <10 LOC).

## Subagent reports landed this review

- `lean-vs-blueprint-checker-g0bo-iter168` — CONVERGING; 0 must-fix / 3 major / minor. Findings folded into G above.
- `lean-auditor-iter168` — 11 must-fix / 7 major / 3 minor. Findings folded into A–F above.
- `progress-critic-routec168` — CHURNING; hard test for iter-169: body of `gmScalingP1` MUST be attempted.

## Hygiene items (not blocking) — lean-auditor minor

- `push Not at h` at G0BO L226 — non-canonical Mathlib spelling (canonical: `push_neg at h`). Trivial golf.
- 3 blocks of revision-history graveyard comments in `Cotangent/ChartAlgebra.lean` (L20-34, L552-560, L624-629) — belong in commit messages, not source. Future cleanup.
- `lake env lean` direct-elaboration errors at G0BO L137/L446 on `IsScalarTower.of_algebraMap_eq fun _ => rfl` — `lake build` GREEN. Defer rewriting to a future hygiene iter.
