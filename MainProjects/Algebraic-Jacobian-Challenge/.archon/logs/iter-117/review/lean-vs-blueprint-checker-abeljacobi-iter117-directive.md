# Lean ↔ Blueprint Checker Directive

## Slug
abeljacobi-iter117

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelJacobi.tex

## Known issues
- The blueprint chapter was rewritten this iter by `blueprint-writer-abeljacobi-iter117` to fix a Pic^0-vs-Albanese drift: every block now leads with the Albanese-projection mathematical content; the classical Pic^0/line-bundle prose was moved to `\begin{remark}` blocks.
- The three protected declarations `AlgebraicGeometry.Jacobian.ofCurve`, `AlgebraicGeometry.Jacobian.comp_ofCurve`, `AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp` are in `archon-protected.yaml` — signatures must match exactly. Verify each has a `\lean{...}` block matching the protected name and signature.
- The Lean file did NOT change this iter (only the blueprint was rewritten). The check is one-direction-leaning: did the rewritten blueprint succeed in tracking what the Lean actually does (Albanese projection on top of the `JacobianWitness.isAlbaneseFor` field)?
