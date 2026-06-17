# Blueprint Reviewer Report — iter020

**Date:** 2026-06-06  
**Scope:** Whole-blueprint audit (all 6 chapters); gate-critical focus on `Picard_QuotScheme.tex`, confirmation focus on `Cohomology_FlatBaseChange.tex`.

---

## DAG health (leandag build --json)

| Metric | Value |
|---|---|
| blueprint\_nodes | 224 |
| lean\_aux\_nodes | 1 |
| proved | 135 |
| mathlib\_ok | 36 |
| with\_sorry | 12 |
| edges | 438 |
| isolated | 1 (lean\_aux, proved, effort 0 — benign) |
| conflicts | 0 |
| unknown\_uses | **0** |

**blueprint-doctor:** `orphan_chapters: []`, `broken_refs: []`, `malformed_refs: []`, `axiom_decls: []`, `covers_problems: []`.

All `\uses{}` edges resolve (`unknown_uses: []`). No orphan chapters. No new axioms. DAG is structurally clean.

The `unmatched_lean` list contains 44 entries. These split into:
- All 36 `\mathlibok` anchors (expected: Lean names in Mathlib, not in the project Lean scan).
- 8 project-level entries without `\mathlibok` that are either unformalized (`def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper`) or deferred future work (`def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg`, `thm:hilbertPoly_of_sectionModule`, `lem:qcoh_section_localization_basicOpen`).

---

## Chapter verdicts

### 1. Picard_QuotScheme.tex — GATE-CRITICAL

**`complete: true` | `correct: true`**

#### 1a. `lem:graded_subquotient_base_eventuallyZero` — newly written this iter

**Block completeness and correctness:** The proof sketches Route (b): the argument lives entirely inside Q₀'s κ-structure. For each degree n, the image of ψ\_n lands in the degree-n graded piece of Q₀ (a finite-dimensional κ-vector space). The family `(range(ψ_n))_{n : ℕ}` is iSupIndep: graded pieces of the ambient M are independent by the ambient `DirectSum.Decomposition`, and ψ\_n maps M\_n into Q₀\_n by construction, so independence of the ambient graded pieces pulls back to independence of the images. `finite_ne_bot_of_iSupIndep` (`lem:finite_ne_bot_of_iSupIndep_mathlib`) then yields finitely many n with non-zero image, giving eventual vanishing of the Hilbert function difference.

This is concrete and formalizable: it stays inside the ambient pair-of-submodules framework (no derived carrier/graded quotient ring), uses only κ-linear algebra on finite-dimensional pieces, and avoids the Route (a) scalar-ring incompatibility (Q₀ → M/N' would require a ring map κ → base ring that doesn't canonically exist).

The block correctly has **no `\leanok`** — it is the open leaf the prover will close this iter.

**`\uses{}` resolution:** Confirmed correct. `lem:graded_subquotient_base_eventuallyZero` references:
- `lem:finite_ne_bot_of_iSupIndep_mathlib`, `lem:mvPolynomial_isNoetherianRing_fin_mathlib`, `lem:isNoetherian_of_isNoetherianRing_of_finite_mathlib`, `lem:module_finite_of_surjective_mathlib`, `lem:module_finite_of_injective_mathlib`, `lem:submodule_liftQ_mathlib` (all `\mathlibok`, all resolve via `unknown_uses: []`)
- Finiteness-transfer infrastructure items (resolve correctly in DAG)

`lem:graded_subquotient_isRatHilb` (which has `\leanok`) correctly lists `lem:graded_subquotient_base_eventuallyZero` as a `\uses{}` dependency. The dependency arc base→inductive-step→keystone is intact.

#### 1b. Six `\mathlibok` anchors

All six are internally consistent:

| Node | Lean name | Status |
|---|---|---|
| `lem:finite_ne_bot_of_iSupIndep_mathlib` | `Submodule.finite_ne_bot_of_iSupIndep` | `\mathlibok`, in `unmatched_lean` (expected) |
| `lem:mvPolynomial_isNoetherianRing_fin_mathlib` | `MvPolynomial.isNoetherianRing_fin` | `\mathlibok`, in `unmatched_lean` |
| `lem:isNoetherian_of_isNoetherianRing_of_finite_mathlib` | `isNoetherian_of_isNoetherianRing_of_finite` | `\mathlibok`, in `unmatched_lean` |
| `lem:module_finite_of_surjective_mathlib` | `Module.Finite.of_surjective` | `\mathlibok`, in `unmatched_lean` |
| `lem:module_finite_of_injective_mathlib` | `Module.Finite.of_injective` | `\mathlibok`, in `unmatched_lean` |
| `lem:submodule_liftQ_mathlib` | `Submodule.liftQ` | `\mathlibok`, in `unmatched_lean` |

All six have prose statements consistent with the Lean names they cite. No integrity problems.

#### 1c. "Finiteness-transfer infrastructure" and "Subquotient constructors" subsubsections

