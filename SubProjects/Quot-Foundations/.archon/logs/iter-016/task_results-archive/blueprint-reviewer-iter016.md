# Blueprint Review — Iter-016 (Whole-Blueprint Audit)

**Reviewer:** blueprint-reviewer subagent  
**Date:** 2026-06-06  
**Scope:** All 6 chapters; iter-016 focus chapters (FBC, GF, QUOT); gate verdicts for prover dispatch

---

## Infrastructure checks

**blueprint-doctor:** Clean — no malformed refs, no undefined labels, no orphan chapters, no broken `\uses{}`, no axiom declarations.

**leandag build:** 167 nodes total, 0 unknown_uses, 0 isolated nodes, 0 conflicts. No broken `\uses{}` edges anywhere in the blueprint.

**Node summary by chapter:**

| Chapter | Nodes | Proved (`\leanok`) | Mathlib | Sorry | Unmatched lean |
|---|---|---|---|---|---|
| Cohomology_RegroupHelper | 1 | 1 | 0 | 0 | 0 |
| Cohomology_FlatBaseChange | 35 | 31 | 4 | 4 | 4 |
| Picard_FlatteningStratification | 40 | 0 | 7 | 5 | 10 |
| Picard_QuotScheme | 45 | 21 | 11 | 4 | 15 |
| Picard_GrassmannianCells | 41 | 34 | 4 | 0 | 4 |
| Picard_RelativeSpec | 5 | 5 | 0 | 0 | 0 |

40 unmatched-lean nodes total: nodes that carry a `\lean{}` pin but have no `lean_source` yet — these are either mathlib bridge anchors (awaiting `\mathlibok`) or active prover targets (awaiting formalization). All 40 are expected at this stage; none are spurious.

---

## Per-Chapter Verdicts

---

### Chapter: Cohomology_RegroupHelper.tex

```
complete: true
correct:  true
```

Single node `lem:base_change_regroup_linearEquiv`: fully proved (no sorry), statement and proof both `\leanok`, `\uses{lem:isPushout_cancelBaseChange_mathlib}` correct.  No findings.

---

### Chapter: Cohomology_FlatBaseChange.tex

```
complete: true
correct:  true
```

#### Node coverage
35 nodes total.  31 have `\leanok` on statements; 4 have sorry in proof bodies (the 4 active FBC-A prover targets):
- `lem:base_change_mate_fstar_reindex` (Seam 2)
- `lem:base_change_mate_gstar_transpose` (Seam 3)
- `lem:affine_base_change_pushforward`
- `thm:flat_base_change_pushforward`

#### Iter-016 focus: Seam 2/3 mechanism check

**Seam 2 (`lem:base_change_mate_fstar_reindex`):** `% RECIPE` comment names a 4-step concrete route:
1. Leg identification via `pullback_fst_snd_specMap_tensor`
2. Unit transport via `conjugateEquiv_pullbackComp_inv` + `unit_conjugateEquiv_symm`
3. Collapse of transparent coherences
4. Reduction to Seam 1 + codomain reconciliation

Dead end documented: "naive `rw`/`simp` with the leg equalities fails ('motive is not type correct')."  Mechanism is concrete and executable. **Confirmed.**

**Seam 3 (`lem:base_change_mate_gstar_transpose`):** `% RECIPE` comment names:
1. Counit split via `Adjunction.homEquiv_counit`
2. Conjugation by `Θ_src`/`Θ_tgt` using `pullback_spec_tilde_iso ψ`
3. Identification on generators as `regroupEquiv.inv`

Mechanism is concrete and executable. **Confirmed.**

#### Findings
None.  No must-fix items.

#### HARD GATE
**FBC-A prover dispatch: PASS.** Both Seam 2/3 proof sketches name concrete executable mechanisms. The 4 sorry nodes are expected skeleton state.

---

### Chapter: Picard_FlatteningStratification.tex

```
complete: true
correct:  true
```

#### Node coverage
40 nodes: 0 proved (no `\leanok` on statements — none yet formalized), 7 mathlib, 5 with sorry. All 5 sorry nodes are GF-alg prover targets:
- `thm:generic_flatness_algebraic`
- `lem:gf_noether_clear_denominators`
- `lem:gf_away_tower_descent` ← new this iter
- `lem:gf_polynomial_core`
- `thm:generic_flatness`

#### Iter-016 focus: Away tower descent check

**`lem:gf_away_tower_descent`:** `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}`, `\uses{lem:isLocalization_away_mul_of_associated, lem:module_free_of_ringEquiv}`.

