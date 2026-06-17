# Lean Auditor Directive

## Slug
dualinverse-restore

## Scope (files)
- /home/archon/proj/Line-Bundle-Comparison-Iso/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

## Focus areas
- The §C tail (decls `homLocalSection`, `topSectionToHom`, `topSectionToHom_app`,
  `image_preimage_of_le`, `homOfLocalCompat`) was just bulk-restored this iter by copying
  the corresponding file from another working tree. Verify the restored tail is internally
  consistent Lean: no dangling docstrings, no decls whose bodies look like fake/stand-in
  content, no excuse-comments.
- The four open `sorry` sites (L388, L525, L627, L629) carry in-body explanatory comments.
  Judge whether those comments accurately describe the open goal or are excuse-comments.

## Known issues
- File legitimately carries 4 standalone sorries (L388, L525, L627, L629) — naturality /
  inverse fields of `sliceDualTransport`/`sliceDualTransportInv`. These are known-open; report
  on their honesty, not their existence.
