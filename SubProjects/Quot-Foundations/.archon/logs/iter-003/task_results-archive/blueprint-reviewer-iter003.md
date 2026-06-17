# Blueprint Review Report

## Slug
iter003

## Iteration
003

## Top-level summaries

### Proofs lacking detail

- `Picard_FlatteningStratification.tex` / `thm:generic_flatness` Step 4: names `Module.Flat.of_free` and `Module.flat_of_isLocalized_maximal` but does not show HOW `flat_of_isLocalized_maximal` bridges the per-patch freeness (one f_j per W_j) to fibrewise flatness of Γ(F,W) over Γ(S,U) for an ARBITRARY affine W ≤ p⁻¹(U) not necessarily equal to a single W_j. A prover targeting GF-geo will stall here. (Severity: **soon** — GF-geo is NEXT, not ACTIVE this iter.)

### Citation discipline

- `Picard_QuotScheme.tex` / `lem:functor_is_representable_mathlib`: prose says "`Functor.representableBy` produces the canonical witness". The actual Mathlib method name is `representableByEquiv`, not `representableBy`. The `\lean{}` reference (`CategoryTheory.Functor.IsRepresentable`) is correct; this is a prose inaccuracy in the expository description of the API, not a fabricated citation. (Severity: **informational** — QUOT has no active provers.)

### Dependency & isolation findings

- `Cohomology_FlatBaseChange.tex` / `lem:pullback_spec_tilde_iso`: proof text says "built by uniqueness of left adjoints ... packaged as a natural isomorphism (Lemma~\ref{lem:gammaPushforwardNatIso})" but neither the statement nor the proof `\uses{}` block lists `lem:gammaPushforwardNatIso`. As a result `lem:gammaPushforwardNatIso` has formal in-degree 0 (no `\uses{}` edge points to it). **wire-up** — add `\uses{lem:gammaPushforwardNatIso}` to the proof block of `lem:pullback_spec_tilde_iso`. (Severity: **soon** — `lem:pullback_spec_tilde_iso` is already `\leanok`; this does not block active prover work.)

---

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Picard_SNAP.tex`  
*(or: an expanded section in the queued QUOT rewrite)*

**Covers**: `AlgebraicJacobian/Picard/QuotScheme.lean` (SNAP sub-steps feeding `def:hilbert_polynomial`)  
**Strategy phase**: SNAP — graded Hilbert function → Hilbert polynomial  
**Why now**: SNAP is listed in the phase table as BLOCKED but its internal sub-steps (S1 Serre correspondence, S2 polynomial extraction) have ZERO blueprint declaration blocks; writing them now, even as a deferred chapter, enables a parallelisable prover route once FBC/GF land and QUOT unblocks.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:sectionGradedRing}` — the graded section ring `⊕_{m≥0} Γ(X_s, L_s^m)` as a graded commutative ring; its Lean carrier is a finite-type k(s)-algebra when L_s is ample. `\lean{AlgebraicGeometry.sectionGradedRing}` [expected]. Source: Nitsure §1 (`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`, §Stratification by Hilbert Polynomials); Hartshorne I.7.
2. `\definition` `\label{def:sectionGradedModule}` — the graded section module `⊕_{m≥0} Γ(X_s, F_s ⊗ L_s^m)` as a finitely-generated graded module over `def:sectionGradedRing`. `\lean{AlgebraicGeometry.sectionGradedModule}` [expected]. Source: Nitsure §1 (same subsection).
3. `\lemma` `\label{lem:sectionGradedModule_fg}` — finiteness: under the coherence + properness-of-support hypotheses on F and the ampleness of L, the section graded module is finitely generated over the section graded ring. This is the Serre correspondence (H⁰ only). `\lean{AlgebraicGeometry.sectionGradedModule_fg}` [expected]. Source: Nitsure §1 / Hartshorne III.5 (Serre vanishing + noetherianness of the section ring).
4. `\mathlibok` anchor `\label{lem:hilbertPoly_exists_mathlib}` — Mathlib's `Polynomial.existsUnique_hilbertPoly` (in `Mathlib.RingTheory.Polynomial.HilbertPoly`, **verified to exist**): for a finitely-generated graded module M over a Noetherian graded ring, there exists a unique polynomial P such that `dim_{κ(s)} M_m = P(m)` for all m ≫ 0. Carries `[CharZero]` on the coefficient field. `\lean{Polynomial.existsUnique_hilbertPoly}` `\mathlibok`.
5. `\theorem` `\label{thm:hilbertPoly_of_sectionModule}` — the Hilbert polynomial Φ_s is the unique polynomial agreeing with `m ↦ dim_{κ(s)} Γ(X_s, F_s ⊗ L_s^m)` for m ≫ 0; extracted by applying `lem:hilbertPoly_exists_mathlib` to `def:sectionGradedModule`. `\lean{AlgebraicGeometry.Scheme.hilbertPolynomialOfSectionModule}` [expected]. Source: Nitsure §1 / Mathlib.

