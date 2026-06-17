# Directive: blueprint-reviewer iter192

You are the iter-192 plan-phase blueprint reviewer. Read the WHOLE blueprint
under `blueprint/src/chapters/*.tex`. Your task is to produce a fresh,
chapter-by-chapter assessment (completeness + correctness), surface any
chapter blocking a live prover lane, and propose new chapters for unstarted
strategy phases.

## Project state context (signal only — not for editing)

- Current sorry count: 80; integration build GREEN; 11-consecutive-zero-
  axiom-build streak restored iter-191.
- New file landed iter-191: `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
  (8 declarations, 4 axiom-clean from skeleton dispatch, 3 typed-sorries
  remaining, 1 inherited-sorryAx chained closure).
- The user has issued a strong hint: push for AMBITIOUS progress —
  encourage `mathlib-build` mode and `fine-grained` mode; bottom-up
  mathlib infrastructure assembly preferred over top-down dependency
  tracing.

## Lanes that will receive prover lanes iter-192 (need HARD GATE clearance)

The plan agent intends to dispatch provers (≤10 files) on the following
candidates iter-192. For each, confirm chapter status (PASS / PARTIAL /
FAIL) and any HARD-GATE blocker:

1. `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` — chapter
   `RiemannRoch_H1Vanishing.tex` (already CONDITIONALLY CLEARED iter-191;
   verify the 3 remaining sorry decls
   `IsFlasque.constant_of_irreducible`, `HModule_flasque_eq_zero`,
   `skyscraperSheaf_eq_pushforward_const` are described with enough
   informal detail for a body close attempt this iter).
2. `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — chapter
   `RiemannRoch_WeilDivisor.tex` — verify the
   `degree_positivePart_principal_eq_finrank` (Hartshorne II.6.9) proof
   sketch is sufficiently detailed.
3. `AlgebraicJacobian/Albanese/CodimOneExtension.lean` — chapter
   `Albanese_CodimOneExtension.tex` — verify Stages 3-4 of Stacks 00TT
   chain (polynomial generators → regular sequence → regular local ring)
   has informal coverage; if not, propose a writer dispatch.
4. `AlgebraicJacobian/Picard/QuotScheme.lean` — chapter
   `Picard_QuotScheme.tex` — verify the iter-191 Lane F aliasing-let
   recipe is documented (or recommend `% NOTE:` addition).
5. `AlgebraicJacobian/Picard/IdentityComponent.lean` — chapter
   `Picard_IdentityComponent.tex` — verify the Lane A.3.i Stacks 04KU
   helper `geometricallyConnected_of_connected_of_section` has informal
   coverage in the chapter (or propose writer dispatch).
6. `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` — chapter
   `Albanese_AuslanderBuchsbaum.tex` — verify route (iii) (zero-divisor
   lift via Krull intersection) for closing
   `notMem_minimalPrimes_of_regularLocal_succ` is covered.
7. `AlgebraicJacobian/AbelianVarietyRigidity.lean` — chapter
   `AbelianVarietyRigidity.tex` — Lane E Part 2 close requires informal
   expansion on `Proj.appIso` evaluation step
   (`isLocElem ↦ [X_0/X_1] ↦ 1`). Propose writer expansion.
8. `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` — chapter
   AbelianVarietyRigidity.tex III.c — verify
   `gmScalingP1_chart_agreement_cross01` topological range containment
   is covered (closed-point + density).
9. `AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean` — needs
   refactor to avoid `set S := ...` Mathlib regression (source no longer
   compiles cleanly).
10. `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` — Pin 3 Step 2
    sub-tasks (a)/(c)/(d) — check chapter coverage.
11. `AlgebraicJacobian/RiemannRoch/RRFormula.lean` — close
    `H1_skyscraperSheaf_finrank_eq_zero` body via the H1Vanishing chain.

## Unstarted-phase blueprint proposals

Look for strategy phases that have NO blueprint coverage. STRATEGY.md
lists these candidates (your job is to propose chapter outlines):

- **A.3.iii–vi** `Pic0AbelianVariety` (HIGH priority — has been deferred
  multiple iters; proposed coverage: tangent iso `H¹(O_C) ≅ T_0 Pic⁰`;
  Pic⁰ smoothness; properness; geom-irreducible).
- **A.4.d** `Albanese_AlbaneseUP.tex` divisor-map rewrite (the iter-188
  S_g-quotient → divisor-map pivot is not reflected in the chapter).

## Required output format

Standard per-chapter checklist with HARD-GATE verdicts. Surface
must-fix-this-iter findings prominently at the top. End with
`## Unstarted-phase blueprint proposals` with concrete chapter outlines.

Report to `task_results/blueprint-reviewer-iter192.md`.
