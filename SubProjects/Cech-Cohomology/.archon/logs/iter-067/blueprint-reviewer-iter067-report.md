# Blueprint Review Report

## Slug
iter067

## Iteration
067

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:mapHC_augment_iso` → zero DAG edges. The lemma appears in the **proof** `\uses{}` of `lem:cechSection_complex_iso` but NOT its **statement** `\uses{}`. Additionally, the statement block of `lem:mapHC_augment_iso` itself has no `\uses{}` (the dependency on `lem:map_augment_cond` is only in the proof `\uses{}`). **wire-up**: (a) add `lem:mapHC_augment_iso, lem:map_augment_cond, lem:augmentCochainIso` to the statement `\uses{}` of `lem:cechSection_complex_iso`; (b) add `\uses{lem:map_augment_cond}` to the statement block of `lem:mapHC_augment_iso`.

- `Cohomology_CechHigherDirectImage.tex` / `lem:map_augment_cond` → zero DAG edges. No statement `\uses{}` on either its own block or `lem:cechSection_complex_iso`. **wire-up** as part of (a) above.

- `Cohomology_CechHigherDirectImage.tex` / `lem:augmentCochainIso` → zero DAG edges. Not in statement `\uses{}` of `lem:cechSection_complex_iso`. **wire-up** as part of (a) above.

- `Cohomology_CechHigherDirectImage.tex` / `lem:pullbackObjUnitToUnit_mathlib` → zero DAG edges. It is a `\mathlibok` anchor; the surrounding prose (line ~10904) explicitly states "pullbackObjUnitToUnit is NOT used" in the enclosing proof. **keep** — intentionally documented but not consumed.

- `lean:AlgebraicGeometry.CechAcyclic.affine` → `lean_aux` isolated node (uncovered Lean helper, dead sorry stub). Blueprint comment at line 1347 explicitly notes this is "a dead placeholder" subsumed by the `cechAugmented_exact` route; it is "NOT a live obligation". **keep** — intentionally inactive.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **Missing statement-level `\uses{}` edges on three augmentation helpers (must-fix).** `lem:mapHC_augment_iso`, `lem:map_augment_cond`, and `lem:augmentCochainIso` (all new, added this iter, already sorry-free in Lean) are listed only in the **proof** `\uses{}` block of `lem:cechSection_complex_iso` (lines 8855–8858), not its **statement** `\uses{}` block (lines 8821–8824). leandag builds edges only from statement-level `\uses{}`, so all three helpers are isolated in the DAG (leandag confirmed: 0 in-edges, 0 out-edges each). Two-part fix: (a) add `lem:mapHC_augment_iso`, `lem:map_augment_cond`, `lem:augmentCochainIso` to the statement `\uses{}` of `lem:cechSection_complex_iso`; (b) add `\uses{lem:map_augment_cond}` to the statement block of `lem:mapHC_augment_iso` (the proof block already has it; the statement block prose cites `lem:map_augment_cond` inline but no `\uses{}` directive).

## Gate question answers (CechSectionIdentification.lean prover lane)

**Are the three new `coreIso` sub-lemma statements well-formed and formalizable, with accurate `\uses{}`?**

Yes. All three are well-formed and individually formalizable:

- `lem:coverInterOpen_inf_distrib` (`coverInterOpen_inf_eq_iInf_inf`): states that `coverInterOpen 𝒰 σ ∩ V = ⋂_k (coverOpen 𝒰 (σ k) ∩ V)`, proved by frame distributivity of binary meet over a nonempty indexed meet. Proof is one lemma application away from completion. `\uses{def:cech_free_presheaf_complex}` is appropriate; connected in the DAG ✓.

- `lem:coreIso_obj_iso` (`coreIso_objIso`): the degree-p object iso between the evaluated push-pull backbone and the concrete restricted section Čech complex. Proof: compose `lem:pushPull_eval_prod_iso` with the factorwise `eqToIso` from `lem:coverInterOpen_inf_distrib`. `\uses{lem:pushPull_eval_prod_iso, lem:coverInterOpen_inf_distrib}` is correct; connected in the DAG ✓.

- `lem:coreIso_comm` (`coreIso_comm`): the differential-match square making the degreewise isos into a complex iso. `\uses{lem:coreIso_obj_iso, lem:section_cech_objd_apply, lem:section_cech_product_equiv, lem:coverInterOpen_inf_distrib}` is correct and complete; connected in the DAG ✓. See below for proof-sketch adequacy.

**Is the `lem:coreIso_comm` proof sketch detailed enough?**

Adequate for formalization. The sketch (lines 8779–8807):
1. Unpacks the section-Čech differential via `sectionCechProductEquiv` (citing `lem:section_cech_objd_apply`) as the alternating sum of face-restriction maps `sectionCechFaceRestr(σ, i)`.
2. States that the evaluated backbone differential is the evaluation at V of the Čech-nerve coface maps.
3. Claims that under the degreewise identification (`lem:coreIso_obj_iso` + `lem:coverInterOpen_inf_distrib`) "each coface of (G_V ∘ Ψ)Č(U) becomes the corresponding presheaf face restriction, because both are induced by the same inclusion of intersection opens ⋂_k(coverOpen(σk)∩V)."
4. Explicitly handles the degree-0 compatibility datum `hcompat` as the `p=0` instance (folding it into this lemma).

The key claim in step 3 — "induced by the same inclusion" — requires the prover to unfold both restriction maps and show they are induced by the same geometric open immersion (hence equal up to `eqToIso` from the open-meet identity). This is straightforward but non-trivial to write; the sketch gives sufficient guidance. The fact that `hcompat` is folded into the `p=0` case is noted clearly at lines 8799–8806, eliminating the separate `have hcompat : ...` sorry in the current Lean file.

**Is `lem:cechSection_contractible` adequate?**

Yes. The block (lines 8927–9007) is well-specified with correct Lean target (`Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0`). The two-part proof:
- Positive Čech degrees: the dep* engine (`depHomotopy`, `depHomotopy_spec`, `depDiff_exact` from `lem:cech_acyclic_affine`) supplies the prepend-`i_fix` homotopy.
- Augmentation node (degree 0): the projection `π_{i_fix}` is identified explicitly; the identity `(ε ∘ π_{i_fix} + degree-0 engine term)(s)_j = s_j` is spelled out in full at lines 8998–9007.

The augmentation node calculation is the non-trivial piece. It is stated clearly enough for formalization.

**Any broken `\uses{}` introduced by the new blocks?**

No broken `\uses{}` (references to nonexistent labels). The only issue is the reverse: labels that EXIST but are not yet listed in statement `\uses{}` (the wire-up issue above). `leandag build --json` reports 0 conflicts and `archon blueprint-doctor --json` reports `"malformed_refs": []`.

**Does the gate clear?**

**Gate DOES NOT CLEAR as-is.** The consolidated chapter is `correct: partial` due to the three isolated augmentation-helper nodes. Per the hard-gate rule, `correct: partial` on the consolidated chapter defers all files it covers until a writer applies the fix. The fix is narrow — add 3-4 `\uses{}` entries — and the same-iter fast path applies: dispatch a blueprint-writer for the 4-line fix, then a scoped re-review, then the prover.

## Severity summary

### must-fix-this-iter
- **wire-up** `lem:mapHC_augment_iso`, `lem:map_augment_cond`, `lem:augmentCochainIso` into the statement `\uses{}` of `lem:cechSection_complex_iso`, and add `\uses{lem:map_augment_cond}` to the statement of `lem:mapHC_augment_iso`. Blocking: `correct: partial` on the consolidated chapter → hard gate does not clear for `CechSectionIdentification.lean`. Fix is 4-line blueprint-writer directive; same-iter fast path available.

### informational
- `lem:pullbackObjUnitToUnit_mathlib` is isolated (`\mathlibok` anchor, explicitly noted as unused in the surrounding proof text). No action needed unless cleanup desired.
- `lean:AlgebraicGeometry.CechAcyclic.affine` lean_aux node is isolated and intentionally dead (blueprint comment documents this). No action needed.

Overall verdict: The consolidated chapter's content is mathematically complete and correct for the `CechSectionIdentification.lean` prover lane; proof sketches are adequate for formalization. Gate blocked by 3 missing statement-level `\uses{}` edges (augmentation helpers isolated in DAG); 1 must-fix-this-iter finding requiring a narrow 4-line blueprint-writer patch before the prover dispatches.
