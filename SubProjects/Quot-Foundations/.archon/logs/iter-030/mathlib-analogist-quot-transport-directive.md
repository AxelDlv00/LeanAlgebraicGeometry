# Mathlib-analogist directive — quot-transport

## Mode: api-alignment

## Context

We are proving **gap1** (Stacks 01HA/01I8): for `M : (Spec R).Modules` (a `SheafOfModules` over
`(Spec R).ringCatSheaf`) with `[M.IsQuasicoherent]`, the canonical map `M.fromTildeΓ` is an
isomorphism — equivalently `M` is in the essential image of `tilde`. The file already has the full
*reduction engine* axiom-clean:
- `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (iff), and the two engines around it;
- `isLocalizedModule_basicOpen_of_presentation` — handles a module with a **global** `M.Presentation`;
- `map_units_restrict_basicOpen`, `isLocalizedModule_tilde_restrict`, etc.
- `exists_finite_basicOpen_cover_le_quasicoherentData` — from `q : M.QuasicoherentData`, produces a
  FINITE `t : Finset R`, `span t = ⊤`, with `∀ r∈t, ∃ i, D(r) ≤ q.X i`.

`IsQuasicoherent` (Mathlib, `Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean`) is
`Nonempty M.QuasicoherentData`, and `QuasicoherentData` provides a covering family `q.X : ι → Opens`
with `q.coversTop` and **local presentations** `q.presentation i : (M.over (q.X i)).Presentation`,
where `M.over (q.X i)` is the restriction of `M` to the sieve-object `q.X i` in the Grothendieck
site (`SheafOfModules.over`).

## The wall (the question)

To finish gap1 we must, for each `r ∈ t` with `D(r) ≤ q.X i`, obtain `IsIso ((M|_{D(r)}).fromTildeΓ)`
where `M|_{D(r)} : (Spec R_r).Modules`. The plan was: transport the **local sieve presentation**
`(M.over (q.X i)).Presentation` to a **global presentation of `M|_{D(r)}` on `Spec R_r`**, then apply
`isLocalizedModule_basicOpen_of_presentation`. This requires:
(a) restrict the slice presentation `M.over (q.X i)` to `M.over (D r)` (iterated-slice transport);
(b) **identify the abstract slice site `J.over (D r)` and sheaf `M.over (D r)` with the opens site
of `Spec R_r` and the scheme-pullback `M|_{D(r)}` across the iso `D(r) ≅ Spec R_r`.**

Two concrete obstacles observed live by the prover:
1. Mathlib `AlgebraicGeometry/Modules/` is only `{Presheaf, Sheaf, Tilde}` — NO restriction-to-open
   functor for `(Spec R).Modules`, NO `over`↔scheme-pullback bridge, NO QC-preservation lemma.
2. Even *stating* `q.presentation i` triggers a `synthInstance` heartbeat **timeout** on the slice
   `(sheafToPresheaf (J.over (q.X i)) _).IsRightAdjoint` instance. This timeout strongly suggests the
   `over`-slice route is the **wrong shape** for what we need.

## What I need from you (api-alignment)

1. **Does Mathlib already provide the QCoh-on-affine ⟹ tilde-essential-image result** (gap1) or any
   substantial fraction of it — e.g. a lemma `IsIso M.fromTildeΓ` from `[M.IsQuasicoherent]`, or a
   `SheafOfModules` restriction-along-open-immersion / pullback functor on `(Spec R).Modules`, or a
   `Presentation`-pullback/restriction lemma? Search `Mathlib/AlgebraicGeometry/Modules/`,
   `Mathlib/Algebra/Category/ModuleCat/Sheaf/`, and the quasi-coherent sheaf files. Give exact names.

2. **Is the `q.X i` sieve-`over` route the canonical Mathlib idiom here, or is there a cleaner path**
   that AVOIDS `M.over (q.X i)` and `q.presentation i` entirely? Specifically: is there a Mathlib way
   to (i) extract, from `[M.IsQuasicoherent]` plus a basic open `D(r)`, a *local* presentation of `M`
   directly on `D(r)` without the slice-site machinery; or (ii) reduce `IsIso M.fromTildeΓ` to a
   per-stalk / per-basic-open statement using existing tilde naturality (`fromTildeΓNatTrans`,
   `toOpen_fromTildeΓ_app`) that we can already discharge from `QuasicoherentData` more directly?

3. **The transport itself** — if we DO need `restrictModulesToBasicOpen : (Spec R).Modules ⥤
   (Spec R_r).Modules` + `over`↔pullback identification + `Presentation` transport: is there a
   Mathlib idiom for "restriction of a `SheafOfModules` along an open immersion of schemes" or
   "pullback of `SheafOfModules` along `Spec R_r → Spec R`" we should build on (e.g. via
   `SheafOfModules.pullback` / a morphism-of-sites functor), rather than a hand-rolled `over`-slice
   transport? `Presentation.ofIsIso` exists; is there `Presentation.pullback` / `Presentation.map`
   along a base-change?

4. **Verdict**: PROCEED (route is fine, just build the named ingredient) or ALIGN-WITH-MATHLIB
   (the slice route is the wrong shape; here is the canonical one). If ALIGN, give the concrete
   alternative decomposition (named Mathlib decls + the project lemmas to build) so we can blueprint
   it and dispatch a mathlib-build prover with the right shape.

Write the persistent rationale to `analogies/quot-gap1-transport.md` and the report to task_results.
