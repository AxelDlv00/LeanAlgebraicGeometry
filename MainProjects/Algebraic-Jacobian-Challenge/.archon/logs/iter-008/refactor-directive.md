<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-07T04:32:59Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive (iter-008)

## Problem

Iter-007 plan-agent re-probe surfaced a major upstream Mathlib advance: the
`HasWeakSheafify` and `HasSheafify` instances for `Scheme.etaleTopology.{u}`
(and its `.over (Spec (CommRingCat.of k))` lift) valued in
`AddCommGrpCat.{u+1}` are now both inferable in current Mathlib (previously
absent through iter-005). The Mathlib gap that previously blocked Phase C
step 3 *proper* (étale sheafification of `PicardFunctorAb`) has therefore
CLOSED, modulo a universe-pinning gymnastic: the inferable `HasSheafify` is
at value-universe `AddCommGrpCat.{u+1}`, while the iter-004 `PicardFunctorAb`
lands at `AddCommGrpCat.{u}`.

Iter-008 lands the étale-sheafified `PicardFunctorAb` on top of the
iter-004 / iter-005 / iter-007 codomain-change-and-polish chain. Iter-008
plan-agent `lean_run_code` probes confirm the closure body
`(presheafToSheaf _ _).obj (Scheme.PicardFunctorAb C ⋙ AddCommGrpCat.uliftFunctor.{u+1, u})`
typechecks against current Mathlib at value-universe
`AddCommGrpCat.{max u (u+1)}` (which equals `AddCommGrpCat.{u+1}`).

## Mathematical justification

`AlgebraicGeometry.Scheme.PicardFunctorAb.etaleSheafified` is the étale-
topology sheafification of the iter-004 `PicardFunctorAb`. It is the
input shape required by Grothendieck's representability machinery (FGA /
Hilbert / Quot schemes) for the `Jacobian` chain — Mathlib's
`CategoryTheory.presheafToSheaf` is the universal property left adjoint of
the inclusion `Sheaf J A → Cᵒᵖ ⥤ A`, and any future representability theorem
will start from this sheaf. Building it now is a no-cost win: the body is a
single one-liner against existing Mathlib API, and unblocks downstream Track
C step 5+ work (representability — still gated on `LineBundle` refinement
and FGA, multi-iteration; iter-008 does NOT attempt it).

The universe-lift `AddCommGrpCat.uliftFunctor.{u+1, u}` post-composition is
the standard route from `AddCommGrpCat.{u}` to `AddCommGrpCat.{u+1}` (the
naive `AddCommGrpCat.uliftFunctor : AddCommGrpCat ⥤ AddCommGrpCat` does not
unify under `u+1 =?= max u v` because the lift functor's universe parameters
are implicit; explicit `.{u+1, u}` annotation resolves this — confirmed by
`lean_run_code` probe).

Universe alignment: `presheafToSheaf` outputs at value-universe
`AddCommGrpCat.{max u (u+1)}` which Lean reduces to `AddCommGrpCat.{u+1}`.
The full output type is
`Sheaf ((Scheme.etaleTopology.{u}).over (Spec (CommRingCat.of k))) AddCommGrpCat.{max u (u+1)}`.

## Changes requested

### 1. Append `Scheme.PicardFunctorAb.etaleSheafified` to `AlgebraicJacobian/Picard/FunctorAb.lean`

After the existing `PicardFunctorAb_forget_obj` simp lemma (current L83–L87)
and inside the same `namespace AlgebraicGeometry.Scheme`, add the following
new declaration with body `:= sorry`:

```lean
/-- Phase C step 3 *proper*: étale-sheafify `PicardFunctorAb C` to obtain
a sheaf on `Scheme.etaleTopology.{u}` over `Spec k` valued in
`AddCommGrpCat.{u+1}`. Post-composes with the universe-lift functor
`AddCommGrpCat.uliftFunctor.{u+1, u}` to bridge the gap between the
iter-004 codomain `AddCommGrpCat.{u}` and the value-universe
`AddCommGrpCat.{u+1}` at which `HasSheafify` is inferable in current
Mathlib. See blueprint chapter `Picard_FunctorAb.tex`
(`def:PicardFunctorAb_etaleSheafified`). Phase C step 3 *proper* (iter-008).
-/
noncomputable def PicardFunctorAb.etaleSheafified
    (C : Over (Spec (CommRingCat.of k))) :
    Sheaf ((Scheme.etaleTopology.{u}).over (Spec (CommRingCat.of k)))
      AddCommGrpCat.{max u (u+1)} :=
  sorry
```

Recorded probe-confirmed body for the prover round:

```lean
  (CategoryTheory.presheafToSheaf _ _).obj
    (PicardFunctorAb C ⋙ AddCommGrpCat.uliftFunctor.{u+1, u})
```

(The `set_option linter.style.longLine false` is NOT needed inside the
declaration; the `≅` form lints fine. The signature line is `≤ 100` cols.)

### 2. Refresh the file docstring

Update the iter-007-era status block (lines around 11–30) to reflect the
iter-008 addition. Add a short status paragraph noting that the étale
sheafification has landed.

### 3. Universe pinning sanity check

Verify by a one-line `lean_run_code` probe (after the edit) that the
new declaration typechecks cleanly with body `sorry`, i.e. that the
signature is well-formed at the current Mathlib `b80f227+` snapshot.

### 4. Do NOT touch

- The iter-004 `PicardFunctorAb` definition (current L48–L65).
- The iter-005 `PicardFunctorAb.forgetCompare` (current L73–L76).
- The iter-007 `PicardFunctorAb_forget_obj` simp lemma (current L83–L87).
- Any file other than `AlgebraicJacobian/Picard/FunctorAb.lean` (no other
  files need changes; `Cohomology/StructureSheafModuleK.lean` is iter-007
  closed and stable).

### 5. Sorry budget

Net `sorry` count change: `10 → 11` (one new scaffold site). The prover
round will close it back to `10 → 10`.

### 6. Compilation invariant

Ensure `lean_diagnostic_messages` on `Picard/FunctorAb.lean` after the edit
returns *only* one new `declaration uses sorry` warning at the new
declaration's line. Zero errors.

### 7. archon-protected.yaml

`archon-protected.yaml` must remain unchanged: the new declaration is not
protected (no other agent has touched it), and no protected declaration is
moved or modified.

## Non-goals (explicitly out of scope for iter-008 refactor)

- Closing `PicardFunctor.representable` — gated on `LineBundle` refinement
  (`MonoidalCategory X.Modules`, still absent in current Mathlib) plus the
  FGA argument; multi-iteration; do not attempt.
- Phase A step 6 (Serre finiteness) — multi-iteration; not in scope.
- Closing any of the 9 protected sorries (`Genus.lean` × 1, `Jacobian.lean`
  × 5, `AbelJacobi.lean` × 3) — the `noncomputable` modifier on `def genus`
  / `def Jacobian` / `def ofCurve` is a separate user-facing question
  (the original challenge.lean writes `def`, not `noncomputable def`, but the
  honest closures of `genus`, `Jacobian`, and `ofCurve` all require
  `noncomputable`). Flag this in `task_pending.md` for the mathematician.
- Defining a `ModuleCat k`-flavored `Sheaf.HModule` (parallel to Mathlib's
  `Sheaf.H` for `AddCommGrpCat`) — would unblock `genus` independently but
  also requires the `noncomputable` decision. Defer.
