# Lean Auditor Report — iter060

**Slug:** iter060  
**Date:** 2026-06-10  
**Scope:** all `.lean` files under `AlgebraicJacobian/`  
**Focus:** `CechSectionIdentification.lean`, `OpenImmersionPushforward.lean`

---

## Summary verdict

**No must-fix issues** in the two focus files. The three newly-built declarations in each
file are genuine constructions; the six known frontier sorry-holes carry correct goal types
and honest comments. One sorry outside the known-issues list is flagged (severity: MINOR —
it is an honest consumer-side residual with accurate documentation).

---

## Per-file checklist

### `CechSectionIdentification.lean` (879 lines) — PRIMARY FOCUS

| Declaration | Lines | Kind | Verdict |
|---|---|---|---|
| `widePullbackBaseCongr` | 502–527 | iso | ✅ GENUINE |
| `coverInterProdIso` | 545–551 | iso | ✅ GENUINE |
| `cechBackbone_left_sigma` | 582–607 | iso | ✅ GENUINE — not a defeq launder |
| `pushPull_sigma_iso` | 652–657 | sorry | ✅ Honest hole, correct type |
| `pushPull_eval_prod_iso` | 739–748 | sorry | ✅ Honest hole, correct type |
| `cechSection_complex_iso` | 803–818 | sorry | ✅ Honest hole, correct type |
| `cechSection_contractible` | 870–877 | sorry | ✅ Honest hole, correct type |
| Abstract categorical infra (lines 48–389) | — | proof | ✅ Axiom-clean |
| `widePullback_openImm_inter` + cover arrow decls | 432–494 | proof | ✅ Axiom-clean |

**Genuineness analysis — `widePullbackBaseCongr`:**  
Builds `(WidePullback B)^n ≅ (WidePullback A)^n` along `w : B ≅ A` using `Over.isoMk` with
`WidePullback.lift` in the hom and inv. The `hom_inv_id`/`inv_hom_id` conditions are
discharged by `WidePullback.hom_ext`. Not a defeq launder — requires explicit construction
and commutativity proof.

**Genuineness analysis — `coverInterProdIso`:**  
Chains `widePullback_overX_eq_prod.symm ≪≫ Over.isoMk (widePullback_openImm_inter …) …`.
Uses `IsOpenImmersion.lift_fac` to close the commutativity leg. Genuine.

**Genuineness analysis — `cechBackbone_left_sigma` (universe-reduction assembly):**  
- Sets `n := Nat.card 𝒰.I₀`, `e : 𝒰.I₀ ≃ Fin n` via `Finite.equivFin`.
- Builds `wZ : (∐ j : Fin n, 𝒰.X (e.symm j)) ≅ ∐ 𝒰.X` via `Sigma.whiskerEquiv e.symm`.
  Proves commutation `hwZ : wZ.hom ≫ Sigma.desc 𝒰.f = Sigma.desc f'` (non-trivial).
- Builds `reIdx` via `Sigma.whiskerEquiv (Equiv.arrowCongr (Equiv.refl _) e.symm)`.
- Chain: `cechBackbone_obj_widePullback ≪≫ widePullbackBaseCongr ≪≫`  
  `FinitaryPreExtensive.widePullback_coproduct_iso f' p ≪≫ reIdx ≪≫`  
  `Sigma.mapIso (fun σ => coverInterProdIso 𝒰 σ)`.
- `FinitaryPreExtensive.widePullback_coproduct_iso` is the genuine extensivity result
  (uses `isIso_sigmaDesc_fst`). The reindexing through `Fin n` is necessary for universe
  compatibility. **NOT a Subsingleton/defeq launder.**

**Sorry-goal verification:**

- `pushPull_sigma_iso` (line 657): Goal is
  `pushPullObj F ((coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p))) ≅`  
  `∏ᶜ fun σ : Fin (p + 1) → 𝒰.I₀ => pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))`.  
  Comment accurately names `TopCat.Sheaf.isProductOfDisjoint` as the required ingredient.
  Correct type; honest hole.

