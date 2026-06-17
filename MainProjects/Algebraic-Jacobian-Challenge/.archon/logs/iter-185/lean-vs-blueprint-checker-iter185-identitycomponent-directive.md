# Lean ↔ Blueprint Checker Directive

## Slug
iter185-identitycomponent

## Lean file
AlgebraicJacobian/Picard/IdentityComponent.lean

## Blueprint chapter
blueprint/src/chapters/Picard_IdentityComponent.tex

## Known issues
- iter-185 NEW Lane: file-skeleton dispatch. 5 declarations scaffolded with `sorry` bodies, matching the 5 `\lean{...}` pins of the chapter (chapter landed iter-184 plan-phase by `blueprint-writer pic0-identity-component-chapter`).
- Declarations (per task result): `AlgebraicGeometry.GroupScheme.IdentityComponent` (L129), `AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme` (L157), `AlgebraicGeometry.Scheme.Pic0Scheme` (L193), `AlgebraicGeometry.Scheme.PicScheme.degree` (L234), `AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety` (L285).
- The plan agent's `objectives.md` listed `identity_component_open_subgroup` as the name; the chapter pin is `IdentityComponent.isOpenSubgroupScheme`; the prover followed the **chapter** (authoritative). Verify the chapter `\lean{...}` resolves the actual Lean name correctly.
- `Pic0Scheme.isAbelianVariety` returns `IsProper ∧ Smooth ∧ GeometricallyIrreducible ∧ Nonempty (GrpObj ...)`. The `Nonempty (GrpObj ...)` is a bundled witness because we cannot derive a `GrpObj` *instance* on a typed-sorry def. Verify whether the chapter's `thm:pic_zero_is_abelian_variety` prose is compatible with this conclusion-shape.
- File is wired into `AlgebraicJacobian.lean:21`; no `Picard.lean` shim exists.
- This is the chapter's first audit alongside Lean code — flag any chapter / Lean alignment gaps for the iter-186 body-work pickup.
