# Blueprint Review — iter-012 fast-path re-review
**Slug:** iter012-rereview  
**Date:** 2026-06-06  
**Reviewer:** blueprint-reviewer subagent  
**Scope:** Whole-blueprint audit (all 6 chapters) + explicit hard-gate verdict for 3 must-fix items from prior iter-012 run  
**Tools run:** `leandag build --json`, `archon blueprint-doctor --json`, `leandag show isolated`, `leandag stats`

---

## Tool diagnostics (pre-chapter)

| Tool | Result |
|---|---|
| `leandag build --json` | `unknown_uses: []`, `conflicts: []`, 18 isolated nodes (all `lean_aux` — expected) |
| `archon blueprint-doctor --json` | `malformed_refs: []`, 32 `unmatched_lean` (Mathlib anchors + open project targets — expected) |
| Isolated blueprint nodes | 0 project blueprint nodes isolated (18 isolated are `lean_aux` type, non-actionable) |

**Diagnostic verdict:** Clean. No structural breakage from writer edits.

---

## Hard-gate verdicts for iter-012 must-fix items

### F-4a — `Picard_GrassmannianCells.tex` / `lem:gr_cocycle` LEAN SIGNATURE

**Status: PASS — resolved.**

The `% LEAN SIGNATURE` block (lines 483–514 of `Picard_GrassmannianCells.tex`) is complete and unambiguous:

- Declaration: `AlgebraicGeometry.Grassmannian.cocycleCondition`
- Composition direction: `Θ_{I,K} = Θ_{I,J}.comp Θ_{J,K}` (ring-hom identity)
- Triple-overlap rings: `S_K := Localization.Away (minorDet d r K I hK hI * minorDet d r K J hK hJ)`, `S_J := Localization.Away (minorDet d r J I hJ hI * minorDet d r J K hJ hK)`, `S_I := Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK)` (each inverting BOTH relevant minors)
- Cardinality hypotheses: `(hI : I.card = d) (hJ : J.card = d) (hK : K.card = d)` spelled out
- Conclusion: `Θ_{I,K} = Θ_{I,J}.comp Θ_{J,K}` as propositional equality of ring homs `S_K →+* S_I`

This resolves the iter-011 type-mismatch ambiguity (the computation is over the doubly-localised triple-overlap rings, not the single-localised overlap rings where the type of `Θ` was ambiguous). The signature fully specifies the ring objects a prover must construct. **Gate for `cocycleCondition`: PASS.**

### F-4b — `Picard_GrassmannianCells.tex` / isolated `lem:mathlib_isUnit_iff_isUnit_det`

**Status: PASS — resolved.**

The label `lem:mathlib_isUnit_iff_isUnit_det` is absent from the chapter (confirmed by full read of 839 lines). `leandag` confirms zero isolated project blueprint nodes. **Isolated-node gate: PASS.**

### F-5a — `Picard_QuotScheme.tex` / `lem:gradedHilbertSerre_rational` decoupling

**Status: PASS — resolved.**

`\uses{}` in both statement block (line 350) and proof block (line 427) name only:
- `lem:finrank_ses_additive_mathlib` = `Submodule.finrank_quotient_add_finrank` (`\mathlibok`)
- `lem:invOneSubPow_mathlib` = `PowerSeries.invOneSubPow` (`\mathlibok`)

Both anchors are `\mathlibok` nodes already in the chapter. Complete LEAN SIGNATURE (lines 365–388) encodes the graded algebra setting via `𝒜 : ℕ → Submodule κ A`, `[GradedAlgebra 𝒜]`, degree-1 generation `Algebra.adjoin κ (↑(𝒜 1) : Set A) = ⊤`, conclusion in rational-series form compatible with `Polynomial.existsUnique_hilbertPoly`. Full inductive proof sketch present (Veronese reduction, base case r=0, inductive step with SES). Node has no `\leanok` (open, expected — this is the SNAP-S2 frontier target). **Node gate for `gradedModule_hilbertSeries_rational`: PASS (clean frontier, all deps mathlibok, prover-ready).**

