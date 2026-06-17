# Blueprint Review Report

## Slug
ts243

## Iteration
243

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex` / `sec:tensorobj_pullback_monoidality`: three `\uses{}` inaccuracies in the new pullback-monoidality section — see must-fix #1, #2, #3 below. The proof sketches themselves are present and mathematically correct; the incompleteness is in the dependency graph.

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map` proof: states it uses "the same `sheafificationCompPullback` device that supplies Steps 1--2 of `lem:tensorobj_restrict_iso`" — but lists `lem:tensorobj_restrict_iso` in `\uses{}` rather than the underlying sub-lemma (`sheafificationCompPullback`). A prover reading the `\uses{}` graph would believe they need to close the open H1 residual of `lem:tensorobj_restrict_iso` (the presheaf-pushforward adjunction) before they can tackle `pullback_tensor_map`. The proof sketch explicitly disavows this: it uses the building blocks of `tensorobj_restrict_iso`, not its conclusion. This must be corrected to avoid misleading prover dispatch.

---

## Per-chapter

### `blueprint/src/chapters/AbelJacobi.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Jacobian.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Rigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_SheafCompose.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Differentials.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CoheightBridge.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_FlatteningStratification.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RigidityKbar.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_LineBundlePullback.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_RelativeSpec.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_QuotScheme.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OCofP.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_HigherDirectImage.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_IdentityComponent.tex` — complete + correct, no notes.

---

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - The two new named obligation blocks (`lem:base_change_map_affine_local`, `lem:pushforward_base_change_mate_cancelBaseChange`) are faithfully extracted from the existing proof prose of `lem:affine_base_change_pushforward`. Both have proper Stacks SOURCE / SOURCE QUOTE citations from `references/stacks-coherent.tex`. Both are well-posed as named obligations: the first identifies the affine-reduction locality naturality and the second names the mate-vs-`cancelBaseChange` coherence crux. No mathematical errors.
  - New `\lean{}` pin on `lem:gammaPushforwardNatIso` (`AlgebraicGeometry.gammaPushforwardNatIso`) is well-formed; `\leanok` is present on both statement and proof (consistent with iter-242 landing). The naturality proof (all constituents are identity-on-carrier repackagings, so every naturality square is a pointwise identity) is correct and detailed enough for a prover.
  - `lem:affine_base_change_pushforward` `\uses{}` now correctly lists `lem:base_change_map_affine_local` and `lem:pushforward_base_change_mate_cancelBaseChange`.
  - **HARD GATE: CLEAR** for `Cohomology/FlatBaseChange.lean`.

