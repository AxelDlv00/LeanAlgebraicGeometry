# Lean ↔ Blueprint Check Report

## Slug
grquot-iter055

## Iteration
055

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackComp}` (def:modules_pullbackComp)
- **Lean target exists**: yes (Mathlib; not defined in this file, referenced only)
- **Signature matches**: yes — blueprint correctly tags this `\mathlibok`
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: Correctly marked `\mathlibok`. No Lean body in this file.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackBaseChangeTransport}` (lem:modules_pullback_basechange_transport)
- **Lean target exists**: yes (line 196)
- **Signature matches**: yes — `(p : W ⟶ V)`, `(a : V ⟶ Yi)`, `(b : V ⟶ Yj)`, `g : pullback a Mi ≅ pullback b Mj` → `pullback (p ≫ a) Mi ≅ pullback (p ≫ b) Mj`. Matches blueprint exactly.
- **Proof follows sketch**: yes — pulls `g` back along `p` and reassociates both sides via `pullbackComp`.
- **notes**: Axiom-clean; `\leanok` on statement block consistent with real proof.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glueData_bridge_src, glueData_bridge_mid, glueData_bridge_tgt}` (lem:gr_glueData_bridges)
- **Lean target exists**: yes (lines 209, 218, 230)
- **Signature matches**: yes — `src` = `pullback.condition`; `mid` uses `t_fac`; `tgt` chains `t_fac`, reversed pullback condition, `t_inv`, and `cocycle`. All match blueprint.
- **Proof follows sketch**: yes — `src` is `pullback.condition` directly; `mid` rewrites with `t_fac`; `tgt` chains the described identities.
- **notes**: All three axiom-clean. Blueprint block lacks `\leanok` — sync issue, not a code defect.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glue}` (def:scheme_modules_glue)
- **Lean target exists**: yes (line 245)
- **Signature matches**: yes — takes `D : Scheme.GlueData`, `M : ∀ i, (D.U i).Modules`, `g : ∀ i j, pullback(f i j) Mi ≅ pullback(t i j ≫ f j i) Mj`, `_hC1`, `_hC2`. Matches blueprint C1/C2 description exactly, including use of `pullbackBaseChangeTransport` and all three `glueData_bridge_*` lemmas in `_hC2`.
- **Proof follows sketch**: N/A — body is `:= sorry` (scaffolded). Blueprint `\leanok` is on the statement block only, consistent with sorry.
- **notes**: See **Red flags § stale comment** below.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.opensMap_final}` (lem:gr_opensMap_final)
- **Lean target exists**: yes (line 290)
- **Signature matches**: yes — `(φ : T' ⟶ T) → (Opens.map φ.base).Final`. Matches blueprint.
- **Proof follows sketch**: yes — shows the structured-arrow category over any `V` has terminal object `⊤`, hence is connected (zigzag).
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso}` (lem:gr_pullbackFreeIso)
- **Lean target exists**: yes (line 309)
- **Signature matches**: yes — `(φ : T' ⟶ T) (I : Type u)` gives `(Modules.pullback φ).obj (free I) ≅ free I`. Matches blueprint.
- **Proof follows sketch**: yes — instances `opensMap_final` then applies `SheafOfModules.pullbackObjFreeIso`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullback_isLocallyFreeOfRank}` (lem:gr_pullback_isLocallyFreeOfRank)
- **Lean target exists**: yes (line 322)
- **Signature matches**: yes — `(φ : T' ⟶ T) → IsLocallyFreeOfRank M d → IsLocallyFreeOfRank (pullback φ).obj M d`. Matches blueprint.
- **Proof follows sketch**: yes — preimage cover + `pullbackComp` + `morphismRestrict_ι` + `pullbackFreeIso`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}` (def:gr_globalUnitSection)
- **Lean target exists**: yes (line 37)
- **Signature matches**: yes — `(a : Γ(X, ⊤)) → (SheafOfModules.unit X.ringCatSheaf).sections`. Matches blueprint.
- **Proof follows sketch**: yes — restriction family via `X.ringCatSheaf.obj.map`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}` (def:gr_scalarEnd)
- **Lean target exists**: yes (line 50)
- **Signature matches**: yes — `(a : Γ(X, ⊤)) → unit ⟶ unit`. Matches blueprint description (multiplication by `a`).
- **Proof follows sketch**: N/A (definition; uses `unitHomEquiv.symm`).
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_one}` (lem:gr_scalarEnd_one)
- **Lean target exists**: yes (line 56)
- **Signature matches**: yes — `scalarEnd 1 = 𝟙 (unit X.ringCatSheaf)`. Matches.
- **Proof follows sketch**: yes — uses `map_one`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_zero}` (lem:gr_scalarEnd_zero)
- **Lean target exists**: yes (line 67)
- **Signature matches**: yes — `scalarEnd 0 = 0`. Matches.
- **Proof follows sketch**: yes — uses `map_zero`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` (def:gr_chart_quotient)
- **Lean target exists**: yes (line 87)
- **Signature matches**: yes — `free (Fin r) ⟶ free (Fin d)` on `affineChart d r I`. Matches blueprint (matrix `X^I` applied to trivial bundles of ranks `r` and `d`).
- **Proof follows sketch**: yes — entry-by-entry biproduct matrix assembly via `scalarEnd`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` (lem:gr_chartQuotientMap_iFree)
- **Lean target exists**: yes (line 103), declared `private`
- **Signature matches**: yes — `ιFree (I.orderIsoOfFin hI k) ≫ chartQuotientMap = ιFree k`. Matches blueprint.
- **Proof follows sketch**: yes — biproduct extensionality + `universalMatrix_submatrix_self` + `scalarEnd_one`/`scalarEnd_zero`.
- **notes**: Declared `private`, but blueprint references it with `\lean{}`. Minor: the `private` modifier may prevent `sorry_analyzer`/`sync_leanok` from resolving the fully-qualified name.

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_epi}` (lem:gr_chartQuotientMap_epi)
- **Lean target exists**: yes (line 145)
- **Signature matches**: yes — `Epi (chartQuotientMap d r I hI)`. Matches blueprint.
- **Proof follows sketch**: yes — exhibits section `freeMap (I.orderIsoOfFin ·) ≫ chartQuotientMap = 𝟙` via `chartQuotientMap_ιFree`, then uses `IsSplitEpi`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}` (def:gr_universal_quotient_sheaf)
- **Lean target exists**: yes (line 346)
- **Signature matches**: yes — `(scheme d r).Modules`. Matches blueprint.
- **Proof follows sketch**: N/A — body is `:= sorry` (scaffold pending `glue`). Blueprint `\leanok` on statement block only.
- **notes**: See **Red flags § scaffold sorries** below.

