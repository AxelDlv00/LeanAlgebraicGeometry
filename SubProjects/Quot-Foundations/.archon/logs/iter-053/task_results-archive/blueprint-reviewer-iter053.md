# Blueprint Review: iter053
**Iter:** 053

## Top-level summaries

- **Deps/Isolated (1 blueprint node)**: `Picard_FlatteningStratification.tex` — `lem:mathlib_flat_of_localized_maximal` isolated; disposition: **keep** (deliberately standalone contrast anchor, referenced only in explanatory prose at line 1929, not a mathematical dependency).
- **Missing edges**: `Picard_FlatteningStratification.tex` — B1 (`lem:gf_flat_localizedModule_sameBase`) has no `\uses{}` on statement or proof block; `Picard_GrassmannianQuot.tex` — `lem:gr_glueData_bridges` not in `\uses{}` of `def:gr_universal_quotient_sheaf`.
- **Gaps (missing \lean{})**: `Picard_QuotScheme.tex` — `lem:comp…`, `lem:gamm…`, `lem:floc…` (each impacts 18–19 downstream nodes).
- **Rendering**: blueprint-doctor reports 0 malformed_refs, 0 broken_refs, 0 orphan_chapters. Clean.
- **Routes**: single route per target; no multi-route coverage gaps.

---

## Hard-gate verdicts for dispatch

| Chapter | complete | correct | Gate |
|---|---|---|---|
| `Picard_FlatteningStratification.tex` | true | **partial** | ✗ WRITER NEEDED |
| `Picard_SectionGradedRing.tex` | true | true | ✓ CLEAR |
| `Picard_GrassmannianQuot.tex` | true | **partial** | ✗ WRITER NEEDED |

---

## Per-chapter

### `Picard_FlatteningStratification.tex`
- **Complete**: true
- **Correct**: partial
- **Notes**:
  1. **B1 missing `\uses{}` (must-fix)**: `lem:gf_flat_localizedModule_sameBase` (line 1956) has neither `\uses{}` on the statement block nor on the proof block. The proof relies on (a) "LocalizedModule T commutes with lTensor over R" and (b) "exactness of LocalizedModule T" — neither is named as a dependency. Missing edges prevent leandag from tracking B1's proof dependencies; a prover dispatched to B1 gets no DAG guidance. Writer directive: add `\uses{}` listing at minimum a new Mathlib anchor for the commutation isomorphism `LocalizedModule T (N ⊗_R K) ≅ (LocalizedModule T N) ⊗_R K` (search `LocalizedModule.map_smul`, `LinearEquiv.ofBijective` in Mathlib; if absent, name it as a bespoke sub-lemma).
  2. **Assembly proof implicit step (must-fix)**: `lem:gf_flat_locality_assembly` (line 2027) proof asserts "by B2, the resulting module is exactly Γ(F,D(g)) ≅ (M_j)_{ḡ}" after applying B1 to `(M_j)_f`. This relies on `(M_j)_{ḡ} = LocalizedModule(powers ḡ)(M_j)_f`, which requires that `f` is already invertible in `(B_j)_{ḡ}` — a consequence of `D(g) ⊆ p^{-1}(D(f))`. This step is not spelled out. Writer directive: add the sentence "Since D(g) ⊆ p⁻¹(D(f)), the element f inverts in (B_j)_{ḡ}, so (M_j)_{ḡ} = LocalizedModule(powers ḡ)(M_j)_f (transitivity of localization)" to the proof.
  3. **B1 mathematical correctness**: The B1 proof sketch is mathematically sound. The commutation `LocalizedModule T (N⊗_R K) ≅ (LocalizedModule T N) ⊗_R K` for T ⊆ B, K an R-module, holds by universal property (elements (n⊗k)/t ↔ (n/t)⊗k). The exactness argument is clean. Adequate for a prover once \uses{} is added.
  4. **Dead-route residue (soon)**: G3.2 (`lem:gf_stalk_flat_over_base`) and G3.4 (`lem:gf_stalk_flat_localBase`) remain in the blueprint but are not in the `\uses{}` closure of `thm:generic_flatness` via the new assembly. G3.3 (`lem:gf_flat_base_local_on_source`) likewise no longer on main path. All are `\leanok`, so they cause no errors, but they are dead branches. Consider removing `\lean{}` targets or marking as deprecated in a future cleanup iter. (Not blocking this iter.)
  5. **thm:generic_flatness `\uses{}` on statement**: lists only `{thm:generic_flatness_algebraic}` — appropriate (statement depends only on the algebraic form; the proof block correctly lists the full set including assembly and G1-bridge).
  6. **Isolated node** `lem:mathlib_flat_of_localized_maximal`: keep (see top-level summary).

### `Picard_SectionGradedRing.tex`
- **Complete**: true
- **Correct**: true
- **Notes**:
  1. **`lem:relativeTensor_as_coequalizer`** (the new coequalizer brick): statement correct — relative tensor presheaf P⊗_p Q is objectwise the coequalizer of P⊗_ℤ 𝒪_X ⊗_ℤ Q ⇉ P⊗_ℤ Q; proof is sound (colimits of abelian presheaves are objectwise); `\uses{lem:presheafModule_monoidal_mathlib}` is adequate. The brick is adequate to discharge the crux `lem:isIso_sheafification_whiskerRight_unit`.
  2. **`lem:isIso_sheafification_whiskerRight_unit` proof (soon)**: Uses "J.W is monoidal for ⊗_ℤ: whiskering a local iso by ⊗_ℤ yields a local iso" without a named `\uses{}` entry. This is a valid Mathlib fact (sheafification is exact → ⊗_ℤ preserves J.W), but it is not cited. Not a hard blocker — prose is clear enough for a prover — but a Mathlib anchor `lem:abelianW_stable_tensor` or similar would make the DAG faithful. Add as a follow-up writer task.
  3. All other blocks (`lem:presheafModule_monoidal_mathlib`, `lem:presheafModule_sheafification_mathlib`, `lem:moduleUnit_mathlib`, tensor power infrastructure, lax-monoidal Γ, graded assembly) are complete and correct. No math errors found.
  4. **HARD GATE**: CLEAR. Prover may be dispatched.

