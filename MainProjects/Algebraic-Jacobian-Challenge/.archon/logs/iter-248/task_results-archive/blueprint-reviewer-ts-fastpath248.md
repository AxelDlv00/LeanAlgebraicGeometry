# Blueprint Review Report

## Slug
ts-fastpath248

## Iteration
248

## Top-level summaries

### Incomplete parts

- `Picard_RelativeSpec.tex`: proof sketches throughout use `Theorem~REF` (11 occurrences) as an unresolved internal cross-reference to the relative-spectrum universal-property theorem — the `\label{}` was never filled in. A.1.a chapter; no current prover. No deferral entry in PROGRESS.md.
- `Albanese_AuslanderBuchsbaum.tex`: 7 `Theorem~REF` placeholders in proof sketches referencing the main Auslander–Buchsbaum formula without resolving the internal `\label`. A.4 Route 1, HELD (gated A.2.c). No deferral entry in PROGRESS.md.
- `Cohomology_StructureSheafModuleK.tex`: 12 `Theorem~REF` / `Section~REF` placeholders in proof sketches and section references. Part of the HELD cohomology chain. No deferral entry in PROGRESS.md.
- `Differentials.tex`: 7 `Theorem~REF` placeholders. HELD lane. No deferral entry.
- `Cohomology_MayerVietoris.tex`: 4 `Theorem~REF` / `Section~REF` placeholders. HELD. No deferral entry.
- `AbelJacobi.tex`: 1 `Theorem~REF` in an active remark body (the "deferred existence hypothesis" pointer). Final assembly chapter, HELD behind all routes. No deferral entry.
- `Cohomology_SheafCompose.tex`: 1 `Theorem~REF` placeholder. HELD. No deferral entry.
- `Cohomology_StructureSheafAb.tex`: 1 `Theorem~REF` placeholder. HELD. No deferral entry.
- `Rigidity.tex`: 1 `Theorem~REF` placeholder in a uniqueness argument. PAUSED lane. No deferral entry.
- `Picard_FlatteningStratification.tex`: 12 `Theorem~REF` placeholders (known, explicit deferral in PROGRESS.md).
- `Jacobian.tex`: 2 `Theorem~REF` in routing prose (known, explicit deferral in PROGRESS.md).
- `Albanese_CodimOneExtension.tex`: Stage 2 depth-≥2 / Stacks 00TT gap (known, explicit deferral in PROGRESS.md).
- `Picard_Pic0AbelianVariety.tex`: `\leanok` on 5 statement blocks whose Lean file does not yet exist (A.3, known, explicit deferral in PROGRESS.md).

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **η-bridge atomic blocks — SOUND:** The new subsection "The unit square (D2′): a mate-calculus telescope" adds six named blocks atomising the D2′ η-bridge. Mathematical audit:
    - `lem:presheaf_unit_comp_map_eta` (pinned to `presheafUnit_comp_map_eta`, exists axiom-clean ✓): states the standard adjunction-mate identity for the presheaf pullback–pushforward adjunction; proof correctly cites Mathlib `Adjunction.unit_app_unit_comp_map_η` instantiated at `presheafPushforwardLaxMonoidal` + `presheafPullbackOplaxMonoidal`. **Mathematically sound; detail adequate.**
    - `lem:isiso_sheafifyeta_of_unitsquare` (pinned to `isIso_sheafifyEta_of_unitSquare`, exists axiom-clean ✓): given the unit square, isolates `a_Y.map(η(F))` as a composite of three isos via algebra on the square equation. **Mathematically sound; detail adequate.**
    - `lem:eta_bridge_unit_square` (forward-pin `pullbackEtaUnitSquare`, NOT yet in file ✓): states the unit square equation; proof is the 7-step telescope. Each step names the exact Mathlib API invoked (Functor.map_comp, Adjunction.unit_naturality, Adjunction.comp_homEquiv, Adjunction.homEquiv_leftAdjointUniq_hom_app, Adjunction.comp_unit_app, presheaf mate identity, ε reconciliation). **Sufficiently detailed for a fine-grained prover; no gap or fake step found.**
    - `lem:comp_homequiv_factor_sheafify_pullback` (forward-pin `compHomEquivFactor`, absent ✓): states composite-adjunction homEquiv factorisation (standard); proof names `Adjunction.comp_homEquiv`. **Sound.** Minor: `\uses{lem:presheaf_pushforward_laxmonoidal}` is over-inclusive (the abstract lemma does not depend on the lax monoidal structure), but not incorrect.
    - `lem:leftadjointuniq_app_unit_eta` (forward-pin `leftAdjointUniqUnitEta`, absent ✓): two equalities: A.homEquiv(g) = B.unit.app(1^p) (via `homEquiv_leftAdjointUniq_hom_app`) and expansion of B.unit (via `comp_unit_app`). Both equalities are in `lem:leftadjointuniq_app_unit_eta`'s statement, and step 5 of the main telescope proof calls this out as a separate expansion step — this is harmless (steps 4–5 cover two equalities of one lemma). **Sound.**
    - `lem:epsilon_presheaf_to_sheaf_unit` (forward-pin `epsilonPresheafToSheafUnit`, absent ✓): identifies presheaf-level lax unit with `unitToPushforwardObjUnit(φ)` via sheafification compatibility. `\uses{lem:presheaf_pushforward_laxmonoidal, lem:unitToPushforwardObjUnit_comp}` — both labels exist at lines 2716, 3150. **Sound.**
  - **Revised `lem:pullback_tensor_iso_unit` proof** correctly chains: `lem:isiso_pullbacktensormap_of_sheafifydelta` → `lem:isiso_sheafifyeta_of_unitsquare` → `lem:eta_bridge_unit_square`. Logic is tight and no step is assumed without justification.
  - **`\uses{\leanok}` bugs — CONFIRMED FIXED:** Searched the file for `\uses{[^}]*\leanok` — zero matches. The three prior bugs (proof envs of `lem:tensorobj_assoc_iso`, `IsInvertible.tensorObj`, `IsInvertible.inverse_unique`) are verified fixed: `\leanok` now sits as a standalone line inside `\begin{proof}` before the `\uses{}` in all three cases.
  - **Forward-pin decls absent from file — CONFIRMED CORRECT:** `pullbackEtaUnitSquare`, `compHomEquivFactor`, `leftAdjointUniqUnitEta`, `epsilonPresheafToSheafUnit` — all four return empty from `lean_local_search`. No `\leanok` present on these statement blocks. Appropriate forward-planning; no spurious `\leanok`.
  - **Existing axiom-clean decls — CONFIRMED:** `presheafUnit_comp_map_eta` and `isIso_sheafifyEta_of_unitSquare` verified axiom-clean (kernel axioms only: propext, Classical.choice, Quot.sound). No `\leanok` on their new statement blocks yet — expected, since `sync_leanok` has not run in this iter (new blocks added by ts-etabridge; sync runs between prover and review).
  - **Citation discipline:** All six new η-bridge blocks are Archon-original mate calculus. Absence of `% SOURCE:` lines is correct, not a defect.
  - **Two `TODO` tokens in the file** are inside LaTeX comment blocks (`% NOTE: ... TODO ...`), not in active blueprint text. Not a purity or completeness issue.
  - **HARD GATE: CLEARS.** Fine-grained prover dispatch on the new atomic targets is sanctioned this iter.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Cleared by blueprint-reviewer rpf-fastpath247 this iter. Quick re-verification: 0 `\uses{\leanok}` bugs, 0 `Theorem~REF` placeholders, 7 `\lean{}` pins present, 2 `\uses{}` blocks both referencing valid labels (`def:line_bundle_on_product`, `def:pullback_along_projection`, `thm:relative_pic_quotient_well_defined`). No new issues introduced by iter-248 edits (none: this chapter had no ts-etabridge edits this iter). HARD GATE CLEAR.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 11 `Theorem~REF` placeholders in proof sketch bodies, all referencing the main relative-spectrum universal-property theorem within the chapter, whose `\label` was never assigned. A.1.a foundational chapter; no active prover; no explicit deferral entry in PROGRESS.md. **Must-fix-this-iter (plan agent should add deferral rationale to PROGRESS.md; no writer needed while A.1.a has no active prover).**

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 12 `Theorem~REF` placeholders (known deficiency). Explicit deferral in PROGRESS.md: A.2.a, HELD behind A.1.c. No new issues.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `\leanok` on 5 statement blocks (known deficiency); Lean file `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` does not yet exist. Explicit deferral in PROGRESS.md: A.3, gated A.2.c (HELD). No new issues.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 7 `Theorem~REF` placeholders in proof sketches (unresolved references to the main Auslander–Buchsbaum formula label within the chapter). A.4 Route 1 cone, HELD (gated A.2.c). **No explicit deferral entry in PROGRESS.md — plan agent should add one.**

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 12 `Theorem~REF` / `Section~REF` placeholders in proof sketches. HELD cohomology chain. **No explicit deferral entry in PROGRESS.md — plan agent should add one.**

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 7 `Theorem~REF` placeholders in proof sketches. HELD lane. **No deferral entry in PROGRESS.md.**

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 4 `Theorem~REF` / `Section~REF` placeholders. HELD cohomology. **No deferral entry in PROGRESS.md.**

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 1 `Theorem~REF` in an active remark body (line ~68: "bundled into the deferred existence hypothesis Theorem~REF"). Final assembly chapter, HELD behind all routes. **No deferral entry in PROGRESS.md.**

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 1 `Theorem~REF` placeholder. HELD. **No deferral entry in PROGRESS.md.**

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 1 `Theorem~REF` placeholder. HELD. **No deferral entry in PROGRESS.md.**

