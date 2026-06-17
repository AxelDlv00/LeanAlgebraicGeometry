# Iter 003 — Objectives (per-lane attempt detail)

## Lane FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

Scaffold + prove the 4-lemma mate chain (effort-breaker `fbc-mate`); blueprint blocks in
`Cohomology_FlatBaseChange.tex`. Order: L1 → L2 → L3 → L4 → mate assembly → affine iso.

- L1 `pullback_fst_snd_specMap_tensor` (crux, eff 961, ready): cone legs = Spec of tensor
  inclusions via `pullbackSpecIso`. Only Mathlib-absent content = `Spec.map φ ↔ Spec.map (algebraMap)`.
- L2 `base_change_mate_domain_read` (eff 850, ready): `Γ(g^*(f_*M̃)) ≅ R'⊗_R M` via tilde dicts.
- L3 `base_change_mate_codomain_read` (eff 1336): `Γ(f'_*(g')^*M̃) ≅ (R'⊗_R A)⊗_A M`; uses L1.
- L4 `base_change_mate_generator_trace` (eff 2011): `r'⊗m ↦ (r'⊗1)⊗m`; uses L2, L3.
- Assemble `pushforward_base_change_mate_cancelBaseChange` (IsIso(Γα) via `cancelBaseChange_symm_tmul`),
  then `affineBaseChange_pushforward_iso` (via the already-proved `base_change_map_affine_local`).
- Deferred: `flatBaseChange_pushforward_isIso` (FBC-B). Fine-break L4 next iter if it stalls.

## Lane GF-alg — `AlgebraicJacobian/Picard/FlatteningStratification.lean` (`GenericFreeness`)

Scaffold + prove the 5-lemma dévissage chain (effort-breaker `gf-devissage`); blueprint blocks in
`Picard_FlatteningStratification.tex`. Order: L1 → L3 → L4 → L5 → dévissage assembly.

- L1 `exists_free_localizationAway_of_torsion` (eff 591, ready, deps 0).
- L3 `exists_free_localizationAway_of_shortExact` (eff 611, ready, deps 0).
- L4 `exists_localizationAway_finite_mvPolynomial` (eff 1000, ready): Noether normalisation
  (`exists_finite_inj_algHom_of_fg`) + clear denominators.
- L5 `exists_free_localizationAway_polynomial` (core, eff 1449, Mathlib-absent): finite module over
  `A[X₁..X_d]` generically free; d-induction; uses L1, L3, finite leaf. The one true hand-built block.
- Assemble `genericFlatnessAlgebraic` residue: prime filtration
  (`induction_on_isQuotientEquivQuotientPrime`) → L4 → L5 → finite leaf.
- Reuse axiom-clean `exists_free_localizationAway_of_{finite,moduleFinite}`.
- Secondary (no churn): `genericFlatness` GF-geo wrapper. Fine-break L5 next iter if it stalls.

## Disproof check (not run)

Both targets verified SOUND by the strategy-critic directly against Nitsure §4 (GF) and Stacks
02KH (FBC) source files; no false-statement risk. The GF primary case is already closed
axiom-clean, and the FBC `base_change_map_affine_local` is proved — the residues are genuine
Mathlib gaps, not statement bugs. No disproof pass warranted.
