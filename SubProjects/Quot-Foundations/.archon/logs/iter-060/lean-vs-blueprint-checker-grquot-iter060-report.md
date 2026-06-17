# Lean ↔ Blueprint Check Report

## Slug
grquot-iter060

## Iteration
060

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean` (1212 lines)
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (1434 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackComp}` (`def:modules_pullbackComp`)
- **Lean target exists**: N/A — marked `\mathlibok` (Mathlib)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correctly attributed to Mathlib; no Lean obligation in this file.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackBaseChangeTransport}` (`lem:modules_pullback_basechange_transport`)
- **Lean target exists**: yes (line 333)
- **Signature matches**: yes — `{W V Yi Yj : Scheme.{u}} (p : W ⟶ V) (a : V ⟶ Yi) (b : V ⟶ Yj) {Mi Mj} (g : pullback a Mi ≅ pullback b Mj)` yields `pullback (p ≫ a) Mi ≅ pullback (p ≫ b) Mj`, matching the prose.
- **Proof follows sketch**: yes — reassociate via `pullbackComp` on both sides, then mapIso `g`; matches blueprint.
- **notes**: Blueprint has `\leanok` on statement block; proof block has no `\leanok`, consistent (no sorry).

### `\lean{...glueData_bridge_src, ...glueData_bridge_mid, ...glueData_bridge_tgt}` (`lem:gr_glueData_bridges`)
- **Lean target exists**: yes (lines 346, 355, 367)
- **Signature matches**: yes — `src` = `pullback.condition`; `mid` and `tgt` match the prose equalities exactly.
- **Proof follows sketch**: yes — `src` is literally `pullback.condition`; `mid` adds `t_fac`; `tgt` chains `t_fac_assoc`, reversed pullback condition, `t_inv`, and `cocycle`. All match blueprint.
- **notes**: Blueprint's `\begin{lemma}\leanok` plus proof block without `\leanok` is consistent (no sorry in proofs).

### `\lean{AlgebraicGeometry.Scheme.Modules.glue}` (`def:scheme_modules_glue`)
- **Lean target exists**: yes (line 382)
- **Signature matches**: yes — takes `D : GlueData`, `M : ∀ i, (D.U i).Modules`, `g : ∀ i j, pullback f_ij Mi ≅ pullback (t_ij ≫ f_ji) Mj`, hypotheses `_hC1` (C1) and `_hC2` (C2), returns `D.glued.Modules`.
- **Proof follows sketch**: yes — the equalizer-of-pushforwards construction matches the blueprint's Construction paragraph exactly. C1/C2 hypotheses are unused in forming the object (both prefixed `_`), per blueprint's note.
- **notes**: Blueprint `\leanok` on statement block is correct (sorry-free body).

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionIso}` (`def:gr_modules_glueRestrictionIso`)
- **Lean target exists**: no — `% NOTE: forward declaration (planned work); the \lean{} target is not yet realised.`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint explicitly flags as forward declaration. No Lean obligation this iteration.

### `\lean{AlgebraicGeometry.Scheme.Modules.glue_unique}` / `\lean{...glueHom}` (`lem:gr_modules_glue_unique`, `def:gr_modules_glueHom`)
- **Lean target exists**: no — both carry `% NOTE: forward declaration (planned work)`.
- **notes**: Same as `glueRestrictionIso`; correctly deferred.