Statement: given `(T_g)_h` free over `(A_g)_h`, descend to a single `T_f` free over `A_f` where `f := g·a` (single product, not a square).  Lean deps comment lists all required primitives.

This exactly matches the intended role described in the directive (iterated-Away-tower descent, single product witness).  **Confirmed.**

**`lem:gf_polynomial_core` Step 4:** "Descend the witness from `A_g` to `A`... by the iterated-`Away`-tower descent `lem:gf_away_tower_descent`. Set `f := g a ≠ 0` — the single product, not a square."  `\uses{}` in `lem:gf_polynomial_core` includes `lem:gf_away_tower_descent`.  Consistent with the helper statement.  **Confirmed.**

#### Findings
None.  No must-fix items.

#### HARD GATE
**GF-alg prover dispatch: PASS.**  New helper block is correctly stated and Step 4 is consistently repointed.

---

### Chapter: Picard_QuotScheme.tex

```
complete: true
correct:  true   (with one documented must-note, see below)
```

#### Node coverage
45 nodes: 21 proved, 11 mathlib, 4 with sorry.  4 sorry nodes (all have `\leanok` on statements — skeleton state):
- `def:hilbert_polynomial` — Snapper's lemma deferred
- `def:quot_functor` — functor definition skeleton
- `def:grassmannian_scheme` — Grassmannian functor-of-points definition skeleton
- `thm:grassmannian_representable` — representability proof skeleton (see must-note)

#### Iter-016 focus: Route 2 re-skeleton check

**Five new Route 2 blocks — verified complete and correct:**

**(a) `def:graded_subquotientHilb`**
- `\lean{AlgebraicGeometry.GradedModule.SubquotientHilb}` (or similar; in unmatched-lean, prover target)
- Statement: ambient subquotient pair `(N, N')` of homogeneous submodules of fixed `M`; endomorphisms `t₀,...,t_{r-1}` of degree 1; `Module.Finite` witness over `κ[t₀,...,t_{r-1}]`; Hilbert function `hilb(n) = dim_κ(N∩Mₙ) - dim_κ(N'∩Mₙ)`. Explicitly states no quotient-module/quotient-ring carrier is constructed.
- `\uses{}`: integrates G1 blocks `lem:graded_homogeneousSubmodule_iSupIndep`, `lem:graded_homogeneousSubmodule_iSup_eq`.
- Complete.

**(b) `lem:graded_subquotient_ker_coker`**
- `\lean{AlgebraicGeometry.GradedModule.subquotient_ker_coker}`
- Statement: sets `K = (N∩x⁻¹(N'), N')`, `C = (N, N'+x·N)`, verifies both are subquotient data of length r-1; `x` annihilates both subquotients; `K` represents ker(x) and `C` represents coker(x) on `N/N'`.  **No quotient/subtype carrier constructed.**
- `\uses{}`: correct — includes G1 blocks, `lem:ideal_homogeneous_span_mathlib`, `lem:isHomogeneousElem_graded_smul_mathlib`.
- Proof: complete informal proof (homogeneity, preservation, annihilation, identification with ker/coker).
- Complete and correct.

**(c) `lem:graded_subquotient_degreewise_diff` (D6)**
- `\lean{AlgebraicGeometry.GradedModule.subquotient_degreewise_diff}`
- Statement: `h_M(n+1) - h_M(n) = h_C(n+1) - h_K(n)`.  Source: Stacks Tag 00K1 (verbatim quote in `% SOURCE QUOTE` comment).  Specialisation note: `(N,N') = (⊤,⊥)` recovers the classical `0 → Mₙ →ˣ M_{n+1} → M_{n+1}/xMₙ → 0`.
- `\uses{}`: correct — includes D5 `lem:graded_degreewise_finrank_diff`, ker/coker block, G1 blocks, degree-shift.
- Proof: complete — kernel identification, cokernel via ambient identity, D5 application.
- Complete and correct.

**(d) `lem:graded_subquotient_finite_transfer`**
- `\lean{AlgebraicGeometry.GradedModule.subquotient_finite_transfer}`
- Statement: K and C are finite `κ[t₀,...,t_{r-2}]`-modules via `x = t_{r-1}` annihilation + `lem:fg_restrictScalars_of_surjective_mathlib`.
- `\uses{}`: correct — includes ker/coker block and the mathlib anchor.
- Proof: complete — Noetherian quotient argument + scalar restriction along `t_{r-1} ↦ 0`.
- Complete and correct.

