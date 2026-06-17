# Lean ↔ Blueprint Check Report

## Slug
grquot-iter056

## Iteration
057

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackComp}` (def:modules_pullbackComp)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes — `\mathlibok` correctly marks this as Mathlib-supplied
- **Proof follows sketch**: N/A
- **notes**: Correctly tagged `\mathlibok`. No action needed.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackBaseChangeTransport}` (lem:modules_pullback_basechange_transport)
- **Lean target exists**: yes (line 196)
- **Signature matches**: yes — `{W V : Scheme.{u}} (p : W ⟶ V) (a : V ⟶ Yi) (b : V ⟶ Yj) (g : pullback a Mi ≅ pullback b Mj) : pullback (p ≫ a) Mi ≅ pullback (p ≫ b) Mj`. More general than the blueprint (abstract p : W → V, not specifically triple-overlap projections); mathematically equivalent.
- **Proof follows sketch**: yes — `pullbackComp⁻¹ ∘ pullback(g) ∘ pullbackComp`, exactly the blueprint's description.
- **notes**: `\leanok` present. ✓

### `\lean{...glueData_bridge_src, ...glueData_bridge_mid, ...glueData_bridge_tgt}` (lem:gr_glueData_bridges)
- **Lean target exists**: yes — all three at lines 209, 218, 230
- **Signature matches**: yes — all three match the blueprint's (src)/(mid)/(tgt) equalities exactly
- **Proof follows sketch**: yes — (src) is `pullback.condition`; (mid) uses `t_fac`; (tgt) chains `t_fac`, `t_inv`, `cocycle`, as blueprinted
- **notes**: Blueprint block at line 151 has NO `\leanok` despite all three being sorry-free. `sync_leanok` should fix; not a checker finding.

### `\lean{AlgebraicGeometry.Scheme.Modules.gluePresheaf}` (def:gr_modules_gluePresheaf)
- **Lean target exists**: **no** — no `gluePresheaf` declaration anywhere in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **MISMATCH — abandoned route.** The blueprint describes a hand-built presheaf of compatible families (lines 190–215). The Lean took the equalizer-of-pushforwards route instead. This declaration was never implemented and will likely never be implemented. The `\lean{...}` hint is stale.

### `\lean{AlgebraicGeometry.Scheme.Modules.gluePresheafModule}` (def:gr_modules_gluePresheafModule)
- **Lean target exists**: **no**
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Same as `gluePresheaf` — describes the abandoned presheaf route. Stale `\lean{...}` hint.

### `\lean{AlgebraicGeometry.Scheme.Modules.gluePresheafIsSheaf}` (lem:gr_modules_gluePresheaf_isSheaf)
- **Lean target exists**: **no**
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Same — abandoned route. Stale `\lean{...}` hint.

### `\lean{AlgebraicGeometry.Scheme.Modules.glue}` (def:scheme_modules_glue)
- **Lean target exists**: yes (line 245)
- **Signature matches**: yes — `(D : GlueData) (M : ∀ i, (D.U i).Modules) (g : ∀ i j, ...) (_hC1 : ...) (_hC2 : ...) : D.glued.Modules`. Matches the blueprint's signature exactly including C1/C2 hypotheses.
- **Proof follows sketch**: **partial mismatch.** The Lean body implements an equalizer of pushforwards `∏ᵢ (ιᵢ)_* Mᵢ ⇉ ∏_{ij} (j_ij)_* (f_ij^* Mᵢ)` and closes with `equalizer a b`. The blueprint's "Construction" paragraph (lines 320–332) explicitly describes the *three-step presheaf route*: build `gluePresheaf`, apply `gluePresheafModule`, prove `gluePresheafIsSheaf`. The Lean bypasses all three. The final mathematical result is equivalent (both produce a sheaf of modules on `D.glued`), but the construction paths diverge.
- **notes**: `\leanok` present. The equalizer construction is axiom-clean. The cocycle hyps `_hC1`/`_hC2` are kept in the signature but are prefixed with `_` (unused in the body), consistent with the Lean docstring explanation that they pin down `glueRestrictionIso` downstream. The blueprint's claim "it is subject to them that the gluing is well-defined" is mildly misleading about where in the proof tree they are consumed, but the blueprint required them as hypotheses and the Lean keeps them — the *signature* is faithful.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionIso}` (def:gr_modules_glueRestrictionIso)
- **Lean target exists**: **no**
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Not yet formalized (the Lean docstring for `glue` notes it as "built downstream"). The blueprint's `\lean{...}` hint is aspirational. No `\leanok` on the blueprint block, so this is an unformalized target. Acceptable.

