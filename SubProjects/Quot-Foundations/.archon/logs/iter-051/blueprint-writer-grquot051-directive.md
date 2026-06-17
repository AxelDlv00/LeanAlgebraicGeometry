Target: blueprint/src/chapters/Picard_GrassmannianQuot.tex
Action: three edits — (1) add `Epi chartQuotientMap` lemma block, (2) add the two infra helper blocks, (3) tighten the `glue` block with cocycle conditions. Read the chapter + the Lean file `AlgebraicJacobian/Picard/GrassmannianQuot.lean` and `AlgebraicJacobian/Picard/GrassmannianCells.lean` (for `universalMatrix`, `universalMatrix_submatrix_self` ~L150) for exact names.

## Edit 1 — `Epi chartQuotientMap` (NEW; feeds tautologicalQuotient surjectivity)
Add a lemma block in `sec:grquot_chart` AFTER `def:gr_chart_quotient` (~line 155). Label `\label{lem:gr_chartQuotientMap_epi}`, `\lean{...}` pointing at the name the prover will create (use `AlgebraicGeometry.Grassmannian.chartQuotientMap_epi` — tell the prover this is the target name). `\uses{def:gr_chart_quotient}`.
Statement: `chartQuotientMap d r I hI` is an epimorphism of sheaves.
Informal proof (split epi): with the inclusion `inclFn : Fin d → Fin r`, `j ↦ I.orderIsoOfFin hI j`, the composite `freeMap inclFn ≫ chartQuotientMap = 𝟙 (free (Fin d))`, so `chartQuotientMap` is a split epi (hence epi). The split equation reduces to the minor identity: the `I`-indexed minor of the universal matrix `X^I` is the identity (`universalMatrix_submatrix_self`, GrassmannianCells.lean:150), i.e. `universalMatrix p (inclFn k) = if p = k then 1 else 0`. Component-wise via the coproduct universal property of `free (Fin d)` (`Cofan.IsColimit.hom_ext`), using the biproduct ↔ coproduct bridge and `biproduct.ι_matrix`/`biproduct.matrix_π`. Project-bespoke (Nitsure §5 big-cell chart); no external verbatim quote required.

## Edit 2 — infra helper blocks (coverage debt; 2 unmatched Lean decls)
In `sec:grquot_chart`, add a short "Infrastructure: scalar endomorphisms" remark with two concise blocks (project-bespoke):
- `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}` — a global section `a ∈ Γ(X,⊤)` yields a section of the unit sheaf `SheafOfModules.unit` (via `PresheafOfModules.sectionsMk`).
- `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}` — a scalar endomorphism `O_X → O_X` from a global section (via `unitHomEquiv`).
Expand the `def:gr_chart_quotient` construction note: the matrix-entry → morphism realisation goes through `scalarEnd` of the `ΓSpecIso`-image of `universalMatrix` entries, assembled by `biproduct.matrix` (Mathlib has no matrix↦morphism-of-free-sheaves primitive). `\uses{def:gr_chart_quotient}` these from the helpers as appropriate.

## Edit 3 — `glue` cocycle conditions (auditor + lvb-checker must-fix, blueprint side)
In `def:scheme_modules_glue` (~line 47), make explicit that the transition data `g` must satisfy the module cocycle conditions as HYPOTHESES: self-identity `g_{ii} = id` and triple-overlap multiplicativity `g_{jk} ∘ g_{ij} = g_{ik}` (transported through the scheme-level `Scheme.GlueData` cocycle `D.t`/`D.f`). State these as the conditions "subject to which" the gluing is well-defined and characterised up to unique isomorphism. The Lean signature currently records only the per-overlap isos (`_g`) without the cocycle laws; the prover will add them — the blueprint must specify them.

Constraints: math prose only, no Lean tactics. Do NOT add `\leanok`. Keep blocks concise.
