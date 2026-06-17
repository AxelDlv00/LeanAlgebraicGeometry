# Lean Auditor Directive

## Slug
iter001

## Scope (files)
- AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
- AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Focus areas (optional)
DualInverse.lean was rewritten this iter: its entire §C tail (~L850-1194:
homLocalSection, topSectionToHom, topSectionToHom_app, homOfLocalCompat) was
restored from an external source after the committed file was found
non-compiling. Audit that restored tail as fresh Lean. Also audit the four
open `sorry` sites (L388, L525, L627, L629) and the `subsingleton` close at the
`dual_restrict_iso` isoMk-naturality site — is `subsingleton` legitimate there
or papering over a non-trivial square?

## Known issues
- 4 open sorries in DualInverse.lean (L388/525/627/629) and 3 in
  TensorObjSubstrate.lean (L712/2623/2851) are tracked residuals — do not
  re-report their mere existence; DO report if any has a fake/suspect body.
- Long in-file STATUS-NOTE docstrings referencing parent iter numbers
  (iter-260/262/303) are carried over from the parent repo.
