# Lean ↔ Blueprint Check Report

## Slug
glue

## Iteration
078

## Files audited
- Lean: `AlgebraicJacobian/Picard/GlueDescent.lean` (2020 lines, ~62 named declarations)
- Blueprint: `blueprint/src/chapters/Picard_GlueDescent.tex` (269 lines, 5 `\lean{...}` blocks)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.glueProd}` (chapter: `def:gr_glue_equalizer`)

- **Lean target exists**: yes (line 940)
- **Signature matches**: yes — `noncomputable def glueProd : D.glued.Modules := ∏ᶜ fun i => (Scheme.Modules.pushforward (D.ι i)).obj (M i)` exactly matches blueprint's `P = ∏_i (ι_i)_* M_i`.
- **Proof follows sketch**: N/A (definition; body is definitionally complete)
- **notes**: The blueprint block `def:gr_glue_equalizer` describes both P and Q plus the two legs a, b. Lean splits this into `glueProd` (pinned), `glueOverlapProd`, `glueLegA`, `glueLegB`, `glueIsoEqualizer`, and `glueProj` (none pinned). The single `\lean{glueProd}` pin leaves the other five companions as unreferenced — see Blueprint Adequacy below.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapBaseChangeIso}` (chapter: `lem:glueOverlapBaseChangeIso`)

- **Lean target exists**: yes (line 1178)
- **Signature matches**: yes — `noncomputable def glueOverlapBaseChangeIso (D : Scheme.GlueData.{0}) (i j : D.J) : Scheme.Modules.pushforward (D.ι j) ⋙ restrictFunctor (D.ι i) ≅ restrictFunctor (D.t i j ≫ D.f j i) ⋙ Scheme.Modules.pushforward (D.f i j)`. Blueprint describes `β_ij : ι_i^* (ι_j)_* → (f_ij)_* (t_ij ∘ f_ji)^*` with the note that chart/overlap restrictions are realized as site-level `restrictFunctor` — matches.
- **Proof follows sketch**: yes — blueprint says `pushforwardComp ∘ (pushforward of opens-functor equality) ∘ pushforwardCongr ∘ pushforwardComp⁻¹`; Lean constructs exactly `SheafOfModules.pushforwardComp ≪≫ pushforwardNatIso (...) ≪≫ pushforwardCongr (...) ≪≫ (pushforwardComp).symm`. No sorry.
- **notes**: Blueprint proof sketch mentions "the one substantive coherence to check is naturality in V" — implemented in `glueData_overlap_appIso_compat` which is itself uncovered (see unreferenced section).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionHom}` (chapter: `lem:glueRestrictionHom`)

- **Lean target exists**: yes (line 1042)
- **Signature matches**: yes — `noncomputable def glueRestrictionHom (i : D.J) : (Scheme.Modules.pullback (D.ι i)).obj (glue D M g hC1 hC2) ⟶ M i`. Blueprint: `r_i : ι_i^* M → M_i`.
- **Proof follows sketch**: yes — body is `((pullbackPushforwardAdjunction (D.ι i)).homEquiv _ _).symm (glueProj … i)`, i.e., the adjoint transpose of the i-th equalizer projection, exactly as stated. No sorry.
- **notes**: none.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_glueRestrictionHom}` (chapter: `thm:isIso_glueRestrictionHom`)

- **Lean target exists**: yes (line 1959)
- **Signature matches**: yes — `theorem isIso_glueRestrictionHom ... (i : D.J) : IsIso (glueRestrictionHom D M g hC1 hC2 i)`. Blueprint: "r_i is an isomorphism".
- **Proof follows sketch**: **partial** — the overall proof structure matches: candidate inverse `glueRestrictionInv`, two triangle identities (r∘σ = id via `glueRestrict_hom_ext` + `glueRestrictionHom_glueChartComponent`; σ∘r = id via `glueChartComponent_self_counit`). However:
  - `glueChartFamily_equalizes` (line 1431), the equalizing condition from C2, is `:= sorry` — this is consumed by `glueRestrictionInv` and therefore by the whole proof.
  - `glueOverlapFactor_transpose` (line 1679), the mate-core for `glueOverlapFactor_mate`, is `:= sorry` — consumed by `glueRestrictionHom_glueChartComponent`.
  - The theorem body itself has no direct `sorry`, but transitively it does through these two helper lemmas.
