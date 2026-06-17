# Iter 039 — Objectives (Quot-Foundations)

## Lane 1 — FBC `_legs_conj` [fine-grained]
File: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
Chapter: `Cohomology_FlatBaseChange.tex`

Targets (in order):
1. `base_change_mate_reindex_conj_pullbackLeg` (conj-2b, `lem:...` @2124) — NEW decl. Anchors:
   `conjugateEquiv_leftAdjointCompIso_inv`, `conjugateEquiv_pullbackComp_inv` (Mathlib, verified),
   `pullbackComp_eq_leftAdjointCompIso` (project).
2. `base_change_mate_reindex_conj_crossLayer` (conj-2d, `lem:...` @2178) — NEW decl. Anchors:
   `unit_conjugateEquiv_symm` raised by `conjugateEquiv_comp` (Mathlib, verified),
   `base_change_mate_unit_value`, `gammaPushforwardIso`.
3. `base_change_mate_fstar_reindex_legs_conj` — discharge sorry @1700 via single-`conjugateEquiv`-component
   reframing (`.injective`/`.surjective`) + conj-2b + conj-2c (PROVED @1626) + conj-2d ⟹ `gstar_transpose`
   @2167 closes by its in-file recipe.

Kill-criterion: if (1)+(2) land but (3) doesn't close `_legs_conj` → escalate + fallback (no more conjugate
rounds). SUCCESS bar: conj-2b/2d compile even if (3) partial.

## Lane 2 — QUOT gap1 Hfr [mathlib-build]
File: `AlgebraicJacobian/Picard/QuotScheme.lean`
Chapter: `Picard_QuotScheme.tex`

Targets:
1. `isLocalizedModule_basicOpen_descent` (`lem:section_localization_descent`) — NEW gap1 keystone. Assemble
   `Hfr` from P1 `isIso_fromTildeΓ_basicOpen_of_quasicoherent` + `isLocalizedModule_restrict_of_isIso_fromTildeΓ`
   + three-pullback section isos (compose `gammaImageRingEquiv` σ_V's + `gammaPullbackImageIso_hom_semilinear`)
   + bridge (I) `isLocalizedModule_of_ringEquiv_semilinear` @1670 + bridge (II)
   `isLocalizedModule_restrictScalars_powers_algebraMap` @1720; instantiate
   `isLocalizedModule_basicOpen_descent_of_cover` @1626 at `exists_finite_basicOpen_cover_le_quasicoherentData`.
2. `isIso_fromTildeΓ_of_isQuasicoherent` (`lem:qcoh_affine_isIso_fromTildeΓ`, gap1) — one-liner via
   `isIso_fromTildeΓ_iff_isLocalizedModule_restrict`.

Critical path = step 1 (slice ↔ scheme-pullback `IsIso fromTildeΓ` transport). mathlib-build: axiom-clean,
NO sorry; if step 1 needs a new ingredient, build it + hand off precise residual.

## Not dispatched
- GR (`GrassmannianCells.lean`) — properness lane CLOSED; GR-quot/repr needs new-file scaffold + blueprint.
- GF (`FlatteningStratification.lean`) — gap1-gated (G1); G3 gap1-independent but needs blueprint+scaffold (Q6).
- FBC A2 @2348 — gated on an api-alignment consult; FBC `flatBaseChange_pushforward_isIso` @2370 — Čech leg.
