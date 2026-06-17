# Blueprint Reviewer Directive

## Slug
iter106

## Strategy snapshot

This iteration the project state is:
- Phase A (Čech acyclicity, `BasicOpenCech.lean`) — 8 consecutive PARTIAL iters on `cechCofaceMap_pi_smul`'s trailing sorry at L1120. Iter-107 prover failed option 3 (direct application of `cechCofaceMap_summand_family_R_linear`). Iter-108 abort policy is triggered: refactor `cechCofaceMap_pi_smul`'s body OR re-dispatch strategy-critic. Wrapper engineering forbidden. The remaining 5 BasicOpenCech sorries (L1212 substep a augmented Čech, L1536 localised-Čech identification, L1564 substep a for s₀, L1754 `g_R.map_smul'`, L1808 `h_loc_exact`) are deferred or gated.
- Phase B (Cotangent sheaves, `Differentials.lean`) — 5 sorries, untouched recently; `h_exact` deferred parallel to Mathlib gap `instIsMonoidal_W`.
- Phase C0 (`instIsMonoidal_W`) — Mathlib-gap deferred.
- Phase C1 (LineBundle refactor) — admitted-wrong definition; refactor not yet started.
- Phase C2 (PicardFunctor re-derivation) — not started.
- Phase C3 (Jacobian existence) — REJECTED by strategy-critic last iter; exit policy adopted: defer via JacobianWitness pattern.
- Phases D, E — closed at the signature level via JacobianWitness routing.

The strategy adopted last iter committed to a JacobianWitness exit policy for Phase C3 with the protected `Jacobian`/`ofCurve` instances reducing to `Nonempty (JacobianWitness C)`. `nonempty_jacobianWitness` is the single named gap. This iter the planner needs to know: (a) which blueprint chapters block any prover dispatch this iter; (b) whether the Phase A blueprint coverage in `Cohomology_MayerVietoris.tex` adequately documents the engine (named family, R-linearity, eqToHom transport) for an iter-108 prover or refactor; (c) whether lean-auditor-iter105 carry-over critical findings (LineBundle wrong def, instIsMonoidal_W sorry instance, 2 stale status docstrings) propagate into the blueprint chapters.

## Routes

Multiple routes are LIVE in the strategy:
- **Phase A route**: continue Čech acyclicity, blocked by L1120 + secondary deferrals. Blueprint: `Cohomology_MayerVietoris.tex`. Iter-108 might restructure `cechCofaceMap_pi_smul`'s body (refactor in place) or attack a different Phase A sorry (e.g. L1808 `h_loc_exact`).
- **Phase B route**: tackle `Differentials.lean` non-`h_exact` sorries. Blueprint: `Differentials.tex`.
- **Phase C1 route**: refactor LineBundle. Blueprint: `Picard_LineBundle.tex` (already has an iter-105 Lean-state status note added by blueprint-writer-linebundle-status).
- **Phase C3 deferred via JacobianWitness exit policy**: blueprint should reflect this honestly.

## Specific concerns
- Last iter (iter-105 Archon) you flagged 3 must-fix items: 2 broken `\uses` (MayerVietoris and StructureSheafModuleK) + LineBundle status note. All 3 reportedly resolved this iter via 3 blueprint-writers. Verify.
- The `Cohomology_MayerVietoris.tex` § "Čech acyclicity engine" prose was queued as "soon" in iter-105 — does the chapter document the iter-104/105 named-family + R-linearity engine adequately for an iter-108 refactor on `cechCofaceMap_pi_smul`'s body?
- `Picard_LineBundle.tex` should now contain Lean-state status acknowledging the `CommRing.Pic Γ(X, ⊤)` approximation. Confirm.
- `Modules_Monoidal.tex` chapter: the lean-auditor flagged the `instIsMonoidal_W` excuse-comment as critical. Does the blueprint chapter accurately frame this as a Mathlib gap?
- `Jacobian.tex`: the iter-107 strategy adopted a JacobianWitness exit policy. Does the chapter reflect this honestly, or does it claim Phase C3 will be closed within the project?

## Final blueprint goal

Determine, for THIS iter's plan dispatch:
- Which `.lean` files are blueprint-gated (chapter not `complete: true` AND `correct: true`)?
- Which need a blueprint-writer this iter to unblock?
- Are there any cross-chapter inconsistencies (e.g. one chapter claims X while another contradicts)?

Read every chapter under `blueprint/src/chapters/`. Report per-chapter completeness + correctness + iter-108 readiness. Hard-gate verdicts on:
- `Cohomology_MayerVietoris.tex` (gates Phase A iter-108 work on BasicOpenCech.lean)
- `Differentials.tex` (gates Phase B work)
- `Picard_LineBundle.tex` (gates Phase C1 refactor)
- `Jacobian.tex` (gates Phase C3 framing)

