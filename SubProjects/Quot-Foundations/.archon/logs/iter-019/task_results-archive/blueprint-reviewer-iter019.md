# Blueprint Reviewer Report — iter019

**Date:** 2026-06-06  
**Scope:** Whole-blueprint audit; three focus chapters with HARD-GATE verdicts requested.  
**Build status:** GREEN (blueprint-only edits, 0 broken `\uses` per leandag, blueprint-doctor clean).  
**leandag summary:** 210 blueprint nodes, 1 lean_aux node, 130 proved, 30 mathlib_ok, 11 with_sorry, 408 edges, 1 isolated (intentional: `finrank_comap_subtype`).

---

## Per-Chapter Checklist

| Chapter | complete | correct | Notes |
|---------|----------|---------|-------|
| Cohomology_RegroupHelper | YES | YES | 1 lemma + proof, both `\leanok`. Trivially complete. |
| Cohomology_FlatBaseChange | YES | YES | 5-link step-(iii) chain fills the iter-018 adequacy gap; `_eCancel` documents all 3 cancellation pairs. |
| Picard_FlatteningStratification | YES | YES | MUST-FIX resolved; L4 Steps 3a/3b/3c now adequately specified. |
| Picard_QuotScheme | YES (for SNAP-S2 target) | YES | ~18 new bespoke helpers all `\leanok`; 3 SNAP-S2 target proofs have adequate proof blocks; M2/M3/M4 corrections applied. |
| Picard_GrassmannianCells | MOSTLY | YES | 3 final-assembly declarations (`def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper`) lack `\leanok` despite GR-cells being listed as a completed phase. |
| Picard_RelativeSpec | YES (with acknowledged gap) | YES | Core construction done; `thm:relative_spec_univ` and `thm:relative_spec_affine_base` deliver weaker Lean types than prose, documented via `% NOTE` comments. |

---

## HARD-GATE Verdicts

### FlatBaseChange.lean — **GATE OPEN**

The iter-018 MAJOR adequacy gap (step-(iii) mechanism absent) is resolved. The 5-link chain:

```
_unitExpand → _gammaDistribute → _eCancel → _affineUnit → _innerMatch
```

provides the following atomic sub-lemmas for the `lem:base_change_mate_fstar_reindex_legs` step-(iii):

- `_unitExpand` (`\uses{pullbackPushforward_unit_comp}`): Expands the bare (g′)-unit as a 4-factor composite via the leg-reindex engine. Single mathematical move; adequate.
- `_gammaDistribute` (`\uses{_unitExpand}`): Distributes Γ functorially over the 4 factors. Single move; adequate.
- `_eCancel` (`\uses{_gammaDistribute, base_change_mate_codomain_read_legs, pullback_isEquivalence_of_iso, gammaMap_pushforwardComp_hom_eq_id}`): Cancels all three e-dependent factors against the three e-pieces of Θ_tgt^flat. **The three cancellation pairs are each explicitly stated in the proof block.** No further breakdown needed; the three pairs are distinct algebraic identities, each localized enough to be proved by a single `rw` + definitional unfolding.
- `_affineUnit` (`\uses{base_change_mate_unit_value, pushforward_spec_tilde_iso, _eCancel}`): Applies Seam 1 (`base_change_mate_unit_value`) to identify the result with restr_φ(η_M). Single Seam 1 invocation; adequate.
- `_innerMatch` (`\uses{def:base_change_mate_inner_value, base_change_mate_unit_value, _affineUnit}`): Definitionally identifies the composite with ρ. Single definitional rewrite; adequate.

All 5 are in `unmatched_lean` (expected — `\lean{}` hints present, no `\leanok` yet). The parent lemma `lem:base_change_mate_fstar_reindex_legs` retains `\leanok`. Full chain through Seam 3 and final assembly (`base_change_mate_section_identity`, `pushforward_base_change_mate_cancelBaseChange`, `affine_base_change_pushforward`, `flat_base_change_pushforward`) all retain `\leanok`.

**Verdict: chapter complete+correct, no must-fix. GATE OPEN for FBC-A fine-grained prover.**

---

### FlatteningStratification.lean — **GATE OPEN**

The iter-018 MUST-FIX (Step 3 of L4 under-specified) is fully resolved. The proof of `lem:gf_noether_clear_denominators` now contains three explicitly-expanded sub-steps:

- **Step 3a** — Comparison map ν: B_g → B_K via universal property of localization (g ≠ 0 in domain A → g invertible in K → B → B_K factors through B_g). Construction spelled out; adequate.
- **Step 3b** — Injectivity of φ: A_g[X_1,...,X_n] → B_g via algebraic-independence descent K → A_g (if P(b_j) = 0 in B_g, apply injective ν to get P^K(b̄_j) = 0 in B_K, contradicting alg. independence from Step 1). Argument complete; adequate.
- **Step 3c** — Module-finiteness of B_g over im(φ) via integral-dependence pushforward (each generator has monic integral-dependence equation over A_g[b_1,...,b_n] after inverting g; finite-type algebra integral over subalgebra is module-finite). Standard CM argument; adequate.

The GF dévissage chain (L1 → L2 → L3a/b/c → L4a → L4 → L5a → L5b mechanics → L5b.3 → L5b target → L5 → geometric form) is fully present. The OreLocalization instance-diamond note in L5 is correctly annotated as a Lean elaboration issue, not a blueprint gap.

**Verdict: chapter complete+correct, MUST-FIX resolved, no remaining must-fix. GATE OPEN for GF-alg prover.**

---

### QuotScheme.lean — **GATE OPEN (for SNAP-S2 induction target)**

The directive tasks the prover with `subquotient_finite_transfer` → `subquotient_hilbertSeries_rational` → `gradedModule_hilbertSeries_rational`. The chapter now provides:

**The ~18 new bespoke helper blocks, all `\leanok`:**

*Degree-raising endomorphism calculus (new):*  
`def:graded_raisesDegree`, `lem:graded_raisesDegree_mem`, `lem:graded_decompose_raisesDegree`, `lem:graded_decompose_raisesDegree_zero`, `lem:graded_comap_isHomogeneous`, `lem:graded_map_isHomogeneous`, `lem:graded_inf_isHomogeneous`, `lem:graded_sup_isHomogeneous`, `lem:graded_map_inf_degree_eq`, `lem:graded_sup_inf_degree_eq` — all `\leanok`.

*Kernel/cokernel closure lemmas (new):*  
`lem:graded_ker_isHomogeneous`, `lem:graded_coker_isHomogeneous`, `lem:graded_ker_le`, `lem:graded_coker_le`, `lem:graded_ker_annihilate`, `lem:graded_coker_annihilate`, `lem:graded_comap_map_le_of_commute`, `lem:graded_map_map_le_of_commute` — all `\leanok`.

*Polynomial ring module structure (new):*  
`def:graded_polyEndHom`, `lem:graded_polyEndHom_X`, `lem:graded_polyEndHom_C`, `def:graded_polyModule`, `lem:graded_polyModule_X_smul`, `lem:graded_polyModule_C_smul`, `lem:graded_polyModule_isScalarTower`, `def:graded_polySubmodule`, `lem:graded_polySubmodule_coe` — all `\leanok`.

*Other new bespoke blocks:*  
`def:graded_subquotientHilb` (with M4 `SubquotientDatum`/`.hilb` pins added), `lem:graded_homogeneousSubmodule_iSupIndep`, `lem:graded_homogeneousSubmodule_iSup_eq`, `lem:graded_subquotient_degreewise_diff`, `lem:graded_degreewise_finrank_diff`, `lem:graded_finiteDimensional_of_mvPolynomial_isEmpty_finite` — all `\leanok`.

**M2 fix confirmed:** `def:graded_subquotientHilb` finiteness condition now reads "the subquotient N/N' is a finite module over the polynomial ring κ[t_0,...,t_{r-1}] acting through the t_i (via the ambient t-stable carriers `polySubmodule N`, `polySubmodule N'` of `def:graded_polySubmodule`)." Correct form.

**M3 fix confirmed:** `lem:graded_subquotient_ker_coker` has no `\lean{}` pin. Comment explicitly states "no single Lean declaration — realised by the eight ambient component facts." Correct.

**M4 fix confirmed:** `def:graded_subquotientHilb` now carries three `\lean{}` pins: `subquotientHilb`, `SubquotientDatum`, `SubquotientDatum.hilb`.

**The three SNAP-S2 target proofs have adequate proof blocks:**

