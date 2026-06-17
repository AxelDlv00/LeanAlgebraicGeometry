# Blueprint Writer Directive

## Slug
ssmk-typo

## Chapter to update
`blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`

## Problem

`blueprint-reviewer-iter106` flagged exactly one must-fix-this-iter item across the whole blueprint: a single-token typo at `Cohomology_StructureSheafModuleK.tex:474` inside the proof block of `\thm:Scheme_module_finite_globalSections_of_isProper`.

The current text reads:
```
\uses{thm:Scheme_toModuleKSheaf, ...}
```

There is no `\label{thm:Scheme_toModuleKSheaf}` in the project. The only matching label is `\label{def:Scheme_toModuleKSheaf}` declared at L144 of the same chapter file. The intended cross-reference is to the definition, so the prefix `thm:` is a typo and should be `def:`.

## Required change

- Read L470-480 of `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` to identify the exact location of the `\uses{thm:Scheme_toModuleKSheaf, ...}` site.
- Replace `thm:Scheme_toModuleKSheaf` with `def:Scheme_toModuleKSheaf` (only that single token; preserve all other `\uses{...}` arguments verbatim).
- Save the file.

## Verification

After the edit, the broken cross-reference should be resolved:
- `grep -n 'thm:Scheme_toModuleKSheaf' blueprint/src/chapters/` should return no hits.
- `grep -n 'def:Scheme_toModuleKSheaf' blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` should show the original definition site (L144) plus the corrected `\uses` site.

## Out of scope (DO NOT DO)

- DO NOT touch any other chapter file.
- DO NOT make other edits in `Cohomology_StructureSheafModuleK.tex` beyond the one-token fix.
- DO NOT touch any `.lean` file.
- DO NOT improvise additional cross-reference corrections — the blueprint-reviewer's full audit found exactly one broken `\uses` and exactly one must-fix-this-iter item; both are this typo.

## Reference background

The label `\label{def:Scheme_toModuleKSheaf}` is at L144 of the same chapter, defining `def:Scheme_toModuleKSheaf` and corresponding to the Lean declaration `AlgebraicGeometry.Scheme.toModuleKSheaf` in `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`. The `\thm:Scheme_module_finite_globalSections_of_isProper` proof block at L470+ legitimately uses this definition — only the prefix is wrong.

