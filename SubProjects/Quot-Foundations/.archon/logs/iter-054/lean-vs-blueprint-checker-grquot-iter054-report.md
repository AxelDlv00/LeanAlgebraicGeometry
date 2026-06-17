# Lean ↔ Blueprint Check Report

## Slug
grquot-iter054

## Iteration
054

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackComp}` (`def:modules_pullbackComp`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes (`\mathlibok`)
- **Proof follows sketch**: N/A (Mathlib-provided)
- **notes**: Correctly marked `\mathlibok`. No Archon obligation.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackBaseChangeTransport}` (`lem:modules_pullback_basechange_transport`)
- **Lean target exists**: yes (line 196)
- **Signature matches**: yes — noncomputable def giving the transport iso via `pullbackComp.symm ≪≫ pullback.mapIso g ≪≫ pullbackComp`; matches prose exactly
- **Proof follows sketch**: yes — the definition body directly assembles the three pseudofunctor comparison isos as described
- **notes**: Statement-block `\leanok` is honest (complete definition, no sorry). Proof-block `\leanok` absent despite definition being closed — `sync_leanok` lag (minor).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glueData_bridge_src}` / `glueData_bridge_mid` / `glueData_bridge_tgt` (`lem:gr_glueData_bridges`)
- **Lean target exists**: yes (lines 209, 218, 230)
- **Signature matches**: yes — all three match the blueprint's itemised equalities; `bridge_src = pullback.condition`, `bridge_mid` uses `t_fac`, `bridge_tgt` uses `t_fac`/`t_inv`/`cocycle`
- **Proof follows sketch**: yes — each proof directly rewrites with the named glue-datum axioms as described in the blueprint
- **notes**: Blueprint statement block and proof block both lack `\leanok` despite all three proofs being complete — `sync_leanok` lag (minor, three instances). Lean grouping (three separate `theorem` decls) matches the single multi-name `\lean{...}` reference.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glue}` (`def:scheme_modules_glue`)
- **Lean target exists**: yes (line 245)
- **Signature matches**: yes — takes `D : Scheme.GlueData`, per-chart modules `M`, transition isos `g`, and hypotheses `_hC1` (self-identity) and `_hC2` (triple-overlap multiplicativity); matches C1/C2 in the blueprint exactly
- **Proof follows sketch**: N/A (body is `:= sorry`; proof body awaited)
- **notes**: Statement-block `\leanok` is honest (declaration present with sorry). No proof-block `\leanok` — correct. The inline `NOTE (scaffold): body … to be filled` comment (line 170) acknowledges the sorry; see Red flags.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.opensMap_final}` (`lem:gr_opensMap_final`)
- **Lean target exists**: yes (line 291)
- **Signature matches**: yes — `(TopologicalSpace.Opens.map φ.base).Final` for arbitrary `φ : T' ⟶ T`
- **Proof follows sketch**: yes — proves finality via the terminal object `⊤` in the structured-arrow category and `zigzag_isConnected`, matching the blueprint sketch exactly
- **notes**: Statement-block `\leanok` honest. Proof-block `\leanok` absent — `sync_leanok` lag (minor).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso}` (`lem:gr_pullbackFreeIso`)
- **Lean target exists**: yes (line 309)
- **Signature matches**: yes — `(Scheme.Modules.pullback φ).obj (free I) ≅ free I` for any `φ`
- **Proof follows sketch**: yes — invokes `opensMap_final` then `SheafOfModules.pullbackObjFreeIso`
- **notes**: Statement-block `\leanok` honest. Proof-block `\leanok` absent — `sync_leanok` lag (minor).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullback_isLocallyFreeOfRank}` (`lem:gr_pullback_isLocallyFreeOfRank`)
- **Lean target exists**: yes (line 322)
- **Signature matches**: yes — `IsLocallyFreeOfRank ((pullback φ).obj M) d` given `h : IsLocallyFreeOfRank M d`
- **Proof follows sketch**: yes — pulls back the trivialising cover, uses `pullbackComp` + `morphismRestrict_ι` + `pullbackFreeIso`
- **notes**: Statement-block `\leanok` honest. Proof-block `\leanok` absent — `sync_leanok` lag (minor).

---

