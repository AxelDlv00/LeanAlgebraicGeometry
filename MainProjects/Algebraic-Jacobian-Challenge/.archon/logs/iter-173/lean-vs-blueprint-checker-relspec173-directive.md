# Lean ↔ Blueprint Checker — Picard/RelativeSpec.lean × Picard_RelativeSpec.tex

## Slug
relspec173

## Iteration
173

## File pair

- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RelativeSpec.lean` (NEW this iter)
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_RelativeSpec.tex`

## Iter-173 prover work

This is the FIRST landing of `Picard/RelativeSpec.lean`. The file-skeleton contains:

- 6 pinned declarations:
  - `Scheme.QcohAlgebra` (L98) — typed `sorry : Type (u+1)`
  - `Scheme.RelativeSpec` (L123) — typed `sorry : Scheme.{u}`
  - `Scheme.RelativeSpec.UniversalProperty` (L169) — encoded as `IsAffineHom (structureMorphism 𝒜)` substantive consequence
  - `Scheme.RelativeSpec.affine_base_iff` (L193) — encoded as `IsAffine ((Spec R).RelativeSpec 𝒜)`
  - `Scheme.RelativeSpec.base_change` (L223) — encoded as `∃ 𝒜', Nonempty (pullback g π ≅ T.RelativeSpec 𝒜')`
  - `Scheme.RelativeSpec.functor` — concrete body via `Over.mk (structureMorphism 𝒜)`, propagates sorry through `structureMorphism`
- 1 NEW helper: `Scheme.RelativeSpec.structureMorphism` (L134) — typed `sorry`.

## Verification questions

1. **Lean → Blueprint**: Do all 6 pinned `\lean{...}` references in the chapter resolve to the declared Lean names? Pin labels: `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base`, `thm:relative_spec_base_change`, `thm:relative_spec_functorial`.
2. **Blueprint → Lean**: Does the chapter's `thm:relative_spec_univ` prose substantively justify the `IsAffineHom`-encoding chosen by the prover (vs. the full Yoneda-bijection)? Flag as soft-finding if the chapter prose is sharper than the Lean encoding.
3. The prover added a new helper `structureMorphism` NOT in the original 6-pin list — is this a clean addition (justified by the universal-property + base-change + functor signatures needing a named structure morphism)? Is the writer's signature stable for iter-174+ body work?
4. The blueprint-reviewer flagged a missing verbatim quote on `thm:relative_spec_univ` proof block. Is this a hard gate for further work on this file, or is the Lean side cleanly decoupled from the proof prose?

## Output

`task_results/lean-vs-blueprint-checker-relspec173.md`
