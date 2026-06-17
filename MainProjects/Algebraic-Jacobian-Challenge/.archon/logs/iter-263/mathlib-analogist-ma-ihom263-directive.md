# mathlib-analogist ma-ihom263 — the internalHomObjModule-add ↦ Hom-add bridge

## Mode: api-alignment

## Context
File `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` is building a `LinearEquiv`
`sliceDualTransport f M V` (forward `toFun` already built categorically via `.map`). The remaining
`≃ₗ` packaging obligations `map_add'` and `map_smul'` are BLOCKED by a syntactic-vs-definitional
mismatch, and a progress-critic flagged the route STUCK because this same blocker will recur on
every remaining sub-hole that touches additivity/linearity.

## The exact blocker (from the iter-262 prover report)
- The domain/codomain elements are `x y : ↑(((pushforward β).obj M.val.dual).obj V)` — sections of
  the pushforward of the (sheaf-level) dual.
- The `+` (and `•`) on these elements is the MODULE add/scalar action carried by
  `PresheafOfModules.InternalHom.internalHomObjModule` — the pointwise internal-hom module structure
  on the dual section object (the value of the internal-hom presheaf at the slice terminal object).
- This `internalHomObjModule` add is NOT *syntactically* the `PresheafOfModules.Hom` add (even though
  they are defeq / the same group of dual sections). So:
  - `apply PresheafOfModules.hom_ext; intro W; show (restrictScalars _).map ((x+y).app _) ≫ _ = _`
    beta-reduces the LHS struct `.app W` (verified), but
  - `PresheafOfModules.add_app` / `Functor.map_add` report "pattern not found" on the LHS `(x+y).app`,
    because the `(x + y)` is the `internalHomObjModule`-add, not the `Hom`-add those lemmas expect.
- The prover's hypothesis: a small `internalHomObjModule`-add ↦ `PresheafOfModules.Hom`-add (and -smul)
  **defeq bridge** — a `change`/unfold of the `internalHomObjModule` add field — would let
  `Functor.map_add, add_comp` fire and close map_add'/map_smul'.

## Relevant decls to inspect (read these in the project + Mathlib)
- `PresheafOfModules.InternalHom.internalHomObjModule` — the project's internal-hom object module
  instance (defined in `Picard/TensorObjSubstrate.lean`; the blueprint block is `lem` near L5187 of
  `Picard_TensorObjSubstrate.tex` with `\lean{...internalHomObjModule}`). Determine how its
  `AddCommGroup`/`Module` `add`/`smul` fields are defined and whether they are reducibly /
  definitionally the underlying `PresheafOfModules.Hom` operations.
- `PresheafOfModules.add_app`, `PresheafOfModules.Hom` add instance — the canonical morphism-level
  add and the lemma that exposes its `.app`.
- The pushforward/dual section object `((pushforward β).obj M.val.dual).obj V`.

## Questions for you (api-alignment)
1. **Does Mathlib have a canonical idiom** for "the module structure on an internal-hom / Hom object is
   the pointwise one, and its `+`/`•` agrees with the underlying morphism `+`/`•`"? E.g. does
   `ModuleCat`/`PresheafOfModules` internal-hom or `Hom`-type already carry `@[simp]` lemmas
   (`add_apply`/`smul_apply`-style, or an `AddMonoidHom`/`LinearMap` `.app` congruence) that expose the
   pointwise action so `map_add` fires WITHOUT a manual `change`? Name the exact lemma(s) if so.
2. If no such lemma exists for THIS object, **what is the cleanest bridge**: a `change`/`show` to the
   `Hom`-add (is it truly defeq?), a one-line helper lemma
   `((x + y : internalHomObjModule …).app W) = x.app W + y.app W` proved by `rfl`/`ext`, or a
   `@[simp]`-able `internalHomObjModule_add_app` / `_smul_app`? Recommend the form that GENERALIZES to
   all remaining sub-holes (the critic's concern: this recurs).
3. **Is the design itself the smell?** The critic raised "design-shape suspected." Is
   `internalHomObjModule` defined in a way that *parallels* (re-implements) a Mathlib module-on-Hom
   structure it should instead be re-using or aligning with — such that the syntactic mismatch is a
   symptom of a parallel-API choice? If so, name the Mathlib structure it should align with and the cost
   of NOT aligning. If the project's choice is fine and only a thin bridge lemma is missing, say so
   plainly (PROCEED).

## Output
Write `analogies/ma-ihom263.md` with: the recommended bridge (exact lemma name or the precise
helper statement + how it is proved), whether it generalizes to map_smul' and the other sub-holes, and
the PROCEED / ALIGN-WITH-MATHLIB verdict on the `internalHomObjModule` design. Validate any concrete
lemma claim with `lean_run_code`/`lean_local_search` where possible and say what you verified.