### blueprint/src/chapters/Rigidity.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 1 `Theorem~REF` placeholder. Route C PAUSED lane. **No deferral entry in PROGRESS.md.**

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - Known deficiency: Stage 2 depth-≥2 / Stacks 00TT gap. Explicit deferral in PROGRESS.md: A.4 fallback cone, HELD (gated A.2.c). No new issues.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 2 `Theorem~REF` in routing prose. Explicit deferral in PROGRESS.md: final assembly routing document. No new issues.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes. (Pointer chapter by design; no declaration blocks.)

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes. (Route C PAUSED; chapter itself is clean.)

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

## Severity summary

**must-fix-this-iter**:

1. **`Picard_RelativeSpec.tex` — complete: partial** — 11 `Theorem~REF` placeholders; A.1.a, no active prover. Action: add deferral entry to PROGRESS.md `## Deferral rationale` section (A.1.a, no active prover; writer not needed until A.1.a re-opens). Do NOT dispatch a writer this iter.

2. **`Albanese_AuslanderBuchsbaum.tex` — complete: partial** — 7 `Theorem~REF` placeholders; A.4 Route 1, HELD (gated A.2.c). Action: add deferral entry to PROGRESS.md.

3. **`Cohomology_StructureSheafModuleK.tex` — complete: partial** — 12 placeholders; HELD cohomology chain. Action: add deferral entry to PROGRESS.md.

