# Blueprint-reviewer directive — iter-016 (whole-blueprint audit + iter-016 gate)

Do your standard WHOLE-blueprint audit (per-chapter completeness + correctness checklist,
isolated/unmatched nodes, broken `\uses`, Lean-target well-formedness, unstarted-phase
proposals). The cross-chapter view is the point — review every chapter.

## This iter's writer rounds (pay extra attention; these gate prover dispatch)
Three chapters received writer + blueprint-clean rounds this iter and need a fresh
complete+correct verdict so the planner can dispatch (or defer) provers on them:

1. `Cohomology_FlatBaseChange.tex` — Seam 2 (`lem:base_change_mate_fstar_reindex`) and Seam 3
   (`lem:base_change_mate_gstar_transpose`) proof sketches were enriched with the conjugate-calculus
   mechanism that closed Seam 1 (`% RECIPE` comments + restructured prose). Confirm the Seam 2/3
   proofs now name a concrete, executable formalization mechanism (no longer under-specified).

2. `Picard_FlatteningStratification.tex` — a new helper block `lem:gf_away_tower_descent`
   (`\lean{...free_localizationAway_of_away_tower}`) was added and Step 4 of `lem:gf_polynomial_core`
   repointed to it (was wrongly citing L3b). Confirm the helper statement matches its intended
   role (iterated-`Away`-tower descent, witness `f := g·a` single power) and Step 4 is consistent.

3. `Picard_QuotScheme.tex` — MAJOR re-skeleton: the graded Hilbert–Serre rationality machinery was
   pivoted from the G1–G5 quotient-ring/quotient-module gradings (a hard Mathlib `isDefEq` dead end)
   to **Route 2: an ambient subquotient induction** (analogist `analogies/quot-hilbert-function-route.md`).
   The old G2/G3/G4 blocks + `quotSMulTop` anchor were removed; G1 was split into the two landed
   ambient halves; five new `AlgebraicGeometry.GradedModule.*` blocks were added (`def:graded_subquotientHilb`,
   `lem:graded_subquotient_ker_coker`, `lem:graded_subquotient_degreewise_diff`,
   `lem:graded_subquotient_finite_transfer`, `lem:graded_subquotient_isRatHilb`); the proof of
   `lem:gradedHilbertSerre_rational` was rewritten to instantiate the induction at `(⊤,⊥)`.
   Confirm: (a) the new blocks are complete (statement + informal proof + accurate `\uses{}`), (b) the
   Route 2 induction is correctly transcribed (ker/coker subquotient closure, the `(⊤,⊥)` bridge
   recovering `dim_κ Mₙ`, the degreewise difference via D5), (c) no dangling `\uses{}`/`\ref` points at
   a deleted G2/G3/G4 label, (d) the five new `\lean{}` pins are well-formed targets the prover can
   create. (Strategy-soundness of Route 2 is already confirmed by the strategy-critic + analogist;
   your job is blueprint completeness/correctness/coherence.)

## Output
Per-chapter `complete:` / `correct:` verdicts + any must-fix-this-iter findings, the
isolated/unmatched-node list, and unstarted-phase proposals. The planner will gate FBC + GF prover
dispatch on chapters 1–2 being complete+correct with no must-fix; chapter 3 (QUOT) clears the gate for
an iter-017 prover.
