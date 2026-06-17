# Iter 029 — Objectives (per-lane detail)

## Lane 1 — FBC `Cohomology/FlatBaseChange.lean` [prove]
Close `base_change_mate_fstar_reindex_legs` @1445 via the term-mode mechanism (analogist `fbc-diamond`):
distribute (`_gammaDistribute`) → collapse the `pushforwardComp` Γ-factor with the SHIPPED
`base_change_mate_inner_eCancel_pushforwardComp` (abandon `hpfc`) spliced by `congrArg`/`.trans` →
splice the 3 atoms against the unfolded `codomain_read_legs` → `exact … .trans …` onto
`base_change_mate_inner_value`. Precedents: ~1144 / ~1304 / ~1534. Cascade → `gstar_transpose` @1817.
Riders: false "sorry-free" docstrings @1837/@1907; dead `hpfc` @~1431; de-`private` 3 atoms @1174/1182/1193.
Out of scope: affine @1995, FBC-B @2017.

## Lane 2 — QUOT `Picard/QuotScheme.lean` [mathlib-build]
Build `exists_isIso_fromTildeΓ_basicOpen_cover` (QuasicoherentData → basic-open refinement → finite
subcover → presentation transport across `D(g)≅Spec R_g`), then toward gap1
`isIso_fromTildeΓ_of_isQuasicoherent` (Mayer–Vietoris on `modulesSpecToSheaf.obj M`). gap1 ⟹ G1-core
one-liner. Blueprint `lem:exists_isIso_fromTildeΓ_basicOpen_cover` / `lem:qcoh_affine_isIso_fromTildeΓ`.
Axiom-clean, no sorry; STOP+handoff at the precise blocked step (likely the presentation transport).

## Lane 3 — GR `Picard/GrassmannianCells.lean` [mathlib-build]
Close `cocycle` (ring identity `Φ=id`, `IsLocalization.ringHom_ext` + reuse `cocycle_imageMatrix_eq`,
~30–50 LOC) → `theGlueData` → `Grassmannian.scheme := theGlueData.glued`. Diamond recipe on-file
(`erw` + `exact congrArg`/`Iso.inv_comp_eq`). Min bar: land `cocycle`. Blueprint `def:gr_glued_scheme`.
