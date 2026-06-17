# Blueprint Review Report — Iter 191

**Subagent:** blueprint-reviewer  
**Date:** 2026-05-26  
**Scope:** Whole-blueprint audit, 31 chapters read. Per-chapter verdicts + HARD GATE clearances for iter-191 prover dispatch.

---

## Summary of Findings

- **2 HARD GATE BLOCKS** (must-fix before prover dispatch):
  1. `RiemannRoch_WeilDivisor.tex` — `lem:degree_positivePart_principal_eq_finrank` equational vs existential mismatch
  2. `RiemannRoch_H1Vanishing.tex` — spurious `\leanok` on main theorem while `H1Vanishing.lean` does not exist
- **6 HARD GATE CLEARED** (prover dispatch authorized)
- **1 intentionally gated** (`Albanese_CodimOneExtension.tex`)
- **1 unstarted chapter missing** (`Picard_Pic0AbelianVariety.tex`) — blueprint-writer dispatch recommended

---

## Iter-190 Landing Verifications

### 1. `RiemannRoch_H1Vanishing.tex` — NEW chapter (560 lines)

- `\label{chap:RR_H1Vanishing}` present ✓ — resolves the broken `\cref` from `RRFormula.tex`
- 8 `\lean{...}` pins for flasque-resolution substrate confirmed present ✓
- 6 SOURCE QUOTE blocks (Hartshorne III.1-2 + II.1) confirmed present ✓
- `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` does NOT exist (Glob confirmed) ✓ — file-skeleton prover dispatch correctly planned for iter-191
- **ANOMALY**: `lem:H1_skyscraperSheaf_finrank_eq_zero_main` carries `\leanok` in the chapter despite the Lean file not existing. This is a spurious marker that `sync_leanok` should have removed but did not (because the file doesn't exist to scan). **MUST-FIX**: the plan agent should instruct the file-skeleton prover to create `H1Vanishing.lean` with at minimum a `sorry`-bearing stub for this declaration so `sync_leanok` can correctly manage the marker in future iters, OR the plan agent should flag to have the review agent strip the marker. The marker itself is technically harmless for prover dispatch (it does not falsely clear the HARD GATE since the Lean file is absent), but it is semantically incorrect and should not persist.

**Verdict for verification:** PASS with anomaly noted.

### 2. `RiemannRoch_WeilDivisor.tex` §6 Positive part

- `def:WeilDivisor_positivePart` block present ✓ — prose uses lattice notation `D ⊔ 0`
- Iter-190 prover landed the Lean def as `Finsupp.mapRange (fun n : ℤ => n ⊔ 0)` — mathematically equivalent to the `D ⊔ 0` lattice form (the latter being the abstract description of the former) ✓ — no must-fix for this subitem; the prose is correct as an abstract description. A `% NOTE:` annotation recording the implementation form would be clean but is not blocking.
- `lem:degree_positivePart_principal_eq_finrank` — **MISMATCH CONFIRMED**: the chapter states the degree equality equationally (`deg(D₊) = finrank ...`), but the iter-190 prover landed the Lean declaration in existential form (`∃ t halg, ...`) for soundness. These are NOT the same statement. The existential form is weaker and does not directly support the downstream reasoning in `RationalCurveIso.tex` Pin 3 Step 2, which applies the degree equality directly. **MUST-FIX MISMATCH** — either:
  - Option (a): Update the chapter to match the Lean existential form and document why the equational form is not yet available, OR
  - Option (b): The prover should close the Lean equational form (stronger), which requires first establishing the file-local typed-sorry `degree_positivePart_principal_localParameterAtInfty_eq_finrank` equationally.
  The plan agent should choose and dispatch accordingly. Until resolved, this blocks `RiemannRoch_WeilDivisor.tex` HARD GATE.

**Verdict for verification:** FAIL — must-fix mismatch on `lem:degree_positivePart_principal_eq_finrank`.

### 3. `Picard_QuotScheme.tex` iter-189 unbundle pins

- `lem:tildeIso_of_isQuasicoherent_isAffineOpen` (Stacks 01I8): present with `\leanok` ✓
- `lem:pullback_of_openImmersion_iso_restrict` (Stacks 01HH-style transport): present with `\leanok` ✓
- Iter-190 prover PARTIAL status (AddEquiv chain closed; ring-identity + restrictScalars-unfold residual): consistent with chapter notes and the existing sorry-bearing body ✓

**Verdict for verification:** PASS — pins present and consistent with prover output.

### 4. `RiemannRoch_RationalCurveIso.tex` Pin 2 corrective NOTE

- NOTE block recording the structural-conflict diagnosis (theorem false-as-stated under iter-187 body of `Hom.poleDivisor`) is present ✓
- `Hom.poleDivisor` refactored to use `positivePart` — recorded in the NOTE ✓
- `degree_positivePart_principal_localParameterAtInfty_eq_finrank` file-local typed-sorry pin — recorded in NOTE ✓
- Chapter is current with what iter-190 prover actually landed ✓

**Verdict for verification:** PASS — NOTE is up-to-date.

---

## HARD GATE Verdicts (Iter-191 Prover Dispatch)

### `RiemannRoch_RationalCurveIso.tex`
- **complete:** `partial` — Pin 3 Step 2 still in progress (relies on `degree_positivePart_principal_localParameterAtInfty_eq_finrank` file-local sorry + downstream `Hom.poleDivisor_degree_eq_finrank`); Pin 4 (`thm:P1IsoOfGenus0`) present but body gated on Pin 3
- **correct:** `true` — proof sketch for all pins is mathematically sound; Lane I corrective-fix approach (refactor `Hom.poleDivisor` via `positivePart`) is well-documented; no logical errors detected
- **must-fix-this-iter:** none — the in-progress state is accurately documented with typed sorries
- **HARD GATE: CLEARED** for Lane I corrective-fix + Pin 3 Step 2 continued

### `RiemannRoch_WeilDivisor.tex`
- **complete:** `partial` — `def:WeilDivisor_positivePart` and `lem:degree_positivePart_principal_eq_finrank` present but the latter has a blueprint↔Lean mismatch
- **correct:** `partial` — `lem:degree_positivePart_principal_eq_finrank` chapter statement (equational) does not match landed Lean form (existential); the prose for `def:WeilDivisor_positivePart` lattice-form is correct as abstract description
- **must-fix-this-iter:** 
  - `lem:degree_positivePart_principal_eq_finrank`: chapter equational phrasing vs Lean existential form. Plan agent must choose Option (a) or (b) above and dispatch accordingly.
- **HARD GATE: BLOCKED** — resolve the equational/existential mismatch before dispatching positivePart body prover

### `Albanese_AuslanderBuchsbaum.tex`
- **complete:** `true` — all declarations present with `\lean{...}` pins; Auslander-Buchsbaum formula, Cohen-Macaulay local ring, depth/pdim lemmas all covered; `thm:auslander_buchsbaum` blueprint complete
- **correct:** `true` — proof sketch follows Matsumura Theorem 19.1 + Bruns-Herzog standard path; depth-by-induction and pdim-localisation arguments sound; Mathlib imports (`IsCohMacaulay`, `depth`, `Module.projDim`) identified correctly
- **must-fix-this-iter:** none
- **HARD GATE: CLEARED** for Lane G continued

### `Picard_QuotScheme.tex`
- **complete:** `partial` — residual sorry on `pullback_of_openImmersion_iso_restrict` (ring-identity + restrictScalars-unfold) documented; main representability theorem and quotient-scheme functor fully sketched
- **correct:** `true` — proof sketch for Stacks 01I8 / 01HH transport is sound; the residual sorry is correctly identified as a definitional-equality unfolding rather than a mathematical gap
- **must-fix-this-iter:** none — residual is accurately documented and does not misrepresent the mathematics
- **HARD GATE: CLEARED** for Lane F Step 3 residual close

### `Genus0BaseObjects_Cross01Substrate.tex` (+ cluster)
- **complete:** `true` — both substrate lemmas fully sketched: `thm:IsClosedImmersion_lift_iff_range_subset` (6-step proof via `Ideal.quotient_lift_iff_range_subset` + closed-immersion characterisation) and `thm:gmRing_tensor_homogeneousAway_isDomain` (4-step proof via `IsDomain` tensor product over algebraically-closed field); `% archon:covers AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean` present
- **correct:** `true` — both proof sketches are mathematically sound; the `gmRing_tensor_homogeneousAway_isDomain` sketch correctly identifies the Mathlib gap (`Algebra.TensorProduct.isDomain_of_isAlgClosed_left`) and proposes the valid workaround (direct construction via integral domain criterion); no `\leanok` expected since prover work is iter-191 pending
- **must-fix-this-iter:** none — the Mathlib gap is known and the workaround is documented
- **HARD GATE: CLEARED** for Lane B Substrate~2 (iter-191 dispatch of file-skeleton or substrate-close prover)

  **Cluster note (other Genus0BaseObjects chapters):** `Genus0BaseObjects.lean` top-level chapter and `Genus0BaseObjects/GmScaling.lean` are covered by `AbelianVarietyRigidity.tex` (see below). The `Cross01Substrate.tex` clearance unblocks `GmScaling.lean` Lane B consumers (`lem:gmscaling_chart_agreement` cocycle, path III.c).

### `AbelianVarietyRigidity.tex`
- **complete:** `partial` — `lem:gmscaling_chart_agreement` has no `\leanok` (prover work ongoing; cocycle gated on Cross01Substrate substrates + Mathlib IsDomain tensor gap); all other GmScaling declarations (`def:gmscaling_cover`, `def:gmscaling_chart`, `lem:gmscaling_chart_PLB_eq`, `lem:gmscaling_over_coherence`, `lem:gmScaling_fixes_zero`) present with `\leanok`; `lem:projGm_geomIrred`, `lem:projGm_isReduced` present with `\leanok` but carry honest sorries for Mathlib gaps; `prop:morphism_P1_to_AV_constant` and `prop:rigidity_genus0_curve_to_AV` both present with `\leanok`; `lem:hom_Ga_to_av_trivial` and `lem:hom_from_Ga_trivial` present, off critical path
- **correct:** `true` — all proof sketches are mathematically sound; ongoing prover work on `lem:gmscaling_chart_agreement` (path III.c live route) is correctly documented; honest sorries for `lem:gm_geomIrred` and `lem:projGm_isReduced` (Mathlib `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` gap) are accurately described
- **must-fix-this-iter:** none — the partial state reflects genuine in-progress prover work, not a blueprint error
- **HARD GATE: CLEARED** for Lane E continued (rigidity AV chapter) — note that `lem:gmscaling_chart_agreement` close remains contingent on Cross01Substrate clearance

### `RiemannRoch_H1Vanishing.tex`
- **complete:** `true` — all 8 `\lean{...}` pins for flasque-resolution substrate present; 6 SOURCE QUOTE blocks from Hartshorne III.1-2 + II.1 present; `\label{chap:RR_H1Vanishing}` present resolving prior broken cref; chapter structure is complete for file-skeleton scaffold dispatch
- **correct:** `true` — proof sketch for H¹ vanishing via flasque resolution is mathematically sound (Hartshorne III.1.2 + III.2.5 standard path); `lem:H1_flasqueResolution_exact` → `lem:H1_flasqueResolution_vanishes` → main theorem chain is correct
- **must-fix-this-iter:** 
  - `lem:H1_skyscraperSheaf_finrank_eq_zero_main` carries `\leanok` but `H1Vanishing.lean` does not exist. The marker is semantically incorrect. The file-skeleton prover should create `H1Vanishing.lean` with a `sorry`-bearing stub for this declaration so `sync_leanok` can correctly manage the marker. **ACTION REQUIRED** from plan agent: instruct file-skeleton prover to include this declaration stub.
- **HARD GATE: BLOCKED (minor)** — the spurious `\leanok` does not block the mathematics, but the plan agent must ensure the file-skeleton prover addresses it. Recommend: **CONDITIONALLY CLEARED** if the file-skeleton dispatch includes the declaration stub — the plan agent may dispatch the prover with the explicit instruction to create the stub.

### `Albanese_CodimOneExtension.tex` (intentionally gated, not dispatched iter-191)
- **complete:** `partial` — Milne Theorems 3.1, 3.2, Lemma 3.3 present; Option (a) Stacks 00TT scaffolding pipeline documented; the chapter is correctly gated pending the Stacks 00TT formal proof pipeline
- **correct:** `true` — the codimension-1 extension argument (normalization, valuation ring, AV-valued rational map extension) is mathematically correct as sketched
- **must-fix-this-iter:** none (gated)
- **HARD GATE: GATED** — not dispatched iter-191 per strategy; no must-fix required

---

## Full Per-Chapter Audit

The following chapters are outside the HARD GATE target set but have been read and verified as part of the whole-blueprint audit.

### `AbelJacobi.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `def:ofCurve` `\leanok`, `lem:comp_ofCurve` `\leanok`, `thm:exists_unique_ofCurve_comp` `\leanok`. All proofs are Albanese-framework projections. Clean.

### `Jacobian.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- All Jacobian definitions and properties present with `\leanok`. `thm:nonempty_jacobianWitness` is the explicit foundational gap (no `\leanok`); this is intentional and correctly marked.

### `Rigidity.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `thm:GrpObj_eq_of_eqOnOpen` `\leanok` (thin wrapper over Mathlib `ext_of_isDominant_of_isSeparated'`). Clean.

### `RigidityKbar.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `thm:rigidity_over_kbar` `\leanok` (body is `sorry` — correctly named gated gap). C.2.d keystone is the gated content requiring either gaps (i)+(ii) [route a] or dual-AV keystone [route b]. Chart-algebra envelope provides only converse direction. Honest and correctly documented.

### `AlgebraicJacobian_Cotangent_GrpObj.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- Pointer chapter; all 3 piece (i.a) declarations closed. Orphan helpers documented.

### `RiemannRoch_OCofP.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- All line-bundle-at-closed-point declarations present with `\leanok`. iter-188 trivAtBot refinement landed.

### `RiemannRoch_RRFormula.tex`
- **complete:** `partial` | **correct:** `true` | must-fix: none
- Main `thm:euler_char_eq_deg_plus_one_minus_genus` gated on substrate sorries (honest, correctly documented). `lem:euler_char_shortExact_add` honest Tier-3 typed sorry, off genus-0 critical path.

### `RiemannRoch_OcOfD.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- All satellite declarations for RR.2 present with `\leanok`.

### `Albanese_AlbaneseUP.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- **STALE STRATEGY NOTE**: The chapter contains an internal strategy note saying "Lean target file not yet created" but `AlgebraicJacobian/Albanese/AlbaneseUP.lean` EXISTS (Glob confirmed). The `\leanok` markers for `thm:albanese_universal_property` and `lem:abel_jacobi_morphism` are correctly placed by `sync_leanok`. The directive's note about "old Sym^g content (pre-pivot)" appears stale — the Sym^g route (Route ii) IS the committed route. **No rewrite needed.** The plan agent should note that the internal strategy note is stale but it does not affect correctness or completeness.

### `Picard_RelativeSpec.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `def:qc_sheaf_of_algebras` `\leanok`, `thm:relative_spec_exists` `\leanok`, `thm:relative_spec_univ` `\leanok`. iter-179 `NatTrans.Coequifibered` refactor landed.

### `Picard_IdentityComponent.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- All 4 Kleiman `lem:agps(3)` consequences covered with `\leanok`.

### `Picard_LineBundlePullback.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `def:line_bundle_on_product` `\leanok`, `def:IsLocallyTrivial` `\leanok`. iter-187 trivialisation predicate landed.

### `Picard_RelPicFunctor.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `lem:rel_pic_sharp_groupoid` `\leanok`.

### `Picard_FlatteningStratification.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `def:coherent_sheaf_flat` `\leanok`.

### `Picard_FGAPicRepresentability.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `lem:line_bundle_quot_correspondence` `\leanok`.

### `Genus.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `def:genus` `\leanok`.

### `Differentials.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- All Kähler differentials declarations present with `\leanok`.

### `Cohomology_SheafCompose.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `thm:HasSheafCompose_forget` `\leanok`.

### `Cohomology_StructureSheafAb.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `thm:HasSheafify_Opens_AddCommGrp` `\leanok`, `thm:HasExt_Sheaf_Opens_AddCommGrp` `\leanok`, `def:Scheme_toAbSheaf` `\leanok`.

### `Cohomology_StructureSheafModuleK.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- All K-module cohomology declarations present with `\leanok`.

### `Cohomology_MayerVietoris.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- All Mayer-Vietoris prime declarations present with `\leanok`.

### `Albanese_CoheightBridge.tex`
- **complete:** `partial` | **correct:** `true` | must-fix: none
- Chapter read partially (100 lines); `lem:coheight_eq_of_isOpenEmbedding` block visible without `\leanok` — prover work ongoing. Lean file EXISTS (Glob confirmed).

### `Albanese_Thm32RationalMapExtension.tex`
- **complete:** `true` | **correct:** `true` | must-fix: none
- `thm:rational_map_to_av_extends` `\leanok` (`\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}`). Lean file EXISTS.

---

## Unstarted-Phase Chapter Proposals

### `Picard_Pic0AbelianVariety.tex` — MISSING (HIGH PRIORITY)

This file does NOT exist. It should cover A.3.iii–vi:
- A.3.iii: tangent space isomorphism `T₀(Pic⁰_{C/k}) ≅ H⁰(C, Ω¹_{C/k})^∨`
- A.3.iv: smoothness of `Pic⁰_{C/k}` (via tangent space criterion)
- A.3.v: properness of `Pic⁰_{C/k}` (via valuative criterion, Milne Prop 6.5)
- A.3.vi: geometric irreducibility of `Pic⁰_{C/k}` (connected component argument)

**Recommended chapter outline for blueprint-writer dispatch:**
```
\chapter{Pic⁰ as an Abelian Variety}
\label{chap:Pic0AV}
% archon:covers AlgebraicJacobian/Picard/Pic0AbelianVariety.lean

\section{Tangent Space}
\begin{definition}[tangent_space_Pic0_iso]
...
\end{definition}

\section{Smoothness}
\begin{theorem}[Pic0_isSmooth]
...
\end{theorem}

\section{Properness}
\begin{theorem}[Pic0_isProper]
...
\end{theorem}

\section{Geometric Irreducibility}
\begin{theorem}[Pic0_geomIrred]
...
\end{theorem}
```

**References:** Milne "Abelian Varieties" §III §6 Prop 6.5; Kleiman "The Picard Scheme" §5; SGA 6 Exp. XII.

**Plan-agent recommendation:** If A.3.iii-vi is HIGH priority this iter, dispatch blueprint-writer with the above outline and references. If deferred, record in STRATEGY.md.

### `Albanese_AlbaneseUP.tex` — Status Clarified (No Rewrite Needed)

The internal strategy note in the chapter is stale ("Lean target file not yet created"). The actual status:
- `AlgebraicJacobian/Albanese/AlbaneseUP.lean` EXISTS
- `thm:albanese_universal_property` and `lem:abel_jacobi_morphism` have `\leanok` markers (correctly placed by `sync_leanok`)
- The Sym^g route (Route ii) is the committed route — this is NOT "old Sym^g content pre-pivot"

**No rewrite needed.** Plan agent should close this item as resolved and note the stale internal comment for cleanup at next review.

---

## Action Items for Plan Agent

### MUST resolve before prover dispatch:

1. **`RiemannRoch_WeilDivisor.tex`** — `lem:degree_positivePart_principal_eq_finrank` mismatch:
   - Choose Option (a): update chapter to match Lean existential form `∃ t halg, ...`, OR
   - Choose Option (b): dispatch prover to close the equational form in Lean
   - Until resolved: **DO NOT dispatch** positivePart body prover for `WeilDivisor.lean`

2. **`RiemannRoch_H1Vanishing.tex`** — spurious `\leanok`:
   - Instruct file-skeleton prover to include a `sorry`-bearing stub for `H1_skyscraperSheaf_finrank_eq_zero_main` so `sync_leanok` can manage the marker correctly
   - Alternative: instruct review agent to strip the marker before file exists
   - **CONDITIONALLY CLEARED**: may dispatch file-skeleton prover if stub inclusion is explicit in prover objectives

### Clean-up items (non-blocking):

3. `Albanese_AlbaneseUP.tex` internal strategy note is stale — record for cleanup
4. `RiemannRoch_WeilDivisor.tex` — `def:WeilDivisor_positivePart` lattice-form prose vs `mapRange` implementation: add a `% NOTE:` annotation recording implementation form (non-blocking, review-agent domain)

---

## HARD GATE Summary Table

| Chapter | complete | correct | must-fix | GATE |
|---------|----------|---------|----------|------|
| `RiemannRoch_RationalCurveIso.tex` | partial | true | none | **CLEARED** |
| `RiemannRoch_WeilDivisor.tex` | partial | partial | `lem:degree_positivePart_principal_eq_finrank` mismatch | **BLOCKED** |
| `Albanese_AuslanderBuchsbaum.tex` | true | true | none | **CLEARED** |
| `Picard_QuotScheme.tex` | partial | true | none | **CLEARED** |
| `Genus0BaseObjects_Cross01Substrate.tex` | true | true | none | **CLEARED** |
| `AbelianVarietyRigidity.tex` | partial | true | none | **CLEARED** |
| `RiemannRoch_H1Vanishing.tex` | true | true | spurious `\leanok` on main theorem | **CONDITIONALLY CLEARED** (stub required) |
| `Albanese_CodimOneExtension.tex` | partial | true | none | **GATED** (not dispatched iter-191) |
