# Lean ↔ Blueprint Check Report

## Slug
lvb-csi-iter062

## Iteration
062

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (Section: Sub-brick A decomposition, ~lines 7463–8466; OpenImm section ~lines 9680–9960)

---

## Per-declaration

### `\lean{CategoryTheory.widePullback_overX_isLimit, CategoryTheory.widePullback_overX_eq_prod}` (chapter: `lem:widePullback_overX_eq_prod`)
- **Lean target exists**: yes (both non-private, axiom-clean)
- **Signature matches**: yes
- **Proof follows sketch**: yes (slice-product = wide fibre power via limit fan; recursion noted)
- **Notes**: Blueprint has no statement-block `\leanok` (consistent: blueprint block exists but without marker — the sync script may have missed it, or the abstract `CategoryTheory` block uses a loose statement marker protocol). Informational only.

### `\lean{CategoryTheory.FinitaryPreExtensive.prod_coproduct_distrib, CategoryTheory.FinitaryPreExtensive.coprodFirst_distrib}` (chapter: `lem:prod_coproduct_distrib`)
- **Lean target exists**: yes (both axiom-clean; `pcd_hom_fst`, `pcd_hom_snd`, `cf_hom_fst` present as compatibility lemmas)
- **Signature matches**: yes
- **Proof follows sketch**: yes (uses `isIso_sigmaDesc_fst` via `FinitaryPreExtensive.isIso_sigmaDesc_fst` and pullback-symmetry)
- **Notes**: `pcd_hom_fst`/`pcd_hom_snd`/`cf_hom_fst` and `overSigma_hom_eq` are bundled in the `\lean{...}` list for `lem:overProd_coproduct_distrib`; that is correct.

### `\lean{CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib, ...}` (chapter: `lem:overProd_coproduct_distrib`)
- **Lean target exists**: yes (axiom-clean; right-handed twin `overProd_coproduct_distrib_right` also present)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: none

### `\lean{CategoryTheory.FinitaryPreExtensive.coproduct_fibrePower_reindex}` (chapter: `lem:coproduct_fibrePower_reindex`)
- **Lean target exists**: yes (axiom-clean)
- **Signature matches**: yes
- **Proof follows sketch**: yes (sigma-sigma flatten + Fin.consEquiv reindex)

### `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso_zero}` (chapter: `lem:coproduct_distrib_fibrePower_zero`)
- **Lean target exists**: yes (axiom-clean, statement block has `\leanok`)
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso, ...}` (chapter: `lem:coproduct_distrib_fibrePower`)
- **Lean target exists**: yes (axiom-clean; uses `set_option maxHeartbeats 1600000`)
- **Signature matches**: yes
- **Proof follows sketch**: yes (induction on p; uses `prodFinSuccIso`, `overProd_coproduct_distrib`, `coproduct_fibrePower_reindex`)

### `\lean{AlgebraicGeometry.widePullback_openImm_inter, AlgebraicGeometry.coverArrowOverSigmaIso, ...}` (chapter: `lem:widePullback_openImm_inter` + cover arrow)
- **Lean target exists**: yes (`widePullback_openImm_inter`, `coverArrowOverCofan`, `coverArrowOverIsColimit`, `coverArrowOverSigmaIso` all present and axiom-clean)
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.cechBackbone_obj_widePullback}` (chapter: `lem:cechBackbone_obj_widePullback`)
- **Lean target exists**: yes (axiom-clean; `:= Iso.refl _`, correct for a definitional unfolding)
- **Signature matches**: yes
- **Proof follows sketch**: yes (pure unfolding, `rfl`-level)

### `\lean{AlgebraicGeometry.cechBackbone_left_sigma, AlgebraicGeometry.coverInterProdIso, AlgebraicGeometry.widePullbackBaseCongr}` (chapter: `lem:cech_backbone_left_sigma`)
- **Lean target exists**: yes (all three present and axiom-clean)
- **Signature matches**: yes
- **Proof follows sketch**: yes (universe-reduction reindex → `widePullbackBaseCongr` → `widePullback_coproduct_iso` → `coverInterProdIso`)
- **Notes**: This was the hard leaf; now closed axiom-clean (per memory iter-060 and Lean source).

