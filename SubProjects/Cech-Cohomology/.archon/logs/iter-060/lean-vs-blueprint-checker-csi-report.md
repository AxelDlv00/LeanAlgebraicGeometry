# Lean ↔ Blueprint Check Report

## Slug
csi

## Iteration
060

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechBackbone_left_sigma}` (chapter: `lem:cech_backbone_left_sigma`)
- **Lean target exists**: yes — line 582
- **Signature matches**: yes — `(coverCechNerveOver 𝒰).obj (op [p]) ≅ ∐ fun σ : Fin(p+1) → 𝒰.I₀ => Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))` in `Over X`, exactly as stated
- **Proof follows sketch**: yes — chains `cechBackbone_obj_widePullback ≪≫ widePullbackBaseCongr … ≪≫ FinitaryPreExtensive.widePullback_coproduct_iso … ≪≫ reIdx ≪≫ Sigma.mapIso (coverInterProdIso …)`, matching the blueprint's universe-reduction strategy (equivFin + arrowCongr reindexing) and the component-wise `coverInterProdIso` closing step
- **notes**: Newly axiom-clean this iteration. Blueprint has `\leanok` on statement block (line 7882) — consistent.

### `\lean{AlgebraicGeometry.widePullback_openImm_inter, AlgebraicGeometry.mem_iInf_opens_of_finite}` (chapter: `lem:widePullback_openImm_inter`)
- **Lean target exists**: yes — lines 414 (`mem_iInf_opens_of_finite`, private) and 432 (`widePullback_openImm_inter`)
- **Signature matches**: yes — `widePullback X Z g ≅ (⨅ k, (g k).opensRange).toScheme` with structure map `Scheme.Opens.ι _`, as stated
- **Proof follows sketch**: yes — uses `IsOpenImmersion.lift` and wide-pullback universal property (not iterated binary, but direct construction)
- **notes**: Both declarations complete (no sorry). `mem_iInf_opens_of_finite` is `private`; the blueprint references it by name in `\lean{...}` (minor stale hint — see below).

### `\lean{AlgebraicGeometry.cechBackbone_obj_widePullback}` (chapter: `lem:cechBackbone_obj_widePullback`)
- **Lean target exists**: yes — line 536
- **Signature matches**: yes — `Iso.refl _` (definitional unfolding)
- **Proof follows sketch**: yes / N/A
- **notes**: Clean.

### `\lean{AlgebraicGeometry.coverArrowOverSigmaIso, AlgebraicGeometry.coverArrowOverCofan, AlgebraicGeometry.coverArrowOverIsColimit}` (chapter: `lem:coverArrow_over_sigma`)
- **Lean target exists**: yes — lines 463, 471, 492
- **Signature matches**: yes — `(∐ fun i => Over.mk (𝒰.f i)) ≅ Over.mk (Sigma.desc 𝒰.f)` as stated
- **Proof follows sketch**: yes
- **notes**: Clean. The abstract version (`overSigmaDescCofan`, `overSigmaDescIsColimit`, `overSigmaDescIso`) also exists in `CategoryTheory` namespace and is `\lean{}`-tagged in same block.

### `\lean{CategoryTheory.widePullback_overX_eq_prod, CategoryTheory.widePullback_overX_isLimit}` (chapter: `lem:widePullback_overX_eq_prod`)
- **Lean target exists**: yes — lines 54, 81
- **Signature matches**: yes — `Over.mk (WidePullback.base g) ≅ ∏ᶜ fun k => Over.mk (g k)` and the underlying `IsLimit` fan
- **Proof follows sketch**: yes
- **notes**: Clean.

### `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso_zero}` (chapter: `lem:coproduct_distrib_fibrePower_zero`)
- **Lean target exists**: yes — line 205
- **Signature matches**: yes — 1-fold fibre power decomposes as `∐ σ : Fin 1 → ι => ∏ᶜ ...`
- **Proof follows sketch**: yes
- **notes**: `\leanok` on statement block consistent with clean proof.

### `\lean{CategoryTheory.FinitaryPreExtensive.prod_coproduct_distrib, CategoryTheory.FinitaryPreExtensive.coprodFirst_distrib}` (chapter: `lem:prod_coproduct_distrib`)
- **Lean target exists**: yes — lines 164, 223
- **Signature matches**: yes — one-sided fibre-product distributivity (both sides)
- **Proof follows sketch**: partial — blueprint describes using `isIso_sigmaDesc_fst_mathlib`; Lean builds directly from `FinitaryPreExtensive.isIso_sigmaDesc_fst` + `pullbackLeftPullbackSndIso`. Mathematically equivalent.
- **notes**: Clean.

### `\lean{CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib, ...pcd_hom_fst, ...pcd_hom_snd, ...cf_hom_fst, ...overSigma_hom_eq}` (chapter: `lem:overProd_coproduct_distrib`)
- **Lean target exists**: yes — lines 233, 254, 275, 285, 305
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `overSigma_hom_eq` is `private lemma` at line 285; the blueprint's `\lean{..., CategoryTheory.FinitaryPreExtensive.overSigma_hom_eq}` pin is inaccurate since private declarations get mangled names in Lean 4. See Red Flags below.

### `\lean{CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib_right}` (chapter: `lem:overProd_coproduct_distrib_right`)
- **Lean target exists**: yes — line 356
- **Signature matches**: yes — `A ⨯ (∐ Y) ≅ ∐ fun i => A ⨯ Y i`
- **Proof follows sketch**: yes
- **notes**: Clean.

### `\lean{CategoryTheory.FinitaryPreExtensive.coproduct_fibrePower_reindex}` (chapter: `lem:coproduct_fibrePower_reindex`)
- **Lean target exists**: yes — line 186
- **Signature matches**: yes — nested-coproduct flatten + Fin.cons reindex
- **Proof follows sketch**: yes
- **notes**: Clean.

### `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso, CategoryTheory.FinitaryPreExtensive.prodFinSuccIso}` (chapter: `lem:coproduct_distrib_fibrePower`)
- **Lean target exists**: yes — lines 134 (`prodFinSuccIso`), 363 (`widePullback_coproduct_iso`)
- **Signature matches**: yes — `p`-indexed family; wide fibre power of `Sigma.desc f` decomposes as `∐ σ : Fin(p+1) → ι => ∏ᶜ fun k => Over.mk (f (σ k))`
- **Proof follows sketch**: yes — induction on `p`, base case via `widePullback_coproduct_iso_zero`, inductive step via `prodFinSuccIso ≪≫ Sigma.mapIso ... ≪≫ overProd_coproduct_distrib ≪≫ ... ≪≫ coproduct_fibrePower_reindex`
- **notes**: `set_option maxHeartbeats 1600000` at line 363. Clean.

### `\lean{AlgebraicGeometry.pushPull_sigma_iso}` (chapter: `lem:pushPull_sigma_iso`) — intentional sorry stub
- **Lean target exists**: yes — line 652
- **Signature matches**: yes — `pushPullObj F ((coverCechNerveOver 𝒰).obj (op [p])) ≅ ∏ᶜ fun σ : Fin(p+1) → 𝒰.I₀ => pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))` in `X.Modules`; matches blueprint exactly
- **Proof follows sketch**: N/A (sorry)
- **notes**: Intentional stub per directive. Blueprint has `\leanok` on statement block (line 8006) — consistent (declaration present with sorry).

### `\lean{AlgebraicGeometry.pushPull_leg_sections}` (chapter: `lem:pushPull_leg_sections`)
- **Lean target exists**: yes — line 690
- **Signature matches**: yes — `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(U_σ ⊓ V, F)` at the presheaf-of-Ab level, per blueprint
- **Proof follows sketch**: yes — chains `restrictFunctorIsoPullback` application + `eqToIso` rewriting `j ''ᵁ (j⁻¹V) = U_σ ⊓ V` via `image_preimage_eq_opensRange_inf` + `Opens.opensRange_ι`, as described
- **notes**: Complete (no sorry). Blueprint `\leanok` consistent.

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`) — intentional sorry stub
- **Lean target exists**: yes — line 739
- **Signature matches**: yes — `Γ(V, pushPullObj F Y_p)` at presheaf level `≅ ∏ᶜ fun σ => Γ(U_σ ⊓ V, F)`, matching blueprint
- **Proof follows sketch**: N/A (sorry)
- **notes**: Intentional stub per directive. Blueprint `\leanok` on statement block consistent.

