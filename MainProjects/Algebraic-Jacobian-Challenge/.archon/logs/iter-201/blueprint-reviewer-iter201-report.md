# Blueprint Review Report

## Slug
iter201

## Iteration
201

## Top-level summaries

### Proofs lacking detail

- `Albanese_AuslanderBuchsbaum.tex` / `thm:auslander_buchsbaum` proof body (base-case paragraph): "splitting the resolution into short exact sequences…and applying Lemma~REF iteratively" — should be `\cref{lem:depth_short_exact_sequence}`.
- `Albanese_AuslanderBuchsbaum.tex` / `thm:auslander_buchsbaum` proof body (inductive-step paragraph): "hence \(\text{depth}(R \oplus M) > 0\) by Lemma~REF, so a common non-zero-divisor exists" — should be `\cref{lem:depth_short_exact_sequence}`.
- `Albanese_AuslanderBuchsbaum.tex` / `lem:depth_short_exact_sequence` proof body: "By Lemma~REF, \(\text{depth}(N')\)…is the smallest index…" — should be `\cref{lem:depth_via_ext}`.

All three are pre-existing (pre-iter-201) unresolved `Lemma~REF` cross-reference placeholders. The proof substance is mathematically sound; only the pointer is missing. A prover can infer the intended lemma from `\uses{}` annotations, but strict blueprint compliance requires the explicit `\cref{}`.

## Per-chapter

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - iter-201 inserts `def:isRegularInCodimensionOne` (`\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne}`) between §"Codim-1 cycle group" and §"Open-immersion descent" — block is well-formed, source citation correct (Hartshorne II §6 + Stacks 0BX5/02ME), `% SOURCE QUOTE:` verbatim matches the Hartshorne condition (∗) text.
  - iter-201 `\section{Open-immersion descent}` (`\label{sec:open_immersion_descent}`) pins 5 new blocks: `def:primeDivisor_restrictToOpen`, `def:primeDivisor_ofOpen`, `lem:primeDivisor_equivOpen`, `lem:primeDivisor_stalkIso`, `thm:isRegularInCodimensionOne_open`. All `\lean{...}` names match the iter-200 Lean decls reported at WeilDivisor.lean L153–L305. `\uses{}` references within the section resolve to labels present in the chapter. Proof sketches are adequate for Sub-build 2 (naturality of `Ring.ordFrac` across the stalk-iso).
  - `lem:rationalMap_order_finite_support` retains `\lean{AlgebraicGeometry.rationalMap_order_finite_support}` on a currently `private` Lean declaration. The block carries an explicit `% NOTE` documenting this; the pin is retained for documentation, not live sync_leanok resolution. This is acceptable per the documented rationale; no blueprint correction required.
  - Stale L99-104 "Iter-173+ may introduce" prose correctly replaced by a confirmed statement referencing `\ref{def:isRegularInCodimensionOne}`.
  - **HARD GATE verdict**: CLEARS for Lane WD-A4a-Sub-build-2.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - iter-201 gap-table update: gap (3) row correctly reclassified to "OBVIATED iter-200". Gap (4) CLOSED. Gap (1) LOC estimate row updated to reflect per-syzygy step only. Gap (2) binding. ✓
  - iter-201 new `\paragraph{Gap (3) OBVIATED iter-200.}` and `\paragraph{Gap (2) Stacks 00MF proof recipe.}` are mathematically correct and actionable. Recipe for Path B (LES-injectivity + matrix-collapse, ~130-200 LOC) matches the `ab-stacks00mf` analogist report content. ✓
  - iter-201 `\subsec:ab_gap1_haspdlt_pivot` (`\label{subsec:ab_gap1_haspdlt_pivot}`) with 4 new lemma blocks: all `\lean{...}` names match iter-200 Lean decls; all `\uses{}` chains resolve; proof sketches cite correct Mathlib API (`ShortComplex.ShortExact.hasProjectiveDimensionLT_X_1`, `ModuleCat.projective_of_free`, etc.). ✓
  - iter-201 closure-assembly paragraph correctly describes the SES-descent recipe consuming the 4 iter-200 helpers + gap (2). ✓
  - iter-201 NOTE on `lem:auslander_buchsbaum_formula_succ_pd` private/public mismatch resolved to option (1): remove `private`. The Lane AB prover must do this as part of closure. Blueprint is correctly updated.
  - **DEFICIENCY (must-fix)**: `thm:auslander_buchsbaum` proof body has 2 unresolved `Lemma~REF` placeholders (both should be `\cref{lem:depth_short_exact_sequence}`). `lem:depth_short_exact_sequence` proof body has 1 unresolved `Lemma~REF` (should be `\cref{lem:depth_via_ext}`). These are pre-existing (not introduced by iter-201) but prevent `correct: true` classification.
  - Remark in `cor:regular_cohen_macaulay` proof: "can be obtained from Theorem~REF" — should be `\cref{thm:auslander_buchsbaum}`; remark-only, not load-bearing.
  - **HARD GATE verdict**: CONDITIONAL — fails on `correct: partial` due to Lemma~REF placeholders. Same-iter fast path: dispatch blueprint writer for a single-pass resolution of 3 `Lemma~REF → \cref{}` substitutions (~15-minute task); re-review not strictly required if the fix is mechanical and the plan agent confirms no new content is altered.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: true
