# Lean ↔ Blueprint Check Report

## Slug
grquot-iter059

## Iteration
059

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackComp}` (chapter: `def:modules_pullbackComp`)
- **Lean target exists**: N/A — `\mathlibok` (Mathlib-provided; no Archon obligation)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correctly marked `\mathlibok`; no declaration expected in this file.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackBaseChangeTransport}` (chapter: `lem:modules_pullback_basechange_transport`)
- **Lean target exists**: yes — line 333
- **Signature matches**: yes — `(p : W ⟶ V)(a : V ⟶ Yi)(b : V ⟶ Yj)(g : pullback a).obj Mi ≅ (pullback b).obj Mj` producing `(pullback(p≫a)).obj Mi ≅ (pullback(p≫b)).obj Mj`; matches blueprint description exactly
- **Proof follows sketch**: yes — `pullbackComp.symm.app Mi ≪≫ pullback(p).mapIso g ≪≫ pullbackComp.app Mj`; blueprint says "pull back along p and reassociate via pullbackComp on both sides"
- **notes**: `\leanok` present; proof is axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glueData_bridge_src, glueData_bridge_mid, glueData_bridge_tgt}` (chapter: `lem:gr_glueData_bridges`)
- **Lean target exists**: yes — lines 346, 355, 367
- **Signature matches**: yes — all three match the blueprint's three equalities: (src) `pullback.condition`, (mid) `t_fac`-consequence, (tgt) cocycle core
- **Proof follows sketch**: yes — each is a one-liner using `pullback.condition`, `D.t_fac`, `D.t_inv`, `D.cocycle`; blueprint sketch is accurate
- **notes**: **No `\leanok` marker on either statement or proof block** despite these being fully proved in iter-052 (axiom-clean per memory). Blueprint block `lem:gr_glueData_bridges` lacks `\leanok`. Likely a `sync_leanok` failure on comma-separated multi-name `\lean{...}` blocks.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glue}` (chapter: `def:scheme_modules_glue`)
- **Lean target exists**: yes — line 382
- **Signature matches**: yes — takes `(D : Scheme.GlueData)(M : ∀ i, (D.U i).Modules)(g : ∀ i j, (pullback D.f i j).obj (M i) ≅ (pullback (D.t i j ≫ D.f j i)).obj (M j))` plus `(_hC1)` and `(_hC2)` hypotheses; returns `D.glued.Modules`; matches blueprint exactly
- **Proof follows sketch**: yes — body is the equalizer-of-pushforwards construction described in the blueprint's Construction paragraph; `_hC1`/`_hC2` unused in the object construction itself (correctly noted in both blueprint and Lean comment)
- **notes**: `\leanok` present; axiom-clean per memory; body matches blueprint description.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionIso}` (chapter: `def:gr_modules_glueRestrictionIso`)
- **Lean target exists**: no — no declaration with this name exists in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correctly annotated `% NOTE: forward declaration (planned work); the \lean{} target is not yet realised.` Blueprint marks this as pending planned work; consistent with current state.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glue_unique}` (chapter: `lem:gr_modules_glue_unique`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correctly annotated as planned forward declaration; consistent.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glueHom}` (chapter: `def:gr_modules_glueHom`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correctly annotated as planned forward declaration; consistent.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.opensMap_final}` (chapter: `lem:gr_opensMap_final`)
- **Lean target exists**: yes — line 463
- **Signature matches**: yes — `(φ : T' ⟶ T) : (Opens.map φ.base).Final`; matches blueprint
- **Proof follows sketch**: yes — terminal object `⊤` in the structured-arrow category, `zigzag_isConnected`; blueprint says exactly this
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso}` (chapter: `lem:gr_pullbackFreeIso`)
- **Lean target exists**: yes — line 482
- **Signature matches**: yes — `(φ : T' ⟶ T)(I : Type u) : (pullback φ).obj (free I) ≅ free I`; matches blueprint
- **Proof follows sketch**: yes — uses `opensMap_final φ` then `pullbackObjFreeIso`; blueprint says exactly this
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullback_isLocallyFreeOfRank}` (chapter: `lem:gr_pullback_isLocallyFreeOfRank`)
- **Lean target exists**: yes — line 505
- **Signature matches**: yes — `(φ : T' ⟶ T)(h : IsLocallyFreeOfRank M d) : IsLocallyFreeOfRank (pullback φ).obj M d`; matches blueprint
- **Proof follows sketch**: yes — preimage cover, `pullbackComp`, `morphismRestrict_ι`, `pullbackFreeIso`; blueprint describes this chain
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}` (chapter: `def:gr_globalUnitSection`)
- **Lean target exists**: yes — line 37
- **Signature matches**: yes — `(a : Γ(X,⊤)) : (SheafOfModules.unit X.ringCatSheaf).sections`; matches blueprint "section of the unit sheaf attached to a global function"
- **Proof follows sketch**: yes — `PresheafOfModules.sectionsMk` with restriction by functoriality; blueprint says exactly this
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}` (chapter: `def:gr_scalarEnd`)
- **Lean target exists**: yes — line 50
- **Signature matches**: yes — `(a : Γ(X,⊤)) : unit X.ringCatSheaf ⟶ unit X.ringCatSheaf`; blueprint says "endomorphism of the unit module given by multiplication by a"
- **Proof follows sketch**: yes — via `unitHomEquiv.symm (globalUnitSection a)` using the `End(1) ≅ Γ(1)` identification; blueprint describes this
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_one}` (chapter: `lem:gr_scalarEnd_one`)
- **Lean target exists**: yes — line 56
- **Signature matches**: yes — `scalarEnd (1 : Γ(X,⊤)) = 𝟙 (unit X.ringCatSheaf)`; matches blueprint
- **Proof follows sketch**: yes — `map_one` via `unitHomEquiv`
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_zero}` (chapter: `lem:gr_scalarEnd_zero`)
- **Lean target exists**: yes — line 67
- **Signature matches**: yes — `scalarEnd (0 : Γ(X,⊤)) = 0`; matches blueprint
- **Proof follows sketch**: yes — `map_zero` + `rfl`
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` (chapter: `def:gr_chart_quotient`)
- **Lean target exists**: yes — line 224
- **Signature matches**: yes — `(d r : ℕ)(I : Finset (Fin r))(hI : I.card = d) : free (Fin r) ⟶ free (Fin d)` over `(affineChart d r I)`; matches blueprint "matrix X^I realised via biproduct"
- **Proof follows sketch**: yes — `biproduct.matrix` with `scalarEnd` entries from `universalMatrix` via `ΓSpecIso`; blueprint describes this Realisation paragraph
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` (chapter: `lem:gr_chartQuotientMap_iFree`)
- **Lean target exists**: yes — line 240
- **Signature matches**: yes — `ιFree (I.orderIsoOfFin hI k) ≫ chartQuotientMap d r I hI = ιFree k`; matches blueprint "I-th columns are the identity"
- **Proof follows sketch**: yes — `universalMatrix_submatrix_self` + `scalarEnd_one`/`scalarEnd_zero`; blueprint describes this
- **notes**: `\leanok` present. **CONCERN**: declaration is `private lemma` in Lean; `AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree` is not a valid public name. `sync_leanok` may fail to look this up correctly by qualified name. Minor: functions correctly as an internal helper; the public `chartQuotientMap_epi` is what matters.

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_epi}` (chapter: `lem:gr_chartQuotientMap_epi`)
- **Lean target exists**: yes — line 282
- **Signature matches**: yes — `Epi (chartQuotientMap d r I hI)`; matches blueprint "split epimorphism"
- **Proof follows sketch**: yes — `IsSplitEpi.mk'` with section `freeMap (I.orderIsoOfFin hI ·)`; blueprint describes the split section argument
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition}` (chapter: `def:gr_bundleTransition`)
- **Lean target exists**: yes — line 565
- **Signature matches**: yes — `(pullback (chartIncl I J)).obj (free (Fin d)) ≅ (pullback (chartTransition I J ≫ chartIncl J I)).obj (free (Fin d))`; matches blueprint `f_{IJ}^*(O^d_{U^I}) ≅ (t_{IJ} ∘ f_{JI})^*(O^d_{U^J})`
- **Proof follows sketch**: yes — `pullbackFreeIso ≪≫ matrixToFreeIso (universalMinorInv …) … ≪≫ pullbackFreeIso.symm`; blueprint Realisation paragraph describes exactly this conjugation
- **notes**: **STALE `% NOTE:`** in blueprint — "forward declaration (planned work); the `\lean{}` target is not yet realised" — but the declaration IS realized this iter with no `sorry`. **Missing `\leanok`** on both statement and definition body. `sync_leanok` should have added this; the stale `% NOTE:` may be interfering or `sync_leanok` ran before this iter's prover work landed.

---

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_self}` (chapter: `lem:gr_bundleCocycle_id`)
- **Lean target exists**: yes — line 591
- **Signature matches**: yes — `bundleTransition d r I I hI hI = eqToIso (congrArg (fun φ => (pullback φ).obj (free (Fin d))) (show chartIncl I I hI hI = chartTransition I I hI hI ≫ chartIncl I I hI hI from …))`; matches the `_hC1` hypothesis form of `Scheme.Modules.glue` and blueprint "self-transition is identity in the form required by `def:scheme_modules_glue` (C1)"
- **Proof follows sketch**: yes — `universalMinorInv_self` → `map_one` → `matrixEnd_one` → `pullbackFreeIso_eqToHom`; blueprint says "I-th minor is identity → Cramer inverse is identity → assembled automorphism is identity → conjugation by free-pullback comparisons preserves identity"
- **notes**: **STALE `% NOTE:`** in blueprint — same issue as `bundleTransition`: declaration and proof are complete (no `sorry`), but blueprint still says "not yet realised". **Missing `\leanok`** on both statement block and proof block. The proof is axiom-clean and follows the blueprint sketch closely.

