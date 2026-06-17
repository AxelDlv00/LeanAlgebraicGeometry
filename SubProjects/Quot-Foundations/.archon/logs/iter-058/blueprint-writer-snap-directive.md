Target: blueprint/src/chapters/Picard_SectionGradedRing.tex
Action: Add the two missing blueprint blocks that gate the SNAP presheaf-promotion prover (HARD-FAIL per iter-058 review). Math is carrier-independent; describe the mathematics only, no Lean tactics.

1. `def:relTensorTriplePresheaf` — `\lean{AlgebraicGeometry.Scheme.Modules.relTensorTriplePresheaf}`. The objectwise ℤ-tensor "triple" presheaf `(Opens X)ᵒᵖ ⥤ Ab`, `U ↦ Γ(U,P) ⊗_ℤ (𝒪_X(U) ⊗_ℤ Γ(U,Q))`, restriction = `⊗`-functoriality of the three underlying restriction maps. It is the DOMAIN ROW of the relative-tensor coequalizer. `\uses{lem:relativeTensor_as_coequalizer}`. One-line informal proof: functoriality of `TensorProduct.map` (`map_id`/`map_comp` by `⊗`-induction). Sibling of the existing `def:relTensorDomainPresheaf`.

2. `def:relTensorActL` — the LEFT-action natural transformation `relTensorTriplePresheaf ⟶ relTensorDomainPresheaf`, componentwise the objectwise `actLmap : Γ(U,P) ⊗_ℤ (𝒪_X(U) ⊗_ℤ Γ(U,Q)) → Γ(U,P) ⊗_ℤ Γ(U,Q)` collapsing the scalar action `m ⊗ (s ⊗ n) ↦ m ⊗ (s·n)`. Naturality = restriction-compatibility of the module action (`PresheafOfModules.map_smul`). One of the two parallel rows whose coequalizer presents `P ⊗_p Q`. `\uses{def:relTensorTriplePresheaf, def:relTensorDomainPresheaf, lem:relativeTensor_as_coequalizer}`.

3. `lem:snap_ztensor_whisker_localIso` (~line 443): add `\lean{}` pin if a Lean decl name is now known; else leave a `% NOTE:` that the Lean name is pending. Do NOT add `\leanok` (sync_leanok owns it).

Constraints: edit ONLY this chapter. No `\leanok`. Keep `\uses{}` accurate to what the construction needs. These are Archon-original infrastructure (no external source quote required).