---

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (def:tautological_quotient)
- **Lean target exists**: yes (line 354)
- **Signature matches**: yes — `free (Fin r) ⟶ universalQuotient d r`. Matches blueprint.
- **Proof follows sketch**: N/A — body is `:= sorry` (scaffold pending `glue`). Blueprint `\leanok` on statement block only.
- **notes**: See **Red flags § scaffold sorries** below.

---

### `\lean{AlgebraicGeometry.Grassmannian.RankQuotient, RankQuotient.Rel, rel_refl, rel_symm, rel_trans, rqSetoid, rqPullback, rqPullback_rel}` (def:gr_rankQuotient)
- **Lean target exists**: yes — all eight names exist (lines 376–443)
- **Signature matches**: yes — `RankQuotient` is a structure `{F, q, epi, locFree}`; `Rel` requires an isomorphism of targets commuting with quotient maps; `rqPullback` re-presents source via `pullbackFreeIso.inv`. All match blueprint prose.
- **Proof follows sketch**: yes — `rel_refl`/`rel_symm`/`rel_trans` are real proofs; `rqPullback_rel` is real. `rqPullback.epi` uses explicit `@CategoryTheory.epi_comp` to avoid the `T.Modules` def-diamond.
- **notes**: Blueprint block lacks `\leanok` (sync issue — all declarations are axiom-clean). Universe comment in Lean ("corrected to `Type 1`") correctly documents the forced change.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_id}` (lem:gr_pullbackObjUnitToUnit_id)
- **Lean target exists**: yes (line 454)
- **Signature matches**: yes — `pullbackObjUnitToUnit (𝟙 T).toRingCatSheafHom = (pullbackId T).hom.app (unit T.ringCatSheaf)`. Matches blueprint.
- **Proof follows sketch**: partial — blueprint says "trace identity through hom-equivalence and conjugate-transpose"; Lean uses `unit_conjugateEquiv`, `conjugateEquiv_pullbackId_hom`, and a trailing `rfl`. The extra `rfl` step is a defeq collapse not mentioned in the blueprint sketch, but the mathematical content matches.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_id}` (lem:gr_pullbackFreeIso_id)
- **Lean target exists**: yes (line 481)
- **Signature matches**: yes — `(pullbackFreeIso (𝟙 T) I).hom = (pullbackId T).hom.app (free I)`. Matches blueprint.
- **Proof follows sketch**: yes — coproduct extensionality reduces to `pullbackObjUnitToUnit_id` as described.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (lem:gr_pullbackObjUnitToUnit_comp)
- **Lean target exists**: yes (line 549)
- **Signature matches**: yes — `pullbackComp(b,a).hom.app unit ≫ pullbackObjUnitToUnit(b≫a) = pullback(b).map(pullbackObjUnitToUnit a) ≫ pullbackObjUnitToUnit b`. Matches blueprint factorisation.
- **Proof follows sketch**: partial — blueprint says "mate construction compatible with composition of adjunctions, reassociated by `pullbackComp`". Lean proof uses a helper `homEquiv_conjugateEquiv_app` (no blueprint block) to handle the mate-compatibility step explicitly, plus `conjugateEquiv_pullbackComp_inv` + `pushforwardComp_inv_app_app = 𝟙`. The mate-compatibility step is not surfaced in the blueprint sketch.
- **notes**: Axiom-clean. Blueprint proof sketch under-specifies the `homEquiv`-conjugate decomposition step.

