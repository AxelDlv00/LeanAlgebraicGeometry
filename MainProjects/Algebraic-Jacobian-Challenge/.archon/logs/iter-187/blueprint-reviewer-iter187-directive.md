# Blueprint Reviewer Directive

## Slug

iter187

## Iter

187

## Background

iter-186 plan-phase had a `loop.max_parallel=1` semaphore deadlock: a long
refactor (~33 min) monopolised the slot and 2 [HIGHLY RECOMMENDED] critics
(`progress-critic` + `blueprint-reviewer`) **never started**. iter-187 plan-phase
**must clear that audit debt** by re-dispatching both with priority.

Three chapter touches landed between your prior verdict (iter-185) and now and
have NOT been freshly audited:

1. `blueprint/src/chapters/Picard_IdentityComponent.tex` — iter-186 plan-phase
   `blueprint-writer identitycomponent-split` rewrite. Path B (chapter split)
   per iter-185 lean-vs-blueprint-checker MUST-FIX. The chapter grew 564→796
   LOC. Block 1 split into 4 per-conclusion blocks (a/b/c/d) + Block 2 into 3
   (1/2/3). 4 new `\lean{...}` pins (`isSubgroupHomomorphism`,
   `isFiniteTypeGeometricallyIrreducible`, `baseChangeIso`,
   `finrank_eq_genus`, `kPoints_iff_kerDegree` minus 2 KEEP pins). Audit
   especially: completeness against Kleiman §5 (lem:agps, prp:pic0, th:qpp&p,
   cor:sm, ex:jac) + Milne III.6; correctness of the new `\lean{...}` pins
   against `AlgebraicJacobian/Picard/IdentityComponent.lean`; the iter-186
   review's `% NOTE (iter-186 review)` annotations on
   `Picard_LineBundlePullback.tex` carrier-level invertibility drop are
   informational only (not in this chapter).

2. `blueprint/src/chapters/AbelianVarietyRigidity.tex` — iter-186 plan-phase
   `blueprint-writer gmscaling-chart-agreement-expansion` rewrite.
   `lem:gmscaling_chart_agreement` proof block rewritten with (I)/(II)/(III)/(IV)
   structure + 6 mini-blocks pinning previously-unpinned decls. Chapter delta
   ~+330 LOC. Audit: adequacy of the expansion against the chart-bridge
   cross-case Lean blocker (the iter-186 Lane B task_result reports
   "Mathlib simp coverage gap" empirically — verify the chapter's
   (III.a)/(III.b)/(III.c) paths reflect this); also audit whether the
   chapter now states clearly enough that (III.c) **separated-locus** is the
   iter-187 mandatory pivot per iter-185 STRATEGY.md failure-mode trigger.

3. `blueprint/src/chapters/Albanese_CodimOneExtension.tex` — iter-185
   plan-phase `blueprint-writer codimone-stacks-00tt` rewrite — landed Stacks
   00TT block + `lem:mem_domain_partial_map_reshuffle`. **NEVER AUDITED**
   (iter-185 reviewer never had a fresh-context opportunity due to
   semaphore-deadlock cascade from iter-186; iter-185 review only had the
   prior-iter checker reports surface 4 must-fix items). Audit: completeness
   against Stacks tag 00TT (read `references/stacks-algebra.tex` L38593-38611
   for the canonical TFAE block); correctness of the `% SOURCE QUOTE:`
   verbatim quote against the source file; the iter-186 plan-phase L209-219
   rewording (removed literal `\uses{}` token to defeat blueprint-doctor
   regex false-positive) — is the rewording semantically equivalent?

## Other lanes under iter-187 prover dispatch (HARD GATE per chapter)

Standard per-chapter audit for completeness + correctness for files in the
iter-187 prover plan:

- `Picard_QuotScheme.tex` — iter-186 plan-phase added a new `\subsection{Project-side base-change substrate}` with 4 new `\lean{...}` pins (`canonicalBaseChangeMap`, `_app_app_isIso`, `_isIso`, `Scheme.Modules.pullback_app_isoTensor`). iter-186 review's `iter185-quotscheme` checker had flagged a missing pin — was the addition correct? Also audit Step 4 (`pullback_app_isoTensor_baseMap_isBaseChange`) for chapter coverage if the lane is dispatched iter-187.
- `RiemannRoch_RRFormula.tex` — verify Hartshorne IV.1 3-piece decomposition (`eulerCharacteristic_shortExact_add` / `_iso` / `_skyscraperSheaf`) is reflected in proof block of `thm:euler_char_eq_deg_plus_one_minus_genus`. iter-186 added these 3 sub-helpers in Lean; the chapter may need `\lean{...}` pin updates.
- `RiemannRoch_RationalCurveIso.tex` — iter-186 Lane I CRITICAL FINDING: `Hom.poleDivisor` body must precede `Hom.poleDivisor_degree_eq_finrank`. Does the chapter's proof block for `lem:degree_via_pole_divisor` adequately specify the `Hom.poleDivisor` body construction (Finsupp on `φ⁻¹(∞)` OR Weil-divisor pullback route)?
- `Albanese_AuslanderBuchsbaum.tex` — iter-186 closed R⧸(x) bridge inline sorry. Chapter pins should now reflect: substrate-gap on `exists_isSMulRegular_quotient_isRegularLocal_succ` + `auslander_buchsbaum_formula`; Lane G iter-187 targets the former.
- `Picard_LineBundlePullback.tex` — iter-186 closed 5 sorries → 0 axiom-clean; iter-186 review landed 3 `% NOTE` annotations on `def:line_bundle_on_product`, `def:pullback_along_projection`, `thm:relative_pic_quotient_well_defined` documenting carrier-level invertibility drop. iter-187 plan opens a follow-up lane for `IsInvertible` predicate refinement — does the chapter need a new sub-section for the predicate, or is the `% NOTE` annotation sufficient pending iter-187 Lean work?
- `RiemannRoch_OCofP.tex` — iter-186 closed 3 `carrierSubmodule` closure sorries axiom-clean; refactor steps 3-5 deferred iter-187. Does the chapter cover the `presheaf` functor + `presheaf_isSheaf` Steps 3-4 in the proof block for `def:lineBundleAtClosedPoint`? iter-187 directive will instruct refactor on Steps 3+4+5.

## What I want back

Standard whole-blueprint audit + per-chapter checklist with:

- HARD GATE clearance status (complete + correct + no must-fix) for each
  `.lean` file the planner is considering for iter-187 prover dispatch
  (specifically: `OCofP.lean`, `LineBundlePullback.lean`, `QuotScheme.lean`,
  `RRFormula.lean`, `RationalCurveIso.lean`, `GmScaling.lean`,
  `AuslanderBuchsbaum.lean`, `AbelianVarietyRigidity.lean`,
  `IdentityComponent.lean`, possibly `CodimOneExtension.lean`).
- Must-fix-this-iter findings (chapter inadequate to guide formalisation).
- Unstarted-phase blueprint proposals (any new chapter needed for a
  strategy-listed phase with no coverage).
- Strategy-modifying findings if any (should escalate to STRATEGY.md edit).