---

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle}` (chapter: `lem:gr_bundleCocycle_mul`)
- **Lean target exists**: yes — line 630; body is `:= sorry`
- **Signature matches**: yes — full `_hC2` hypothesis of `Scheme.Modules.glue` instantiated at `theGlueData d r` and `bundleTransitionData d r`; matches blueprint (C2) equation `ĝ_{JK} ∘ ĝ_{IJ} = ĝ_{IK}` in the form required by `glue`
- **Proof follows sketch**: N/A (`sorry`)
- **notes**: Blueprint `% NOTE:` correctly marks this as "the hard step"; sorry is authorized. See **Blueprint Adequacy** section for guidance gap analysis.

---

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}` (chapter: `def:gr_universal_quotient_sheaf`)
- **Lean target exists**: yes — line 669; body is `:= sorry`
- **Signature matches**: yes — `(d r : ℕ) : (scheme d r).Modules`; matches blueprint "locally free O_{Gr(d,r)}-module U of rank d"
- **Proof follows sketch**: N/A (`sorry`)
- **notes**: Blueprint has `\leanok` on statement block (declaration exists with sorry) but not on proof block — correct per marker semantics. Blueprint comment accurately describes the missing C2 cocycle as the only upstream gap.

---

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (chapter: `def:tautological_quotient`)
- **Lean target exists**: yes — line 679; body is `:= sorry`
- **Signature matches**: yes — `free (Fin r) ⟶ universalQuotient d r` over `(scheme d r)`; matches blueprint `u : O^r ↠ U`
- **Proof follows sketch**: N/A (`sorry`)
- **notes**: Blueprint has `\leanok` on statement block; correct. Rides on `universalQuotient` which rides on C2.

