Target: blueprint/src/chapters/Picard_FlatteningStratification.tex

Action: Add 4 missing lemma blocks (coverage debt — these Lean decls are PROVED axiom-clean but
have no blueprint entry) and wire them into the `thm:generic_flatness` STEP-4/flatV proof `\uses{}`.
These are Archon-original transport helpers (no external source — omit SOURCE/SOURCE QUOTE lines).
Each block: statement in project notation, `\label{}`, `\lean{}`, accurate `\uses{}`, ≥1-line informal proof.

1. `\label{lem:gf_flat_isLocalizedModule_sameBase}` `\lean{AlgebraicGeometry.gf_flat_isLocalizedModule_sameBase}`
   — B1′, model-free variant of `lem:gf_flat_localizedModule_sameBase` (which it `\uses`). Given any
   `IsLocalizedModule T φ` model N' of a source localization over the scalar tower R→B→N, if N is
   flat over R then N' is flat over R. Proof: `IsLocalizedModule.iso` to the canonical model +
   `Module.Flat.of_linearEquiv`. (Distinct lemma from `gf_flat_localizedModule_sameBase`; do NOT
   repoint that block's pin.)

2. `\label{lem:flat_of_ringEquiv_semilinear}` `\lean{AlgebraicGeometry.flat_of_ringEquiv_semilinear}`
   — flatness analogue of `lem:module_free_of_ringEquiv` (`\uses` it). Flatness transfers across a
   ring iso e : R ≃+* R' and a compatible e-semilinear additive iso l : M ≃+ M' (l(r•x)=e(r)•l(x)).
   Proof: M' is the base change R' ⊗[R] M (l lifts to an R'-linear equiv, inverse y ↦ 1 ⊗ l⁻¹ y), so
   `Module.Flat.isBaseChange` descends flatness.

3. `\label{lem:flat_localization_models}` `\lean{AlgebraicGeometry.flat_localization_models}`
   — model-independence of localization flatness: two models Mₛ,Mₛ' of M localized at S (over Rₛ,Rₛ')
   satisfy Mₛ flat/Rₛ ⟹ Mₛ' flat/Rₛ'. Proof: `IsLocalization.algEquiv` + `IsLocalizedModule.linearEquiv`
   are semilinear; apply `lem:flat_of_ringEquiv_semilinear`. (`\uses{lem:flat_of_ringEquiv_semilinear}`.)

4. `\label{lem:isLocalizedModule_powers_restrictScalars}` `\lean{AlgebraicGeometry.isLocalizedModule_powers_restrictScalars}`
   — scalar-tower descent: if φ : M →ₗ[B] N exhibits N as localization of M at powers(algebraMap A B f),
   then φ.restrictScalars A exhibits N as localization of M (as A-module) at powers f. Proof: scalar-tower
   agreement of the two actions.

Then add `\uses{lem:gf_flat_isLocalizedModule_sameBase, lem:flat_of_ringEquiv_semilinear,
lem:flat_localization_models, lem:isLocalizedModule_powers_restrictScalars}` to the `thm:generic_flatness`
proof block (STEP-4/flatV).

Constraints: edit ONLY this chapter. Do NOT add/remove `\leanok`. Do NOT touch other blocks' pins.
Place the 4 blocks near the existing B1 section (`lem:gf_flat_localizedModule_sameBase`).
