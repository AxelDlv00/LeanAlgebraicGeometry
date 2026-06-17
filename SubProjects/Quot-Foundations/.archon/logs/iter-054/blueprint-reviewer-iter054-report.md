# Blueprint review — iter-054

**Date:** 2026-06-10  
**Reviewer:** blueprint-reviewer subagent  
**Scope:** whole-blueprint audit; HARD GATE focus on three edited chapters

---

## 1. Tool runs

### archon blueprint-doctor --json
**CLEAN.**  
- `malformed_refs`: 0  
- `broken_refs`: 0  
- `orphan_chapters`: 0  
- `axiom_decls`: 0  
- `covers_problems`: 0  
- `labels_defined_count`: 577  
All 8 chapters present and included in `content.tex`.

### leandag stats
```
Blueprint nodes        531
Lean-aux nodes           6
Edges                 1170
Proved (leanok)        404  (76.1%)
Mathlib-backed          92
With sorry              14
Ready to formalize      11
Needs \lean{}            3
Needs \leanok            7
Unmatched \lean{}        0
Axioms (dep=0)         156
Leaves (rdep=0)         50
Isolated (no edges)      7  (1 blueprint, 6 lean_aux)
Done (Lean chars)    412,484
Remaining (≥)         83,481
```

### leandag show isolated
- **1 blueprint isolated node:** `lem:mathlib_flat_of_localized_maximal`
  - Chapter: `Picard_FlatteningStratification.tex`
  - 0 in-edges, 0 out-edges, 0 effort, unproved
  - This is the **dead stalk-route flatness criterion** (`Module.flat_of_localized_maximal`). It is mentioned only in a comparison footnote in the B2.2 prose ("unlike `lem:mathlib_flat_of_localized_maximal`…") but carries no `\uses{}` edges.
  - **Disposition: REMOVE.** The stalk route is dead per STRATEGY.md. No prover lane references it. Its sibling `lem:mathlib_flat_of_isLocalized_maximal` (the stalk-route *criterion* — also dead) is used only by `gf_stalk_flat_over_base` / `gf_stalk_flat_localBase`, which themselves are stranded dead-route nodes. The footnote comparison is the only surviving trace.
  - **Action for prover lane:** no action needed (none of the live B2 → G3 chain depends on it). Blueprint writer should remove in next pass.
- **6 lean_aux isolated nodes:** all proved (`✓`), 0 effort — library-level orphans, no action needed.

### leandag show gaps
3 unproved blueprint nodes with effort > 0 and no `\mathlibok`:
```
lem:composite_basic_open_immersion_isOpenImmersion  (QuotScheme, effort 816, impact 20)
lem:gamma_pullback_image_iso                        (QuotScheme, effort 743, impact 19)
lem:flocus_section_scalar_tower                     (QuotScheme, effort 693, impact 19)
```
All three are in the QUOT lane, already tracked as open items (gap-related helpers). Not in current iter's critical path. No blueprint action needed now.

---

## 2. Focus chapters — HARD GATE verdicts

### 2.1 `Picard_FlatteningStratification.tex`

**Verdict: COMPLETE ✓ | CORRECT ✓ | HARD GATE: CLEARED**

#### B2 chain (new this iter)

| Label | Mathlib anchor | Stated |
|---|---|---|
| `lem:gf_crossChart_basicOpen_eq` (B2.1) | `Scheme.basicOpen_res` | D(g) = D(ḡ) under cross-chart match |
| `lem:gf_section_localization_twoleg` (B2.2) | — | Section-localization identity Γ(W,M)[1/g] ≅ Γ(W_j,M)[1/ḡ] |
| `lem:gf_base_localization_comparison` (B2.3) | — | Source-ring localization agrees with target-ring localization |
| `lem:gf_section_localization_flat_descent` (B2 assembly) | — | Flat descent along the two-leg comparison |
| `lem:gf_crossChart_spanning_cover` (B2.4) | — | Cross-chart basic opens span the cover |
| `lem:gf_flat_locality_assembly` (G3) | `mathlib_flat_of_isLocalized_span` | Final assembly: generic flatness |

