# Progress-critic directive — iter-028

Assess convergence per active route from the signals below. K=4 iters. For each route return
CONVERGING / CHURNING / STUCK / UNCLEAR + the corrective TYPE if not converging.

## Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
STRATEGY phase: FBC-A (entered ~iter-018 at the gstar route-swap). Current `Iters left` estimate: 2–4.

Signals (sorry count in file / helpers added / status / blocker phrase):
- iter-020: sorry ~6 / helpers added / PARTIAL / blocker "literal-form lock: rw cannot match the post-subst unit leg"
- iter-022: sorry ~6 / +helpers / PARTIAL / same "literal-form lock"
- iter-024: sorry 6→5 / 3 `inner_eCancel` atoms + Seam B closed axiom-clean / PARTIAL / blocker "inner_value_eq assembly blocked at literal-form lock"
- iter-026: sorry 5→5 (FLAT) / 0 new sorries / PARTIAL / **the 4-iter literal-form lock was BROKEN: `erw` (defeq match) fires the unit expansion where `rw` (syntactic) cannot.** `base_change_mate_fstar_reindex_legs` now performs the unit expansion (the step 4 prior iters could not pass); remaining is the ~100 LOC cancellation assembly (term-mode `_gammaDistribute` distribution → unfold codomain read → 3 proved atoms → Seam 1 transport). The inline `inner_value_eq` pre-subst route was confirmed WALLED (leg only propositionally equal); the live route is via `_legs`.

Note: sorry count has been flat (≈5–6) for 4 iters, but iter-026 is a verified tactic advance past the named project blocker (not a discarded helper). Next planned dispatch: a focused `prove` pass on `_legs` completing the cancellation (route fully documented in-code + chapter).

## Route QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`
STRATEGY phase: QUOT-defs. Current `Iters left` estimate: 4–7.

Signals:
- iter-024: sorry 4→4 (protected stubs only) / +2 affine-engine decls axiom-clean (`isLocalizedModule_tilde_restrict`, `..._restrict_of_isIso_fromTildeΓ`) / PARTIAL / blocker "keystone gap1 hand-wavy"
- iter-026: sorry 4→4 (FLAT) / +5 axiom-clean decls (3 public + 2 private): the entire downstream glue `G1-core ⟹ gap1 ⟹ keystone` is now wired, axiom-clean, EXCEPT G1-core itself / PARTIAL / blocker "G1-core is genuine multi-session Stacks-01HA descent (cover-refine → local-tilde → flat-equalizer); step 1 (finite basic-open presentation cover from QuasicoherentData) needs the Scheme.Modules site/over API, a full-session build"
- This is a `mathlib-build` lane: sorry count is flat by design (the 4 sorries are protected stubs); progress is measured by axiom-clean infrastructure added each iter. The keystone's remaining obligation is now EXACTLY G1-core.

## Route GR — `AlgebraicJacobian/Picard/GrassmannianCells.lean`
STRATEGY phase: QUOT-repr (GR-glue sub-phase). Current `Iters left` estimate: part of QUOT-repr 6–12.

Signals:
- iter-012: sorry 0→0 / +28 decls (charts, transitions, cocycle) axiom-clean / COMPLETE for GR-cells
- iter-026: sorry 0→0 / +11 axiom-clean decls (7 GlueData "easy" fields + linchpin `awayPullbackIso` + 2 leg lemmas + `awayMulCommEquiv` orderSwap) / PARTIAL / blocker "the GlueData itself (t', t_fac, cocycle, .glued) is one large coherent construction; blocker is construction volume + the product-order subtlety (now solved by awayMulCommEquiv), NOT a missing Mathlib fact; precise decomposition handed off"
- `mathlib-build` lane: sorry 0 throughout (new-decl build into a sorry-free file); progress = axiom-clean decls toward `Grassmannian.scheme`.

## Dispatch sanity
Proposed iter-028 objectives (file count + basenames):
- `FlatBaseChange.lean` (FBC: prove `_legs` cancellation)
- `GrassmannianCells.lean` (GR: build the GlueData → `Grassmannian.scheme`)
- `QuotScheme.lean` (QUOT: G1-core step 1 `quasicoherentFiniteBasicCover` — pending a mathlib-analogist consult on whether a shorter affine descent exists)
3 import-independent lanes. Flag if any looks like a re-dispatch of a churning lane with cosmetic recipe variation.