- `lem:graded_subquotient_finite_transfer` (lines 1604–1672): Complete proof via commutative adjoin + free polynomial surjection + `fg_restrictScalars_of_surjective_mathlib`. All three paragraphs are spelled out (polynomial module structure, transfer down one generator, why free polynomial ring). No `\leanok` yet — this is the prover's target.
- `lem:graded_subquotient_isRatHilb` (lines 1749–1815): Complete induction proof with explicit base case (r=0: eventually-zero → `ratHilb_ofEventuallyZero`) and inductive step (ker/coker closure → `ratHilb_ofDiffEq` + `ratHilb_bump`). No `\leanok` yet — prover's target.
- `lem:gradedHilbertSerre_rational` (lines 346–492): Complete proof via Veronese reduction + ambient subquotient induction at pair (⊤, ⊥). No `\leanok` yet — prover's target (assembly step).

**leandag / isolated count confirmation:** 0 broken `\uses`, 1 isolated node (`finrank_comap_subtype`, lean_aux, intentional), matching the directive's expected outcome.

**Verdict: chapter complete+correct for the SNAP-S2 prover lane, no must-fix. GATE OPEN for QuotScheme.lean subquotient_finite_transfer → subquotient_hilbertSeries_rational → gradedModule_hilbertSeries_rational prover.**

---

## Remaining Findings (Non-blocking)

### FINDING-Q1 (minor): Missing `\uses` edge in `def:graded_subquotientHilb`

**File:** `Picard_QuotScheme.tex`, line 955  
**Issue:** The finiteness condition in the body of `def:graded_subquotientHilb` references `def:graded_polySubmodule` (defined at line 1576, later in the same section), but the `\uses` field lists only `lem:graded_homogeneousSubmodule_iSupIndep` and `lem:graded_homogeneousSubmodule_iSup_eq`. The `def:graded_polySubmodule` dependency is not tracked in the DAG.  
**Severity:** Non-blocking. leandag reports 0 broken `\uses`, so no structural issue. The forward reference is within the same chapter. However, if `def:graded_polySubmodule` is ever refactored, this definition would not be flagged.  
**Fix (next iter):** Add `def:graded_polySubmodule` to the `\uses` of `def:graded_subquotientHilb`.

---

### FINDING-G1 (moderate): GR-cells final-assembly declarations lack `\leanok`

**File:** `Picard_GrassmannianCells.tex`, lines 1045, 1091, 1162  
**Issue:** `def:gr_glued_scheme`, `lem:gr_separated`, and `lem:gr_proper` all have `\lean{}` pins but no `\leanok`. Since `sync_leanok` is authoritative and these remain unmarked, they either have sorrys or are not yet implemented in `GrassmannianCells.lean`. STRATEGY.md lists GR-cells as a completed phase.  
**Severity:** Moderate. These declarations are consumed by `thm:grassmannian_representable` (which does carry `\leanok`, implying a weaker Lean implementation than the prose). Not blocking any of the three HARD-GATE chapters this iter. **But this finding should be addressed before QUOT-repr is unblocked.**  
**Fix (future iter):** Close the remaining sorrys in the gluing / separatedness / properness lemmas of `GrassmannianCells.lean`, then `sync_leanok` will add `\leanok`.

---

### FINDING-R1 (low): RelativeSpec Lean types weaker than prose

