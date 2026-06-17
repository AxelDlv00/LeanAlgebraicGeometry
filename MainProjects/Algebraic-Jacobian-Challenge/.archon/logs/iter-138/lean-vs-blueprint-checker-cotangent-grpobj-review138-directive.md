# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review138

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

(Also consult `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` —
the pointer chapter — to verify cross-references resolve.)

## Known issues
- Iter-135 MED-C file-header line-anchor drift at L61/L107/L146/L155/L160
  (now extended further by iter-138 docstring insertions). Already
  carry-over — flag as minor at most, do not re-elevate.
- The iter-138 blueprint-writer landed a new `def:GrpObj_schemeHomRingCompatibility`
  block + companion remark in `RigidityKbar.tex` plus a ~140-line
  `% NOTE iter-137:` block inside the proof of
  `lem:GrpObj_omega_basechange_proj` documenting the Route (a) /
  Route (b) closure options. Treat the writer-landed material as the
  baseline; do not flag it as new.
- The blueprint's `lem:GrpObj_omega_basechange_proj` is still
  `\notready`-eligible: iter-138 prover shipped PARTIAL with three
  concrete sub-sorries. Statement block can still be `\leanok` (Lean
  decl exists with matching signature); proof block must NOT be `\leanok`.
  Marker management is `sync_leanok`'s domain — do not propose marker
  edits, but DO flag if you see something that suggests the script
  mis-marked.

## Focus question for the bidirectional check

The iter-138 prover decomposed the original single `sorry` body of
`relativeDifferentialsPresheaf_basechange_along_proj_two` into a
substantive Route (b) skeleton with three concrete narrowly-scoped
sub-sorries (helper `_derivation`'s `d_app` + `d_map`, plus `IsIso`
of `basechange_along_proj_two_inv` in the main def). Verify:

1. The new helpers `basechange_along_proj_two_inv_derivation` and
   `basechange_along_proj_two_inv` have signatures that match the
   blueprint's Route (b) prose (the ~140-line `% NOTE iter-137:` block).
2. The structural decomposition is honestly described in the Lean
   docstrings — no excuse-comments dressed up as analysis.
3. The three remaining sub-sorries are concrete enough that an
   iter-139+ prover can attack them without re-reading the whole
   iter-137 mathlib-analogist analysis.
4. Blueprint coverage of the helper signatures: does `RigidityKbar.tex`
   need explicit `\lean{...}` blocks for the two new helpers, or is
   the proof-block prose sufficient?
