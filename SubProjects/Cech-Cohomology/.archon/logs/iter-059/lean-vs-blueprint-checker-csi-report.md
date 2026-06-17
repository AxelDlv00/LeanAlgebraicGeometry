# Lean ↔ Blueprint Check Report

## Slug
csi

## Iteration
059

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (consolidated chapter; `CechSectionIdentification.lean` declared via `% archon:covers`)

---

## Per-declaration

### `\lean{CategoryTheory.widePullback_overX_isLimit}` / `\lean{CategoryTheory.widePullback_overX_eq_prod}` (chapter: `lem:widePullback_overX_eq_prod`)
- **Lean target exists**: yes — lines 54–85
- **Signature matches**: yes. Both declared; blueprint says "wide fibre power over a base is the iterated product in the slice". Lean provides both the `IsLimit` witness and the canonical iso. ✓
- **Proof follows sketch**: yes (pure limit-uniqueness argument). ✓
- **notes**: Statement block lacks `\leanok` even though the declarations are fully proved (no sorry). This implies `sync_leanok` did not verify them — see **Red flags §Leanok gaps** below.

### `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso_zero}` (chapter: `lem:coproduct_distrib_fibrePower_zero`)
- **Lean target exists**: yes — lines 205–216. ✓
- **Signature matches**: yes. ✓
- **Proof follows sketch**: yes. ✓
- **notes**: Has `\leanok`. No issues.

### `\lean{CategoryTheory.FinitaryPreExtensive.prod_coproduct_distrib}` (chapter: `lem:prod_coproduct_distrib`)
- **Lean target exists**: yes — lines 164–179. ✓
- **Signature matches**: partial. Blueprint states **both** forms of distributivity (coproduct in first and second pullback argument). The Lean declaration covers only the second form: `∐i pullback(a, gᵢ) ≅ pullback(a, ∐g)`. The first form `∐i pullback(gᵢ, b) ≅ pullback(∐g, b)` is implemented as the **separate** declaration `coprodFirst_distrib` (lines 223–227), which has **no** `\lean{}` pin in this blueprint block.
- **Proof follows sketch**: yes (uses `isIso_sigmaDesc_fst`). ✓
- **notes**: `\lean{}` pin is incomplete. `coprodFirst_distrib` should be added. See **Red flags** below.

### `\lean{CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib}` (chapter: `lem:overProd_coproduct_distrib`)
- **Lean target exists**: yes — lines 305–352. ✓
- **Signature matches**: yes. `(∐ A) ⨯ B ≅ ∐ fun i => A i ⨯ B` in `Over S`. ✓
- **Proof follows sketch**: partial. Blueprint sketch says "it suffices to identify the underlying objects" via `Over.prodLeftIsoPullback` and `prod_coproduct_distrib`. The Lean proof additionally required four explicit helper lemmas (`pcd_hom_fst`, `pcd_hom_snd`, `cf_hom_fst`, `overSigma_hom_eq`) to verify structure-map compatibility conditions that the blueprint sketch does not mention. The math is correct but the sketch is under-specified.
- **notes**: Has `\leanok`. The `% NOTE: build target. The Lean declaration does not exist yet` at line 7654 is **stale** (declaration exists and proved). Stale comment should be removed by the review agent.

### `\lean{CategoryTheory.FinitaryPreExtensive.coproduct_fibrePower_reindex}` (chapter: `lem:coproduct_fibrePower_reindex`)
- **Lean target exists**: yes — lines 186–193. ✓
- **Signature matches**: yes. ✓
- **Proof follows sketch**: yes. ✓
- **notes**: Has `\leanok`. No issues.