- `pushPull_eval_prod_iso` (line 748): Depends on `pushPull_sigma_iso`. Goal is
  a section-group iso to a product of section groups over `coverInterOpen`. Correct type;
  honest hole.

- `cechSection_complex_iso` (line 818): Goal is a complex-level iso between the evaluated
  augmented complex (`cechAugmentedComplex` evaluated at `V`) and the concrete section Čech
  complex (`sectionCechComplexV 𝒰 F V`). Uses `cechAugmentedComplex` and
  `sectionCechComplexV`. Correct type; honest hole.

- `cechSection_contractible` (line 877): Goal is
  `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0`.  
  Comment references `CombinatorialCech.depHomotopy` as the intended engine. Correct type;
  honest hole.

**Excuse-comment check:** None found in focus area or surrounding decls.

---

### `OpenImmersionPushforward.lean` (600 lines) — PRIMARY FOCUS

| Declaration | Lines | Kind | Verdict |
|---|---|---|---|
| `sectionsCorep` | 363–366 | CorepresentableBy | ✅ GENUINE |
| `sectionsCorepPushforward` | 372–384 | CorepresentableBy | ✅ GENUINE |
| `jShriekOU_transport_along_iso` | 391–395 | iso | ✅ GENUINE corepresentability transport |
| `case hqc => sorry` in `higherDirectImage_openImmersion_acyclic` | 532 | sorry | ✅ Honest hole, correct type |
| `higherDirectImage_openImmersion_comp` | 574–598 | sorry | ✅ Honest hole, correct type |
| `isAffineHom_of_affine_separated` | 423–429 | lemma | ✅ Axiom-clean |
| `pushforwardSectionsFunctor` + `Additive` instance | 436–463 | def/instance | ✅ Genuine (explicit chain) |
| All Need#1 Ext-transport decls | — | proof | ✅ Axiom-clean |

**Genuineness analysis — `sectionsCorep`:**  
`CorepresentableBy (sectionsFunctor V ⋙ forget AddCommGrpCat) (jShriekOU V)` with
`homEquiv := (jShriekOU_homEquiv V B).toEquiv` and
`homEquiv_comp := jShriekOU_homEquiv_nat V f g`. Both fields are filled with genuine data.

**Genuineness analysis — `sectionsCorepPushforward`:**  
`CorepresentableBy (sectionsFunctor (φ.inv ⁻¹ᵁ V) ⋙ forget …) (Φ.functor.obj (jShriekOU V))`
with `homEquiv` chaining `Φ.toAdjunction.homEquiv (jShriekOU V) B` with
`jShriekOU_homEquiv V (Φ.inverse.obj B)`, and `homEquiv_comp` using
`Φ.toAdjunction.homEquiv_naturality_right` + `erw [jShriekOU_homEquiv_nat …]`. Both fields
filled with genuine data connecting the adjunction to the section functor.

**Genuineness analysis — `jShriekOU_transport_along_iso`:**  
```
(sectionsCorepPushforward φ V).uniqueUpToIso (sectionsCorep (φ.inv ⁻¹ᵁ V))
```
`sectionsCorepPushforward` establishes the left side corepresents `sectionsFunctor (φ.inv⁻¹V) ⋙ forget`
via adjunction; `sectionsCorep` establishes the right side corepresents the same functor
directly via `jShriekOU_homEquiv`. `CorepresentableBy.uniqueUpToIso` provides the iso from
this data. **Mathematically correct corepresentability transport — not a defeq launder.**

**Sorry-goal verification:**

- `case hqc => sorry` (line 532): Inside `higherDirectImage_openImmersion_acyclic`,
  goal is `((Scheme.Modules.pushforwardEquivOfIso U.isoSpec).functor.obj H).IsQuasicoherent`.
  Comment accurately states: "pushforward along an iso preserves quasi-coherence; requires a
  `pushforward_commutes_restriction`-style lemma not yet in Mathlib." Honest hole.

