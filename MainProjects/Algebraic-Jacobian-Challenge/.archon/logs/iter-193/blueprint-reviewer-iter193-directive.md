# Blueprint reviewer directive — iter-193

You are dispatched for the iter-193 plan-phase whole-blueprint audit.

## Audit scope

Whole blueprint. Read every chapter under `blueprint/src/chapters/`. Per
chapter, render a `complete` + `correct` verdict + must-fix-this-iter
flags + concrete writer-directive seeds for any chapter that fails the
HARD GATE.

## Notable since prior dispatch (iter-192)

1. **NEW chapter** `Picard_Pic0AbelianVariety.tex` landed iter-192 plan-
   phase. It declares `% archon:covers AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`
   but that Lean file does not yet exist (blueprint-doctor iter-192
   finding still live). iter-193 plan-phase will dispatch a file-skeleton
   prover to materialise the Lean file. You should audit this chapter
   on its own merits (completeness + correctness against Kleiman §5 +
   Milne III §6); the missing Lean file is NOT a blueprint flaw.

2. **Lane I signature corrective** landed iter-193 plan-phase: the
   public theorem `degree_positivePart_principal_eq_finrank` in
   `WeilDivisor.lean` got an extra `hlp` hypothesis encoding the
   local-parameter constraint. The chapter prose at
   `lem:degree_positivePart_principal_eq_finrank` (in
   `RiemannRoch_WeilDivisor.tex`) currently carries a `% NOTE (iter-192
   review)` block flagging the signature gap; the plan agent will
   remove that block post-refactor (replacing with a one-paragraph
   "iter-193 fix landed" note). When you read this chapter, evaluate
   the prose as-it-will-stand AFTER the note removal — the
   mathematical content of the lemma (Hartshorne II.6.9 specialised
   at the divisor `D = [∞]`) is correct; the existential `hlp`
   hypothesis is the minimal Lean encoding the prover needs.

3. **iter-192 review** added a `% NOTE (iter-192 review)` to the
   above lemma. NO other manual blueprint markers were added.

## Per-chapter checklist format

For each chapter, return:

```
### chapters/<slug>.tex
- complete: <true | partial | false>
- correct: <true | partial | false>
- must-fix-this-iter: <list of items OR "none">
- writer-directive-seed: <one paragraph IF complete=partial/false OR
  correct=partial/false, naming what a blueprint-writer should fix>
```

## Project HARD GATE — give a per-file verdict on the iter-193 prover lanes

The planner is proposing the following 10 Lean files for prover dispatch.
For EACH, name the corresponding blueprint chapter (1:1 slug OR consolidated
via `% archon:covers`), and state whether the HARD GATE (chapter complete
+ correct + no must-fix) passes.

1. `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` →
   chapters/RiemannRoch_WeilDivisor.tex
2. `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` →
   chapters/RiemannRoch_RationalCurveIso.tex
3. `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` →
   chapters/RiemannRoch_H1Vanishing.tex
4. `AlgebraicJacobian/Albanese/CodimOneExtension.lean` →
   chapters/Albanese_CodimOneExtension.tex
5. `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` →
   chapters/Albanese_AuslanderBuchsbaum.tex
6. `AlgebraicJacobian/Picard/IdentityComponent.lean` →
   chapters/Picard_IdentityComponent.tex
7. `AlgebraicJacobian/Picard/QuotScheme.lean` →
   chapters/Picard_QuotScheme.tex
8. `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` (NEW file) →
   chapters/Picard_Pic0AbelianVariety.tex
9. `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` →
   chapters/AbelianVarietyRigidity.tex (via consolidated `% archon:covers`)
   — note: `AbelianVarietyRigidity.tex` covers both GmScaling and AVR
   chart-bridge material.
10. `AlgebraicJacobian/AbelianVarietyRigidity.lean` → same as #9.

For chapters where the HARD GATE fails, name (a) the writer directive seed
and (b) whether the same-iter fast path is recommended (rewrite + scoped
re-review this iter) or whether dropping the file from objectives is
preferred.

## Unstarted phases (STRATEGY.md)

Per STRATEGY.md `## Phases & estimations`, identify any phase row whose
chapter is missing. Propose a chapter outline (3-6 bullets, no Lean code)
for each so the planner can dispatch a blueprint-writer this iter.

The STRATEGY.md phase rows are:

- A.1.a `RelativeSpec` (chapter `Picard_RelativeSpec.tex`)
- A.1.b `LineBundlePullback` (DONE iter-188 — chapter `Picard_LineBundlePullback.tex`)
- A.1.c `RelPic functor` (chapter `Picard_RelPicFunctor.tex`)
- A.2.a flattening stratification (chapter `Picard_FlatteningStratification.tex`)
- A.2.b Quot + Grassmannian (chapter `Picard_QuotScheme.tex`)
- A.2.c FGA `Pic_{C/k}` (chapter `Picard_FGAPicRepresentability.tex`)
- A.3.0 scheme-level tangent space (chapter — check existence)
- A.3.i `GroupScheme.IdentityComponent` (chapter `Picard_IdentityComponent.tex`)
- A.3.ii–vii Pic⁰ assembly (chapter `Picard_Pic0AbelianVariety.tex` NEW iter-192)
- A.4.a Lemma 3.3 codim-1 + Weil-divisor (chapter `Albanese_CodimOneExtension.tex`
  + `RiemannRoch_WeilDivisor.tex`)
- A.4.b Auslander-Buchsbaum (chapter `Albanese_AuslanderBuchsbaum.tex`)
- A.4.c Thm 3.2 (chapter `Albanese_Thm32RationalMapExtension.tex`)
- A.4.d divisor-map Albanese UP (chapter — check existence; standing
  deferral iter-200+)
- A.4.d.0 Pic^d component (chapter — check existence)
- Lane M↓ (chapter `Albanese_CodimOneExtension.tex` consolidated)
- Genus-0 rigidity arm: `AbelianVarietyRigidity.tex`, `RiemannRoch_*.tex`
- `genusZeroWitness` body
- `nonempty_jacobianWitness` body

## Output

Per-chapter checklist as above + an `## Unstarted-phase blueprint
proposals` section if any strategy phase has no chapter.