### `\lean{AlgebraicGeometry.isIso_modules_of_toPresheaf}` (chapter: `lem:isIso_modules_of_toPresheaf`)
- **Lean target exists**: yes (axiom-clean; `theorem` not `lemma`, blueprint has `\leanok`)
- **Signature matches**: yes
- **Proof follows sketch**: yes (iso-reflection via `isIso_of_reflects_iso`)

### `\lean{AlgebraicGeometry.pushPull_binary_coprod_prod, AlgebraicGeometry.isIso_prodLift_of_isLimit, AlgebraicGeometry.coprodDecompMap}` (chapter: `lem:pushPull_binary_coprod_prod`)
- **Lean target exists**: **NO** — `pushPull_binary_coprod_prod` is absent from the Lean project (only mentioned in inline comments, lines 673/689/698 of CSI). `isIso_prodLift_of_isLimit` and `coprodDecompMap` exist as `private` helpers, but the named public declaration does not exist.
- **Signature matches**: N/A (absent)
- **Proof follows sketch**: N/A
- **Notes**: **MUST-FIX.** The blueprint `\lean{...}` names a declaration that doesn't exist. The blueprint has no statement-block `\leanok` (correct: nothing to mark). The CSI file's large `/-` comment block (lines 666–701) documents the planned construction in detail (chain iso via `coprodDecompMap`, per-leg coherence (★), KEY DEFEQ `pushforwardComp` is identity-on-objects) but the declaration itself is not built. This is the sole blocker of the entire Sub-brick A chain.

### `\lean{AlgebraicGeometry.pushPull_coprod_prod}` (chapter: `lem:pushPull_coprod_prod`)
- **Lean target exists**: **NO** — absent from all Lean files in the project.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: **MUST-FIX.** Blueprint names a declaration that doesn't exist. Blueprint has no statement-block `\leanok`. Blocked on `pushPull_binary_coprod_prod`; proof is simple induction over the binary case.

### `\lean{AlgebraicGeometry.pushPull_sigma_iso}` (chapter: `lem:pushPull_sigma_iso`)
- **Lean target exists**: yes (`:= sorry`, line 810)
- **Signature matches**: yes — `pushPullObj F ((coverCechNerveOver 𝒰).obj (op (mk p))) ≅ ∏ᶜ fun σ => pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))` matches the blueprint formula.
- **Proof follows sketch**: N/A (sorry)
- **Notes**: Statement-block `\leanok` correct (sorry present). Proof is trivial once `pushPull_coprod_prod` exists (one-line: apply `cechBackbone_left_sigma` + `pushPull_coprod_prod`). Blocked only on missing predecessors.

### `\lean{AlgebraicGeometry.pushPull_leg_sections}` (chapter: `lem:pushPull_leg_sections`)
- **Lean target exists**: yes (axiom-clean)
- **Signature matches**: yes — `presheaf.obj (op V) ≅ presheaf.obj (op (coverInterOpen 𝒰 σ ⊓ V))` at Ab level matches `Γ(V, pushPullObj) ≅ Γ(U_σ ∩ V, F)`.
- **Proof follows sketch**: yes (three-step chain: pushforward-sections-are-preimage-sections → restrictFunctorIsoPullback → image-preimage identity)
- **Notes**: Statement-block `\leanok` correct. DONE.

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`)
- **Lean target exists**: yes (`:= sorry`, line 901)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (sorry)
- **Notes**: Statement-block `\leanok` correct (sorry present). Blocked on `pushPull_sigma_iso`.

### `\lean{AlgebraicGeometry.cechSection_complex_iso, AlgebraicGeometry.sectionCechComplexV}` (chapter: `lem:cechSection_complex_iso`)
- **Lean target exists**: yes (`:= sorry`, line 971; `sectionCechComplexV` as axiom-clean `abbrev`)
- **Signature matches**: yes — takes explicit `ε` and `hε`, returns `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε`; matches blueprint "augmented form" NOTE.
- **Proof follows sketch**: N/A (sorry)
- **Notes**: **STALE-ABSENT `\leanok`**: declaration exists as sorry but the statement block has NO `\leanok` — `sync_leanok` should add it. Blueprint `% NOTE` about "augmented form" is correct and not stale. Blocked on `pushPull_eval_prod_iso`.

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`)
- **Lean target exists**: yes (`:= sorry`, line 1030)
- **Signature matches**: yes — `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0` matches blueprint "augmented form".
- **Proof follows sketch**: N/A (sorry; proof sketch is adequate — see Blueprint Adequacy below)
- **Notes**: Statement-block `\leanok` correct. Blocked on `cechSection_complex_iso`.