---

### `\lean{AlgebraicGeometry.Grassmannian.RankQuotient}` + related (chapter: `def:gr_rankQuotient`)
- **Lean target exists**: yes — `RankQuotient` (line 701), `RankQuotient.Rel` (line 714), `rel_refl`/`rel_symm`/`rel_trans` (lines 717–732), `rqSetoid` (line 735), `rqPullback` (line 743), `rqPullback_rel` (line 758); all without sorry
- **Signature matches**: yes — all match blueprint definitions: structure with `F`, `q : free (Fin r) ⟶ F`, `epi`, `locFree`; `Rel` as `∃ f : x.F ≅ y.F, x.q ≫ f.hom = y.q`; `rqPullback` using `pullbackFreeIso.inv`; all consistent
- **Proof follows sketch**: partial — no proof sketch in blueprint for these (definition blocks only); Lean proofs are direct
- **notes**: All proved without sorry. No `\leanok` visible on `def:gr_rankQuotient` statement block — likely a `sync_leanok` issue with multi-name `\lean{...}` blocks (8 names). Minor concern.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_id}` (chapter: `lem:gr_pullbackObjUnitToUnit_id`)
- **Lean target exists**: yes — line 779
- **Signature matches**: yes — `pullbackObjUnitToUnit (𝟙 T) = (pullbackId T).hom.app (unit)`; matches blueprint "comparison for id agrees with pullbackId component"
- **Proof follows sketch**: yes — mate/conjugate argument via `unit_conjugateEquiv` + `conjugateEquiv_pullbackId_hom`
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_id}` (chapter: `lem:gr_pullbackFreeIso_id`)
- **Lean target exists**: yes — line 806
- **Signature matches**: yes — `(pullbackFreeIso (𝟙 T) I).hom = (pullbackId T).hom.app (free I)`; matches blueprint
- **Proof follows sketch**: yes — coproduct extensionality reducing to `pullbackObjUnitToUnit_id`; blueprint describes this
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.homEquiv_conjugateEquiv_app}` (chapter: `lem:gr_homEquiv_conjugateEquiv_app`)
- **Lean target exists**: yes — line 833
- **Signature matches**: yes — `adj₂.homEquiv c d (α.app c ≫ f) = adj₁.homEquiv c d f ≫ (conjugateEquiv adj₁ adj₂ α).app d`; matches blueprint "hom-equivalence of adj₂ applied to α_c ∘ f equals ... post-composed with conjugate component"
- **Proof follows sketch**: yes — term-mode composition of `homEquiv_unit` expansions and whiskering; blueprint says "pasting of unit/counit triangles"
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (chapter: `lem:gr_pullbackObjUnitToUnit_comp`)
- **Lean target exists**: yes — line 874
- **Signature matches**: yes — `(pullbackComp b a).hom.app unit ≫ pullbackObjUnitToUnit (b≫a) = pullback(b).map (pullbackObjUnitToUnit a) ≫ pullbackObjUnitToUnit b`; matches blueprint "comparison for b∘a factors through pullbackComp"
- **Proof follows sketch**: yes — mate/conjugate + `conjugateEquiv_pullbackComp_inv` + section-level `rfl`; blueprint sketch matches
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_comp}` (chapter: `lem:gr_pullbackFreeIso_comp`)
- **Lean target exists**: yes — line 951
- **Signature matches**: yes — `(pullbackComp b a).hom.app (free I) ≫ (pullbackFreeIso (b≫a) I).hom = pullback(b).map (pullbackFreeIso a I).hom ≫ (pullbackFreeIso b I).hom`; matches blueprint
- **Proof follows sketch**: yes — coproduct extensionality reducing to `pullbackObjUnitToUnit_comp`; blueprint describes this
- **notes**: `\leanok` present; clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.functor}` (chapter: `def:grassmannian_functor`)
- **Lean target exists**: yes — line 1094
- **Signature matches**: yes — `(d r : ℕ) : Scheme.{0}ᵒᵖ ⥤ Type 1`; blueprint prose says "contravariant functor from schemes to sets". **Minor**: `Type 1` vs "sets" — universe not mentioned in blueprint but forced by the large-object issue (noted in Lean docstring only, not in blueprint prose)
- **Proof follows sketch**: yes — `map_id` via `pullbackFreeIso_id`, `map_comp` via `pullbackFreeIso_comp`; blueprint mentions these coherences discharge functoriality
- **notes**: `\leanok` present; all functoriality axioms proved. Blueprint should mention `Type 1` universe.

---

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (chapter: `thm:grassmannian_universal_property`)
- **Lean target exists**: yes — line 1173; body is `:= sorry`
- **Signature matches**: yes — `(d r : ℕ)(hd : 1 ≤ d)(hdr : d ≤ r) : (functor d r).RepresentableBy (scheme d r)`; matches blueprint "Gr(r,d) represents the Grassmannian functor"
- **Proof follows sketch**: N/A (`sorry`)
- **notes**: Blueprint has `\leanok` on theorem statement (correct); no `\leanok` on proof block (correct, sorry present). Rides on `tautologicalQuotient`. Blueprint proof sketch is detailed and faithful to Nitsure §1.

---

## Red Flags

### Placeholder / suspect bodies
- `bundleTransition_cocycle` at line 650: `:= sorry`; blueprint `lem:gr_bundleCocycle_mul` marks this as planned open work (`% NOTE:`) — authorized.
- `universalQuotient` at line 670: `:= sorry`; blueprint `def:gr_universal_quotient_sheaf` has `\leanok` on statement (exists as sorry) but no `\leanok` on definition-body — authorized, waiting on C2.
- `tautologicalQuotient` at line 681: `:= sorry`; same status — authorized.
- `represents` at line 1175: `:= sorry`; blueprint has `\leanok` on theorem statement, no `\leanok` on proof block — authorized.
- **All four sorries are correctly authorized by the blueprint.**

### Stale excuse-annotations in the blueprint (not in Lean — but misleading)
- `blueprint/src/chapters/Picard_GrassmannianQuot.tex`, `def:gr_bundleTransition` block: `% NOTE: forward declaration (planned work); the \lean{} target is not yet realised.` — **STALE**: `AlgebraicGeometry.Grassmannian.bundleTransition` is fully realized this iter with no sorry. The `% NOTE:` is incorrect.
- Same tex file, `lem:gr_bundleCocycle_id` block: `% NOTE: forward declaration (planned work); the \lean{} target is not yet realised.` — **STALE**: `AlgebraicGeometry.Grassmannian.bundleTransition_self` is fully proved (no sorry) this iter. The `% NOTE:` is incorrect.

### Missing `\leanok` markers (likely `sync_leanok` failures)
- `lem:gr_glueData_bridges`: all three of `glueData_bridge_src/mid/tgt` are proved without sorry (iter-052) but the block has no `\leanok`. Likely a `sync_leanok` failure on comma-separated multi-declaration `\lean{...}` blocks.
- `def:gr_bundleTransition`: definition is complete (no sorry) — statement block should have `\leanok`.
- `lem:gr_bundleCocycle_id`: proof is complete (no sorry) — both statement and proof blocks should have `\leanok`.
- `def:gr_rankQuotient`: all 8 referenced declarations are proved without sorry — statement block should have `\leanok`. Again a multi-name block.

---

## Unreferenced declarations (informational)

### Unreferenced but should have blueprint entries (substantive)

| Declaration | Line | Role | Blueprint gap |
|---|---|---|---|
| `matrixEnd` | 147 | Core: `d×d` matrix of global sections → endomorphism of free rank-d sheaf | Described only in prose of `def:gr_bundleTransition` Realisation paragraph; no `\lean{...}` ref |
| `matrixEnd_comp` | 169 | `matrixEnd M ≫ matrixEnd N = matrixEnd (N * M)` | Underlies C2; not referenced anywhere in blueprint |
| `matrixEnd_one` | 185 | `matrixEnd 1 = 𝟙` | Underlies `bundleTransition_self`; not referenced |
| `matrixToFreeIso` | 201 | Invertible matrix → isomorphism of free sheaves | Used directly in `bundleTransition`; not in blueprint |
| `bundleTransitionData` | 611 | Packages per-chart cocycle data to feed `Scheme.Modules.glue` | Instantiates the `g` argument of `glue`; not in blueprint |
| `universalMinorInv_self` | 533 | `universalMinorInv I I hI hI = 1` | Key lemma for C1; not referenced; `lem:gr_universalMinorInv_identities` is referenced in the proof block but not this Lean name |
| `pullbackFreeIso_eqToHom` | 491 | `eqToHom ≫ (pullbackFreeIso ψ I).hom = (pullbackFreeIso φ I).hom` | Used in `bundleTransition_self`; not in blueprint |

### Unreferenced helpers (acceptable as project-local)

| Declaration | Line | Notes |
|---|---|---|
| `scalarEnd_val_app` | 80 | Internal `rfl`-proof |
| `unitHomEquiv_scalarEnd` | 86 | Internal helper |
| `scalarEnd_val_app_one` | 91 | Internal helper |
| `scalarEnd_comp` | 98 | `scalarEnd a ≫ scalarEnd b = scalarEnd (a*b)` — underlies `matrixEnd_comp` |
| `scalarEnd_add` | 112 | `scalarEnd (a+b) = scalarEnd a + scalarEnd b` — underlies `matrixEnd` |
| `scalarEnd_sum` | 123 | `scalarEnd (∑ f i) = ∑ scalarEnd (f i)` |
| `hasFiniteBiproducts_modules` | 140 | Instance; pure infrastructure |
| `matrixToFreeIso_hom` | 210 | `@[simp]` unfold lemma |
| `chartQuotientMap_ιFree` | 240 | `private`; referenced by blueprint but inaccessible by public name |
| `bundleMatrix_cancel` | 541 | `private`; GL_d invertibility for `matrixToFreeIso` in `bundleTransition` |
| `biproduct_matrix_comp` | 156 | `private`; categorical matrix product for `matrixEnd_comp` |

---

## Blueprint adequacy for this file

- **Coverage**: 30/52 Lean declarations (counting all `\lean{...}` references) have a corresponding blueprint block. Unreferenced declarations: ~15 helpers (acceptable, mostly `private`) + 7 substantive public declarations flagged above (`matrixEnd`, `matrixEnd_comp`, `matrixEnd_one`, `matrixToFreeIso`, `bundleTransitionData`, `universalMinorInv_self`, `pullbackFreeIso_eqToHom`).

- **Proof-sketch depth**: **under-specified** for one block.
  - `lem:gr_bundleCocycle_mul` (`bundleTransition_cocycle`): The sketch correctly identifies the matrix-level reduction `(X^J_K)^{-1}(X^I_J)^{-1} = (X^I_K)^{-1}` and the transport via `pullbackBaseChangeTransport`+`glueData_bridge_*`. However, it omits the intermediate step that ties matrix multiplication to composition of morphisms: the prover needs `matrixEnd_comp` (which reduces to `biproduct_matrix_comp` + `scalarEnd_comp`) to make "biproduct assembly turns matrix multiplication into composition" concrete. A prover cannot derive `matrixEnd_comp` from the blueprint alone. Similarly, `pullbackFreeIso_eqToHom` (used in `bundleTransition_self`) is entirely absent from the blueprint.
  - All other proof sketches are adequate.

- **Hint precision**: **partial** for the `matrixEnd`/`matrixToFreeIso` layer. The blueprint's Realisation paragraph for `def:gr_bundleTransition` describes the construction correctly but uses only prose; the actual Lean names `matrixEnd`, `matrixToFreeIso` are not pinned. A prover must infer the right abstraction.

- **Generality**: **matches need** — the blueprint is at the right level of generality for all formalized declarations.

- **Recommended chapter-side actions** (for the blueprint-writing or review subagent):
  1. Remove the stale `% NOTE: forward declaration (planned work); the \lean{} target is not yet realised.` annotations from `def:gr_bundleTransition` and `lem:gr_bundleCocycle_id`. Add/verify `\leanok` on both blocks (both statement and proof/body).
  2. Add a new blueprint block for `matrixEnd` (and optionally `matrixEnd_comp`, `matrixEnd_one`) with `\lean{AlgebraicGeometry.Grassmannian.matrixEnd}` in the infrastructure section of `sec:grquot_bundle_cocycle`. This is the direct precursor of `bundleTransition` and needs explicit coverage.
  3. Add `\lean{AlgebraicGeometry.Grassmannian.bundleTransitionData}` to the `def:gr_bundleTransition` block or as a separate packaging block.
  4. Extend the proof sketch of `lem:gr_bundleCocycle_mul` to mention that the matrix-multiplication-to-composition step uses `matrixEnd_comp` (the categorical matrix product `biproduct_matrix_comp`).
  5. Investigate and fix `sync_leanok` for multi-name `\lean{...}` blocks (`lem:gr_glueData_bridges`, `def:gr_rankQuotient`) — these lack `\leanok` despite being fully proved.
  6. Add `Type 1` note to `def:grassmannian_functor` prose.

---

## Severity Summary

### must-fix-this-iter
_None._ All four `sorry` bodies are correctly authorized by the blueprint. All `\lean{...}` pins point to real declarations. No wrong signatures, no unauthorized axioms, no actively misleading Lean-side placeholders.

### major
1. **Stale `% NOTE:` in blueprint** for `def:gr_bundleTransition` and `lem:gr_bundleCocycle_id`: both say "the `\lean{}` target is not yet realised" but both ARE realized (no sorry) in this iter's prover output. The review agent should remove these annotations and ensure `\leanok` is added.
2. **Missing `\leanok` markers** for `def:gr_bundleTransition` (statement+body), `lem:gr_bundleCocycle_id` (statement+proof), `lem:gr_glueData_bridges` (statement+proof), `def:gr_rankQuotient` (statement) — all fully proved in Lean, absent from blueprint markers.
3. **Missing `\lean{...}` for substantive public declarations**: `matrixEnd`, `matrixEnd_comp`, `matrixEnd_one`, `matrixToFreeIso`, `bundleTransitionData` — these form the core matrix-to-free-sheaf infrastructure that the bundle transition relies on, and are undocumented in the blueprint.

### minor
4. `chartQuotientMap_ιFree` is `private` in Lean but the blueprint pins it with its public qualified name; `sync_leanok` may mishandle this.
5. Missing `\lean{...}` for internal helpers `scalarEnd_comp`, `scalarEnd_add`, `scalarEnd_sum`, `universalMinorInv_self`, `pullbackFreeIso_eqToHom` — these underlie `bundleTransition_self` and `matrixEnd_comp`.
6. Blueprint proof sketch for `lem:gr_bundleCocycle_mul` (C2) does not reference `matrixEnd_comp`/`matrixToFreeIso` infrastructure, leaving the critical "matrix multiplication → composition" step unguided.
7. `def:grassmannian_functor` blueprint prose doesn't mention the `Type 1` universe (noted only in the Lean docstring).

**Overall verdict**: The Lean file is faithful to the blueprint for all realized declarations — signatures match, proofs follow sketches, no unauthorized axioms — but the blueprint has stale `% NOTE:` annotations for two declarations newly proved this iter, missing `\leanok` markers on several proved blocks (likely `sync_leanok` failures on multi-name blocks), and gaps in `\lean{...}` coverage for the `matrixEnd`/`matrixToFreeIso` infrastructure layer added this iter.
