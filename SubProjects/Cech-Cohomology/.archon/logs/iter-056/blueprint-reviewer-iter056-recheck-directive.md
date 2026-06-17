# Blueprint-reviewer (scoped re-check) — clear the hard gate for two active prover lanes

## Scope
Your iter-056 review (`task_results/blueprint-reviewer-iter056.md`) flagged
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` as `complete: partial` with ONE
must-fix: `lem:open_immersion_pushforward_comp` Proof detail (2) ("change-of-scheme Serre transport")
had no Lean anchor / aux lemma / `\uses` edge. This re-check verifies whether that must-fix is now
resolved so the hard gate can clear for the two active prover lanes:
- `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` (Sub-brick A chain — was internally
  clean, gated only by the consolidated chapter's `partial` verdict);
- `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` (the Need #2 general-affine-open Serre
  vanishing target, newly blueprinted this iter).

## What changed since your iter-056 review
A mathlib-analogist audit proved the original prose route (transport along `j⁻¹V ≅ Spec Γ(j⁻¹V)`)
was a restriction-preserves-injectives WALL. Two blueprint-writer rounds + a blueprint-clean pass
replaced it with the sound two-need split:
- **Need #1**: whole-scheme `U ≅ Spec Γ(U)` transport via `Scheme.isoSpec` +
  `Scheme.Modules.pushforward` coherences + `Abelian.Ext.mapExactFunctor` — blueprinted as the TODO
  target `lem:modules_isoSpec_ext_transport` with `\mathlibok` anchors `Scheme.isoSpec`,
  `Ext.mapExactFunctor`, `Scheme.Modules.pushforward`.
- **Need #2**: enlarge `affineCoverSystem`'s basis `B` from `{D f}` to all affine opens, giving
  general-affine-open Serre vanishing from the existing `cech_eq_cohomology_of_basis` — blueprinted
  as the TODO target `lem:affine_serre_vanishing_general_open`.
- The WALL lemma `lem:sectionsFunctor_isoSpec_transport` was DELETED; a DEAD-END remark records why
  the open-subscheme transport is rejected. Proof detail (2) rewritten as (2a)/(2b Need#1)/(2c Need#2).
- Coverage-debt blocks added for the prover-created helpers; stale `affine_serre_vanishing` prose
  deleted; the misleading `dep*` `\uses` clarified.

## Your task
Re-audit `Cohomology_CechHigherDirectImage.tex` (you may read the whole blueprint as usual, but the
VERDICT I need is on this chapter). Report per-chapter `complete` / `correct` and whether ANY
must-fix-this-iter finding remains that touches:
(a) `lem:open_immersion_pushforward_comp` and its new transport sub-lemmas (Need #1 / Need #2), or
(b) the Sub-brick A chain (`lem:cech_backbone_left_sigma` … `lem:cechSection_contractible`), or
(c) the `lem:affine_serre_vanishing_general_open` Need #2 target.
Confirm the two new TODO targets are well-formed build targets (statement + informal proof + `\uses`,
`…TODO…` pin, no marker) — these are legitimately "to be built", not defects. Confirm the DEAD-END
remark is mathematically correct (the open-subscheme isoSpec transport really would force
restriction-preserves-injectives). State explicitly whether the hard gate CLEARS for
`CechSectionIdentification.lean` and for `AffineSerreVanishing.lean`.
