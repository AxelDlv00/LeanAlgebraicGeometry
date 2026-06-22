# Project Progress

## Current Stage

prover

## Stages
- [x] init
- [x] autoformalize
- [ ] prover
- [ ] polish

## End-state overview

**Zero inline `sorry` in the dependency cone of the two genus-0 Riemann–Roch headline targets,
0 project axioms (kernel-only).** Full arc in STRATEGY.md.

Headline targets (both protected):
1. `Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero` — `ℓ(D)=deg(D)+1` (genus 0).
2. `genusZero_curve_iso_P1` — genus-0 smooth proper geom. irred. curve over `k̄` ≅ `ℙ¹`.

**iter-020 — the "shared Mathlib gap" is NOT a gap (key finding).** The valuation-membership lemma that
blocked BOTH S3 cones (G2 leaf + bridge inverse) across iters 017–019 EXISTS in Mathlib: loogle confirmed
`IsDiscreteValuationRing.exists_lift_of_le_one` (DVR `valuation ≤ 1 ⟹ lifts to A`) for the G2 leaf, and
`mem_integers_of_valuation_le_one` (Dedekind, already anchored) for the bridge, joined by
`Ring.ordFrac_eq_inverse_comp_valuation` (order↔valuation). This is the progress-critic STUCK corrective
(Mathlib-idiom consult, not a mathlib-build lane). Blueprint rewired to cite the anchors; both chapters
GATE-CLEARED (blueprint-reviewer iter020: complete+correct, 0 must-fix, anchors LSP-verified). Two parallel
prove lanes consume the existing Mathlib infrastructure directly.

## Current Objectives

Two parallel prover lanes (different files), both GATE-CLEARED.

1. **`RiemannRoch/OcOfD.lean`** — close the **G2 residue leaf** `orderAtP_residue_linearEquiv` (`sorry`
   at L~1605). Blueprint: `chapters/RiemannRoch_OcOfD.tex` (`lem:cokernel_sheafOf_single_add_stalkAtP_iso_kbar`
   + the newly-pinned leaf block). [prover-mode: prove]

   - `sheafOf.orderAtP_residue_linearEquiv` — the `k̄`-module quotient
     `orderAtP([P]+D)(P) / range(inclusion of orderAtP D(P)) ≅ k̄`. The categorical/naturality half of
     `cokernel_stalk_at_iso_kbar` is already sorry-free (iter-019); this is the SOLE remaining leaf and
     closing it makes the whole cokernel iso `cokernel_carrierSheafHom_iso_skyscraper` axiom-clean.
     Recipe (now fully Mathlib-backed): the forward map sends `g ∈ orderAtP([P]+D)(P)` to `π_P^{n+1} g mod 𝔪_P`;
     `π_P^{n+1} g` has `ord_P ≥ 0`, so by **`IsDiscreteValuationRing.exists_lift_of_le_one`** [verified iter-020,
     `Mathlib.RingTheory.Valuation.Discrete.IsDiscreteValuationRing`] (after converting `ord ≥ 0` to `valuation ≤ 1`
     via **`Ring.ordFrac_eq_inverse_comp_valuation`** [verified iter-020, `Mathlib.RingTheory.OrderOfVanishing.Noetherian`])
     it LIFTS to `𝒪_{C,P}`; reduce mod `𝔪_P` into `𝒪_{C,P}/𝔪_P = k̄` (`residueField_eq_of_coheight_eq_one` /
     `codimOne_point_residueField_eq_kbar`). Kernel = `range(orderAtP D(P))`; surjective; `k̄`-linear. Stalk
     is a DVR via `isDiscreteValuationRing_stalk_of_smooth`. Attempt the body; do not stop at a typed pin.

   - **Do NOT touch this iter:** the bridge `carrierSheaf_zero_iso_toModuleKSheaf` + section lemma
     `carrierSheaf_zero_sections_eq_structureSheaf` + naturality — these consume Lane 2's
     `chart_mem_range_of_forall_order_nonneg` and are the NEXT-iter OcOfD lane (assembly). The 2
     `sheafOf_ses_single_add` corners (gated on bridge+G2); L745 `sheafOf_singlePoint_iso` (off-cone).

