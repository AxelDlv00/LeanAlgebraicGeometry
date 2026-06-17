# Progress-critic directive — iter-058

Assess convergence per active route from the signals below. K=5 iters. Verdict per route + named corrective for any CHURNING/STUCK.

## Route GF — AlgebraicJacobian/Picard/FlatteningStratification.lean
- STRATEGY: Iters-left = 1–2; phase (GF-geo) entered ~iter-050.
- sorry/iter: 051:1 · 052:1 · 053:1 · 054:1→2 · 055:2→1 · 056:1→1
- helpers added/iter: 053: B1 source-localization; 054: gf_flat_of_isBaseChange_id; 055: +2 (gf_section_span_flat_descent, gf_common_basicOpen_basis CLOSED); 056: +2 (gf_flat_of_isEpi, gf_isEpi_restrict_of_affine_le)
- statuses: PARTIAL ×5
- blocker phrases: "open-immersion flat-epi base change absent from Mathlib" (051–055) → **DISSOLVED iter-056** (built axiom-clean as 2 helpers). Residual now = single sorry `flatV` (per-piece flatness over Γ(S,V)=A_f), described in-code as "pure in-Mathlib localization assembly, NO Mathlib gap".
- this iter proposal: 1 prover lane, prove mode, close `flatV` → close `genericFlatness` (project headline).

## Route GR — AlgebraicJacobian/Picard/GrassmannianQuot.lean
- STRATEGY: Iters-left = 6–12; phase (GR-quot) entered ~iter-045.
- sorry/iter: 052:? · 053:? · 054:6 · 055:6→4 · 056:4→3
- helpers/closes: 054: functor.map_id dropped; 055: **functor DROPPED** (pullbackObjUnitToUnit_comp keystone closed); 056: **glue CLOSED** (equalizer-of-pushforwards)
- statuses: PARTIAL ×3 then 2 consecutive headline CLOSES (functor 055, glue 056)
- blocker phrases: none active; remaining 3 sorries (universalQuotient/tautologicalQuotient/represents) ride on net-new GL_d bundle transition cocycle (g I J matrix automorphism + hC1/hC2; hC2 hard) — NOT reachable from glue.
- this iter proposal: **NO prover lane** — blueprint-expand the bundle cocycle (effort-breaker/writer) before any prover.

## Route SNAP — AlgebraicJacobian/Picard/SectionGradedRing.lean
- STRATEGY: Iters-left = 3–6; phase (SNAP-S0) entered ~iter-050.
- sorry/iter: 0 throughout (presheaf-promotion infra build, not sorry-elimination)
- helpers added/iter: 053: isColimitCofork (objectwise coequalizer) DONE; 055: relTensorDomainPresheaf (Step-1 brick); 056: relTensorTriplePresheaf (domain row)
- statuses: 1 axiom-clean decl/iter; crux `isIso_sheafification_whiskerRight_unit` NEVER reached
- blocker phrases: 055: "T-presheaf 200k-heartbeat perf wall"; 056: "relTensorActL BLOCKED — carrier gap ↥(P.obj U) vs ↥((P.presheaf).obj U), ~12 routes ruled out". Each iter adds exactly one presheaf brick; crux still several bricks away.
- this iter proposal: 1 prover lane (scaffold relTensorActL via the prover's documented next-iter handle (1): a DISTINCT ↥(P.obj ·)-carrier ℤ-linear restriction used uniformly).

## Output
Per-route verdict (CONVERGING/CHURNING/STUCK/UNCLEAR) + corrective TYPE for any CHURNING/STUCK. Pay special attention to whether SNAP is CHURNING (one presheaf brick/iter, crux never reached) and whether one-more-handle is the right call vs a design-shape/blueprint corrective.
