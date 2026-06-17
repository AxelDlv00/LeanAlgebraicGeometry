# blueprint-reviewer — directive (slug: iter176-whole)

## Mode

Whole-blueprint audit (read every chapter under
`blueprint/src/chapters/`). Report per-chapter completeness + correctness
with the explicit `complete: true|false|partial`, `correct: true|false|partial`,
and `must-fix-this-iter: <items>` annotations.

## Special focus for iter-176

The iter-175 prover phase was DAMAGED by an external session-limit-reset
window at 06:14 UTC. 5 of the 10 file-skeleton prover lanes died in
1 turn with `summary: "You've hit your session limit · resets 7:30am
(UTC)"` and never created their files. Iter-176 will RE-DISPATCH those
5 lanes verbatim.

This means the chapters for these 5 missing Lean files are STILL the
gate for the iter-176 lanes:

| Blueprint chapter | Lean file (does NOT exist yet) |
|---|---|
| `Picard_FlatteningStratification.tex` | `AlgebraicJacobian/Picard/FlatteningStratification.lean` |
| `Picard_RelPicFunctor.tex` | `AlgebraicJacobian/Picard/RelPicFunctor.lean` |
| `Picard_QuotScheme.tex` | `AlgebraicJacobian/Picard/QuotScheme.lean` |
| `Picard_FGAPicRepresentability.tex` | `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` |
| `RiemannRoch_OCofP.tex` | `AlgebraicJacobian/RiemannRoch/OCofP.lean` |

The iter-175 `blueprint-reviewer iter175-whole` audit cleared all 5
chapters' HARD GATE. Confirm whether the gate still clears entering
iter-176, since no Lean changes happened on these chapters' content.

## Additional chapters that matter for iter-176

- `AbelianVarietyRigidity.tex` — gates `Genus0BaseObjects/GmScaling.lean`
  Lane A1. Audit whether iter-175 plan-phase writer changes (helper pins
  via `g0bo-helper-pins`) and analogist consult are reflected in the chapter.
- `Picard_RelativeSpec.tex` — gates Lane B re-dispatch.
- `RiemannRoch_WeilDivisor.tex` — gates Lane D re-dispatch.
- `Albanese_AuslanderBuchsbaum.tex` and
  `Albanese_Thm32RationalMapExtension.tex` — iter-175 file-skeleton
  lanes that succeeded; ready for body-lane downstream of A.4.a /
  A.4.c assembly.
- `Albanese_CodimOneExtension.tex`, `Albanese_AlbaneseUP.tex`,
  `RiemannRoch_RationalCurveIso.tex` — iter-176+ file-skeleton
  candidates (deferred per iter-175 plan).

## What I'm asking you for

1. Per-chapter checklist with `complete` / `correct` / `must-fix-this-iter`.
2. HARD GATE clearance for each chapter that backs an iter-176 prover lane.
3. Unstarted-phase blueprint proposals (any phase with no chapter coverage
   that should be filled iter-176).
4. Any chapter-prose changes needed (broken `\uses{}`, stale `\leanok`,
   strategy-modifying findings).

Report at `.archon/task_results/blueprint-reviewer-iter176-whole.md`.
