# Blueprint Review Report

## Slug
ts244

## Iteration
244

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_lan_decomposition` (D1 sub-lemma): no `\lean{...}` hint. The prover must self-name this intermediate declaration. Not a hard gate blocker (the parent `lem:pullback_tensor_iso` has its Lean target named), but the absence means the D1 bridge will arrive under a prover-chosen name with no blueprint anchor.

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_lan_decomposition`: No `\lean{...}` hint. Prover must invent the Lean name for the pushforward-factorization / pullback-decomposition sub-lemma; the parent chain refers to it by blueprint label only.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
*(Pointer chapter only; mathematical content lives in RigidityKbar.tex.)*

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:IsLocallyTrivial_pullback` (`\label{lem:IsLocallyTrivial_pullback}`, `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.pullback}`) is **orphaned project-wide** after the re-route of `lem:isinvertible_pullback`. No other chapter references it via `\uses{}`, `\cref{}`, or `\ref{}` anywhere in `blueprint/src/`. The label, Lean target, and proof body remain valid standalone (the lemma is mathematically correct and Lean-closed per the `\leanok` marker), but no blueprint node depends on it. Flag for plan agent: can demote to a `\% NOTE` or retain as a standalone infrastructure lemma; does not block any active prover.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:

  **Gate-relevant section `sec:tensorobj_pullback_monoidality` — detailed verdict:**

  **`lem:pullback_tensor_iso` (committed build target).**
  D1–D4 decomposition is present, detailed, and mathematically correct:
  - D1 (decomposition): pushforward factors as `pushforward₀ F R ∘ restrictScalars φ`; taking left adjoints reverses the composite, yielding `pullback φ ≅ extendScalars φ ⋙ pullback₀`. Correct.
  - D2 (scalar half strong, free): `extendScalars` is strong monoidal via `TensorProduct.AlgebraTensorModule.distribBaseChange`, so `δ` is iso iff `δ₀` is iso. Correct.
  - D3 (topological half — genuine build): `pullback₀ = Lan (Opens.map f.base).op`. Pointwise: `pullback₀(M ⊗ N)(V) = colim_{(F↓V)} (M(U) ⊗ N(U))`. The comma category `(F↓V) = {U : f⁻¹V ⊆ U}` is up-directed (hence filtered), so the diagonal `(F↓V) → (F↓V) × (F↓V)` is final, and tensor commutes with the filtered colimit — `δ₀` is an isomorphism. Mathematically correct.
  - D4 (sheafify + transport): sheafification monoidality brick `sheafifyTensorUnitIso` + `Adjunction.leftAdjointUniq` transport to the abstract pullback. Correct.
  - Lean target `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}` present ✓.
  - `% SOURCE:` from `references/stacks-modules.tex` with `(read from ...)` parenthetical ✓; `% SOURCE QUOTE:` verbatim Stacks `lemma-tensor-product-pullback` ✓; visible `\textit{Source:}` line ✓.
  - `\uses{def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso, lem:pullback_lan_decomposition, lem:pullback0_tensor_iso, lem:pullback_tensor_map}` — all labels exist in the chapter ✓.
  - **Sufficiently detailed for bottom-up formalization. GATE CLEARS for the `mathlib-build` lane.**

  **`lem:pullback_lan_decomposition` (D1 sub-lemma).**
  - Statement: well-formed. Content: pushforward factorization → left-adjoint reversal → `pullback φ ≅ extendScalars φ ⋙ pullback₀`. Correct.
  - `\uses{lem:presheaf_pushforward_laxmonoidal}` ✓ (label exists in chapter).
  - **No `\lean{...}` hint** — prover must self-name this declaration. Minor gap; does not block.
  - No `% SOURCE:` block — this is Archon-original assembly (categorical adjoint-reversal argument), so the omission is correct.

  **`lem:pullback0_tensor_iso` (D3 sub-lemma).**
  - Statement: well-formed. `\lean{AlgebraicGeometry.Scheme.Modules.pullback0TensorIso}` ✓.
  - `\uses{lem:pullback_lan_decomposition}` ✓.
  - Proof: filtered-colimit/⊗ interchange via diagonal finality of `(F↓V)`. Mathematically correct.
  - Honest note that this lemma is bottom-up (not in Mathlib) ✓.

  **`lem:isinvertible_pullback` (re-routed 3-line Stacks proof).**
  - `\uses{def:scheme_modules_isinvertible, lem:pullback_tensor_iso, lem:pullback_unit_iso}` ✓. No reference to `lem:isinvertible_implies_locallytrivial` ✓.
  - `% SOURCE:` from `references/stacks-modules.tex` ✓; `% SOURCE QUOTE:` verbatim `lemma-pullback-invertible` ✓; `% SOURCE QUOTE PROOF:` verbatim Stacks proof ✓; visible `\textit{Source:}` ✓.
  - Three-step iso chain `(pullbackTensorIso)⁻¹ ≫ (pullback f).mapIso e ≫ pullbackUnitIso` is spelled out with correct justification for each arrow being an isomorphism ✓.

  **`lem:isinvertible_implies_locallytrivial` (demoted off-path).**
  - Demotion is coherent: no other block anywhere in the blueprint has `\uses{}` pointing at it. Retained for future A.2.c (Quot-embedding), not a dependency for A.1.c. ✓.

  **Orphan flag: `lem:IsLocallyTrivial_pullback`** — see `Picard_LineBundlePullback.tex` notes above.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.
*(Named gap for `thm:rigidity_over_kbar` is correctly disclosed; fallback route retained per strategy.)*

## Cross-chapter notes

- `Picard_LineBundlePullback.tex` defines `lem:IsLocallyTrivial_pullback` with `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.pullback}`. After the re-route of `lem:isinvertible_pullback` to use `lem:pullback_tensor_iso` directly, this label has zero consumers in the blueprint dependency graph. The Lean declaration itself may still be used by prover-side Lean code, but it is not reachable via `\uses{}` from any theorem the project cares about.

## Severity summary

- **must-fix-this-iter**: none. The gate chapter is `complete: true, correct: true`. The A.1.c.sub `mathlib-build` prover lane may proceed.
- **soon**: `Picard_LineBundlePullback.tex` / `lem:IsLocallyTrivial_pullback` orphaned from the `\uses{}` graph. Clean up (demote to `\% NOTE` or retain as standalone) to keep the dependency graph tidy before A.2.c authoring references it.
- **informational**: `Picard_TensorObjSubstrate.tex` / `lem:pullback_lan_decomposition` missing `\lean{...}` hint. Plan agent may optionally add a Lean name (suggested: `AlgebraicGeometry.Scheme.Modules.pullbackLanDecomposition`) before the prover lane starts, so the blueprint anchor is complete.

**Overall verdict**: HARD GATE CLEARS for the `mathlib-build` lane on `Picard_TensorObjSubstrate.tex` — `sec:tensorobj_pullback_monoidality` is complete and correct; `lem:pullback_tensor_iso` proof sketch (D1–D4) is sufficiently detailed for bottom-up formalization; all `\uses{}` references resolve; citation discipline on `lem:isinvertible_pullback` is sound. 35 chapters audited, 2 findings (1 soon, 1 informational), 0 unstarted-phase proposals.