### `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso}` + `\lean{CategoryTheory.FinitaryPreExtensive.prodFinSuccIso}` (chapter: `lem:coproduct_distrib_fibrePower`)
- **Lean target exists**: yes — `widePullback_coproduct_iso` at lines 363–386; `prodFinSuccIso` at lines 134–156. ✓
- **Signature matches**: **partial** — σ-normal-form divergence. Blueprint states the σ-component as the "(p+1)-fold fibre power `X_{σ(0)} ×_S ⋯ ×_S X_{σ(p)}`" (wide pullback form). The Lean declaration uses `∏ᶜ (fun k => Over.mk (f (σ k)))` — the **categorical product in `Over S`**. These are isomorphic via `widePullback_overX_eq_prod`, but not syntactically equal. The Lean docstring at line 199–204 documents this normal-form choice explicitly; the blueprint does not mention it. A consumer applying `widePullback_coproduct_iso` and then `widePullback_openImm_inter` needs an intermediate `widePullback_overX_eq_prod` step that the blueprint's proof sketch for `lem:cech_backbone_left_sigma` silently omits.
- **Proof follows sketch**: yes (induction on p, base case = `widePullback_coproduct_iso_zero`, inductive step uses `overProd_coproduct_distrib` + `overProd_coproduct_distrib_right` + `coproduct_fibrePower_reindex`). ✓
- **notes**: (a) Statement block lacks `\leanok` despite declarations being fully proved — sync_leanok gap (see Red flags). (b) Stale comment `% NOTE: build target. The Lean declaration does not exist yet` at line 7740 should be removed. (c) `overProd_coproduct_distrib_right` (used on line 381) is not mentioned in the `\lean{}` pin or proof sketch.

### `\lean{AlgebraicGeometry.widePullback_openImm_inter}` + `\lean{AlgebraicGeometry.mem_iInf_opens_of_finite}` (chapter: `lem:widePullback_openImm_inter`)
- **Lean target exists**: yes — lines 432–459 and 413–425. ✓
- **Signature matches**: yes. `widePullback X Z g ≅ (⨅ k, (g k).opensRange).toScheme`. ✓
- **Proof follows sketch**: yes (direct construction of the iso via `IsOpenImmersion.lift`). ✓
- **notes**: Statement block lacks `\leanok` despite the declarations being proved. sync_leanok gap.

### `\lean{AlgebraicGeometry.coverArrowOverSigmaIso}` + `coverArrowOverCofan` + `coverArrowOverIsColimit` + `CategoryTheory.overSigmaDescCofan` + `overSigmaDescIsColimit` + `overSigmaDescIso` (chapter: `lem:coverArrow_over_sigma`)
- **Lean target exists**: yes — all six declarations present and proved (lines 88–125, 463–494). ✓
- **Signature matches**: yes. ✓
- **Proof follows sketch**: yes. ✓
- **notes**: Statement block lacks `\leanok`. sync_leanok gap.

### `\lean{AlgebraicGeometry.cechBackbone_obj_widePullback}` (chapter: `lem:cechBackbone_obj_widePullback`)
- **Lean target exists**: yes — lines 503–506. Body is `Iso.refl _` (definitional). ✓
- **Signature matches**: yes. ✓
- **notes**: Has `\leanok`. No issues.

### `\lean{AlgebraicGeometry.cechBackbone_left_sigma}` (chapter: `lem:cech_backbone_left_sigma`)
- **Lean target exists**: yes — lines 537–541. Body: `:= sorry`. ✓ (statement declared)
- **Signature matches**: yes. `(coverCechNerveOver 𝒰).obj (op [p]) ≅ ∐ fun σ : Fin(p+1)→𝒰.I₀ => Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))`. ✓
- **Proof follows sketch**: N/A (sorry). Known blocker: `widePullback_coproduct_iso` requires `{ι : Type}` (universe 0) but `𝒰.I₀ : Type u`. The prover must reindex via `Fintype.equivFin` before applying the distributivity lemma, then transport back. This step is documented in the blueprint at lines 7887–7898 but **without exact Lean API names** (`Fintype.equivFin`, `Sigma.whiskerEquiv`). Additionally, the blueprint's sketch at lines 7869–7885 omits the intermediate `widePullback_overX_eq_prod` step needed to convert the `∏ᶜ` output of `widePullback_coproduct_iso` to the `Over.mk (WidePullback.base ...)` form that `widePullback_openImm_inter` expects.
- **notes**: Has `\leanok`. Correctly typed. Blueprint adequacy gap for consumer step (see §Blueprint adequacy).

### `\lean{AlgebraicGeometry.pushPull_sigma_iso}` (chapter: `lem:pushPull_sigma_iso`)
- **Lean target exists**: yes — lines 586–591. Body: `:= sorry`. ✓
- **Signature matches**: yes. ✓
- **notes**: Has `\leanok`. Tagged HARD (new-infra leaf, the single hardest open stub).

