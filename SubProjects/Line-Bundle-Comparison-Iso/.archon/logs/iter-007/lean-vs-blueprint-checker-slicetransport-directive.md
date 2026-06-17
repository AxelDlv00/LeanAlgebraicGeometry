# Lean ↔ Blueprint Checker Directive

## Slug
slicetransport

## Lean file
AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/SliceTransport.lean

## Blueprint chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Known issues
- This file was split out of `DualInverse.lean` this iter (refactor) and given prover work.
- 3 intentional open `sorry`s remain: L444 (`sliceDualTransportInv` inv-naturality root), L724/726 (`sliceDualTransport` left_inv/right_inv). Report them, but they are known — focus on whether the chapter's `lem:slice_dual_transport` / `lem:slice_dual_transport_inv` blocks (and the `_apply` helper lemmas) are adequately specified and whether signatures match the `\lean{...}` hints.
- The chapter is the consolidated `% archon:covers` chapter; only audit blocks whose `\lean{...}` targets live in THIS Lean file.
