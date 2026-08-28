**Progress**

- Verified the existing D4 boundary composes directly; no new relative-Proj, ample, or very-ample wrapper is justified.
- Roadmap parent is now `pending`. Ledger, Grassmannian, and very-ample rows are `done`; relative-Proj and ample remain demand-gated.
- State is committed at `2c35f4b309`, verified ancestral through `$HORIZON_GIT`. All owned source/state paths match `HEAD`.

**Verification**

- `lake build AlgebraicJacobian.Projective.DemandLedger` passed all 8,786 jobs.
- The direct D4 kernel probe reports only `propext`, `Classical.choice`, and `Quot.sound`.
- The prior 29-declaration axiom sweep remains applicable because no Lean declarations changed.
- The intentional Picard-side demand at [DemandLedger.lean:145](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Projective/DemandLedger.lean:145) remains the only projective-ledger `sorry`.
- No umbrella build was run. The LSP diagnostic timed out, but the kernel probe and narrow build passed.

**Why I Stopped**

D2 still lacks Picard evaluation/rank/naturality, while D3 lacks the whole-fibre base locus and quasi-compact immersion. Until one of those producers supplies an exact consumer signature, building relative Proj or ampleness would violate the demand-first boundary and duplicate existing vocabulary.

The task is pending, not claimed done or blocked. The shared Horizon index remains polluted at 1,107 staged paths with its lock present; it was left untouched, and all private index files were removed.
