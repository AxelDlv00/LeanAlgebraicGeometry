# Blueprint Review Report

## Slug
iter020

## Iteration
020

---

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine` proof: the proof sketch re-describes the local-to-global exactness argument (content of `lem:section_cech_module_exact`) inline rather than citing it by label. The proof-level `\uses{...}` block lists only `{def:section_cech_complex, def:qcoh_sections_localized, lem:section_cech_homology_exact}` — `lem:section_cech_module_exact` is absent. **wire-up** — add `lem:section_cech_module_exact` to the proof-level `\uses{}` of `lem:cech_acyclic_affine`; trim the inline re-proof to "by Lemma~\ref{lem:section_cech_module_exact}, D• is exact." **No out-of-order dispatch risk**: `lem:section_cech_module_exact` is already in the DAG transitively (it appears in the statement-level `\uses{}` of `lem:section_cech_homology_exact`, which is a proof-level dependency of `lem:cech_acyclic_affine`). The DAG ordering is correct; this is a prover-clarity improvement, classified **soon**.

---

## Gate: hard-gate verdict for the three prover lanes

**`CechAcyclic.lean` (P3 L1 steps (b)–(d))**: PASSES.
- `def:qcoh_sections_localized`: present with detailed prose. The Mathlib gap (qcoh F≅tilde(ΓF) globalisation, Stacks 01I8) is explicitly acknowledged as a build target and is exactly what the prover is being sent to close. Source citations reference `references/stacks-schemes.tex` (exists, ✓).
- `lem:section_cech_homology_exact`: present with full proof sketch and source quote. `\uses{}` correctly includes `lem:section_cech_module_exact` at statement level (added this iter, ✓).
- `lem:cech_acyclic_affine`: present with detailed 2-paragraph proof sketch (local-to-global + dependent port). Source quote present. The proof-level `\uses{}` omission of `lem:section_cech_module_exact` is classified soon (no dispatch risk, see Dependency findings above).

**`FreePresheafComplex.lean` (6-link quasi-iso chain → `lem:cech_free_complex_quasi_iso`)**: PASSES.
- All 6 sub-lemmas are present with complete proof sketches. The prior iter's lean-vs-blueprint-checker must-fix (monolithic proof under-specified) is **RESOLVED**. See per-chapter section for detailed per-lemma analysis.

**`CechBridge.lean` (injective-acyclicity bridging under `lem:injective_cech_acyclic`)**: PASSES.
- `lem:injective_cech_acyclic`, `lem:ses_cech_h1`, `lem:cech_to_cohomology_on_basis` are all present with detailed 2-part proof sketches and source quotes. Mathlib-backed adjunction bricks (`lem:injective_of_adjoint`, `lem:mod_pmod_adjunction`) correctly marked `\mathlibok`.

---

## Unstarted-phase blueprint proposals

*(omitted — every strategy phase has adequate blueprint coverage)*

All four active phases (P3, P3b, P5a, P5b) have ≥3 meaningful declaration blocks. Completed phases (P1, P2, P4) have coverage. No unstarted-phase proposals needed.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: true
- **correct**: true
- **notes**:

  **The 6-link quasi-iso chain — verification:**

  The directive asks to confirm the split of `lem:cech_free_complex_quasi_iso` into 6 sub-lemmas resolves the prior must-fix (monolithic proof under-specified). **Confirmed resolved.**

  | Label | Statement present | Proof sketch adequate | Source quote | `\uses{}` correct |
  |---|---|---|---|---|
  | `lem:quasiIso_of_evaluation` | ✓ | ✓ (objectwise conservativity + evaluation-commutes-homology) | ✓ Stacks lemma-homology-complex L1220–1226 | ✓ |
  | `lem:cech_free_eval_sectionwise` | ✓ | ✓ (explicit K(U)_p(V) = ⨁_{σ:Fin(p+1)→I₁} O_X(V)) | ✓ L1227–1252 | ✓ |
  | `lem:cech_free_eval_empty` | ✓ | ✓ (trivial: I₁=∅ → both sides zero) | ✓ L1228–1230 | ✓ uses `lem:cech_free_eval_sectionwise` |
  | `lem:cech_free_eval_prepend_homotopy` | ✓ | ✓ (definition of h_p as Sigma.desc of prepend-i_fix maps) | ✓ L1253–1271 | ✓ |
  | `lem:cech_free_eval_prepend_homotopy_spec` | ✓ | ✓ (dh+hd=id via combHomotopy_spec, sign-cancellation traced) | ✓ L1272–1285 with source quote proof | ✓ |
  | `lem:cech_free_eval_nonempty` | ✓ | ✓ (homotopy → contractible → quasi-iso via Homotopy.toQuasiIso) | ✓ L1224–1245 | ✓ uses previous 3 |
  | `lem:cech_free_complex_quasi_iso` | ✓ | ✓ (split on I₁, apply lem:quasiIso_of_evaluation) | ✓ L1198–1284 | ✓ uses all 6 |

  Mathematical chain is complete and logically sound. All `\lean{}` hints name specific Lean declarations. The objectwise-reduction step, the combinatorial description, the two branching cases, and the quasi-iso assembly are each isolated as a self-contained unit. **Prior lean-vs-blueprint-checker must-fix fully resolved.**

  **New P3 L1 step (a) — `def:section_cech_module_complex` + `lem:section_cech_module_exact`:**

  `def:section_cech_module_complex`: defines D• = ∏_σ M_{s_σ} with differential the alternating sum of away-localisation comparison maps. Bundles 22+ Lean helper names (`dCoeff`, `dCoface`, `dDiff`, `dToCech`, `fLoc`, `locDiff`, `locDiff_exact`, etc.). The three comparison families (dToCech, fLoc, locDiff) and the key transitivity `M_a[1/b]=M_{ab}` are all explained. Prose is dense but complete. `\uses{def:standard_affine_cover, def:qcoh_sections_localized}` — correct. No external source (Archon-original) — citation omission correct.

  `lem:section_cech_module_exact`: states positive-degree exactness of D•. Proof via `exact_of_isLocalized_span` + `map_dDiff_eq_locDiff` + `locDiff_exact` + `locDiff_eq_depDiff`. `\uses{def:section_cech_module_complex}` — correct. Proof is clear and adequate for formalization. No external source — correct.

  The new dependency arc `lem:section_cech_homology_exact` (statement) → `lem:section_cech_module_exact` → `def:section_cech_module_complex` is correctly wired. leandag confirms zero `unknown_uses`.

  **soon finding (re-stated for clarity):**
  The proof block of `lem:cech_acyclic_affine` lists `\uses{def:section_cech_complex, def:qcoh_sections_localized, lem:section_cech_homology_exact}` but should also list `lem:section_cech_module_exact`; the proof text re-describes the local-to-global exactness content inline, which could mislead a prover into re-proving rather than invoking `AlgebraicGeometry.SectionCechModule.dDiff_exact`. Wire-up: add `lem:section_cech_module_exact` to the proof-level `\uses{}` and replace the inline §"Node-by-node exactness" paragraph with a citation.

  **Informational:**
  - `def:cohomology_sheaf_is_sheafify_homology` (line ~2184) uses a `def:` label prefix but is declared inside `\begin{lemma}` — naming inconsistency; no impact on correctness or DAG.
  - `lem:cech_acyclic_affine` carries two `\lean{}` primary targets: `AlgebraicGeometry.sectionCech_affine_vanishing` (new re-signed name) and `AlgebraicGeometry.CechAcyclic.affine` (old name, held for coverage continuity per the `% NOTE:`). Transitional state is correctly documented; old name should be removed once the re-sign lands.

---

## Severity summary

**must-fix-this-iter**: 0.

**soon** (1 item):
- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine` proof: missing `lem:section_cech_module_exact` in proof-level `\uses{}`; proof sketch re-proves inline what the lemma already provides. **wire-up** — add the label and shorten the proof sketch. (No dispatch risk: dependency captured transitively; purely a prover-clarity improvement on an active route chapter.)

**informational** (2 items):
- `Cohomology_CechHigherDirectImage.tex` / `def:cohomology_sheaf_is_sheafify_homology`: `def:` label prefix on a `\begin{lemma}` block — naming inconsistency.
- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine`: dual `\lean{}` targets (re-sign transitional); clean up old name when refactor lands.

**DAG health**: zero `unknown_uses`, zero isolated nodes, zero conflicts (leandag). **Rendering health**: zero orphan chapters, zero broken refs, zero malformed refs (blueprint-doctor). All 3 active chapters pass.

**Overall verdict**: the consolidated chapter `Cohomology_CechHigherDirectImage.tex` is complete and correct; the 6-link `lem:cech_free_complex_quasi_iso` chain resolves the prior must-fix; `def:section_cech_module_complex` + `lem:section_cech_module_exact` are adequate; the HARD GATE clears for all three files (`CechAcyclic.lean`, `FreePresheafComplex.lean`, `CechBridge.lean`); no unstarted phases; 1 soon + 2 informational findings, 0 must-fix.
