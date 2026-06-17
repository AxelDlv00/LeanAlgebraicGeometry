# Lean Auditor — iter-173

## Scope

Audit all `.lean` files under `AlgebraicJacobian/` that were edited this iteration:

- `AlgebraicJacobian/Genus0BaseObjects.lean`
- `AlgebraicJacobian/Picard/RelativeSpec.lean` (NEW this iter — file-skeleton)
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- `AlgebraicJacobian.lean` (umbrella — confirm no-op)

You may also spot-audit other files if needed for context, but the focus is on the four above.

## Absolute paths

- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RelativeSpec.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean

## Focus areas

1. **Honest scaffolding vs. laundering** — for `Picard/RelativeSpec.lean` (newly created), check that the 6 pinned scaffold `sorry`s use **substantive intended types** rather than tautological `Iso.refl`-style placeholders. Special attention to `UniversalProperty`, `affine_base_iff`, `base_change`, and the helper `structureMorphism`.
2. **`Genus0BaseObjects.lean` — `awayι_comp_PLB_hom` + `gmScalingP1_cover_X_iso`** (newly added) — check axiom hygiene claim (`{propext, Classical.choice, Quot.sound}`-only), check pattern-match-on-`i` rationale for the iso, and check whether the two new helpers are referenced only by the body they support.
3. **`WeilDivisor.lean` — `Scheme.PrimeDivisor`** — the placeholder `isCodim1AndIntegral : True := trivial` was repaired to `coheight : Order.coheight point = 1`. Confirm no callers were broken and the structure is substantive. Also verify `degree_hom` is sorry-free with the `Finsupp.liftAddHom` body.
4. Any stale comments / dead-end excuse comments / outdated docstrings on the touched files.
5. Any unused declarations introduced this iter.

## Output

Report `task_results/lean-auditor-iter173.md` with per-file checklist + severity-tagged findings.
