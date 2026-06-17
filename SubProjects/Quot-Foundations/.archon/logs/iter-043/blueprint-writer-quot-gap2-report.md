# Blueprint Writer Report: quot-gap2
**Status:** COMPLETE

## Changes (Picard_QuotScheme.tex)
- Add `lem:modules_restrict_linear` (`Scheme.Modules.restrictₗ`): Γ(X,U)-linear section restriction (compHom codomain).
- Add `lem:modules_restrict_basicOpen_linear` (`Scheme.Modules.restrictBasicOpenₗ`): scalar-tower basic-open form; `\uses` restrict_linear.
- Add `lem:fromSpec_image_top_section_coherence` (`...fromSpec_image_top_section_coherence`): ρ(σf)=f crux; `\uses` def:gamma_image_ring_equiv.
- Add `lem:section_localization_hfr_aux_general` (`...section_localization_hfr_aux_general`): gap2-core transport; `\uses` gamma_pullback_image_iso(+semilinear/naturality), gamma_image_ring_equiv, isLocalizedModule_restrict_of_isIso_fromTildeΓ, isLocalizedModule_ringEquiv_semilinear, restrict_linear.
- Add `lem:qcoh_pullback_fromSpec` (`...isQuasicoherent_pullback_fromSpec`, Piece A, `% NOTE` Mathlib-absent): QC preserved under pullback along fromSpec; 2-step route (isoSpec.inv∘ι factor → QuasicoherentData by cover-refine {U⊓q.X i}); `\uses` over_restrict_presentation, presentation_pullback_iota_of_quasicoherentData, presentation_map_mathlib, modules_pullback_mathlib, isQuasicoherent_quasicoherentData_mathlib.
- Rewrite gap2 proof (`lem:qcoh_section_localization_basicOpen`): dropped "sole genuinely new piece"; route now instantiates `section_localization_hfr_aux_general` at j=fromSpec (hP1 via Piece A + gap1 `lem:qcoh_affine_isIso_fromTildeΓ`), bridges via `fromSpec_image_top_section_coherence`. Updated statement+proof `\uses{}`.
- leandag: 0 unknown_uses; my 5 labels non-isolated; the 2 isolated nodes are pre-existing (annih…, gr_de…).

## Notes / Strategy
- `lem:qcoh_pullback_fromSpec` is unmatched_lean (expected: Piece A Lean decl not yet built — new gap). Other 4 match existing Lean.
- `Scheme.Modules.map_smul` (used in both restrict-linear proofs) has NO blueprint anchor; referenced in prose only. Plan agent: consider a Mathlib/aux anchor if DAG strictness wants it.
- Piece A `\lean{}` name is the suggested `isQuasicoherent_pullback_fromSpec`; prover may rename.
