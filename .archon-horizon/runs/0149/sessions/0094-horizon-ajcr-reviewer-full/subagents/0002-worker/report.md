## Progress

- I inspected the Pic0 seam files you named and confirmed the honest inputs are still conditional:
  - `Pic0SepClosedRepresentable.lean`
  - `Pic0FiniteGaloisRepresentable.lean`
  - `Pic0RepresentableByTransport.lean`
  - `PicRepDatum.lean`
  - `JacobianData.lean`
- I added a small wrapper in `AlgebraicJacobian/Picard/Pic0FiniteGaloisJacobianData.lean` at lines 115 and 143:
  - `picRepDatum_finiteStageGaloisDescent_of_isProjective`
  - `jacobianData_finiteStageGaloisDescent_of_isProjective`
- Those wrappers only package the existing finite-stage/projective descent route; they do not claim an unconditional arbitrary-field `pic0_representableBy`.

## Issues

- The first missing hypothesis for an honest assembly is `P.gluedMap.IsProjective` (equivalently, the derived `OrbitsInAffineOpen` witness for the finite-stage semilinear action).
- A direct kernel check failed because `.lake/build/lib/lean/AlgebraicJacobian/Picard/Pic0FiniteStageTripleTransitionFaceReflection.olean` was missing.
- I started the dependency build, but it did not finish in time, so I could not complete the final kernel/axiom audit or commit.

## Why I stopped

- Partial advance only: I found the exact missing hypothesis and landed the bounded wrapper, but the import-closure build did not complete, so verification is still open.

## Next

- Finish the missing dependency build.
- Rerun `lake env lean AlgebraicJacobian/Picard/Pic0FiniteGaloisJacobianData.lean`.
- If clean, run the axiom audit and commit the scoped change.