### `\lean{AlgebraicGeometry.Scheme.Modules.opensMap_final}` (`lem:gr_opensMap_final`)
- **Lean target exists**: yes (line 463)
- **Signature matches**: yes — `(φ : T' ⟶ T) → (Opens.map φ.base).Final`.
- **Proof follows sketch**: yes — constructs terminal object `⊤`, uses `zigzag_isConnected` with arrows `hs`, `ht` to `top`.
- **notes**: `\leanok` on statement and no proof `\leanok` consistent with sorry-free proof.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso}` (`lem:gr_pullbackFreeIso`)
- **Lean target exists**: yes (line 482)
- **Signature matches**: yes — `(φ : T' ⟶ T) (I : Type u) → pullback φ (SheafOfModules.free I) ≅ SheafOfModules.free I`.
- **Proof follows sketch**: yes — uses `opensMap_final φ` to enable `SheafOfModules.pullbackObjFreeIso`.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullback_isLocallyFreeOfRank}` (`lem:gr_pullback_isLocallyFreeOfRank`)
- **Lean target exists**: yes (line 518)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — pulls back the trivialising cover, uses `pullbackComp` + `pullbackCongr morphismRestrict_ι` + `pullbackFreeIso`. Matches blueprint.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}` (`def:gr_globalUnitSection`)
- **Lean target exists**: yes (line 37)
- **Signature matches**: yes — `(a : Γ(X, ⊤)) → (SheafOfModules.unit X.ringCatSheaf).sections`.
- **Proof follows sketch**: N/A (definition)
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}` (`def:gr_scalarEnd`)
- **Lean target exists**: yes (line 50)
- **Signature matches**: yes — `(a : Γ(X, ⊤)) → unit X.ringCatSheaf ⟶ unit X.ringCatSheaf`.
- **Proof follows sketch**: N/A (definition, via `unitHomEquiv.symm`).
- **notes**: Clean.

### `\lean{...scalarEnd_one}`, `\lean{...scalarEnd_zero}`, `\lean{...scalarEnd_comp}`, `\lean{...scalarEnd_add}` (`lem:gr_scalarEnd_*`)
- **Lean target exists**: yes (lines 56, 67, 98, 112)
- **Signature matches**: yes — all match prose.
- **Proof follows sketch**: yes for all four.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Grassmannian.matrixEnd}` (`def:gr_matrixEnd`)
- **Lean target exists**: yes (line 147)
- **Signature matches**: yes — `{S : Scheme.{0}} {d : ℕ} (M : Matrix (Fin d) (Fin d) Γ(S, ⊤)) → free (Fin d) ⟶ free (Fin d)`.
- **Proof follows sketch**: N/A (definition, biproduct assembly).
- **notes**: Clean. `S : Scheme.{0}` is the concrete universe, consistent with `hasFiniteBiproducts_modules` instance.

### `\lean{AlgebraicGeometry.Grassmannian.matrixEnd_comp}` / `matrixEnd_one` (`lem:gr_matrixEnd_comp`, `lem:gr_matrixEnd_one`)
- **Lean target exists**: yes (lines 169, 185)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `matrixEnd_comp` uses `biproduct_matrix_comp` + `scalarEnd_comp` + `scalarEnd_sum`; `matrixEnd_one` uses `scalarEnd_one`/`scalarEnd_zero`. Both match blueprint.
- **notes**: `biproduct_matrix_comp` is a private helper with no blueprint entry — acceptable.

