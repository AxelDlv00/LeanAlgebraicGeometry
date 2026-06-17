# Blueprint Clean Directive — Picard_TensorObjSubstrate.tex

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (just rewritten this
iter by blueprint-writer for the flat/line-bundle pivot — the relative
Picard group law moved off the all-modules `MonoidalCategory`/`MonoidalClosed`
route onto four existence-of-iso lemmas on line bundles + a flat-scoped
`tensorObj_restrict_iso`).

## What to enforce
1. **Strip genuine Lean-tactic / project-history leakage**: any `:= sorry`,
   tactic strings, `inferInstanceAs`, iter-NNN references, "our failed
   route" narrative, "contamination guard" phrasing, or commentary about
   what the deterministic markers do. Make the prose read as timeless
   mathematics.
2. **PRESERVE the Mathlib-idiom-alignment references** as load-bearing
   formalization guidance — this chapter's "Mathlib API survey" /
   "concrete realisation" style legitimately names the formalization
   target API. Keep: `CommRing.Pic`, `Module.Invertible`,
   `Module.Flat.lTensor_preserves_injective_linearMap`,
   `Module.Invertible.lTensor_bijective_iff`, `Units (Skeleton …)`,
   `QuotientAddGroup`, `PresheafOfModules.Monoidal.tensorObj`, and the
   Stacks/Kleiman citations. These guide the prover and match the chapter's
   existing API-survey convention; do NOT strip them as "implementation
   detail."
3. **Citation discipline**: verify the preserved Kleiman §2 (df:aPf,
   df:Pfs) `% SOURCE:` / `% SOURCE QUOTE:` blocks are intact and verbatim.
   No new external math source was added (the new content is
   Mathlib-API-grounded, not textbook-derived), so no new `% SOURCE QUOTE`
   is required for the four iso lemmas. Stacks 01CR is already cited for the
   Picard-group fact. If you judge a NEW external math source IS needed and
   it is missing from `references/`, spawn a reference-retriever.
4. **Fix LaTeX**: `\uses{}` / `\label{}` / `\cref{}` correctness; the
   writer demoted `thm:scheme_modules_monoidal` to
   `rem:scheme_modules_monoidal_off_path` and removed its `\lean` pin —
   verify no dangling `\cref{thm:scheme_modules_monoidal}` remains.

## Do NOT
- Touch `\leanok` / `\mathlibok` markers.
- Touch any other chapter.
