# Iter 041 — Objectives detail

## Lane 1 — QUOT gap1 keystone close (`Picard/QuotScheme.lean`, mathlib-build)

Status entering iter: producer (a) `pullback_composite_immersion_isIso_fromTildeΓ` + range
`compositeBasicOpenImmersion_opensRange` (+def+instance) DONE axiom-clean (iter-040).

Build order (axiom-clean, no sorry):
1. **(b-flocus)** `compositeBasicOpenImmersion_flocus_image` — `σ f' = algebraMap R R_s f` (definitional)
   + `j ''ᵁ D(f') = D(f)⊓D(s)` (= `D(σ f') ⊓ range j`, range `= D(s)`). `σ = gammaImageRingEquiv j ⊤`.
2. **(c)** `gamma_image_iso_semilinear_top` — upgrade `gammaPullbackImageIso_hom_semilinear` (over
   `gammaImageRingEquiv j D(f')`) to ⊤-level `σ`. e₂/D(f') leg via `gammaPullbackImageIso_hom_naturality`
   (QuotScheme.lean:1833) — transport along the restriction square, do NOT re-state σ at D(f').
3. **(d)** `flocus_section_scalar_tower` — `A`-module + `IsScalarTower R A` on `Γ(M, D(f)⊓D(s))`,
   `A := Γ(M,D(s))`. Algebra via restriction-map `.hom.toAlgebra` (Mathlib Scheme.lean:725, Restrict.lean:200).
4. **TOP** `section_localization_hfr_basicOpen` — feed combiner `isLocalizedModule_powers_transport` (DONE)
   with engine localization (`isLocalizedModule_restrict_of_isIso_fromTildeΓ` on `(pullback j).obj M`,
   DONE via (a)), e₁=`gammaPullbackTopIso`, e₂=`gammaPullbackImageIso` (as `≃+`), σ/hf/semilin/tower from
   (b-flocus)/(c)/(d). **σ = `(ΓSpecIso R_s).symm` (RingEquiv) `≪≫ gammaImageRingEquiv j ⊤`; ModuleCat-R_s ↔
   Γ(Spec R_s,⊤) bridge is DEFEQ** (`analogies/quot-sigma-rebasing.md`; nudge stuck `rfl` with
   `ModuleCat.restrictScalars.smul_def`).
5. **keystone** `isLocalizedModule_basicOpen_descent` = instantiate `_of_basicOpen_cover` (DONE) at
   `exists_finite_basicOpen_cover_le_quasicoherentData` (DONE) with `Hfr` from TOP.
6. **gap1** `isIso_fromTildeΓ_of_isQuasicoherent` = one line via
   `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (DONE).

Discipline (CHURNING corrective): keystone-close-or-flag. Close gap1 OR stop+hand off the ONE precise
Mathlib-absent gap (name it + why). No silent feeder-defer (15th PARTIAL is out of tolerance).

Out of scope: 4 protected stubs; P2; SNAP.

## Lane 2 — FBC `_legs_conj` FINAL round (`Cohomology/FlatBaseChange.lean`, fine-grained)

Close `base_change_mate_fstar_reindex_legs_conj` (`_legs_conj`, sorry @~1822) via **Fallback B**: peel one
adjunction-layer at a time with `conjugateEquiv_symm_comp` + whiskering (recipe
`analogies/fbc-legs-conj-injective-route.md`), discharging each by conj-2b
(`base_change_mate_reindex_conj_pullbackLeg`) / conj-2c (`pushforwardCollapse`) / conj-2d
(`base_change_mate_reindex_conj_crossLayer`). Closes `gstar_transpose` @~2289.

NOT: one-shot reframing (iter-039 dead); element-`ext` (iter-035 dead); keyed `rw`/`simp`/`erw` on the
`X.Modules` diamond.

FINAL in-loop attempt. If it closes nothing → leave compiling partial layer-lemmas + escalate (TO_USER.md).
Out of scope: A2 @~2470, isIso @~2492.
