# Blueprint rendering cleanup — Rigidity.tex (iter-279)

## Scope
ONE chapter: `blueprint/src/chapters/Rigidity.tex`. Defect class: `literal-ref` (2).

## Edits

1. **Line 58 — `literal-ref` → `\cref`** (resolved by `\cref`, live target exists)
   - Before: `Used in the uniqueness half of Theorem~REF (the Albanese property of \(\Jac(C)\)):`
   - After: `Used in the uniqueness half of \cref{thm:albanese_universal_property} (the Albanese property of \(\Jac(C)\)):`

2. **Line 61 — `literal-ref` → `\cref`** (resolved by `\cref`, live target exists)
   - Before: `Note: the existence half of REF requires Phase~B/C infrastructure`
   - After: `Note: the existence half of \cref{thm:albanese_universal_property} requires Phase~B/C infrastructure`

Both `REF` tokens referred to the same Albanese universal-property theorem, identified
from the surrounding prose ("the Albanese property of \(\Jac(C)\)"). Target label
`thm:albanese_universal_property` (Milne III §6 Prop 6.1), present in the Albanese cluster
(`Albanese_AlbaneseUP.tex:99`, also Jacobian.tex:552). No rewording was needed; the target
is live, so neither defect was resolved by excision.

## Verification
- `grep REF blueprint/src/chapters/Rigidity.tex` → none.
- `\label{thm:albanese_universal_property}` confirmed present in the blueprint.
- Both `Rigidity.tex` and `Albanese_AlbaneseUP.tex` are `\input` in `content.tex`.
- No math-delim/bare-label/undefined-macro defects in this chapter.
- Changed NO statement text, NO `\lean{}`, NO `\label{}`, NO `\uses{}`, NO `\leanok`;
  added/removed no blocks. Only prose cross-references in `\section{Use in the project}`.

## Note (non-blocking, out of scope)
`thm:albanese_universal_property` is defined in two chapters (Jacobian.tex:552 and
Albanese_AlbaneseUP.tex:99) — a pre-existing duplicate-label condition owned by the
mathematician, not introduced here. The `\cref` resolves regardless; flagging for awareness.

## Unresolved defects
None.
