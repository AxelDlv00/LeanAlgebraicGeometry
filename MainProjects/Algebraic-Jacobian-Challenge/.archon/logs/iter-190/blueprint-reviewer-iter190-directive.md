# Blueprint reviewer iter-190 directive

## Mandate

Whole-blueprint audit. iter-189 prover phase landed new declarations and the
plan-phase landed several new `\lean{...}` pins. iter-190 must verify per-chapter
completeness + correctness + the HARD GATE status for the files I am about
to dispatch provers on.

## Scope

Read every `.tex` file under `blueprint/src/chapters/`. Use the standard
per-chapter checklist (complete · correct · must-fix-this-iter).

## Specific iter-189 / iter-190 deltas to verify

iter-189 plan-phase added (before prover dispatch):
- `Picard_QuotScheme.tex` — `def:pullback_app_isoTensor_sigma` block
  pinning iter-188's NEW Σ-pair helper.
- `RiemannRoch_RRFormula.tex` — split `lem:euler_char_skyscraperSheaf`
  into independently pinned blocks
  `lem:H0_skyscraperSheaf_finrank_eq_one` and
  `lem:H1_skyscraperSheaf_finrank_eq_zero`; updated parent `\uses{}`.
- `RiemannRoch_OCofP.tex` — added
  `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf` block pinning
  iter-188's NEW `⊓ trivAtBot` carrier-refinement wrapper.
- `Genus0BaseObjects_Cross01Substrate.tex` — NEW chapter pinning
  Lane B Option B substrate(s) `IsClosedImmersion_lift_iff_range_subset` +
  `gmRing_tensor_homogeneousAway_isDomain`.

iter-189 prover phase landed:
- **OCofP.lean** — `carrierPresheaf_isSheaf` Case B closed axiom-clean
  (via direct irreducibility argument; the `carrierTypeSubfunctor`
  framework was inspected but the proof uses a cleaner direct route).
  Verify the chapter's `def:carrierSubmoduleSheaf` block accurately
  describes the landed implementation.
- **Cross01Substrate.lean** — NEW file, Substrate 1
  `IsClosedImmersion.lift_iff_range_subset` axiom-clean.
- **QuotScheme.lean** — 2 NEW typed-sorry pins:
  `tildeIso_of_isQuasicoherent_isAffineOpen` (Stacks 01I8) and
  `pullback_of_openImmersion_iso_restrict` (transport substrate). The
  iter-189 chapter does NOT yet have blocks for these. Flag as
  must-fix-this-iter so iter-190 plan-phase can land the pins before any
  prover dispatch.
- **AuslanderBuchsbaum.lean** — Substrate consolidated; `isDomain_of_regularLocal`
  isolated as the lone Stacks 00NQ named sorry. Verify whether the
  chapter pins this new declaration (an iter-189 plan-phase pin
  recommendation was logged in the task result; check whether it
  landed and whether the chapter needs `def:isDomain_of_regularLocal`
  block).
- **RationalCurveIso.lean** — Pin 2 `Hom.poleDivisor_degree_eq_finrank`
  diagnosed as mathematically FALSE as stated; the chapter has a `% NOTE
  (iter-189 review)` flagging the structural conflict between the
  iter-187 `Hom.poleDivisor` body (a principal divisor of degree 0)
  and the RHS `Module.finrank > 0`. Verify the chapter prose is now
  honest about the corrective options (a)/(b) outlined in iter-189
  task result.

## What I need from you

A per-chapter checklist with columns (complete | correct | must-fix-this-iter).
For each chapter F has `\lean{X}` declarations, confirm that each `X`
exists in the live Lean tree at the path declared (or the chapter declares
the path via `% archon:covers ...`). Special attention to:

- The 2 NEW QuotScheme pins (`tildeIso_of_isQuasicoherent_isAffineOpen`,
  `pullback_of_openImmersion_iso_restrict`) — chapter must grow blocks
  for these.
- The Pin 2 structural conflict in RationalCurveIso — chapter must
  either pivot the lemma statement to `positivePart`, or document the
  refactor explicitly.
- The 2 unstarted-phase proposals from iter-188 (Pic0AbelianVariety,
  H1Vanishing) — both deferred to iter-190 plan-phase; if they remain
  unstarted, name them under `## Unstarted-phase blueprint proposals`.
- The 1 broken cross-ref the blueprint-doctor flagged
  (`\cref{chap:RR_H1Vanishing}` in `RiemannRoch_RRFormula.tex`) —
  resolved by writing the H1Vanishing chapter.

## HARD GATE outcome

For each file iter-190 plan-phase is considering dispatching a prover on,
return one of:
- `complete: true; correct: true; must-fix: none` → fine to dispatch.
- otherwise → list the must-fix items so I can decide whether to
  blueprint-write this iter or defer the file.

The candidate files for iter-190 prover dispatch are:
- `RiemannRoch/OCofP.lean`
- `RiemannRoch/RationalCurveIso.lean`
- `Picard/IdentityComponent.lean`
- `Albanese/AuslanderBuchsbaum.lean`
- `Picard/QuotScheme.lean`
- `Genus0BaseObjects/Cross01Substrate.lean`
- `AbelianVarietyRigidity.lean` (post Lane E refactor)
- `RiemannRoch/RRFormula.lean` (gated)

## Unstarted-phase proposals

List each strategy phase with no chapter coverage and propose a one-paragraph
outline for it. These become writer directive seeds for iter-190 plan-phase.