### `\lean{AlgebraicGeometry.Grassmannian.matrixToFreeIso}` / `matrixToFreeIso_hom` (`def:gr_matrixToFreeIso`, `lem:gr_matrixToFreeIso_hom`)
- **Lean target exists**: yes (lines 201, 210)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Grassmannian.matrixToFreeIso_mul}` (`lem:gr_matrixToFreeIso_mul`)
- **Lean target exists**: **no** — no declaration `matrixToFreeIso_mul` anywhere in the file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint block has no `\leanok`; this is an open work item. Blueprint proof sketch is minimal: "By `matrixToFreeIso_hom` the two forward maps are `matrixEnd(A)` and `matrixEnd(B)`; composite is `matrixEnd(B·A)` by `matrixEnd_comp`." Simple one-liner once the three pieces exist. **Coverage debt — must be created before `bundleTransition_cocycle_transport` can be proved.** See Coverage debt section.

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` (`def:gr_chart_quotient`)
- **Lean target exists**: yes (line 224)
- **Signature matches**: yes — `(d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) → free (Fin r) ⟶ free (Fin d)` on the affine chart.
- **Proof follows sketch**: N/A (definition)
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` (`lem:gr_chartQuotientMap_iFree`)
- **Lean target exists**: yes (line 240) but declared **`private`**.
- **Signature matches**: yes — `ιFree (orderIsoOfFin hI k) ≫ chartQuotientMap = ιFree k`.
- **Proof follows sketch**: yes — checks entries via `universalMatrix_submatrix_self`, `scalarEnd_one`/`scalarEnd_zero`.
- **notes**: `private` means the fully-qualified name `AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree` is not externally accessible; the blueprint `\lean{}` pin is informational-only and won't resolve via `lean_verify`. Minor issue.

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_epi}` (`lem:gr_chartQuotientMap_epi`)
- **Lean target exists**: yes (line 282)
- **Signature matches**: yes — `Epi (chartQuotientMap d r I hI)`.
- **Proof follows sketch**: yes — exhibits split section via `freeMap (orderIsoOfFin)`, uses `IsSplitEpi.mk'`.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition}` (`def:gr_bundleTransition`)
- **Lean target exists**: yes (line 578)
- **Signature matches**: yes — `pullback (chartIncl I J) (free (Fin d)) ≅ pullback (chartTransition ≫ chartIncl J I) (free (Fin d))` using `pullbackFreeIso ≪≫ matrixToFreeIso ≪≫ (pullbackFreeIso …).symm`.
- **Proof follows sketch**: yes — matches the "realisation" paragraph: free-pullback comparisons conjugating the matrix automorphism.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_self}` (`lem:gr_bundleCocycle_id`)
- **Lean target exists**: yes (line 612)
- **Signature matches**: yes — `bundleTransition d r I I hI hI = eqToIso (congrArg ... (chartIncl = chartTransition ≫ chartIncl))`.
- **Proof follows sketch**: yes — blueprint says "matrix part is identity, free-pullback comparisons cancel into eqToIso transport". Lean proof: `hB` collapses `matrixToFreeIso` to `Iso.refl` via `universalMinorInv_self` + `matrixEnd_one`; then `pullbackFreeIso_trans_symm_eqToIso` (new helper) closes the comparison cancellation. Mathematical content matches.
- **notes**: Iter-060 key change: maxHeartbeats override removed; proof rebuilt using `pullbackFreeIso_trans_symm_eqToIso` (generic `subst` on variables) to avoid whnf of concrete immersions. This is mathematically equivalent to the former proof and leaner. The `erw [hB]` handles the `chartOverlap`/`Spec` defeq on the inferred base scheme. Clean.

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_matrix}` (`lem:gr_bundleCocycle_matrix`)
- **Lean target exists**: **no** — no such declaration in the file.
- **notes**: Blueprint block has no `\leanok`; planned work. Proof sketch in blueprint is detailed: derives `X^J_K = (X^I_J)^{-1} X^I_K` from column submatrix commuting with left multiplication, then inverts. Pre-req for `bundleTransition_cocycle_transport`. **Coverage debt.**

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_transport}` (`lem:gr_bundleCocycle_transport`)
- **Lean target exists**: **no** — no such declaration in the file.
- **notes**: Blueprint block has no `\leanok`; planned work. The proof sketch names the ingredients (`pullbackBaseChangeTransport`, `pullbackComp`, `pullbackCongr`, `glueData_bridge_*`, `matrixToFreeIso_mul`, `pullbackFreeIso`) and describes the effect (free-pullback comparisons cancel, each transport becomes a `matrixEnd` of a base-changed Cramer inverse). **See adequacy assessment below.** **Coverage debt.**

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle}` (`lem:gr_bundleCocycle_mul`)
- **Lean target exists**: yes (line 664) — sorry body.
- **Signature matches**: yes — exact `_hC2` hypothesis form for `Scheme.Modules.glue` instantiated at `theGlueData d r` and `bundleTransitionData`.
- **Proof follows sketch**: N/A (sorry)
- **notes**: Blueprint `\leanok` on statement block is correct per `sync_leanok` semantics (sorry present). Proof sketch correctly decomposes into `bundleTransition_cocycle_matrix` + `matrixToFreeIso_mul` + `bundleTransition_cocycle_transport`, all of which are open.

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}` (`def:gr_universal_quotient_sheaf`)
- **Lean target exists**: yes (line 703) — sorry body.
- **Signature matches**: yes — `(d r : ℕ) → (scheme d r).Modules`.
- **notes**: Blueprint `\leanok` on statement block correct (sorry present). The NOTE in the Lean file accurately describes the pending assembly via `Scheme.Modules.glue`; rides on C2.

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (`def:tautological_quotient`)
- **Lean target exists**: yes (line 713) — sorry body.
- **Signature matches**: yes — `free (Fin r) ⟶ universalQuotient d r`.
- **notes**: Blueprint `\leanok` correct (sorry present). Rides on `universalQuotient`.