4. **`Differentials.tex` — complete: partial** — 7 placeholders; HELD. Action: add deferral entry.

5. **`Cohomology_MayerVietoris.tex` — complete: partial** — 4 placeholders; HELD. Action: add deferral entry.

6. **`AbelJacobi.tex` — complete: partial** — 1 `Theorem~REF`; HELD behind all routes. Action: add deferral entry.

7. **`Cohomology_SheafCompose.tex` — complete: partial** — 1 placeholder; HELD. Action: add deferral entry.

8. **`Cohomology_StructureSheafAb.tex` — complete: partial** — 1 placeholder; HELD. Action: add deferral entry.

9. **`Rigidity.tex` — complete: partial** — 1 placeholder; Route C PAUSED. Action: add deferral entry.

Items 1–9 are ALL in HELD / PAUSED lanes with no active prover. The correct action is a one-line deferral entry in PROGRESS.md for each — not a writer dispatch. None of these block any active prover route.

**Already-deferred (must-fix carried from prior iters, deferral recorded in PROGRESS.md):**
- `Picard_FlatteningStratification.tex` (partial) — deferral entry present
- `Jacobian.tex` (partial) — deferral entry present
- `Albanese_CodimOneExtension.tex` (partial) — deferral entry present
- `Picard_Pic0AbelianVariety.tex` (correct: partial) — deferral entry present

**HARD GATE for `Picard_TensorObjSubstrate.tex` and `Picard_RelPicFunctor.tex`: CLEARS.** Neither the new TS must-fix items nor the carried-forward deferred chapters touch the TS or RPF chapters. Fine-grained prover dispatch on the η-bridge atomic targets (`pullbackEtaUnitSquare`, `compHomEquivFactor`, `leftAdjointUniqUnitEta`, `epsilonPresheafToSheafUnit`) is sanctioned this iter.

Overall verdict: `Picard_TensorObjSubstrate.tex` CLEARS the HARD GATE — `complete: true, correct: true`, all three prior `\leanok`-in-`\uses{}` bugs fixed, six η-bridge atomic blocks mathematically sound and prover-ready; 9 HELD/PAUSED chapters need deferral entries added to PROGRESS.md (plan agent action only — no writers needed).
