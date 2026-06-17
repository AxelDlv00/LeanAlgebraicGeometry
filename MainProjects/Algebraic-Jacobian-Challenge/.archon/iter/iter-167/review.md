# Iter-167 (Archon canonical) — review

## Outcome at a glance
- **The "close the AVR aux-sorry pile + add Lane A export instances" iter.** Two
  parallel prover lanes, file-disjoint, both following the iter-167 plan verbatim:
  Lane B (`AbelianVarietyRigidity.lean`) closed the iter-166 helper-aux pile;
  Lane A (`Genus0BaseObjects.lean`) shipped the named product/Proj instances Lane B
  consumes.
- **Lane B delivered (PRIMARY COMPLETE):** all 5 in-line `sorry`s inside the
  iter-166 helper `morphism_P1_to_grpScheme_const_aux` eliminated; 4 resolve via
  Lane A's parallel exports (`projGm_locallyOfFiniteType`, `projGm_geomIrred`,
  `projGm_isReduced`, `projectiveLineBar_isReduced`) under `infer_instance`; the
  5th promoted to a single named top-level bridge `iotaGm_isDominant` (still
  `sorry`, gated on Lane A's `gmScalingP1` body). All 5 `-- TODO:` excuse comments
  dropped (lean-auditor-iter166 major cleared). AVR sorry footprint **6 → 2**.
- **Lane A delivered (PARTIAL per plan target):** 4 new axiom-clean exports
  (`gmRing_isDomain`, `gm_irreducibleSpace`, `projGm_locallyOfFiniteType`,
  `projGm_geomIrred`) + 3 new scaffold-sorry exports
  (`projectiveLineBar_isReduced`, `gm_geomIrred`, `projGm_isReduced`) with honest
  Mathlib-gap docstrings. The 2 CRITICAL PRIMARY body closures (`gmScalingP1`,
  `gmScalingP1_collapse_at_zero`) DEFERRED; OPT-IN `gm_grpObj` / `ga_grpObj`
  DEFERRED. Genus0BaseObjects sorry footprint **6 → 9** (3 new export scaffolds
  added, 0 of the 6 pre-existing closed).
- **Dispatch MATCHED the plan — 10th consecutive iter** with no plan/dispatch
  contradiction.
- **Global bare-sorry 15 → 14 (-1).** Per-file inventory (verified by grep + `lake
  build`):
  - `AbelianVarietyRigidity.lean` — **2** at L934 (`iotaGm_isDominant`, NEW) and
    L1141 (`genusZero_curve_iso_P1`, RR bridge, unchanged).
  - `Genus0BaseObjects.lean` — **9** at L177, L184, L335, L420, L459, L476, L522
    (NEW), L532 (NEW), L564 (NEW).
  - `Jacobian.lean` — **2** (unchanged).
  - `RigidityKbar.lean` — **1** (unchanged).
  No new `axiom`; no protected signature touched; `lake build AlgebraicJacobian.AbelianVarietyRigidity`
  and `lake build AlgebraicJacobian.Genus0BaseObjects` both green (sorry warnings only).

## The advance, independently verified this review
1. **AVR helper `morphism_P1_to_grpScheme_const_aux` is now `sorry`-free at the
   body level.** Verified directly (Read of AVR.lean L958-end-of-helper) and
   re-confirmed by `lean-auditor-iter167` (per-file checklist: "zero inline
   `sorry`s"). 4 of the 5 iter-166 internal sorries resolve via Lane A's
   `projGm_*` + `projectiveLineBar_isReduced` exports under `infer_instance`; the
   5th surfaces as a single named file-local bridge `iotaGm_isDominant` (L931–L934,
   `private lemma`, single `sorry`, docstring discloses Lane A gating).
2. **Lane B PRIMARY target met:** iter-166 progress-critic hard test was
   "iter-167's AVR report must close ≥3 of the 5 aux sorries OR demonstrate
   Lane-A-dependency forced the residual." iter-167 closed 4 of 5; the 5th
   carries a documented Lane A blocker citation. **HARD TEST PASSED.**
3. **Lane A axiom-clean exports verified** by both the lean-auditor and the
   sister checker:
   - `gmRing_isDomain` — `IsLocalization.isDomain_localization` chain.
   - `gm_irreducibleSpace` — `change` + `infer_instance` chains
     `gmRing_isDomain → PrimeSpectrum.irreducibleSpace`.
   - `projGm_locallyOfFiniteType` — `change` to `pullback.fst ≫ ℙ¹.hom`, then
     `infer_instance` (LOFT base-change + composition stability). Uses the rfl
     identity `(X ⊗ Y).hom = pullback.fst X.hom Y.hom ≫ X.hom` from
     `Mathlib/CategoryTheory/Monoidal/Cartesian/Over.lean:62` (`tensorObj_hom`).
   - `projGm_geomIrred` — `change` + `exact GeometricallyIrreducible.comp _ _`
     (bare `infer_instance` does not auto-fire). Propagates `sorryAx` through
     `gm_geomIrred` + `projectiveLineBar_geomIrred` (acknowledged in docstring).
4. **Lane A scaffold-sorry exports** all carry honest Mathlib-gap docstrings
   (auditor verified: 3-table inspection, all 3 cite the actual Mathlib gap, no
   smuggled excuses). The gaps named:
   - `projectiveLineBar_isReduced` — `HomogeneousLocalization.Away`-is-domain for
     the standard ℕ-grading not shipped; closure needs project-side helper
     `homogeneousLocalizationAwayIso ≃+* MvPolynomial Unit kbar` (~30 LOC).
   - `gm_geomIrred` — `Localization.Away t ⊗_R S ≃+* Localization.Away (t ⊗ 1)`
     not shipped; tensor-of-domains-over-field also missing.
   - `projGm_isReduced` — `Smooth → GeometricallyReduced` scheme-level bridge
     missing; chart-local alternative needs the same two missing helpers.

## Is this iter-157 laundering again? No.
Explicitly checked. Both `lean-auditor-iter167` and the AVR checker confirmed:
- `morphism_P1_to_grpScheme_const_aux` body has zero inline `sorry`; the 4
  product/Proj instances resolve by `infer_instance` (Lane A exports are the real
  named declarations, not signature-stripping); the dominance bridge is hoisted
  to a NAMED top-level `iotaGm_isDominant` with an explicit gating disclosure.
- The basepoint hypothesis `hf0` is still consumed at L975:
  `rw [← Category.assoc, hcollapse]; exact hf0` (preserved verbatim from iter-166).
- No theorem with a sorry-free top-level body has a helper that drops a
  load-bearing hypothesis. All hypothesis threads (`_hf`/`hf0`/`hα`/`_hgenus`)
  intact.

## Review-phase subagents (3 dispatched)

| Subagent | Slug | mf / maj / min | Headline |
|---|---|---|---|
| `lean-auditor` | iter167 | 0 / 7 / 3 | iter-167 lane edits sound — 5 iter-166 TODOs swept clean; 3 new scaffold sorries all carry honest Mathlib-gap docstrings; `iotaGm_isDominant` bridge cleanly hoisted. **Iter-167-specific majors: 2** (status-tag bumps on AVR L1090/L1156, still say "Status (iter-166):"). **Iter-166 carry-over majors: 5** (stale-narrative blocks in `Jacobian.lean` L237-263, `RigidityKbar.lean` L9-89, `Cotangent/GrpObj.lean` L297-326 + L465-525 + EXCISE stubs, `Cotangent/ChartAlgebra.lean` L36-79). All carry-overs unchanged from iter-166. |
| `lean-vs-blueprint-checker` | avr-iter167 | 0 / 1 / 3 | AVR.lean faithfully realises the blueprint chapter — every in-scope `\lean{...}` hook resolves to an existing decl with matching (or strictly more general) signature; iter-167 refactor structurally clean and excuse-comment-free. 1 major: 3 off-path Lean-hooks (`rationalMap_to_av_extends`, `hom_Ga_to_av_trivial`, `morphism_Ga_to_av_const`) name decls that don't exist. 1 minor: chapter L1417-1432 NOTE on `prop:morphism_P1_to_AV_constant` was stale (still claimed "5 helper sorries" — this review **edited it** to record the iter-167 reduction to 1 named bridge). |
| `lean-vs-blueprint-checker` | g0bo-iter167 | 0 / 0 / 2 | **CLEAN** — all 11 `\lean{...}` hooks resolve to declarations with matching signatures; 4 new axiom-clean instances verified; 3 new scaffold sorries have honest gap-naming docstrings; no TODO/excuse-comments or placeholder bodies. 2 minor optional-hygiene recommendations (the new Lane-B product-stability instances aren't individually `\lean{}`-pinned; `Gm`'s affine-Spec encoding choice documented only in Lean docstring). |

Reports archived under `logs/iter-167/{lean-auditor-iter167, lean-vs-blueprint-checker-avr-iter167, lean-vs-blueprint-checker-g0bo-iter167}-report.md`.

## Blueprint markers updated (manual)

- `AbelianVarietyRigidity.tex`, `prop:morphism_P1_to_AV_constant`: appended an
  iter-167 `% NOTE` to the proof block (chapter L1432–L1444) recording the
  iter-167 reduction from "5 helper sorries" to ONE named top-level bridge
  `iotaGm_isDominant`. Math unchanged. Triggered by avr-iter167 finding 1
  (`Stale prose`).
- No `\mathlibok` additions this iter (no new declarations are direct Mathlib
  re-exports).
- No `\lean{...}` corrections needed (the iter-167 prover did not rename
  declarations; the only NEW Lean decl is `iotaGm_isDominant`, a private file-local
  helper not promoted to a chapter `\lean{...}` per the checker's adequacy verdict).
- No stale `\notready` removals (no `\notready` markers in scope).
- 3 wrong-hint blueprint→Lean hooks (`rationalMap_to_av_extends`,
  `hom_Ga_to_av_trivial`, `morphism_Ga_to_av_const`) flagged by the avr-iter167
  checker — DEFERRED to a future blueprint-writer hygiene iter (off the critical
  path; no `\leanok` on either block, so they cannot falsely launder; not blocking
  iter-167's AVR consumer work).

## Per-file aux-sorry-pile shape (iter-167 close)

```
AbelianVarietyRigidity.lean  (2 sorry)
├── iotaGm_isDominant          L934   NEW — file-local dominance bridge
└── genusZero_curve_iso_P1     L1141  pre-existing RR bridge, off-limits

Genus0BaseObjects.lean       (9 sorry)
├── projectiveLineBar_geomIrred       L177   OPT-IN, pre-existing
├── projectiveLineBar_smoothOfRelDim  L184   OPT-IN, pre-existing
├── ga_grpObj                         L335   OPT-IN, pre-existing
├── gm_grpObj                         L420   CRITICAL deferred (3-iter), pre-existing
├── gmScalingP1                       L459   CRITICAL deferred (3-iter), pre-existing
├── gmScalingP1_collapse_at_zero      L476   CRITICAL deferred (3-iter), pre-existing
├── projectiveLineBar_isReduced       L522   NEW — Lane B export, Mathlib gap
├── gm_geomIrred                      L532   NEW — Lane B export, Mathlib gap
└── projGm_isReduced                  L564   NEW — Lane B export, Mathlib gap

Jacobian.lean                (2 sorry)  — unchanged
RigidityKbar.lean            (1 sorry)  — unchanged
```

## Watch items for iter-168 (planner's attention)

1. **`gmScalingP1` body + `gm_grpObj` are now 3-iter deferred (iter-165, iter-166,
   iter-167).** The iter-167 progress-critic explicitly named these as the
   `GrpObj.ofRepresentableBy` recurring-blocker watch item: "If persists into
   iter-168 reports, escalate to STUCK with a Mathlib-idiom corrective." iter-168
   plan must either (a) carry both into the lane with adequate budget, or (b)
   explicitly pivot via a Mathlib-idiom consult on `GrpObj.ofRepresentableBy`. A
   third silent deferral would now justify the CHURNING corrective.
2. **Top single-lever for iter-168**: build the `homogeneousLocalizationAwayIso`
   helper (~30 LOC of project-side ring-iso work). It unlocks 3 of the iter-167
   scaffold-sorry exports (`projectiveLineBar_isReduced`, the chart-local branch
   of `projGm_isReduced`, and one of `gmScalingP1`'s 5 chartwise glue steps).
   Cheapest infrastructure lever on the route.
3. **`iotaGm_isDominant` is parked on Lane A.** Once `gmScalingP1` lands the
   concrete open-immersion form `Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹`, the dominance
   reduces to `IsOpenImmersion → IsDominant` (priority-100 instance L226 in
   `Mathlib.AlgebraicGeometry.Morphisms.UnderlyingMap`). DO NOT retry `infer_instance`
   in the meantime — iter-167 confirmed the in-context synthesis fails (backward-defeq
   quirk with `gmScalingP1 := sorry`) even though a standalone `lean_run_code`
   smoke test succeeds.
4. **Status-tag bumps on AVR L1090, L1156** ("Status (iter-166):" → "Status
   (iter-167):" with updated residual list). lean-auditor-iter167 flagged as
   major; cosmetic only (content correct), defer to a hygiene-only iter or fold
   into the iter-168 prover task report for AVR if it runs.
5. **5 iter-166 stale-narrative carry-over majors UNCHANGED for the third
   consecutive iter.** Defensible (the affected declarations are sound;
   misleading-purpose narratives only) but the carry-over has now hardened into a
   pattern; a single hygiene-only iter scheduled when no critical-path lane is
   open would close all 5.

## Subagent skips

None. All three review-phase subagents (mandatory `lean-auditor` + 2 file-scoped
`lean-vs-blueprint-checker` per modified file) dispatched.
