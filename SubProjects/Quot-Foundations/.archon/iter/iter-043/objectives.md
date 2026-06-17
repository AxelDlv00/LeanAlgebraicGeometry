# Iter 043 — Objectives detail

## Lane 1 — FBC tilde-transport (FlatBaseChange.lean) [mathlib-build]
- **sections_direct** (NEW): `Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt = cancelBaseChange⁻¹` on `R'⊗_R M`. Unfold
  `pushforwardBaseChangeMap` def; eval units/counits via tilde dictionaries (`pullback/pushforward_spec_tilde_iso`,
  `base_change_mate_domain_read` @737 / `_codomain_read` @773); `TensorProduct.induction_on`; endpoint =
  `cancelBaseChange_symm_tmul`. Blueprint `lem:pushforward_base_change_mate_sections_direct` @3286.
- **cancelBaseChange** (@2414): re-prove via sections_direct → axiom-clean, off `gstar_transpose`.
- Out: affineBaseChange_pushforward_iso (2496, FBC-A2-gated), flatBaseChange (2518, Čech), dead conjugate
  decls (1848/2315 — cleanup later). Reversal: re-derives mate → escalate.

## Lane 2 — QUOT close gap2 (QuotScheme.lean) [mathlib-build]
- **Piece A `isQuasicoherent_pullback_fromSpec`** (NEW, Mathlib-absent): QC under pullback along `hU.fromSpec`.
  `(pullback fromSpec).obj M = (pullback isoSpec.inv).obj ((pullback U.ι).obj M)`; build `QuasicoherentData`
  for `(pullback U.ι).obj M` from `q` by `{U ⊓ q.X i}` cover + slice-presentation pullback
  (`SheafOfModules.Presentation.map` + `pullbackObjFreeIso`); reuse `presentationPullbackιOfQuasicoherentData`/
  `overRestrictPresentation`; NEW step = refine `q` to a cover of `U`. Blueprint `lem:qcoh_pullback_fromSpec`.
  WATCH: resists → flag precise sub-step (no silent defer).
- **gap2 `isLocalizedModule_basicOpen`**: `section_localization_hfr_aux_general` @ `j = hU.fromSpec` (hP1 = Piece
  A + gap1) + eqToHom bridge to `restrictBasicOpenₗ` via `isLocalizedModule_of_ringEquiv_semilinear`,
  `ρ := (X.presheaf.mapIso (eqToHom eT.symm).op).commRingCatIsoToRingEquiv`, `ρF=f` = crux
  `fromSpec_image_top_section_coherence`. Shapes: iter-042 hand-off Piece B.

## Deferred this iter (ready iter-044+)
- GF-G1 (gap2-gated; import QuotScheme + build gf_qcoh_fintype_finite_sections) → G3 → genericFlatness 2264.
- QUOT annihilator (needs gap2 + blueprint block), P2 (same file as gap2). FBC-A2 (consult first), FBC-B (scaffold).
- SNAP tensor-powers (Mathlib-gradient + Q1 ref-retrieve), GR-quot/repr (new chapter).
