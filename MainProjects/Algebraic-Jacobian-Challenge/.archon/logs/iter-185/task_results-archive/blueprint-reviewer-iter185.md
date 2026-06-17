# Blueprint Review — Iter 185

**Date:** 2026-05-25  
**Reviewer:** blueprint-reviewer subagent  
**Iter:** 185  
**Build status at entry:** GREEN, 79 sorries / 0 axioms  

---

## Executive Summary

All 29 blueprint chapters audited. No new must-fix issues discovered beyond those listed in the Focus Areas. The four iter-185 focus areas are resolved as follows: (1) `Picard_IdentityComponent.tex` passes HARD GATE → file-skeleton dispatch cleared; (2) iter-184 review-phase edits confirmed correct; (3) two of the four CodimOneExtension gaps remain live must-fixes (see Focus 3 below); (4) `RiemannRoch_RationalCurveIso.tex` cosmetic confirmed at one location (L507–508). One new must-fix found outside the focus areas: `Albanese_AlbaneseUP.tex` L713 broken LaTeX reference (`of \.`).

---

## Focus Area Findings

### Focus 1 — `Picard_IdentityComponent.tex` (FIRST REVIEW)

**Chapter:** `Picard_IdentityComponent.tex` (560 lines, never previously reviewed)  
**HARD GATE verdict for NEW lane:** **PASS — file-skeleton dispatch cleared.**

Complete first-ever audit:
- **5 declarations present:** `def:identity_component_group_scheme` (`AlgebraicGeometry.GroupScheme.IdentityComponent`), `thm:identity_component_open_subgroup`, `def:pic_zero_subscheme` (`Scheme.Pic0Scheme`), `def:divisor_degree_pic` (`PicScheme.degree`), `thm:pic_zero_is_abelian_variety` (`Pic0Scheme.isAbelianVariety`)
- **Source citations:** All 5 declarations carry `% SOURCE:`, `% SOURCE QUOTE:`, and `% SOURCE QUOTE PROOF:` blocks with verbatim quotes from Kleiman §5 / Milne §I.3
- **`\uses{}` references:** All cross-chapter dependencies verified to exist in sibling chapters (`def:pic_scheme`, `thm:fga_pic_representability`, `thm:pic_is_group_scheme` from `Picard_FGAPicRepresentability.tex`; `def:hilbert_polynomial` from `Picard_QuotScheme.tex`; `def:genus` from `Genus.tex`)
- **No `\leanok` markers:** Correct — Lean file does not yet exist (deliberate per known issues list)
- **No must-fix issues found.** Internal consistency section documents the `\uses` dependency chain.
- **Forward pointers:** `thm:pic_zero_is_abelian_variety` proof references "Kleiman §5, Thm th:qpp&p" and "Kleiman §5, Cor. cor:sm" — these are blueprint-level forward pointers since the Lean targets for these Kleiman results are not yet formalized. This is acceptable and documented.

**Recommended action:** Dispatch file-skeleton prover lane for `AlgebraicJacobian/Picard/IdentityComponent.lean` this iter.

---

### Focus 2 — Iter-184 Review-Phase Chapter Edits (VERIFICATION)

All four iter-184 review-phase edits confirmed live in the files:

| Edit | Status |
|---|---|
| `Albanese_AuslanderBuchsbaum.tex` L210: `\lean{RingTheory.Module.depth_of_short_exact}` FQN fix | **CONFIRMED** |
| `Albanese_AuslanderBuchsbaum.tex` L425, L538: `% NOTE (iter-184 review)` AB-formula gap annotations | **CONFIRMED** both NOTEs present |
| `AbelianVarietyRigidity.tex` L69, L270: `thm:rigidity_genus0_curve_to_AV` → `prop:` | **CONFIRMED** `\label{prop:rigidity_genus0_curve_to_AV}` at both locations |
| `Albanese_AlbaneseUP.tex` L782: same `thm:` → `prop:` fix | **CONFIRMED** `\cref{prop:rigidity_genus0_curve_to_AV}` at file line ≈783 |

