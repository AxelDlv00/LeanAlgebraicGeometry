# Blueprint Review Report

## Slug
iter031

## Iteration
031

## Top-level summaries

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:qcoh_localized_sections` (P1): The final "IsLocalizedModule construction from local data" step — showing that patching compatible fractions across the finite basic-open cover makes `Γ(X,F) → Γ(D(f),F)` an `IsLocalizedModule` — is described informally ("a compatible family of fractions s_j/f^N glues") but no Lean API is named for how to establish the `IsLocalizedModule` predicate from local/sheaf-gluing data. This is the acknowledged load-bearing GAP. A skilled prover can work from the sketch, but the Lean route through `IsLocalizedModule.mk` or a universality argument will require care (~few-hundred LOC per STRATEGY). Not a block — P1 is still **FORMALIZE-READY** — but flag for the dispatched prover.

### Dependency & isolation findings

- `lean:AlgebraicGeometry.CechAcyclic.affine` appears in both `leandag.meta.axioms` and `leandag.meta.leaves` — it is a fully isolated `lean_aux` node (dead sorry superseded by `sectionCech_affine_vanishing`, noted in PROGRESS.md). **keep** — it is the explicitly-documented dead sorry that will be removed once the Lean file is tidied; not a blueprint coverage gap.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: true
- **correct**: true
- **notes**:
  - **FORMALIZE-READY: `lem:injective_cech_acyclic` (CechBridge target)** — Block at line 2663 covers both `injective_cech_acyclic` (original X.OpenCover form) and `injective_cech_acyclicFam` (new cover-agnostic family form, this iter's target) in the `\lean{}` hint. Proof is detailed in two parts (injective sheaf → injective presheaf via adjoint; quasi-iso + exact Hom → vanishing). `cechFreeComplex_quasiIsoFam` is confirmed in `lem:cech_free_complex_quasi_iso`'s `\lean{}` list. All `\uses{}` resolve (leandag: 0 broken).
  - **FORMALIZE-READY: `lem:section_cech_complex_mapop_iso` (CechBridge target)** — Block at line 2600 covers both `sectionCechComplexMapOpIso` and `sectionCechComplexMapOpIsoFam` in the `\lean{}` hint. Proof is the composition of `homCechComplexMapOpIso` and `cechComplex_hom_identification`; family form is stated as the cover-agnostic mirror. All `\uses{}` resolve.
  - **FORMALIZE-READY: `lem:exists_finite_basicOpen_subcover` (P0, QcohTilde target)** — Block at line 3827 is fully self-contained: no `\uses{}`, three-step proof (basic opens form a basis; quasi-compactness gives finite subcover; covering ↔ span condition). SOURCE + QUOTE from `references/stacks-schemes.tex` L531–534, L1289–1301 present. Clean topology; the prover can formalize from the block alone.
  - **FORMALIZE-READY: `lem:qcoh_localized_sections` (P1, QcohTilde target)** — Block at line 3867 gives the correct approach: quasi-compact affine → finite basic-open trivialising cover (P0) → on each D(f_j) = Spec R_{f_j} quasi-coherence supplies a Presentation → `qcoh_iso_tilde_sections_of_presentation` gives F|_{D(f_j)} ≅ ~M_j → sections over D(g) ⊆ D(f_j) are (M_j)_g → patching via sheaf condition yields IsLocalizedModule for {f^k}. `\uses{lem:exists_finite_basicOpen_subcover, lem:qcoh_iso_tilde_sections_of_presentation}` resolves correctly. Acknowledged GAP (~few-hundred LOC); proof sketch tells the prover what to do (see "Proofs lacking detail" finding for the one thin step).
  - `lem:free_isQuasicoherent` (P3 helper, line 3806): Statement-only block with SOURCE + QUOTE; no separate proof block (justification embedded in statement body). This is fine for a simple fact. FORMALIZE-READY.
  - `lem:tilde_preserves_kernels` (P3 sub-gap, line 3954): SOURCE + QUOTE from stacks-schemes.tex, proof sketch references exactness of `~(-)`. No `\uses{}` (root lemma via Mathlib tilde exactness). FORMALIZE-READY.
  - **blueprint-doctor**: zero malformed_refs, zero broken_refs, zero orphan chapters, zero covers_problems. Rendering clean.
  - **leandag**: 123 nodes, 265 edges, 0 `unknown_uses` (broken \uses{}), 0 `unmatched_lean`, 0 isolated blueprint nodes. DAG integrity clean.
  - **Citation discipline audit (P0–P4 chain)**: All six new blocks (`lem:free_isQuasicoherent`, `lem:exists_finite_basicOpen_subcover`, `lem:qcoh_localized_sections`, `lem:qcoh_global_generation`, `lem:tilde_preserves_kernels`, `lem:qcoh_kernel_qcoh`) carry `% SOURCE: ... (read from references/stacks-schemes.tex, ...)` with local-file parenthetical ✓; `% SOURCE QUOTE:` verbatim text ✓; `\textit{Source: ...}` first-line visible citation ✓. `references/stacks-schemes.tex` and `references/stacks-schemes.md` both on disk ✓. No fabrication signals.
  - **`rem:o1i8_decomposition` \uses-chain**: All six labels used (`lem:qcoh_iso_tilde_sections`, `lem:qcoh_iso_tilde_sections_of_presentation`, `lem:isIso_fromTildeGamma_of_presentation`, `lem:exists_finite_basicOpen_subcover`, `lem:qcoh_localized_sections`, `lem:qcoh_global_generation`, `lem:tilde_preserves_kernels`, `lem:qcoh_kernel_qcoh`, `lem:isIso_fromTildeGamma_of_genSections`, `lem:qcoh_iso_tilde_sections_of_genSections`, `lem:isIso_fromTildeGamma_of_quasicoherent`) resolve in leandag. Route-P decomposition is internally consistent.
  - **P5a coverage** (`lem:cech_term_pushforward_acyclic`, line 5103): Present and detailed — reduces to Serre vanishing via relative affine vanishing argument. `lem:affine_serre_vanishing` (line 3226) and `lem:affine_injective_acyclic` (line 3548) present. P5a adequately covered.
  - **P5b coverage** (`lem:cech_augmented_resolution` line 4834, `lem:cech_computes_cohomology` line 5173): Both present. P5b adequately covered.

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

(The "proofs lacking detail" note on P1 and the dead-sorry isolated lean_aux node are informational; neither triggers a must-fix.)

---

**Overall verdict**: Blueprint is complete and correct across all three chapters; both CechBridge family-form targets (`injective_cech_acyclicFam`, `sectionCechComplexMapOpIsoFam`) and both QcohTilde targets (P0 `exists_finite_basicOpen_subcover`, P1 `qcoh_localized_sections`) are FORMALIZE-READY; all three remaining strategy phases (02KG, P5a, P5b) have adequate blueprint coverage; 0 unstarted-phase proposals needed. HARD GATE CLEARS for all four prover dispatch targets this iter.