**`\uses` skeleton**:
- `lem:sectionGradedModule_fg` uses `def:sectionGradedModule`, `def:sectionGradedRing`
- `def:sectionGradedModule` uses `def:sectionGradedRing`
- `thm:hilbertPoly_of_sectionModule` uses `lem:sectionGradedModule_fg`, `lem:hilbertPoly_exists_mathlib`
- `def:hilbert_polynomial` (in QUOT chapter) is then defined = Φ_s of `thm:hilbertPoly_of_sectionModule`

**Main theorem proof strategy**: Apply `Polynomial.existsUnique_hilbertPoly` (already verified in Mathlib) directly to the finitely-generated graded module `⊕_m Γ(F_s ⊗ L_s^m)` over the section ring, after establishing (S1) that this module is indeed finitely generated over a Noetherian graded ring (the section ring of L_s, Noetherian because L_s is ample and X_s is proper over a field). The `[CharZero]` hypothesis is satisfied by taking coefficients in ℚ. No higher cohomology is used.

**References for writer**:
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` → §1 "Stratification by Hilbert Polynomials", L453–L500 — source quotes for S1 (Serre correspondence) and the polynomial property
- Mathlib `Mathlib.RingTheory.Polynomial.HilbertPoly` — `Polynomial.existsUnique_hilbertPoly` signature (verified: `∃! p : ℚ[X], ∀ n, p.eval n = HilbertSerre_function n` over a CharZero field)
- `references/hartshorne-algebraic-geometry.pdf` → I.7 — textbook reference for Hilbert polynomial of a graded module (no text layer; cite via Nitsure §1 quotes only)

**Subphase choices exposed**:
- Placement: write SNAP as a standalone `Picard_SNAP.tex` vs. embed it as a new `\section{Graded Hilbert polynomial}` inside the queued rewrite of `Picard_QuotScheme.tex`. The queued QUOT rewrite is happening anyway (encoding pivot); embedding SNAP there avoids a thin standalone file. Recommendation: embed in the QUOT rewrite — saves a chapter file and keeps def:hilbert_polynomial in the same chapter as its construction.

---

### Proposed chapter: `blueprint/src/chapters/Picard_GrassmannianCells.tex`  
*(GR-cells + GR-glue decomposition of QUOT-repr)*

**Covers**: `AlgebraicJacobian/Picard/QuotScheme.lean` (GR-cells and GR-glue sub-phases of QUOT-repr)  
**Strategy phase**: QUOT-repr — `thm:grassmannian_representable` (sub-phases GR-cells, GR-glue)  
**Why now**: `thm:grassmannian_representable` currently has one monolithic proof block for a phase estimated at 6–12 iters; decomposing GR-cells and GR-glue into named lemmas now makes the first two sub-phases parallelisable and review-able when QUOT unblocks, and exposes the cocycle-condition obligation as a concrete prover target rather than a prose aside.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:gr_affine_chart}` — for each size-d subset I ⊆ {1,...,r}, the affine chart U^I := Spec(ℤ[X^I]) where X^I is the d×r matrix with identity d×d I-block and d(r-d) free entries; U^I ≅ 𝔸^{d(r-d)}_ℤ. `\lean{AlgebraicGeometry.Grassmannian.affineChart}` [expected]. Source: Nitsure §1 "Construction of Grassmannian" (`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`, L773–L810).
2. `\definition` `\label{def:gr_transition}` — for I ≠ J, the transition map θ_{I,J} : U^I_J → U^J_I defined by X^J ↦ (X^I_J)⁻¹ · X^I on the locus where det(X^I_J) ≠ 0. `\lean{AlgebraicGeometry.Grassmannian.transitionMap}` [expected]. Source: Nitsure §1, L810–L820.
3. `\lemma` `\label{lem:gr_cocycle}` — the transition maps satisfy the cocycle condition θ_{I,K} = θ_{J,K} ∘ θ_{I,J} on U^I ∩ U^J ∩ U^K. `\lean{AlgebraicGeometry.Grassmannian.cocycleCondition}` [expected]. Source: Nitsure §1; follows from associativity of matrix multiplication. The key Lean infrastructure is `AlgebraicGeometry.Scheme.GlueData.cocycle_cond`.
4. `\definition` `\label{def:gr_glued_scheme}` — the Grassmannian scheme Gr(r,d) over ℤ obtained by gluing {U^I}_{|I|=d} along {θ_{I,J}} using `Scheme.GlueData`. Smooth over ℤ of relative dimension d(r-d). `\lean{AlgebraicGeometry.Grassmannian.scheme}` [expected]. Source: Nitsure §1, L820–L830.
5. `\lemma` `\label{lem:gr_separated}` — Gr(r,d) is separated over ℤ: the diagonal Δ ↪ Gr(r,d) ×_ℤ Gr(r,d) is a closed immersion, checked on charts by X^J_I · X^I = X^J. `\lean{AlgebraicGeometry.Grassmannian.isSeparated}` [expected]. Source: Nitsure §1, L830–L840.
6. `\lemma` `\label{lem:gr_proper}` — Gr(r,d) is proper over ℤ: valuative criterion for DVRs, extending over the DVR by choosing the chart with minimal-valuation minor. `\lean{AlgebraicGeometry.Grassmannian.isProper}` [expected]. Source: Nitsure §1, L840–L860.