### `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}` (`def:gr_globalUnitSection`)
- **Lean target exists**: yes (line 37)
- **Signature matches**: yes — `PresheafOfModules.sectionsMk` packaging the restriction family, matches the "section of the unit sheaf" description
- **Proof follows sketch**: yes
- **notes**: Statement-block `\leanok` honest.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}` (`def:gr_scalarEnd`)
- **Lean target exists**: yes (line 50)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (definition)
- **notes**: Statement-block `\leanok` honest.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_one}` (`lem:gr_scalarEnd_one`)
- **Lean target exists**: yes (line 56)
- **Signature matches**: yes — `scalarEnd 1 = 𝟙 (unit …)`
- **Proof follows sketch**: yes
- **notes**: Proof-block `\leanok` absent — `sync_leanok` lag (minor).

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_zero}` (`lem:gr_scalarEnd_zero`)
- **Lean target exists**: yes (line 67)
- **Signature matches**: yes — `scalarEnd 0 = 0`
- **Proof follows sketch**: yes
- **notes**: Proof-block `\leanok` absent — `sync_leanok` lag (minor).

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` (`def:gr_chart_quotient`)
- **Lean target exists**: yes (line 87)
- **Signature matches**: yes — `free (Fin r) ⟶ free (Fin d)` on the affine chart, built via biproduct matrix
- **Proof follows sketch**: yes
- **notes**: Statement-block `\leanok` honest.

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` (`lem:gr_chartQuotientMap_iFree`)
- **Lean target exists**: yes (line 103, `private`)
- **Signature matches**: yes — `ιFree (orderIsoOfFin k) ≫ chartQuotientMap = ιFree k`
- **Proof follows sketch**: yes — reads off the identity submatrix entry-by-entry using `universalMatrix_submatrix_self`, `scalarEnd_one`, `scalarEnd_zero`
- **notes**: Declaration is `private`; the `\lean{...}` reference in the blueprint is still valid within the file scope. Proof-block `\leanok` absent — `sync_leanok` lag (minor).

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_epi}` (`lem:gr_chartQuotientMap_epi`)
- **Lean target exists**: yes (line 145)
- **Signature matches**: yes — `Epi (chartQuotientMap d r I hI)`
- **Proof follows sketch**: yes — exhibits the splitting section via `freeMap (orderIsoOfFin)`, checks composition is identity via `chartQuotientMap_ιFree`, concludes by `IsSplitEpi.mk'.epi`
- **notes**: Proof-block `\leanok` absent — `sync_leanok` lag (minor).

---

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}` (`def:gr_universal_quotient_sheaf`)
- **Lean target exists**: yes (line 346)
- **Signature matches**: yes — `(scheme d r).Modules`
- **Proof follows sketch**: N/A (body `:= sorry`)
- **notes**: Statement-block `\leanok` honest (scaffold, awaiting `glue`). `NOTE (scaffold)` comment is workflow documentation; see Red flags.

---

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (`def:tautological_quotient`)
- **Lean target exists**: yes (line 354)
- **Signature matches**: yes — `free (Fin r) ⟶ universalQuotient d r`
- **Proof follows sketch**: N/A (body `:= sorry`)
- **notes**: Statement-block `\leanok` honest (scaffold). `NOTE (scaffold)` comment; see Red flags.

---

### `\lean{AlgebraicGeometry.Grassmannian.RankQuotient}` + family (`def:gr_rankQuotient`)
- **Lean target exists**: yes — all eight decls present (lines 376–443)
- **Signature matches**: yes — `RankQuotient (r d : ℕ) (T : Scheme.{0})` structure with `F`, `q`, `epi`, `locFree`; `Rel`/`rel_refl`/`rel_symm`/`rel_trans`; `rqSetoid`; `rqPullback`; `rqPullback_rel` — all match blueprint
- **Proof follows sketch**: yes
- **notes**: Blueprint block `def:gr_rankQuotient` (lines 662–703) has NO `\leanok` marker despite all eight declarations being complete — `sync_leanok` lag (minor). Universe note: the Lean file comment (lines 369–372) explains the forced `Type 1` shift from `Type 0`; blueprint prose does not explicitly state the universe, but the prose describes the value set as "large" (because `F : T.Modules` is large), and `Type 1` is correct; no mismatch of mathematical content.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_id}` (`lem:gr_pullbackObjUnitToUnit_id`)
- **Lean target exists**: yes (line 454)
- **Signature matches**: yes — `SheafOfModules.pullbackObjUnitToUnit (𝟙 T).toRingCatSheafHom = (Scheme.Modules.pullbackId T).hom.app (unit …)`
- **Proof follows sketch**: yes — traces the mate through the adjunction hom-equivalence, uses `unit_conjugateEquiv` + `conjugateEquiv_pullbackId_hom`, closes by `rfl`; matches the "conjugate/mate" blueprint sketch
- **notes**: Statement-block `\leanok` honest (complete proof). Proof-block `\leanok` absent — this was closed **this iter**; `sync_leanok` lag expected (minor). This is the `map_id` keystone newly closed this iter.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (`lem:gr_pullbackObjUnitToUnit_comp`)
- **Lean target exists**: yes (line 514)
- **Signature matches**: yes — `pullbackComp b a |>.hom.app unit ≫ pullbackObjUnitToUnit (b ≫ a) = (pullback b).map (pullbackObjUnitToUnit a) ≫ pullbackObjUnitToUnit b`; matches the blueprint's factoring identity exactly
- **Proof follows sketch**: partial — proof is reduced (via `homEquiv` injectivity + `Adjunction.comp_homEquiv`) to a remaining goal; the `sorry` is precisely the obstacle the blueprint's sketch leaves as the hard step (`conjugateEquiv_pullbackComp_inv`); the inline comment at lines 503–513 accurately describes the route
- **notes**: Statement-block `\leanok` honest (sorry present). No proof-block `\leanok` — correct. This is the known open item for this iter.