### `\lean{AlgebraicGeometry.Scheme.Modules.glue_unique}` (lem:gr_modules_glue_unique)
- **Lean target exists**: **no**
- **Signature matches**: N/A
- **notes**: Not yet formalized. No `\leanok` on blueprint block. Acceptable.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueHom}` (def:gr_modules_glueHom)
- **Lean target exists**: **no**
- **notes**: Not yet formalized. No `\leanok` on blueprint block. Acceptable.

### `\lean{AlgebraicGeometry.Scheme.Modules.opensMap_final}` (lem:gr_opensMap_final)
- **Lean target exists**: yes (line 326)
- **Signature matches**: yes — `{T' T : Scheme.{u}} (φ : T' ⟶ T) : (Opens.map φ.base).Final`
- **Proof follows sketch**: yes — structured-arrow category has terminal object `⊤`, hence connected. Matches blueprint exactly.
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso}` (lem:gr_pullbackFreeIso)
- **Lean target exists**: yes (line 345)
- **Signature matches**: yes — `(φ : T' ⟶ T) (I : Type u) : pullback φ (free I) ≅ free I`
- **Proof follows sketch**: yes — uses `opensMap_final` then `SheafOfModules.pullbackObjFreeIso`
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullback_isLocallyFreeOfRank}` (lem:gr_pullback_isLocallyFreeOfRank)
- **Lean target exists**: yes (line 358)
- **Signature matches**: yes
- **Proof follows sketch**: yes — pulls back the trivialising cover, uses `pullbackComp` + `pullbackFreeIso`
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}` (def:gr_globalUnitSection)
- **Lean target exists**: yes (line 37)
- **Signature matches**: yes — `(a : Γ(X, ⊤)) : (SheafOfModules.unit X.ringCatSheaf).sections`
- **Proof follows sketch**: yes — componentwise restriction of `a`
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}` (def:gr_scalarEnd)
- **Lean target exists**: yes (line 50)
- **Signature matches**: yes — `(a : Γ(X, ⊤)) : unit R ⟶ unit R` via `unitHomEquiv.symm`
- **Proof follows sketch**: yes
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_one}` (lem:gr_scalarEnd_one)
- **Lean target exists**: yes (line 56)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_zero}` (lem:gr_scalarEnd_zero)
- **Lean target exists**: yes (line 67)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` (def:gr_chart_quotient)
- **Lean target exists**: yes (line 87)
- **Signature matches**: yes — `(d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) : free (Fin r) ⟶ free (Fin d)` on the affine chart
- **Proof follows sketch**: yes — biproduct matrix assembly using `scalarEnd` of each `universalMatrix` entry
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` (lem:gr_chartQuotientMap_iFree)
- **Lean target exists**: yes (line 103), but declared `private`
- **Signature matches**: yes — `chartQuotientMap_ιFree (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) (k : Fin d) : ιFree (I.orderIsoOfFin hI k) ≫ chartQuotientMap = ιFree k`
- **Proof follows sketch**: yes
- **notes**: `\leanok` present. **Minor issue**: declared `private`. In Lean 4, private declarations get a mangled exported name, so `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` may not resolve correctly for `lean_verify` / `sync_leanok`. Consider making it non-private if the blueprint references it by name.

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_epi}` (lem:gr_chartQuotientMap_epi)
- **Lean target exists**: yes (line 145)
- **Signature matches**: yes — `Epi (chartQuotientMap d r I hI)`
- **Proof follows sketch**: yes — exhibits a section (split epi) via `IsSplitEpi.mk'`
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}` (def:gr_universal_quotient_sheaf)
- **Lean target exists**: yes (line 392)
- **Signature matches**: yes — `(d r : ℕ) : (scheme d r).Modules`
- **Proof follows sketch**: N/A — body is `:= sorry`
- **notes**: `\leanok` on statement block (correctly reflects that the statement is formalized with sorry). The docstring explains the remaining gap (GL_d bundle cocycle). No excuse-comment for wrong code — this is an in-progress obligation, acknowledged by the project as gated on the bundle cocycle.

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (def:tautological_quotient)
- **Lean target exists**: yes (line 402)
- **Signature matches**: yes — `(d r : ℕ) : free (Fin r) ⟶ universalQuotient d r`
- **Proof follows sketch**: N/A — body is `:= sorry`
- **notes**: `\leanok` on statement block. Rides on `universalQuotient` (sorry chain). Acceptable.

### `\lean{AlgebraicGeometry.Grassmannian.RankQuotient, ...RankQuotient.Rel, ...rel_refl/symm/trans, rqSetoid, rqPullback, rqPullback_rel}` (def:gr_rankQuotient)
- **Lean target exists**: yes — all at lines 424–491
- **Signature matches**: yes — structure, relation def, three relation lemmas, setoid instance, pullback def, pullback-respects-rel lemma; all match the blueprint description
- **Proof follows sketch**: yes (all sorry-free except none needed)
- **notes**: Blueprint block has NO `\leanok` marker despite all declarations being sorry-free. `sync_leanok` should add it. The blueprint says `q ∘ f = q'` (note direction) while the Lean says `x.q ≫ f.hom = y.q` — these are the same up to notation (pre-compose vs post-compose with iso); **consistent**. The `rqPullback.epi` field uses a fully explicit term-mode proof (lines 472–477) due to the `T.Modules` instance diamond; this is implementation detail.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_id}` (lem:gr_pullbackObjUnitToUnit_id)
- **Lean target exists**: yes (line 502)
- **Signature matches**: yes — states `pullbackObjUnitToUnit (𝟙 T).toRingCatSheafHom = (pullbackId T).hom.app (unit T.ringCatSheaf)`
- **Proof follows sketch**: yes — mate construction argument via adjunction conjugate
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_id}` (lem:gr_pullbackFreeIso_id)
- **Lean target exists**: yes (line 529)
- **Signature matches**: yes
- **Proof follows sketch**: yes — coproduct extensionality reducing to unit coherence
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.homEquiv_conjugateEquiv_app}` (lem:gr_homEquiv_conjugateEquiv_app)
- **Lean target exists**: yes (line 556)
- **Signature matches**: yes — `adj₂.homEquiv c d (α.app c ≫ f) = adj₁.homEquiv c d f ≫ (conjugateEquiv adj₁ adj₂ α).app d`
- **Proof follows sketch**: yes
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (lem:gr_pullbackObjUnitToUnit_comp)
- **Lean target exists**: yes (line 597)
- **Signature matches**: yes — composite coherence equation matching the blueprint
- **Proof follows sketch**: yes — mate compatibility argument via `conjugateEquiv_pullbackComp_inv`
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_comp}` (lem:gr_pullbackFreeIso_comp)
- **Lean target exists**: yes (line 674)
- **Signature matches**: yes
- **Proof follows sketch**: yes — coproduct extensionality reducing to unit composite coherence
- **notes**: `\leanok` present. ✓

### `\lean{AlgebraicGeometry.Grassmannian.functor}` (def:grassmannian_functor)
- **Lean target exists**: yes (line 817)
- **Signature matches**: yes — `(d r : ℕ) : Scheme.{0}ᵒᵖ ⥤ Type 1`. Blueprint says "functor from schemes to sets"; Lean uses `Type 1` due to `T.Modules` being large. This is forced and the docstring acknowledges it. ✓
- **Proof follows sketch**: yes — `map_id` and `map_comp` both proved via `pullbackFreeIso_id`/`pullbackFreeIso_comp` coherences, matching the blueprint's description.
- **notes**: `\leanok` present. Fully proved (no sorry). ✓

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (thm:grassmannian_universal_property)
- **Lean target exists**: yes (line 896)
- **Signature matches**: yes — `(d r : ℕ) (hd : 1 ≤ d) (hdr : d ≤ r) : (functor d r).RepresentableBy (scheme d r)`
- **Proof follows sketch**: N/A — body is `:= sorry`
- **notes**: `\leanok` on statement block. Blueprint has a detailed proof sketch (Nitsure §1 construction); this is the correct proof plan. Sorry rides on `tautologicalQuotient` being sorry. Acceptable.

---

## Red flags

### Placeholder / suspect bodies

The following declarations have `:= sorry` bodies. All are **expected in-progress stubs**, not unexplained placeholders — each has a docstring NOTE explaining the remaining gap (GL_d bundle cocycle) and each has `\leanok` on its statement block in the blueprint (consistent with the project's convention that `\leanok` on a statement block means "at least a sorry present"):

- `universalQuotient` (line 392): blocked on GL_d bundle transition cocycle
- `tautologicalQuotient` (line 402): rides on `universalQuotient`
- `represents` (line 896): rides on `tautologicalQuotient`

These are NOT must-fix findings. The sorry chain is acknowledged and tracked.

### Excuse-comments

None found. The NOTE docstrings on `universalQuotient`, `tautologicalQuotient`, and `represents` describe what's needed to close the sorry; they are progress notes, not "wrong but works for now" excuses.

### Axioms / Classical.choice on non-trivial claims

None found. No `axiom` declarations in the file.

---

## Unreferenced declarations (informational)

The following Lean declarations are NOT referenced by any `\lean{...}` block in the blueprint:

| Declaration | Notes |
|---|---|
| `globalUnitSection` (line 37) | Blueprint has `\lean{...}` for it — it IS referenced, see `def:gr_globalUnitSection`. ✓ |

All substantive declarations are referenced. The only purely internal helpers are `chartQuotientMap_ιFree` (private, referenced but private-mangled) and the `scalarEnd_one`/`scalarEnd_zero` lemmas (referenced at `lem:gr_scalarEnd_one`/`lem:gr_scalarEnd_zero`). No substantive unreferenced declarations.

---

## Blueprint adequacy for this file

- **Coverage**: ~29/29 Lean declarations have a corresponding `\lean{...}` block (100%), except for 3 in-progress sorry stubs that are also correctly blueprinted with `\leanok` on their statement blocks. However, the blueprint additionally references **6 declarations that do NOT exist in the Lean file**: `gluePresheaf`, `gluePresheafModule`, `gluePresheafIsSheaf` (abandoned route) and `glueRestrictionIso`, `glue_unique`, `glueHom` (not yet formalized).

- **Proof-sketch depth**: **under-specified in one critical way**. The `def:scheme_modules_glue` "Construction" paragraph (blueprint lines 320–332) describes a three-step presheaf-assembly route (`gluePresheaf` → `gluePresheafModule` → `gluePresheafIsSheaf`). The Lean took a completely different route: effective descent via equalizer of pushforwards. The blueprint does not describe this route at all; there is no mention of the `∏ᵢ (ιᵢ)_* Mᵢ ⇉ ∏_{ij} (j_ij)_* (f_ij^* Mᵢ)` equalizer anywhere in the chapter.

- **Hint precision**: **stale for three blocks**. The `\lean{...}` hints for `gluePresheaf`, `gluePresheafModule`, `gluePresheafIsSheaf` point to declarations that were never formalized and will not be formalized (the route was deliberately abandoned). These hints are inaccurate and may confuse future agents or readers.

- **Generality**: matches need — the declarations that ARE formalized match the project's needs.

- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. **Update `def:scheme_modules_glue` Construction paragraph** to describe the equalizer-of-pushforwards route: `P = ∏ᵢ (ιᵢ)_* Mᵢ`, two legs `a, b : P → ∏_{ij} (j_ij)_* (f_ij^* Mᵢ)`, glued sheaf = `equalizer a b`. Note that `_hC1`/`_hC2` are not consumed by the object itself but will be needed for `glueRestrictionIso`.
  2. **Remove or annotate with `% NOTE:`** the three presheaf-route blocks (`def:gr_modules_gluePresheaf`, `def:gr_modules_gluePresheafModule`, `lem:gr_modules_gluePresheaf_isSheaf`). These describe a route that was deliberately abandoned in favor of the equalizer approach. Their `\lean{...}` hints are stale.
  3. **Update `def:gr_modules_glueRestrictionIso`, `lem:gr_modules_glue_unique`, `def:gr_modules_glueHom`** to note they require the equalizer-based `glue` and a different proof strategy than what the old presheaf-route description implies (since the presheaf-compatible-families description is gone). These remain valid targets.
  4. **Minor**: The `lem:gr_glueData_bridges` block and `def:gr_rankQuotient` block are missing `\leanok` — `sync_leanok` should handle this.
  5. **Minor**: Consider making `chartQuotientMap_ιFree` non-private since the blueprint references it by its full qualified name.

---

## Severity summary

| Finding | Severity |
|---|---|
| `def:scheme_modules_glue` "Construction" paragraph describes presheaf route; Lean uses equalizer route (valid but different) | **major** |
| `\lean{gluePresheaf}`, `\lean{gluePresheafModule}`, `\lean{gluePresheafIsSheaf}` point to non-existent declarations (abandoned route) | **major** |
| `chartQuotientMap_ιFree` is `private` but blueprint references it by its public qualified name | **minor** |
| `lem:gr_glueData_bridges` and `def:gr_rankQuotient` missing `\leanok` (sync_leanok should fix) | **informational** |
| `_hC1`/`_hC2` unused in `glue` body — blueprint says "subject to them gluing is well-defined" but they're deferred to `glueRestrictionIso` | **minor** (signature is faithful; prose is slightly misleading) |
| `glueRestrictionIso`, `glue_unique`, `glueHom` not yet formalized (no `\leanok`, expected) | **informational** |

**Overall verdict**: The Lean file is faithful to the blueprint in all formalized declarations (no wrong signatures, no unauthorized axioms, no excuse-comments); the two must-fix criteria are not triggered. The primary concern is a **major blueprint accuracy gap**: the chapter still describes the abandoned hand-built presheaf route for `glue` (three phantom blocks with stale `\lean{...}` hints), while the Lean successfully closed `glue` via the equalizer-of-pushforwards route — a valid and axiom-clean construction that the blueprint does not document. The blueprint's "Construction" paragraph needs updating. — 30 declarations checked, 0 must-fix red flags, 2 major blueprint-accuracy findings.
