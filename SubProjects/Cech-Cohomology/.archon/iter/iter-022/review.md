# iter-022 review

## Overall progress this iter
- **Total sorry**: 2 → 2 (no regression). Both intentional: superseded relative-form
  `CechAcyclic.lean:110` (`affine`, blueprint-authorized via `% NOTE`) + frozen P5b
  `CechHigherDirectImage.lean:679`.
- **Build**: GREEN. Both touched files diagnostic-clean; both `lake env lean … → EXIT 0`.
  All new decls `lean_verify`-clean (`{propext, Classical.choice, Quot.sound}`).
- **Lanes planned 2, ran 2** — the iter-021 noop trap was FIXED (planner D1). First time
  FreePresheafComplex received prover work since iter-019.
- **+30 axiom-clean declarations** (16 CechAcyclic + 14 FreePresheafComplex); **0 new sorries**;
  **2 named blueprint targets landed** (both CechAcyclic):
  - `sectionCech_homology_exact` (`lem:section_cech_homology_exact`)
  - `sectionCech_affine_vanishing` (`lem:cech_acyclic_affine`, section form).

## Branches advanced
- **P3 L1 (`CechAcyclic.lean`, +16) — the tilde-bridge is CLOSED.** The complete categorical→module
  homology bridge for `F = ~M`: `phiL`/`phi` (the comparison, a one-line `IsLocalizedModule.iso`),
  `restr_bridge` (accessor-1↔accessor-2), `phiL_naturality`/`phi_naturality` (per-coface naturality —
  the bottleneck, see below), the additive ladder (`sectionProdAddEquiv`, `sectionToModuleAddEquiv`),
  `sectionCechCofaceMatch`, `sectionCechAbExact`, and the two public theorems. The project's
  longest-running module-algebra route (P3 L1 affine vanishing) is now done for the tilde case. The
  only deferred piece is the general-qcoh reduction `F ≅ ~(ΓF)` (Stacks 01I8), correctly scoped in the
  blueprint and independent of the P3b lane.
- **P3b free (`FreePresheafComplex.lean`, +14) — engine complex built, named target still absent.**
  The CHURNING corrective ran (analogist → prover) and produced real content: the object half of the
  engine iso (`cechFreeEvalEngine_X`) PLUS the entire engine target complex `cechEngineComplex`, its
  `d²=0` (`cechEngineD_comp`), its contracting homotopy (`cechEnginePrepend_spec`, first try), and its
  positive-degree exactness (`cechEngineD_exact`). This resolves the chain-vs-cochain variance question.
  The named target `cechFreeEvalEngineIso` (the differential comm-square) was NOT built — left as a
  documented comment block, no sorry, no axiom. The residual is now a single comm-square lemma with all
  inputs in-file.

## This iter's analysis
- **The noop-trap fix is the headline operational win.** Two iters (020, 021) lost the Route-2
  corrective to a one-line formatting bug; iter-022's D1 put the scaffold keyword on the path line and
  both lanes ran, yielding +30 decls. The Knowledge Base now records this as RESOLVED & CONFIRMED, not
  an open blocker.
- **The biggest mathematical landing is P3 L1.** The tilde F-bridge — flagged a genuine new-infra
  blocker by iter-021's review — dissolved exactly as the iter-022 mathlib-analogist predicted (defeq,
  keep the `Ab` complex). The cost was performance engineering, not new mathematics: the
  `IsLocalizedModule.ext`-over-heavy-section-types timeout (abstract-the-map workaround) and the
  `LinearEquiv`-coerced-composition `rw`-mismatch (`change`/`DFunLike.congr_fun`). Both captured in the KB.
- **Route 2 is convergence-shaped churn, and iter-023 is the decision point.** The named target has
  been absent 4 iters — but unlike a true churn, the residual genuinely collapsed to one lemma with a
  documented ~60–120-line route and every input in-file. The honest reading: this iter was the
  *substantive* attempt the iter-021 corrective intended (it just stopped one lemma short). The planner
  should: (a) expand `lem:cech_free_eval_engine_iso` to cover the `survivingEquiv`-naturality step the
  lvb flagged as missing, then (b) dispatch scoped to the comm-square only. If it still does not land,
  the planner's own reversal signal (structural refactor of the differential derivation) fires — do not
  assign a 5th plain helper round.
- **No code-quality regressions.** lean-auditor: 0 critical, 1 major (FreePresheafComplex module header
  lists `cechFreeComplex_quasiIso` as owned though not defined — misleading; honest note only at file
  end), 5 minor. lvb ×2: 0 must-fix; CechAcyclic faithful + correctly-scoped; FreePresheafComplex's
  6 majors are all blueprint-side (the prepend `\lean{}` re-leveling, the unblueprinted engine layer,
  the under-specified comm-square sketch). All land in `recommendations.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:cech_free_eval_prepend_homotopy`: added `% NOTE`
  (pinned `\lean{cechFreeEvalPrependHomotopy}` does not exist; built engine-level as `cechEnginePrepend`;
  planner/writer to re-point `\lean{}` + re-level prose).
- `Cohomology_CechHigherDirectImage.tex`, `lem:cech_free_eval_prepend_homotopy_spec`: added `% NOTE`
  (built as `cechEnginePrepend_spec` + `cechEngineD_exact`).
- No `\mathlibok` (no Mathlib re-export this iter); no stale `\notready`; `\leanok` untouched
  (sync_leanok ran for iter 22: +2/−2).

## Coverage debt
`archon dag-query unmatched` = 26 `lean_aux` nodes; full list + recommended attachment blocks in
`session_22/recommendations.md`.

## Subagent skips
- (none — both HIGHLY RECOMMENDED review subagents dispatched: lean-auditor, plus
  lean-vs-blueprint-checker on each of the two prover-touched files.)
