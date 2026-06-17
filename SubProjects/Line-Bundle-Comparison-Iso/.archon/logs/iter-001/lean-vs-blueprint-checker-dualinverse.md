# Lean ↔ Blueprint Checker Directive

## Slug
dualinverse

## Lean file
/home/archon/proj/Line-Bundle-Comparison-Iso/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

## Blueprint chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Known issues
- Chapter is a consolidated `% archon:covers` chapter for several files; only the
  `sec:tensorobj_dual_bridge` region (`lem:slice_dual_transport`,
  `lem:slice_dual_transport_inv`, `lem:dual_restrict_iso`, `lem:dual_isLocallyTrivial`,
  `lem:sheafofmodules_hom_of_local_compat`) maps to this Lean file. Restrict the per-decl
  check to that region.
- File carries 4 known-open sorries (L388, L525, L627, L629) in the naturality/inverse fields
  of `sliceDualTransport`/`sliceDualTransportInv`. These are tracked open frontier; do not
  report them as placeholder unless the blueprint claims those exact fields are closed.
- The §C tail was bulk-restored from the extraction parent this iter (truncation recovery).
