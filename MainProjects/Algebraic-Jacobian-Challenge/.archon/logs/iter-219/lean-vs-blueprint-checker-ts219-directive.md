# lean-vs-blueprint-checker directive — iter-219

## Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What changed this iter (the prover work to verify)

The prover built the FIRST sub-step of the new internal-hom/dual block (blueprint section
`sec:tensorobj_dual_infra`). 11 new axiom-clean declarations in `namespace PresheafOfModules.InternalHom`
(lines ~996–1129), centered on:
- `homModule` — the `R(T)`-module structure on `Hom(M,N)` of presheaves of modules over a base
  with terminal object `T`.
- `internalHomObjModule` — the slice value `Hom(M|_U, N|_U)` as an `R(U)`-module, i.e. the
  per-object VALUE of `def:presheaf_internal_hom`.

## What to check (bidirectional)

1. Lean → blueprint: do these 11 decls faithfully realize what `sec:tensorobj_dual_infra` /
   `def:presheaf_internal_hom` describe? The blueprint pins `def:presheaf_internal_hom` to
   `PresheafOfModules.internalHom` (the FULL presheaf, NOT yet built). The prover built only the
   per-object VALUE module (`internalHomObjModule`/`homModule`), not the full presheaf. Is the
   blueprint pin therefore pointing at a not-yet-existent declaration? Report whether the chapter's
   `\lean{...}` pins match what now exists in the Lean.
2. Blueprint → Lean: is the chapter detailed enough to guide the REMAINING sub-steps (restriction
   maps for `V ⟶ U`, presheaf assembly, dual, eval, sheafify)? Or is any sub-step under-specified?
3. Flag any fake/placeholder statement, signature mismatch, or mathematical divergence.

Report must-fix items explicitly. Read only the two files named above.