---

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - **GATE-CRITICAL SECTION `sec:tensorobj_pullback_monoidality` — detailed assessment:**

  **What is correct and well-formulated:**
  - `lem:pullback_tensor_iso` is cleanly descoped with no `\lean{}` pin. The prose explains the Mathlib-scale obstruction (absent `PresheafOfModules.extendScalars` + topological inverse-image left Kan extension) and records the would-be concrete proof to document why the general iso is hard. Off-path disposition is clean.
  - `lem:presheaf_pushforward_laxmonoidal` (`AlgebraicGeometry.Scheme.Modules.presheafPushforwardLaxMonoidal`): correctly states that the presheaf pushforward is lax monoidal as the composite of the strong-monoidal fixed-ring pushforward and the lax-monoidal `restrictScalars`. Proof sketch is correct and sufficient.
  - `lem:presheaf_pullback_oplaxmonoidal` (`AlgebraicGeometry.Scheme.Modules.presheafPullbackOplaxMonoidal`): correctly invokes `Adjunction.leftAdjointOplaxMonoidal` on the lax-monoidal pushforward. Uses `lem:presheaf_pushforward_laxmonoidal`. Proof sketch is correct and sufficient.
  - `lem:isinvertible_implies_locallytrivial` (`AlgebraicGeometry.Scheme.Modules.IsInvertible.isLocallyTrivial`): proof sketch is mathematically correct. The argument (tensor inverse → local stalk invertible → stalk free rank 1 over local ring → finite-presentation spread-out → locally trivial) follows Stacks `lemma-invertible-is-locally-free-rank-1`. Source citations (`lemma-invertible` and `lemma-invertible-is-locally-free-rank-1`, both from `references/stacks-modules.tex`) are present and correct.
  - `lem:isinvertible_pullback` (`AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback`): the local-trivialization route proof sketch is structurally sound. The three-step composite `δ_sheaf^{-1} ≫ f^*e ≫ pullbackUnitIso` is well-described. The cover argument (invertibility → local triviality → restrict `δ_sheaf` to trivializing cover where all modules are `𝒪` → `δ_sheaf` = canonical `𝒪⊗𝒪→𝒪` → iso; globalise by `lem:isiso_of_isiso_restrict`) is correct. Source citations from `references/stacks-modules.tex` (`lemma-pullback-invertible`) are present and correct with SOURCE QUOTE PROOF.

  **Must-fix findings (three `\uses{}` inaccuracies):**

  **FINDING #1 (most critical — misleads prover on dependency order):** `lem:pullback_tensor_map` has:
  ```
  \uses{lem:presheaf_pullback_oplaxmonoidal, def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso}
  ```
  But the proof sketch says: "using the same `sheafificationCompPullback` device **that supplies Steps 1--2 of** `lem:tensorobj_restrict_iso`" — i.e., it uses the building blocks (`SheafOfModules.sheafificationCompPullback`, `sheafifyTensorUnitIso`), not the *conclusion* of `tensorobj_restrict_iso`. The conclusion of `tensorobj_restrict_iso` is the iso `(M⊗N)|_f ≅ M|_f ⊗ N|_f`, which is NOT needed to build the comparison MAP `δ_sheaf`. Including `lem:tensorobj_restrict_iso` in `\uses{}` falsely implies the prover must first close the H1 residual (the presheaf pushforward adjunction, an open Mathlib-gradient build) before they can proceed. This will mislead a prover into wrong dispatch order.
  
  **Fix**: Remove `lem:tensorobj_restrict_iso` from `lem:pullback_tensor_map`'s `\uses{}`. If `sheafificationCompPullback` / `sheafifyTensorUnitIso` are project-side lemmas with blueprint labels, add those instead; if they are Mathlib facts, no `\uses{}` entry is needed.

  **FINDING #2:** `lem:isinvertible_pullback` proof body uses `\cref{lem:IsLocallyTrivial_pullback}` (defined in `Picard_LineBundlePullback.tex`, label confirmed to exist) but does not list it in `\uses{}`. The `\uses{}` on both statement and proof blocks is:
  ```
  \uses{def:scheme_modules_isinvertible, lem:pullback_tensor_map,
        lem:isinvertible_implies_locallytrivial, lem:pullback_unit_iso,
        lem:isiso_of_isiso_restrict, lem:tensorobj_preserves_locally_trivial}
  ```
  Add `lem:IsLocallyTrivial_pullback` to both the statement and proof `\uses{}` entries. Without it, the dependency graph misses the cross-chapter edge to `Picard_LineBundlePullback.tex`.

  **FINDING #3:** `lem:isinvertible_implies_locallytrivial` proof body invokes `stalkTensorIso` (i.e., `lem:stalk_tensor_commutation`, which IS `\leanok` — so it's not a prover blocker, but the dependency is undeclared). The proof says: "commuting the stalk past the tensor product — the varying-ring stalk-tensor identification `(M⊗_XN)_x ≅ M_x ⊗_{O_{X,x}} N_x` (`stalkTensorIso`)". This is `lem:stalk_tensor_commutation` from the same chapter. It should be added to `\uses{}`:
  ```
  \uses{def:scheme_modules_isinvertible, def:IsLocallyTrivial, lem:stalk_tensor_commutation}
  ```

  **What this means for the gate:** All three findings are `\uses{}` graph inaccuracies (two missing entries, one overstated entry). The mathematical proof sketches are all correct. A writer pass targeting exactly these three `\uses{}` fixes is sufficient to clear the gate. The same-iter fast path applies: fix → `lake build` green → scoped re-review → dispatch prover.

  - **HARD GATE: BLOCKED** for `Picard/TensorObjSubstrate.lean`. Reason: `complete: partial` (three `\uses{}` inaccuracies in `sec:tensorobj_pullback_monoidality`). See must-fix items above. Mathematical content is sound; only the dependency graph needs writer repair.

---

## Severity summary

**must-fix-this-iter:**

1. **`Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map`**: Remove `lem:tensorobj_restrict_iso` from `\uses{}` — overstated dependency that would mislead a prover into closing the H1 residual before attempting `pullback_tensor_map`. The proof sketch explicitly uses only the building blocks of `tensorobj_restrict_iso`, not its conclusion.

2. **`Picard_TensorObjSubstrate.tex` / `lem:isinvertible_pullback`**: Add `lem:IsLocallyTrivial_pullback` to `\uses{}` in both statement and proof blocks. The proof body cites this cross-chapter label (from `Picard_LineBundlePullback.tex`) but the dependency is undeclared.

3. **`Picard_TensorObjSubstrate.tex` / `lem:isinvertible_implies_locallytrivial`**: Add `lem:stalk_tensor_commutation` to `\uses{}`. The proof body uses `stalkTensorIso` (which IS `\leanok`) but the dependency is undeclared in the graph.

**Gate consequences:**
- `Cohomology/FlatBaseChange.lean` — GATE CLEAR (chapter complete + correct, no must-fix findings).
- `Picard/TensorObjSubstrate.lean` — GATE BLOCKED until the three `\uses{}` fixes are applied. Same-iter fast path: dispatch blueprint-writer targeting exactly these three entries, re-run scoped review, then dispatch prover.

Overall verdict: FlatBaseChange HARD GATE CLEARS; TensorObjSubstrate blocked on 3 `\uses{}` inaccuracies in the new pullback-monoidality section (mathematical content correct, dependency graph incomplete/overstated); all other 33 chapters are complete and correct. 0 unstarted-phase proposals (every strategy phase has adequate blueprint coverage).
