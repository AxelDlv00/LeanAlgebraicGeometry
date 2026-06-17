# Rendering cleanup — AlgebraicJacobian_Cotangent_GrpObj.tex

Chapter: `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`
Defects flagged: 1 `literal-ref` + 2 `undefined-macro`. All resolved.

## Edits

1. **`literal-ref`** (line ~6) — `chapter~REF (\texttt{RigidityKbar.tex} ...)`
   → `\cref{chap:RigidityKbar} (\texttt{RigidityKbar.tex} ...)`.
   Resolved by `\cref` (NOT reworded): the target label `\label{chap:RigidityKbar}`
   exists at `RigidityKbar.tex:2`. The intended target was unambiguous from the
   surrounding sentence ("lives in ... RigidityKbar.tex") and matches the already-present
   `\cref{chap:RigidityKbar}` uses elsewhere in this same chapter (lines 35, 92, 160).

2. **`undefined-macro` `\obj`** (line ~151, in `R.\obj\,X` inside the
   `lem:isIso_of_app_iso_module` statement block) — added chapter-local
   `\providecommand{\obj}{\mathrm{obj}}` near the top (line 4).

3. **`undefined-macro` `\toUnit`** (line ~130, in `\toUnit_{G}` inside the
   `lem:section_snd_eq_identity_struct` statement block) — added chapter-local
   `\providecommand{\toUnit}{\mathrm{toUnit}}` near the top (line 5).

## Why `\providecommand` instead of the directive's preferred rewrite

Both `\obj` and `\toUnit` occur INSIDE protected `\begin{lemma}...` STATEMENT blocks
(`\obj`: lines 145–154; `\toUnit`: lines 126–140), not in proof/prose. The HARD
CONSTRAINT forbids altering statement text, and the directive explicitly says to
"choose whichever keeps the statement text UNCHANGED if these macros appear inside a
protected statement block". So the `\providecommand` route was mandatory here; the
statement text is byte-for-byte unchanged.

## Verification
- `grep REF` over the chapter → zero matches (exit 1).
- No `$ ... \(` interleaving present (no `math-delim` defects in this chapter).
- `\cref{chap:RigidityKbar}` names a label that exists (`RigidityKbar.tex:2`).
- No `\lean{}`, `\label{}`, `\uses{}`, `\leanok`, or statement/proof mathematics changed;
  no declaration blocks added/removed/reordered. Only the two `\providecommand` lines
  added and the one literal-ref token replaced.

## Unresolved
None.
