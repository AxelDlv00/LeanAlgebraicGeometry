# Blueprint Reviewer Directive (scoped fast-path)

## Slug
ts220fp

## Why scoped this iter

This is the sanctioned same-iter fast-path re-review after a blueprint-writer round. This iter a
writer (ts220asm) + clean (ts220) expanded section `\label{sec:tensorobj_dual_infra}` of
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. You still read the whole blueprint as usual,
but the GATE DECISION I need is specifically about whether **`Picard_TensorObjSubstrate.tex`** is now
`complete: true` + `correct: true` with **no must-fix** for the NEXT prover step, so I can dispatch a
`mathlib-build` prover on `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` THIS iter.

## What changed this iter (focus your gate decision here)

Within `sec:tensorobj_dual_infra`, three new blocks + a revised assembly paragraph:

1. `def:presheaf_internal_hom_value` (`\lean{PresheafOfModules.InternalHom.homModule}`) — pins the
   already-built `R(T)`-module structure on the morphism group `M ⟶ N` over a base with terminal `T`.
2. `def:presheaf_internal_hom_slice_value` (`\lean{PresheafOfModules.InternalHom.internalHomObjModule}`)
   — the slice specialisation: `M|_U ⟶ N|_U` as an `R(U)`-module, = the value `ℋom(M,N)(U)`.
3. `lem:presheaf_internal_hom_restriction` (`\lean{PresheafOfModules.InternalHom.restrictionMap}`) —
   the restriction map `ℋom(M,N)(U) → ℋom(M,N)(V)` for `g : V ⟶ U`, additive + semilinear over
   `R(g)`. This is the previously-under-specified next prover target.
4. Revised `def:presheaf_internal_hom` prose: explicit presheaf assembly (value modules + restriction
   maps + identity/composition functoriality + semilinearity compatibility) + extended `\uses{}`.

## The gate question

For the next prover step (sub-step 2 of the dual block: build the restriction maps + assemble the
full `PresheafOfModules.internalHom`), is the chapter now formalization-ready? Concretely:

- Are the three new blocks mathematically correct and self-consistent (value module → slice value →
  restriction map → assembly), and do they give a prover enough to formalize the restriction map and
  the presheaf assembly WITHOUT inferring the decomposition?
- Are the `\uses{}` dependency edges among the new blocks (and into `def:scheme_modules_tensorobj`)
  acyclic and accurate?
- Any must-fix that would make a prover formalizing sub-step 2 produce throwaway work?

Report `Picard_TensorObjSubstrate.tex` with an explicit complete/correct verdict and any must-fix
items. The rest of your whole-blueprint audit is welcome but secondary to this gate decision.
