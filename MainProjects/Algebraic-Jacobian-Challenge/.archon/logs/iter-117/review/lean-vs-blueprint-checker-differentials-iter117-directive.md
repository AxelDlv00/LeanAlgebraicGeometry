# Lean ↔ Blueprint Checker Directive

## Slug
differentials-iter117

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Differentials.tex

## Known issues
- This file was heavily trimmed this iter: from ~1100 LOC to 83 LOC. Both the Lean file and the blueprint chapter were rewritten in iter-117 to drop the cotangent exact sequence, Serre duality, sheafification, and sheaf-condition machinery. Surviving Lean declarations: `relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`, `smooth_iff_locally_free_omega` (the last with an inline `sorry` body).
- `smooth_iff_locally_free_omega` was refactored from the sheafified form (against `relativeDifferentials f`) to the presheaf form (against `relativeDifferentialsPresheaf f`). Both statements express the same math; the change-of-statement is intentional. Verify the new presheaf-form statement is mathematically correct and the blueprint's `thm:smooth_iff_locally_free_omega` proof sketch matches the presheaf form.
- The blueprint chapter (`Differentials.tex`) was rewritten this iter by `blueprint-writer-differentials-iter117`. Audit it against the Lean for: (a) does each surviving Lean declaration have a `\lean{...}`-tagged block in the chapter; (b) is the proof sketch detailed enough to guide an iter-118 prover lane on the inline sorry; (c) is the "out-of-scope" trimmed-material disclosure section honest about what was removed?
- The blueprint should NOT reference the deleted machinery (cotangent exact sequence, Serre duality, sheaf-uniform-gluing helper, etc.) except in an explicit "out of autonomous-loop scope" disclosure section.
