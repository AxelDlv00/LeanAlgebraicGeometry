# Iter 004 — Objectives (per-task detail)

## Lane 1 — FBC-A : `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

Blueprint: `chapters/Cohomology_FlatBaseChange.tex`. Reference: Stacks "Affine base change".
Mate lemma `pushforward_base_change_mate_cancelBaseChange` is already a proved assembly consuming
the single L4 leaf. Close L4's effort-broken chain:

- **L4-a** `base_change_mate_regroupEquiv` (`lem:base_change_mate_regroupEquiv`) — `R'`-linear iso
  `(A⊗_R R')⊗_A M ≅ R'⊗_R M` = `comm ≪≫ cancelBaseChange ≪≫ comm`. Pure tensor algebra; CLOSE.
  [verified] `TensorProduct.AlgebraTensorModule.cancelBaseChange`, `…AlgebraTensorModule.comm`.
- **L4-b** `base_change_mate_generator_trace_eq` (`lem:base_change_mate_generator_trace_eq`) —
  conjugate `Θ_tgt∘Γ(α)∘Θ_src⁻¹` sends `r'⊗m ↦ (r'⊗1)⊗m` = `regroupEquiv.symm`. The 3-step
  adjoint-mate trace. The hard piece — attempt, leave real partial if stuck (re-break candidate).
- **L4-c** `base_change_mate_generator_trace` (`lem:base_change_mate_generator_trace`, unchanged pin)
  — IsIso corollary: rw L4-b; LinearEquiv ⟹ iso. Auto-closes the mate lemma.
- **Then** `affineBaseChange_pushforward_iso` — assembly via `lem:modules_isIso_iff_affineOpens` +
  `lem:base_change_map_affine_local` (proved) + mate lemma + tilde dicts. Attempt; partial OK (the
  per-open identification is the heavy bit → next-iter effort-break candidate).
- Deferred: `flatBaseChange_pushforward_isIso` (FBC-B).

## Lane 2 — GF-alg : `AlgebraicJacobian/Picard/FlatteningStratification.lean` (`GenericFreeness`)

Blueprint: `chapters/Picard_FlatteningStratification.tex`. Reference: Nitsure §4 (src L1711–1772).

- **L3-a** `exact_localizedModule_powers_of_shortExact` (`lem:gf_splice_shortExact_localized_exact`)
  — localised SES exact via `LocalizedModule.map_exact` [expected name; prover confirms].
- **L3-b** `free_localizationAway_of_free_of_eq_mul` (`lem:gf_splice_shortExact_free_transport`) —
  `f=f'f''`, `N_{f'}` free ⟹ `N_f` free. Ring-side `IsLocalization.Away.mul`.
- **L3-c** `free_of_shortExact_of_free_free` (`lem:gf_splice_shortExact_split`) — free ends ⟹ split
  ⟹ free middle.
- **L3 assembly** `exists_free_localizationAway_of_shortExact` (`lem:gf_splice_shortExact`) — pick
  `f:=f'f''`; L3-a → L3-b×2 → L3-c. Replace body sorry.
- **L4 re-sign** `exists_localizationAway_finite_mvPolynomial` (`lem:gf_noether_clear_denominators`)
  to the AlgHom target in the chapter `% LEAN SIGNATURE` block; prove via `exists_finite_inj_algHom_of_fg`
  (`\mathlibok` `lem:noether_normalization_fg`) + denominator-clearing. Re-sign required; partial OK
  (re-sign alone ≠ sorry-elimination — review note).
- **L5 d≥1** `exists_free_localizationAway_polynomial` (`lem:gf_polynomial_core`) — generic-rank
  dévissage SES, IH on torsion quotient, splice via L3. Attempt; partial OK. (d=0 already proved.)
- **Assembly** `genericFlatnessAlgebraic` residue — wire only if L3/L4/L5 land (instance
  reconciliation `Module A N` via `algebraMap A B` vs `Module B N`). Else leave as-is.
- Deferred: `genericFlatness` (GF-geo).

## Disproof / soundness checks
- No new hard statement introduced this iter; all targets are decompositions of already-vetted
  parents (FBC mate lemma, GF dévissage) whose blueprints the reviewer passed complete+correct.
  No counterexample pass needed (no signature is suspected false — the GF L4 re-sign tightens, not
  weakens; FBC L4 chain conserves the mate-lemma mathematics per effort-breaker).

## QUOT prep (non-prover, banked this iter)
- `analogies/quot-predicates.md` + new `Picard_QuotScheme.tex` blocks (`def:modules_annihilator`,
  `def:schematic_support`, `def:has_proper_support` + `\mathlibok` `lem:isProper_mathlib`,
  `def:is_locally_free_of_rank`). Next QUOT step: `[prover-mode: mathlib-build]` builds these.
