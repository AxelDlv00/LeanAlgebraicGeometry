# Blueprint-reviewer directive — slug `tosheaf-rereview` (fast-path, scoped)

Scoped re-review of ONE chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.
This is the same-iter fast-path after a writer fix. Assess ONLY the Gate-1 toSheaf chain that you
flagged in `blueprint-reviewer-iter033` as must-fix:

- **`lem:toSheaf_preservesFiniteColimits`** (~L3508) — the writer (`tosheaf-fix`) just rewrote Step 2
  as a three-clause descent (counit-iso → `toSheaf R` is a retract of the colimit-preserving
  composite → retract preserves finite colimits) in unified notation, and added
  `\uses{lem:mod_pmod_adjunction}` to the statement and proof blocks.
- **`lem:to_sheaf_preserves_epi`**, **`lem:affine_surj_of_vanishing`**, **`def:affine_cover_system`**
  — you already found these clean (conditional on the above). Just confirm they remain clean.

Return: does Gate 1 (`AffineSerreVanishing.lean`) now CLEAR — i.e. is
`lem:toSheaf_preservesFiniteColimits` now `complete: true` + `correct: true` with no must-fix, and
the rest of the chain clean? If yes, the prover lane on `AffineSerreVanishing.lean` is cleared to
dispatch this iter. If a must-fix remains, name it precisely.