---

### `\lean{AlgebraicGeometry.Grassmannian.functor}` (def:grassmannian_functor)
- **Lean target exists**: yes (line 769)
- **Signature matches**: yes — `Scheme.{0}ᵒᵖ ⥤ Type 1`. Blueprint explicitly notes the corrected `Type 1` universe.
- **Proof follows sketch**: yes — `map_id` and `map_comp` reduce via pseudofunctor coherences (`pullbackFreeIso_id`/`_comp`) exactly as described. The proofs are complete (no sorry).
- **notes**: Axiom-clean. Key lemma `pullbackFreeIso_comp` used in `map_comp` has no `\lean{}` block in the blueprint (see coverage debt below).

---

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (thm:grassmannian_universal_property)
- **Lean target exists**: yes (line 845)
- **Signature matches**: yes — `(functor d r).RepresentableBy (scheme d r)` with hypotheses `1 ≤ d` and `d ≤ r`. Matches blueprint.
- **Proof follows sketch**: N/A — body is `:= sorry` (scaffold). Blueprint `\leanok` on statement block only. Blueprint proof sketch (the local-to-global inverse construction) is detailed and correct, ready to guide the proof once `glue`/`universalQuotient`/`tautologicalQuotient` land.
- **notes**: See **Red flags § scaffold sorries** below.

---

## Red flags

### Scaffold sorries (informational — consistent with blueprint's statement-block-only `\leanok`)

These declarations have `:= sorry` bodies and are marked as scaffolds:

| Declaration | Line | Blueprint marker | Dependency |
|---|---|---|---|
| `Scheme.Modules.glue` | 245 | `\leanok` stmt block only | Core descent primitive |
| `Grassmannian.universalQuotient` | 346 | `\leanok` stmt block only | rides on `glue` |
| `Grassmannian.tautologicalQuotient` | 354 | `\leanok` stmt block only | rides on `glue` |
| `Grassmannian.represents` | 845 | `\leanok` stmt block only | rides on all three above |

**Classification: NOT must-fix.** The blueprint correctly has `\leanok` only on the *statement* block for all four (not on any proof block), consistent with the spec: "statement block: declaration is formalized (at least a `sorry` present)." These are sanctioned scaffolds gated on `glue`.

### Stale NOTE comment in `glue` (minor)

`GrassmannianQuot.lean` lines 170–173:
```
NOTE (scaffold): the body and the module-cocycle hypotheses on `g` are still to be
filled; the transition data `g` (per-overlap pullback isos) is recorded in the
signature, the multiplicative cocycle conditions remain to be added before the
construction is closed.
```
**The cocycle conditions (C1 and C2) ARE present in the signature.** The comment was written before they were added and is now partially stale. It does not excuse incorrect code (the hypotheses are correct), but the phrase "cocycle conditions remain to be added" is factually wrong. This is a stale workflow note, not an excuse-comment for a wrong definition.

- **Classification: minor**

---

## Unreferenced declarations (informational)

These declarations appear in the Lean file with no `\lean{...}` block in the blueprint:

### `Scheme.Modules.homEquiv_conjugateEquiv_app` (line 508) — **major coverage debt**

A non-trivial general lemma about the interaction between `Adjunction.homEquiv` and `conjugateEquiv`: "transposing `α.app c ≫ f` under `adj₂` equals transposing `f` under `adj₁` composed with `conjugateEquiv adj₁ adj₂ α`." This is used as a key step in the proof of `pullbackObjUnitToUnit_comp`.

The blueprint proof of `lem:gr_pullbackObjUnitToUnit_comp` says "the mate construction is compatible with composition of adjunctions" but does not identify or name this helper. The prover had to extract it as a standalone lemma. The blueprint is under-specified at this step.

### `Scheme.Modules.pullbackFreeIso_comp` (line 626) — **major coverage debt**

