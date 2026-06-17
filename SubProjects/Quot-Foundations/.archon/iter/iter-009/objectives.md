# Iter 009 — Objectives (per-task detail)

## Dispatched prover lane (1)

### GrassmannianCells.lean — `def:gr_transition` [mathlib-build]
- Gate: blueprint-reviewer `iter009` GREEN (chapter complete+correct, all `\uses{}` resolve).
- Target: build `AlgebraicGeometry.Grassmannian.transitionMap` (Cramer-inverse transition ring hom
  `θ_{I,J}(X^J)=(X^I_J)⁻¹X^I` on the localized affine charts), then `cocycleCondition` if budget.
- Special instruction: FIRST investigate the iter-008 no-output anomaly (same target, zero edits, no
  result) — confirm the file compiles, check for instance/universe obstructions, record findings.
- Housekeeping: delete stale `affineChart` docstring (~line 59).
- Escalation: a 2nd consecutive no-delivery iter ⇒ CHURNING (progress-critic `iter009b`).

## Blueprint correctives executed this iter (no prover)

### FBC route swap — blueprint-writer `fbc-routeswap` (COMPLETE) + blueprint-clean `iter009`
- Dropped `lem:base_change_mate_unit_value` / `…_fstar_reindex` / `…_gstar_transpose` (statement+proof).
- Replaced `…_generator_trace_eq` with `lem:base_change_mate_section_identity` (`Γ(θ)=lTensor R' η_M`,
  `% LEAN SIGNATURE` pinned, Stacks 02KH/lemma-affine-base-change verbatim quote).
- Rebuilt `lem:base_change_mate_regroupEquiv` + `base_change_regroup_linearEquiv` (RegroupHelper) on
  `Algebra.IsPushout.cancelBaseChange`; new `\mathlibok` anchor `lem:isPushout_cancelBaseChange_mathlib`.
- Verified: 0 unknown_uses, 0 orphaned `\uses{}`, env-balanced. Reviewer: complete:partial (one
  residual obligation), correct:true. Gate-ready iter-010.

### GF effort-break — (effort-breaker landed pre-resume; validated by blueprint-clean + reviewer)
- `lem:gf_torsion_reindex` decomposed into `lem:gf_torsion_annihilator` (annihilator extraction),
  `lem:gf_nagata_monic_lastVar` (Nagata change-of-vars), shared engine
  `lem:gf_mvPolynomial_quotient_finite_monic`, + Mathlib anchors
  (`lem:annihilator_meets_nonZeroDivisors`, `lem:polynomial_monic_quotient_finite`).
- Each sub-lemma: `% LEAN SIGNATURE` + informal proof + correct `\uses{}`. Assembly faithful.
  Reviewer: decomposition sound, gate-ready iter-010.

### QuotScheme writer — blueprint-writer `quot-bridge-snap` (in flight at plan close)
- Task 1 (must-fix): author `% LEAN SIGNATURE` + proof sketch for the QCoh bridge
  `lem:qcoh_section_localization_basicOpen` (`Scheme.Modules.isLocalizedModule_basicOpen`) — unblocks
  the whole QUOT-A predicate chain. Gate-pending iter-010 review.
- Task 2 (unstarted phase): author `% LEAN SIGNATURE` + proof sketch for SNAP-S2
  `lem:gradedHilbertSerre_rational` (Hartshorne I.7.5, Noetherian induction on f.g. graded modules).

## STRATEGY.md edits this iter
- FBC route rewritten (direct-on-sections committed; mate tower removed from Phases/Gaps/Routes).
- SNAP re-statused NEXT(S2) with the blocker named (`def:sectionGradedRing` gates S1/S3; S2 authorable).
- Format de-drifted: per-iter narrative stripped, table cells shortened, "Rejected" note removed.
- FBC-A + GF-alg iters-left revised 3–4 → 2–3 (OVER_BUDGET acknowledged per progress-critic).
