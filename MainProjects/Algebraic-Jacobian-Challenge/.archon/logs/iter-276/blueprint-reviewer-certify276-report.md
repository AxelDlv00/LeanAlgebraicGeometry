# Blueprint Review Report

## Slug
certify276

## Iteration
276

## Top-level summaries

### Incomplete parts

- `AbelianVarietyRigidity.tex` / `lem:rigidity_eqOn_saturated_open_to_affine` proof block and surrounding proof: contains NOTE comment (iter-162) saying "STALE as of iter-162 — Step 1 is now PROVEN and the WHOLE Rigidity-Lemma chain is sorry-free + axiom-clean". The proof prose still describes Step 1 as "the chain's single genuinely-deep residual sorry". Blueprint-writer should refresh this wording to "chain closed iter-162" per the NOTE.

- `AlgebraicJacobian_Cotangent_GrpObj.tex`: pointer chapter only — no standalone mathematical declaration blocks. The literal-ref "Chapter~REF" at line 6 (referring to `RigidityKbar.tex`) and two undefined macros (`\obj`, `\toUnit`) are the only content-level issues. The chapter correctly declares its role as a Lean-file pointer.

### Proofs lacking detail

No proofs lacking detail in chapters feeding active prover lanes. The stalktensor/internalhom/vestigial helpers subsections of `Picard_TensorObjSubstrate.tex` (the directive's priority focus) are sufficiently detailed for provers.

### Dependency & isolation findings

**`lem:isiso_sheafification_map_of_W`** (`Picard_TensorObjSubstrate.tex`, line 1009): isolated (no `\uses{}` out, nothing uses it). Block comment says "pending deletion once the assoc re-route (morphism-level descent) lands." The assoc re-route (`tensorobj_assoc_iso` via `tensorobj_restrict_iso`) has landed axiom-clean; this lemma is no longer the associator's load-bearing step. The block appears only in a prose list in the `sec:tensorobj_internal_consistency` section, not as a `\uses{}` dependency anywhere. **Disposition: remove** — genuinely orphaned scaffolding, authorized for writer deletion. The `\leanok` marker means the Lean-side declaration (`PresheafOfModules.isIso_sheafification_map_of_W`) is proved and need not be deleted from Lean; only the blueprint block requires removal to clean up the isolation.

**`lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`** (`RigidityKbar.tex`, line 2252): isolated, unmatched `\lean{}` (`Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`). **Disposition: keep** — long-standing isolation-exempt leaf; the `\lean{}` pin targets an unformalized Lean declaration on the off-critical-path (S3.sep.2) route; retaining for architectural completeness.

**`lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`** (`RigidityKbar.tex`, line 2357): isolated, unmatched `\lean{}` (`Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`). **Disposition: keep** — same as `lem:S3_sep_2_*` above.

**54 isolated `lean_aux` nodes**: all in `TensorObjSubstrate.lean` / `DualInverse.lean` (the two actively-churning prover-lane files). These are uncovered Lean helpers, a normal "needs a blueprint entry" signal for in-progress implementation; not removal candidates. The directive confirms these are the 54 known deferred helpers.

**No `unknown_uses`**: all `\uses{}` edges point to valid blueprint labels (leandag `unknown_uses: []`). ✓

**Rendering integrity (from `archon blueprint-doctor --json`):** 353 malformed\_refs total across 26 chapters, zero in the two active prover chapters (`Picard_TensorObjSubstrate.tex`, `Cohomology_CechHigherDirectImage.tex`). Grouped findings:

| Chapter | Kind | Count | Representative |
|---|---|---|---|
| `AbelJacobi.tex` | literal-ref | 2 | "Theorem~REF" in proof of `thm:exists_unique_ofCurve_comp` |
| `AbelianVarietyRigidity.tex` | math-delim | 8 | lines 25, 41 — `\(…\)` inside `$…$` |
| `Albanese_AlbaneseUP.tex` | bare-label | 1 | `lem:agps` in prose |
| `Albanese_AlbaneseUP.tex` | math-delim | 8 | lines 369, 435 |
| `Albanese_AuslanderBuchsbaum.tex` | bare-label | 1 | `lem:depth_drops_by_one` |
| `Albanese_AuslanderBuchsbaum.tex` | math-delim | 6 | lines 158, 401 |
| `Albanese_CodimOneExtension.tex` | math-delim | 8 | lines 1686, 1732 |
| `Albanese_CoheightBridge.tex` | math-delim | 8 | lines 111, 134 |
| `AlgebraicJacobian_Cotangent_GrpObj.tex` | literal-ref | 1 | "REF" in first paragraph |
| `AlgebraicJacobian_Cotangent_GrpObj.tex` | undefined-macro | 2 | `\obj`, `\toUnit` |
| `Cohomology_MayerVietoris.tex` | literal-ref | 29 | "Chapter~REF", "Definition~REF", "Lemma~REF" |
| `Cohomology_SheafCompose.tex` | literal-ref | 2 | "Definition~REF", "Theorem~REF" |
| `Cohomology_StructureSheafAb.tex` | literal-ref | 7 | "Chapter~REF", "Theorem~REF" |
| `Cohomology_StructureSheafModuleK.tex` | literal-ref | 38 | "Chapter~REF", "Definition~REF", "Lemma~REF" |
| `Differentials.tex` | literal-ref | 16 | "Definition~REF", "Lemma~REF" |
| `Jacobian.tex` | literal-ref | 9 | "Chapter~REF", "Theorems~REF" |
| `Picard_FGAPicRepresentability.tex` | bare-label | 7 | `cor:algsch`, `lm:ctn`, `lm:qt` |
| `Picard_FGAPicRepresentability.tex` | math-delim | 8 | lines 129, 135 |
| `Picard_FlatteningStratification.tex` | literal-ref | 23 | "Corollary~REF", "Definition~REF" |
| `Picard_FlatteningStratification.tex` | math-delim | 2 | line 742 |
| `Picard_IdentityComponent.tex` | bare-label | 17 | `cor:sm`, `lem:agps`, `th:qpp` |
| `Picard_Pic0AbelianVariety.tex` | bare-label | 15 | `cor:ch0`, `cor:sm`, `rmk:Jac` |
| `Picard_Pic0AbelianVariety.tex` | undefined-macro | 1 | `\tu` |
| `Picard_QuotScheme.tex` | math-delim | 8 | lines 243, 332 |
| `Picard_RelPicFunctor.tex` | bare-label | 3 | `th:cmp`, `th:main` |
| `Picard_RelPicFunctor.tex` | literal-ref | 3 | "REF" section refs |
| `Picard_RelativeSpec.tex` | math-delim | 2 | line 686 |
| `RiemannRoch_OCofP.tex` | math-delim | 8 | lines 27, 424 (paused) |
| `RiemannRoch_OcOfD.tex` | literal-ref + math-delim | 43+8 | many (paused) |
| `RiemannRoch_RRFormula.tex` | literal-ref + math-delim | 35+8 | many (paused) |
| `RiemannRoch_RationalCurveIso.tex` | math-delim | 8 | lines 36, 51 (paused) |
| `RiemannRoch_WeilDivisor.tex` | math-delim | 6 | lines 142, 1370 |
| `Rigidity.tex` | literal-ref | 2 | "Theorem~REF" |

All rendering issues are **soon severity** — none occur in `Picard_TensorObjSubstrate.tex` or `Cohomology_CechHigherDirectImage.tex` (the active prover lanes). The undefined macros in `AlgebraicJacobian_Cotangent_GrpObj.tex` (`\obj`, `\toUnit`) and `Picard_Pic0AbelianVariety.tex` (`\tu`) render as raw LaTeX everywhere and should be defined or replaced.

### Unmatched `\lean{}` pins (46 total)

**25 `AlgebraicGeometry.TODO.*`** pins: expected, explicitly marking unformalized targets. Not errors.

**21 non-TODO unmatched**:
- `AlgebraicGeometry.finite_appTop_of_universallyClosed` — correctly marked `\mathlibok` in `Cohomology_StructureSheafModuleK.tex`; unmatched because leandag scans project Lean files only, not the Mathlib lake package. Mathlib has this declaration at `Mathlib/AlgebraicGeometry/Morphisms/Proper.lean:154`. **Not an error.**
- `AlgebraicGeometry.pushPullMap_comp` (`lem:push_pull_functor`, `Cohomology_CechHigherDirectImage.tex`) — declared in Lean only as an inline field of a structure comment; not yet a top-level `theorem`. In progress. **Not an error; expected unmatched.**
- `AlgebraicGeometry.hom_Ga_to_av_trivial`, `AlgebraicGeometry.morphism_Ga_to_av_const` — off-path Milne-alternative declarations in `AbelianVarietyRigidity.tex`; explicitly marked off the genus-0 critical path. Not yet formalized. **Informational.**
- `AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth`, `AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper`, `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`, `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange` — off-path S3 declarations in `RigidityKbar.tex`. Not yet formalized. **Informational.**
- Substrate/pullback items (`pullbackTensorIso`, `pullback0TensorIso`, `pullbackTensorIsoOfLocallyTrivial`, `IsInvertible.isLocallyTrivial`, `IsInvertible.pullback`, `addCommGroup_via_tensorObj`, `baseMap_*`) — A.1.c.sub targets in TensorObjSubstrate, in progress. **Expected unmatched.**
- `Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension` — `Differentials.tex` / `lem:smooth_algebra_krull_dim_formula`; Lean declaration exists at this name in `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` but may be qualified differently. **Minor.**
- `AlgebraicGeometry.Scheme.Pic.albaneseUP` — `Albanese_AlbaneseUP.tex`; target declaration not yet created in `AlgebraicJacobian/Albanese/AlbaneseUP.lean`. **Expected unmatched.**

### Priority-area findings: three `*_helpers` subsections of `Picard_TensorObjSubstrate.tex`

**`subsec:tensorobj_stalktensor_helpers`** (lines 2324–2640, ~30 blocks): all "Proved directly in Lean" coverage blocks are **mathematically faithful** to their Lean declarations. The chain builds the stalk–tensor comparison isomorphism bottom-up (balanced bilinear map → per-neighbourhood descent → forward map → reverse map → mutual inversion lemmas), with each block's mathematical statement correctly matching the Lean signature. No duplicate `\lean{}` pins within this subsection. No Lean syntax in statement/proof bodies.

**`subsec:tensorobj_internalhom_helpers`** (lines 6986–7398, ~23 blocks): all blocks faithful. The chain builds the internal-hom presheaf of modules (terminal ring map → global-scalar endomorphism → restriction functoriality → abelian-group presheaf → evaluation map → lax-monoidal ε/μ), with each block correctly characterizing its Lean declaration. No duplicate pins. No Lean syntax leak.

**`subsec:tensorobj_vestigial_helpers`** (lines 7399–7574, ~16 blocks): all blocks faithful. The chain builds localizer-stability helpers (left/right whiskering locality, stalkwise-iso criterion, open-embedding slice-site equivalence). No duplicate pins. No Lean syntax leak.

**One intentionally shared pin**: `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` is pinned to two blueprint blocks — `lem:islocallyinjective_whisker_of_W` (line 1191, superseded route) and a block in the vestigial subsection (line 2261). The in-file comment at line 1193–1196 explicitly documents this as intentional, noting "Both blueprint nodes legitimately share the pin (leandag flags only Lean-side name collisions, not shared blueprint pins)." **Not an error.**

**NOTE also in `Picard_TensorObjSubstrate.tex`, line 1829**: "NOTE: `\lean{}` pin target absent from Lean source as of iter-271 (verified by grep)" — this documents that one pin in the Route-(e) section points at a declaration not yet present. This is in the off-path route-(e) section and does not affect active prover work.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 2 literal-ref "Theorem~REF" placeholders in prose of `thm:exists_unique_ofCurve_comp` proof — writer should replace with `\cref{thm:nonempty_jacobianWitness}` or the appropriate label.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 8 math-delim issues (lines 25, 41 and others) — `\(…\)` opened inside `$…$` math environments. Writer fix needed.
  - Stale wording in proof block of `lem:rigidity_eqOn_saturated_open_to_affine` and surrounding blocks describing Step 1 as "the chain's single genuinely-deep residual sorry" — contradicted by the in-file NOTE at line 196–201 saying "STALE as of iter-162 — Step 1 is now PROVEN". Writer should update these proof prose blocks to reflect the closed state.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 1 bare-label `lem:agps` in prose — replace with `\cref{lem:agps}`.
  - 8 math-delim issues (lines 369, 435).

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 1 bare-label `lem:depth_drops_by_one` — replace with `\cref{}`.
  - 6 math-delim issues (lines 158, 401).

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes (8 math-delim rendering issues, soon severity).

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes (8 math-delim rendering issues, soon severity).

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Pointer-only chapter — no standalone mathematical declaration blocks; all content delegated to `RigidityKbar.tex`. Mathematical declarations covered are listed in the `\section{Lean declarations in this file}` bullet list.
  - 1 literal-ref "Chapter~REF" (line 6) — replace with `\cref{chap:RigidityKbar}`.
  - 2 undefined macros: `\obj` and `\toUnit` — define via `\providecommand` or replace with prose (e.g., `\(\mathtt{obj}\)` and `\(\mathtt{toUnit}\)`). Intent is clear from context.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 29 literal-ref placeholders (Chapter~REF, Definition~REF, Lemma~REF) — all need `\cref{}` replacements.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 2 literal-ref (Definition~REF, Theorem~REF).

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 7 literal-ref (Chapter~REF, Definition~REF, Theorem~REF).

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 38 literal-ref (Chapter~REF, Definition~REF, Lemma~REF).

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 16 literal-ref (Definition~REF, Lemma~REF, Remark~REF).

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 9 literal-ref (Chapter~REF, REF, Theorems~REF) — replace with appropriate `\cref{}`.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 7 bare-labels (`cor:algsch`, `lm:ctn`, `lm:qt` etc.) — replace with `\cref{}`.
  - 8 math-delim (lines 129, 135).

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 23 literal-ref (Corollary~REF, Definition~REF, Lemma~REF).
  - 2 math-delim (line 742).

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 17 bare-labels (`cor:sm`, `lem:agps`, `th:qpp` etc.) — replace with `\cref{}`.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 15 bare-labels (`cor:ch0`, `cor:sm`, `rmk:Jac` etc.) — replace with `\cref{}`.
  - 1 undefined macro `\tu` — define or replace with `\text{H}^1(\mathcal{O}_X)` or whatever the intended expansion is.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 8 math-delim (lines 243, 332).

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 3 bare-labels (`th:cmp`, `th:main`).
  - 3 literal-ref "REF" section refs (lines 51, 55, 57).

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 2 math-delim (line 686).

### blueprint/src/chapters/Picard_SheafOverEquivalence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Priority-area audit (directive §1) PASSED: all three helpers subsections are mathematically faithful, no duplicate pins (intentional shared pin documented), no Lean syntax leak. See `### Priority-area findings` above.
  - `lem:isiso_sheafification_map_of_W` (line 1009): isolated, should be removed — see `### Dependency & isolation findings`.
  - NOTE at line 1829: `\lean{}` pin absent from Lean source (route-(e) off-path section). Informational, does not affect active prover work.
  - 2 nodes with `∞` effort in leandag (TensorObjSubstrate / DualInverse active-lane churning) — expected for deferred prover items.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes (paused lane).

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, 8 math-delim (paused lane).

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, 43 literal-ref + 8 math-delim (paused lane).

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, 35 literal-ref + 8 math-delim (paused lane).

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, 8 math-delim (paused lane).

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, 6 math-delim.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 2 literal-ref "Theorem~REF" in "Use in the project" section (lines 58, 61) — replace with `\cref{thm:IsAlbanese_exists_unique_ofCurve_comp}` or the relevant Albanese-property theorem label.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

## Cross-chapter notes

- `AbelianVarietyRigidity.tex` proof blocks describing Step 1 as "the chain's single genuinely-deep residual sorry" are stale (chain closed iter-162 per NOTE at line 196–201). No downstream correctness impact; purely a documentation gap.

## Severity summary

**Must-fix-this-iter**: none.

**Soon** (grouped by action):
1. **Undefined macros** (render as raw TeX): `\obj`, `\toUnit` in `AlgebraicJacobian_Cotangent_GrpObj.tex`; `\tu` in `Picard_Pic0AbelianVariety.tex`.
2. **Math-delim** (shredded formulas, 88 occurrences across 13 chapters): `AbelianVarietyRigidity.tex`, `Albanese_AlbaneseUP.tex`, `Albanese_AuslanderBuchsbaum.tex`, `Albanese_CodimOneExtension.tex`, `Albanese_CoheightBridge.tex`, `Picard_FGAPicRepresentability.tex`, `Picard_FlatteningStratification.tex`, `Picard_QuotScheme.tex`, `Picard_RelativeSpec.tex`, `RiemannRoch_*` (4 paused chapters), `RiemannRoch_WeilDivisor.tex`.
3. **Bare-labels** (not rendered as cross-refs, 58 occurrences across 6 chapters): `Albanese_AlbaneseUP.tex`, `Albanese_AuslanderBuchsbaum.tex`, `Picard_FGAPicRepresentability.tex`, `Picard_IdentityComponent.tex`, `Picard_Pic0AbelianVariety.tex`, `Picard_RelPicFunctor.tex`.
4. **Literal-ref placeholders** (plain "REF" tokens in prose, 207 occurrences across 11 chapters): `AbelJacobi.tex`, `AlgebraicJacobian_Cotangent_GrpObj.tex`, `Cohomology_MayerVietoris.tex`, `Cohomology_SheafCompose.tex`, `Cohomology_StructureSheafAb.tex`, `Cohomology_StructureSheafModuleK.tex`, `Differentials.tex`, `Jacobian.tex`, `Picard_FlatteningStratification.tex`, `Picard_RelPicFunctor.tex`, `Rigidity.tex`, `RiemannRoch_OcOfD.tex`, `RiemannRoch_RRFormula.tex`.
5. **Isolation removal**: `lem:isiso_sheafification_map_of_W` in `Picard_TensorObjSubstrate.tex` — dispatch writer to remove this block (Lean declaration `isIso_sheafification_map_of_W` may remain in Lean tree; only the blueprint block should be deleted).
6. **Stale proof prose**: `AbelianVarietyRigidity.tex` — update "single genuinely-deep residual sorry" wording to reflect chain closed iter-162.

**Informational**:
- `lem:hom_Ga_to_av_trivial`, `lem:hom_from_Ga_trivial` — unmatched lean pins for off-path Milne-alternative declarations; not yet formalized; low priority.
- Intentional shared lean pin `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` between two TensorObjSubstrate blocks — documented, not an error.

**Overall verdict**: HARD GATE CLEARS for all active prover lanes (`Picard_TensorObjSubstrate.tex` and `Cohomology_CechHigherDirectImage.tex` are both `complete: true`, `correct: true`, no must-fix findings). The three `*_helpers` subsections are mathematically faithful with no pin duplication or syntax leakage. 353 rendering issues across 26 chapters are soon severity only; 0 unstarted-phase proposals.