---

### `\lean{AlgebraicGeometry.Grassmannian.functor}` (`def:grassmannian_functor`)
- **Lean target exists**: yes (line 542)
- **Signature matches**: yes — `Scheme.{0}ᵒᵖ ⥤ Type 1`; matches blueprint (with correct `Type 1` universe forced by `F : T.Modules`)
- **Proof follows sketch**: partial — `map_id` is fully closed (line 546–565, uses `pullbackFreeIso_id`); `map_comp` is reduced to the composite free coherence but carries a `sorry` (line 595); inline comment (lines 587–594) accurately names the obstacle; matches blueprint's description of the reduction to `pullbackObjUnitToUnit_comp`
- **notes**: Statement-block `\leanok` honest (sorry in `map_comp`). `map_id` closure is the iter-054 milestone. The `map_comp` sorry is the known open item.

---

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (`thm:grassmannian_universal_property`)
- **Lean target exists**: yes (line 603)
- **Signature matches**: yes — `(functor d r).RepresentableBy (scheme d r)`
- **Proof follows sketch**: N/A (body `:= sorry`; awaits `functor`, `tautologicalQuotient`, `glue`)
- **notes**: Statement-block `\leanok` honest. No proof-block `\leanok` — correct. `NOTE (scaffold)` comment; see Red flags.

---

## Red flags

### Placeholder / suspect bodies

The following declarations have `:= sorry` bodies. Under the project's blueprint vocabulary, statement-block `\leanok` with a sorry body is the **intended scaffold state** ("at least a sorry present"), so these are **not** must-fix per project convention. They are listed here for completeness.

- `AlgebraicGeometry.Scheme.Modules.glue` (line 271): `:= sorry`. Scaffold awaiting the module-descent construction.
- `AlgebraicGeometry.Grassmannian.universalQuotient` (line 347): `:= sorry`. Scaffold awaiting `glue`.
- `AlgebraicGeometry.Grassmannian.tautologicalQuotient` (line 356): `:= sorry`. Scaffold awaiting `glue`.
- `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp` (line 524): sorry inside proof. Reducted proof; open item this iter.
- `AlgebraicGeometry.Grassmannian.functor.map_comp` (line 595): sorry inside proof. Reduced proof; open item this iter.
- `AlgebraicGeometry.Grassmannian.represents` (line 605): `:= sorry`. Scaffold awaiting `functor`/`tautologicalQuotient`/`glue`.

### Excuse-comments

The following `NOTE (scaffold)` comments acknowledge incomplete proof bodies. They describe dependency ordering rather than claiming the code is wrong, so they are **minor** (workflow documentation), not must-fix.

- `GrassmannianQuot.lean:170`: "NOTE (scaffold): the body and the module-cocycle hypotheses on `g` are still to be filled" — attached to `glue`.
- `GrassmannianQuot.lean:345`: "NOTE (scaffold): rides on `Scheme.Modules.glue`; body to be filled once `glue` lands" — attached to `universalQuotient`.
- `GrassmannianQuot.lean:353`: same — attached to `tautologicalQuotient`.
- `GrassmannianQuot.lean:601`: "NOTE (scaffold): body … to be filled once `functor`, `tautologicalQuotient`, and `Scheme.Modules.glue` land" — attached to `represents`.

These are honest dependency-tracking notes, not "wrong but works for now." No must-fix classification.