**Q: Is the matched-pair (g, ḡ) treatment of B2.1/B2.2 mathematically sound?**

**YES.** The blueprint correctly identifies and addresses the subtlety: the bare image of `g ∈ Γ(X,W)` in `Bⱼ` does NOT automatically give `D(g) = D(ḡ)` over the overlap, because sections from different charts can agree on stalks without cutting out the same basic open over the full intersection. B2.1 (`gf_crossChart_basicOpen_eq`) takes two explicit hypotheses:
1. `g|_O = ḡ|_O` (sections agree over the overlap O = W ∩ Wⱼ), AND
2. `D(g) ≤ O` and `D(ḡ) ≤ O` (both basic opens are contained in the overlap)

Under these hypotheses the equality `D(g) = D(ḡ)` (as subsets of X, equivalently as subschemes of O) follows from `Scheme.basicOpen_res` (the Mathlib anchor at `lem:mathlib_scheme_basicOpen_res`): restricting both sides to O and using the section equality yields the identity. The statement is tight — without the containment hypotheses the equality is false in general. Sound.

B2.2 (`gf_section_localization_twoleg`) then takes this as a datum (`hḡ : X.basicOpen g = X.basicOpen ḡ`) and produces the iso `Γ(W,M)[1/g] ≅ Γ(Wⱼ,M)[1/ḡ]` via transport along the basic-open equality + quasi-coherence. Sound.

**Q: Does `gf_flat_locality_assembly` correctly consume the new chain?**

**YES.** The `\uses{}` list of `lem:gf_flat_locality_assembly` is:
```
gf_patch_free_imp_flat
gf_flat_localizedModule_sameBase
gf_section_localization_flat_descent      ← B2 assembly
gf_crossChart_spanning_cover              ← B2.4
mathlib_flat_of_isLocalized_span          ← Mathlib span criterion
mathlib_flat_localization_preserves
mathlib_flat_of_free
gf_qcoh_fintype_finite_sections           ← GF-G1 (DONE)
qcoh_section_localization_basicOpen
```
The proof text feeds the span cover (B2.4) + section-localization flatness (B2 descent) into `Module.flat_of_isLocalized_span`. The `gf_flat_localizedModule_sameBase` provides the same-base localization identity needed to convert the cross-chart iso into the form the span criterion expects. No missing edge. Chain is correct.

**Mathlib anchor `lem:mathlib_scheme_basicOpen_res` → `AlgebraicGeometry.Scheme.basicOpen_res`:**
Verified real Mathlib declaration. States that for an open immersion `i : U → X` and `f : X.presheaf U`, `(i^* X).basicOpen (X.presheaf.map i.op f) = X.basicOpen f ∩ U`. Exactly what B2.1 needs.

**Dead stalk-route nodes still in chapter:** `gf_stalk_flat_over_base` (G3.2) and `gf_stalk_flat_localBase` (G3.4) are present but are not in the `\uses{}` chain of any live assembly lemma. They are benign (no broken edges, no impact on the live path). The isolated `lem:mathlib_flat_of_localized_maximal` anchor (see §1) is the only actionable cleanup item.

**No must-fix items for iter-055 prover.**

---

### 2.2 `Picard_GrassmannianQuot.tex`

**Verdict: COMPLETE ✓ | CORRECT ✓ | HARD GATE: CLEARED**