- **notes**: `\leanok` on the statement block (correct: declaration exists). No `\leanok` on the proof block (correct: proof is not closed). The blueprint's proof sketch at lines 196–241 is detailed enough to have guided the proof structure, but the two sorry obligations are the remaining mathematical content.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionIso}` (chapter: `def:glueRestrictionIso`)

- **Lean target exists**: yes (line 2000)
- **Signature matches**: yes — `noncomputable def glueRestrictionIso ... (i : D.J) : (Scheme.Modules.pullback (D.ι i)).obj (glue D M g hC1 hC2) ≅ M i`. Blueprint: `ρ_i : ι_i^* M ≅ M_i`.
- **Proof follows sketch**: yes (N/A — definition packaging `isIso_glueRestrictionHom` via `asIso`). No direct sorry.
- **notes**: The `% NOTE:` comment in the blueprint (`def:gr_modules_glueRestrictionIso` in `Picard_GrassmannianQuot.tex` is a stale forward-declaration) is an important cross-file annotation; the review agent should ensure that duplicate `\lean{...}` pin is reconciled.

---

## Red Flags

### Placeholder / suspect bodies

- **`glueChartFamily_equalizes`** at line 1431: body is `:= sorry`. This is **Obligation 1** of `isIso_glueRestrictionHom` (C2 transported): the family `glueChartFamily` equalizes the two restricted descent legs. The blueprint's proof of `thm:isIso_glueRestrictionHom` (lines 214–231) explicitly identifies this as the content that follows from the triple-overlap multiplicativity (C2). Without this, `glueRestrictionInv` is a definition that elaborates but whose claim of being a well-typed equalizer lift cannot be discharged. **Must-fix.**

- **`glueOverlapFactor_transpose`** at line 1679: body is `:= sorry`. This is the mate-core that identifies the adjoint transpose of `(glueOverlapFactorIso D M i j).hom` along `ι_i` in terms of concrete `pushforwardComp`/`pushforwardCongr` data. Without it, `glueOverlapFactor_mate` (line 1688) applies the sorry, which in turn prevents `glueRestrictionHom_glueChartComponent` from closing — breaking **Obligation 3** (the pair-(i,j) equalizer condition transposed). **Must-fix.**

### Excuse-comments

- `glueChartFamily_equalizes`, lines 1409–1431: the sorry is preceded by an extensive `-- ROUTE` comment (lines 1409–1431) that describes the proof plan for the sorry in detail. This is the correct format for a scoped route, NOT an excuse comment. No flag here beyond the sorry itself.

- `glueOverlapFactor_transpose`, lines 1673–1679: preceded by a comment outlining the remaining site-level core computation. Same pattern — scoped route, not an excuse. No additional flag.

### Axioms / Classical.choice on non-trivial claims

None found. No `axiom` declarations. No `Classical.choice _` patterns on substantive claims.

---

## Unreferenced declarations (informational)

Of the ~62 named declarations in the file, **57 have no `\lean{...}` block in this chapter**. Most are genuinely "Project-local" helpers; the ones that name mathematical objects the blueprint discusses verbally (and whose absence is a coverage debt) are:

**Substantive — should eventually get blueprint blocks:**

