# lean-vs-blueprint-checker — QuotScheme.lean ↔ Picard_QuotScheme.tex

## File pair

- **Lean**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuotScheme.lean`
- **Blueprint**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_QuotScheme.tex`

## What changed this iter (Lane F — iter-180)

- `canonicalBaseChangeMap_app_app_isIso` body closes axiom-clean by composing 2 named substantive helpers:
  - `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` (Stacks 00H8 / 02KE affine flat base change).
  - `canonicalBaseChangeMap_app_app_isIso_of_affineCover` (Mayer-Vietoris descent from quasi-separated f).
- File 6 → 7 sorries (net +1 from the split; main theorem body itself has 0 sorry).

## Report bidirectionally

1. **Lean → blueprint**: do the 2 new helpers correspond to clearly-named blueprint pieces? Verify the chapter's prose mentions both the affine-local flat base change AND the MV descent step.
2. **Blueprint → Lean**: is the chapter detailed enough on (a) the affine identification of `Scheme.Modules` sections with algebraic tensor products (project-side bridge owed), and (b) the sheaf-theoretic "iso on basis ⟹ iso" lemma? Both are deep pieces the helpers carry as substantive sorries.

Output to `task_results/lean-vs-blueprint-checker-quotscheme.md`.