- `higherDirectImage_openImmersion_comp` (lines 574–598): Entire proof body is sorry. Comment
  gives a structural plan: construct acyclic resolution of `j_* H` from the acyclic resolution
  of each `j⁻¹(V) → V`, invoke `rightDerivedIsoOfAcyclicResolution`. Honest hole awaiting the
  `hqc` residual and the acyclic-resolution composition glue.

**Excuse-comment check:** No excuse-comments found. The `Additive` instance comment at lines
459–463 is a genuine architectural note explaining why `@CategoryTheory.Functor.instAdditiveComp`
must be called explicitly (5-fold composite defeats `infer_instance`) — accurate and necessary.

---

### `CechAugmentedResolution.lean` (246 lines)

| Declaration | Lines | Kind | Verdict |
|---|---|---|---|
| `isZero_of_faithful_preservesZeroMorphisms` | — | lemma | ✅ Axiom-clean |
| `isZero_presheafToSheaf_of_locally_isZero` | — | lemma | ✅ Axiom-clean |
| `cechAugmented_exact` | 229 | sorry | ⚠️ NOT in known-issues list |

**`CechAugmentedResolution.lean:229`** (see Flagged Issues below).

---

### `CechAcyclic.lean` (≥150 lines)

- `CechAcyclic.affine` (line 110): known dead declaration per directive. **Not re-flagged.**
- `CombinatorialCech` namespace: axiom-clean combinatorial infrastructure.

---

### `CechHigherDirectImage.lean`

- Line 780 (`cech_computes_higherDirectImage`): known frozen P5b-assembly per directive.
  **Not re-flagged.**
- All other read declarations: axiom-clean.

---

### All remaining files — axiom-clean

The following files contain **zero sorry occurrences** and no axiom launders:

| File | Key decls | Status |
|---|---|---|
| `AbsoluteCohomology.lean` (171 lines) | `jShriekOU`, `jShriekOU_homEquiv`, `absoluteCohomology`, `absoluteCohomologyZeroAddEquiv` | ✅ Clean |
| `AcyclicResolution.lean` (926 lines) | `InjectiveResolution.ofShortExact`, `rightDerivedShiftIsoOfAcyclic`, `rightDerivedIsoOfAcyclicResolution` | ✅ Clean (P4 complete) |
| `AffineSerreVanishing.lean` (888 lines) | `affineCoverSystem`, `affineCoverSystemGeneral`, `affine_serre_vanishing`, `affine_serre_vanishing_general_open`, `higherDirectImage_openImmersion_acyclic` (partial), `ext_jShriekOU_eq_zero_of_specIso` | ✅ Clean |
| `CechBridge.lean` (1116 lines) | `cechComplex_hom_identification`, `injective_cech_acyclic`, `ses_cech_h1`, family-parameterized Fam variants of all bridge decls, `injective_cech_acyclicFam` | ✅ Clean |
| `CechToCohomology.lean` | `sectionCechCosimplicialMap`, `sectionCechCosimplicialFunctor`, L1/L2 chain | ✅ Clean |
| `FreePresheafComplex.lean` | `cechFreePresheafComplex`, `cechFreeComplex_quasiIso`, `cechFreePresheafComplexFam`, `cechFreeComplex_quasiIsoFam`, `FreeCechEngine.combHomotopy` | ✅ Clean |
| `HigherDirectImage.lean` (50 lines) | `higherDirectImage` | ✅ Clean |
| `HigherDirectImagePresheaf.lean` (170 lines) | `mapHomologyIso'`, `homologyIsoSheafify`, `higherDirectImage_iso_sheafify_presheafHomology` | ✅ Clean |
| `PresheafCech.lean` | `sectionCechComplex`, `freeYonedaHomEquiv`, `freeYonedaHomAddEquiv`, `injective_toPresheafOfModules` | ✅ Clean |
| `QcohRestrictBasicOpen.lean` | qcoh restriction infrastructure | ✅ Clean |
| `QcohTildeSections.lean` | tilde-sections infrastructure | ✅ Clean |
| `TildeExactness.lean` | `qcoh_iso_tilde_sections`, tilde exactness | ✅ Clean |
| `AlgebraicJacobian.lean` (18 lines) | import barrel file | ✅ Clean |
| `_mcp_snippet_…lean` (9 lines) | `SheafOfModules.IsQuasicoherent.of_coversTop` example | ✅ Clean |