| Declaration | Line | Why it matters |
|---|---|---|
| `pullbackBaseChangeTransport` | 57 | Blueprint cites `lem:modules_pullback_basechange_transport` inline (docstring tag present) but no `\lean{...}` block in this chapter |
| `glue` | 106 | Core construction; `def:scheme_modules_glue` `\lean{...}` presumably lives in another chapter — not a fault of this chapter |
| `glueLift` | 176 | Companion to `glue`; same cross-chapter note |
| `glueOverlapProd` | 945 | The "Q" product in `def:gr_glue_equalizer`; blueprint describes it but `glueProd` is the only pin |
| `glueLegA` / `glueLegB` | 953/963 | The parallel pair `a, b` described in `def:gr_glue_equalizer`; no `\lean{...}` |
| `glueProj` | 1004 | "i-th projection" mentioned by name in `lem:glueRestrictionHom` proof sketch |
| `glueOverlapFactorIso` | 1357 | The pullback-form β used throughout the inverse construction; blueprint calls it "overlap base change" in the proof of `thm:isIso_glueRestrictionHom` |
| `glueChartComponent` | 1374 | The j-th component of σ_i; the blueprint's proof formula (lines 222–226) exactly describes its construction |
| `glueChartFamily` | 1384 | The full family; blueprint says "a morphism M_i → ι_i^* P … a compatible family of morphisms" |
| `glueRestrictionInv` | 1436 | The candidate inverse σ_i; blueprint says "We produce an inverse s_i" |
| `glueChartComponent_self_counit` | 1510 | Obligation 2 (C1 + counit triangle); blueprint explicitly identifies this content |
| `glueRestrictionHom_glueChartComponent` | 1872 | Obligation 3 (pair-(i,j) equalizer condition); blueprint calls it "the reverse composite s_i ∘ r_i = id" |
| `glueOverlapFactor_mate` | 1688 | Conjugate-calculus engine; feeds Obligation 3 |
| `pullback_map_jointly_faithful` | 1210 | Separation of the chart cover; blueprint references `lem:gr_modules_glue_unique` in `\uses` for `thm:isIso_glueRestrictionHom` |

**Helper-only — no blueprint block expected:**

`glueData_bridge_src/mid/tgt`, `opensMap_final`, `pullbackFreeIso*`, `pullbackObjUnitToUnit_*`, `homEquiv_conjugateEquiv_app`, `pullbackFreeIso_comp`, `pullbackFreeIso_inv_congr_hom`, `pullbackCongr_hom_app_free`, `pullbackFreeIso_inv_congr`, `pullbackCongr_inv_app_free`, `pullbackComp_inv_app_free_map`, `homEquiv_comp_unit_pushforwardComp`, `homEquiv_comp_pushforwardCongr`, `glueLift_cond_iff`, `restrictFunctor_isRightAdjoint`, `restrictFunctor_preservesLimits`, `pullback_preservesLimits_of_isOpenImmersion`, `glueIsoEqualizer`, `glueLift_glueProj`, `glueRestrictEqualizerIso`, `glueRestrictProdIso`, `pullback_map_glueLift_glueRestrictionHom`, `glueData_preimage_image_eq`, `glueData_overlap_opensFunctor_eq`, `appLE_congr_mor`, `glueData_overlap_appIso_compat`, `glueOverlapBaseChangeIso_inv/hom_app_app`, `restrictAdjunction_unit_app_iso`, `restrictFunctorIsoPullback_hom_app_counit`, `pullbackCongr_hom_app_eqToHom`, `restrictFunctorCongr_rfl_hom_app`, `restrictFunctorIsoPullback_congr`, `glueRestrict_proj_compat`, `glueRestrictionInv_pullback_map_glueProj`, `glueRestrict_hom_ext`, `glueOverlapFactor_transpose`, `glueRestriction_overlap_compat`, `pullback_isLocallyFreeOfRank`.

---

## Blueprint adequacy for this file

- **Coverage**: 5/62 Lean declarations have a corresponding `\lean{...}` block. Unreferenced: ~43 helpers (acceptable for the proof engine) + ~14 substantive declarations (listed above, flagged as coverage debt).
- **Proof-sketch depth**: **adequate** for the 5 covered declarations. The proof sketch of `thm:isIso_glueRestrictionHom` (blueprint lines 196–241) is detailed enough to have guided formalization: it names the candidate inverse, the three-step component construction, the three obligations (C2 equalizing, C1+counit triangle, pair-(i,j) condition), and references the Mayer–Vietoris limit engine. A prover reading it would arrive at the Lean structure found in the file.
- **Hint precision**: **loose** — the 14 substantive declarations listed above have no `\lean{...}` hints at all, so a prover or auditor reading only the blueprint cannot find the Lean names for the candidate-inverse components, the overlap base change in pullback form, the joint faithfulness lemma, or the individual obligations.
- **Generality**: **matches need** — no narrower-than-needed abstract definitions were found. The use of `restrictFunctor` in `glueOverlapBaseChangeIso` (site-level, not geometric pullback) is intentional per the blueprint's note and is the correct level.