### `\lean{AlgebraicGeometry.sliceStructureSheafHom}` (chapter: `lem:slice_structureSheaf_hom`, OpenImm section)
- **Lean target exists**: yes — `OpenImmersionPushforward.lean` has `sliceStructureSheafHom` (non-private, axiom-clean), plus both `IsRightAdjoint` instances.
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: **STALE NOTE** — blueprint line 9804 says `% NOTE: build target. The Lean declaration does not exist yet.` This is FALSE: the declaration is now axiom-clean. Blueprint `\leanok` on statement block is correct.

### `\lean{AlgebraicGeometry.pushforwardSlicePullbackIso}` (chapter: `lem:pushforward_slice_pullback_iso`, OpenImm section)
- **Lean target exists**: no — `pushforwardSlicePullbackIso` appears only in inline comments of `OpenImmersionPushforward.lean` (lines 655, 659), not as a `def`/`theorem`.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint `% NOTE: build target. The Lean declaration does not exist yet.` is CURRENT. See Blueprint Adequacy section — the proof sketch is **incorrect/incomplete** for general H.

---

## Red Flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.pushPull_sigma_iso` (CSI line 810): `:= sorry`. Blueprint claims a substantive proof (trivial once predecessors exist, but predecessor `pushPull_coprod_prod` is absent).
- `AlgebraicGeometry.pushPull_eval_prod_iso` (CSI line 901): `:= sorry`. Downstream of `pushPull_sigma_iso`.
- `AlgebraicGeometry.cechSection_complex_iso` (CSI line 971): `:= sorry`. Downstream.
- `AlgebraicGeometry.cechSection_contractible` (CSI line 1030): `:= sorry`. Downstream.
- `higherDirectImage_openImmersion_acyclic` (`OpenImmersionPushforward.lean` line 670): `:= sorry` in the `hqc` branch — blocked on `pushforwardSlicePullbackIso`. This is the lone sorry in OpenImm's main theorem.

### Excuse-comments
- CSI lines 666–701: Large `/-` comment block describing `pushPull_binary_coprod_prod` and its planned construction but no actual declaration follows. The comment contains the text "**Remaining for L2 `pushPull_binary_coprod_prod`**" — this is a planner-strategy comment, not a red-flag excuse-comment, but it documents a known-absent declaration.

### Axioms / Classical.choice on non-trivial claims
- None found. The file is axiom-free (all sorries in the 4 open stubs).

---

## Unreferenced declarations (informational)

The following are present in CSI but not `\lean{...}`-referenced by the blueprint (all private or pure-categorical helpers):

- `CategoryTheory.FinitaryPreExtensive.prodFinSuccIso` — finite-product-split helper for `widePullback_coproduct_iso` induction. Worth promoting to blueprint if Mathlib PR is planned, but acceptable as local helper.
- `CategoryTheory.FinitaryPreExtensive.overSigmaDescIsColimit` — colimit universality for the descent map. Blueprint references it implicitly through `overSigmaDescIso`'s `\lean{}` block.
- `AlgebraicGeometry.mem_iInf_opens_of_finite` (private) — membership lemma for `widePullback_openImm_inter`. Pure helper.
- `AlgebraicGeometry.isIso_map_prodLift_of_isLimit` (private) — ModuleCat-level iso reflection; used by `isIso_coprodDecompMap` but not independently referenced. Acceptable.
- `AlgebraicGeometry.BinaryDecomp` section helpers (`coprodDecompMap`, `isIso_coprodDecompMap`, `isIso_prodLift_of_isLimit`) — all private and bundled under `lem:pushPull_binary_coprod_prod`'s `\lean{...}` list. Acceptable.
- `AlgebraicGeometry.widePullbackBaseCongr` — listed in `lem:cech_backbone_left_sigma`'s `\lean{...}` block. Already covered.

No unreferenced substantive public declarations.

---

## Blueprint adequacy for this file

- **Coverage**: Of the 8 substantive public declarations in CSI, 8 have a corresponding `\lean{...}` blueprint block (coverage 100%). Private helpers are bundled or implicitly covered. Missing: `pushPull_binary_coprod_prod` and `pushPull_coprod_prod` appear in the blueprint's `\lean{...}` lists but are absent from the Lean file — the BLUEPRINT is ahead of the Lean (declarations named but not built).

