# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review145

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex

(This is a pointer chapter; the main mathematical content for `GrpObj.lean`
material lives in `blueprint/src/chapters/RigidityKbar.tex`. You may read
that as well, but your verification target is the pointer chapter
metadata + the in-file Lean state.)

## Known issues
- Five sorry-bodied declarations were EXCISED iter-145 from this file
  (`basechange_along_proj_two_inv_derivation`, `basechange_along_proj_two_inv`,
  `basechange_along_proj_two_inv_app_isIso`,
  `relativeDifferentialsPresheaf_basechange_along_proj_two`,
  `mulRight_globalises_cotangent`) as part of the iter-144 chart-algebra
  pivot Q7 absorption (strategy-critic-iter145 Q7 sunk-cost ruling).
  Verify the pointer chapter (`AlgebraicJacobian_Cotangent_GrpObj.tex`)
  has been updated to reflect the excise — OR — that the pointer chapter
  carries an honest DESCOPED/EXCISED disposition for the deleted entries.
  If the pointer chapter still lists the excised declarations as live
  blueprint blocks with `\lean{...}` hints to declaration names that no
  longer exist in the Lean file, that is a must-fix Lean ↔ blueprint
  signature mismatch (the `\lean{...}` resolves to "declaration not
  found").
- The piece (i.a) trio `cotangentSpaceAtIdentity*` (defined at
  `GrpObj.lean` lines ~125–170 area) is intact and is the protected
  surviving content from earlier iters; it should be `\lean{...}`-pinned
  in the pointer chapter.
- The piece (i.b) shear-iso helpers (`shearMulRight`, `_hom_fst`,
  `_hom_snd`, `schemeHomRingCompatibility`, `isIso_of_app_iso_module`,
  `relativeDifferentialsPresheaf_restrict_along_identity_section`,
  `section_snd_eq_identity_struct`) are now orphan-helpers (per the
  iter-145 refactor report) but were NOT auto-deleted; verify whether
  the pointer chapter still references them and, if so, with what
  disposition.

Write your report per the descriptor's template.
