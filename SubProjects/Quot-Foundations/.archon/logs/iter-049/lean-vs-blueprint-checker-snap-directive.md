# Lean ↔ Blueprint — SectionGradedRing (iter049)

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/SectionGradedRing.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_SectionGradedRing.tex

## Scope
New decl this iter: `sectionsMul` (def:sectionMul) — lax-monoidal global-section multiplication.
10 layer-1 helpers were marked `private` this iter. `tensorPowAdd` (lem:sheafTensorPow_add)
NOT added — blocked on the sheaf-level associator (Mathlib-absent: MonoidalClosed(PresheafOfModules)).

## Check
(a) Lean→blueprint: does `sectionsMul` match `def:sectionMul`'s `\lean{...}` + statement?
(b) blueprint→Lean: is `def:sectionMul` detailed enough? Does the chapter still reference the
now-`private` helpers as if public? Any prose-vs-Lean mismatch on `lem:sheafTensorPow_add`?
Report bidirectionally with must-fix tags.