- **Proof-sketch depth**: **adequate** for all currently-sorryed CSI declarations (`pushPull_sigma_iso`, `pushPull_eval_prod_iso`, `cechSection_complex_iso`, `cechSection_contractible`). Each blueprint proof block gives a clean 2–4 step assembly sketch that faithfully guides the Lean construction. The Lean file's inline planner-strategy comments supplement the blueprint with Lean-specific implementation details (adapter types, instance paths). No blueprint block is under-specified for these.

  - `lem:pushPull_binary_coprod_prod` proof sketch: **adequate** for the Lean work, especially combined with its `% NOTE` block documenting the instance trap and Ab→ModuleCat bridge. The CSI inline comment (lines 666–701) adds the canonical definition target (`asIso (prod.lift ...)`) and the KEY DEFEQ observation (`pushforwardComp` is identity-on-objects). The blueprint gives enough to guide a prover.

  - `lem:pushforward_slice_pullback_iso` proof sketch: **under-specified / incorrect** for the general case. See below.

- **Hint precision**: **precise** for all CSI-file declarations.

- **Generality**: **matches need** for all CSI declarations.

### Recommended chapter-side actions (blueprint-writing subagent)

1. **MUST-FIX (OpenImm, `lem:pushforward_slice_pullback_iso`)**: The current proof states "First, `pullbackObjUnitToUnit ψ_r` is an isomorphism because F is final; it identifies `(pullback ψ_r).obj` of the slice with the pushforward". This is correct only for the *unit module*. For general H the blueprint omits the key step. The `OpenImmersionPushforward.lean` inline comment (lines 661–668) documents the correct route: use `Adjunction.leftAdjointUniq` to show `pullback ψ_r ≅ pushforward φ''` (where `φ'' = sliceStructureSheafHom U.isoSpec.symm Vᵢ`), then compose with the section-identity iso `pushforward φ'' (H.over Uᵢ) ≅ (Φ H).over Vᵢ` (an `rfl`-level identity via `pushforward_obj_obj`). The blueprint proof should be rewritten to describe this `leftAdjointUniq` route.

2. **MAJOR (OpenImm, `lem:slice_structureSheaf_hom`)**: Remove the stale `% NOTE: build target. The Lean declaration does not exist yet.` — `sliceStructureSheafHom` is now axiom-clean with both `IsRightAdjoint` instances.

3. **MINOR (CSI, `lem:cechSection_complex_iso`)**: Missing statement-block `\leanok`. The declaration `cechSection_complex_iso` exists as sorry; `sync_leanok` should add `\leanok` to the statement block.

---

## Severity summary

| # | Finding | Severity |
|---|---------|----------|
| 1 | `pushPull_binary_coprod_prod` absent from Lean (blueprint `\lean{...}` names a non-existent declaration; entire CSI chain blocked) | **must-fix-this-iter** |
| 2 | `pushPull_coprod_prod` absent from Lean (blueprint names it, doesn't exist; blocks `pushPull_sigma_iso`) | **must-fix-this-iter** |
| 3 | Blueprint `lem:pushforward_slice_pullback_iso` proof sketch is incomplete/incorrect for general H — only the unit case is described; actual route requires `Adjunction.leftAdjointUniq` (documented in OpenImm inline comment, absent from blueprint) | **must-fix-this-iter** |
| 4 | Stale `% NOTE: build target. The Lean declaration does not exist yet.` on `lem:slice_structureSheaf_hom` (declaration is now axiom-clean) | **major** |
| 5 | Missing statement-block `\leanok` on `lem:cechSection_complex_iso` (`sync_leanok` miss; sorry is present) | **minor** |

**Overall verdict**: The CSI Lean file is structurally sound — all axiom-clean work (Stubs 1, 3, and the binary leaf `isIso_coprodDecompMap`) is in good shape and faithfully follows the blueprint — but the chain is completely blocked by two missing intermediate declarations (`pushPull_binary_coprod_prod`, `pushPull_coprod_prod`) that the blueprint names but the Lean file has not built; additionally the blueprint proof sketch for `pushforward_slice_pullback_iso` (OpenImm dependency) is incorrect for the general case and must be fixed before the final sorry in `higherDirectImage_openImmersion_acyclic` can be discharged. 8 declarations checked, 3 must-fix red flags.
