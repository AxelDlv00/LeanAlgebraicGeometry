# Progress-critic — iter-055 convergence audit

Assess convergence per route from the extracted signals below. Verdict per route
(CONVERGING / CHURNING / STUCK / UNCLEAR) + named corrective for any CHURNING/STUCK.

## Route GF — AlgebraicJacobian/Picard/FlatteningStratification.lean
Strategy: GF-geo, Iters-left=1–2, entered geometric phase ~iter-053. Hard close deadline iter-055.
Signals (sorry count this file / helpers added / status / blocker):
- iter-051: sorry 1→1; G1 base case closed (gf_qcoh_fintype_finite_sections); status PARTIAL.
- iter-052: sorry 1→1; +3 axiom-clean G3 anchors, but the route they served (sheaf stalk) found DEAD.
- iter-053: sorry 1→1; +2 axiom-clean (B1.0/B1 source-span algebra core); status PARTIAL; algebra DONE.
- iter-054: sorry 1→2; +3 axiom-clean (B2.1/B2.2/B2.3) + B2.4 assembled riding on 1 new narrow helper sorry
  (gf_common_basicOpen_basis); genericFlatness still open; status PARTIAL.
- Recurring blocker phrase: "genericFlatness close = large module-instance assembly (gf_flat_locality_assembly,
  does-not-exist) + cover scaffold; not yet built." Prior verdict iter-054: STUCK.
- Remaining this iter: close gf_common_basicOpen_basis Step-3 (recipe in-code), build gf_flat_locality_assembly,
  close genericFlatness over Module.flat_of_isLocalized_span.

## Route GR — AlgebraicJacobian/Picard/GrassmannianQuot.lean
Strategy: GR-quot, Iters-left=6–12, long-running. 
- iter-051: chartQuotientMap_epi closed.
- iter-052: 5 decl-sorries, no drop; +4 axiom-clean (pullbackBaseChangeTransport + 3 bridges).
- iter-053: 5 decl-sorries, no drop; +8 axiom-clean; functor assembled with 2 internal law-sorries.
- iter-054: functor.map_id CLOSED (declaration-sorry DROP) + 2 axiom-clean coherence lemmas; map_comp reduced
  to one named gap pullbackObjUnitToUnit_comp; sorry 5→6 (the +1 is the documented partial). status PARTIAL.
- Prior verdict iter-054: CHURNING (had then gone 2 iters w/o a declaration-sorry drop; iter-054 broke that).
- Remaining: close pullbackObjUnitToUnit_comp (recipe documented) → pullbackFreeIso_comp → map_comp → functor
  drops; then attempt glue (the bottleneck for 3 riders).

## Route SNAP — AlgebraicJacobian/Picard/SectionGradedRing.lean
Strategy: SNAP-S0, Iters-left=3–6, phase active since ~iter-048.
- iter-051: objective DROPPED by no-op filter (file 0-sorry, scaffold keyword landed off the filename line);
  prover NEVER dispatched.
- iter-052: +3 axiom-clean reduction lemmas; file 0-sorry.
- iter-053: +22 axiom-clean (objectwise relative-tensor coequalizer isColimitCofork — the hard Mathlib-absent
  brick); file 0-sorry.
- iter-054: NO committed prover output — objective DROPPED AGAIN by the no-op filter (scaffold keyword on the
  continuation line, not the filename line). Prover NEVER dispatched.
- The make-or-break crux (isIso_sheafification_whiskerRight_unit, the presheaf-promotion path) has NEVER been
  attempted because the objective keeps being filtered out before dispatch.
- Prior verdict iter-054: CHURNING.
- This iter: objective is reformatted with the scaffold keyword ON the filename line so dispatch actually fires.

## PROGRESS.md proposal this iter (3 prover lanes, 1 file each)
1. FlatteningStratification.lean (GF) — close gf_common_basicOpen_basis + build assembly + close genericFlatness.
2. GrassmannianQuot.lean (GR) — close pullbackObjUnitToUnit_comp → functor; then attempt glue.
3. SectionGradedRing.lean (SNAP) — build relativeTensorCoequalizerIso (presheaf promotion) + crux.

Question to answer: which routes are genuinely converging vs churning, and is SNAP's "CHURNING" a math stall or a
mechanical dispatch artifact? Name the corrective for any CHURNING/STUCK.