2. **`RiemannRoch/CurveChartDedekind.lean`** — prove the 2 scaffolded **algebraic-Hartogs** stubs
   (compiles, 2 expected `sorry`s). Blueprint: `chapters/RiemannRoch_CurveChartDedekind.tex`
   (§"Algebraic Hartogs on a Dedekind chart"). [prover-mode: prove]

   - `chart_mem_range_of_forall_order_nonneg` (main, OcOfD-consumable) — for the Dedekind chart `A = Γ(V,⊤)`,
     a rational function `g` with `0 ≤ order Z g` at every prime divisor `Z` lies in
     `(algebraMap A V.functionField).range`. Route: `chart_isDedekindDomain V hdim` (this file, landed iter-019)
     makes `A` Dedekind; apply **`IsDedekindDomain.HeightOneSpectrum.mem_integers_of_valuation_le_one`**
     [verified iter-020, `Mathlib.RingTheory.DedekindDomain.AdicValuation`] reducing to `∀ v, valuation v g ≤ 1`;
     per height-one prime apply Decl 2. Prime-divisor ↔ height-one-prime correspondence + per-point localization
     mirror `finite_order_support_affine` (WeilDivisor.lean L892–936; stalk = `IsLocalization.AtPrime` via
     `IsAffineOpen.isLocalization_stalk`).
   - `chart_valuation_le_one_of_order_nonneg` (per-prime translation) — `0 ≤ order Z g ⟹ valuation v g ≤ 1`.
     Via `order Z g = WithZero.log (Ring.ordFrac (stalk) g)`, the DVR identity
     `Ring.ordFrac = inverse ∘ HeightOneSpectrum.valuation` (`Ring.ordFrac_eq_inverse_comp_valuation`), and
     `0 ≤ log x ↔ 1 ≤ x`; adic valuation of `A` at `v` = valuation of the localization `A_v`.

   Rich per-`sorry` `/- Planner strategy: … -/` comments are in the scaffolded file. Attempt both bodies; if
   the order↔valuation `WithZero` arithmetic stalls, leave partial progress + report the precise friction
   (→ fine-grained next iter).

## Deferred this iter (not prover objectives)

- **Bridge assembly (OcOfD)** — NEXT-iter lane once both this-iter lanes land: import CurveChartDedekind,
  close `carrierSheaf_zero_sections_eq_structureSheaf` inverse via `chart_mem_range_of_forall_order_nonneg`,
  then naturality + `NatIso.ofComponents` assembly + the 2 `sheafOf_ses_single_add` corners by transport.
  Then de-dup OcOfD's local DVR-stalk copies vs CurveChartDedekind.
- **S2 base finiteness** (`Cohomology/SerreFiniteness.lean`) — after S3. GATE: pin shared H²/Ext²-vanishing
  lemma for `lem:grothendieck_vanishing_curve` (no `\lean`, used-by 4) = same fact as RRFormula.lean:469.
- **M3-close (`RRFormula.lean`) / HEADLINE #1** — BLOCKED on S3 + S2.
- **S4 (narrow) + M5 (`RationalCurveIso.lean` + `AbelianVarietyRigidity.lean`)** — HEADLINE #2 arm; before
  dispatch add `% archon:covers AbelianVarietyRigidity.lean` to RationalCurveIso.tex (blueprint-reviewer debt).
- **S5 `injective_flasque` (`j_!`)** — out of headline cone; leave.

## Notes

- **prove mode both lanes**: each is a small focused leaf with a now-fully-Mathlib-backed recipe (no
  mathlib-build needed — the supposed gap exists). OcOfD lane = ONE leaf; CurveChartDedekind = 2 tight stubs.
- **No import changes to OcOfD this iter** (it does NOT yet import CurveChartDedekind — that wire is the
  NEXT-iter bridge-assembly lane).
- `\leanok` markers recomputed deterministically by `sync_leanok` post-prover.
- "Route C PAUSE" / "Pic representability" / "Route A" standing hints are stale parent-Jacobian carryovers
  (this subproject IS the former Route-C RR work); AUTONOMOUS directive governs.