- `def:graded_lastVarAlgHom`, `lem:graded_polyEndHom_mem_of_stable`, `lem:graded_polyEndHom_lastVar_sub_mem`, `lem:graded_polyQuot_finite_of_le_numerator`, `lem:graded_polyQuot_finite_of_le_denominator`: all lack `\leanok` (pending formalization by the prover). Their `\uses{}` edges resolve and reflect the correct mathematical dependencies.
- `def:graded_subquotientDatum_ker`, `def:graded_subquotientDatum_coker`: lack `\leanok`, correctly reflecting unformalized state.
- `lem:graded_subquotient_finite_transfer` (re-stated): correctly integrates the infrastructure nodes via `\uses{}`.
- Internal cross-references within the subsubsections are consistent.

**FYI (not gating):** `def:graded_lastVarAlgHom` carries `\label{lem:graded_lastVarAlgHom}` — a `lem:` prefix on a definition label. This is a minor naming inconsistency (def block with lem-prefixed label). No broken `\uses{}` result from this; labels are opaque to the blueprint engine. Clean in a future iter.

**Must-fix this iter:** NONE.

---

### 2. Cohomology_FlatBaseChange.tex — CONFIRMATION

#### No broken `\uses{}` after phantom deletion

`unknown_uses: []` confirms there are zero unresolved `\uses{}` references in the entire blueprint. The three deleted phantom blocks (`..._eCancel`, `..._affineUnit`, `..._innerMatch`) are absent from the file — confirmed by full read of all 2755 lines. No surviving block references those labels.

#### Live route is mathematically coherent

The section-level base-change mate is now derived from:

```
lem:base_change_mate_section_identity
  ↑ \uses{
      lem:base_change_mate_domain_read,
      lem:base_change_mate_codomain_read,
      lem:base_change_mate_gstar_transpose   ← CRUX
    }
```

The 3-seam approach (domain read + codomain read + gstar\_transpose counit factorization) is mathematically sound: the counit factorization of the (g\* ⊣ g\_\*)-adjunction avoids the opaque transpose that blocked the old route, and the section-level map is correctly identified as extension of scalars along ψ of the affine unit value. The prose is internally consistent.

`thm:flat_base_change_pushforward` has `\leanok`. `lem:base_change_mate_gstar_transpose` has `\leanok`. The `lem:base_change_mate_section_identity` block does NOT have `\leanok`, correctly reflecting that it is still open (it depends on the crux).

#### `lem:base_change_mate_gstar_transpose` is the live remaining crux

Confirmed: this is the only open `\uses{}` dependency between the proved top theorem and the rest of the live route. It is the next FBC prover target.

#### Residual FYI (not gating — handled next iter)

The superseded Seam-2 blocks (`lem:base_change_mate_fstar_reindex`, `..._legs`, `..._unitExpand`, `..._gammaDistribute`, `lem:base_change_mate_codomain_read_legs`) remain in the chapter with "Superseded." prose and their original `\lean{...}` names. These are dead code pending removal. They do not appear in any live `\uses{}` arc (confirmed by `unknown_uses: []`). No action this iter.

---

### 3. Cohomology_RegroupHelper.tex

**`complete: true` | `correct: true`**

Both the statement block and the proof block of `lem:base_change_regroup_linearEquiv` have `\leanok`. The `\uses{lem:isPushout_cancelBaseChange_mathlib}` dependency resolves correctly. The chapter is a clean standalone helper. No issues.

---

### 4. Picard_GrassmannianCells.tex

**`complete: false` | `correct: true`**

**What is done (28 decls, all GREEN per STRATEGY iter-012):**

The chart construction through cocycle is fully formalized:
- `def:gr_affine_chart`, `def:gr_universal_matrix`, `def:gr_minor_det`, `def:gr_universal_minor`, `lem:gr_minorDet_unit`, `def:gr_universalMinorInv`, `lem:gr_universalMinorInv_identities`, `def:gr_image_matrix`, `def:gr_transition_pre`, `lem:gr_transition_pre_unit`, `def:gr_transition`, `lem:gr_transition_self` — all have `\leanok`.
- The project-local matrix helpers (`lem:gr_mul_submatrix_col`, `lem:gr_map_nonsing_inv`, `lem:gr_map_map_eq_of_comp`, `lem:gr_inv_mul_inv_mul_cancel`, `lem:gr_universalMatrix_submatrix_self`, etc.) all have `\leanok`.
- Triple-overlap structure (`def:gr_away_incl_left/right`, `def:gr_cocycle_theta_ij/jk/ik`, `lem:gr_cocycle_imageMatrix_eq`) all have `\leanok`.
- `lem:gr_cocycle` (the cocycle condition) has `\leanok`.

**What is open:**

Three nodes in the "gluing/separated/proper" sections lack `\leanok` and appear in `unmatched_lean` (no Lean declarations found in project files):

| Node | Lean name | Status |
|---|---|---|
| `def:gr_glued_scheme` | `AlgebraicGeometry.Grassmannian.scheme` | No `\leanok`, unmatched_lean |
| `lem:gr_separated` | `AlgebraicGeometry.Grassmannian.isSeparated` | No `\leanok`, unmatched_lean |
| `lem:gr_proper` | `AlgebraicGeometry.Grassmannian.isProper` | No `\leanok`, unmatched_lean |