### `\lean{AlgebraicGeometry.pushPull_leg_sections}` (chapter: `lem:pushPull_leg_sections`)
- **Lean target exists**: yes — lines 624–644. Body: fully proved (no sorry). ✓
- **Signature matches**: yes. Returns an iso of presheaf objects at the Ab-group level, consistent with "isomorphism of section groups". ✓
- **Proof follows sketch**: yes. Three-step chain: `restrictFunctorIsoPullback` + `eqToIso` using `image_preimage_eq_opensRange_inf` + `opensRange_ι`. Matches blueprint steps (1)+(2)+(3). ✓
- **notes**: Has `\leanok`. No issues.

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`)
- **Lean target exists**: yes — lines 673–682. Body: `:= sorry`. ✓
- **Signature matches**: yes. Product of section groups over multi-indices. ✓
- **notes**: Has `\leanok`. Properly typed assembly stub (awaits `pushPull_sigma_iso`).

### `\lean{AlgebraicGeometry.cechSection_complex_iso}` + `\lean{AlgebraicGeometry.sectionCechComplexV}` (chapter: `lem:cechSection_complex_iso`)
- **Lean target exists**: yes — `cechSection_complex_iso` at lines 737–752 (body `:= sorry`); `sectionCechComplexV` at lines 689–692 (proved abbrev). ✓
- **Signature matches**: yes. The augmented form `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε` is correct per the blueprint's `% NOTE: build target — augmented form` at line 8066–8071. ✓
- **notes**: **CRITICAL** — Statement block has **no `\leanok`** at line 8061 despite the sorry declaration existing. By contrast `lem:cechSection_contractible` (same file, same sorry tier) has `\leanok` at line 8137. This inconsistency strongly suggests `sync_leanok` failed to verify `cechSection_complex_iso` — likely a universe mismatch or elaboration failure in the `let`-binding chain (`D` lives in `CochainComplex AddCommGrpCat ℕ` while `sectionCechComplexV` returns `CochainComplex Ab.{u} ℕ`; for `u > 0` these differ). **This is a must-fix-this-iter issue.**

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`)
- **Lean target exists**: yes — lines 804–811. Body: `:= sorry`. ✓
- **Signature matches**: yes. `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0`. Correctly re-signed to augmented form per `% NOTE`. ✓
- **notes**: Has `\leanok`. Correctly typed. Blueprint proof sketch (lines 8174–8216) is detailed and gives a complete route via the `dep*` engine plus an explicit augmentation-node verification.

---

## Red flags

### Leanok gaps — multiple proved declarations missing `\leanok`

The following declarations are **fully proved** (no sorry) but their blueprint statement blocks lack `\leanok`:

| Declaration | Blueprint label | Lines |
|---|---|---|
| `widePullback_overX_eq_prod` / `widePullback_overX_isLimit` | `lem:widePullback_overX_eq_prod` (7561) | 54–85 |
| `widePullback_coproduct_iso` / `prodFinSuccIso` | `lem:coproduct_distrib_fibrePower` (7735) | 134–156, 363–386 |
| `widePullback_openImm_inter` / `mem_iInf_opens_of_finite` | `lem:widePullback_openImm_inter` (7806) | 413–459 |
| `coverArrowOverSigmaIso` + companions / `overSigmaDescIso` etc. | `lem:coverArrow_over_sigma` (7900) | 88–125, 463–494 |

`sync_leanok` apparently could not verify these declarations this iteration. This is consistent with `CechSectionIdentification.lean` being git-untracked (`??`) — if `sync_leanok` only scans git-tracked files, it would miss the new declarations. The `\leanok` markers present on other declarations (like `prod_coproduct_distrib`, `overProd_coproduct_distrib`) reflect their pre-existing state from prior iterations where those declarations lived in already-tracked files.

**Action needed**: Confirm the file builds (`lake build AlgebraicJacobian.Cohomology.CechSectionIdentification`), add the file to git tracking, and re-run `sync_leanok`. Until these `\leanok` gaps are resolved, `lem:cech_backbone_left_sigma`'s dependency-graph path appears incomplete in the blueprint web.

### Critical: `lem:cechSection_complex_iso` missing `\leanok` (compilation suspected)

- `cechSection_complex_iso` at lines 737–752 is `:= sorry` but has **no** `\leanok` on its statement block (blueprint line 8061), while the identical-tier `cechSection_contractible` (lines 804–811) does have `\leanok`.
- The `cechSection_complex_iso` return type uses `let D := (GV.mapHomologicalComplex cc).obj Kp` where `GV` maps into `AddCommGrpCat` (universe 0), while the RHS `(sectionCechComplexV 𝒰 F V).augment ε hε` is in `Ab.{u}` (universe u). For `u > 0` this is a universe mismatch.
- **Severity: must-fix-this-iter.** The prover should check whether the elaboration fails and either fix the universe on the `D` side (by annotating `AddCommGrpCat.{u}`) or adjust `sectionCechComplexV`'s universe.

