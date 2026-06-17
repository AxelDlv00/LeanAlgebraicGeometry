# Mathlib Analogist Directive

## Mode: cross-domain-inspiration

## Slug
fbc-iter009

## Structural problem
We need a **base-change / extension-restriction square iso of `ModuleCat` objects** whose underlying
`R'`-module structure is *transparent* (typeclass-synthesizable), not opaque. Concretely, in the affine
model of flat base change along ring maps `R → R'` (`ψ`) and `R → A` (`φ`):

- The object `(extendScalars φ).obj M` (an `A`-module `M` extended), then `restrictScalars` /
  `extendScalars` again along the base-change square, carries an `R'`-module structure that arrives
  through `ModuleCat.ExtendScalars` / `ModuleCat.RestrictScalars` functor objects.
- We built a hand-rolled `R'`-linear equivalence `g` (`base_change_mate_regroupEquiv`) bundling
  `(R'⊗_R A)⊗_A M ≅ R'⊗_R M` over these objects.
- The `map_smul'` field needs `r' • z` to reduce on generators. The substantive generator computation is
  PROVEN. But the two trivial `r' • 0 = 0` "zero branches" CANNOT close: the `R'`-module instance on the
  carrier is an **opaque `_aux` def** through which `SMulZeroClass ↑R'` does not synthesize and
  `simp [smul_zero]` finds no keyed match. `letI`/`inferInstanceAs` re-supply via the transparent
  `restrictScalars` path produces a *fresh* opaque `_aux` that TC still ignores; the `.toDistribMulAction`
  projection variant times out `whnf` forcing reduction of the opaque module def.

The question: **how does Mathlib structure a base-change-square module iso so that the resulting
`R'`-module action is transparent enough that `smul_zero` / `smul_add` fire by `simp`?** I.e. what is the
canonical idiom for stating "the `R'`-module obtained by restricting an extended-scalars object along a
commuting square" so it is NOT an opaque sigma-def?

## Failed approaches
- Hand-built `g : LinearEquiv` over the bare functor-object carriers, promoted via
  `LinearEquiv.toModuleIso`. → `map_smul'` zero-branches blocked on opaque `Module ↑R'`.
- `erw [ExtendScalars.smul_tmul]` + explicit `show` reductions close the `tmul`/`add` branches but the
  `zero` branches have no tensor head to rewrite.
- `letI`/`haveI`/`inferInstanceAs` re-supplying `SMulZeroClass`/`DistribMulAction` from the transparent
  `restrictScalars` path → fresh opaque `_aux`, ignored by TC; `whnf` timeout on projection.

## Search radius
narrow (algebraic geometry / commutative algebra / category-theory `ModuleCat` area — same general area,
different sub-area: look at how Mathlib's own base-change, `Algebra.TensorProduct.cancelBaseChange`,
`ModuleCat.ExtendScalars`/`RestrictScalars` adjunction, and any `Module.Flat` base-change-square material
state and consume these isos transparently).

## What I want back
A ranked list of Mathlib idioms/precedents for stating this base-change-square iso with a transparent
target action, each with citation + the technique, AND a concrete recommendation: should we (a) retype
`g`'s domain/codomain at genuine `(restrictScalars _).obj ((extendScalars _).obj M)` iso objects so the
action is transparent (the prover's "route (b)"), or (b) abandon the hand-built mate equiv entirely and
reduce both sides through the already-proved tilde dictionaries to Mathlib's `cancelBaseChange` directly?
Write the persistent rationale to `analogies/fbc-base-change-square-transparent-module.md`.
