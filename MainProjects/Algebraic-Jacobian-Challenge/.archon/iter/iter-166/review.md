# Iter-166 (Archon canonical) — review

## Outcome at a glance
- **The "AVR refactor + scaffold-close" iter.** Two parallel prover lanes — Lane 1 on
  `AlgebraicJacobian/AbelianVarietyRigidity.lean` (refactor + proof close per the iter-166 plan)
  and Lane 2 on `AlgebraicJacobian/Genus0BaseObjects.lean` (live-consumer scaffold closures).
- **Lane 1 delivered (PARTIAL per plan target):** import + signature refactor (`P1 → ProjectiveLineBar`)
  + proof bodies for `morphism_P1_to_grpScheme_const` (L1089) and
  `rigidity_genus0_curve_to_grpScheme` (L1156); `genusZero_curve_iso_P1` (L1131) signature
  refactored, body deferred (RR bridge). The new private helper
  `morphism_P1_to_grpScheme_const_aux` (L931) carries the ≈100-LOC 𝔾ₘ-scaling shortcut body
  with 5 honest helper sorries.
- **Lane 2 delivered (PARTIAL per plan target):** 3 of 7 plan-flagged live-consumer scaffold
  sorries closed — `ProjectiveLineBar.zeroPt` / `.onePt` / `.inftyPt` (L268/L274/L280) all
  **axiom-clean** (`{propext, Classical.choice, Quot.sound}`, kernel — verified this review).
  3 CRITICAL deferred (`gm_grpObj`, `gmScalingP1` body, `gmScalingP1_collapse_at_zero` body)
  + 3 OPT-IN deferred (`projectiveLineBar_geomIrred`, `..._smoothOfRelDim`, `ga_grpObj`) remain.
- **Dispatch MATCHED the plan — 9th consecutive iter** with no plan/dispatch contradiction.
- **Global bare-sorry 15 → 15 (NET unchanged, by design).** Per-file inventory:
  - `AbelianVarietyRigidity.lean` — 6 (3 → 6: the 3 deferred genus-0 scaffolds were
    converted to proof bodies that internally rely on 5 helper sorries; `genusZero_curve_iso_P1`
    keeps its 1 RR-bridge sorry).
  - `Genus0BaseObjects.lean` — 6 (9 → 6: 3 closed axiom-clean; 6 deferred).
  - `Jacobian.lean` — 2 (unchanged).
  - `RigidityKbar.lean` — 1 (unchanged).
  No new `axiom`; no protected signature touched; `lake build AlgebraicJacobian.AbelianVarietyRigidity`
  and `lake build AlgebraicJacobian.Genus0BaseObjects` both green (sorry warnings only).

## The advance, independently verified this review
1. **`morphism_P1_to_grpScheme_const` body landed** — signature refactored to drop the abstract
   `P1` parameter; body proven via the 𝔾ₘ-scaling shortcut (outer reduction to base-point case
   via group division `f / (toUnit ≫ zeroPt ≫ f)` + private helper
   `morphism_P1_to_grpScheme_const_aux`). `lean_verify` axioms `{propext, sorryAx,
   Classical.choice, Quot.sound}` — sorryAx propagates honestly through the helper's 5
   internal sorries. Lifts to axiom-clean once helper sorries discharge.
2. **`morphism_P1_to_grpScheme_const_aux` (private helper, L931)** — ≈100-LOC body
   implementing the pointed case `(zeroPt ≫ f = η[A]) ⟹ f = 1`. Wires: W-axis collapse via
   `gmScalingP1_collapse_at_zero` precomposed with `Gm.onePt`; applies Cor 1.5
   (`hom_additive_decomp_of_rigidity`) with `V = ProjectiveLineBar`, `W = Gm`, base points
   `zeroPt` and `onePt`; collapses the W-axis restriction to `1` via the basepoint hypothesis;
   reads `σ ≫ f = fst ≫ fV`; specialises at `x = 1` via
   `iotaGm := lift (toUnit Gm ≫ onePt) (𝟙 Gm) ≫ gmScalingP1`; globalises via dominance +
   `[IsSeparated A.hom]` (derived from `IsProper.toIsSeparated`). The basepoint hypothesis
   `hf0` is genuinely consumed (`hcorhyp := hcollapse ▸ hf0` feeds Cor 1.5).
3. **`rigidity_genus0_curve_to_grpScheme` body landed** — clean iso-transport from
   `morphism_P1_to_grpScheme_const` under `genusZero_curve_iso_P1`'s iso. `lean_verify` axioms
   identical (sorryAx propagation only — through `genusZero_curve_iso_P1` + the helper's 5
   sorries).
4. **`ProjectiveLineBar.zeroPt` / `.onePt` / `.inftyPt` PROVEN axiom-clean.** Construction
   via shared `pointOfVec` helper using `Proj.fromOfGlobalSections` of a vector evaluation,
   with the irrelevant-ideal condition discharged from `IsUnit (v i)` of one coordinate. The
   section condition `fromOfGlobalSections ≫ ProjectiveLineBar.hom = 𝟙` chases through
   `fromOfGlobalSections_toSpecZero` + scalar-tower collapse to `MvPolynomial.C` +
   `MvPolynomial.eval_C` + `AlgebraicGeometry.toSpecΓ_SpecMap_ΓSpecIso_inv`. Unit-coordinate
   conventions verified: `[0:1]` ≡ affine origin, `[1:1]` ≡ affine unit, `[1:0]` ≡ point at
   infinity (matches chapter `x = X₀/X₁` convention).

