# Progress-critic directive — iter-035

Assess convergence per active route from the signals below. K = 4 iters.

## Route 1 — TildeExactness.lean (01I8 Route-P step P3: build `tildePreservesFiniteLimits`)
Strategy: 01I8 row, `Iters left` ~5–7; route entered current phase ~iter-032.
mathlib-build mode (named target ABSENT until built; sorry count 0→0 every iter by design — judge by helper landed + residual sharpening, NOT sorry count).

Signals (per iter):
- iter-032: prover landed P1b in a DIFFERENT file (QcohTildeSections); TildeExactness not yet created.
- iter-033: TildeExactness NEW file, PARTIAL, +3 axiom-clean helpers (`tilde_preservesFiniteColimits`,
  `tilde_toStalk_map_injective`, `tilde_preservesFiniteLimits_of_preservesKernels`). Recurring-blocker phrase:
  "Ab-stalk germ-naturality transport for mono-preservation". Also: lean-auditor refuted the docstring's
  feared "obstruction 2" (right-exact+mono⟹left-exact glue) as already-supplied by a Mathlib lemma.
- iter-034: PARTIAL, +2 axiom-clean helpers (`tilde_stalkFunctor_map_toStalk` = the germ-naturality CRUX
  the planner flagged as the single hardest piece — now DONE; `tildePreservesFiniteLimits_of_toPresheaf` =
  categorical reduction of the named target to the Ab-presheaf composite). Blocker phrase CHANGED to:
  "R-linearity of σ_x (HSMul/Module-R typeclass synthesis friction on defeq-not-syntactic stalk carrier) +
  jointly-reflecting stalk-family assembly (~100–150 LOC)".
- iter-035 (proposed): continue — package σ_x R-linear, identify with the localised map, assemble
  `PreservesFiniteLimits (~ ⋙ toPresheaf)` via the jointly-reflecting stalk family, then compose with the
  done reduction lemma to land `tildePreservesFiniteLimits`.

iter-034's watchpoint (planner-set): "a 2nd PARTIAL on the SAME Ab-stalk blocker at iter-035 triggers
re-classification." Note the blocker phrase changed iter-033→034 (germ-naturality crux landed); judge whether
this is genuine forward progress with a sharpening residual, or churn on the same wall.

## Route 2 — AffineSerreVanishing.lean (02KG cover-system) — NOT a prover lane this iter
Strategy: 02KG row, `Iters left` ~3; entered current phase ~iter-029.
Signals:
- iter-032: PARTIAL, +1 (`standard_cover_cofinal`); blocked on `toSheaf` epi-preservation build.
- iter-033: DID NOT RUN (mechanical dispatch shortfall — file byte-unchanged).
- iter-034: COMPLETE for the lane, +4 axiom-clean (`toSheaf_preservesFiniteColimits`,
  `toSheaf_preservesEpimorphisms`, `affine_surj_of_vanishing`, `affineCoverSystem`).
- iter-035: this lane gets a NON-prover correctness fix (a refactor-subagent tightens `affineCoverSystem.Cov`
  to add the covering condition `⨆ D(gᵢ)=D(f)`, which the iter-034 lean-auditor flagged as a major flaw that
  makes the gated qcoh seed unprovable). No prover dispatched on this file this iter.

## This iter's PROGRESS `## Current Objectives` proposal (prover lanes only — dispatch sanity)
2 files (both prover lanes; the AffineSerreVanishing Cov fix is handled by a refactor subagent, not a prover):
1. `AlgebraicJacobian/Cohomology/TildeExactness.lean` — continuation (mathlib-build).
2. `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` (NEW file) — P1a geometry chain, build
   `modules_restrict_basicOpen` → `tilde_restrict_basicOpen` → `presentation_restrict_basicOpen` →
   `isQuasicoherent_restrict_basicOpen` as far as possible (mathlib-build). [conditional on blueprint-reviewer
   clearing the P1a blocks this iter.]

Give a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any CHURNING/STUCK, the named
corrective type. Also flag any dispatch-sanity concern with the 2-file proposal.