**(e) `lem:graded_subquotient_isRatHilb`**
- `\lean{AlgebraicGeometry.GradedModule.subquotient_hilbertSeries_rational}`
- Statement: `IsRatHilb(hilb, r)` for any subquotient datum of length r.  Source: Stacks Tag 00K1 (verbatim quote).
- `\uses{}`: correct — includes all 4 new blocks + `lem:ratHilb_ofEventuallyZero`, `lem:ratHilb_ofDiffEq`, `lem:ratHilb_bump`.
- Proof: complete full induction — base r=0 (eventually-zero, `ratHilb_ofEventuallyZero`), inductive step r≥1 (ker/coker closure + finiteness transfer + D6 + `ratHilb_ofDiffEq` + `ratHilb_bump`).
- Complete and correct.

**`(⊤,⊥)` bridge:** `lem:gradedHilbertSerre_rational` proof instantiates the induction at `(N,N') = (⊤,⊥)`, yielding `hilb(n) = dim_κ(⊤∩Mₙ) - dim_κ(⊥∩Mₙ) = dim_κ Mₙ - 0 = dim_κ Mₙ`.  Correctly recovers the classical Hilbert function.  **Confirmed.**

**No dangling G2/G3/G4 refs:** leandag `unknown_uses = 0`.  Every `\uses{}` edge resolves to an existing label.  The deleted G2/G3/G4 blocks leave no dangling references.  **Confirmed.**

**`\lean{}` pins well-formed:** All 5 new blocks use the `AlgebraicGeometry.GradedModule.*` namespace; names are valid Lean 4 declaration identifiers matching the project's existing naming pattern.  Prover can create these without naming conflicts.  **Confirmed.**

#### Must-note (not a must-fix this iter)

**`thm:grassmannian_representable` Lean pin under-delivers:**  The prose statement asserts full representability — smooth projective S-scheme of relative dimension d(r-d), tautological rank-d quotient, Plücker embedding.  The `\lean{}` pin `AlgebraicGeometry.Scheme.Grassmannian.representable` currently points to a weaker existence skeleton (omits smoothness, relative dimension, tautological quotient, Plücker embedding).

This gap is explicitly documented in the chapter via a `% NOTE` comment (lines 1785-1796):  "The proof is blocked on either (a) strengthening `thm:relative_spec_univ` to deliver a RepresentableBy witness, or (b) finding a RepresentableBy-free argument via direct gluing of chart-wise classifying morphisms. This is a deferred open question."

The root cause is `thm:relative_spec_univ` in `Picard_RelativeSpec.tex`: current Lean type is `IsAffineHom (structureMorphism 𝒜)` (weaker), not a full `CategoryTheory.Functor.RepresentableBy` witness.  The RelativeSpec chapter itself documents this as "iter-174+ commitment; still pending iter-180+."

**Action for iter-017 QUOT prover:** The 5 new Route 2 blocks and the Quot/Grassmannian definition stubs are the clean prover targets.  `thm:grassmannian_representable`'s full proof is explicitly deferred; prover should not attempt to close it this iter and should note the mismatch.

#### Findings
- **Must-note (no blocker):** `thm:grassmannian_representable` `\lean{}` pin points to a skeleton that under-delivers the prose statement.  Chapter already documents this as a deferred open question.  No action required this iter.

#### HARD GATE
**QUOT iter-017 prover dispatch: CONDITIONAL PASS.**  All 5 Route 2 blocks are complete and correct; `(⊤,⊥)` bridge is in place; no dangling G2/G3/G4 refs; `\lean{}` pins are well-formed targets.  The `thm:grassmannian_representable` gap is documented and does not block the Route 2 prover work.

---

### Chapter: Picard_GrassmannianCells.tex

```
complete: true
correct:  true
```

#### Node coverage
41 nodes: 34 proved (all `\leanok` on statement and proof), 4 mathlib, **0 sorry**.  This chapter is effectively fully formalized at the blueprint level.

