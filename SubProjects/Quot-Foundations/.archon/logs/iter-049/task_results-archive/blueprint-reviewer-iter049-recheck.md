# Blueprint Review: iter049-recheck
**Iter:** 049

## Top-level summaries

- **Rendering**: `Picard_SectionGradedRing.tex` — `\PShMod` undefined (typo for `\PshMod`); `Picard_GrassmannianQuot.tex` — `\quot` and `\xhookrightarrow` undefined.
- **Deps/Isolated**: `unknown_uses: []` — no broken `\uses{}` edges. 10 isolated nodes, all `lean_aux` (uncovered helpers, no blueprint nodes). No wire-up/remove actions needed.
- **Multi-route**: single route (no multi-route in any chapter).

---

## Focus-chapter verdicts (directive items 1–3)

### 1. `Picard_SectionGradedRing.tex` — `lem:sheafTensorPow_add`

**Prior must-fix**: no explanation of where associator/unitor/braiding come from in Lean.

**Fix applied**: a new paragraph was added between the local-iso criterion and "Construction of μ" reading:

> "Concretely, each structural map is obtained as the image under the sheafification functor `\PShMod → \ShMod` (`lem:presheafModule_sheafification_mathlib`) of the corresponding natural transformation supplied by the presheaf-level monoidal structure (`lem:presheafModule_monoidal_mathlib`): the associator α, left/right unitors λ,ρ, and braiding β of PShMod. Sheafification is a functor, hence carries each such presheaf-level natural transformation to a morphism of ShMod; these are the maps the local-isomorphism criterion above promotes to isomorphisms on locally free factors."

**Assessment**: The gap is closed. The origin of each structural map is now explicit (sheafification ∘ presheaf-level monoidal NatTrans from `PresheafOfModules.monoidalCategory`), and the local-iso argument is complete and correct. The inductive construction of μ is well-structured. `\uses` in the proof block covers all dependencies (`def:sheafTensorPow`, `def:sheafTensorObj`, `lem:presheafModule_monoidal_mathlib`, `lem:presheafModule_sheafification_mathlib`).

**Rendering issue (soon)**: `\PShMod` is used in the new paragraph but not defined. The chapter header defines `\PshMod` (lowercase s). Fix: replace `\PShMod` with `\PshMod` throughout the proof (three occurrences).

**Verdict**:
- **Complete**: true
- **Correct**: true
- **Hard gate**: PASS

---

### 2. `Picard_FlatteningStratification.tex` — `lem:gf_flat_locality_assembly` (G3)

**Prior must-fix**: two false steps — (i) source patches as a covering family of the base ring A_f; (ii) Γ(S,U) a localization of A_f for general affine U.

**New proof** (lines 1669–1727):

- **Step 1**: free ⟹ flat on each patch. Correct; free modules are flat.
- **Step 2**: pointwise flatness on p⁻¹(V). For x ∈ p⁻¹(V), the argument identifies the stalk F_x as a localization of the free A_f-module (M_j)_f and uses that O_{S,s} is a localization of A_f (since s ∈ D(f) = Spec A_f). This is correct.
- **Step 3**: base-maximal locality criterion. For maximal p ⊂ R = Γ(S,U) with U ≤ V, the local ring R_p = O_{S,x} is a localization of A_f (since x ∈ U ⊆ D(f)). This corrects the prior false step — the claim is about the local ring, not about R itself being a localization of A_f. Source reduction uses stalk-flatness over O_{S,p(y)} (from Step 2) together with Flat.trans (O_{S,x} → O_{S,p(y)} is a localization, hence flat).

Both false steps are gone. The proof correctly handles the reduction to local rings at maximal ideals.

**`\uses`**: `lem:gf_qcoh_fintype_finite_sections, lem:qcoh_section_localization_basicOpen` — both correct and needed.

**One transparency note** (not a must-fix): Step 3 source-reduction ends with "this source-side locality is the project-built geometric glue, no single Mathlib lemma ... being available." This flags an obligation for the prover to build a lemma showing module flatness over a local base is detected at source points. This is mathematically standard and the prover will formalize it; the blueprint is appropriately transparent that this is a project-built piece.

**Verdict**:
- **Complete**: true
- **Correct**: true
- **Hard gate**: PASS

---

### 3. `Picard_GrassmannianQuot.tex` — NEW chapter (full review)

**Declarations**: all five required declarations are present.

