# Iter 034 — Objectives (per-lane detail)

Full directives in PROGRESS.md `## Current Objectives`. This is the per-lane attempt-context record.

## Lane 1 — FBC-A `Cohomology/FlatBaseChange.lean` [fine-grained]
- Target: `lem:base_change_mate_fstar_reindex_legs` (→ cascade `fstar_reindex`, `inner_value_eq`,
  `gstar_transpose`). The conjugate-side re-encoding (first prover round of the iter-033 pivot).
- Recipe source: `analogies/fbc-mate-reencode.md`, `logs/iter-034/mathlib-analogist-fbc-mate-report.md`.
- Key Mathlib (verified this iter via the analogist): `leftAdjointCompIso`,
  `conjugateEquiv_leftAdjointCompIso_inv`, `leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm`,
  `unit_conjugateEquiv_symm`, `conjugateEquiv_comp`/`_symm_comp` (reassoc simp), `conjugateIsoEquiv`.
  Project: `conjugateEquiv_pullbackComp_inv`, `gammaMap_pushforwardComp_*`, `pullbackSpecIso`.
- Do-not-retry: the `..._link_distributeCollapse`/`_cancelEUnit`/`_cancelPullbackComp`/`_survivor` factor
  telescoping (the abandoned direct route); keyed `rw`/`simp`/`erw`/`conv` under the `X.Modules` diamond.
- Stop condition / tripwire: see `iter/iter-034/plan.md` `## Decision made`.

## Lane 2 — FBC-B `Cohomology/FlatBaseChangeGlobal.lean` [mathlib-build]
- Target: the ModuleCat-over-A `LinearMap.eqLocus` reformulation feeding `LinearMap.tensorEqLocusEquiv`
  (3-step: A-module structures via restriction of scalars → A-linear `leftRes/rightRes` → A-linear
  `Γ(M,⊤) ≅ eqLocus` from L2's Ab-`IsLimit`).
- Recipe source: `logs/iter-034/...FlatBaseChangeGlobal.lean-report.md` §"ModuleCat-over-A / flatness reformulation".
- Independent of FBC-A; the downstream chain (`base_changed_equalizer_diagram` etc.) stays blocked on FBC-A.

## Lane 3 — QUOT-P1 `Picard/QuotScheme.lean` [mathlib-build]
- Target: `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` =
  `Scheme.Modules.isIso_fromTildeΓ_restrict_basicOpen`.
- Recipe source: `logs/iter-034/...QuotScheme-report.md` §"Recommended completion recipe" (5 steps).
- Re-uses this-iter's `overRestrictPresentation` (twice) + `isoSpec` + Final-based `pullbackObjUnitToUnit`.
- Carry the three `set_option`s (`maxHeartbeats 2000000`, `synthInstance.maxHeartbeats 800000`,
  `backward.isDefEq.respectTransparency false`). Do-not-retry: open-immersion `pullback`-unit-iso (not Final).

## Lane 4 — GR-sep `Picard/GrassmannianCells.lean` [mathlib-build]
- Target: `lem:gr_separated` = `Grassmannian.isSeparated` (NEW decl — scaffold dispatch).
- Recipe source: `logs/iter-034/...GrassmannianCells.lean-report.md` §"isSeparated — geometric handoff",
  route (b): build `π : scheme → Spec ℤ` (`GlueData.glueMorphisms`), `IsSeparated π` via the Proj template
  (`Proj.isSeparated`, `ProjectiveSpectrum/Proper.lean:80–129`), `IsSeparated.comp_iff` to terminal.
- Ring heart already axiom-clean (`diagonalRingMap_surjective`); remaining = leg-compat + two-leg `hom_ext`.