### Stale `% NOTE: build target` comments

- **`lem:overProd_coproduct_distrib`** (blueprint line 7654): `% NOTE: build target. The Lean declaration does not exist yet` — stale; `overProd_coproduct_distrib` is proved. Review agent should update this to `% NOTE: (resolved iter-059)` or remove.
- **`lem:coproduct_distrib_fibrePower`** (blueprint line 7740): `% NOTE: build target. The Lean declaration does not exist yet` — stale; `widePullback_coproduct_iso` is proved. Same action.

### Placeholder / suspect bodies

| Declaration | Line | Note |
|---|---|---|
| `cechBackbone_left_sigma` | 541 | `:= sorry` — known universe blocker, correctly typed |
| `pushPull_sigma_iso` | 591 | `:= sorry` — known HARD leaf (new sheaf infra) |
| `pushPull_eval_prod_iso` | 682 | `:= sorry` — downstream from pushPull_sigma_iso |
| `cechSection_complex_iso` | 752 | `:= sorry` + possible compilation error (see above) |
| `cechSection_contractible` | 811 | `:= sorry` — correctly typed, engine ready |

No axiom declarations found. No `Classical.choice` on non-trivial claims.

---

## Unreferenced declarations (informational)

### No blueprint block — new helpers (acceptable)
- `coprodFirst_distrib` (line 223): Covers the "coproduct-in-first-arg" form `∐i pullback(gᵢ, b) ≅ pullback(∐g, b)` — the **second form** of `lem:prod_coproduct_distrib` which the blueprint claims is covered. NOT in the `\lean{}` pin. **Should be added to `lem:prod_coproduct_distrib`'s `\lean{}` pin.** (major)
- `pcd_hom_fst` (line 233): Proof helper for `overProd_coproduct_distrib`. Pure infrastructure, no blueprint block needed.
- `pcd_hom_snd` (line 254): Proof helper. Same.
- `cf_hom_fst` (line 275): Proof helper. Same.
- `overSigma_hom_eq` (line 285, private): Private proof helper. OK.

### No blueprint block — new substantive decl
- `overProd_coproduct_distrib_right` (line 355): "Right-handed one-sided distributivity in `Over S`: `A ⨯ (∐ᵢ Yᵢ) ≅ ∐ᵢ (A ⨯ Yᵢ)`". Used in the inductive step of `widePullback_coproduct_iso` (line 381). Derived from `overProd_coproduct_distrib` by braiding. Not mentioned in any `\lean{}` pin. The blueprint proof sketch for `lem:coproduct_distrib_fibrePower` (line 7793–7794) says "binary-product form (Lemma~{lem:overProd_coproduct_distrib})" without distinguishing left/right-handed variants. **Should be added to `lem:overProd_coproduct_distrib`'s `\lean{}` pin or noted in `lem:coproduct_distrib_fibrePower`'s proof.** (major)

---

## Blueprint adequacy for this file

### Coverage
- 16 Lean declarations have a `\lean{}` block in the chapter.
- 4 purely private helpers (+ `overSigma_hom_eq`) have no block: acceptable.
- 1 substantive unreferenced: `overProd_coproduct_distrib_right` (flagged).
- 1 partially unreferenced: `coprodFirst_distrib` covers the second form of `lem:prod_coproduct_distrib` but is not in the `\lean{}` pin (flagged).

### Proof-sketch depth: **under-specified** for two blocks

1. **`lem:overProd_coproduct_distrib`**: The sketch says "it suffices to identify the underlying objects" via `Over.prodLeftIsoPullback` and `prod_coproduct_distrib`, and that structure maps commute "by construction". In practice the prover needed four helper lemmas (`pcd_hom_fst`, `pcd_hom_snd`, `cf_hom_fst`, `overSigma_hom_eq`) to verify the explicit compatibility conditions. The blueprint gives no guidance for these steps.

