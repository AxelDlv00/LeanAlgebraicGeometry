# Lean ↔ Blueprint Checker Directive

## Slug
jacobian-iter155

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Jacobian.tex

## Known issues
- `genusZeroWitness` was rewritten this iter from a bare `sorry` into the
  blueprint's terminal-object (`J := 𝟙_`) skeleton (Jacobian.tex § C.3 / C.2).
  6 of 7 structure fields close; the uniqueness clause closes via real lemmas
  (`Over.toUnit_left`, `Flat.epi_of_flat_of_surjective`, `Over.epi_of_epi_left`,
  `cancel_epi`); the single residual `sorry` is the `key : f = toUnit C ≫ η[A]`
  rigidity equation (downstream of `rigidity_over_kbar` + k̄→k descent + char-p).
  Verify the skeleton faithfully realizes the blueprint's C.3 construction and the
  C.2 uniqueness-via-epi step, and that the residual gap is exactly the C.2.f
  rigidity/descent content the chapter describes (not a broader/laundered gap).
- `positiveGenusWitness` is a known bare `sorry` (Route A Albanese variety, no
  Mathlib construction) — do not re-flag its existence; only report if its
  blueprint mapping or comments are wrong.
- Do NOT report on `\leanok` markers (managed deterministically).
