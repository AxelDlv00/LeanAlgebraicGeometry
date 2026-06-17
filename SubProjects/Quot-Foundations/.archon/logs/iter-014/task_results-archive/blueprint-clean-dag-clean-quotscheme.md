# Blueprint Clean Report — dag-clean-quotscheme
**Chapter:** `blueprint/src/chapters/Picard_QuotScheme.tex`
**Iteration:** 013

## Status: CLEAN — all issues resolved

## Changes made

### 1. Removed `% LEAN SIGNATURE` block from `lem:gradedHilbertSerre_rational`
Full Lean type signature (~24 comment lines) with typeclass syntax, universe variables, and raw Lean expressions was removed entirely. The SOURCE QUOTE and `\textit{Source:}` prose now flow cleanly.

### 2. Removed `% LEAN SIGNATURE` block from `lem:qcoh_section_localization_basicOpen`
Full Lean type signature (~16 comment lines) including `SheafOfModules.IsQuasicoherent`, `IsLocalizedModule`, `Submonoid.powers`, `presheaf.map`, `homOfLE`, raw scalar-tower expressions. Removed entirely.

### 3. Cleaned `% NOTE (iter-007)` in `def:sectionGradedRing`
Removed: iteration reference "iter-007", Lean typeclass names `MonoidalCategoryStruct`, `SheafOfModules`, `PresheafOfModules`, "(synthesis fails)", "See task_results...". Replaced with a clean mathematical statement of the blocking gap (tensor products of sheaves of modules absent from Mathlib).

### 4. Cleaned `% NOTE (iter-012)` in `lem:gradedHilbertSerre_rational`
Removed: iteration reference "iter-012", Lean identifiers `rationalHilbert_antidiff`, `IsRatHilb.ofDiffEq`, `DirectSum.Decomposition`, `SetLike.GradedSMul`, `GradedModule`, backtick-escaped Lean syntax. Replaced with a clean note naming the mathematical obstacle (no graded-module quotient M/xM, graded kernel, regrading with finite-module transfer in Mathlib).

### 5. Cleaned `% NOTE (iter-011)` in `def:modules_annihilator`
Removed: iteration reference "iter-011", Lean identifiers `ofIdeals`, `Scheme.Modules.annihilator_ideal_le`, "landed lemma". Replaced with a clean note referencing the blueprint labels (`\cref{lem:modules_annihilator_ideal_le}`, `\cref{lem:qcoh_section_localization_basicOpen}`).

### 6. Stripped `ofIdeals` from `lem:modules_annihilator_ideal_le` prose
"always-available (\(\mathrm{ofIdeals}\)) inclusion direction" and "from the defining \(\mathrm{ofIdeals}\) bound" → "inclusion direction available directly from the definition" and "Proved directly in Lean."

### 7. Cleaned `% NOTE` block in `thm:grassmannian_representable`
Removed: iteration reference "iter-012", Lean-tool tag "lean-vs-blueprint-checker", raw Lean expression `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`, "iter-177+ refinement work", "See task_results/lean-vs-blueprint-checker-quot-iter012.md". Preserved mathematical content: proof is blocked on `\cref{thm:relative_spec_univ}` being weaker than a full RepresentableBy witness; Lean statement is a weakened skeleton missing smoothness/properness/relative-dimension/tautological-quotient/Plücker content.

### 8. Removed "project-built primitive" / "project-side" language from prose
- `def:modules_annihilator` \textit{Source:} annotation: removed "the construction is a project-built primitive"
- `def:modules_annihilator` \emph{Note}: "This is a project-built primitive; Mathlib does not carry..." → "Mathlib does not carry..."
- `def:is_locally_free_of_rank` \emph{Note}: "This predicate is project-built; it is not supplied by Mathlib." → "Mathlib does not provide this predicate."
- Out-of-scope section: "project-side substrate" → "associated prerequisites"; "project-side sub-build for the Lean encoding" → "Lean formalization is a prerequisite sub-task"
- `lem:gradedHilbertSerre_rational` \emph{Status}: "project-side obligation" → "not covered by Mathlib"

## LaTeX / refs audit
- **`\label{}`**: all labels are non-empty and well-formed; no duplicates visible.
- **`\lean{}`**: all `\lean{}` annotations are non-empty and reference qualified Lean identifiers. The note in `thm:grassmannian_representable` flags that the pinned Lean declaration under-delivers the prose (an action item for the prover, not a LaTeX error).
- **`\uses{}`**: all multi-line `\uses{...}` arguments are properly closed. No empty `\uses{}`.
- **Literal REF tokens**: none found.
- **Interleaved math delimiters**: none found.
- **Macros**: all macros used in prose (`\Quot`, `\Hilb`, `\Spec`, `\PP`, `\AA`, `\Q`, `\Z`, `\llbracket`, `\rrbracket`, `\cref`) are defined in `blueprint/src/macros/common.tex`. No undefined macros detected.

## Citation audit
- All pre-existing externally-sourced blocks retain their `% SOURCE QUOTE:` comments.
- No new external citations added (new helpers are project-internal; no `% SOURCE QUOTE:` required per directive).
- No missing quotes detected for pre-existing blocks referencing `references/` entries.

## Out of scope (confirmed untouched)
- Mathematical statements of all theorems/definitions: unchanged.
- `\leanok` markers: not added or removed.
- Other chapters: not touched.