### Axioms / Classical.choice on non-trivial claims
None found.

---

## Unreferenced declarations (informational)

### Substantive — should be blueprinted

**`AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_id`** (line 481):
- Complete proof. Signature: `(pullbackFreeIso (𝟙 T) I).hom = (pullbackId T).hom.app (free I)`.
- Used load-bearingly in `functor.map_id` (line 563: `← Scheme.Modules.pullbackFreeIso_id`).
- The blueprint prose paragraph between `lem:gr_pullbackObjUnitToUnit_comp` and `def:grassmannian_functor` (lines 754–760) describes this result in words ("Together … upgrade to the corresponding free-sheaf coherences") but provides NO `\lean{...}` reference and no formal lemma block.
- **This is a major blueprint gap**: a load-bearing, named, closed declaration has no `\lean{...}` entry. A blueprint-writing subagent should add `\begin{lemma}\leanok ... \lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_id} ... \end{lemma}` to formalise the paragraph.

### Helpers — acceptable as unlisted

- `AlgebraicGeometry.Grassmannian.globalUnitSection` — blueprinted ✓
- `AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree` — blueprinted ✓ (private in Lean)
- `AlgebraicGeometry.Scheme.Modules.pullbackBaseChangeTransport` — blueprinted ✓
- All `glueData_bridge_*` — blueprinted ✓
- `RankQuotient` family helpers (`rel_refl`, `rel_symm`, `rel_trans`) — blueprinted as part of `def:gr_rankQuotient` ✓

---

## Blueprint adequacy for this file

- **Coverage**: 21 of 22 Lean declarations (counting groups) have a `\lean{...}` block; 1 substantive unblueprinted helper (`pullbackFreeIso_id`).
- **Proof-sketch depth**: **adequate** for all covered declarations. The id/comp coherence sketches (section "The functor of points," `lem:gr_pullbackObjUnitToUnit_id`/`comp`) give enough mathematical detail to guide the Lean prover; the `map_id`/`map_comp` reductions are described faithfully. The `glue` construction prose describes the descent argument at a level sufficient for the sorry placeholder (the hard step is the module descent implementation, not the statement).
- **Hint precision**: **precise** for all covered declarations. Every `\lean{...}` name resolves correctly.
- **Generality**: **matches need**. No parallel API gap detected. The `pullbackFreeIso_id` gap is a missing reference, not a generality mismatch.
- **`sync_leanok` lag**: Multiple proof blocks are missing `\leanok` for closed proofs (`pullbackBaseChangeTransport`, all three bridge lemmas, `opensMap_final`, `pullbackFreeIso`, `pullback_isLocallyFreeOfRank`, `scalarEnd_one/zero`, `chartQuotientMap_ιFree/epi`, `pullbackObjUnitToUnit_id`). This will resolve automatically when `sync_leanok` runs. The statement-block markers are all honest.
- **Missing `\leanok` on statement block**: `def:gr_rankQuotient` lacks a statement-block `\leanok` despite all eight declarations being complete — `sync_leanok` lag.

### Recommended chapter-side actions

1. **[major]** Add a formal lemma block for `pullbackFreeIso_id` between `lem:gr_pullbackObjUnitToUnit_comp` and `def:grassmannian_functor`, with `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_id}` and a proof sketch ("by coproduct extensionality, reduces to `pullbackObjUnitToUnit_id`"). Mark `\leanok` once the block is added (or let `sync_leanok` handle it).
2. **[minor]** After the next `sync_leanok` run, verify that proof-block `\leanok` markers appear on all the newly-noted closed proofs.

---

## Severity summary

- **must-fix-this-iter**: **0** findings. All sorry bodies are honest scaffolds with correct statement-level `\leanok`; no proof-block `\leanok` sits on a sorry body; no signature mismatches; no axioms.
- **major**: 1 finding — `pullbackFreeIso_id` is a load-bearing, closed, named declaration with no `\lean{...}` entry and no lemma block in the blueprint chapter.
- **minor**: (a) ~12 proof blocks missing `\leanok` for closed proofs (`sync_leanok` lag); (b) 4 `NOTE (scaffold)` workflow comments on sorry-bodied scaffolds; (c) `def:gr_rankQuotient` statement block missing `\leanok` (`sync_leanok` lag).

**Overall verdict**: The Lean file faithfully implements the blueprint chapter with no signature mismatches or dishonest markers; the sole actionable finding is a major blueprint gap — `pullbackFreeIso_id` is closed and load-bearing but lacks any blueprint entry.