### `\lean{AlgebraicGeometry.cechSection_complex_iso, AlgebraicGeometry.sectionCechComplexV}` (chapter: `lem:cechSection_complex_iso`) — intentional sorry stub
- **Lean target exists**: yes — lines 755 (`sectionCechComplexV`), 803 (`cechSection_complex_iso`)
- **Signature matches**: yes — target is `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε`, the AUGMENTED form specified by the blueprint's `% NOTE:` annotation; the augmentation parameters `ε` and `hε` are explicit arguments. Matches corrected blueprint target from iter-058.
- **Proof follows sketch**: N/A (sorry)
- **notes**: Intentional stub per directive. Blueprint has NO `\leanok` on this statement block despite the sorry being present — `sync_leanok` should add it on the next sync pass (informational, not a Lean error).

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`) — intentional sorry stub
- **Lean target exists**: yes — line 870
- **Signature matches**: yes — `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0`, the AUGMENTED form specified by the blueprint's `% NOTE:` annotation
- **Proof follows sketch**: N/A (sorry)
- **notes**: Intentional stub per directive. Blueprint `\leanok` on statement block (line 8199) consistent with sorry present.

---

## Red flags

### Excuse-comments
None found.

### Axioms / `Classical.choice` on non-trivial claims
None found — no `axiom` declarations in the file.

### Placeholder / suspect bodies
- `pushPull_sigma_iso` (line 657): `:= sorry` — **intentional stub per directive**, not a flag.
- `pushPull_eval_prod_iso` (line 748): `:= sorry` — **intentional stub per directive**, not a flag.
- `cechSection_complex_iso` (line 818): `:= sorry` — **intentional stub per directive**, not a flag.
- `cechSection_contractible` (line 877): `:= sorry` — **intentional stub per directive**, not a flag.

### Minor: stale `\lean{}` reference to private declaration
- Blueprint `lem:overProd_coproduct_distrib` lists `\lean{..., CategoryTheory.FinitaryPreExtensive.overSigma_hom_eq}` (line 7656). In the Lean file `overSigma_hom_eq` is declared `private` (line 285), so its actual Lean 4 internal name is mangled and inaccessible by the blueprint-listed identifier. Mathematical content is unaffected; the `overProd_coproduct_distrib` proof is complete. This is a blueprint annotation error only.

---

## Unreferenced declarations (informational)

The following declarations exist in the Lean file but have **no `\lean{...}` blueprint reference**:

| Declaration | Line | Nature |
|---|---|---|
| `CategoryTheory.widePullbackBaseCongr` | 502 | **New helper** — universe-reduction transport for the `cechBackbone_left_sigma` proof; no blueprint block |
| `CategoryTheory.AlgebraicGeometry.coverInterProdIso` | 545 | **New helper** — combines `widePullback_overX_eq_prod` + `widePullback_openImm_inter` to identify the σ-component with the intersection open; no blueprint block |
| `CategoryTheory.AlgebraicGeometry.cechBackbone_obj_widePullback` | 536 | Has blueprint block `lem:cechBackbone_obj_widePullback` — correctly referenced ✓ |
| `private mem_iInf_opens_of_finite` | 414 | Referenced via `AlgebraicGeometry.mem_iInf_opens_of_finite` in `lem:widePullback_openImm_inter`; but is `private` (same private-name issue as `overSigma_hom_eq`) |
| `private overSigma_hom_eq` | 285 | Referenced in blueprint but private (flagged above) |

Per the directive, `widePullbackBaseCongr` and `coverInterProdIso` are already noted as coverage debt for the planner; they are not must-fix.

---

## Blueprint adequacy for this file

- **Coverage**: All 13 substantive blueprint-referenced declaration groups are present in the file with matching signatures. Two new helpers (`widePullbackBaseCongr`, `coverInterProdIso`) have no blueprint blocks — coverage debt, already noted in directive.
- **Proof-sketch depth**: **adequate** for all closed declarations. The `cechBackbone_left_sigma` proof closely follows the universe-reduction route described in the blueprint's "Universe reduction" paragraph, using `Finite.equivFin`, `Sigma.whiskerEquiv`, and `Equiv.arrowCongr` exactly as specified. The `pushPull_leg_sections` proof matches the three-step chain described in the blueprint.
- **Hint precision**: **mostly precise**. One stale hint: `CategoryTheory.FinitaryPreExtensive.overSigma_hom_eq` is `private` and the `\lean{}`-listed name is inaccessible externally. `AlgebraicGeometry.mem_iInf_opens_of_finite` is similarly private.
- **Generality**: **matches need** — the abstract `CategoryTheory`-namespace declarations are correctly stated for arbitrary categories with the required instances; the geometric specialization at `Scheme` is confined to the assembly declarations.
- **`% NOTE:` annotations**: Both `lem:cechSection_complex_iso` and `lem:cechSection_contractible` carry `% NOTE: build target — augmented form` annotations (lines 8128, 8203). The Lean signatures correctly reflect these annotations (augmented form used in both stubs).
- **Missing `\leanok` on `lem:cechSection_complex_iso`**: The statement block carries no `\leanok` despite the Lean file having a sorry (which satisfies the "at least a sorry" threshold). `sync_leanok` should add the marker on next run; this is an infrastructure lag, not a content error.

**Recommended chapter-side actions:**
- Add `\lean{AlgebraicGeometry.widePullbackBaseCongr}` and a short lemma block for the helper (universe-reduction transport of wide fibre power along a cover-source iso).
- Add `\lean{AlgebraicGeometry.coverInterProdIso}` and a short lemma block for the σ-component identification helper.
- Update `\lean{}` hints for `overSigma_hom_eq` and `mem_iInf_opens_of_finite` to either remove them (pure internal helpers) or make them non-private in the Lean source.

---

## Severity summary

| Finding | Severity |
|---|---|
| `cechBackbone_left_sigma` closed axiom-clean, signature and proof match blueprint | — (positive) |
| 4 intentional sorry stubs (`pushPull_sigma_iso`, `pushPull_eval_prod_iso`, `cechSection_complex_iso`, `cechSection_contractible`) all have correct augmented signatures | — (no issue) |
| `widePullbackBaseCongr` has no blueprint block | **minor** (coverage debt, noted in directive) |
| `coverInterProdIso` has no blueprint block | **minor** (coverage debt, noted in directive) |
| `\lean{..., overSigma_hom_eq}` and `\lean{..., mem_iInf_opens_of_finite}` reference `private` declarations | **minor** (stale blueprint `\lean{}` annotation; math unaffected) |
| `lem:cechSection_complex_iso` missing `\leanok` despite sorry present | **minor** (infrastructure lag; `sync_leanok` should correct) |

**No must-fix-this-iter findings.**

**Overall verdict**: `cechBackbone_left_sigma` correctly closed this iteration with proof matching the blueprint's universe-reduction route; all four remaining sorry stubs have correct augmented signatures; two new helpers need blueprint blocks (non-blocking coverage debt); no axioms, no suspect bodies, no excuse-comments.