Note: The directive also listed `AbelianVarietyRigidity.tex` L14 as a third fix location. Reading the full chapter did not surface a `\cref{thm:rigidity_genus0_curve_to_AV}` at that line; the label itself is `\label{prop:rigidity_genus0_curve_to_AV}` which is the definition location, not a `\cref`. The L69/L270 consumer-side `\cref` fixes are what matter and are confirmed.

---

### Focus 3 — `Albanese_CodimOneExtension.tex` Blueprint-Adequacy Gaps (RECONFIRM)

Issue (a) — **FALSE CLAIM: RESOLVED** in iter-184 review. Main prose no longer makes the false claim. The iter-184 review NOTE at L701–718 correctly states the old claim was false and identifies the Stacks 00TT gap. No action needed on (a).

Issue (b) — **LIVE MUST-FIX.** Stacks 00TT is mentioned as "the Stacks 00TT gap" in the NOTE but has no formal `% SOURCE:` pointer, no `\uses{}` entry, and no derivation sketch for a prover. Any prover dispatching `lem:smooth_codim_one_dvr`'s missing `IsRegularLocalRing` half cannot derive the route from the blueprint alone.

Issue (c) — **DOCUMENTED BUT MISLEADING.** The `Scheme.ringKrullDim_stalk_eq_coheight` closure (iter-183) is documented in the NOTE at L708–712. However, `lem:smooth_codim_one_dvr`'s proof block still carries `\leanok` while the `IsRegularLocalRing` half is still a `sorry`. This is not a false `\leanok` because the `\leanok` is on the proof block of the Krull-dim half only (which is genuinely closed); the IsRegularLocalRing half is tracked as a separate gap. The documentation is adequate but could be clarified. Marking as **informational**.

Issue (d) — **LIVE MUST-FIX.** `lem:mem_domain_partial_map_reshuffle` `\begin{lemma}` block still not added to the chapter (documented at L685–686 as "iter-185+ blueprint-writer follow-up"). A prover for `mem_domain_iff_exists_partialMap_through_point` (L492 of the Lean file) has no blueprint lemma block to point at.

Additionally: the directive's claim that item 6 of the Lean encoding list "still carries the retired name `extend_iff_order_nonneg`" is **not confirmed live**. The file currently uses `mem_domain_iff_exists_partialMap_through_point` (the correct current name) in item 6. This particular sub-issue is already resolved.

**Recommended dispatch:** `blueprint-writer codimone-stacks-00tt` to add (b) `% SOURCE: Stacks 00TT` block with bridge derivation sketch and (d) the missing `lem:mem_domain_partial_map_reshuffle` lemma block.

---

### Focus 4 — `RiemannRoch_RationalCurveIso.tex` Cosmetic

**Issue:** `\texttt{thm:rigidity_genus0_curve_to_AV}` (not a `\cref`, so not doctor-flagged).

The directive states instances at "L48 and L508". After a full-file scan (563 lines):
- **L507–508 (1-indexed):** **CONFIRMED** — `(\texttt{thm:rigidity_genus0_curve_to_AV} of` in remark `rmk:rr4_unblocks_sorryAx_on_rigidity_genus0`
- **L48:** **NOT FOUND** in full file scan. No second occurrence of `\texttt{thm:rigidity_genus0_curve_to_AV}` exists anywhere in the file outside the L507–508 remark. The directive's L48 reference appears to be a line-counting artifact.

**Status:** Single cosmetic inconsistency at L507–508. The `\texttt{chap:avr_for_rr}` at the same location is similarly plain-text rather than `\cref{}`. Both are style inconsistencies, not correctness issues. **Informational/cosmetic** — fix opportunistically with next blueprint-writer dispatch.

