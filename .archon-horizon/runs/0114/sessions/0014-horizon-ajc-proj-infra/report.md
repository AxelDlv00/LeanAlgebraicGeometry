**Progress**

- Re-audited the live Picard seam and its new descendants. No exact relative-Proj, ample, or missing generic projective-adapter consumer has landed. `IsHQuasiProjectiveWith` remains the exact carried-`O(1)` output, and the proved D4 adapter remains the exact projective consumer.
- Reconciled the newly landed `SupportBaseChange` theorem: it proves carrier equality only, requires an explicit import, and earns no finite-fibre producer or seam credit. The roadmap now lists exactly the two open D3 obligations: relative-curve finite-fibre geometry and the whole-fibre `ExistsUnique` locus.
- A fresh D3 signature audit confirmed that `universalCandidateIdeal` lives on the Grassmannian total space. The existing `lineBundleLocus` gives pointwise factorization there, but exports neither the quasi-compact immersion nor the descent to a universal base locus needed by D3.
- Committed the demand-boundary update at `5c53ea1099`, resolved inbox hygiene at `2b66dc0113`, and the session census at `783bf26d32`; every commit was made and audited through a fresh private index.

**Verification**

- `lake build AlgebraicJacobian.Projective.DemandLedger` passed all 8,786 jobs.
- Lean LSP completed with only the intentional `sorry` warning at `DemandLedger.lean:145`.
- `#print axioms` was run on all five ledger declarations. Four report only `propext`, `Classical.choice`, and `Quot.sound`; the intentionally open producer additionally reports `sorryAx`.
- No umbrella build was run, and no Lean source declaration changed this round.

**Why I Stopped**

D2 still lacks the Picard evaluation epimorphism, arbitrary-test locally-free rank, and pullback naturality. D3 still lacks the relative-curve finite-fibre producer and the universal whole-fibre locus with a quasi-compact immersion. Until one of those producers exposes an exact consumer, adding relative Proj or ampleness would violate the demand-first boundary and duplicate existing vocabulary.

The task remains pending, not done or blocked. All six task-specific private indexes were removed. A fresh session-end measurement found the shared Horizon index lock present with 1,161 staged paths (5 added, 817 deleted, 339 modified); it was left untouched.
