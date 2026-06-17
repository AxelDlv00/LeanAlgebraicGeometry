# Iter-030 objectives (detail)

## Lane A — FreePresheafComplex.lean [mathlib-build] — re-parameterize to a raw finite family
- Goal: family-form resolution chain `{ι}[Finite ι](U : ι → Opens X)`, carrying the proofs; preserve every
  `X.OpenCover`-named def/lemma CechBridge consumes as a thin wrapper (`:= …Fam (coverOpen 𝒰)`), defeq-preserving.
- Decls to family-parameterize (carry proofs on the family version): `coverInterOpen`, `cechFreeSimplicial`,
  `cechFreePresheafComplex`, `cechFreeAug`, `coverStructurePresheaf`, `cechFreeComplexAug`, eval engine
  (`cechFreeEval_X`, `freeYonedaEval_iso_of_le`, `cechFreeEvalDropZeros`, `survivingEquiv`,
  `cechFreeEvalEngine_X`, `cech_free_eval_prepend_homotopy`, …), up to **`cechFreeComplex_quasiIso`**.
- UNCHANGED: `freeYoneda`/`freeYonedaAug`/`freeYonedaHomEquiv`/`freeYonedaHomAddEquiv` (take an open).
  `coverOpen (𝒰 : X.OpenCover) i := (𝒰.f i).opensRange` STAYS (only `𝒰.f` use).
- Substitution: `𝒰.I₀ ↦ ι`, `coverOpen 𝒰 ↦ U`, `coverInterOpen 𝒰 σ ↦ ⨅ k, U (σ k)`.
- ACCEPTANCE: `lake env lean` EXIT 0 on BOTH FreePresheafComplex.lean AND CechBridge.lean (CechBridge NOT edited).
  Axiom-clean. No sorry. Hand off family-version names for next iter's CechBridge lane.
- Recipe: `analogies/reparam.md` (target #4); strategy-critic `iter030` stalkwise-exactness proof.

## Lane B — QcohTildeSections.lean [mathlib-build] — 01I8 global generation
- Goal: instance `[IsQuasicoherent F] : IsIso F.fromTildeΓ` (on `Spec R`), upgrading `qcoh_iso_tilde_sections`
  to the unconditional qcoh form.
- 3-step: (1) global epi `free I ⟶ F` (`F.GeneratingSections`) from `QuasicoherentData` local presentations +
  `Spec R` compactness + localisation-of-sections — THE genuine blocker (~few-hundred LOC); (2) kernel qcoh ⟹
  `F.Presentation`; (3) `isIso_fromTildeΓ_of_presentation`.
- ACCEPTANCE: axiom-clean, no sorry; if blocked on step-1 gluing, hand off a NEW sub-decomposition (not a
  relabel of the same gap — progress-critic iter-031 STUCK watch). Flag final names.
- Recipe: `rem:o1i8_decomposition` + `lem:qcoh_iso_tilde_sections_of_presentation` (chapter).

## Not dispatched this iter (gated)
- CechBridge.lean (family `injective_cech_acyclic` + `sectionCechComplexMapOpIso`) — next iter, after Lane A.
- AffineSerreVanishing.lean (`affine_surj_of_vanishing` via local-surjectivity; `affineCoverSystem`;
  `affine_cech_vanishing_qcoh`; top `affine_serre_vanishing`) — next iter, after CechBridge family.