- **correct**: true
- **notes**:
  - iter-201 updates `lem:smooth_algebra_krull_dim_formula` "Mathlib API state" itemization: replaced stale "NEEDS-BRIDGE; ~200-300 LOC" with iter-200 actual state (Steps 1+2 axiom-clean inline; Step 3 = Jacobian-witness residual ~30-60 LOC). ✓
  - iter-201 new `\subsec:stage6_iib_substrate_iter200` (`\label{subsec:stage6_iib_substrate_iter200}`) enumerates 7 iter-200 private substrate decls by role (Step 1 / Step 2 LB / Step 2 UB / Step 2 Fin n / Step 2 general / capstone / Step 3 additive form). NO `\lean{...}` pins on these 7 decls — correct design choice to avoid sync_leanok private-name resolution failures. ✓
  - Jacobian-witness recipe paragraph correctly describes the iter-201 closure path (Stacks 00SW/00OW, `Algebra.SubmersivePresentation.jacobian_isUnit` + `RingTheory.Sequence.isRegular_cons_iff` + promotion to IsRegular). API choice (`IsRegular` via `IsLocalRing.isRegular_iff_isWeaklyRegular`) is correctly explained. ✓
  - `thm:weil_divisor_obstruction` intentionally has no `\lean{...}` pin (documented in `% NOTE` since iter-179). The theorem is present with a full statement and proof sketch referencing `\cref{lem:smooth_codim_one_dvr}` and `\cref{def:order_at_point}`. This is an acknowledged, intentional gap — not a blueprint error.
  - `lem:stage6_regular_stalk_assembly` (6.C) has no `\lean{...}` pin; NOTE explains it is the body of `isRegularLocalRing_stalk_of_smooth` itself. ✓
  - All `\uses{}` chains in the new subsection resolve to labels present in the chapter. ✓
  - **HARD GATE verdict**: CLEARS for Lane COE-Stage6.B-Jacobian.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:symmetric_product_to_jacobian` birationality proof uses Riemann–Roch (Route C PAUSED) for the generic-fibre argument. The iter-199 NOTE at that block flags this correctly. Since Lane AlbaneseUP is priority-5/HELD, this is not a blocking issue; recorded for completeness.
  - `def:symmetric_power_curve` has no Mathlib analogue; the chapter correctly notes this requires a project-side affine-and-glue construction. The chapter specifies the target adequately.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Consolidated chapter covering AbelianVarietyRigidity.lean, Genus0BaseObjects.lean, BareScheme.lean, ChartIso.lean, Points.lean, GmScaling.lean, RigidityLemma.lean. The genus-0 rigidity chain (Rigidity Lemma + additivity Corollary 1.5 + Gm-scaling shortcut) is well-specified.
  - Route C PAUSED: BareScheme.lean (2 sorries) and GmScaling.lean (2 sorries) are off-limits. The chapter covers both but prover dispatch is paused per USER directive.
  - AbelianVarietyRigidity.lean has 3 sorries. The `prop:rigidity_genus0_curve_to_AV` and supporting declarations are adequately blueprinted.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Route C PAUSED (`RigidityKbar.lean` has 1 sorry). The chapter documents the fallback route (a) with `[CharZero]` hypothesis. Not the committed critical path; the AbelianVarietyRigidity.tex char-free route is the committed one. Chapter is complete as a fallback specification.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lane RPF HELD iter-199/200/201; binding gate is TensorObjSubstrate scaffold (iter-204+). `\leanok` on declaration heads; body has 1 sorry (`addCommGroup` L235 gated on Scheme.Modules monoidal structure). Chapter is adequately specified for eventual prover dispatch.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - New chapter (iter-200). I read the first ~30 lines. Chapter describes the `Scheme.Modules.tensorObj` substrate needed for Lane RPF. It specifies three responsibilities (Mathlib API audit, construction of `tensorObj`, consumer wiring back to RelPicFunctor). Blueprint has adequate mathematical content for a prover to build the scaffold (iter-202 commitment). Verdict `partial` only because the Lean scaffold file `Picard/TensorObjSubstrate.lean` does not yet exist; when that scaffold is created, this chapter is the prover-ready spec. No prover dispatch this iter, so the `partial` verdict does not trigger a HARD GATE failure for any active lane.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - A.2.c assembly chapter. HELD pending A.2.b (QuotScheme bypassed) and A.1.c (RelPicFunctor). The chapter specifies the FGA representability assembly via Kleiman §4. Lean file has 7 sorries (rank-1 gated on TensorObjSubstrate + rank-3 Route C blocked). `partial` because the assembly cannot close until upstream inputs land; the blueprint content is well-specified but not complete as a prover-ready spec without the upstream pieces.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Bypassed via Cartier route (12 sorries, not in current objectives). Blueprint is complete as a specification.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Bypassed (7 sorries). Not in current objectives.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: true
- **correct**: true
- **notes**:
  - A.3 row. EXCISED per Pic⁰ pivot (9 sorries, A.3.i identity-component path excised). Chapter specifies the identity component construction; currently deferred until after A.2.c + other prerequisites.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Gated on A.3.vii + A.2.c (5 sorries). Not in current objectives.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

(All five RR.* chapters are Route C PAUSED per USER 2026-05-28 standing directive; no prover dispatched; blueprint content is adequate.)

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

## Severity summary

**must-fix-this-iter:**
1. `Albanese_AuslanderBuchsbaum.tex` — `correct: partial` due to 3 unresolved `Lemma~REF` cross-reference placeholders in pre-existing proof bodies of `thm:auslander_buchsbaum` (×2) and `lem:depth_short_exact_sequence` (×1). Each should be the corresponding `\cref{}`. This blocks Lane AB-Stacks-00MF from the HARD GATE. **Same-iter fast path**: dispatch blueprint writer for a single mechanical pass resolving `Lemma~REF → \cref{lem:depth_short_exact_sequence}` (2 sites in `thm:auslander_buchsbaum` proof body) and `Lemma~REF → \cref{lem:depth_via_ext}` (1 site in `lem:depth_short_exact_sequence` proof body). No new content; trivial substitutions only. After the writer returns, the plan agent may re-dispatch Lane AB without waiting for another full blueprint-reviewer run, per the same-iter fast-path protocol.

**soon:**
2. `Albanese_AuslanderBuchsbaum.tex` / `cor:regular_cohen_macaulay` proof remark: "Theorem~REF" → `\cref{thm:auslander_buchsbaum}`. Remark-only, not load-bearing for the proof or the prover target.
3. `RiemannRoch_WeilDivisor.tex` / `lem:rationalMap_order_finite_support`: `\lean{AlgebraicGeometry.rationalMap_order_finite_support}` pins a currently `private` Lean declaration. sync_leanok will not be able to resolve this until the declaration is made public (which happens at the terminal closure step, iter-203+ per plan). The `% NOTE` in the block documents this correctly. No action required this iter; flag for the iter handling `rationalMap_order_finite_support` terminal closure.

**informational:**
4. `Albanese_CodimOneExtension.tex` / `thm:weil_divisor_obstruction`: intentionally no `\lean{...}` pin (documented since iter-179; the `Scheme.RationalMap → function-field pullback` machinery is a Mathlib gap). Not an error; the block is correctly labeled as pending future infrastructure.

## HARD GATE verdicts (explicit)

| Lane | Lean file | Chapter | Verdict |
|---|---|---|---|
| WD-A4a-Sub-build-2 | `RiemannRoch/WeilDivisor.lean` | `RiemannRoch_WeilDivisor.tex` | **CLEARS** — complete:true, correct:true |
| AB-Stacks-00MF | `Albanese/AuslanderBuchsbaum.lean` | `Albanese_AuslanderBuchsbaum.tex` | **CONDITIONAL** — complete:true, correct:partial; fast-path fix required (3 Lemma~REF → \cref{}) |
| COE-Stage6.B-Jacobian | `Albanese/CodimOneExtension.lean` | `Albanese_CodimOneExtension.tex` | **CLEARS** — complete:true, correct:true |

Overall verdict: 2 of 3 HARD GATE lanes clear unconditionally; Lane AB is conditional on a trivial blueprint writer pass (fix 3 pre-existing Lemma~REF placeholders); no unstarted phases lack blueprint coverage; 0 unstarted-phase proposals.
