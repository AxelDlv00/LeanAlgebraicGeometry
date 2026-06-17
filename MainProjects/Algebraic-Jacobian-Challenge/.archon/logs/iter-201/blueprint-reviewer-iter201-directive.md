# blueprint-reviewer directive — slug `iter201`

## Scope

Whole-blueprint audit per descriptor (read every chapter under
`blueprint/src/chapters/`). Per-chapter checklist + must-fix-this-iter
findings + unstarted-phase blueprint proposals.

## Iter context

iter-201 plan agent made the following blueprint edits:

1. **`RiemannRoch_WeilDivisor.tex`**:
   - L99-104 stale "Iter-173+ may introduce" prose fixed to a
     confirmed-and-pinned statement referencing
     `\ref{def:isRegularInCodimensionOne}`.
   - Inserted new `\begin{definition} … [Regular in codimension one]
     \label{def:isRegularInCodimensionOne}
     \lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne}` block
     between §"Codim-1 cycle group" (`def:codim1_cycles`) and the new
     section.
   - Inserted new `\section{Open-immersion descent for prime divisors}
     \label{sec:open_immersion_descent}` after §"Codim-1 cycle group"
     and before §"Order of a rational function at a prime divisor".
     The new section pins 5 iter-200 axiom-clean substrate decls:
     `def:primeDivisor_restrictToOpen`,
     `def:primeDivisor_ofOpen`, `lem:primeDivisor_equivOpen`,
     `lem:primeDivisor_stalkIso`, and
     `thm:isRegularInCodimensionOne_open` (the descent instance).

2. **`Albanese_AuslanderBuchsbaum.tex`**:
   - Per-gap effort table gap (3) row reclassified to **OBVIATED
     iter-200** per the ALIGN_WITH_MATHLIB pivot.
   - Closure-assembly paragraph rewritten to describe the SES-descent
     recipe consuming the 4 iter-200 helpers (~50-80 LOC closure cost).
   - New `\paragraph{Gap (3) OBVIATED iter-200.}` + `\paragraph{Gap (2)
     Stacks 00MF proof recipe.}` explaining the binding gap and
     Buchsbaum-Eisenbud criterion recipe.
   - New `\subsec:ab_gap1_haspdlt_pivot` (label
     `subsec:ab_gap1_haspdlt_pivot`) with 4 standalone lemma blocks
     pinning the iter-200 helpers:
     `lem:hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`,
     `lem:hasProjectiveDimensionLT_ker_of_surjection`,
     `lem:hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`,
     `lem:depth_ker_ge_min_of_surjection_finite_localRing`.
   - NOTE on `lem:auslander_buchsbaum_formula_succ_pd` private/public
     mismatch updated to commit option (1): remove `private` from the
     Lean declaration (the iter-201 Lane AB prover or a refactor agent
     post-closure handles this).

3. **`Albanese_CodimOneExtension.tex`**:
   - `lem:smooth_algebra_krull_dim_formula` (Stage 6.A) "Mathlib API
     state" itemization updated: replaced the stale "NEEDS-BRIDGE;
     ~200-300 LOC" line with the iter-200 actual state
     (Steps 1+2 axiom-clean inline; Step 3 = Jacobian-witness
     residual ~30-60 LOC).
   - New `\subsec:stage6_iib_substrate_iter200` (label
     `subsec:stage6_iib_substrate_iter200`) enumerating the 7
     iter-200 axiom-clean `private` substrate decls per their
     role (Step 1 / Step 2 LB / Step 2 UB / Step 2 Fin n / Step 2
     general / capstone / Step 3 additive form). NOTE: NO inline
     `\lean{...}` pins on the 7 decls (avoiding sync_leanok
     private-name resolution). The Jacobian-witness recipe paragraph
     gives the iter-201+ closure path (Stacks 00SW/00OW).

## What you check

Per descriptor:

1. Per-chapter completeness + correctness verdict.
2. Whether each chapter's `\lean{...}` pins resolve.
3. Whether each chapter's `\uses{...}` references resolve.
4. Whether the proof sketches are detailed enough for an iter-201+
   prover to formalize.
5. Whether any chapter still has unstarted-phase blueprint proposals
   that the plan agent must dispatch a writer for.
6. The iter-200 per-file checkers flagged (WD-iter200, AB-iter200,
   COE-iter200) — most findings should be addressed by the iter-201
   plan agent's edits above; verify that the chapters now match
   the iter-200 Lean code.

## HARD GATE candidates

The iter-201 PROGRESS.md will list 3 prover-touched files:
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — chapter
  `RiemannRoch_WeilDivisor.tex` MUST be `complete + correct` for
  Lane WD-A4a-Sub-build-2 dispatch.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` — chapter
  `Albanese_AuslanderBuchsbaum.tex` MUST be `complete + correct` for
  Lane AB-Stacks-00MF dispatch.
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean` — chapter
  `Albanese_CodimOneExtension.tex` MUST be `complete + correct` for
  Lane COE-Stage6.B-Jacobian dispatch.

Return verdicts on these 3 explicitly.

## Output format

Per descriptor: per-chapter checklist + must-fix-this-iter findings +
unstarted-phase blueprint proposals + recommendation on the HARD GATE
candidates.
