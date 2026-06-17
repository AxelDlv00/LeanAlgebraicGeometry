# Directive: verify CechBridge.lean against its blueprint chapter

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechBridge.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(this is a consolidated chapter; it declares `% archon:covers` for several files
including CechBridge.lean).

## Focus
This iter added one theorem to CechBridge.lean:
`AlgebraicGeometry.injective_cech_acyclic` (blueprint `lem:injective_cech_acyclic`,
line ~2579). It is the positive-degree Čech-vanishing for injective sheaves
(`IsZero (sectionCechComplex ... ).homology p` for `0 < p`).

Report bidirectionally:
1. **Lean → blueprint**: is `injective_cech_acyclic` a faithful, non-placeholder
   realization of `lem:injective_cech_acyclic`? Does the Lean signature match the
   informal statement (note: the chosen Lean form covers ONLY the `p>0` vanishing
   half; the `Ȟ⁰ = I(U)` clause of the Stacks statement is deliberately not in this
   declaration — confirm that is an acceptable, clearly-scoped split, not a faked
   statement). Also check the two existing CechBridge targets `ses_cech_h1`
   (`lem:ses_cech_h1`) and the `sectionCech_*` H¹ heart are still faithfully
   blueprinted.
2. **Blueprint → Lean**: is the chapter detailed enough to have guided this proof,
   and are the `\lean{...}` pins on `lem:injective_cech_acyclic`,
   `lem:ses_cech_h1` correct (matching real declaration names)?

Flag any must-fix-this-iter findings. Keep scope to this one file vs this chapter.