| Label | Lean target | `\uses` | Citation |
|-------|-------------|---------|----------|
| `def:gr_chart_quotient` | `Grassmannian.chartQuotientMap` | `def:gr_affine_chart, def:gr_universal_matrix` | Nitsure §1 L898-L910 ✓ |
| `def:gr_universal_quotient_sheaf` | `Grassmannian.universalQuotient` | `def:gr_chart_quotient, def:gr_universalMinorInv, def:gr_transition, lem:gr_cocycle, def:gr_glued_scheme` | Nitsure §1 L903-L910 ✓ |
| `def:tautological_quotient` | `Grassmannian.tautologicalQuotient` | `def:gr_universal_quotient_sheaf, def:gr_chart_quotient, def:gr_glued_scheme, def:gr_universalMinorInv, lem:gr_cocycle` | Nitsure §1 L908-L910 ✓ |
| `def:grassmannian_functor` | `Grassmannian.functor` | (none — standalone definition) | Nitsure §1 Exercise (2) L557-L564 ✓ |
| `thm:grassmannian_universal_property` | `Grassmannian.represents` | all of the above | Nitsure §1 L546-L566 ✓ |

All `\uses` labels resolve (verified by `leandag build --json`: `unknown_uses: []`). All depended-upon cells (`def:gr_affine_chart`, `def:gr_transition`, `lem:gr_cocycle`, `def:gr_glued_scheme`, etc.) are in `Picard_GrassmannianCells.tex` which is DONE axiom-clean (per project status).

**Citation discipline**: all five blocks have `% SOURCE: ... (read from references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex, L...)`, verbatim `% SOURCE QUOTE:`, and `\textit{Source: [Nitsure], ...}` first line. SOURCE QUOTES are verbatim from the Nitsure source (no paraphrasing detected). `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` exists on disk. Citation discipline PASS.

**Universal property proof adequacy** (`thm:grassmannian_universal_property`):
- Constructs T_I (open locus where I-minor is iso) via non-vanishing of determinant — correct.
- Covers by Nakayama — correct.
- On T_I: reads off φ_I : T_I → U^I from the d(r-d) free entries of M^I — correct; universal property of affine space.
- Gluing: M^J = (M^I_J)^{-1} M^I on T_I ∩ T_J — matches the bundle transition g_{I,J} — correct.
- Uniqueness: ψ = φ forced chart-by-chart — correct.
The proof is complete, correct, and sufficiently detailed for formalization.

**Rendering issues (soon)**:
1. `\quot` undefined (5 occurrences). Recommend `\providecommand{\quot}{\mathrm{Quot}}` at chapter top. (Nitsure uses `\Quot`; the chapter lowercases it.)
2. `\xhookrightarrow` undefined (1 occurrence in proof: `\mathcal{O}_T^d \xhookrightarrow{\iota_I}`). This is a `mathtools` macro. Recommend `\hookrightarrow` as fallback, or add `mathtools` to the preamble.

**No `\uses` on `def:grassmannian_functor`**: The prose references `\cref{def:quot_functor}` (from `Picard_QuotScheme.tex`) as an orientation remark, not as a logical dependency. Disposition: **keep** — the definition does not depend on `def:quot_functor` logically; the cross-reference is explanatory only.

**Verdict**:
- **Complete**: true
- **Correct**: true
- **Hard gate**: PASS

---

## Hard-gate summary table

| Chapter | Complete | Correct | Unresolved must-fix (math) | Gate |
|---------|----------|---------|---------------------------|------|
| `Picard_SectionGradedRing.tex` | true | true | none | **PASS** |
| `Picard_FlatteningStratification.tex` | true | true | none | **PASS** |
| `Picard_GrassmannianQuot.tex` | true | true | none | **PASS** |

---

## Per-chapter (non-focus, no changes)

- `Cohomology_FlatBaseChange.tex`: no changes since last review; verdict unchanged (covers FlatBaseChange.lean + FlatBaseChangeGlobal.lean; ongoing prover work).
- `Cohomology_RegroupHelper.tex`: clean, `lem:base_change_regroup_linearEquiv` leanok.
- `Picard_GrassmannianCells.tex`: DONE axiom-clean; all cells depended on by GrassmannianQuot verified present.
- `Picard_QuotScheme.tex`: covers QuotScheme.lean + GradedHilbertSerre.lean; no changes flagged this iter.
- `Picard_RelativeSpec.tex`: covers RelativeSpec.lean; no changes flagged this iter.

---

## Severity summary

- **soon (rendering-only, no hard-gate impact)**:
  - `Picard_SectionGradedRing.tex`: replace `\PShMod` → `\PshMod` in `lem:sheafTensorPow_add` proof (3 occurrences).
  - `Picard_GrassmannianQuot.tex`: define `\quot` as `\mathrm{Quot}` (5 occurrences); replace `\xhookrightarrow` with `\hookrightarrow` (1 occurrence).

## Unstarted-phase proposals

None — no strategy phases identified as zero-coverage from the set of chapters read.
