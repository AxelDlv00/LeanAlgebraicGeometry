# Progress-critic directive — iter-028

Assess convergence of the single active route. Fresh-context: do NOT read STRATEGY.md, blueprint, or
sidecars; judge only from the signals below.

## Active route: 01EO Čech↔cohomology comparison chain → `affine_serre_vanishing`
Files: `AbsoluteCohomology.lean` (Form-B absolute cohomology), `CechToCohomology.lean` (the 01EO
L1→L2→L3→L4→top chain). This route entered its current phase at **iter-026** (Form-B scaffold opened).
STRATEGY's current estimate for the phase: **Iters left ~3–4** (so iter-028 is iter 3 of an estimated
3–4-iter phase).

### Last 4 iters' signals
| Iter | Prover status | Named targets landed | Helpers/decls added | Project sorry | Recurring blocker phrases |
|---|---|---|---|---|---|
| 025 | COMPLETE | `injective_cech_acyclic` (P3b bridge final brick) | +1 named (+ reused 024 bricks) | 2 → 2 | none |
| 026 | COMPLETE | Form-B scaffold: `jShriekOU`, `absoluteCohomology`, H⁰≅Γ, injective vanishing, 3 LES wrappers | +10 axiom-clean | 2 → 2 | none |
| 027 | COMPLETE (2 lanes) | `absoluteCohomologyZeroAddEquiv_naturality` (Lane 1); L1 `cechComplex_shortExact_of_basis` + L2 `quotient_cech_vanishing_of_basis` (Lane 2) | +5 (Lane1) +12 (Lane2) axiom-clean | 2 → 2 | none |
| 028 (proposed) | — | proposed prover target: per-face SES derivation + L3 `absoluteCohomology_one_eq_zero_of_basis` + L4 `absoluteCohomology_eq_zero_of_basis` + top `cech_eq_cohomology_of_basis` | (to be built) | 2 (both frozen/superseded) | — |

Notes on the signals:
- The 2 project sorries are constant and both intentional (a superseded relative-form `CechAcyclic.affine`,
  and the frozen P5b protected target); no new sorries any iter.
- Every iter landed its planned named target(s) axiom-clean on the first prover attempt; zero reverts,
  zero route-restarts.
- Helpers added each iter are matched to landed targets (not orphan churn) and were blueprinted the
  following plan phase (coverage debt returns to 0 each cycle).

## This iter's proposed objective (dispatch-sanity check)
ONE prover lane: `CechToCohomology.lean` (mathlib-build mode) — build, in dependency order, the per-face
SES derivation, L3, L4 (with `BasisCovSystem`/`HasVanishingHigherCech` defs), and the top assembly, as
far as axiom-clean progress allows; hand off a clean decomposition if L4's induction proves heavy.
Plus blueprint reconciliation (blueprint-writer) of the L1/L2 prose + coverage debt + L3/L4 scaffolds,
and a root-import refactor — neither is a prover lane.

## Question for you
Is this route CONVERGING, or is the steady "+N decls, sorry constant" pattern masking churn? Is loading
the single lane with per-face-SES + L3 + L4 + top reasonable for one mathlib-build session, or should
L4 (the `BasisCovSystem` induction) be split to its own iter? Verdict per the standard scale
(CONVERGING / UNCLEAR / CHURNING / STUCK) with a one-paragraph justification and, if not CONVERGING,
the named corrective.