#### Content summary
Covers the complete GR-cells construction of Gr(r,d) over ℤ:
- Affine charts `U^I ≅ 𝔸^{d(r-d)}_ℤ`: `def:gr_affine_chart`, `def:gr_universal_matrix`, `def:gr_minor_det`, `def:gr_universal_minor`
- Cramer inverse chain (6 lemmas): `def:gr_universalMinorInv`, `lem:gr_minorDet_unit`, `lem:gr_universalMinorInv_identities`
- Image matrix and transition map: `def:gr_image_matrix`, `def:gr_transition_pre`, `lem:gr_transition_pre_unit`, `def:gr_transition`, `lem:gr_transition_self`
- Matrix bookkeeping helpers (6 lemmas): `lem:gr_mul_submatrix_col`, `lem:gr_map_nonsing_inv`, `lem:gr_map_map_eq_of_comp`, `lem:gr_inv_mul_inv_mul_cancel`, `lem:gr_universalMatrix_submatrix_self`, `lem:gr_imageMatrix_submatrix_self`, `lem:gr_imageMatrix_submatrix_I`, `lem:gr_universalMatrix_map_transitionPreMap`, `lem:gr_transitionPreMap_minorDet`, `lem:gr_imageMatrix_map_eq`
- Triple-overlap cocycle machinery: `def:gr_away_incl_left/right`, associated lemmas, `def:gr_cocycle_theta_ij/jk/ik`, `lem:gr_cocycle_imageMatrix_eq`
- Cocycle condition: `lem:gr_cocycle` — verified via image-matrix calculation `(X^I_K)^{-1}X^I = θ_{I,J}((X^I_J)^{-1}X^I)·context` with full cancellation argument
- Glued scheme + smoothness: `def:gr_glued_scheme`
- Separatedness: `lem:gr_separated` — diagonal cut out by `X^J_I X^I - X^J = 0`
- Properness: `lem:gr_proper` — via valuative criterion for DVRs (minimum-valuation chart selection)

All `\uses{}` chains verified by leandag.  Tautological quotient, Plücker embedding, and functor-of-points representability are correctly deferred to `Picard_QuotScheme.tex` (documented in "Out of scope" section).

#### Findings
None.

---

### Chapter: Picard_RelativeSpec.tex

```
complete: true
correct:  true
```

#### Node coverage
5 nodes, all proved (`\leanok` on both statement and proof), 0 sorry.

