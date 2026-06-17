# Rendering-cleanup directive (NON-SEMANTIC)

## Scope: ONE chapter only — rendering/reference defects flagged by the blueprint-doctor

This is a **rendering-quality cleanup** pass. `leandag` already builds clean for this
chapter (`broken_refs: 0`, `unknown_uses: 0`); the defects below only degrade the
`leanblueprint web` rendered output. Your job is to make the chapter render correctly.

### HARD CONSTRAINTS — do NOT change any of:
- any `\begin{definition|lemma|theorem|...}` STATEMENT text (the mathematical content),
- any `\begin{proof}` body's mathematical content (you may only repair broken delimiters /
  references WITHIN prose, never alter the mathematics),
- any `\lean{...}` annotation, `\label{...}`, or the SEMANTICS of any `\uses{...}` list,
- do NOT add or remove `\leanok` (forbidden — owned by the deterministic sync phase),
- do NOT add `\mathlibok` (none required here),
- do NOT add, delete, or reorder declaration blocks.

You are ONLY allowed to repair the four rendering-defect classes below, in prose/proof text.

### Defect classes and the required fix:
1. **`literal-ref`** — a literal placeholder token like `Theorem~REF`, `Section~REF`,
   `Lemma~REF`, `Definition~REF`, `Remark~REF`, `Chapter~REF`, `\S~REF`. Replace each with a
   proper `\cref{<label>}` pointing at the INTENDED target. Identify the target from the
   surrounding sentence and the block's `\uses{...}` list. If the referenced section/block
   was excised (no live target exists in the blueprint — common in historical-note prose),
   REWORD the sentence to remove the dangling cross-reference (e.g. "documented separately
   below", "the converse section") rather than inventing a `\cref` to a non-existent label.
   NEVER emit a `\cref{}` to a label that does not exist somewhere in the blueprint.
2. **`math-delim`** — interleaved/unbalanced math delimiters, e.g. `$ ... \( ... \) ... $`
   where `$...$` and `\(...\)` are nested or swapped. Pick ONE delimiter style per formula —
   use `\( ... \)` — and never switch inside a formula. A common pattern here is an INVERTED
   block `$MATH1\( text1 \)MATH2\( text2 \)MATH3$` whose correct form is
   `\(MATH1\) text1 \(MATH2\) text2 \(MATH3\)` (math in `\(...\)`, prose outside). Preserve
   the mathematical content exactly; only fix the delimiters.
3. **`bare-label`** — a raw label id in prose (e.g. "Lemma~lem:foo" or just "lem:foo").
   Replace with `\cref{lem:foo}` (for a project-internal label) or, for an EXTERNAL paper's
   internal label, the source's human-readable number (e.g. "Lemma 5.1").
4. **`undefined-macro`** — a macro used but defined nowhere. Either add a chapter-local
   `\providecommand{\foo}{...}` near the top of the chapter, or rewrite the prose to avoid
   the macro. Prefer rewriting Lean-ish notation into plain math.

### Verification before returning:
- Re-grep your chapter for `REF` (the literal placeholder) — zero should remain.
- Re-grep for `$` followed later on the same logical formula by `\(` — none should remain.
- Confirm every `\cref{...}` you introduced names a label that exists in the blueprint.
- Confirm you changed NO statement text, NO `\lean{}`, NO `\label{}`, NO `\uses{}` semantics.

### Report:
List each edit (line, defect class, before→after summary). Note any `literal-ref` you
resolved by REWORDING (target was excised) vs. by `\cref`. Flag any defect you could NOT
resolve and why.

## This chapter: blueprint/src/chapters/Cohomology_StructureSheafAb.tex
Defects: 7 `literal-ref` (`Chapter~REF`, `Theorem~REF`). The `Chapter~REF` tokens refer to
the sheaf-compose chapter (`Cohomology_SheafCompose.tex`); replace with `\cref` to that
chapter's top-level `\label` (look it up — it is the chapter introducing the sheaf-compose
instance) or its sheaf-compose-instance definition label. Resolve `Theorem~REF` from the
surrounding sentence + the block `\uses{}`.
