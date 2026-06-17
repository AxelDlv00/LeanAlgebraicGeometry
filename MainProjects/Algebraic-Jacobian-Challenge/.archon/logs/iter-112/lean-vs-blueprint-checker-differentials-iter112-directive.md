# Lean ↔ Blueprint Checker Directive

## Slug
differentials-iter112

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Differentials.tex

## Known issues
- The iter-112 prover added two new top-level helpers in `Differentials.lean`:
  - `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (L159) — body `sorry`, packaging
    Step 2 + Step 3 of the chapter's Route (a) recipe.
  - `relativeDifferentialsPresheaf_isSheaf_type` (L188) — fully closed via
    `isSheaf_iff_isSheafOpensLeCover`.
  These are SCAFFOLDING and are intentionally not referenced from the blueprint by `\lean{...}` hints
  (they are private to the Lean side). Please flag only if you believe a `\lean{...}` hint would
  materially improve the bidirectional mapping or if the scaffolding deviates from the chapter's
  Route (a) recipe at L33–L51.
- The 4 unchanged `sorry` sites at L622 (`cotangentExactSeq_structure case h_exact`),
  L816 (`smooth_iff_locally_free_omega`), L832 (`cotangent_at_section`), L976 (`serre_duality_genus`)
  are all documented named-deferred or named-gap; please flag only if the chapter prose has drifted
  from the Lean signatures.
