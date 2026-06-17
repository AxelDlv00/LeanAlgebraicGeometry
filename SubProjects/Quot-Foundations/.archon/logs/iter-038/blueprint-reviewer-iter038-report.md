# Blueprint reviewer — iter-038 report

**Slug:** `blueprint-reviewer-iter038`
**Date:** 2026-06-08
**Chapters audited:** 6 (all under `blueprint/src/chapters/`)

---

## Top-level summary

### leandag health

| Metric | Value |
|---|---|
| Blueprint nodes | 393 |
| Edges | 836 |
| Proved (no sorry) | 297 (75.6 %) |
| With sorry | 9 |
| Ready to formalize | 7 |
| Needs `\leanok` sync | 4 |
| Unmatched `\lean{}` hints | 92 |
| Unknown `\uses{}` refs | **0** |
| Blueprint gaps | **0** |
| Isolated (blueprint) | 1 |
| Isolated (lean_aux) | 10 |

Zero broken `\uses{}` edges. Zero blueprint nodes without a `\lean{}` hint. Dependency graph is clean.

### blueprint-doctor

Zero malformed_refs, broken_refs, orphan chapters, axiom_decls, covers_problems.

### Isolation disposition

`lem:annihilator_localization_eq_map` (QuotScheme, line 2415) — **keep as-is.** Proved, `\leanok` on statement and proof. No outgoing edge because the consumer block (a future annihilator characterization) is not yet written; the sibling `def:modules_annihilator` carries a `% NOTE` explaining the omission. This is intentionally deferred, not a structural gap.

---

## Per-chapter verdicts

### Picard_QuotScheme.tex — gates `QuotScheme.lean`

**complete: partial**
**correct: partial**

#### New coverage blocks (I + II)

**Block I — `lem:isLocalizedModule_ringEquiv_semilinear`** (line 3784):
- `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_of_ringEquiv_semilinear}` — MATCHED (decl exists in Lean). No `\leanok` (awaiting sync).
- Statement: semilinear transport of `IsLocalizedModule` across a ring iso; proof sketch transfers the three fields (map_units / surj / exists_of_eq) via the semilinear pair. Complete and correct. Coverage block is honest.

**Block II — `lem:isLocalizedModule_restrictScalars_powers_algebraMap`** (line 3805):
- `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_restrictScalars_powers_algebraMap}` — MATCHED. No `\leanok` (awaiting sync).
- Statement: restriction of scalars of an `IsLocalizedModule` from `R_r` to `R` along `algebraMap`. Proof sketch uses `map_pow` and `algebraMap_smul` via scalar tower; the `R_r`-level localization is read back as `R`-level data for the cover-form descent. Complete and correct.

#### New prover-target blocks (semilinearity wall)

**Block `def:gamma_image_ring_equiv`** (line 3827):
- `\lean{AlgebraicGeometry.Scheme.Modules.gammaImageRingEquiv}` — **UNMATCHED** (decl does not yet exist). No `\leanok`. `\uses{lem:gamma_pullback_image_iso}`.
- Statement: for open immersion `j : U → Y` and open `V ≤ U`, defines the ring iso `σ_V : Γ(𝒪_Y, j''(U,V)) → Γ(𝒪_U, V)`.
- **Issue:** The image open `j''(U,V)` is denoted by informal notation; the blueprint does not give the Lean expression (which should be something like `j.openFunctor.obj V` or equivalent). A prover needs this to elaborate the `RingEquiv` target type. **This is a must-fix: add one `% LEAN TYPE` line pinning the Lean expression for `j''(U,V)`.**

**Block `lem:gamma_pullback_image_iso_hom_semilinear`** (line 3838):
- `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso_hom_semilinear}` — **UNMATCHED**. No `\leanok`. `\uses{lem:gamma_pullback_image_iso, def:gamma_image_ring_equiv}`.
- Statement: the forward map of `gammaPullbackImageIso j M V` is `σ_V`-semilinear. Equation stated explicitly. Mathematically correct; variance of `σ_V` is sensible (covariant on module sections, contragredient for the ring action).
- **Proof sketch assessment:** The sketch names the key objects (`Functor.mapIso`, `restrictFunctorIsoPullback.symm.app M`, `mapPresheaf`-naturality) and gives the correct approach (term-mode on presheaf sections, avoid `X.Modules` instance diamond). The critical "module-structure naturality of that morphism, read through the structure-sheaf identification σ_V" is stated but the specific Lean API for the natural-transformation component (e.g. `SheafOfModules.Hom.mapPresheaf_apply` or an `IsModuleHom` instance) is not named. A skilled Lean prover can navigate from these clues, but it is thin: **partial-complete.** The block is workable for a mathlib-build prover but one additional sentence naming the specific naturality lemma would make it robust.
- **Verdict on semilinearity block:** Adequate to dispatch a prover, but the `def:gamma_image_ring_equiv` `j''(U,V)` pin is a concrete gap that must be filled before dispatch. Recommend adding a `% LEAN TYPE` comment to `def:gamma_image_ring_equiv` this iter.