**`\uses` skeleton**:
- `def:gr_glued_scheme` uses `def:gr_affine_chart`, `def:gr_transition`, `lem:gr_cocycle`
- `lem:gr_separated` uses `def:gr_glued_scheme`, `def:gr_transition`
- `lem:gr_proper` uses `def:gr_glued_scheme`, `lem:gr_separated`
- `lem:gr_cocycle` uses `def:gr_transition`, `def:gr_affine_chart`

**Main theorem proof strategy**: The cells U^I are affine spaces; the cocycle condition is a matrix-algebra identity; the gluing uses `Scheme.GlueData`. Separatedness reduces to a diagonal equation on charts. Properness uses the valuative criterion: a map from Spec(K) to Gr(r,d) extends to Spec(R) by choosing the chart with minimal-valuation minor. Each step is elementary matrix algebra over a DVR.

**References for writer**:
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` → "Construction by gluing together affine patches", L773–L870 — verbatim source for all six declarations above
- Mathlib `AlgebraicGeometry.Scheme.GlueData` and `AlgebraicGeometry.AffineScheme.glueOpens` — the gluing backbone (exist and are used in RelativeSpec chapter already)
- retrieval needed: Nitsure §5 for the relative-Grassmannian base-change from ℤ to a general base S with vector bundle V — no local `references/` file covers §5 specifically

**Subphase choices exposed**:
- Working over ℤ first then base-changing to S with vector bundle V (Nitsure's approach) vs. working directly over an arbitrary S. Recommendation: work over ℤ first (exact Nitsure §1 route), then derive the relative version by base change — this keeps each GR-* sub-phase shorter and lets GR-cells/GR-glue land before GR-quot/GR-repr.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:gammaPushforwardNatIso` has formal in-degree 0 (nothing `\uses{}` it), but its proof text is referenced in `lem:pullback_spec_tilde_iso`. **wire-up** (soon): add `\uses{lem:gammaPushforwardNatIso}` to the proof block of `lem:pullback_spec_tilde_iso`. Does not block active provers (`lem:pullback_spec_tilde_iso` is `\leanok`).
  - **`\mathlibok` verification** — all three anchors verified to exist in Mathlib:
    - `AlgebraicGeometry.pullbackSpecIso` ✓ (`Mathlib/AlgebraicGeometry/Pullbacks.lean`); companion forms `_hom_fst`, `_hom_snd`, `_inv_fst`, `_inv_snd` all present ✓
    - `TensorProduct.AlgebraTensorModule.cancelBaseChange` ✓ (`Mathlib/LinearAlgebra/TensorProduct/Tower.lean`); `cancelBaseChange_tmul` and `cancelBaseChange_symm_tmul` verified ✓
    - `LinearMap.tensorEqLocusEquiv` ✓ (`Mathlib/RingTheory/Flat/Equalizer.lean`) ✓
  - The decomposed 4-lemma chain (`lem:pullback_fst_snd_specMap_tensor`, `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:base_change_mate_generator_trace`) is mathematically sound: each sub-lemma's `\uses{}` covers its real dependencies, the chain assembles correctly into `lem:pushforward_base_change_mate_cancelBaseChange`, and `cancelBaseChange` closes the iso with no flatness hypothesis. Chain is ready for prover dispatch.

