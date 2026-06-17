# blueprint-reviewer iter-012 report

**Agent:** blueprint-reviewer  
**Iteration:** 012  
**Date:** 2026-06-06  
**Directive:** `.archon/logs/iter-012/blueprint-reviewer-iter012-directive.md`

---

## 1. Tool summary

### leandag build

| Metric | Value |
|---|---|
| Blueprint nodes | 100 |
| Lean aux nodes | 18 |
| Proved (no sorry) | 72 |
| Mathlib-ok anchors | 18 |
| With sorry | 12 |
| Edges | 148 |
| Isolated nodes | 19 |
| `unknown_uses` | **0** |
| `effort_done` | 74 515 |
| `effort_remaining` | 48 922 |

`unknown_uses = 0` — all `\uses{}` labels resolve to real blueprint nodes. No dangling references.

**`unmatched_lean` (28 nodes):** All are either `\mathlibok` anchors (expected: Lean decl is in Mathlib, not in the project source tree) or blocked/stub nodes whose Lean declaration has not yet been created locally. Full list in §7.

**With-sorry nodes (12):**

| Node | Lean name | Phase |
|---|---|---|
| `lem:base_change_mate_section_identity` | `base_change_mate_section_identity` | FBC-A crux |
| `lem:affine_base_change_pushforward` | `affineBaseChange_pushforward_iso` | FBC-A |
| `thm:flat_base_change_pushforward` | `flatBaseChange_pushforward_isIso` | FBC-B |
| `thm:generic_flatness_algebraic` | `genericFlatnessAlgebraic` | GF-alg |
| `lem:gf_noether_clear_denominators` | `exists_localizationAway_finite_mvPolynomial` | GF-alg |
| `lem:gf_torsion_reindex` | `gf_torsion_reindex` | **GF-alg (this iter's target)** |
| `lem:gf_polynomial_core` | `exists_free_localizationAway_polynomial` | GF-alg |
| `thm:generic_flatness` | `genericFlatness` | GF-geo |
| `def:hilbert_polynomial` | `Scheme.hilbertPolynomial` | QUOT-defs |
| `def:quot_functor` | `Scheme.QuotFunctor` | QUOT-defs |
| `def:grassmannian_scheme` | `Scheme.Grassmannian` | QUOT-defs |
| `thm:grassmannian_representable` | `Scheme.Grassmannian.representable` | QUOT-repr |

All 12 are expected: they correspond to active-phase prover targets or downstream stubs awaiting upstream closes.

### blueprint-doctor

```
orphan_chapters: []
broken_refs:     []
malformed_refs:  []
axiom_decls:     []
covers_problems: []
```

Clean structural pass. All 6 chapters are included in `content.tex`. No undefined labels, no orphan chapters.

---

## 2. Per-chapter checklist

### 2.1 `Cohomology_RegroupHelper.tex`

| Field | Value |
|---|---|
| **complete** | true |
| **correct** | true |

**Declarations (1):**

| Label | Statement | Proof | Notes |
|---|---|---|---|
| `lem:base_change_regroup_linearEquiv` | `\leanok` | `\leanok` | Sole lemma; `\uses{lem:isPushout_cancelBaseChange_mathlib}` correctly references the FBC chapter's Mathlib anchor. |

**Findings:** None.

---

### 2.2 `Cohomology_FlatBaseChange.tex`

| Field | Value |
|---|---|
| **complete** | true |
| **correct** | mostly-true (3 should-fix NOTEs) |

**Declarations (34 total, counting all mathlibok anchors):**

All statements `\leanok`. Proof blocks `\leanok` except for the 3 active sorry nodes listed above (FBC-A/B frontier). Selected overview:

| Label | Statement | Proof `\leanok` | Notes |
|---|---|---|---|
| `def:pushforward_base_change_map` | ✓ | ✓ | |
| `lem:modules_isIso_iff_stalk` | ✓ | ✓ | |
| `lem:modules_isIso_of_isBasis` | ✓ | ✓ | |
| `lem:modules_isIso_iff_affineOpens` | ✓ | ✓ | |
| `lem:globalSectionsIso_hom_comp_specMap_appTop` | ✓ | ✓ | |
| `lem:gammaPushforwardIso` | ✓ | ✓ | |
| `lem:gammaPushforwardTildeIso` | ✓ | ✓ | |
| `lem:gammaPushforwardIsoAt` | ✓ | ✓ | |
| `lem:tildeRestriction_isLocalizedModule` | ✓ | ✓ | |
| `lem:powers_restrictScalars` | ✓ | ✓ | |
| `lem:fromTildeGamma_app_isIso_of_localized` | ✓ | ✓ | |
| `lem:pushforward_spec_tilde_iso_conditional` | ✓ | ✓ | |
| `lem:pushforward_spec_tilde_iso` | ✓ | ✓ | |
| `lem:gammaPushforwardNatIso` | ✓ | ✓ | |
| `lem:pullback_spec_tilde_iso` | ✓ | ✓ | |
| `lem:base_change_map_affine_local` | ✓ | ✓ | |
| `lem:pullbackSpecIso_mathlib` | ✓ (`\mathlibok`) | — | `AlgebraicGeometry.pullbackSpecIso` |
| `lem:cancelBaseChange_mathlib` | ✓ (`\mathlibok`) | — | `TensorProduct.AlgebraTensorModule.cancelBaseChange` |
| `lem:isPushout_cancelBaseChange_mathlib` | ✓ (`\mathlibok`) | — | `Algebra.IsPushout.cancelBaseChange` |
| `lem:pullback_fst_snd_specMap_tensor` | ✓ | ✓ | |
| `lem:base_change_mate_domain_read` | ✓ | ✓ | |
| `lem:base_change_mate_codomain_read` | ✓ | ✓ | |
| `lem:pullbackIsoEquivalenceOfIso` | ✓ | ✓ | |
| `lem:pullback_isEquivalence_of_iso` | ✓ | ✓ | |
| `lem:base_change_mate_regroupEquiv` | ✓ | ✓ | **SHOULD-FIX** (F-2a) |
| `lem:base_change_mate_section_identity` | ✓ | ✗ (sorry) | Active FBC-A crux |
| `lem:base_change_mate_generator_trace` | ✓ | ✓ | Conditionally proved (uses sorry-upstream) |
| `lem:pushforward_base_change_mate_cancelBaseChange` | ✓ | ✓ | Conditionally proved |
| `lem:flat_preserves_equalizer_mathlib` | ✓ (`\mathlibok`) | — | `LinearMap.tensorEqLocusEquiv` |
| `lem:affine_base_change_pushforward` | ✓ | ✗ (sorry) | Active FBC-A target |
| `thm:flat_base_change_pushforward` | ✓ | ✗ (sorry) | Active FBC-B target |

**Findings:**

- **(F-2a) SHOULD-FIX** — `lem:base_change_mate_regroupEquiv`, `% NOTE (iter-003)`: prose writes `R' ⊗_R A` but the Lean uses Mathlib's `A ⊗[R] R'` orientation (`pullbackSpecIso`'s orientation). The NOTE says "faithful re-orientation, no content change." The prose and Lean are describing the same module; the tensor convention mismatch could confuse a prover verifying the equality of the two orientations. No content fix needed — the NOTE is sufficient, but the prose should be updated to use the Lean-canonical orientation.

- **(F-2b) SHOULD-FIX** — `lem:pushforward_base_change_mate_cancelBaseChange` and `lem:base_change_mate_generator_trace` both have NOTEs stating the Lean decl formalizes the `IsIso` corollary rather than the full equality `Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹ = cancelBaseChange⁻¹`. The prose claims the full equality; the Lean type is narrower. For a prover trying to pattern-match against the blueprint, this is a potential confusion point. Should be fixed to state `IsIso` form in the prose statement block, with the equality relegated to the proof sketch.

- **(INFO)** — The `lem:base_change_mate_section_identity` proof block has no `\leanok` (as expected: sorry in progress). Its proof sketch is detailed and complete — sufficient for prover dispatch to FBC-A.

---

### 2.3 `Picard_FlatteningStratification.tex`

| Field | Value |
|---|---|
| **complete** | true |
| **correct** | true (1 must-fix on proved upstream lemma) |

**Declarations:**

| Label | Statement | Proof `\leanok` | Notes |
|---|---|---|---|
| `thm:generic_flatness_algebraic` | ✓ | ✗ (sorry) | Top-level GF-alg obligation |
| `lem:gf_finite_module` | ✓ | ✓ | |
| `lem:gf_torsion_base` | ✓ | ✓ | |
| `lem:gf_splice_shortExact_localized_exact` | ✓ | ✓ | |
| `lem:gf_splice_shortExact_free_transport` | ✓ | ✓ | |
| `lem:gf_splice_shortExact_split` | ✓ | ✓ | |
| `lem:gf_splice_shortExact` | ✓ | ✓ | |
| `lem:gf_clear_one_denominator` | ✓ | ✓ | |
| `lem:gf_noether_clear_denominators` | ✓ | ✗ (sorry) | Denominator-clearing loop (L4) |
| `lem:gf_generic_rank_ses` | ✓ | ✓ | |
| `lem:gf_torsion_annihilator` | ✓ | ✓ | |
| `lem:gf_nagata_monic_lastVar` | ✓ | ✓ | |
| `lem:gf_mvPolynomial_quotient_finite_monic` | ✓ | ✓ | **MUST-FIX** (F-3a) |
| `lem:gf_torsion_reindex` | ✓ | ✗ (sorry) | **This iter's prover target** |
| `lem:gf_polynomial_core` | ✓ | ✗ (sorry) | Nitsure §4 induction (L5) |
| `lem:gf_flat_finite` | ✓ | ✓ | |
| `lem:gf_free_moduleFinite` | ✓ | ✓ | |
| `thm:generic_flatness` | ✓ | ✗ (sorry) | Geometric form (GF-geo) |
| `lem:fp_free_descent` (`\mathlibok`) | — | — | `Module.FinitePresentation.exists_free_localizedModule_powers` |
| `lem:noeth_prime_filtration` (`\mathlibok`) | — | — | `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` |
| `lem:noether_normalization_fg` (`\mathlibok`) | — | — | `exists_finite_inj_algHom_of_fg` |
| `lem:annihilator_meets_nonZeroDivisors` (`\mathlibok`) | — | — | `Submodule.annihilator_top_inter_nonZeroDivisors` |
| `lem:polynomial_monic_quotient_finite` (`\mathlibok`) | — | — | `Polynomial.Monic.finite_quotient` |

**Findings:**

- **(F-3a) MUST-FIX** — `lem:gf_mvPolynomial_quotient_finite_monic`, `% NOTE (iter-011)`: the `% LEAN SIGNATURE` comment in the blueprint states the finiteness conclusion as `Module.Finite`, but the landed Lean declaration encodes it as `RingHom.Finite`. Math is unchanged (both express module-finiteness of a quotient ring as a module over the base), but the formal type is different. A prover for `lem:gf_torsion_reindex` that tries to `apply gf_mvPolynomial_quotient_finite_monic` and then discharge a `Module.Finite` goal will get a type error. The writer must update the `% LEAN SIGNATURE` comment to reflect `RingHom.Finite`. **This is a docs fix only — the math and the Lean proof are correct.**

- **(INFO)** — `lem:gf_polynomial_core` proof sketch is complete and detailed (strong induction on `d`, generalizing the base domain `A` into the motive). The proof structure note at lines 916–936 gives the Lean induction pattern explicitly.

- **(INFO)** — `thm:generic_flatness` geometric form (GF-geo) is fully blueprinted through lines 1044–1143. Proof sketch: restrict to non-empty affine `U₀ = Spec A`, apply `thm:generic_flatness_algebraic` on each patch of a finite affine cover, take `f = ∏ fⱼ`, use `Module.Flat.of_free`. Coherence encoding (`[IsQuasicoherent]` + `[IsFiniteType]`) documented with LEAN SIGNATURE header at lines 1052–1074. GF-geo blueprint is gate-ready for when GF-alg closes.

- **(INFO)** — 11 GenericFreeness lean_aux nodes (see §6) are internal helpers for the shared elimination engine — no blueprint obligation expected at this phase.

---

### 2.4 `Picard_GrassmannianCells.tex`

| Field | Value |
|---|---|
| **complete** | partial |
| **correct** | partial (2 must-fix findings) |

**Declarations (overview):**

| Label | Statement | Proof `\leanok` | Notes |
|---|---|---|---|
| `def:gr_cell_algebra` | ✓ | ✓ | |
| `def:gr_universal_minor` | ✓ | ✓ | |
| `def:gr_minor_det` | ✓ | ✓ | |
| `lem:gr_minorDet_unit` | ✓ | ✓ | |
| `def:gr_universalMinorInv` | ✓ | ✓ | |
| `lem:gr_universalMinorInv_identities` | ✓ | ✓ | |
| `def:gr_image_matrix` | ✓ | ✓ | |
| `def:gr_transition_pre` | ✓ | ✓ | |
| `lem:gr_transition_pre_unit` | ✓ | ✓ | |
| `def:gr_transition` | ✓ | ✓ | |
| `lem:gr_transition_self` | ✓ | ✓ | |
| `lem:gr_cocycle` | ✗ (no `\leanok`) | ✗ | **HARD GATE BLOCKER** (F-4a) |
| `def:gr_glued_scheme` | ✗ | ✗ | Depends on `lem:gr_cocycle` |
| `lem:gr_separated` | ✗ | ✗ | Depends on `def:gr_glued_scheme` |
| `lem:gr_proper` | ✗ | ✗ | Depends on `def:gr_glued_scheme` |
| `lem:mathlib_isUnit_iff_isUnit_det` (`\mathlibok`) | — | — | **MUST-FIX: isolated, see (F-4b)** |
| `lem:mathlib_away_algebraMap_isUnit` (`\mathlibok`) | — | — | Used by `lem:gr_minorDet_unit` ✓ |
| `lem:mathlib_nonsing_inv_mul` (`\mathlibok`) | — | — | Used by `lem:gr_universalMinorInv_identities` ✓ |
| `lem:mathlib_mul_nonsing_inv` (`\mathlibok`) | — | — | Used by `lem:gr_universalMinorInv_identities` ✓ |
| `lem:mathlib_away_lift` (`\mathlibok`) | — | — | Used by `def:gr_transition` ✓ |

**Findings:**

- **(F-4a) MUST-FIX / HARD GATE BLOCKER** — `lem:gr_cocycle` (`AlgebraicGeometry.Grassmannian.cocycleCondition`): blueprint has `\lean{...}` and a complete proof sketch, but **NO `% LEAN SIGNATURE` comment**. The exact ring-hom identity (localization rings, composition direction, how the two `IsLocalization.Away.lift` calls compose to form the cocycle) is ambiguous from the prose alone. A prover cannot determine the precise Lean type of `cocycleCondition` without a pinned signature. This blocks prover dispatch. **A writer must pin the `% LEAN SIGNATURE` before this chapter can pass the hard gate.**

- **(F-4b) MUST-FIX** — `lem:mathlib_isUnit_iff_isUnit_det` (`Matrix.isUnit_iff_isUnit_det`) is **isolated**: leandag confirms 0 edges (no incoming, no outgoing). It is not listed in the `\uses{}` of any blueprint node. The likely consuming node is `lem:gr_minorDet_unit` (which shows a matrix minor is a unit) or `lem:gr_universalMinorInv_identities`. The writer must inspect the Lean proof of these lemmas and either:
  - **wire-up**: add `lem:mathlib_isUnit_iff_isUnit_det` to the `\uses{}` of the consuming lemma; or  
  - **remove**: delete the `\mathlibok` node from the blueprint if `Matrix.isUnit_iff_isUnit_det` is not actually referenced.

- **(INFO)** — iter-011 issue #4 (stale `\uses{lem:mathlib_isUnit_iff_isUnit_det}` in `lem:gr_transition_pre_unit`) is **resolved**: leandag confirms `lem:gr_transition_pre_unit` does NOT use it. The residual problem is the isolation (F-4b above).

- **(INFO)** — 5 Grassmannian lean_aux nodes isolated (§6): all GR-cell implementation helpers. No blueprint obligation in the current phase (GR-repr is BLOCKED).

---

### 2.5 `Picard_QuotScheme.tex`

| Field | Value |
|---|---|
| **complete** | partial (SNAP/bridge-gated nodes expected) |
| **correct** | true for the proved portion; known gaps documented |

**Declarations (overview):**

| Label | Statement | Proof `\leanok` | Notes |
|---|---|---|---|
| `def:modules_annihilator` | ✓ | ✓ | Via `ofIdeals`; forward char bridge-gated |
| `lem:annihilator_localization_eq_map` | ✓ | ✓ | |
| `def:schematic_support` | ✓ | ✓ | |
| `def:has_proper_support` | ✓ | ✓ | |
| `def:is_locally_free_of_rank` | ✓ | ✓ | |
| `def:quot_functor` | ✓ | ✗ (sorry) | QUOT-defs stub |
| `def:grassmannian_scheme` | ✓ | ✗ (sorry) | QUOT-defs stub |
| `thm:grassmannian_representable` | ✓ | ✗ (sorry) | QUOT-repr stub; correctness gap (see F-5b) |
| `def:sectionGradedRing` | ✗ (no `\leanok`) | ✗ | Blocked: SheafOfModules tensor structure |
| `def:sectionGradedModule` | ✗ | ✗ | Blocked on `def:sectionGradedRing` |
| `lem:sectionGradedModule_fg` | ✗ | ✗ | Blocked on `def:sectionGradedRing` |
| `lem:gradedHilbertSerre_rational` | ✗ | ✗ | Project obligation; authorable (S2) |
| `thm:hilbertPoly_of_sectionModule` | ✗ | ✗ | Blocked on S1/S2/S3 |
| `def:hilbert_polynomial` | ✓ | ✗ (sorry) | `\uses{thm:hilbertPoly_of_sectionModule}` (unproved) |
| `lem:qcoh_section_localization_basicOpen` | ✗ | ✗ | Blocked on `isIso_fromTildeΓ_of_isQuasicoherent` sub-build |

**Findings:**

- **(F-5a) INFO** — `lem:gradedHilbertSerre_rational` (`AlgebraicGeometry.gradedModule_hilbertSeries_rational`): LEAN SIGNATURE pinned in the blueprint with Stacks 00K1 source. S2 authorable now (imports only Mathlib + graded encoding). Blueprint block is gate-ready for SNAP-S2 prover dispatch whenever the writer opens that lane.

- **(F-5b) INFO** — `thm:grassmannian_representable`: `\leanok` on statement, but the Lean type is `IsAffineHom (structureMorphism 𝒜)`, not `CategoryTheory.Functor.RepresentableBy`. The correctness gap is documented inline ("deferred to iter-180+"). Not a must-fix for current iters.

- **(F-5c) INFO** — No blueprint coverage for `isIso_fromTildeΓ_of_isQuasicoherent` sub-build. This is the gate for `lem:qcoh_section_localization_basicOpen` → forward annihilator characterization. See §8 (UP-1).

- **(F-5d) INFO** — Coverage debt: `annihilator_ideal_le`, `schematicSupportι` — 2 lean_aux nodes isolated (§6). Small helpers for proved QUOT predicates; no blueprint obligation until the predicate chain closes.

---

### 2.6 `Picard_RelativeSpec.tex`

| Field | Value |
|---|---|
| **complete** | true |
| **correct** | partial (known correctness gap on `thm:relative_spec_univ`) |

**Declarations:**

| Label | Statement | Proof `\leanok` | Notes |
|---|---|---|---|
| `def:qc_sheaf_of_algebras` | ✓ | ✓ | |
| `thm:relative_spec_exists` | ✓ | ✓ | |
| `def:relspec_structure_morphism` | ✓ | ✓ | |
| `thm:relative_spec_univ` | ✓ | ✓ | Correctness gap (F-6a) |
| `thm:relative_spec_affine_base` | ✓ | ✓ | |

**Findings:**

- **(F-6a) INFO** — `thm:relative_spec_univ`: Lean type is `IsAffineHom (structureMorphism 𝒜)`, but the blueprint claims `RepresentableBy`. Gap documented inline ("deferred to iter-180+"). No must-fix for current iters; relevant only when QUOT-repr needs the stronger form.

---

## 3. Hard gate verdicts

### 3.1 `Picard_FlatteningStratification.tex` → `gf_torsion_reindex`

**HARD GATE: PASS (conditional)**

| Criterion | Status |
|---|---|
| `complete` | true — `lem:gf_torsion_reindex` and all upstream sub-lemmas are blueprinted |
| `correct` | true — math is correct; LEAN SIGNATURE mismatch on upstream `gf_mvPolynomial_quotient_finite_monic` is documented (NOTE present) |
| No must-fix on target | true — F-3a is a must-fix on a **proved** upstream lemma, not on `gf_torsion_reindex` itself |

**Prover dispatch for `gf_torsion_reindex` is recommended.** The prover should be aware of F-3a: when invoking `gf_mvPolynomial_quotient_finite_monic`, use `RingHom.Finite` (the actual Lean type) not `Module.Finite` (as stated in the blueprint prose). The NOTE in the blueprint documents this.

**Must-fix before chapter can be marked fully correct:** Writer to update `% LEAN SIGNATURE` in `lem:gf_mvPolynomial_quotient_finite_monic` to reflect `RingHom.Finite`. This is a docs-only change, non-blocking for prover dispatch.

---

### 3.2 `Picard_GrassmannianCells.tex` → `lem:gr_cocycle` / `cocycleCondition`

**HARD GATE: BLOCKED**

| Criterion | Status |
|---|---|
| `complete` | false — `lem:gr_cocycle` has no `% LEAN SIGNATURE` pin |
| `correct` | partial — `lem:mathlib_isUnit_iff_isUnit_det` is isolated (F-4b); no must-fix on `lem:gr_cocycle` itself beyond the missing signature |
| No must-fix on target | false — F-4a is a must-fix directly on `lem:gr_cocycle` |

**Prover dispatch for `cocycleCondition` is BLOCKED.** A writer must:
1. Pin the `% LEAN SIGNATURE` for `lem:gr_cocycle` specifying the exact Lean type of `AlgebraicGeometry.Grassmannian.cocycleCondition` — the ring-hom identity relating `gr_transition I J ≫ gr_transition J K = gr_transition I K` via the two `IsLocalization.Away.lift` calls and the algebra maps between the affine big-cell rings.
2. Fix F-4b (`lem:mathlib_isUnit_iff_isUnit_det` isolation) before or concurrently.

After the writer completes step 1, a scoped re-review of `lem:gr_cocycle` alone suffices to unblock this gate.

---

## 4. Isolated DAG node triage (19 nodes)

### 4.1 Blueprint lemma node

| Node | Lean name | Disposition | Rationale |
|---|---|---|---|
| `lem:mathlib_isUnit_iff_isUnit_det` | `Matrix.isUnit_iff_isUnit_det` | **wire-up or remove** | Used nowhere in the blueprint (`\uses{}`). Writer must check Lean proof of `lem:gr_minorDet_unit` or `lem:gr_universalMinorInv_identities` for actual usage of this Mathlib lemma and add the `\uses{}` edge, or remove the node if genuinely unused. See F-4b. |

### 4.2 GenericFreeness lean_aux nodes (11)

All proved. These are internal implementation helpers for the shared elimination engine (`gf_mvPolynomial_quotient_finite_monic` and `gf_torsion_reindex`):

`T`, `T1`, `T_leadingcoeff_eq`, `degreeOf_t_ne_of_ne`, `degreeOf_zero_t`, `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`, `leadingCoeff_finSuccEquiv_t`, `lt_up`, `sum_r_mul_ne`, `t1_comp_t1_neg`

**Disposition: keep.** All private to the `GenericFreeness` namespace. No blueprint obligation expected until GF-alg closes (at which point a writer may choose to add blueprint coverage for the non-private helpers).

### 4.3 Grassmannian lean_aux nodes (5)

All proved:

`imageMatrix_submatrix_I`, `imageMatrix_submatrix_self`, `mul_submatrix_col`, `universalMatrix_map_transitionPreMap`, `universalMatrix_submatrix_self`

**Disposition: keep.** Implementation helpers for GR cells/transition maps. GR-repr is BLOCKED; no blueprint obligation in the current phase. Note: `mul_submatrix_col` is new since iter-011 (was not in the prior 4-item coverage debt list).

### 4.4 QuotScheme lean_aux nodes (2)

`annihilator_ideal_le`, `schematicSupportι`

**Disposition: keep.** Small helpers for the proved `def:modules_annihilator` / `def:schematic_support` predicates. Can be blueprinted when the predicate chain closes.

---

## 5. Coverage debt summary

| Chapter | Lean aux nodes (no blueprint) | Disposition |
|---|---|---|
| FlatteningStratification | 11 (GenericFreeness internals) | keep |
| GrassmannianCells | 5 (GR cell helpers) + 1 new (`mul_submatrix_col`) | keep |
| QuotScheme | 2 (`annihilator_ideal_le`, `schematicSupportι`) | keep |
| **Total** | **18** | |

No non-private, public-API lean_aux nodes are unblueprinted at this time. The 18 nodes are all internal namespace helpers.

---

## 6. Severity summary

### Must-fix (3)

| ID | Chapter | Finding |
|---|---|---|
| F-3a | FlatteningStratification | `lem:gf_mvPolynomial_quotient_finite_monic` `% LEAN SIGNATURE` states `Module.Finite` but Lean uses `RingHom.Finite`. Docs-only fix; non-blocking for `gf_torsion_reindex` prover dispatch but must be corrected before chapter is marked correct. |
| F-4a | GrassmannianCells | `lem:gr_cocycle` missing `% LEAN SIGNATURE` pin. **Hard gate blocker** for `cocycleCondition` prover dispatch. |
| F-4b | GrassmannianCells | `lem:mathlib_isUnit_iff_isUnit_det` isolated in DAG (0 edges). Writer must wire-up or remove. |

### Should-fix (3)

| ID | Chapter | Finding |
|---|---|---|
| F-2a | FlatBaseChange | `lem:base_change_mate_regroupEquiv` prose uses `R' ⊗_R A` orientation; Lean canonical is `A ⊗[R] R'`. Update prose to match Lean orientation. |
| F-2b | FlatBaseChange | `lem:pushforward_base_change_mate_cancelBaseChange` and `lem:base_change_mate_generator_trace` prose claims full equality; Lean formalizes `IsIso` corollary only. Update statement prose to match the `IsIso` form. |

### Info / known gaps (4)

| ID | Chapter | Finding |
|---|---|---|
| F-5b | QuotScheme | `thm:grassmannian_representable` correctness gap: `IsAffineHom` vs `RepresentableBy`. Deferred iter-180+. |
| F-5c | QuotScheme | No blueprint coverage for `isIso_fromTildeΓ_of_isQuasicoherent` sub-build (see UP-1). |
| F-6a | RelativeSpec | `thm:relative_spec_univ` correctness gap: `IsAffineHom` vs `RepresentableBy`. Deferred. |
| — | GrassmannianCells | `mul_submatrix_col` is a new lean_aux node (not in iter-011 coverage debt list of 4). Low priority. |

---

## 7. Unstarted-phase proposals

### UP-1: `isIso_fromTildeΓ_of_isQuasicoherent` QCoh bridge sub-build

**Status:** No blueprint coverage. No LEAN SIGNATURE. Referenced in STRATEGY.md as a "sizable new sub-build" and "Mathlib-gradient lane."

**Purpose:** Provides the QCoh→`IsLocalizedModule` bridge `lem:qcoh_section_localization_basicOpen` (`AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen`). This unlocks the forward annihilator characterization `(annihilator F).ideal U = Module.annihilator Γ(X,U) Γ(F,U)`, which in turn feeds the rank-`r` local-freeness predicate (QUOT-defs P2).

**Mathematical content:** For an affine scheme `X = Spec A`, a basic open `D(f)`, and a quasi-coherent sheaf `F`, the section module `Γ(F, D(f))` is the localization of `Γ(F, X)` at `f`. Equivalently: `isIso_fromTildeΓ_of_isQuasicoherent` states that the canonical map `tilde(Γ(F,X)) → F` is an isomorphism when `F` is quasi-coherent. Mathlib provides only the global-presentation form; the local `IsLocalizedModule` form requires a sub-build.

**Trigger:** Open this lane when QUOT-repr approaches (GR-cells/glue/quot phases begin) OR when the forward annihilator characterization is needed for the rank predicate. Not blocking any current-iter prover.

**Recommendation:** When the writer opens this lane, add a new blueprint section to `Picard_QuotScheme.tex` (or a dedicated `Picard_QCohBridge.tex`) with the sub-build's lemmas and `% LEAN SIGNATURE` pins before dispatching a prover.

**Estimated effort:** 3–5 iters, 80–200 LOC.

---

## 8. Cross-chapter notes

### FBC chain integrity

The FBC proof chain is logically complete: RegroupHelper → FlatBaseChange carries the full `cancelBaseChange`-based route from Stacks 02KH. The 3 sorry nodes (`section_identity`, `affine_base_change`, `flat_base_change`) are all in the proof bodies only (statements `\leanok`). `lem:base_change_mate_generator_trace` and `lem:pushforward_base_change_mate_cancelBaseChange` are conditionally proved (no sorry in their own proof bodies; relying on `section_identity` via the standard conditional chain).

### GF phase readiness

GF-alg: 5 sorry nodes (`generic_flatness_algebraic`, `gf_noether_clear_denominators`, `gf_torsion_reindex`, `gf_polynomial_core`, `generic_flatness`). Blueprint is complete through all of these including the GF-geo geometric form. After `gf_torsion_reindex` closes, the path to `gf_polynomial_core` and then `thm:generic_flatness_algebraic` is clear. The induction structure (generalizing `A` into the motive — `Nat.strong_induction_on d` with `A` reverted) is fully documented at lines 916–936.

### SNAP phase

S2 (`lem:gradedHilbertSerre_rational`) is authorable now: LEAN SIGNATURE pinned, Stacks 00K1 source documented. S1 and S3 are blocked on `def:sectionGradedRing` (SheafOfModules tensor structure). SNAP is not a separate chapter — it is embedded in `Picard_QuotScheme.tex`. No new chapter needed; the existing blueprint block at `lem:gradedHilbertSerre_rational` is gate-ready for S2 prover dispatch.

### QUOT-repr timeline

`def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` depend on `lem:gr_cocycle`, which is hard-gate BLOCKED (F-4a). GR-repr requires `thm:relative_spec_univ` strengthened to `RepresentableBy` (open strategic question per STRATEGY.md). No blueprint action needed for QUOT-repr until F-4a is resolved and the RelativeSpec gap is addressed.

### unmatched_lean recap

All 28 `unmatched_lean` nodes are accounted for:
- 9 in FlatBaseChange (4 Mathlib anchors + 5 that are Lean-local with no project decl — these are the `mathlibok` anchors whose Lean names are Mathlib-only)
- 5 in FlatteningStratification (Mathlib anchors)
- 4 in GrassmannianCells (3 Mathlib anchors + `lem:gr_cocycle`, `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` — unformalized GR nodes)
- 10 in QuotScheme (SNAP/bridge-blocked nodes + Mathlib anchors)

No `unmatched_lean` node is unexpected.

---

*End of report. Gate verdicts: FlatteningStratification → gf_torsion_reindex: **PASS**. GrassmannianCells → lem:gr_cocycle: **BLOCKED**.*