**Must-fix-this-iter:**
1. Add a `% LEAN TYPE` (or equivalent) comment to `def:gamma_image_ring_equiv` giving the Lean expression for the image open `j''(U,V)` (e.g. `j.openFunctor.obj V` or the Mathlib spelling for the image of an open immersion on opens).
2. Optionally: add one sentence to the `lem:gamma_pullback_image_iso_hom_semilinear` proof sketch naming the specific naturality API (`SheafOfModules.Hom.mapPresheaf_apply` or `CommSheaf.…`).

#### Purity findings

- Line 3823: `% NOTE (iter-038): the remaining wall … build axiom-clean, NO sorry` — project-history verbosity (iteration number + construction annotation). In a `%` comment, so it does not affect rendering. Flag: minor verbosity; acceptable as scaffolding context but should be removed in blueprint-clean pass.
- Proof body of `lem:gamma_pullback_image_iso_hom_semilinear` (lines 3857–3863) uses inline Lean identifiers (`restrictFunctorIsoPullback`, `mapPresheaf`, `X.Modules`) in a `\texttt{}` call inside the proof block. This is the borderline-acceptable end of scaffolding hint practice; the `\texttt{X.Modules}` in the final warning is particularly raw. Flag for cleanup but not blocking.

**HARD-GATE verdict for QuotScheme:** **PARTIAL — conditional dispatch.** The prover may be dispatched **after** the `def:gamma_image_ring_equiv` `j''(U,V)` pin is added. The two coverage blocks (I + II) are clean; the semilinearity lemma's statement is correct; only the `gammaImageRingEquiv` type-elaboration anchor is missing.

---

### Picard_GrassmannianCells.tex — gates `GrassmannianCells.lean`

**complete: true**
**correct: true**

#### New coverage block

**`lem:gr_free_entry_eq_signed_minor`** (line 2315):
- `\lean{AlgebraicGeometry.Grassmannian.exists_minorDet_eq_free_entry}` — MATCHED (decl exists). No `\leanok` (awaiting sync).
- Statement: `minorDet d r J K' = ± X_(p,q)` (cofactor sub-step). Proof sketch: column reordering + `det_permute'` on an identity matrix with one column replaced. Mathematically sound and actionable. Coverage block is honest.

#### Live prover target — E4

**`lem:gr_existence_lift`** (line 2432):
- `\lean{AlgebraicGeometry.Grassmannian.existence_lift}` — **UNMATCHED** (decl does not exist yet). No `\leanok`.
- `\uses{}` (statement): `lem:gr_existence_chart_factorization`, `lem:gr_existence_factor_through_valuation_ring`, `def:gr_the_glue_data`, `def:gr_to_specZ`, `lem:gr_ι_toSpecZ`. All five exist in the chapter. Dependency graph complete.
- **LEAN SIGNATURE comment** (lines 2445–2448): filler = `Spec.map (CommRingCat.ofHom g') ≫ (theGlueData d r).ι J`; package as `CommSq.LiftStruct`; conclude `HasLift`. Explicit and unambiguous.
- **Top triangle proof** (lines 2464–2470): restricting `ℓ` along `Spec(R → K)` factors as `Spec(g) ∘ ι_J = i_1` via `g = (R ↪ K) ∘ g'` and `i_1 = Spec(f) ∘ ι_I`. Correct.
- **Bottom triangle proof** (lines 2470–2476): both `ℓ ∘ π` and `i_2` land in the terminal `Spec ℤ`; `specZIsTerminal.hom_ext` closes it. Correct.
- Both triangles are stated with enough detail to implement directly. Source cite (Nitsure §1) is present.

**HARD-GATE verdict for GrassmannianCells:** **CLEARS.** E4 is complete and correct; dispatch the prover.