**File:** `Picard_RelativeSpec.tex`, lines 183–280, 285–365  
**Issue:** `thm:relative_spec_univ` has Lean type `IsAffineHom (structureMorphism 𝒜)` rather than the full `CategoryTheory.Functor.RepresentableBy` witness the prose states. `thm:relative_spec_affine_base` has Lean type `IsAffine (...)` rather than the canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`. Both gaps are explicitly documented via `% NOTE` comments with iter-174+/iter-180+ resolution targets.  
**Severity:** Low (intentionally deferred). Not blocking any current iter's prover gate.

---

## Unstarted-Phase Blueprint Proposals

### Proposal 1: FBC-B — Flat base change for pushforward (NEXT phase)

**Rationale:** FBC-A (flat base change for pullback along an affine map) is about to be closed. FBC-B covers the corresponding result for derived pushforward in the geometric (non-affine) setting.

**Blueprint work needed:**
- Extend `Cohomology_FlatBaseChange.tex` or create a sub-section `sec:fbc_pushforward` covering:
  - Statement of the flat base change theorem for Rf_* (Stacks 02KH), relating (Rf_*)_T and Rf_{T,*} via a comparison morphism.
  - A dependency on the derived category formulation or Čech cohomology approach.
  - The `affine_base_change_pushforward` already proved in the chapter is the affine input; the extension needs the global case via local-to-global spectral sequence or Čech-to-derived comparison.
- Estimated complexity: 1 iter of blueprint writing + 2–3 iters of prover time.

---

### Proposal 2: GF-geo — Geometric form of generic flatness (NEXT phase)

**Rationale:** GF-alg (algebraic form, L5 in `FlatteningStratification`) is about to be closed. GF-geo is the scheme-theoretic corollary: a coherent sheaf on a finite-type Z-scheme is flat over a dense open of the base.

**Blueprint work needed:**
- New section `sec:gf_geometric` in `Picard_FlatteningStratification.tex` or a new chapter `Picard_GenericFlatness_Geo.tex`:
  - `lem:gf_geometric_form`: given a noetherian scheme S and a coherent sheaf F on X → S of finite type, there exists a dense open U ⊆ S over which F is flat.
  - Proof outline: reduce to the affine case via affine open cover, apply L5 (polynomial_core) to the affine rings, glue the flat loci.
  - Dependency: `lem:gf_polynomial_core` → `lem:gf_geometric_form`.
- Estimated complexity: 0.5 iters of blueprint writing (proof is a direct application of L5) + 1–2 iters prover time.

---

### Proposal 3: SNAP-S1/S3 — Alternative Hilbert-Serre routes (NEXT, lower priority)

**Rationale:** The SNAP-S2 route (ambient subquotient induction, now blueprinted) avoids the graded quotient module isDefEq pathology. SNAP-S1 (direct power-series manipulation) and SNAP-S3 (via Euler characteristic and Serre vanishing) are fallback routes in case S2 encounters unexpected elaboration issues.

**Blueprint work needed for S1:**
- A thin section in `Picard_QuotScheme.tex` under `subsec:isRatHilb` demonstrating the alternative: given a rational Hilbert series p·(1-X)^{-d}, extract the polynomial by differentiation of the generating function. This is more computational but avoids the module-theoretic machinery.
- Low priority given S2 is now well-blueprinted.

**Blueprint work needed for S3:**
- A section outlining the Serre-vanishing shortcut: for m >> 0, H^i(X_s, F_s ⊗ L_s^m) = 0 for i > 0, so the Euler characteristic equals the h^0 Hilbert function. The polynomiality then follows from Snapper's lemma via a different route.
- Dependency: requires the higher coherent cohomology infrastructure (sheaf cohomology, Serre vanishing theorem in Mathlib) which is not yet available at the pinned commit. Low priority.

---

### Proposal 4: QUOT-repr — Quot scheme representability (BLOCKED, deferred)

**Current blocker:** `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` in `GrassmannianCells.tex` still lack `\leanok` (FINDING-G1). Also, `thm:relative_spec_univ` delivers only `IsAffineHom` rather than a `RepresentableBy` witness (FINDING-R1), which blocks the Grassmannian representability assembly `thm:grassmannian_representable`.

**Blueprint work needed (once unblocked):**
- A new chapter `Picard_QuotRepr.tex` covering:
  - Boundedness of flat quotients (Castelnuovo-Mumford regularity bound).
  - The Grassmannian-embedding construction: for large r, the evaluation map E_T → F gives a point of Grass(H^0(E_T(r)), Φ(r)).
  - Locally closed subfunctor argument: the Quot functor embeds as a locally closed subfunctor of the Grassmannian.
  - Representability by a projective scheme from the closed subfunctor of the proper Grassmannian.
- Prerequisites: close FINDING-G1, upgrade FINDING-R1 (iter-180+ plan), and close the SNAP-S2 prover lane (QuotScheme.lean).
- Estimated complexity: 3–5 iters of blueprint writing + multiple prover iters. BLOCKED until prerequisites are met.

---

## Summary

All three HARD-GATE chapters clear their gates this iter:

- **FlatBaseChange.lean**: GATE OPEN. 5-link step-(iii) chain is adequate, `_eCancel` has explicit pair documentation, no further breakdown needed.
- **FlatteningStratification.lean**: GATE OPEN. MUST-FIX resolved, L4 Steps 3a/3b/3c provide full injectivity + finiteness argument.
- **QuotScheme.lean**: GATE OPEN (for SNAP-S2 target). ~18 helper blocks `\leanok`, three SNAP-S2 target proofs have complete proof blocks, leandag `lean_aux`/isolated reduced to 1 (intentional).

Two non-blocking findings (FINDING-Q1 minor, FINDING-G1 moderate, FINDING-R1 low) are noted for future iters. None block the current prover dispatch.
