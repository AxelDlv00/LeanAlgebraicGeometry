# Iter-219 objectives — detail

## Lane TS — `Picard/TensorObjSubstrate.lean` [prover-mode: mathlib-build]

### Context
`exists_tensorObj_inverse` (the ⊗-inverse, critical path) is BLOCKED on a Mathlib-absent sheaf
internal-hom / dual of 𝒪_X-modules (mathlib-analogist ts219dual). Do NOT `prove`/pin
`exists_tensorObj_inverse` this iter (iter-214 d.1 anti-pattern — forbidden). Instead BUILD the missing
infrastructure axiom-clean, one step at a time (Mathlib-gradient), starting with the first sub-step.

### Blueprint backing
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, new section `\label{sec:tensorobj_dual_infra}`
(gate-cleared this iter: complete+correct, 0 must-fix). Recipe + cost rationale: `analogies/ts219dual.md`.
Verbatim source: `references/stacks-modules.tex` (Stacks "Modules on Ringed Spaces" §Internal Hom, tag
area 01CM; the dual-of-invertible fact is tag 01CR item 2).

### PRIMARY build target — `def:presheaf_internal_hom` → `PresheafOfModules.internalHom`
Construct the presheaf-level internal hom of `𝒪_X`-modules as a `PresheafOfModules`:
`ℋom(M,N)(U) := ModuleCat.of (R.obj U) (M|_U ⟶ N|_U)` (the SLICE formula), where `M|_U` is the
open-immersion restriction already in-project. KEY technical point (blueprint intro + analogist):
the pointwise rule `U ↦ Hom_{R(U)}(M(U),N(U))` is CONTRAVARIANT in the restriction maps and is NOT a
covariant presheaf — so this is NOT a "build a presheaf then sheafify the way `tensorObj` does." The
SLICE rule `U ↦ (M|_U ⟶ N|_U)` IS covariant (restricting further along `V ⊆ U` is functorial) and is
the correct object. Build the object + its restriction maps + functoriality. Lean ingredients to lean
on (verify before use — [expected], not [verified]): `PresheafOfModules.Hom`, the in-project module
restriction (`M.restrict`), `ModuleCat.restrictScalars`, `ModuleCat.of`. Mirror the STRUCTURAL shape of
how `tensorObj`/`tensorObj_functoriality` are assembled (sheafification machinery aside), NOT its
sheafify step.

### DOWNSTREAM (push as far as budget allows; each its own clean decl, no sorry)
- `def:presheaf_dual` → `PresheafOfModules.dual M := internalHom M (unit)` — the dual `M^∨ = ℋom(M,R)`.
- `lem:internal_hom_eval` → `PresheafOfModules.internalHomEval` — evaluation `M ⊗ M^∨ → R`,
  `s ⊗ φ ↦ φ(s)` (counit of the internal-hom adjunction).

### mathlib-build mode contract
No sorry in output: each step is either fully proved/constructed or absent. Go as far as you can in one
iteration; stop ONLY when genuinely blocked, and hand off a PRECISE decomposition of the next step (what
Mathlib decl is missing / what coherence didn't close) so the next iter can continue. Keep build GREEN.
This is a multi-iter block (~6–12 iters estimated) — partial axiom-clean progress + a clean handoff is
the success criterion this iter, NOT closing `exists_tensorObj_inverse`.

### Out of scope this iter
- `exists_tensorObj_inverse` body (blocked on this infra; do not pin).
- `tensorObj_assoc_iso` re-route + whiskering/stalk deletion (deferred jointly with the dual — needs
  morphism-level descent; do NOT delete the still-live whiskering decls).
- `addCommGroup_via_tensorObj` (downstream of the inverse).
