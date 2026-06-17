# Blueprint Review Report

## Slug
iter061

## Iteration
061

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:compCoyonedaIso_mathlib`: isolated (no `\uses` out,
  nothing uses it). Reading the proof of `lem:jshriek_transport_along_iso` (lines 9647–9664) reveals it
  is explicitly invoked at step (1) of the coyoneda-transport chain. Missing from the proof's
  `\uses{def:jshriek_ou, lem:sectionsFunctorCorepIso}`. **wire-up** — add
  `lem:compCoyonedaIso_mathlib` to the proof `\uses`. (Node is `\mathlibok`; Mathlib declaration
  `CategoryTheory.Adjunction.compCoyonedaIso` verifiably exists.)

- `Cohomology_CechHigherDirectImage.tex` / `lem:coyoneda_fullyFaithful_mathlib`: same situation — used
  twice in the same proof (lines 9639–9640 and 9664) but absent from `\uses`. **wire-up** — add
  `lem:coyoneda_fullyFaithful_mathlib` to the proof `\uses`. (Mathlib declaration
  `CategoryTheory.Coyoneda.fullyFaithful` exists.)

  Both wire-ups target the already-`\leanok` lemma `lem:jshriek_transport_along_iso`. Not on any active
  prover lane this iter — **soon**, not must-fix.

- `lean_aux` isolated node (1): standard uncovered Lean helper, no blueprint entry needed. **keep**.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: true
- **correct**: true
- **notes**:

  #### Lane 1 (CSI Stub 2) focused audit

  **`lem:isIso_modules_of_toPresheaf` (L1 — reflection wrapper)**

  - Present at line 8007, no `\leanok` (expected: build target). `\lean{AlgebraicGeometry.isIso_modules_of_toPresheaf}` unmatched (expected).
  - Statement: if `toPresheaf φ` is an iso of presheaves-of-abelian-groups, then `φ` is an iso in `X.Modules`. Mathematically sound.
  - Proof: invokes fully-faithfulness of the forgetful functor chain (`lem:forget_reflectsIso_mathlib`). One step, correctly specified.
  - `\uses{lem:forget_reflectsIso_mathlib}` resolves. `lem:forget_reflectsIso_mathlib` → `SheafOfModules.fullyFaithfulForget` is `\mathlibok`. Declaration verified present in Mathlib (used by earlier `\leanok` lemmas).
  - **Verdict: complete + correct. Gate clears for Lane 1.**

  **`lem:pushPull_binary_coprod_prod` (L2 — binary disjoint-union base)**

  - Present at line 8028, no `\leanok`. `\lean{AlgebraicGeometry.pushPull_binary_coprod_prod}` unmatched (build target).
  - Statement: `pushPullObj F (Over.mk (coprod.desc Y₀.hom Y₁.hom)) ≅ pushPullObj F Y₀ × pushPullObj F Y₁`. Mathematically sound.
  - Proof: reduces to sections over each open `V` via `lem:isIso_modules_of_toPresheaf`; uses `lem:coprodPresheafObjIso_mathlib` and `lem:isProductOfDisjoint_mathlib` to split the coproduct-preimage into two disjoint traces; concludes by `lem:evaluation_preserves_products_mathlib`.
  - `\uses{def:push_pull_obj, lem:isIso_modules_of_toPresheaf, lem:coprodPresheafObjIso_mathlib, lem:isProductOfDisjoint_mathlib, lem:evaluation_preserves_products_mathlib}` — all resolve (unknown_uses: []).
  - Mathlib anchors verified via loogle:
    - `AlgebraicGeometry.Scheme.coprodPresheafObjIso` ✓ (Mathlib.AlgebraicGeometry.Limits)
    - `TopCat.Sheaf.isProductOfDisjoint` ✓ (Mathlib.Topology.Sheaves.SheafCondition.PairwiseIntersections)
    - `SheafOfModules.evaluationPreservesLimitsOfShape` ✓ (Mathlib.Algebra.Category.ModuleCat.Sheaf.Limits)
  - Note: `lem:coprodPresheafObjIso_mathlib` is specifically for the structure sheaf; the working sheaf-decomposition for module sheaves is `lem:isProductOfDisjoint_mathlib`. Both are cited; combination is sound.
  - **Verdict: complete + correct. Gate clears.**

  **`lem:pushPull_coprod_prod` (finite-index induction)**

  - Present at line 8078, no `\leanok`. `\lean{AlgebraicGeometry.pushPull_coprod_prod}` unmatched (build target).
  - Statement: `pushPullObj F (Over.mk (Sigma.desc ...)) ≅ ∏_i pushPullObj F (legs i)` for finite `ι`. Mathematically sound.
  - Proof: induction on cardinality of `ι`.
    - Empty base: initial scheme → terminal object = empty product; checked on sections via `lem:isIso_modules_of_toPresheaf`. ✓
    - Inductive step: reassociate `ι ≃ {*} ⊔ ι'`; apply `lem:pushPull_binary_coprod_prod` then induction hypothesis. ✓
  - `\uses{def:push_pull_obj, lem:isIso_modules_of_toPresheaf, lem:pushPull_binary_coprod_prod}` — all resolve.
  - Induction terminates: strictly decreasing cardinality. No circularity with L2.
  - **Verdict: complete + correct. Gate clears.**

  **`lem:pushPull_sigma_iso` (specialization to backbone)**

  - Present at line 8129, **already `\leanok`**. Lean declaration `AlgebraicGeometry.pushPull_sigma_iso` exists.
  - Statement: `pushPullObj F Yₚ ≅ ∏_σ pushPullObj F (Over.mk j_σ)` (backbone degree-p decomposition).
  - Proof: applies `lem:pushPull_coprod_prod` to the coproduct structure produced by `lem:cech_backbone_left_sigma`. One-line.
  - `\uses{def:push_pull_obj, lem:cech_backbone_left_sigma, lem:pushPull_coprod_prod}` — all resolve.
  - **The Lane 1 chain is mathematically complete and non-circular**. L3 uses only L2 and `lem:isIso_modules_of_toPresheaf`; L4 uses only L3 and `lem:cech_backbone_left_sigma` (already proven). No back-edges.

  #### Lane 2 (OpenImm hqc) focused audit

  **`lem:isQuasicoherent_of_coversTop_mathlib` (supporting anchor)**

  - Present at line 9670. `\mathlibok`, `\lean{SheafOfModules.IsQuasicoherent.of_coversTop}`.
  - Verified in Mathlib via loogle: `SheafOfModules.IsQuasicoherent.of_coversTop` ✓ (Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent). Type matches: given `I → C`, `J.CoversTop`, and `(M.over (X i)).IsQuasicoherent` for all `i`, concludes `M.IsQuasicoherent`. ✓
  - `lem:nonempty_quasicoherentData_mathlib` → `SheafOfModules.IsQuasicoherent.nonempty_quasicoherentData` verified ✓.

  **`lem:pushforwardPushforwardEquivalence_mathlib` (supporting anchor)**

  - Present at line 3962. `\mathlibok`, `\lean{SheafOfModules.pushforwardPushforwardEquivalence}`.
  - Used by already-`\leanok` lemmas; considered verified.

  **`lem:pushforward_commutes_restriction`**

  - Present at line 9690, no `\leanok`. Has `% NOTE: build target`. `\lean{AlgebraicGeometry.pushforward_commutes_restriction}` unmatched (build target).
  - Statement: for `φ : X ≅ Y`, `Φ = pushforwardEquivOfIso φ`, open `V ⊆ X`, image `V' = φ.inv⁻¹V`, the comparison `e.functor.obj (H.over V) ≅ (Φ.functor.obj H).over V'`. Sound.
  - Proof: section-by-section on opens `W ⊆ V'`; right-hand side sections = sections of `H` over `φ.hom⁻¹W = W₀` (by pushforward def); left-hand side = same (site-equivalence `e` relabels `W` to `W₀` and reads `H.over V`). Morphism is iso on every section group.
  - `\uses{lem:pushforwardPushforwardEquivalence_mathlib, lem:restrict_obj_mathlib}` — all resolve.
  - **Verdict: complete + correct. Gate clears.**

  **`lem:pushforward_iso_preserves_qcoh`**

  - Present at line 9732, no `\leanok`. Has `% NOTE: build target`. `\lean{AlgebraicGeometry.pushforward_iso_preserves_qcoh}` unmatched (build target).
  - Statement: `φ : X ≅ Y`, `H` qcoh → `Φ.functor.obj H` qcoh.
  - Proof strategy:
    1. Extract `H`'s quasi-coherence datum (cover `(U_i)_i` + presentations) via `lem:nonempty_quasicoherentData_mathlib`. ✓
    2. Form image cover `V_i = φ.inv⁻¹ U_i`. ✓
    3. For each `i`, use `lem:pushforward_commutes_restriction` to get `e_i.functor.obj (H.over U_i) ≅ (Φ.functor.obj H).over V_i`. ✓
    4. Use `lem:presentation_map_mathlib` to transport presentation of `H.over U_i` to `e_i.functor.obj (H.over U_i)`. ✓
    5. Use `lem:presentation_ofIsIso_mathlib` to carry that presentation to `(Φ.functor.obj H).over V_i`. ✓
    6. Each member quasi-coherent → whole sheaf quasi-coherent by `lem:isQuasicoherent_of_coversTop_mathlib`. ✓
  - `\uses{lem:pushforward_commutes_restriction, lem:pushforwardPushforwardEquivalence_mathlib, lem:presentation_map_mathlib, lem:isQuasicoherent_of_coversTop_mathlib, lem:nonempty_quasicoherentData_mathlib, lem:presentation_ofIsIso_mathlib, lem:isAffineOpen_image_of_iso_mathlib}` — all resolve (unknown_uses: []).
  - The `lem:isAffineOpen_image_of_iso_mathlib` is cited for "the image of an affine open under a scheme iso is affine" when maintaining affine cover membership. This is a secondary detail; the core argument doesn't require it (affine-ness of covers is only needed if the prover wants the cover to remain affine for qcoh). The block is correctly complete for either affineness or non-affine coverage.
  - **Verdict: complete + correct. Gate clears.**

  #### Rendering

  Blueprint doctor reports clean: no orphan chapters, broken refs, malformed_refs (undefined macros, math-delim, literal-ref, bare-label), axiom declarations, or covers problems.

  #### leandag global

  - `unknown_uses: []` — zero broken `\uses{}` references across the whole blueprint. ✓
  - `unmatched_lean`: 79 nodes. Of these, the 5 unmatched build targets for Lane 1/2 are expected (pre-formalization). The remaining unmatched entries are `\mathlibok` anchors not scanned in project Lean files; this is the normal state for Mathlib-backed declarations and does not indicate breakage.
  - Isolated: 3 (2 blueprint — `lem:compCoyonedaIso_mathlib`, `lem:coyoneda_fullyFaithful_mathlib`; 1 lean_aux). The two blueprint-isolated nodes have wire-up dispositions (see Dependency & isolation findings above); they do not affect the active lanes.

## Severity summary

- **must-fix-this-iter**: none.
- **soon** (2 items):
  - `Cohomology_CechHigherDirectImage.tex` / `lem:jshriek_transport_along_iso` proof `\uses`: missing `lem:compCoyonedaIso_mathlib` and `lem:coyoneda_fullyFaithful_mathlib` (wire-up; those two are the isolated blueprint nodes). Dispatch blueprint-writer to add both to the proof `\uses{}` block. Not on an active prover lane.

Overall verdict: The consolidated chapter `Cohomology_CechHigherDirectImage.tex` is **complete and correct**; the HARD GATE clears for both Lane 1 (CSI Stub 2 chain: L1–L4 blocks present, all `\uses{}` resolve, Mathlib anchors verified, induction sound, no circularity) and Lane 2 (OpenImm hqc: both `lem:pushforward_commutes_restriction` and `lem:pushforward_iso_preserves_qcoh` complete with verified supporting anchors). Zero must-fix findings. Two soon-severity wire-up items on an already-`\leanok` lemma not in any active lane. No unstarted phases.
