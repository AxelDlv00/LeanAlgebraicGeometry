# lean-vs-blueprint-checker — RelativeSpec.lean ↔ Picard_RelativeSpec.tex

## File pair

- **Lean**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RelativeSpec.lean`
- **Blueprint**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_RelativeSpec.tex`

## What changed this iter (Lane C — iter-180)

- `QcohAlgebra.pullback.coequifibered` field closed kernel-clean via 2 named helpers (`QcohAlgebra.pullback_fst_isAffineHom`, `QcohAlgebra.pullback_coequifibered`).
- Net -1 sorry; off-target `pullback_iso` at L429 left as sorry per directive.
- `QcohAlgebra.pullback` def was reorganized from BEFORE `namespace RelativeSpec` to AFTER `RelativeSpec.UniversalProperty` (because new helpers depend on `UniversalProperty`).

## Report bidirectionally

1. **Lean → blueprint**: do the new helpers (`pullback_fst_isAffineHom`, `pullback_coequifibered`) need to be added to the chapter as `\lean{...}` pins? Verify the reorganization (moving `QcohAlgebra.pullback` def) doesn't break any chapter cross-references.
2. **Blueprint → Lean**: does the chapter spec the Mathlib idiom (`coequifibered_iff_forall_isLocalizationAway` + `IsAffineOpen.isLocalization_of_eq_basicOpen`)? Is the chapter detailed enough on the remaining `pullback_iso` body for iter-181+ work?

Output to `task_results/lean-vs-blueprint-checker-relativespec.md`.