## Is this iter-157 laundering again? No.
Explicitly checked by both `lean-auditor-iter166` and `lean-vs-blueprint-checker-avr-iter166`:
- `morphism_P1_to_grpScheme_const` outer body is `sorry`-free but delegates to the helper
  whose 5 internal sorries are honest open math obligations (Mathlib bridge work +
  Lane-2-dependency), not signature-stripping.
- `morphism_P1_to_grpScheme_const_aux` substantively consumes `hf0 : zeroPt ≫ f = η[A]`
  (L975: `rw [← Category.assoc, hcollapse]; exact hf0`).
- `rigidity_genus0_curve_to_grpScheme` substantively consumes `_hf : p ≫ f = η[A]` (pinned via
  basepoint transport along `φ.hom`).
- No theorem with a sorry-free top-level body has a helper that drops a load-bearing
  hypothesis. `_hf`/`hf0`/`hα`/`_hgenus` are all threaded.

## Review-phase subagents (3 dispatched, all COMPLETE)

| Subagent | Slug | mf / maj / min | Headline |
|---|---|---|---|
| `lean-auditor` | iter166 | 0 / 11 / 3 | Iter-166 sound; 5 helper sorries verified open obligations; point-soundness verified; no laundering. Hygiene debt: 6 stale-narrative carry-overs (iter-164) still in place + 5 NEW redundant `-- TODO:` excuse-comments inside `morphism_P1_to_grpScheme_const_aux` that duplicate the kernel `sorry` + docstring disclosure. |
| `lean-vs-blueprint-checker` | avr-iter166 | 0 / 0 / 3 | Iter-166 Lane 1 refactor faithfully matched by chapter; helper decomposition + RR-bridge sorry honestly acknowledged via `rmk:genusZero_iso_subbuild`. 3 informational on adding `\lean{}` for the helper + naming the 5 scaffold sorries as blueprint obligations + stripping 3 off-path Route-A `\lean{}` hints. |
| `lean-vs-blueprint-checker` | g0bo-iter166 | 1 / 6 / 1 | The 1 must-fix is `gmScalingP1` body sorry on a chapter-pinned `\lean{...}` — but the directive marks it plan-deferred to iter-167+ (already tracked). 6 majors = missing `\lean{...}` hooks (iter-165 carry-over: 3 new ℙ¹-points + `gmScalingP1_collapse_at_zero` + `gm_grpObj` + `Ga`/`Gm`). Point-soundness verified `[0:1]`/`[1:1]`/`[1:0]`; private helper privacy correct. |

Reports: `logs/iter-166/{lean-auditor-iter166, lean-vs-blueprint-checker-avr-iter166,
lean-vs-blueprint-checker-g0bo-iter166}-report.md`.

## Actions taken this review
- Added `% NOTE (iter-166 review)` blocks to two proof blocks in
  `blueprint/src/chapters/AbelianVarietyRigidity.tex`:
  - `prop:morphism_P1_to_AV_constant` (L1224-1279) — flags the Lean outer/helper split +
    enumerates the 5 honest helper sorries + corroborates checker's "no laundering" finding.
  - `thm:rigidity_genus0_curve_to_AV` (L1370-1383) — records the iter-166 body landing +
    `sorryAx` propagation chain.
- Did NOT touch any `\leanok` (sync-owned).
- Wrote journal (summary/milestones/recommendations); updated PROJECT_STATUS.md Knowledge Base
  with 5 new Proof Patterns (pointOfVec/Proj.fromOfGlobalSections k̄-point recipe;
  iso-transport of rigidity headline through curve-iso; `set ι` token trap;
  `IsProper.toIsSeparated` derivation; inline `ext_of_isDominant_of_isSeparated'`); refreshed
  the `## Last Updated` ledger entry; updated TO_USER.md.

## For the next plan agent (see recommendations.md)
1. **HIGH:** dispatch `mathlib-analogist (api-alignment)` on the 4 product-stability +
   Proj-integrality questions BEFORE the prover lane on the helper-internal residuals.
2. **HIGH:** dispatch `mathlib-analogist (api-alignment)` on `GrpObj.ofRepresentableBy` +
   units-functor BEFORE the prover lane on `gm_grpObj`.
3. **HIGH:** schedule a 2-lane parallel round for iter-167 (Lane A = `gm_grpObj` +
   `gmScalingP1` body + companion; Lane B = the 4 non-iotaGm AVR helper sorries + redundant-TODO
   cleanup). `IsDominant iotaGm.left` slips to iter-168 once Lane A lands a body.
4. **MEDIUM:** dispatch blueprint-writer on `AbelianVarietyRigidity.tex` per-decl `\lean{...}`
   coverage gap (still open from iter-165 — 3 ℙ¹-points + `gmScalingP1_collapse_at_zero` +
   `gm_grpObj` + `Ga`/`Gm`).
5. **MEDIUM:** consider a stale-narrative purge iter — 6 files of carry-over (iter-164 flagged,
   still live).

## Standing recommendations carried over
- `sync_leanok` keyword-stripping fix (`.debug-feedback` iter-164) — has it run successfully
  this iter? No `marker-sync` artifact under `logs/iter-166/` to confirm.
- The `genusZeroWitness.key` descent (in `Jacobian.lean`) remains gated on
  `rigidity_genus0_curve_to_grpScheme` axiom-cleanness, which itself depends on
  `genusZero_curve_iso_P1` (RR bridge) + the 5 helper sorries — multi-iter dependency chain.

## Subagent skips

(None — all 3 highly-recommended review subagents dispatched.)
