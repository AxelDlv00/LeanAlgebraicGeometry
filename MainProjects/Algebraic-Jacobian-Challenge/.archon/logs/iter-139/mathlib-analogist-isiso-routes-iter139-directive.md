# Mathlib Analogist Directive — iter-139, `IsIso` routes for `basechange_along_proj_two_inv`

## Slug

isiso-routes-iter139

## Why you're being dispatched

Iter-138 closed PARTIAL on
`AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two`
(`AlgebraicJacobian/Cotangent/GrpObj.lean:612`) with substantive
structural body cut: the iter-137-validated **Route (b) inverse-
direction-via-adjunction-transpose** skeleton landed end-to-end with
the additive (`d_add`) and Leibniz (`d_mul`) laws of the pointwise
`KaehlerDifferential.D` derivation closed honestly. Three concrete
sub-sorries remain. The iter-139 plan has the **two derivation sub-
sorries (d_app + d_map)** going to a prover lane in parallel with
your consult. **Your consult is the iter-140 decision input on how to
close the third sub-sorry**: `IsIso` of `basechange_along_proj_two_inv`
(`Cotangent/GrpObj.lean:624`, inside
`letI : IsIso (basechange_along_proj_two_inv G) := sorry`).

The choice is non-obvious. The iter-137 mathlib-analogist's PRIMARY
recommendation was Route (a) chart-unfolding helper; the iter-138
prover deferred Route (a) (the helper hits the same
`PresheafOfModules.pullback` opacity blocker as the iter-137
direct attempt; building the helper itself is ~30–60 LOC of
custom infrastructure) and instead landed Route (b) end-to-end
without that helper. Route (b'2) is a NEW alternative surfaced by the
iter-138 prover's task result: use
`PresheafOfModules.toPresheaf` (reflects isos via the underlying
presheaf-of-abelian-groups) and `NatTrans.isIso_iff_isIso_app` to
localise the iso check to per-open ModuleCat morphisms.

## The two routes to compare

### Route (a) — chart-unfolding helper + forward direction

- Build `pullbackObjEquivTensor` (~30–60 LOC helper): unfold
  `((PresheafOfModules.pullback φ).obj M).obj V` as
  `TensorProduct ((F.op ⋙ S).obj V) (R.obj V) (M.obj (F.op.obj V))`
  using the `pullbackPushforwardAdjunction` unit/counit.
  Reference: `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean`.
- Build the **forward direction** of the Step 2 iso directly via
  the chart-level `Algebra.IsPushout` helper + `tensorKaehlerEquiv`
  (the iter-137 5-step recipe Steps 1+3+4+5; ~250–500 LOC body).
- Establish `IsIso` of the inverse map by `isIso_of_isInverse`
  pairing the forward direction with `basechange_along_proj_two_inv`.
- **LOC envelope**: ~30–60 LOC helper + ~250–500 LOC body =
  ~280–560 LOC.
- **Reusability**: the chart-unfolding helper is potentially load-
  bearing for any future presheaf-of-modules pullback-on-obj
  computation in the project (and conceivably an upstream-PR
  candidate).

### Route (b'2) — local-iso check via `toPresheaf` + `NatTrans.isIso_iff_isIso_app`

- Use `PresheafOfModules.toPresheaf` (the forgetful functor to
  presheaves-of-abelian-groups, which reflects isos because
  `PresheafOfModules.PresheafForget`-ness is fully-faithful or
  reflects-iso at the right level). Reference:
  `Mathlib/Algebra/Category/ModuleCat/Presheaf/Basic.lean` (look
  for `toPresheaf` or equivalent name; verify the actual name).
- Use `CategoryTheory.NatTrans.isIso_iff_isIso_app` to localise
  the iso check to per-open identifications.
- At each open `V`, identify the per-open ModuleCat morphism with
  `KaehlerDifferential.tensorKaehlerEquiv`'s inverse on affines
  (using a chart-level `Algebra.IsPushout` helper, similar to
  Route (a)'s Step 1).
- **LOC envelope**: ~150–300 LOC.
- **Reusability**: less infrastructure value; the local-iso check
  pattern is project-specific.

## What you must check

1. **Mathlib naming verification**. The iter-138 prover's task result
   names `PresheafOfModules.toPresheaf` and
   `NatTrans.isIso_iff_isIso_app`. **Verify both names exist in
   current Mathlib via `lean_loogle` / `lean_local_search` /
   `lean_hover_info`**, and report the exact name + module path of
   each (or the closest replacement if either name is wrong). Also
   verify `PresheafOfModules.pullback` and `pullbackPushforwardAdjunction`
   for Route (a) (these are well-known per the iter-137 / iter-138
   docs but should be cross-checked).

2. **Route (a) chart-unfolding helper feasibility**. Is
   `pullbackObjEquivTensor` actually buildable from
   `pullbackPushforwardAdjunction` unit/counit, or does it require
   further Mathlib infrastructure that doesn't exist? If buildable,
   what's the cleanest signature shape (an `Iso` between objects?
   An `≃ₗ[R]` between underlying linear types? A `simp` lemma on
   `(pullback φ).obj M`'s `.obj V`?). Identify the closest Mathlib
   analogue and confirm Route (a) follows it.

3. **Route (b'2) `toPresheaf`-reflects-isos check**. Does Mathlib's
   `PresheafOfModules.toPresheaf` (or its equivalent) actually
   reflect isomorphisms? If yes, name the supporting lemma. If no,
   identify the obstruction (Route (b'2) collapses if the forgetful
   functor doesn't reflect isos at the underlying-presheaf level).

4. **Per-open identification with `tensorKaehlerEquiv`**. Both
   routes need to chart-localise to per-open ModuleCat
   identifications via `KaehlerDifferential.tensorKaehlerEquiv`
   (`Mathlib.RingTheory.Kaehler.TensorProduct`). Is this the right
   Mathlib idiom for "compare two presheaf-of-modules morphisms by
   their per-open behavior on affine generators"? Or does Mathlib
   prefer a different idiom (e.g. `PresheafOfModules.epi_iff_locally_surjective`
   or a localised generator argument)?

5. **Verdict shape**. Render a clear PROCEED-with-Route-a / PROCEED-
   with-Route-b'2 / ALIGN_WITH_MATHLIB-on-different-idiom verdict.
   Include LOC envelope estimates revised for the iter-139 Mathlib
   reality + any infrastructure gaps you find. If both routes are
   viable but one is more upstream-PR-aligned, note that.

## Out of scope

- Do NOT attempt to close the d_app or d_map sub-sorries (that's
  the parallel iter-139 prover lane's territory).
- Do NOT propose a third radically-different route unless you find
  Mathlib idiom that Route (a) and Route (b'2) both ignore. If you
  do, name it and explain the cost of NOT pivoting.

## Persistent file output

Write a persistent file at
`analogies/isiso-basechange-along-proj-two-inv.md` documenting:

- The two routes (a) and (b'2) as you understand them after consult.
- Your verdict + LOC envelope revision.
- Named Mathlib API + module paths (key signatures verified to exist).
- Any gap items the iter-140 prover would need to pre-construct.

Also write the report to `task_results/mathlib-analogist-isiso-routes-iter139.md`.