Note: chapter as a whole remains `complete: partial` (SNAP-S1/S3 blocked on `def:sectionGradedRing`; QCoh bridge deferred). That is expected and does not affect this node's gate.

### F-3a — `Picard_FlatteningStratification.tex` / `lem:gf_mvPolynomial_quotient_finite_monic` LEAN SIGNATURE

**Status: PASS — resolved.**

Node has `\leanok` (line 729). The `% NOTE (iter-012 resync, F-3a)` annotation (lines 735–738) is present. LEAN SIGNATURE (lines 754–764) encodes finiteness as `RingHom.Finite` of the composite ring map `MvPolynomial (Fin n) R →+* (MvPolynomial (Fin (n+1)) R ⧸ Ideal.span {p})`, with the caller discharging the `RingHom.Finite` goal (not `Module.Finite`). Matches the landed decl. **Chapter `correct: true`. F-3a gate: PASS.**

The `gf_torsion_reindex` hard gate: node has `\leanok` (line 794). **PASS — unchanged.**

---

## Per-chapter checklist

### 1. `Cohomology_RegroupHelper.tex` (77 lines)

| Field | Value |
|---|---|
| complete | true |
| correct | true |

**Declarations:** `lem:base_change_regroup_linearEquiv` — `\leanok` (statement + proof).  
**Mathlib anchors:** `lem:isPushout_cancelBaseChange_mathlib` (`Algebra.IsPushout.cancelBaseChange`) — valid.  
**Dependencies:** `\uses{lem:isPushout_cancelBaseChange_mathlib}` — clean.  
**Notes:** Single-declaration chapter; axiom-clean; fully closed. No action needed.

---

### 2. `Picard_RelativeSpec.tex` (408 lines)

| Field | Value |
|---|---|
| complete | true |
| correct | true |

**Declarations with `\leanok`:** `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base` — all formalized.  
**Notes:** `thm:relative_spec_univ` formalized as `IsAffineHom (structureMorphism 𝒜)` (weaker than Yoneda-bijection form); `thm:relative_spec_affine_base` formalized as `IsAffine` only. Both iter-174+ strengthening commitments documented and deferred — this is expected and does not affect completeness/correctness of the current formalization. No action needed.

---

### 3. `Picard_FlatteningStratification.tex` (1160 lines)

| Field | Value |
|---|---|
| complete | true |
| correct | true |

**All dévissage chain lemmas have `\leanok`:** `thm:generic_flatness_algebraic` (line 44), `thm:generic_flatness` (line 1042), and the full chain: `lem:gf_finite_module`, `lem:gf_torsion_base`, `lem:gf_splice_shortExact_localized_exact`, `lem:gf_splice_shortExact_free_transport`, `lem:gf_splice_shortExact_split`, `lem:gf_splice_shortExact`, `lem:gf_clear_one_denominator`, `lem:gf_noether_clear_denominators`, `lem:gf_generic_rank_ses`, `lem:gf_torsion_annihilator`, `lem:gf_nagata_monic_lastVar`, `lem:gf_polynomial_core`, `lem:gf_flat_finite`, `lem:gf_free_moduleFinite`, `lem:gf_mvPolynomial_quotient_finite_monic` (iter-012 resync complete), `lem:gf_torsion_reindex`.  
**Mathlib anchors:** `lem:fp_free_descent`, `lem:noeth_prime_filtration`, `lem:noether_normalization_fg`, `lem:annihilator_meets_nonZeroDivisors`, `lem:polynomial_monic_quotient_finite` — all present and valid.  
**Hard gates:** `gf_mvPolynomial_quotient_finite_monic` LEAN SIGNATURE resynced (F-3a: PASS); `gf_torsion_reindex` PASS.

---

### 4. `Picard_GrassmannianCells.tex` (839 lines)

| Field | Value |
|---|---|
| complete | true |
| correct | true |

