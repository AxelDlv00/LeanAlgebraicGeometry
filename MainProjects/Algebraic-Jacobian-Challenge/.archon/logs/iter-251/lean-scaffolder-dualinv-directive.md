# lean-scaffolder — create the dual-inverse parallel-lane file

## Goal
Create a NEW Lean file `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` holding the
dual-inverse chain as `sorry`-body stubs, so a prover lane can prove it bottom-up IN PARALLEL with the
critical-path D1′/D3′/D4′ lane (which stays in `TensorObjSubstrate.lean`). DO NOT prove anything — every
body is `sorry`. DO NOT move or touch `exists_tensorObj_inverse` (it stays in `TensorObjSubstrate.lean`
for now; it is out of scope this iter and guard-railed).

## File setup
- Path: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`.
- Imports: `import AlgebraicJacobian.Picard.TensorObjSubstrate` and
  `import AlgebraicJacobian.Picard.TensorObjSubstrate.PresheafInternalHom` (the dual / internal-hom
  infrastructure lives there — `internalHom`, `internalHomEval`, etc.). Add any further imports the
  signatures need (verify with Lean search).
- Namespace: match the existing decls — `namespace AlgebraicGeometry.Scheme.Modules` (the existing
  decls are `AlgebraicGeometry.Scheme.Modules.dual_restrict_iso` etc.). Open the same namespaces
  `TensorObjSubstrate.lean` opens (check its header).
- After creating the file, add `import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse` to the
  aggregator `AlgebraicJacobian.lean` (in the correct alphabetical/dependency position) so the loop
  builds it.
- The file MUST compile (`lake build`) with the three stubs as `sorry`.

## The three stubs to scaffold (signatures from the blueprint; verify against it)
Read `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Author EXACT Lean signatures matching these
`\lean{...}` pins (all blueprint blocks are complete + correct per blueprint-review br251; all their
`\uses{}` deps are already `\leanok`/closed):

1. `AlgebraicGeometry.Scheme.Modules.homOfLocalCompat` — blueprint `lem:sheafofmodules_hom_of_local_compat`
   (~L5680). "A family of compatible local module-hom sections over an open cover glues to a global
   SheafOfModules morphism." `\uses{def:scheme_modules_homMk, lem:open_immersion_slice_sheaf_equiv}` —
   both CLOSED. This is the frontier base of the chain (no unproven deps).
2. `AlgebraicGeometry.Scheme.Modules.dual_restrict_iso` — blueprint `lem:dual_restrict_iso` (~L5370).
   The ring-iso/dual commutation: restriction along an open immersion commutes with the dual.
   `\uses{lem:internal_hom_isSheaf, lem:restrictscalars_ringiso_dualequiv}` — both CLOSED.
3. `AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial` — blueprint `lem:dual_isLocallyTrivial`
   (~L5468). The dual of a locally-trivial module is locally trivial.
   `\uses{lem:internal_hom_isSheaf, lem:dual_restrict_iso, def:scheme_modules_dual_iso_of_iso,
   lem:restrictscalars_ringiso_dualequiv}`.

For each stub include a `/- Planner strategy: ... -/` block above the `sorry` capturing:
- the blueprint label + the proof-sketch route (read it from the chapter);
- the named CLOSED base lemmas it consumes (`internalHom`/`internalHomEval` in PresheafInternalHom.lean,
  `dualIsoOfIso` at TensorObjSubstrate.lean:218, `isIso_of_isIso_restrict` at TensorObjSubstrate.lean:557,
  `homMk`, the slice-sheaf-equiv bridge);
- the WARM-CONTEXT WARNING from progress-critic pc251: `dual_restrict_iso` needs a presheaf-level
  R-linear slice comparison NOT covered by `overSliceSheafEquiv` (different categories/value ring) — it
  is a genuine new build; if it resists, the iter-230 C-wiring diagnostic and a targeted mathlib-analogist
  consult on the dual-restrict presheaf goal are the correctives (do not thrash).

## Constraints
- Signatures only need to be close enough to compile + be provable; the prover may refine them. Get the
  `{X : Scheme.{u}}` / `(f : ...)` variable shape right by mirroring `exists_tensorObj_inverse`
  (TensorObjSubstrate.lean:683) and the dual section header (TensorObjSubstrate.lean ~L200–700).
- No proofs. No edits to any file other than the new `DualInverse.lean` and the aggregator import line.
- Do NOT edit `TensorObjSubstrate.lean`, `RelPicFunctor.lean`, or the blueprint.
