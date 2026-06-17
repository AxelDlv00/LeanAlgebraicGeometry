# Iter 042 — Objectives detail

## Lane 1 (prover this iter): QuotScheme.lean — gap1 consumers [mathlib-build]

### (1) G1-core — `isLocalizedModule_basicOpen_of_isQuasicoherent`
- Blueprint: `lem:qcoh_affine_section_localization` (Picard_QuotScheme.tex), gate-cleared `quot-recheck`.
- Statement: `Spec R`, `[M.IsQuasicoherent]`, `f : R` ⟹ `IsLocalizedModule (powers f)` on the restriction
  `Γ(M,⊤) → Γ(M,D(f))`.
- Proof (one line): `isLocalizedModule_restrict_of_isIso_fromTildeΓ M.fromTildeΓ
  (isIso_fromTildeΓ_of_isQuasicoherent hqc)`. Both ingredients axiom-clean iter-041.

### (2) gap2 — `isLocalizedModule_basicOpen`
- Blueprint: `lem:qcoh_section_localization_basicOpen` (Picard_QuotScheme.tex), gate-cleared.
- General scheme `X`, affine open `U`, quasi-coherent `M`. **Single-chart transport** (U fixed affine):
  apply G1-core on `Spec Γ(X,U)`, transport the `IsLocalizedModule` across `U ≅ Spec Γ(X,U)` via
  `IsLocalizedModule.linearEquiv` [verified in Mathlib]. No cover-and-glue.
- If the affine-iso transport needs a Mathlib-absent packaging lemma, build it axiom-clean and hand off
  precisely (the `\uses{}` was flagged thin) — do NOT sorry-pin gap2.

### Discipline
- mathlib-build: axiom-clean or absent; no typed-sorry pins.
- Term-mode only under the `X.Modules` diamond (`.trans`/`congrArg`/applied `map_smul`); NEVER positional
  `rw`/`simp`/`erw`.
- Out of scope: 4 protected stubs, P2, annihilator reverse inclusion, SNAP.

## Lane 2 (blueprint only this iter; prover iter-043): FBC tilde-transport
- Blueprint authored: `lem:pushforward_base_change_mate_sections_direct` + revised
  `lem:pushforward_base_change_mate_cancelBaseChange` proof + re-pointed `lem:affine_base_change_pushforward`
  `\uses{}` (no longer depends on `gstar_transpose`/`section_identity`).
- iter-043 prover [mathlib-build]: build the direct lemma (`TensorProduct.induction_on` unfolding the
  `pushforwardBaseChangeMap` adjunction def), close `cancelBaseChange`, `affineBaseChange_pushforward_iso`,
  `flatBaseChange_pushforward_isIso`. MUST dispatch (progress-critic).

## Deferred (iter-043+)
- GF-G1 (`FlatteningStratification.lean`): add `import …Picard.QuotScheme`, then
  `gf_qcoh_fintype_finite_sections` = G1-core application. Parallel with the FBC lane.
- QUOT annihilator reverse inclusion (needs gap2 + a block); P2 (needs a block); FBC-A2 (consult first).
- SNAP `def:sectionGradedRing` tensor-powers (Mathlib-gradient); GR-quot/GR-repr (new files, scaffold).