---

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **`\mathlibok` verification** — all three anchors verified:
    - `Module.FinitePresentation.exists_free_localizedModule_powers` ✓ (`Mathlib.RingTheory.Localization.Free`); signature matches blueprint's description (f.g. presented R-module, free at localization S, yields r ∈ S with M_r free of the same rank) ✓
    - `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` ✓ (`Mathlib.RingTheory.Ideal.AssociatedPrime.Finiteness`); three cases (`subsingleton`, `quotient` for A⧸p, `exact` for short exact sequences) match blueprint's description ✓
    - `exists_finite_inj_algHom_of_fg` ✓ (`Mathlib.RingTheory.NoetherNormalization`) ✓
  - The dévissage chain (`lem:gf_torsion_base` → `lem:noeth_prime_filtration` + `lem:gf_splice_shortExact` → `lem:gf_noether_clear_denominators` → `lem:gf_polynomial_core` → `lem:gf_finite_module`) is mathematically sound. Each sub-lemma's `\uses{}` covers its real dependencies. Chain bottoms out correctly at the `\mathlibok` leaf `lem:fp_free_descent`. Ready for GF-alg prover dispatch.
  - `thm:generic_flatness` Step 4 (GF-geo, NEXT phase): names `Module.Flat.of_free` ✓ (verified in Mathlib) and `Module.flat_of_isLocalized_maximal` ✓ (verified in Mathlib at `Mathlib.RingTheory.Flat.Localization`), but does not spell out how `flat_of_isLocalized_maximal` connects per-patch freeness to fibrewise flatness for arbitrary affine W ≤ p⁻¹(U). **proofs lacking detail** (soon): add a sentence or two explaining the localize-at-maximal-ideals application before GF-geo prover dispatch.
  - Supporting helpers `lem:gf_flat_finite` and `lem:gf_free_moduleFinite` are correctly stated and provide the flatness/module-finiteness packaging of `lem:gf_finite_module` needed by the chain and globalization.

---

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **Encoding pivot (must-fix, writer rewrite queued)**: `def:hilbert_polynomial` prose describes the cohomological χ form (∑(-1)^i dim H^i(X_s, F_s⊗L_s^m)), but the ENCODING PIVOT comment (present in the blueprint) mandates the graded Hilbert function encoding via `Polynomial.existsUnique_hilbertPoly`. The two encodings agree for m≫0 but the χ form requires higher cohomology (Hⁱ, i>0), breaking the Čech-independent leg. The `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` stub exists with `\leanok` but the formal signature needs re-alignment. This divergence makes the chapter `complete: partial` (SNAP sub-steps absent as declaration blocks) and `correct: partial` (prose describes the wrong encoding for the formal target). **Must-fix: dispatch writer for QUOT rewrite (graded encoding + SNAP sub-steps) before any QUOT prover work.** QUOT is gated behind FBC/GF and has no active provers this iter; this finding does NOT block FBC-A or GF-alg prover dispatch.
  - `lem:functor_is_representable_mathlib`: `\lean{CategoryTheory.Functor.IsRepresentable}` ✓ (verified in Mathlib at `Mathlib.CategoryTheory.Yoneda`); `CategoryTheory.Functor.reprX` ✓. Prose name `Functor.representableBy` is a slight misnaming (actual Mathlib method is `representableByEquiv`); informational finding.
  - `thm:grassmannian_representable`: proof sketch covers cells + gluing + properness + universal quotient in one block — adequate as a high-level strategy description, but no named sub-lemma declaration blocks for GR-cells/GR-glue/GR-quot/GR-repr. The decomposition into sub-phases (per STRATEGY) is unblueprinted. **Proposal provided above.**
  - `def:quot_functor`, `def:grassmannian_scheme`, `thm:relative_spec_exists`, `thm:relative_spec_univ` `\uses{}` in `thm:grassmannian_representable`: correct cross-chapter edges; the dependency on RelativeSpec universal property is flagged as blocked (NOTE in chapter) pending the RepresentableBy upgrade.