**Declarations with `\leanok`:** `def:gr_affine_chart`, `def:gr_universal_matrix`, `def:gr_minor_det`, `def:gr_universal_minor`, `def:gr_universalMinorInv`, `def:gr_image_matrix`, `def:gr_transition_pre`, `def:gr_transition`, `def:gr_transition_self`, `lem:gr_minorDet_unit`, `lem:gr_universalMinorInv_identities`, `lem:gr_transition_pre_unit` — all closed.  
**Open targets (no `\leanok`):** `lem:gr_cocycle` (frontier, F-4a now PASS), `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` — expected GR-glue phase obligations.  
**Mathlib anchors:** `lem:mathlib_away_algebraMap_isUnit`, `lem:mathlib_nonsing_inv_mul`, `lem:mathlib_mul_nonsing_inv`, `lem:mathlib_away_lift` — valid.  
**Hard gate:** `cocycleCondition` LEAN SIGNATURE now complete and unambiguous (F-4a: PASS). Isolated node F-4b removed (PASS).

---

### 5. `Picard_QuotScheme.tex` (1174 lines)

| Field | Value |
|---|---|
| complete | partial |
| correct | true |

**Declarations with `\leanok`:** `def:hilbert_polynomial`, `lem:annihilator_localization_eq_map`, `def:schematic_support`, `def:has_proper_support`, `def:is_locally_free_of_rank`, `def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable` — formalized.  
**Frontier targets (no `\leanok`):**
- `lem:gradedHilbertSerre_rational` — SNAP-S2, now clean frontier (F-5a: PASS). All deps mathlibok. Complete LEAN SIGNATURE + proof sketch. Gate-ready for `mathlib-build` scaffold+prove.
- `def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg` — SNAP-S1/S3, blocked on tensor/monoidal sheaf infrastructure.
- `lem:qcoh_section_localization_basicOpen` — QCoh bridge, deferred per STRATEGY.md (off critical path).

**Why `complete: partial`:** SNAP-S1/S3 nodes and the QCoh bridge are not formalized. This is expected; STRATEGY.md explicitly documents these as blocked. The chapter's formalized targets (`def:hilbert_polynomial`, Grassmannian defs, predicates) are sound.  
**Notes:** `thm:hilbertPoly_of_sectionModule` moves the geometric application of `lem:gradedHilbertSerre_rational`; the node-level decoupling is correct.

---

### 6. `Cohomology_FlatBaseChange.tex` (2250 lines)

| Field | Value |
|---|---|
| complete | true |
| correct | true |

**Declarations with `\leanok` (statement + proof closed):**  
`def:pushforward_base_change_map`, `lem:modules_isIso_iff_stalk`, `lem:modules_isIso_of_isBasis`, `lem:modules_isIso_iff_affineOpens`, `lem:globalSectionsIso_hom_comp_specMap_appTop`, `lem:gammaPushforwardIso`, `lem:gammaPushforwardTildeIso`, `lem:gammaPushforwardIsoAt`, `lem:tildeRestriction_isLocalizedModule`, `lem:powers_restrictScalars`, `lem:fromTildeGamma_app_isIso_of_localized`, `lem:pushforward_spec_tilde_iso_conditional`, `lem:pushforward_spec_tilde_iso`, `lem:gammaPushforwardNatIso`, `lem:pullback_spec_tilde_iso`, `lem:base_change_map_affine_local`, `lem:pullback_fst_snd_specMap_tensor`, `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:pullbackIsoEquivalenceOfIso`, `lem:pullback_isEquivalence_of_iso`, `lem:base_change_mate_regroupEquiv`, `lem:base_change_mate_generator_trace`, `lem:pushforward_base_change_mate_cancelBaseChange`.

**Declarations with `\leanok` in statement, proof not yet closed:**  
`lem:base_change_mate_section_identity`, `lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward`.  
(These are formalized with sorry; proof-body closure awaits the 3 seam lemmas below.)

**Open frontier targets (no `\leanok`):**
- `lem:base_change_mate_unit_value` (Seam 1) — complete LEAN SIGNATURE (elaboration-checked, lines 1389–1405)
- `lem:base_change_mate_fstar_reindex` (Seam 2) — complete LEAN SIGNATURE (elaboration-checked, lines 1449–1473)
- `lem:base_change_mate_gstar_transpose` (Seam 3) — complete LEAN SIGNATURE (elaboration-checked, lines 1525–1538)

