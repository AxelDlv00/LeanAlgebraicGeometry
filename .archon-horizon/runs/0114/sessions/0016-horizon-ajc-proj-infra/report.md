## Progress

- Added `Projective/EffectiveCartierSupport.lean`. It proves finite fibres for the schematic support of every `DivFamily` on a proper smooth geometrically integral relative curve, derives the demanded `LocallyQuasiFinite` theorem and instance, and is rooted through `AlgebraicJacobian.lean`.
- Made `Projective/DemandLedger.lean` consume that instance through `d3Support_locallyQuasiFinite_of_curve`. This closes the D3 finite-fibre/LQF input as one geometric unit; it does not count the consumer check as a second theorem.
- Committed source/API integration at `dd26508b7485` and `cb15d595e91d`, exact hgraph nodes at `f34a2841b016`, and the history-preserving roadmap release at `162de4aad094`. The D3 and projective-infra summaries retain their prior text verbatim behind explicit supersession markers, and all six projective owners are released.

## Key decisions

- Kept all affine, annihilator, and generic-point reductions private. The public API is exactly the finite-fibre theorem, the LQF theorem, and its instance; no duplicate Proj, ample, very-ample, or generic quasi-finiteness vocabulary was introduced.
- Relative Proj and ampleness remain absent because no represented Picard component exposes an elaborated consumer signature. `IsHQuasiProjectiveWith` remains the carried-`O(1)` very-ample certificate.
- The root imports `EffectiveCartierSupport` directly. The named D3 synthesis remains ledger-only so the root does not inherit the ledger's intentional producer `sorry`.

## Verification

- Lean LSP was clean after each proof edit. Narrow builds passed: `EffectiveCartierSupport` (8,719 jobs) and `DemandLedger` (8,793 jobs).
- The one permitted umbrella build, `lake build AlgebraicJacobian`, passed all 8,936 jobs; output contained only pre-existing project `sorry` warnings and the unrelated root long-line warning.
- In-memory `#print axioms` checks covered all 13 new declarations, including private helpers; every cone is exactly `propext`, `Classical.choice`, and `Quot.sound`. Split import probes confirmed the three producer exports at the root and the D3 consumer only through `Projective.DemandLedger`.
- Independent ground review found no circular LQF premise and synthesized the real `DivPushforwardFlat` consumer via `x.coherentSheafFlat_id_pushforward`.

## Issues

- Commit provenance is incomplete on five lane commits. `dd26508b7485`, `cb15d595e91d`, and `f34a2841b016` carry only `Archon-Commit`; `162de4aad094` and `27c2214563a0` carry no Archon run/session/task/project trailers.
- Attribution remains recoverable from the live transcript and Horizon state for run `0114`, session `0016-horizon-ajc-proj-infra`, task `ajc-proj-infra`, project `Algebraic-Jacobian-Challenge`. Shared history was not rewritten; this report records the defect forward.

## Why I stopped

D3 still lacks the universal whole-fibre `ExistsUnique` Grassmannian locus and its quasi-compact immersion. D2 still lacks the evaluation epimorphism, arbitrary-test locally-free rank, and pullback naturality. These are Picard-side producers; building relative Proj or ampleness before their exact signatures appear would violate the demand ledger.

The task remains pending, not done or blocked.

## Next

Construct the Grassmannian-base whole-fibre locus, using finite divisor support to descend the total-space line-bundle condition to a quasi-compact immersion on the base. Then consume that locus at the central representability seam before activating any further projective infrastructure.