---

## Flagged issues

### MINOR — `CechAugmentedResolution.lean:229`: honest residual sorry not in known-issues list

**File:** `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`  
**Line:** 229  
**Declaration:** `cechAugmented_exact`  
**Not in the directive's known-issues list.**

**Context:**  
The sorry fills the goal `Homotopy (𝟙 ((GV.mapHomologicalComplex cc).obj Kp)) p ?_` inside
`refine isZero_homology_of_homotopy_id_zero ((GV.mapHomologicalComplex cc).obj Kp) p ?_`.
The comment (lines 215–227) accurately describes the intended discharge:
```
exact isZero_homology_of_iso_homotopy_id_zero
  (cechSection_complex_iso 𝒰 F V) p (cechSection_contractible 𝒰 F V i hiV)
```
and explains why it is held back: "that sibling file currently has signature-level compile
errors … so its import is held back."

**Assessment:** The hole is honest and correctly typed. The comment accurately identifies the
two CSI dependencies (`cechSection_complex_iso`, `cechSection_contractible`) that unblock it.
The "signature-level compile errors" description may now be stale — CSI compiles after the
iter-060 repairs to `widePullbackBaseCongr`/`cechBackbone_left_sigma`. The sorry will close
once those two CSI declarations' proofs are filled (they are themselves known frontier holes).

**Recommended action:** Update the comment to reflect current status (CSI imports after
iter-060; the residual is now purely the two frontier sorry-bodies in CSI). Optionally add
this sorry to the known-issues list for the next audit pass. No correctness issue.

---

## Axiom inventory

No new `axiom` declarations introduced this iteration. The existing `#check @sorryAx`
print from `CechAcyclic.lean:110` and the six frontier sorry-holes are the complete sorry
inventory. All non-sorry-hole content compiles axiom-clean.

**Total sorry count:** 10 occurrences across the project  
- 2 known-issues (dead decl + frozen P5b): not re-flagged  
- 6 known frontier holes (4 CSI + 2 OpenImm): correct types, honest  
- 1 consumer-side residual (CechAugmentedResolution:229): honest, noted above  
- (The `CechAcyclic.lean:18` occurrence is a doc-comment word, not a proof term)

---

## Focus-area verdict

| Check | CechSectionIdentification | OpenImmersionPushforward |
|---|---|---|
| Newly-built decls genuine (not defeq launder) | ✅ `widePullbackBaseCongr`, `coverInterProdIso`, `cechBackbone_left_sigma` all genuine | ✅ `sectionsCorep`, `sectionsCorepPushforward`, `jShriekOU_transport_along_iso` all genuine |
| Sorry-holes correctly typed | ✅ All four holes carry correct goal types | ✅ Both holes carry correct goal types |
| No excuse-comments | ✅ | ✅ |
| `cechBackbone_left_sigma` is genuine geometric proof | ✅ Uses `FinitaryPreExtensive.widePullback_coproduct_iso` after Fin-reindexing universe reduction | — |
| `jShriekOU_transport_along_iso` is genuine corepresentability | — | ✅ Both sides corepresent same functor; `CorepresentableBy.uniqueUpToIso` provides iso |