- `def:qc_sheaf_of_algebras` — QcohAlgebra 3-field structure with `NatTrans.Coequifibered` predicate (Mathlib commit b80f227 / Stacks 01LL)
- `thm:relative_spec_exists` — existence by gluing, proved via `AffineZariskiSite.relativeGluingData`
- `def:relspec_structure_morphism` — the projection π, proved directly
- `thm:relative_spec_univ` — universal property; current Lean type is `IsAffineHom (structureMorphism 𝒜)` (weaker than full Yoneda bijection); documented in `% NOTE` comment as "iter-174+ commitment; still pending iter-180+"
- `thm:relative_spec_affine_base` — affine-base case; current Lean type is `IsAffine` rather than canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`; documented similarly

The `thm:relative_spec_univ` Yoneda gap is the root cause of the `thm:grassmannian_representable` blocker noted above.  Both gaps are documented in their respective chapters.

#### Findings
None (documented gaps are known and tracked).

---

## Isolated / Unmatched-node triage

**Isolated nodes:** 0 (confirmed by leandag data; all nodes have at least one dependency or reverse-dependency edge).

**Unmatched-lean nodes:** 40 total.  All expected.  By category:

| Category | Count | Disposition |
|---|---|---|
| FBC mathlib anchors (`lem:pullbackSpecIso_mathlib`, `lem:cancelBaseChange_mathlib`, `lem:isPushout_cancelBaseChange_mathlib`, `lem:flat_preserves_equalizer_mathlib`) | 4 | `\mathlibok` to be added after Mathlib search; prover obligation: verify existence |
| GF mathlib/project anchors (`lem:fp_free_descent`, `lem:noeth_prime_filtration`, `lem:noether_normalization_fg`, `lem:annihilator_meets_nonZeroDivisors`, `lem:polynomial_monic_quotient_finite`, `lem:isLocalization_away_mul_of_associated`, `lem:module_free_of_ringEquiv`) | 7 | GF-alg prover targets or Mathlib bridge candidates |
| QUOT mathlib anchors (`lem:hilbertPoly_exists_mathlib`, `lem:finrank_ses_additive_mathlib`, `lem:invOneSubPow_mathlib`, `lem:isLocalization_basicOpen_mathlib`, `lem:submodule_isHomogeneous_mathlib`, `lem:ideal_homogeneous_span_mathlib`, `lem:finrank_range_add_finrank_ker_mathlib`, `lem:fg_restrictScalars_of_surjective_mathlib`, `lem:isHomogeneousElem_graded_smul_mathlib`) | 9 | `\mathlibok` to be added; known Mathlib declarations |
| QUOT definition targets (`def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg`, `thm:hilbertPoly_of_sectionModule`, `lem:gradedHilbertSerre_rational`) | 5 | QUOT prover targets |
| Route 2 new blocks (5 × `AlgebraicGeometry.GradedModule.*`) | 5 | QUOT prover targets — well-formed names |
| GR mathlib anchors (`lem:mathlib_away_algebraMap_isUnit`, `lem:mathlib_nonsing_inv_mul`, `lem:mathlib_mul_nonsing_inv`, `lem:mathlib_away_lift` — already `\mathlibok` in chapter, appearing as unmatched only because `lean_source` not in project) | 4 | Expected; `\mathlibok` already in chapter |
| Other (`lem:qcoh_section_localization_basicOpen`, `lem:annihilator_localization_eq_map`, plus GF items) | 6 | Mixed prover / mathlib targets |

No spurious unmatched nodes.  None require immediate action.

---

## Unstarted-phase proposals

### FBC-B: Globalization of flat base change (NO CHAPTER EXISTS)

**Phase:** FBC-B (NEXT in STRATEGY.md)  
**Coverage:** Zero blueprint nodes for FBC-B.

**Proposal:** Write `blueprint/src/chapters/Cohomology_FlatBaseChange_Global.tex` covering:
- Globalization of the affine FBC-A result to arbitrary quasi-compact quasi-separated morphisms (Stacks 02KH: "Flat base change for higher direct images")
- Reduction to the affine case via Čech cohomology or the Leray spectral sequence argument
- Key node: `thm:flat_base_change_pushforward` (currently in FBC chapter as the global theorem with sorry — this is the consumer)

The affine base change (`lem:affine_base_change_pushforward`) is the proved local case; the globalization argument (covering + descent) is the missing layer.  Without FBC-B, `thm:flat_base_change_pushforward` cannot be discharged.

---

### SNAP-S1: Snapper's Lemma (NO DEDICATED CHAPTER OR PROOF SKETCH)

**Phase:** SNAP-S1 (NEXT in STRATEGY.md)  
**Coverage:** `def:hilbert_polynomial` mentions Snapper's Lemma (polynomial-eventually property of Euler characteristics) but provides no proof sketch; the sorry in `def:hilbert_polynomial` blocks `thm:hilbertPoly_of_sectionModule`.

**Proposal:** Add a section (or standalone chapter `Cohomology_Snapper.tex`) with:
- Statement of Snapper's Lemma: for a coherent sheaf F on a projective scheme X, χ(F(n)) is eventually polynomial in n
- Source: Hartshorne III.5.2 / Nitsure §1 (already cited in `def:hilbert_polynomial`)
- Lean target: the existence assertion in `def:hilbert_polynomial` pointing at the polynomial-eventually witness

---

### GR-repr (full RepresentableBy): Yoneda upgrade for thm:relative_spec_univ (PARTIAL COVERAGE)

**Phase:** GR-repr (BLOCKED in STRATEGY.md)  
**Coverage:** `thm:grassmannian_representable` exists but proof is blocked on `thm:relative_spec_univ` Yoneda gap.

**Proposal:** The iter-174+ commitment (`thm:relative_spec_univ` upgraded to `CategoryTheory.Functor.RepresentableBy`) needs a blueprint proof sketch in `Picard_RelativeSpec.tex` mapping the current `IsAffineHom` proof to the full bijection witness.  This unblocks `thm:grassmannian_representable` full representability and the downstream GR-repr phase.

---

## Gate summary

| Chapter | complete | correct | Gate outcome |
|---|---|---|---|
| Cohomology_RegroupHelper | ✓ | ✓ | n/a |
| **Cohomology_FlatBaseChange** | **✓** | **✓** | **FBC-A prover: PASS** |
| **Picard_FlatteningStratification** | **✓** | **✓** | **GF-alg prover: PASS** |
| **Picard_QuotScheme** | **✓** | **✓\*** | **iter-017 QUOT prover: CONDITIONAL PASS** |
| Picard_GrassmannianCells | ✓ | ✓ | GR-cells: fully formalized (0 sorry) |
| Picard_RelativeSpec | ✓ | ✓ | RelSpec: fully formalized (0 sorry) |

\* QuotScheme: `thm:grassmannian_representable` Lean stub under-delivers prose statement.  Documented in chapter.  Does not block Route 2 prover work.  Iter-017 QUOT prover should target the 5 Route 2 blocks + `lem:gradedHilbertSerre_rational` + `thm:hilbertPoly_of_sectionModule` and explicitly skip `thm:grassmannian_representable` full proof.