Chapter has 21 nodes, 13 `\leanok`. The two new coherence lemmas are both unproved (expected — they are the prover's target this iter).

**Q: Is the `gr_pullbackObjUnitToUnit_id` / `_comp` coherence block well-posed and formalizable?**

**YES.**

`lem:gr_pullbackObjUnitToUnit_id` (line 707–727):
- Statement: for `id_T`, the comparison morphism `id_T* 1 → 1` (the map underlying the free-pullback iso at a 1-element index) equals the `1`-component of the pullback-identity isomorphism `id_T* ≅ id`.
- Proof sketch: mate under pullback–pushforward adjunction; for identity the pushforward is the identity functor so the adjunction unit is itself an identity; the pullback-identity iso is the conjugate transpose of the pushforward-identity iso; tracing through gives equality.
- **Formalizability:** well-posed. Both the comparison morphism and the pullback-identity component live in the same hom-set; the proof is a mate calculation that Lean's `CategoryTheory.Adjunction.mate` API handles. Concrete Lean target: `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_id`.

`lem:gr_pullbackObjUnitToUnit_comp` (line 730–747):
- Statement: for composable `a : T'' → T'`, `b : T' → T`, the comparison `(b∘a)*1 → 1` factors as `a*(b's comparison) ≫ (a's comparison) ≫ (pullbackComp component at 1)`.
- Proof sketch: mate is compatible with composition of adjunctions; pentagon coherence of iterated-pullback comparisons (`def:modules_pullbackComp`, `\mathlibok` → `AlgebraicGeometry.Scheme.Modules.pullbackComp`) makes the factorisation well-defined.
- **Formalizability:** well-posed. The `\uses{}` correctly lists both `lem:gr_pullbackObjUnitToUnit_id` and `def:modules_pullbackComp`. The pentagon coherence is a Mathlib pseudofunctor law. Concrete Lean target: `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp`.

Together these two coherences unlock `def:grassmannian_functor` (already `\leanok` provisionally — its `\uses{}` lists both coherence lemmas) and transitively unblock the remaining functor-build work.

**No must-fix items.**

---

### 2.3 `Picard_SectionGradedRing.tex`

**Verdict: COMPLETE ✓ | CORRECT ✓ | HARD GATE: CLEARED**

Chapter has ~20 `\leanok` markers.

**Q: Is the promotion proof detailed enough to formalize?**

**YES.** The rewritten `lem:relativeTensor_as_coequalizer` proof is structured as 3 explicit steps:

1. **Objectwise step:** `lem:relativeTensor_objectwise_coequalizer` (already `\leanok`) gives `isColimitCofork` for each `U`. All constituent declarations (`isColimitCofork`, `actN`, `actM`, `actLmap`, `actRmap`, `projL`, `piMor`, `coeq_condition`, `cofork`, `descHom`, `descMor`, `descFac`) are named in `\lean{}` hints and the objectwise lemma is proved.

2. **Functor-category promotion:** `CategoryTheory.Limits.evaluationJointlyReflectsColimits` lifts the objectwise colimit to a colimit in the functor category `Cᵒᵖ ⥤ AddCommGrpCat`. This step is explicit in the proof text: "apply `evaluationJointlyReflectsColimits` to promote the objectwise colimit data".

3. **Apex identification:** `PresheafOfModules.Monoidal.tensorObj_obj` establishes the canonical identification `(M ⊗ N).obj U = M.obj U ⊗[S.obj U] N.obj U` that matches the functor-category colimit apex to the concrete tensor product presheaf. The proof uses this to complete the iso.

The proof is granular enough: each step has a named Mathlib anchor, the transition between objectwise data and the functor-category result is explicit, and the apex identification is spelled out. A prover can formalize this without further decomposition.

**Q: Do the `\mathlibok` anchors name real Mathlib decls?**

| Anchor label | Lean name | Status |
|---|---|---|
| `lem:mathlib_tensorProduct_liftAddHom` | `TensorProduct.liftAddHom` | ✓ REAL |
| `lem:mathlib_evaluationJointlyReflectsColimits` | `CategoryTheory.Limits.evaluationJointlyReflectsColimits` | ✓ REAL |
| `lem:mathlib_tensorObj_obj` | `PresheafOfModules.Monoidal.tensorObj_obj` | ✓ REAL |

All three are verified real Mathlib declarations.

**Minor note (non-blocking):** The proof of `lem:isIso_sheafification_whiskerRight_unit` invokes "J.W is monoidal for ℤ-tensor". This is a non-trivial claim (the class of local-isomorphisms is monoidal for the tensor product of sheaves of modules over a fixed base ring). It is mathematically sound — it follows from the fact that ℤ-flatness is preserved by the localization functor and the unit of sheafification is an iso on representable sheaves — but the proof text does not spell it out. This is a **soft flag** (not a blocker for the SNAP prover, which is working on the tensor-coequalizer piece, not the sheafification-unit piece), but a blueprint writer pass should add 1–2 sentences justifying the monoidal claim before that lemma is formalized.

---

## 3. Remaining chapters (standard audit)

### `Cohomology_FlatBaseChange.tex`
- 82 `\leanok` markers; partial read (≈1375 lines read of large file)
- All read nodes: `\leanok` or `\mathlibok`. No `\uses{}` broken edges (leandag: unknown_uses = []).
- FBC lane: `_legs_conj` keystone still unproved (known open item, per memory); no new blueprint gaps introduced this iter.
- **Verdict: no must-fix items from blueprint perspective.**

### `Cohomology_RegroupHelper.tex`
- 77 lines, 2 `\leanok` markers, 1 node (`lem:base_change_regroup_linearEquiv`). Clean.
- **Verdict: COMPLETE ✓ | CORRECT ✓**

### `Picard_GrassmannianCells.tex`
- 155 `\leanok` markers. Large chapter (≥2700 lines). All properness/existence arc nodes `\leanok` per prior audit (iter-052/053 confirmed E1–E5, `gr_proper`, existence lift chain all axiom-clean).
- No new edits this iter. Prior iter's verdict holds.
- **Verdict: no must-fix items.**

### `Picard_QuotScheme.tex`
- 167 `\leanok` markers. 3 gap nodes (see §1): `lem:composite_basic_open_immersion_isOpenImmersion`, `lem:gamma_pullback_image_iso`, `lem:flocus_section_scalar_tower`. These are tracked open items in the QUOT lane, not new regressions.
- `def:hilbert_polynomial`, `lem:gradedHilbertSerre_rational`, and GradedHilbertSerre chain all `\leanok`.
- **Verdict: no must-fix items for iter-055 (gap nodes are longer-range QUOT work).**

### `Picard_RelativeSpec.tex`
- 438 lines, 9 node markers. All major theorems `\leanok`: `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base`.
- **Verdict: COMPLETE ✓ | CORRECT ✓**

---

## 4. Unstarted-phase proposals

**None.** All active phases per STRATEGY.md (GF-geo, SNAP, QUOT-repr, FBC, GR-quot) have adequate blueprint coverage for their current iter scope:
- GF-geo: B2 chain + G3 assembly now fully specified (this iter's contribution)
- SNAP: objectwise coequalizer (DONE) + promotion proof (detailed, this iter) cover the iter-055 target
- GR-quot: coherence lemmas (this iter) cover the functor-build target
- FBC: `_legs_conj` remains open in the blueprint (adequately specified, prover is working it)
- QUOT: gap nodes are tracked; no new blueprint coverage needed for iter-055

---

## 5. Severity summary

| Severity | Item | Chapter | Action |
|---|---|---|---|
| LOW (cleanup) | Remove isolated node `lem:mathlib_flat_of_localized_maximal` | FlatteningStratification | Blueprint writer next pass |
| LOW (soft flag) | Justify "J.W monoidal for ℤ-tensor" in `lem:isIso_sheafification_whiskerRight_unit` | SectionGradedRing | Blueprint writer next pass |

**No MUST-FIX items blocking iter-055 prover work.**

---

## 6. HARD GATE summary

| Chapter | Complete | Correct | Gate |
|---|---|---|---|
| `Picard_FlatteningStratification.tex` | ✓ | ✓ | **CLEARED** |
| `Picard_GrassmannianQuot.tex` | ✓ | ✓ | **CLEARED** |
| `Picard_SectionGradedRing.tex` | ✓ | ✓ | **CLEARED** |

All three focus chapters are complete and correct. Prover lanes (GF-geo fine-grained, GR-quot functor build, SNAP promotion) are unblocked.