---

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:relative_spec_univ` and `thm:relative_spec_affine_base`: blueprint prose describes the full Yoneda-bijection / canonical-iso form, but Lean currently has the weaker `IsAffineHom (structureMorphism A)` and `IsAffine (...)` respectively. Both discrepancies are documented in `% NOTE` blocks in the chapter and in STRATEGY.md open questions. Since RelativeSpec is not an active prover target (all blocks are `\leanok` with real proofs) and the upgrade is deferred pending a STRATEGY decision on QUOT-repr's RepresentableBy route, these are **informational** findings only — not must-fix.
  - No `\mathlibok` anchors to verify.

---

## Severity summary

### Must-fix-this-iter

1. **`unstarted-phase proposal: SNAP`** — SNAP phase has zero blueprint declaration blocks for its internal steps (S1 Serre correspondence, S2 `existsUnique_hilbertPoly` extraction). Dispatch blueprint-writer for SNAP (embedded in the queued QUOT rewrite per the proposal above) or record explicit deferral rationale in `iter/iter-003/plan.md`. SNAP is BLOCKED but writing the blueprint early costs nothing and enables future parallelism.

2. **`unstarted-phase proposal: QUOT-repr decomposition (GR-cells + GR-glue)`** — `thm:grassmannian_representable` is a single monolithic block for a 6–12 iter BLOCKED phase. Dispatch blueprint-writer for GR-cells/GR-glue (standalone chapter `Picard_GrassmannianCells.tex` per the proposal above) or record deferral rationale.

3. **`Picard_QuotScheme.tex` — must-fix writer rewrite** — Chapter is `complete: partial` and `correct: partial` due to the encoding pivot on `def:hilbert_polynomial`. Dispatch the queued blueprint-writer for the graded encoding rewrite (already identified as a queued task in the strategy). **Does not block FBC-A or GF-alg prover dispatch** (QUOT has no active provers; per the directive, this divergence is not treated as a blocker for FBC/GF).

### Soon

1. `Cohomology_FlatBaseChange.tex` / `lem:pullback_spec_tilde_iso`: **wire-up** — add `\uses{lem:gammaPushforwardNatIso}` to its proof block. `lem:pullback_spec_tilde_iso` is already `\leanok`; no active prover at risk.

2. `Picard_FlatteningStratification.tex` / `thm:generic_flatness` Step 4: **proofs lacking detail** — flesh out the `Module.flat_of_isLocalized_maximal` application (how per-patch freeness → fibrewise flatness for arbitrary affine opens) before GF-geo prover dispatch. GF-geo is NEXT; not urgent for this iter.

### Informational

1. `Picard_QuotScheme.tex` / `lem:functor_is_representable_mathlib` prose: `Functor.representableBy` should be `representableByEquiv` (Mathlib name). The `\lean{}` reference is correct.

2. `Picard_RelativeSpec.tex` / `thm:relative_spec_univ`, `thm:relative_spec_affine_base`: prose/type drift is documented in NOTEs; no active prover impact.

---

Overall verdict: FBC and GF chapters clear the HARD GATE — FBC-A and GF-alg provers may be dispatched; QUOT is `partial` on both axes (encoding pivot, no active provers) and requires a writer rewrite; 2 phases (SNAP, QUOT-repr GR-decomposition) have no blueprint declaration blocks — proposals provided for immediate writer dispatch or plan-agent deferral.