#### Purity findings

- `% LEAN SIGNATURE` comments (lines 2445–2448) contain raw Lean 4 syntax. Intentional scaffolding; these are in `%`-comments and are standard practice for this chapter. Not a blocking issue.
- `% SOURCE QUOTE` comments (lines 2441–2444, 2488–2493) are project history annotations. Acceptable.

---

### Cohomology_FlatBaseChange.tex — no prover this iter

**complete: true**
**correct: true**

#### New coverage block

**`lem:base_change_mate_extendScalars_inner_value_counit`** (line 2920):
- `\lean{AlgebraicGeometry.base_change_mate_extendScalars_inner_value_counit}` — MATCHED (decl exists; axiom-clean per prior session). No `\leanok` (awaiting sync).
- The block correctly labels itself a "redundant variant … retained from the iter-036 step-(b) build" and notes it is a "coverage node only." The proof sketch (counit reduction via `Counit.map_apply_one_tmul`, then `congrArg _ rfl` closes the definitional match) is consistent with the axiom-clean record in memory. Block is honest.

#### `gstar_transpose` stuck state

**`lem:base_change_mate_gstar_transpose`** (line 2982):
- `\leanok` on statement (declaration exists, currently sorry'd). No `\leanok` on proof block. The `% NOTE` at lines 2984–2988 accurately records: master counit-transport identity `huce` (`conjugateEquiv_counit_symm`) is landed and compiling; the remaining ~150-LOC telescoping (steps (a)/(b)/(c)) is open. The `% LEAN SIGNATURE` comment (lines 3000–3013) specifying `Adjunction.homEquiv_counit` and the section-level content is present and detailed.
- **Stuck-state assessment:** The description is accurate and honest. No misleading claims. The proof is genuinely open; the block does not falsely represent progress.

**Must-fix-this-iter:** None.

---

### Cohomology_RegroupHelper.tex

**complete: true**
**correct: true**

One proved lemma (`lem:base_change_mate_regroupEquiv`). `\leanok` on both statement and proof. Standalone chapter is complete for its scope.

---

### Picard_FlatteningStratification.tex

**complete: true**
**correct: true**

34 `\leanok` markers across the chapter. Algebraic generic flatness (`thm:generic_flatness_algebraic`) and geometric wrapper (`thm:generic_flatness`) are both blueprinted; G1 and G3 have stub-level `\lean{}` hints. Chapter is at the expected completeness for GF-geo phase. No new blocks this iter.

---

### Picard_RelativeSpec.tex

**complete: partial**
**correct: true**

9 `\leanok` markers. Complete for `RelativeSpec` and the `gap1` (`lem:qcoh_affine_isIso_fromTildeΓ`) chain leading into it. The sub-phase stubs for QUOT-repr and GR-repr are not yet authored (referenced in `thm:grassmannian_representable` prose but no blueprint nodes). This is expected at this stage; not a blocking deficiency.

---

## Severity summary

| Chapter | complete | correct | Blocking? | Must-fix |
|---|---|---|---|---|
| Picard_QuotScheme | partial | partial | **conditional** | Pin `j''(U,V)` Lean expression in `def:gamma_image_ring_equiv` |
| Picard_GrassmannianCells | true | true | **clears** | — |
| Cohomology_FlatBaseChange | true | true | n/a (no prover) | — |
| Cohomology_RegroupHelper | true | true | n/a | — |
| Picard_FlatteningStratification | true | true | n/a | — |
| Picard_RelativeSpec | partial | true | n/a (stubs expected) | — |

---

## Unstarted-phase proposals

None. All active phases in the strategy table (`FBC-A`, `FBC-B`, `GF-geo`, `GR-proper`, `QUOT-defs`, `SNAP-S1/S3`, `QUOT-repr`) have at least three meaningful blueprint nodes covering their Lean declarations. No phase is entirely unrepresented.

---

## Overall verdict

**GrassmannianCells prover: DISPATCH — E4 chapter is complete and correct.**

**QuotScheme prover: HOLD pending one editorial fix.** Add a `% LEAN TYPE` comment to `def:gamma_image_ring_equiv` identifying the Lean expression for the image open `j''(U,V)` before dispatching the semilinearity prover. Once that single pin is in place, the semilinearity block is workable (statement correct, σ_V variance sensible, proof sketch directs toward `mapPresheaf`-naturality and away from the instance diamond). No other chapter has a blocking deficiency.