The composite analogue of `lem:gr_pullbackFreeIso_id`: `pullbackComp(b,a).hom.app (free I) ≫ pullbackFreeIso(b≫a).hom = pullback(b).map(pullbackFreeIso(a).hom) ≫ pullbackFreeIso(b).hom`. This is used directly in `functor.map_comp`.

The blueprint prose at lines 773–779 says: "Together `lem:gr_pullbackObjUnitToUnit_id` and `lem:gr_pullbackObjUnitToUnit_comp` upgrade to the corresponding free-sheaf coherences — the free-pullback isomorphism at the identity equals the component of the pullback-identity isomorphism, **and likewise for the composite**." The phrase "likewise for the composite" hints at `pullbackFreeIso_comp` but gives it no `\lean{}` block or lemma label. The `functor.map_comp` proof depends on this lemma directly.

---

## Blueprint adequacy for this file

- **Coverage**: 
  - Blueprint `\lean{}` blocks: 22 distinct names (counting the grouped bridge block as 3, and the `def:gr_rankQuotient` cluster as 8).
  - Lean declarations: 35 total (28 with real proofs, 4 sorry-bodies, 3 inlined in `functor`).
  - Of the 35, 33 are `\lean{}`-referenced. Unreferenced: `homEquiv_conjugateEquiv_app` (substantive helper, should have a block), `pullbackFreeIso_comp` (substantive, should have a block).

- **Proof-sketch depth**: **under-specified** for two proofs:
  1. `lem:gr_pullbackObjUnitToUnit_comp` — blueprint does not disclose the `homEquiv`/`conjugateEquiv` decomposition step; prover needed to extract and prove `homEquiv_conjugateEquiv_app` separately.
  2. `def:grassmannian_functor` (`functor.map_comp`) — blueprint says "the composite free-sheaf coherence" but gives no `\lean{}` block for `pullbackFreeIso_comp`, leaving the prover to derive and name it ad hoc.

- **Hint precision**: **precise** for all referenced declarations. All `\lean{}` hints name the correct Lean identifiers with matching signatures.

- **Generality**: **matches need** — the blueprint's level of generality (arbitrary scheme morphisms, arbitrary index types, arbitrary glue data) matches what the Lean requires.

- **Recommended chapter-side actions**:
  1. Add a lemma block for `Scheme.Modules.pullbackFreeIso_comp` with `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_comp}` and a proof sketch noting it reduces by coproduct extensionality to `pullbackObjUnitToUnit_comp`.
  2. Add a lemma block for `Scheme.Modules.homEquiv_conjugateEquiv_app` with `\lean{AlgebraicGeometry.Scheme.Modules.homEquiv_conjugateEquiv_app}` and a one-sentence proof sketch ("mate-compatibility: transpose of `α ≫ f` under `adj₂` equals transpose of `f` under `adj₁` composed with `conjugateEquiv adj₁ adj₂ α`; from `unit_conjugateEquiv` + naturality").
  3. Update the NOTE comment in `glue` (line 172) to reflect that C1 and C2 hypotheses ARE present; only the body remains sorry.
  4. Consider removing `private` from `chartQuotientMap_ιFree` or adding a note that `\lean{}` references to `private` declarations may not resolve in `sync_leanok`.
  5. Run `sync_leanok` to add `\leanok` to `lem:gr_glueData_bridges` and `def:gr_rankQuotient` (all real proofs, no sorry).

---

## Severity summary

| Finding | Severity |
|---|---|
| `pullbackFreeIso_comp` unreferenced in blueprint (substantive, used in `functor.map_comp`) | **major** |
| `homEquiv_conjugateEquiv_app` unreferenced in blueprint (helper for `pullbackObjUnitToUnit_comp`) | **major** |
| Blueprint proof sketch for `pullbackObjUnitToUnit_comp` under-specifies mate-compatibility step | **major** |
| Stale NOTE comment in `glue` ("cocycle conditions remain to be added" — they ARE present) | minor |
| `chartQuotientMap_ιFree` is `private` but has a `\lean{}` blueprint reference | minor |
| `lem:gr_glueData_bridges` and `def:gr_rankQuotient` lack `\leanok` (sync issue) | minor |

**Overall verdict**: The Lean file is in good shape for iter-055 — `functor` is axiom-clean (its four `sorry`-bodies are sanctioned scaffolds gated on `glue`), all signatures match the blueprint, no excuse-comments on real declarations. The primary debt is blueprint coverage: two substantive lemmas introduced this iteration (`pullbackFreeIso_comp`, `homEquiv_conjugateEquiv_app`) have no `\lean{}` blocks, and the proof sketch for `pullbackObjUnitToUnit_comp` under-specifies the mate-compatibility decomposition step needed to formalize it. — 22 blueprint blocks checked (35 Lean declarations), 2 major coverage gaps, 0 must-fix findings.
