# Blueprint Writer Directive

## Slug
ts-engine210

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Strategy context
The relative-Picard group law is built via the ⊗-invertibility idiom, mirroring
Mathlib's `CommRing.Pic = Units (Skeleton (ModuleCat R))`. A line object is an
⊗-invertible object (`∃ N, M ⊗_X N ≅ 𝒪_X`, `def:scheme_modules_isinvertible`).
The group axioms on ⊗-iso-classes are **propositions** (`Nonempty (… ≅ …)`), so
the construction needs only OBJECTWISE existence-of-iso lemmas — NOT a coherent
monoidal category on all modules. A focused Mathlib-alignment consult (recorded at
`analogies/ts-assoc-gate210.md`) resolved the one remaining engine question: the
associator, restricted to invertible objects, is buildable from present Mathlib by
**local trivialization**, with NO `MonoidalClosed (PresheafOfModules R₀)` and NO
sheafification absorption iso. This single change makes the chapter dispatchable.

## Required content

1. **Re-scope `lem:tensorobj_assoc_iso` (currently ~L531) from arbitrary to
   INVERTIBLE objects.** Change the statement from "arbitrary `M,N,P`" to:
   *Let `X` be a scheme and `M,N,P ∈ Scheme.Modules X` be ⊗-invertible
   (`def:scheme_modules_isinvertible`, i.e. locally free of rank one). Then there
   is an isomorphism `(M ⊗_X N) ⊗_X P ≅ M ⊗_X (N ⊗_X P)` in `Scheme.Modules X`.*
   - Keep the `\lean{...}` target name `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso`
     (it is referenced by downstream `\uses{}`); only the hypotheses change.
   - Add `\uses{def:scheme_modules_isinvertible}` (and keep
     `\uses{def:scheme_modules_tensorobj}`).

2. **Replace the proof** with the local-trivialization construction, mirroring the
   already-correct `lem:tensorobj_preserves_locally_trivial` (~L504). The argument:
   - Pick a common affine open cover `{U_i}` of `X` on which `M|U_i ≅ 𝒪_{U_i}`,
     `N|U_i ≅ 𝒪_{U_i}`, `P|U_i ≅ 𝒪_{U_i}` (invertible ⇒ locally free rank one).
   - On each `U_i`, both `((M⊗N)⊗P)|U_i` and `(M⊗(N⊗P))|U_i` are `≅ 𝒪_{U_i}`
     (tensor of free rank-one modules is free rank-one). The standard associator
     of the underlying module tensor product (Mathlib's `Module.TensorProduct.assoc`)
     supplies the local isomorphism; its transition data over overlaps are units
     (`𝒪^×`-valued), and tensoring is functorial, so the local isomorphisms agree
     on overlaps and glue to a global isomorphism on `X`.
   - Emphasise in the prose that this is an **objectwise** isomorphism for the three
     fixed invertible objects — NOT a natural associator on a category — and that
     this is all the group law on iso-classes (`Nonempty (… ≅ …)`) consumes.

3. **Remove the now-obsolete `% NOTE` absorption-iso / `MonoidalClosed` paragraph**
   inside the old proof of `lem:tensorobj_assoc_iso`, and remove any
   "Strategy-modifying finding" framing it carried. The wall it described applied
   only to the arbitrary-module associator, which is no longer the target.

4. **Reconcile any prose that still asserts the associator holds for "arbitrary
   `M,N,P`, no flatness/local-freeness required".** If an explicitly-deferred
   *optional supplement* about the all-modules associator is desired, keep it as a
   clearly-marked optional remark that no consumer uses; otherwise drop it. Do NOT
   leave the chapter claiming both "arbitrary" and "invertible" for the same lemma.

5. **Check the consumers** `lem:tensorobj_isoclass_commgroup` (~L859),
   `lem:tensorobj_lift_onproduct` (~L672), `thm:rel_pic_addcommgroup_via_tensorobj`
   (~L953): confirm their `\uses{}` and prose reference the now-invertible-scoped
   associator and remain coherent. They already operate on invertible objects, so
   the change should make them MORE consistent; adjust prose only where it implies
   the associator is available for arbitrary modules.

6. **Update the LOC-estimate section** (`sec:tensorobj_loc_estimates`, ~L1080) to
   reflect that the associator is now a ~local-trivialization-glue lemma (cheap,
   no absorption iso, comparable to `lem:tensorobj_preserves_locally_trivial`),
   not a blocked `MonoidalClosed` build.

## Out of scope
- Do NOT change the unitor (`lem:tensorobj_unit_iso`) or braiding
  (`lem:tensorobj_comm_iso`) lemmas — they are already the cheap
  `sheafification.mapIso` pattern and do not hit the wall.
- Do NOT touch `def:scheme_modules_tensorobj`, `def:scheme_modules_isinvertible`,
  or the `lem:tensorobj_restrict_iso` / `restrictscalars_laxmonoidal` blocks
  (they are off-path supplements; leave them as-is).
- Do NOT introduce a `MonoidalCategory` / `J.W.IsMonoidal` framing anywhere.
- Do NOT add `\leanok` / `\mathlibok` markers.

## References
- `analogies/ts-assoc-gate210.md` — the consult that authorizes this change
  (local-trivialization realization; reasoning + Mathlib alignment).
- `references/stacks-modules.tex` / `references/stacks-divisors.tex` — invertible
  module def (tag 01CS), the `∃N` characterisation (0B8K), Picard group (01CX),
  if you need a verbatim `% SOURCE QUOTE` for the re-scoped statement. Mathlib
  `Module.TensorProduct.assoc` is the local associator (no external quote needed —
  it is the Lean target, named in prose only).

## Expected outcome
`lem:tensorobj_assoc_iso` is stated for invertible `M,N,P` with a clean
local-trivialization proof (no `% NOTE`, no `MonoidalClosed`), the chapter no
longer claims an arbitrary-module associator, the consumers are coherent, and the
chapter is internally consistent and dispatchable (every coherence iso is an
objectwise existence-of-iso the group law consumes).