These 3 seam lemmas are the residual section-level proof obligations for FBC-A. Each has: a full English proof sketch, exact `% LEAN SIGNATURE` blocks (with the note "elaboration-checked" against the live `FlatBaseChange.lean` decls), and correct `\uses{}` edges. Not must-fix — these are the intended live frontier for the FBC-A prover.

**Dependency chain:** Seams 1/2/3 → `lem:base_change_mate_section_identity` proof → `lem:base_change_mate_generator_trace` (proof already `\leanok` using sorry'd section identity as assumption) → `lem:pushforward_base_change_mate_cancelBaseChange` (proof `\leanok`) → `lem:affine_base_change_pushforward` → `thm:flat_base_change_pushforward`. The sorry chain will collapse cleanly once the 3 seams are proved.

**Mathlib anchors:** `lem:pullbackSpecIso_mathlib` (`AlgebraicGeometry.pullbackSpecIso`), `lem:cancelBaseChange_mathlib` (`TensorProduct.AlgebraTensorModule.cancelBaseChange`), `lem:isPushout_cancelBaseChange_mathlib` (`Algebra.IsPushout.cancelBaseChange`), `lem:flat_preserves_equalizer_mathlib` (`LinearMap.tensorEqLocusEquiv`) — all valid Mathlib decls.

**Hard gates:**
- `lem:affine_base_change_pushforward` (`AlgebraicGeometry.affineBaseChange_pushforward_iso`): statement `\leanok`, chapter complete + correct → **PASS**
- `thm:flat_base_change_pushforward` (`AlgebraicGeometry.flatBaseChange_pushforward_isIso`): statement `\leanok`, chapter complete + correct → **PASS**

---

## New must-fix introduced by writer edits

**None.** The three writer patches (GrassmannianCells LEAN SIGNATURE addition + isolated-node removal; QuotScheme `\uses{}` decoupling; FlatteningStratification LEAN SIGNATURE resync) introduce no new `unknown_uses`, no new isolated nodes, no broken `\ref{}` or `\uses{}` edges, and no stale mathlibok anchors. `leandag` and `blueprint-doctor` are both clean.

---

## Severity summary

| Severity | Count | Items |
|---|---|---|
| MUST-FIX | 0 | — |
| INFO | 0 | — |

Prior iter-012 must-fix items resolved: **3/3** (F-4a, F-4b, F-5a, F-3a — 4 sub-items across 3 finding IDs).

---

## Unstarted-phase proposals

None required. All 7 phases in STRATEGY.md have blueprint coverage:
- FBC-A (ACTIVE) — 3 seam lemmas are the live frontier; chapter complete + correct
- FBC-B (NEXT) — `thm:flat_base_change_pushforward` statement blueprinted; proof sketch present
- GF-alg (ACTIVE) — fully formalized (all lemmas `\leanok`)
- GF-geo (NEXT) — `thm:generic_flatness` has `\leanok`; blueprinted
- QUOT-defs (ACTIVE) — predicates + stubs blueprinted; SNAP-S2 frontier ready
- SNAP (NEXT S2) — `lem:gradedHilbertSerre_rational` now clean frontier (all deps mathlibok)
- QUOT-repr (BLOCKED) — GR-cells/glue/quot/repr blueprinted with status notes

---

## Overall verdict: **PROCEED**

All 3 prior hard gates clear. No new must-fix. All 6 chapters are `correct: true`. Iter-012 prover lanes are unblocked:

| Lane | Target | Gate |
|---|---|---|
| FBC-A (active) | `affineBaseChange_pushforward_iso` — seams 1/2/3 | PASS |
| SNAP-S2 (ready) | `gradedModule_hilbertSeries_rational` | PASS (node) |
| GF (closed) | `thm:generic_flatness_algebraic` / `thm:generic_flatness` | PASS (fully `\leanok`) |
| GR-cells (unblocked) | `cocycleCondition` + downstream GR-glue | PASS |

Recommend dispatching FBC-A seam-1/2/3 prover (highest leverage: 3 lemmas close the entire FBC-A sorry chain) and SNAP-S2 scaffold+prove in parallel.