### `\lean{...RankQuotient, RankQuotient.Rel, rel_refl, rel_symm, rel_trans, rqSetoid, rqPullback, rqPullback_rel}` (`def:gr_rankQuotient`)
- **Lean target exists**: yes (lines 735–802) — all present, all sorry-free.
- **Signature matches**: yes for all; `RankQuotient` is a `structure` with fields `F`, `q`, `epi`, `locFree` matching the prose.
- **Proof follows sketch**: yes for the three relation properties.
- **notes**: Blueprint block lacks `\leanok` but all declarations exist and have no sorry. `sync_leanok` will add `\leanok` on the next pass. Not a mistake.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_id}` (`lem:gr_pullbackObjUnitToUnit_id`)
- **Lean target exists**: yes (line 813)
- **Signature matches**: yes
- **Proof follows sketch**: yes — transposes both sides under pullback-pushforward adjunction; conjugate = `(pushforwardId).inv`; equals identity on sections. Matches blueprint description.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_id}` (`lem:gr_pullbackFreeIso_id`)
- **Lean target exists**: yes (line 840)
- **Signature matches**: yes
- **Proof follows sketch**: yes — coproduct extensionality reduces to `pullbackObjUnitToUnit_id`.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.homEquiv_conjugateEquiv_app}` (`lem:gr_homEquiv_conjugateEquiv_app`)
- **Lean target exists**: yes (line 867)
- **Signature matches**: yes
- **Proof follows sketch**: yes — term-mode pasting of unit/counit triangles. Matches blueprint.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (`lem:gr_pullbackObjUnitToUnit_comp`)
- **Lean target exists**: yes (line 908)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `homEquiv_conjugateEquiv_app` + `conjugateEquiv_pullbackComp_inv` to transpose both sides; reduces to `pushforwardComp_inv_app_app = 𝟙` (rfl).
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_comp}` (`lem:gr_pullbackFreeIso_comp`)
- **Lean target exists**: yes (line 985)
- **Signature matches**: yes
- **Proof follows sketch**: yes — coproduct extensionality reduces to `pullbackObjUnitToUnit_comp`.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Grassmannian.functor}` (`def:grassmannian_functor`)
- **Lean target exists**: yes (line 1128)
- **Signature matches**: yes — `(d r : ℕ) : Scheme.{0}ᵒᵖ ⥤ Type 1`. The universe `Type 1` (not `Type 0`) is correct per the file comment: `F : T.Modules` is a large object.
- **Proof follows sketch**: yes — `map_id` uses `pullbackFreeIso_id`; `map_comp` uses `pullbackFreeIso_comp`. Both complete, no sorry.
- **notes**: The `Type 1` universe correction is documented in the Lean file. Blueprint does not mention the universe but `Type 1` is correct. Minor documentation gap in blueprint (not a mismatch since no formal signature is pinned in prose).

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (`thm:grassmannian_universal_property`)
- **Lean target exists**: yes (line 1207) — sorry body.
- **Signature matches**: yes — `(d r : ℕ) (hd : 1 ≤ d) (hdr : d ≤ r) → (functor d r).RepresentableBy (scheme d r)`.
- **notes**: Blueprint `\leanok` on statement block correct (sorry present). Rides on `tautologicalQuotient`. Blueprint proof sketch (local inverse construction, gluing via cocycle) is detailed enough for a future prover.

---

## Red Flags

### Placeholder / suspect bodies
- `bundleTransition_cocycle` (line 684): `:= sorry`. Expected open item (C2 cocycle); the three stepping-stone lemmas do not yet exist.
- `universalQuotient` (line 704): `:= sorry`. Rides on `bundleTransition_cocycle`.
- `tautologicalQuotient` (line 715): `:= sorry`. Rides on `universalQuotient`.
- `represents` (line 1209): `:= sorry`. Rides on `tautologicalQuotient`.

**Verdict**: All four sorry bodies are correctly expected per the project's open-work tracking and per `sync_leanok` semantics (`\leanok` on statement block = "sorry present"). No must-fix violation.

### Excuse-comments
None found. The inline NOTE comments in `glue`, `universalQuotient`, `tautologicalQuotient`, `represents`, and `bundleTransition_self` are accurate status notes, not excuse-comments for wrong code.

### Axioms / Classical.choice on non-trivial claims
None detected. The file is axiom-clean (consistent with MEMORY entry "iter-060: `bundleTransition_self` FULLY CLOSED axiom-clean").

---

## Unreferenced Declarations (informational)

The following declarations in the Lean file have no `\lean{...}` reference in the blueprint. Those that are mathematically substantive (not obvious one-liners) are flagged as coverage debt in the next section.

| Declaration | Line | Type | Blueprint-worthy? |
|---|---|---|---|
| `scalarEnd_val_app` | 80 | private-ish lemma | no (computational helper, low interest) |
| `unitHomEquiv_scalarEnd` | 86 | lemma | no (trivial by `Equiv.apply_symm_apply`) |
| `scalarEnd_val_app_one` | 91 | lemma | no (one-line by `one_smul`) |
| `scalarEnd_sum` | 124 | lemma | minor interest; used in `matrixEnd_comp` |
| `hasFiniteBiproducts_modules` | 141 | instance | no (one-liner from `HasFiniteProducts`) |
| `biproduct_matrix_comp` | 156 | **private** lemma | no |
| `bundleMatrix_cancel` | 554 | **private** lemma | no |
| `universalMinorInv_self` | 546 | lemma | **yes** — used in `bundleTransition_self` proof, referenced in blueprint proof text as part of `lem:gr_universalMinorInv_identities`; adding a `\lean{}` pin would improve traceability |
| `bundleTransitionData` | 645 | noncomputable def | **yes** — packaging `bundleTransition` for `theGlueData`; used in `bundleTransition_cocycle` signature; should have a blueprint entry |
| `pullbackFreeIso_eqToHom` | 491 | lemma | minor — helper for `pullbackFreeIso_trans_symm_eqToIso` |
| `pullbackFreeIso_trans_symm_eqToIso` | 503 | lemma | **yes** — new in iter-060, load-bearing for the leaner `bundleTransition_self`; should have a `\lean{}` pin |
| `pullbackObjUnitToUnit_id` | 813 | lemma | **has `\lean{}` pin** ✓ |
| `pullbackFreeIso_id` | 840 | lemma | **has `\lean{}` pin** ✓ |
| `homEquiv_conjugateEquiv_app` | 867 | lemma | **has `\lean{}` pin** ✓ |
| `pullbackObjUnitToUnit_comp` | 908 | lemma | **has `\lean{}` pin** ✓ |
| `pullbackFreeIso_comp` | 985 | lemma | **has `\lean{}` pin** ✓ |

---

## Blueprint Adequacy for This File

### Coverage
- **36/40** blueprint `\lean{...}` targets resolve to existing (possibly sorry-bodied) Lean declarations.
- **3** blueprint `\lean{...}` targets name planned-but-not-yet-created declarations with no `\leanok`: `matrixToFreeIso_mul`, `bundleTransition_cocycle_matrix`, `bundleTransition_cocycle_transport`. These are intentional open work items, not errors.
- **3** blueprint `\lean{...}` targets are `% NOTE: forward declaration (planned work)`: `glueRestrictionIso`, `glue_unique`, `glueHom`. Correctly deferred.
- **3** Lean declarations are substantive but lack blueprint entries: `pullbackFreeIso_trans_symm_eqToIso`, `bundleTransitionData`, `universalMinorInv_self`.

### Proof-sketch depth
**Partially under-specified** for the C2 path. Specifically:

- `lem:gr_bundleCocycle_matrix`: **adequate** — the proof sketches the Cramer-inverse cocycle derivation in enough detail.
- `lem:gr_matrixToFreeIso_mul`: **adequate** — straightforward from `matrixToFreeIso_hom` + `matrixEnd_comp`.
- `lem:gr_bundleCocycle_transport`: **under-specified** for the Lean term-mode proof. The blueprint accurately names the ingredients (`pullbackBaseChangeTransport`, `pullbackComp`, `pullbackCongr`, `glueData_bridge_*`, `matrixToFreeIso_mul`, `pullbackFreeIso`) and describes the endpoint-alignment effect. However, it does not spell out the reassociation sequence of `pullbackComp`/`pullbackCongr` steps that the Lean term will require (~50-100 LOC of bookkeeping). Given that rw-tactics fail under the Modules instance diamond (documented in prior iters), the prover must work entirely in term mode. The blueprint's high-level description is insufficient to guide this without prior knowledge of the pattern (cf. `functor` proof for analogous term-mode calc chains).

### Hint precision
**Precise** for all resolved targets. The three unresolved targets (`matrixToFreeIso_mul`, `bundleTransition_cocycle_matrix`, `bundleTransition_cocycle_transport`) pin plausible names; no wrong-predicate issues detected.

### Generality
**Matches need** for all existing declarations. The `Scheme.{0}` universe restriction on `matrixEnd`/`matrixToFreeIso`/`bundleTransitionData` is appropriate for the Grassmannian concreteness.

### Recommended chapter-side actions
1. **Add a blueprint entry** for `pullbackFreeIso_trans_symm_eqToIso` (new in iter-060, load-bearing for `bundleTransition_self`). Suggested label `lem:gr_pullbackFreeIso_trans_symm_eqToIso` under the "Pullback of free sheaves" subsection, referencing `lem:gr_pullbackFreeIso`.
2. **Add a blueprint entry** for `bundleTransitionData` (packaging helper for `bundleTransition_cocycle`). Suggested label `def:gr_bundleTransitionData` in the GL_d bundle section.
3. **Add a `\lean{}` pin** to `lem:gr_bundleCocycle_id`'s `\uses{}` or prose for `universalMinorInv_self`, or verify it is covered by `lem:gr_universalMinorInv_identities` in `GrassmannianCells`.
4. **Expand the proof sketch** for `lem:gr_bundleCocycle_transport` with an explicit step-by-step description of the `pullbackComp` reassociations on the source/middle/target free sheaves, similar in style to the term-mode structure of `pullbackFreeIso_comp`. Without this, iter-061 will need to discover the reassociation sequence from first principles.
5. The `chartQuotientMap_ιFree` `\lean{}` pin names a `private` declaration — technically the pin is informational; the blueprint may note this or promote the declaration to non-private if external citation is desired.

---

## Severity Summary

### must-fix-this-iter
None. All sorry bodies are correctly-expected open items; no wrong signatures or excuse-comments; no unauthorized axioms.

### major
1. **Coverage gap — `matrixToFreeIso_mul`**: Blueprint `\lean{}` pin exists but no Lean declaration. Required before `bundleTransition_cocycle_transport` can be proved. Iter-061 prover must create this first (proof is a one-liner: `matrixEnd_comp` + `matrixToFreeIso_hom`).
2. **Coverage gap — `bundleTransition_cocycle_matrix`**: Blueprint `\lean{}` pin exists but no Lean declaration. Required stepping stone for C2.
3. **Coverage gap — `bundleTransition_cocycle_transport`**: Blueprint `\lean{}` pin exists but no Lean declaration. The most substantial missing piece; the proof sketch is under-specified for the Lean term-mode bookkeeping (~50-100 LOC of `pullbackComp`/`pullbackCongr` reassociations).
4. **Blueprint adequacy — `lem:gr_bundleCocycle_transport` proof sketch under-specified** for Lean term-mode. A blueprint-writing pass expanding this sketch is recommended before dispatching the iter-061 prover.

### minor
1. `pullbackFreeIso_trans_symm_eqToIso` (new in iter-060): load-bearing helper for `bundleTransition_self`, no blueprint entry.
2. `bundleTransitionData`: packaging wrapper used in `bundleTransition_cocycle` signature, no blueprint entry.
3. `chartQuotientMap_ιFree` is `private`; blueprint `\lean{}` pin names the fully qualified name, which won't resolve externally.
4. `def:gr_rankQuotient` lacks `\leanok` in blueprint although all 8 referenced declarations exist sorry-free; `sync_leanok` will resolve this automatically.
5. `functor`'s `Type 1` universe correction is not documented in the blueprint prose (blueprint is not wrong, just silent on this point).

**Overall verdict**: The Lean file is faithful to the blueprint for all 36 resolved declarations; the three unresolved C2 stepping-stone lemmas (`matrixToFreeIso_mul`, `bundleTransition_cocycle_matrix`, `bundleTransition_cocycle_transport`) are correctly tracked as planned open work, and the iter-060 leaner `bundleTransition_self` proof via `pullbackFreeIso_trans_symm_eqToIso` is sound — 36 declarations checked, 0 red flags, 3 major coverage gaps blocking C2.