This is consistent with STRATEGY.md (GR-cells DONE, GR-glue phase BLOCKED/NEXT). The prose for these three blocks is mathematically correct and source-attributed (Nitsure §1). No action needed this iter; these are the GR-glue phase targets.

No broken `\uses{}` (`unknown_uses: []`).

---

### 5. Picard_RelativeSpec.tex

**`complete: true` | `correct: true`** (with noted prose/Lean-type gap — not a blueprint integrity issue)

All major declarations have `\leanok`:
- `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base` — all statement + proof blocks carry `\leanok`.

**FYI (not gating):** Both `thm:relative_spec_univ` and `thm:relative_spec_affine_base` carry `% NOTE (iter-179 review)` annotations documenting that the landed Lean type is weaker than the prose statement:
- `thm:relative_spec_univ`: Lean type = `IsAffineHom (structureMorphism 𝒜)`; prose claims full Yoneda-bijection `Functor.RepresentableBy` form. Upgrade deferred to iter-174+.
- `thm:relative_spec_affine_base`: Lean type = `IsAffine (...)`; prose claims canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`. Upgrade deferred to iter-180+.

These are accurately documented in the blueprint. The `\leanok` on the weaker Lean stubs is correct by the definition of `\leanok` (declaration exists with at most sorry). The discrepancy is known and tracked; it gates the QUOT-repr phase (see STRATEGY). No blueprint integrity problem.

No broken `\uses{}`.

---

### 6. Picard_FlatteningStratification.tex

**`complete: false` | `correct: true`**

**State of formalization:**

The devissage sub-lemmas (L1 `gf_torsion_base` through L5 `gf_polynomial_core`, plus the Nagata machinery and transport helpers) are all written with correct prose and source attribution. However, none of the main GF declarations carry `\leanok` in the blueprint. This is consistent with STRATEGY indicating GF-alg is ACTIVE with 1–2 iters remaining.

**Notable open items (per STRATEGY.md):**

- `thm:generic_flatness_algebraic`: top-level open (no `\leanok`). Assembly of the dévissage pending.
- `thm:generic_flatness`: geometric form, depends on algebraic (no `\leanok`).
- `lem:gf_noether_clear_denominators` (L4): two sub-pieces open — algebraic-independence descent for injectivity + module-finiteness Finset-fold.
- `lem:gf_polynomial_core` (L5): STRATEGY says "CLOSED iter-017" but blueprint lacks `\leanok`. Per the STRATEGY NOTE, a Lean OreLocalization instance-alignment issue (instance presentations on `(N ⧸ range φ)_g` are defeq but not instance-transparent-equal to what `gf_torsion_reindex` input expects) blocks the final assembly. The blueprint's missing `\leanok` may reflect either a stale sync_leanok state or the ongoing sorry — a prover dispatched to fix the instance-alignment issue should also trigger a fresh sync_leanok pass to update the marker.

The blueprint prose for all GF nodes is mathematically correct and internally consistent. `\uses{}` edges all resolve. No must-fix items.

---

## Severity summary

| Severity | Chapter | Item |
|---|---|---|
| **HARD GATE PASSED** | Picard_QuotScheme | `lem:graded_subquotient_base_eventuallyZero` is complete + correct. Prover may dispatch. |
| **HARD GATE PASSED** | Cohomology_FlatBaseChange | Route swap confirmed, no broken `\uses{}`, crux identified. No prover this iter. |
| FYI | Picard_QuotScheme | `def:graded_lastVarAlgHom` carries `\label{lem:...}` — lem-prefix on a def label. Harmless; clean next iter. |
| FYI | Cohomology_FlatBaseChange | Superseded Seam-2 blocks retain `\lean{...}` names (dead code). Remove next iter. |
| FYI | Picard_GrassmannianCells | `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` unformalized. Expected per STRATEGY (GR-glue phase). |
| FYI | Picard_RelativeSpec | `thm:relative_spec_univ` / `affine_base` prose claims stronger form than Lean type. Documented in `% NOTE`, deferred per STRATEGY. |
| FYI | Picard_FlatteningStratification | `lem:gf_polynomial_core` STRATEGY-CLOSED but lacks `\leanok`. Run sync_leanok after OreLocalization instance fix lands. |

---

## Cross-chapter view

The blueprint as a whole is structurally clean:
- `unknown_uses: []` — no dangling `\uses{}` anywhere.
- `orphan_chapters: []` — all 6 chapters are included in `content.tex`.
- `broken_refs: []` — no broken `\ref` or `\cref`.
- `axiom_decls: []` — no new axioms introduced.

The 12 open sorries are distributed across SNAP-S2 (`lem:graded_subquotient_base_eventuallyZero` and surrounding infrastructure), GF-alg (`gf_noether_clear_denominators` pieces, `genericFlatnessAlgebraic` assembly, L5 OreLocalization alignment), and possibly FBC. None of these block the gate-critical prover dispatch for QuotScheme this iter.

The single isolated node is a lean\_aux node (proved, effort 0) — benign.

---

*Generated by blueprint-reviewer subagent, iter020.*