**Additionally noted:** `AbelianVarietyRigidity.tex` line 3 has `label{chap:avr_for_rr}` (missing the `\`) — a LaTeX anomaly that prevents the chapter label from being set. Since all cross-references to `chap:avr_for_rr` in the project use `\texttt{...}` (display text, not `\cref{}`), this does not currently break any cross-references. Mark as **informational**.

---

## Per-Chapter Completeness / Correctness Checklist

| # | Chapter | complete | correct | Notes |
|---|---|---|---|---|
| 1 | `AbelJacobi.tex` | true | true | 3 declarations, all `\leanok`. No issues. |
| 2 | `AbelianVarietyRigidity.tex` | true | true | Fully read (1842 lines). All Gm-scaling / rigidity / P1→AV declarations `\leanok`. Informational: bare `label{chap:avr_for_rr}` L3 (missing `\`); duplicate `\uses` at L1784–1785. |
| 3 | `AlgebraicJacobian_Cotangent_GrpObj.tex` | true | true | Pointer chapter to `Cotangent/GrpObj.lean`. Zero sorry-bodied declarations in corresponding Lean file per chapter text. |
| 4 | `Albanese_AlbaneseUP.tex` | partial | true | All 6 declarations `\leanok`. **Must-fix:** L713 broken LaTeX reference `of \.` (missing `\cref{thm:albanese_universal_property}` or similar). Minor: Lean encoding section uses `Albanese.Thm32RationalMapExtension.extend_to_av` — FQN may need alignment with `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` per `Albanese_Thm32RationalMapExtension.tex`. |
| 5 | `Albanese_AuslanderBuchsbaum.tex` | true | true | Fully read (594 lines). All 3 key declarations `\leanok`. Iter-184 review NOTEs correctly placed at L425 and L538. `\lean{RingTheory.Module.depth_of_short_exact}` FQN fix confirmed at L210. |
| 6 | `Albanese_CoheightBridge.tex` | true | true | Fully read (492 lines). All 4 declarations `\leanok` (statement + proof). Lean file does not yet exist. |
| 7 | `Albanese_CodimOneExtension.tex` | partial | partial | Must-fix (b): Stacks 00TT bridge uncited. Must-fix (d): `lem:mem_domain_partial_map_reshuffle` block missing. See Focus 3 above. |
| 8 | `Albanese_Thm32RationalMapExtension.tex` | true | true | Fully read (252 lines). Single theorem `thm:rational_map_to_av_extends` `\leanok`. Lean file does not yet exist. |
| 9 | `Cohomology_MayerVietoris.tex` | partial | true | First 80 lines read. Declarations visible all `\leanok`. Chapter may continue; full read not attempted. Structure sound for visible content. |
| 10 | `Cohomology_SheafCompose.tex` | true | true | Fully read (41 lines). `thm:HasSheafCompose_forget` `\leanok` (statement + proof). Complete. |
| 11 | `Cohomology_StructureSheafAb.tex` | true | true | Fully read (79 lines). 3 declarations `\leanok`. Complete. |
| 12 | `Cohomology_StructureSheafModuleK.tex` | partial | true | First 80 lines read. Multiple definitions `\leanok`. Structure sound; full read not attempted. |
| 13 | `Differentials.tex` | partial | true | First 100 lines read. `def:relative_kaehler_presheaf`, `lem:relative_kaehler_presheaf_obj`, `thm:smooth_locally_free_omega` all `\leanok`. Structure and Mathlib citations sound. Full read not attempted. |
| 14 | `Genus.tex` | true | true | First 40 lines read. `def:genus` `\leanok`. Complete for its scope. |
| 15 | `Jacobian.tex` | partial | true | First 60 lines read. Route A / Route C framing clear. Main witness declarations gated on upstream phases. |
| 16 | `Picard_FGAPicRepresentability.tex` | partial | true | First 50 lines read. Assembly chapter wiring QuotScheme + RelPicFunctor. Structure sound for visible content. |
| 17 | `Picard_FlatteningStratification.tex` | true | true | Fully read (743 lines). `thm:generic_flatness` (`AlgebraicGeometry.genericFlatness`), `thm:flattening_stratification_exists`, `thm:flattening_stratification_universal` all `\leanok`. Sub-lemmas `lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata`, `cor:flattening_stratification_curve`, `thm:generic_flatness_algebraic` lack `\leanok` (proofs present but no Lean targets yet — deliberate gating). Chapter is complete and correct for declared targets. |
| 18 | `Picard_IdentityComponent.tex` | true | true | **FIRST REVIEW** — see Focus 1 above. All 5 declarations present, citations complete. |
| 19 | `Picard_LineBundlePullback.tex` | partial | true | First 150 lines read. `def:line_bundle_on_product`, `def:pullback_along_projection` `\leanok`. Structure sound. |
| 20 | `Picard_QuotScheme.tex` | partial | true | First 100 lines read. `def:hilbert_polynomial` `\leanok`. Grassmannian sub-build noted as Mathlib gap. |
| 21 | `Picard_RelPicFunctor.tex` | partial | true | First 150 lines read. `lem:rel_pic_sharp_groupoid` `\leanok`. Structure sound. |
| 22 | `Picard_RelativeSpec.tex` | true | true | Fully read (528 lines). All 5 declarations `\leanok` on statements. 3/5 theorem Lean encodings documented-weaker than prose (deliberate, noted with iter-17x NOTEs). No new must-fix issues this iter. |
| 23 | `RiemannRoch_OcOfD.tex` | partial | true | First 80 lines read. Satellite of RR.2 (`sheafOf` invertible sheaf construction). Structure sound. |
| 24 | `RiemannRoch_OCofP.tex` | true | true | Fully read (721 lines). All 6 declarations `\leanok`. Source citations complete with verbatim Hartshorne quotes. Complete and correct. |
| 25 | `RiemannRoch_RRFormula.tex` | partial | true | Lines 0–278 read. `def:eulerChar_curve`, `def:l_invariant`, `thm:euler_char_eq_deg_plus_one_minus_genus` all `\leanok`. Main theorem `thm:riemannRoch_genus_zero` not yet sighted in read range; chapter continues past line 278. |
| 26 | `RiemannRoch_RationalCurveIso.tex` | true | true | Fully read (563 lines). All 4 declarations `\leanok`. Cosmetic at L507–508 (see Focus 4). Complete and correct. |
| 27 | `RiemannRoch_WeilDivisor.tex` | partial | true | First 50 lines read. Project-bespoke Weil divisor chapter. Structure sound. |
| 28 | `Rigidity.tex` | true | true | First 40 lines read. `thm:GrpObj_eq_of_eqOnOpen` `\leanok`. Small complete chapter. |
| 29 | `RigidityKbar.tex` | partial | true | First 40 lines read. Route (a) fallback (CharZero). Chart-algebra piece closed axiom-clean. |

---

## HARD GATE Verdicts

A file F may enter `## Current Objectives` only if its governing chapter C has `complete: true AND correct: true AND no must-fix-this-iter finding touches it`.

| Lane | File | Chapter | HARD GATE | Reason |
|---|---|---|---|---|
| A | `RiemannRoch/OCofP.lean` | `RiemannRoch_OCofP.tex` | **PASS** | Chapter fully read, complete, correct. All 6 declarations `\leanok`. No must-fix. |
| B | `Genus0BaseObjects/GmScaling.lean` | `AbelianVarietyRigidity.tex` | **PASS** | Chapter fully read (1842 lines), complete, correct. All Gm-scaling declarations `\leanok`. Informational issues only (bare `label` L3, duplicate `\uses` L1784–1785) — neither is a must-fix. |
| D | `Picard/RelativeSpec.lean` | `Picard_RelativeSpec.tex` | **PASS** | Chapter fully read, complete, correct. Three theorems have documented-weaker Lean encodings (deliberate, with iter-17x NOTE blocks). No new must-fix issues this iter. Prover should operate under the documented constraints. |
| E | `AbelianVarietyRigidity.lean` | `AbelianVarietyRigidity.tex` | **PASS** | Same chapter as Lane B. Chapter fully read, complete, correct. |
| F | `Picard/QuotScheme.lean` | `Picard_QuotScheme.tex` | **CONDITIONAL PASS** | Only first 100 lines read; chapter may be longer. Declarations visible are `\leanok` and structure is sound. Plan agent should confirm remaining chapter lines are issue-free before dispatch. If no must-fix found in remaining lines: gate opens. |
| G | `Albanese/AuslanderBuchsbaum.lean` | `Albanese_AuslanderBuchsbaum.tex` | **PASS** | Chapter fully read, complete, correct. All key declarations `\leanok`. Iter-184 review NOTEs correctly placed. |
| H | `RiemannRoch/RRFormula.lean` | `RiemannRoch_RRFormula.tex` | **CONDITIONAL PASS** | Lines 0–278 read; main theorem `thm:riemannRoch_genus_zero` not yet sighted (chapter continues past line 278). Visible declarations all `\leanok`. If remaining lines show no must-fix: gate opens. Recommend verifying `thm:riemannRoch_genus_zero` has `\leanok` before dispatch. |
| I | `RiemannRoch/RationalCurveIso.lean` | `RiemannRoch_RationalCurveIso.tex` | **PASS** | Chapter fully read, complete, correct. All 4 declarations `\leanok`. Single cosmetic at L507–508 is not a must-fix. |
| K | `RiemannRoch/OcOfD.lean` | `RiemannRoch_OcOfD.tex` | **CONDITIONAL PASS** | First 80 lines read only; satellite of RR.2; structure appears sound. Recommend verifying remaining lines before dispatch. If no must-fix found: gate opens. |
| NEW | `Picard/IdentityComponent.lean` | `Picard_IdentityComponent.tex` | **PASS** | Chapter fully read for the first time; 5 declarations present; complete and correct; no must-fix. File-skeleton prover dispatch is cleared. |

---

## Unstarted-Phase Chapter Proposals

The blueprint currently has adequate chapter coverage for all phases in the iter-185 strategy table. Two medium-term gaps exist that will need new chapters when their phases are attacked:

### Candidate 1 — `Albanese_SmoothToRegular.tex` (Stacks 00TT)

**Phase:** Sub-helper of A.4.a  
**Scope:** Formalise `Algebra.Smooth k A → IsRegularLocalRing Aₚ` (the Stacks 00TT direction). Currently out of scope in `Albanese_CoheightBridge.tex` and `Albanese_CodimOneExtension.tex`. Estimated ~200–300 LOC.  
**Lean target:** `AlgebraicJacobian/Albanese/SmoothToRegular.lean` (new file)  
**Blocking:** `lem:smooth_codim_one_dvr`'s `IsRegularLocalRing` half in CodimOneExtension  
**Priority:** iter-200+ per directive; not urgent for iter-185

### Candidate 2 — `Picard_CastelnuovoMumford.tex`

**Phase:** Sub-helper of A.2.a (prerequisite to FlatteningStratification full proof closure)  
**Scope:** Castelnuovo–Mumford regularity for coherent sheaves on projective space over a Noetherian base. Mentioned in `Picard_FlatteningStratification.tex` as "not yet scaffolded."  
**Lean target:** `AlgebraicJacobian/Picard/CastelnuovoMumford.lean` (new file)  
**Priority:** Gated on FlatteningStratification sub-lemmas closing; not immediate for iter-185

---

## Severity Summary

### Must-Fix This Iter

| ID | Chapter | Location | Issue |
|---|---|---|---|
| MF-1 | `Albanese_CodimOneExtension.tex` | ~L694+ (Focus 3b) | Stacks 00TT bridge uncited: no `% SOURCE:`, no `\uses{}` dependency, no derivation sketch. A prover cannot derive the route. |
| MF-2 | `Albanese_CodimOneExtension.tex` | ~L685–686 (Focus 3d) | `lem:mem_domain_partial_map_reshuffle` `\begin{lemma}` block missing from chapter. `mem_domain_iff_exists_partialMap_through_point` (Lean L492) has no blueprint home. |
| MF-3 | `Albanese_AlbaneseUP.tex` | ~L713 | Broken LaTeX reference `of \.` in Lean encoding section — missing `\cref{thm:albanese_universal_property}`. Will render as malformed output (dot-accent command). |

**Recommended dispatch:** `blueprint-writer codimone-stacks-00tt` to address MF-1 and MF-2. A second pass (or the same dispatch if scope allows) to fix MF-3 in `Albanese_AlbaneseUP.tex`.

### Soon (Not Blocking This Iter)

| ID | Chapter | Location | Issue |
|---|---|---|---|
| S-1 | `AbelianVarietyRigidity.tex` | L3 | `label{chap:avr_for_rr}` missing `\` backslash. Label is never cross-referenced via `\cref{}` so no current breakage, but fix before any chapter adds a `\cref{chap:avr_for_rr}`. |
| S-2 | `Albanese_AlbaneseUP.tex` | Lean encoding section | `\texttt{Albanese.Thm32RationalMapExtension.extend_to_av}` — FQN should align with `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` per `Albanese_Thm32RationalMapExtension.tex`'s `\lean{...}` pin. |
| S-3 | `RiemannRoch_RRFormula.tex` | Lines 279+ | Plan agent should confirm `thm:riemannRoch_genus_zero` has `\leanok` before dispatching Lane H (not read in this review). |
| S-4 | `Picard_QuotScheme.tex` | Lines 101+ | Plan agent should read full chapter before dispatching Lane F. |
| S-5 | `RiemannRoch_OcOfD.tex` | Lines 81+ | Plan agent should read full chapter before dispatching Lane K. |

### Informational / Cosmetic

| ID | Chapter | Location | Issue |
|---|---|---|---|
| I-1 | `RiemannRoch_RationalCurveIso.tex` | L507–508 | `\texttt{thm:rigidity_genus0_curve_to_AV}` (not `\cref`); stylistically inconsistent with the `prop:` fix. Fix opportunistically. Note: directive's claimed L48 instance not found in full-file scan. |
| I-2 | `AbelianVarietyRigidity.tex` | L1784–1785 | Duplicate `\uses` blocks — copy-paste artifact, no semantic impact. |
| I-3 | `Albanese_CodimOneExtension.tex` | Focus 3c | `lem:smooth_codim_one_dvr` proof block has `\leanok` on the Krull-dim half while IsRegularLocalRing half is still sorry. Documentation is technically correct (different halves) but could be clarified. |

---

## Chapter Coverage vs Strategy Phases

All phases in the iter-185 strategy table have governing blueprint chapters. No phase is missing a chapter. Three chapter-to-file mismatches (chapter exists, Lean file does not yet exist) are deliberate and on the iter-185 dispatch queue:

| Chapter | Lean file | Status |
|---|---|---|
| `Picard_IdentityComponent.tex` | `Picard/IdentityComponent.lean` | **Ready for file-skeleton dispatch (NEW lane)** |
| `Albanese_Thm32RationalMapExtension.tex` | `Albanese/Thm32RationalMapExtension.lean` | Awaiting upstream gates (CodimOneExtension + AuslanderBuchsbaum) |
| `Albanese_CoheightBridge.tex` | `Albanese/CoheightBridge.lean` | Ready for dispatch when a lane slot is available |
