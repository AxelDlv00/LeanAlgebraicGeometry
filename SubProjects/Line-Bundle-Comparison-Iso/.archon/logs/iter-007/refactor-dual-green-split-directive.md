# Refactor directive — green + split DualInverse.lean

Target: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` (currently RED, 6 compile errors; 1235 LOC).

## PRIORITY 1 (must achieve): restore a GREEN, compiling file
The file does not compile. Replace ONLY the failing proof obligations at these sites with a typed
`sorry` (leave a `-- REPAIR: sorry inserted at broken proof site; fill via analogies/dualnat006.md` note):
- L407 `ext z` (the `sliceDualTransportInv.naturality` field) — replace the whole `ext z; simp only [...]`
  tactic block with `sorry`.
- L436 / L556 / L566 (inside `sliceDualTransport`, ~L429–768): the `naturality` field whnf-timeouts and
  the L556 "function expected" — replace the failing tactic block(s) for that field with `sorry`.
- L799 `Unknown identifier sliceDualTransport` and L803 `subsingleton` (inside `dual_restrict_iso`, ~L769):
  L799 is a CASCADE — once `sliceDualTransport` elaborates (PRIORITY-1 sorry), it should resolve on its
  own; if `dual_restrict_iso`'s `isoMk` square still fails, replace that proof obligation with `sorry`.
Do NOT fill any proof. Do NOT change any signature, name, or argument order (every decl is consumed
downstream / by `TensorObjSubstrate.lean`'s import — exported API must be byte-identical). Verify
`lake build AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse` exits 0 with only `sorry`/lint
warnings. This is the iteration's must-fix; do not proceed to PRIORITY 2 until it is green.

## PRIORITY 2 (only if PRIORITY 1 is green): split the file
Split along the natural seam, preserving all fully-qualified names + the `namespace`s:
- New file `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/SliceTransport.lean`:
  move `unitDualSectionEquiv`, `dualUnitIsoGen` (L84–163, `namespace PresheafOfModules`) and
  `isIso_ε_restrictScalars_appIso`, `dualUnitRingSwap(_apply/Inv/Hom)`, `isIso_ε_restrictScalars_appIso_hom`,
  `isIso_ε_restrictScalars_presheafMap`, `unitRelabelSwap`, `sliceDualTransportInv`, `sliceDualTransport`
  (L164–768, `namespace AlgebraicGeometry.Scheme.Modules`).
- Keep in `DualInverse.lean`: `dual_restrict_iso`, `presheafDualUnitIso`, `dual_unit_iso`,
  `dual_isLocallyTrivial`, `homLocalSection`, `topSectionToHom`, `topSectionToHom_app`,
  `image_preimage_of_le`, `homOfLocalCompat` (L769–1235); add `import ...DualInverse.SliceTransport`.
- Replicate the import/`open` preamble in the new file as needed; both files must build green.
If the split cannot keep BOTH files green, REVERT the split and keep the single greened file from
PRIORITY 1 (the green file is non-negotiable; the split is best-effort).

## Report
List: the typed-sorry sites inserted (decl name + field), the final file layout + LOC of each, and the
exact `lake build` exit status of every affected module.
