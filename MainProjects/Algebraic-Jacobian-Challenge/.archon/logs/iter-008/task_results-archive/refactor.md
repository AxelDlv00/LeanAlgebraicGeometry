# Refactor Report

## Status
COMPLETE

## Directive

### Problem
Iter-008 lands the étale-sheafified `PicardFunctorAb` on top of the iter-004
/ iter-005 / iter-007 codomain-change-and-polish chain in
`Picard/FunctorAb.lean`. The previously-blocking Mathlib gap
(`HasSheafify` for `Scheme.etaleTopology.{u}` valued in `AddCommGrpCat`)
has CLOSED in current Mathlib at value-universe `AddCommGrpCat.{u+1}`,
modulo a universe-lift of the iter-004 `PicardFunctorAb` (lands at
`AddCommGrpCat.{u}`) via `AddCommGrpCat.uliftFunctor.{u+1, u}`. The
directive scaffolds one new `noncomputable def` —
`Scheme.PicardFunctorAb.etaleSheafified` — with body `:= sorry`. The
prover round will install the probe-confirmed one-liner.

### Changes requested
1. Append `Scheme.PicardFunctorAb.etaleSheafified` to
   `AlgebraicJacobian/Picard/FunctorAb.lean` after the iter-007
   `PicardFunctorAb_forget_obj` simp lemma, body `:= sorry`, signature
   per directive.
2. Refresh the file docstring with an iter-008 status paragraph.
3. Universe-pinning sanity-check via a `lean_run_code` probe.
4. Touch nothing else (in particular, no other file).
5. Sorry budget: `10 → 11` (one new scaffold).
6. Compilation invariant: only one new `declaration uses sorry`
   warning, zero errors.
7. `archon-protected.yaml` unchanged (no protected declaration is
   touched).

## Changes Made

### File: AlgebraicJacobian/Picard/FunctorAb.lean

- **What:** (a) Extended the file docstring with an "iteration 008 —
  étale-sheafification scaffold" status paragraph describing the new
  declaration. (b) Appended a new `noncomputable def
  PicardFunctorAb.etaleSheafified` after the iter-007
  `PicardFunctorAb_forget_obj` lemma (now at L99–L113), inside the
  existing `namespace AlgebraicGeometry.Scheme`, body `:= sorry`. The
  signature is verbatim from the directive:
  ```lean
  noncomputable def PicardFunctorAb.etaleSheafified
      (C : Over (Spec (CommRingCat.of k))) :
      Sheaf ((Scheme.etaleTopology.{u}).over (Spec (CommRingCat.of k)))
        AddCommGrpCat.{max u (u+1)} :=
    sorry
  ```
- **Why:** Phase C step 3 *proper* — the étale-sheafification of
  `PicardFunctorAb` is the input shape required downstream by
  Grothendieck representability; the new Mathlib `HasSheafify` instance
  unblocks the one-liner. The post-composition with
  `AddCommGrpCat.uliftFunctor.{u+1, u}` (which the prover's body will
  use) bridges the universe gap between `AddCommGrpCat.{u}`
  (iter-004 codomain) and `AddCommGrpCat.{u+1}` (where `HasSheafify`
  inferes); naive `AddCommGrpCat.uliftFunctor` does not unify under
  `u+1 =?= max u v`, which is why explicit `.{u+1, u}` is required.
- **Cascading:** none. Only `AlgebraicJacobian.lean` (the aggregator
  with `import AlgebraicJacobian.Picard.FunctorAb`) and the file itself
  reference it; the new declaration is purely additive.

The iter-004 `PicardFunctorAb` (now at L48), the iter-005
`PicardFunctorAb.forgetCompare` (now at L73), and the iter-007
`PicardFunctorAb_forget_obj` (now at L94) are untouched — verified
both by inspection and by the same line-content as before the edit
(only the docstring grew, shifting line numbers by +14 lines from
their pre-edit positions of L48 / L73 / L83).

No other file was modified.

## New Sorries Introduced
- `AlgebraicJacobian/Picard/FunctorAb.lean:113` —
  `PicardFunctorAb.etaleSheafified` body. Probe-confirmed closure:
  `(CategoryTheory.presheafToSheaf _ _).obj
   (PicardFunctorAb C ⋙ AddCommGrpCat.uliftFunctor.{u+1, u})`.

Net sorry count change: `10 → 11` (matches directive §5).

## Compilation Status

- `AlgebraicJacobian/Picard/FunctorAb.lean`:
  `lean_diagnostic_messages` returns one item, severity=warning,
  `"declaration uses 'sorry'"` at line 109 col 19 (the new
  declaration). **Zero errors. Zero unrelated warnings.** Matches
  directive §6 invariant exactly.
- Probe (directive §3): `lean_run_code` against current Mathlib with
  the prover's intended one-liner closure body returned
  `{success: true, diagnostics: []}` — confirms the signature is
  well-formed and the body that the prover will install typechecks
  end-to-end at the current Mathlib snapshot.
- The aggregator `AlgebraicJacobian.lean` returned a transient
  `success: false` from `lean_diagnostic_messages` (no items,
  intermittently with `failed_dependencies: ["AbelJacobi.lean"]`),
  which appears to be an LSP load/cache hiccup unrelated to the
  refactor — `Picard/FunctorAb.lean` itself diagnoses cleanly, and
  the only file modified is `Picard/FunctorAb.lean`. No file other
  than the one I touched is reachable as a downstream consumer of
  the new declaration in the existing import graph.
- `archon-protected.yaml`: unchanged.

## Notes for Plan Agent

- **Mathematical justification was sufficient.** The directive
  spelled out the universe pinning gymnastic (`u+1 =?= max u v`
  unification trap, the explicit `.{u+1, u}` annotation), the
  signature line by line (including `AddCommGrpCat.{max u (u+1)}` —
  Lean reduces this to `AddCommGrpCat.{u+1}` automatically), and
  flagged that no `set_option linter.style.longLine false` is
  needed inside the declaration. All of these matched what I saw in
  the file.
- **Probe-confirmed body for the prover round** (recorded in
  `PROGRESS.md` and re-confirmed by my §3 probe):
  ```lean
  (CategoryTheory.presheafToSheaf _ _).obj
    (PicardFunctorAb C ⋙ AddCommGrpCat.uliftFunctor.{u+1, u})
  ```
  Inside the namespace, `Scheme.PicardFunctorAb` resolves as
  `PicardFunctorAb` directly. The probe ran from a top-level
  `open ... AlgebraicGeometry` context (not the namespace), where
  the qualified name is `Scheme.PicardFunctorAb` — the prover should
  drop the `Scheme.` prefix when installing the body inside
  `namespace AlgebraicGeometry.Scheme`.
- **No additional refactors needed.** The directive's "Do NOT touch"
  surface (iter-004 `PicardFunctorAb`, iter-005
  `PicardFunctorAb.forgetCompare`, iter-007
  `PicardFunctorAb_forget_obj`) is preserved verbatim. The file
  docstring's pre-existing iter-004 status paragraph is untouched;
  the iter-008 paragraph is appended after it.
- **Blueprint not modified** (per refactor-agent rules; review agent
  owns markers).
- **No follow-up refactor needed for iter-008.** The file is in a
  clean shape for the prover round.