### `Picard_GrassmannianQuot.tex`
- **Complete**: true
- **Correct**: partial
- **Notes**:
  1. **`lem:gr_glueData_bridges` missing from `def:gr_universal_quotient_sheaf \uses{}` (must-fix)**: The three bridges (`glueData_bridge_src/mid/tgt`) prove the scheme-morphism equalities that make the C2 cocycle condition typecheck in `def:scheme_modules_glue`. `def:gr_universal_quotient_sheaf` invokes the module glue with C2 as a hypothesis — the bridges are the proof of that hypothesis. Yet they appear nowhere in `def:gr_universal_quotient_sheaf \uses{}` (current list: `{def:gr_chart_quotient, def:gr_universalMinorInv, def:gr_transition, lem:gr_cocycle, def:gr_glued_scheme, def:scheme_modules_glue, def:is_locally_free_of_rank}`). Writer directive: add `lem:gr_glueData_bridges` to `\uses{}` of `def:gr_universal_quotient_sheaf`. Disposition: **wire-up**.
  2. **`lem:gr_glueData_bridges` content**: Statement correctly describes the three equalities (src = pullback condition; mid = t_fac composition; tgt = t_fac associativity + t_inv + cocycle). Proof correctly routes each through D.t_fac / D.cocycle. `\uses{def:gr_the_glue_data}` is adequate. The three-declaration `\lean{...}` block is correctly formatted.
  3. **`lem:modules_pullback_basechange_transport`** (`\leanok`): proof is complete; `\uses{def:modules_pullbackComp, def:gr_the_glue_data}` is adequate.
  4. All other blocks (infrastructure, chart quotient, universal quotient sheaf, tautological quotient, functor of points, universal property theorem) are complete and have adequate `\uses{}` chains. The universal property proof is sound and detailed enough to dispatch a prover.
  5. **HARD GATE**: NOT MET. Writer must add `lem:gr_glueData_bridges` to `def:gr_universal_quotient_sheaf \uses{}` before prover dispatch.

### `Cohomology_RegroupHelper.tex`
- **Complete**: true — **Correct**: true. Single lemma block + Mathlib anchor; `\leanok` on both.

### `Cohomology_FlatBaseChange.tex`
- Not readable in full (>256KB). Not re-specced this iter. From prior verdicts and STRATEGY.md the chapter is complete for its existing scope (FBC-A2 blueprint present; FBC-B gated on A1). No new must-fix from this iter.

### `Picard_GrassmannianCells.tex`
- Not a focus chapter. All DONE per strategy (cells + cocycle + glue + sep + proper). No findings.

### `Picard_QuotScheme.tex`
- **Complete**: partial — 3 lemmas missing `\lean{}` hints (leandag: `lem:comp…` 816 effort/19 impact, `lem:gamm…` 743/18, `lem:floc…` 693 eff.total 1509/18). These affect 18–19 downstream nodes each; prover dispatched to those nodes cannot get LSP feedback. From chapter grep: candidates are `lem:composite_basic_open_immersion_isOpenImmersion` (4761), `lem:gamma_pullback_image_iso` (4378), `lem:flocus_section_scalar_tower` or `lem:composite_immersion_flocus_basicOpen`. Writer directive (soon): add `\lean{}` hints to all three.
- **Correct**: true (for the portions covered).
- QUOT-defs consumers (annihilator, P2) frontier — declared ready by STRATEGY.md; prover can be dispatched to the annihilator lane specifically (it doesn't depend on the 3 gap nodes if the gap nodes aren't on its chain).

### `Picard_RelativeSpec.tex`
- **Complete**: partial (stub/thin chapter, 438 lines, ~13 declaration blocks). Adequate for the BLOCKED phase. No active prover dispatch gated on it.
- **Correct**: true.

---

## Severity summary

- **must-fix (writer directive this iter)**:
  - `Picard_FlatteningStratification.tex`: B1 `lem:gf_flat_localizedModule_sameBase` — add `\uses{}` on proof block naming the commutation iso (new anchor or Mathlib name).
  - `Picard_FlatteningStratification.tex`: assembly proof — add explicit sentence about (M_j)_{ḡ} = LocalizedModule(powers ḡ)(M_j)_f via f invertibility.
  - `Picard_GrassmannianQuot.tex`: `def:gr_universal_quotient_sheaf` — add `lem:gr_glueData_bridges` to `\uses{}` (wire-up).
- **soon (next iter writer task)**:
  - `Picard_SectionGradedRing.tex`: add Mathlib anchor for "J.W monoidal for ⊗_ℤ" with `\uses{}` in `lem:isIso_sheafification_whiskerRight_unit`.
  - `Picard_QuotScheme.tex`: add `\lean{}` hints to 3 gap nodes.
  - `Picard_FlatteningStratification.tex`: cleanup dead-route G3.2/G3.3/G3.4 (orphaned from main chain; not blocking).

---

## Unstarted-phase proposals

All strategy phases have adequate blueprint coverage (≥ 3 meaningful declaration blocks). No new chapter proposals required this iter.