2. **`lem:cech_backbone_left_sigma` proof sketch** (lines 7869–7898): The sketch omits the intermediate `widePullback_overX_eq_prod` step between applying `widePullback_coproduct_iso` (which outputs `∏ᶜ` form in `Over S`) and applying `widePullback_openImm_inter` (which takes the wide pullback form). Without this bridging step explicitly mentioned, a prover reading the sketch would not know it is needed. (The Lean docstring at line 199–204 notes this normal-form choice, but the blueprint doesn't.)

3. **Universe reduction** in `lem:cech_backbone_left_sigma` (lines 7887–7898): Correct in principle, but gives no Lean API names. The prover needs `Fintype.equivFin`, `Sigma.whiskerEquiv` (or similar) to perform the reindexing — these are non-obvious. Recommend adding at least `Fintype.equivFin` as a hint.

### Hint precision: **loose** for `lem:coproduct_distrib_fibrePower`

The blueprint statement uses "wide fibre power" but the Lean signature uses `∏ᶜ` (slice categorical product). These are isomorphic via `widePullback_overX_eq_prod` but not definitionally equal. A prover reading the blueprint might implement the wrong output type. Recommend adding a prose note: "In the Lean declaration the σ-component is the slice product `∏ᶜ (fun k => Over.mk (f (σ k)))` rather than the wide pullback, connected by `widePullback_overX_eq_prod`."

### Generality: **matches need**

No parallel API was invented outside the blueprint's scope. The abstract `FinitaryPreExtensive`-level formulation is appropriate.

### Recommended chapter-side actions

1. **Add** `CategoryTheory.FinitaryPreExtensive.coprodFirst_distrib` to `lem:prod_coproduct_distrib`'s `\lean{}` pin (it covers the second stated form).
2. **Add** `CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib_right` to `lem:overProd_coproduct_distrib`'s `\lean{}` pin (or note it as a corollary in `lem:coproduct_distrib_fibrePower`'s proof sketch).
3. **Remove** stale `% NOTE: build target. The Lean declaration does not exist yet` from `lem:overProd_coproduct_distrib` (line 7654) and `lem:coproduct_distrib_fibrePower` (line 7740).
4. **Add** a prose sentence to `lem:coproduct_distrib_fibrePower`'s statement: "In the Lean formalization, the σ-component is expressed as the slice product `∏ᶜ (fun k => Over.mk (f (σ k)))` (connected to the wide fibre power by `lem:widePullback_overX_eq_prod`)."
5. **Expand** `lem:cech_backbone_left_sigma`'s proof sketch to mention the `widePullback_overX_eq_prod` step between `lem:coproduct_distrib_fibrePower` and `lem:widePullback_openImm_inter`.
6. **Add** `Fintype.equivFin` hint to the universe-reduction paragraph of `lem:cech_backbone_left_sigma`.

---

## Severity summary

| Finding | Severity |
|---|---|
| `lem:cechSection_complex_iso` missing `\leanok` — possible universe mismatch in `D` vs. `Ab.{u}` return type | **must-fix-this-iter** |
| Multiple proved declarations lack `\leanok` — suggests `sync_leanok` is not tracking `CechSectionIdentification.lean` (git-untracked file) | **major** |
| `coprodFirst_distrib` covers second form of `lem:prod_coproduct_distrib` but not in `\lean{}` pin | **major** |
| `overProd_coproduct_distrib_right` is a substantive new decl with no blueprint block or `\lean{}` pin | **major** |
| Stale `% NOTE: build target` on `lem:overProd_coproduct_distrib` and `lem:coproduct_distrib_fibrePower` | **major** |
| σ-normal-form divergence: `widePullback_coproduct_iso` outputs `∏ᶜ` (slice product), blueprint says "wide fibre power"; bridging step via `widePullback_overX_eq_prod` undocumented in `lem:cech_backbone_left_sigma` proof sketch | **major** |
| `lem:overProd_coproduct_distrib` proof sketch under-specified (no guidance for `pcd_hom_*` / `cf_hom_fst` compatibility sub-steps) | **minor** |
| `lem:cech_backbone_left_sigma` universe-reduction paragraph lacks Lean API names | **minor** |
| `pcd_hom_fst`, `pcd_hom_snd`, `cf_hom_fst`, `overSigma_hom_eq` are proof helpers with no blueprint blocks — acceptable infrastructure | informational |

**Overall verdict**: The 8 new declarations are mathematically well-formed and correctly typed; the primary blocker is the likely compilation failure of `cechSection_complex_iso` (universe mismatch in the `let D` expression), with secondary issues being stale blueprint notes, two missing `\lean{}` pins (`coprodFirst_distrib`, `overProd_coproduct_distrib_right`), and an underdocumented σ-normal-form bridge step in the `cech_backbone_left_sigma` proof sketch.
