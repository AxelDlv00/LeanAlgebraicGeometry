# Mathlib Analogist Report

## Slug
m3-route-audit-iter123

## Iteration
123

## Question

M3 route-pick audit. Estimate, per route, the cumulative LOC of upstream
Mathlib work the project would need to contribute (or backfill in-tree)
to formalize `positiveGenusWitness` (i.e. the higher-genus case of
`AlgebraicGeometry.nonempty_jacobianWitness`,
`AlgebraicJacobian/Jacobian.lean:176`) for an arbitrary smooth proper
geometrically irreducible curve `C / k` with `genus C ≥ 1`.

Routes:
- **A**: Picard scheme via FGA (Hilbert / Quot representability +
  identity-component of a `k`-group scheme).
- **B**: Symmetric powers + Stein factorisation (`Sym^n` of schemes,
  coherent direct image and Stein, Brill-Noether / Riemann-Roch).

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Route A vs Route B (route pick) | NEEDS_MATHLIB_GAP_FILL — escalate to user | critical |
| A1: Hilbert representability + supporting QCoh/Coh/flattening | NEEDS_MATHLIB_GAP_FILL | informational |
| A2: Quot representability (post-Hilbert) | NEEDS_MATHLIB_GAP_FILL | informational |
| A3: Identity-component `G^0 ⊆ G` as closed subgroup scheme | NEEDS_MATHLIB_GAP_FILL | informational |
| B1: Symmetric powers `Sym^n C` with smoothness | NEEDS_MATHLIB_GAP_FILL | informational |
| B2: Stein factorisation (incl. coherent `f_*` and Relative Spec) | NEEDS_MATHLIB_GAP_FILL | informational |
| B3: Riemann-Roch + Brill-Noether for curves | NEEDS_MATHLIB_GAP_FILL | informational |

## LOC summary

| Piece | Low | High | Midpoint | Cross-utility |
|---|---:|---:|---:|---|
| A1 Hilbert + QCoh/Coh/flattening | 3400 | 4900 | 4150 | HIGH |
| A2 Quot (post-A1) | 1100 | 1700 | 1400 | HIGH |
| A3 Identity-component subgroup scheme | 850 | 1200 | 1025 | MEDIUM-HIGH |
| **Route A total** | **5350** | **7800** | **~6500** | |
| B1 `Sym^n` of schemes + smoothness | 2350 | 3800 | 3075 | LOW-MEDIUM |
| B2 Stein factorisation | 2200 | 3400 | 2800 | HIGH |
| B3 Riemann-Roch + Brill-Noether | 2650 | 4250 | 3450 | MEDIUM |
| **Route B total** | **7200** | **11450** | **~9000** | |

A-vs-B shared infrastructure (QCoh + Coh + relative Spec) accounts for
~1000-1500 LOC of overlap — material if both are pursued, but does
not bring either route below the 5000-LOC line.

## Must-fix-this-iter

None. The audit is read-only and the project has not "shipped" either
route — both are deferred behind `nonempty_jacobianWitness`. There is
nothing to refactor; there is a routing decision to surface.

## Major

The plan agent for iter-124 should:

1. **Trigger user escalation per STRATEGY.md's hard fallback rule.**
   Both Route A (≈6500 LOC) and Route B (≈9000 LOC) exceed the
   5000-LOC threshold. The decision is "external Mathlib PR vs.
   in-project build vs. indefinite deferral", and is a user-level
   call.

2. **Surface the route ranking honestly** if the user asks for one:
   Route A is preferred on cross-utility grounds (Hilbert / Quot /
   identity-component are top-tier Mathlib infrastructure; `Sym^n`
   smoothness and curve-side RR are narrower). LOC also favours
   Route A by ≈2500 LOC at the midpoint.

3. **Offer the smallest extractable upstream-PR pieces** to the user
   as concrete external-PR proposals (each well under 1500 LOC,
   each self-contained, each useful regardless of which route the
   project eventually picks):

   - **Relative Spec functor** `Spec_Y : QcohAlg(Y)^op ⥤ Sch/Y`
     — ~700-1100 LOC. **Top recommend.** Strict prerequisite for
     Stein (Route B) and useful for affine-map factorisation in any
     FGA setup (Route A).
   - **Identity-component of a `k`-group scheme** as a closed
     subgroup scheme (generalising
     `Subgroup.connectedComponentOfOne`,
     `Mathlib.Topology.Algebra.Group.Basic:740`) — ~850-1200 LOC.
     Needed by both routes (Route A directly; Route B via the
     `Pic^g(C) → Jac(C)` translation).
   - **Quasi-coherent + Coherent typeclass on
     `Scheme.SheafOfModules`** (lifting the abstract
     `SheafOfModules.Presentation.IsFinite` at
     `Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent:52` to a
     scheme-level typeclass with affine/Tilde calibration) —
     ~700-900 LOC. Foundational for *every* downstream coherent-sheaf
     theorem.

4. **Do not** continue treating M3 as a "next-iter prover lane". The
   audit finds no realistic prover-loop-sized decomposition; M3 is
   genuinely a 5000+ LOC infrastructure project and should not be
   driven autonomously.

## Informational

- **Mathlib snapshot used**: lake-manifest neighbourhood of `b80f227`.
  Searches verified absence of `PicardScheme`, `HilbertScheme`,
  `QuotScheme`, `Scheme`-side `Sym^n`, scheme group-action, scheme
  quotient by a finite group, Cartier/Weil divisor on a general scheme,
  `RiemannRoch`, `BrillNoether`, `SteinFactorization`, `RelativeSpec`,
  higher direct image `R^i f_*`.
- **Partial infrastructure that *is* present** (cited in the persistent
  file for each piece): `LocalRepresentability.isRepresentable`,
  `isCommMonObj_of_isProper_of_geometricallyIntegral`,
  `smooth_of_grpObj_of_isAlgClosed`,
  `finite_appTop_of_universallyClosed`,
  `SheafOfModules.Presentation.IsFinite`,
  `Subgroup.connectedComponentOfOne` (topological-group only),
  `CommRing.Pic`.
- **Alternative routes** considered and dismissed (Chevalley-decomposition
  assist, étale-local linearisation, indefinite deferral) — see the
  persistent file. None are materially cheaper than A or B.
- **Cross-route overlap**: Route A and Route B both need
  quasi-coherent/coherent infrastructure and the relative-Spec functor.
  A combined effort saves ~1000-1500 LOC vs. summing route estimates.

## Persistent file
- `analogies/m3-route-audit.md` — full per-piece audit with sub-piece
  LOC breakdowns, cross-utility flags, smallest-PR extractables, and
  alternative-route notes. Usable by future iters' plan agents and any
  iter-128+ prover lane on M3.

Overall verdict: **NEEDS_MATHLIB_GAP_FILL on both routes; both exceed
the 5000-LOC escalation threshold; iter-124 plan agent must escalate to
the user for an external-PR routing decision, with Route A preferred on
cross-utility and the Relative-Spec functor identified as the smallest
clean Mathlib-PR extractable piece (~1000 LOC).**