**Recommended chapter-side actions** (for the blueprint-writing subagent):

1. Add `\lean{...}` blocks for the 14 substantive uncovered declarations in the candidate-inverse cluster (minimally: `glueOverlapFactorIso`, `glueChartComponent`, `glueChartFamily`, `glueRestrictionInv`, `glueChartComponent_self_counit`, `glueRestrictionHom_glueChartComponent`, `glueOverlapFactor_mate`, `pullback_map_jointly_faithful`).
2. Expand `def:gr_glue_equalizer` to also pin `glueOverlapProd`, `glueLegA`, `glueLegB`, and `glueProj` (currently only `glueProd` is pinned despite the block describing all five objects).
3. Reconcile the duplicate `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionIso}` pin flagged by the `% NOTE:` in `def:glueRestrictionIso` (a stale copy reportedly lives in `Picard_GrassmannianQuot.tex`).

---

## Severity summary

### must-fix-this-iter

1. **`glueChartFamily_equalizes` (line 1431): `:= sorry`**. This is Obligation 1 of `isIso_glueRestrictionHom` (C2 transported). It is a non-trivial mathematical claim (the triple-overlap multiplicativity condition, transported through the overlap base changes, makes the candidate inverse family equalize the restricted descent legs). Without it, `glueRestrictionInv` produces an ill-formed equalizer lift and the whole proof of `isIso_glueRestrictionHom` is blocked.

2. **`glueOverlapFactor_transpose` (line 1679): `:= sorry`**. This is the mate-core for `glueOverlapFactor_mate`. It identifies the adjoint transpose of `(glueOverlapFactorIso D M i j).hom` along `ι_i` in terms of concrete `(ι_j)_* (unit_{t_ij ≫ f_ji}) ≫ pushforwardComp ≫ pushforwardCongr ≫ pushforwardComp⁻¹` data. Without it, `glueRestrictionHom_glueChartComponent` (Obligation 3) cannot close, breaking the `r_i ∘ σ_i = id` arm of `isIso_glueRestrictionHom`.

### major

3. **Blueprint coverage gap — 14 substantive declarations uncovered.** The proof structure of `thm:isIso_glueRestrictionHom` is implemented via at least 14 declarations whose mathematical content the blueprint describes verbally but does not pin with `\lean{...}` blocks (listed in the unreferenced section). This makes the chapter inadequate as a standalone reference for auditing or re-formalizing the proof. Filling the two sorries (items 1–2) is a prerequisite before adding the blocks, but the blocks should follow promptly.

4. **`def:gr_glue_equalizer` pins only `glueProd` of six sibling declarations.** `glueOverlapProd`, `glueLegA`, `glueLegB`, `glueIsoEqualizer`, `glueProj` share the same blueprint block but have no `\lean{...}` reference.

5. **Duplicate `\lean{...}` pin** for `glueRestrictionIso` reportedly in `Picard_GrassmannianQuot.tex` (flagged by a `% NOTE:` in the blueprint by the review agent). Cross-chapter pin duplication can cause `sync_leanok` to write `\leanok` on a stale forward-declaration block.

### minor

6. `\lean{lem:modules_pullback_basechange_transport}` appears in the docstring of `pullbackBaseChangeTransport` but no corresponding block in this chapter (the declaration may belong in a different chapter; low priority).

---

**Overall verdict**: The 5 `\lean{...}`-covered declarations are correctly stated and well-matched to the blueprint; the proof structure of `isIso_glueRestrictionHom` faithfully implements the blueprint's sketch, but 2 must-fix sorries (`glueChartFamily_equalizes` and `glueOverlapFactor_transpose`) prevent the proof from closing, and the blueprint chapter has major coverage debt (~14 substantive helper declarations with no `\lean{...}` blocks).
