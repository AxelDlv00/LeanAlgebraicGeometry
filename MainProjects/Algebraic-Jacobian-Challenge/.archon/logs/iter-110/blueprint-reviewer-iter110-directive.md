# Blueprint Reviewer Directive

## Slug
iter110

## Strategy snapshot
The project formalizes the Jacobian of a smooth proper geometrically irreducible curve over a field (Merten's challenge, `references/challenge.lean`). End-state: 9 protected declarations + 6 named Mathlib-gap sorries + 1 budget-deferral.

Current named-gap roster (post iter-109 C1 promotion):

1. `Modules/Monoidal.lean:166` `instIsMonoidal_W` — varying-ring `stalk_tensorObj` gap; **load-bearing post-C1**.
2. `Differentials.lean:636` `cotangentExactSeq_structure.h_exact` — sheaf-of-modules exactness criterion; deferred parallel to `instIsMonoidal_W`.
3. `Jacobian.lean:179` `nonempty_jacobianWitness` — Hilbert/Quot schemes + finite-group quotients (Phase C3 exit policy).
4. `Picard/Functor.lean:181` `PicardFunctor.representable` — gated on C3.
5. `Picard/LineBundle.lean:82` `SheafOfModules.pullback_tensorObj` — named-deferred (analogist option (c)).
6. `Picard/LineBundle.lean:96` `SheafOfModules.pullback_oneIso` — **NEW iter-109** companion oracle (unit-preservation iso); sibling to (5).

Budget-deferral: `BasicOpenCech.lean:1846` `h_loc_exact` — `-- DEFERRED (budget): ...` annotation; mechanizable from existing Mathlib.

Phase state: Phase A escape-valve fired iter-108; Phase C1 promotion COMPLETE iter-109 (3 transient `Pic.pullback*` sorries closed); next priority is Phase B (Differentials non-h_exact sorries: L122, L718, L735, L877) or Phase C2 (PicardFunctor re-derivation, may be largely done given iter-109's clean universe bumps).

## Routes
Single end-to-end route — no alternative routes after iter-105 strategy-critic decisions (FGA-Hilbert and Sym^g/S_g for C3 both REJECTED with JacobianWitness exit policy; iter-108 mathlib-analogist Q1 ALIGN_WITH_MATHLIB recipe for C1 settled the C1 sub-route choice). The route is: Phase A (Čech acyclicity — closed-out modulo deferred substeps) → Phase B (cotangent sheaves — 4 actively workable sorries, variance flag on `serre_duality_genus` requires mathlib-analogist consult before scheduling) → Phase C1 (refined LineBundle — DONE iter-109) → Phase C2 (PicardFunctor re-derivation — largely absorbed by iter-109 universe bumps) → Phase D/E (file-level closure pending content) → Phase C3 deferred via JacobianWitness exit policy.

## References
- `references/summary.md`: high-level index (also includes the challenge file from Merten).
- `references/challenge.lean`: the upstream challenge spec; defines protected signatures.

## Focus areas (optional)
- `Picard_LineBundle.tex`: iter-109 closed `Pic.pullback*` but added `pullback_oneIso` as a new named-deferred sister gap. The blueprint should record `pullback_oneIso` as a sibling theorem block to `pullback_tensorObj`; the proof block of `\thm:Scheme_Pic_pullback` should reflect the hand-construction (not the unrealized `Skeleton.monoidHom` route); the "remain `sorry`" prose at L62 and L81 is stale (the three `Pic.pullback*` bodies are now closed, gated only on the two oracles). Verify whether plan-agent edits I will make this iter address these findings adequately, OR re-flag as must-fix if they don't.
- `Differentials.tex` (or `Differentials_*.tex` if it has been split): on the cusp of becoming an active prover-route. Audit whether the chapter is adequate for a prover to formalize one of L122 (`relativeDifferentialsPresheaf_isSheaf`), L718 (`smooth_iff_locally_free_omega`), L735 (`cotangent_at_section`) WITHOUT the `serre_duality_genus` variance flag triggering. The variance flag for L877 is well-known; do not re-flag L877.
- `Cohomology_MayerVietoris.tex`: substep numbering cleanup deferred from iter-109 (cosmetic; substep numbering inconsistency at L1196 vs L1167-1176; missing `IsLocalizedModule.prodMap` mention; 3-tuple Mathlib-gap-list stale — should be 6+1 post-iter-109). Iter-109 plan called this MINOR; re-verify and consider whether iter-110 should fire the writer.

## Known issues
- The 6 named-gap sorries + 1 budget-deferral surface is locked-in. Do NOT re-flag them as findings unless their disclosure in the blueprint is incorrect.
- The off-limits BasicOpenCech sub-routes (L1120 PAUSED; L1212/L1536/L1564 substep-deferred; L1754 gated on L1120; L1846 budget-deferred) carry historical scaffolding that should be preserved as inert infrastructure. Do not re-flag these as "incomplete".
- The C1 promotion that landed iter-109 is final; do not re-litigate the choice of `(Skeleton X.Modules)ˣ` vs alternative bodies. Per blueprint-checker-linebundle-iter109 PASS, the body is mathematically correct.
- `Jacobian.lean`'s C3 exit policy via `JacobianWitness` is final; do not propose alternative C3 routes.
