# Progress-Critic Directive — iter-006

Assess convergence per active route. Two routes, both single-file prover lanes.
Below are the extracted signals for the last 4 iters (002–005; iter-005 was a
graph/dag-only stage with no prover run, so it contributes no new trajectory
data). Build is green entering iter-006.

## Route FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- Sorry counts (file): iter-002 end = 3; iter-003 = 3; iter-004 = 4.
- Helpers added: iter-003 = +2 (`pullbackIsoEquivalenceOfIso`,
  `pullback_isEquivalence_of_iso`); iter-004 = +1 axiom-clean core
  (`base_change_regroup_linearEquiv`) plus the L4 sub-lemma stubs.
- Prover statuses: iter-002 PARTIAL; iter-003 PARTIAL (proved L1/L2/L3 reads
  axiom-clean + assembled the mate lemma modulo L4); iter-004 PARTIAL (proved the
  L4-a math core `base_change_regroup_linearEquiv` axiom-clean + closed L4-c
  `base_change_mate_generator_trace`; isolated two residues).
- Genuine sorry-elimination each iter: iter-003 closed 3 read-lemmas + 2 helpers;
  iter-004 closed the L4-a core + L4-c.
- Recurring blocker phrases: (a) "regroupEquiv `map_smul'` instance/carrier wall"
  — appeared iter-004; has a CONFIRMED fix (split the helper to a separate compiled
  module, being executed this iter via a refactor); (b) "adjoint-mate generator
  trace" (`base_change_mate_generator_trace_eq`) — NEW in iter-004, the genuine
  outstanding crux, typed-sorry with full informal trace, no prove attempt yet.
- Strategy estimate: Iters left = 3–5; route entered ACTIVE at iter-002 (elapsed 3).
- iter-006 proposed objective (1 file): close the regroupEquiv `map_smul'` sorry
  via the now-separately-compiled helper one-liner; make the first real prove
  attempt at `base_change_mate_generator_trace_eq` (leave honest partial if it
  stalls); attempt `affineBaseChange_pushforward_iso` if budget remains.

## Route GF-alg — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- Sorry counts (file): iter-002 end = 2; iter-003 = 5; iter-004 = 4.
- Helpers added: iter-003 = 5 (full Nitsure-§4 chain scaffolded as stubs);
  iter-004 = 3 L3 sub-lemmas (`exact_localizedModule_powers_of_shortExact`,
  `free_localizationAway_of_free_of_eq_mul`, `free_of_shortExact_of_free_free`) —
  all CLOSED axiom-clean.
- Prover statuses: iter-002 (landed primary finite-A-module case); iter-003 PARTIAL
  (proved L1 torsion base + L5 d=0 base); iter-004 PARTIAL (closed the entire L3
  chain = 4 lemmas axiom-clean, re-signed L4 + Step-1 Noether normalisation, closed
  L5 torsion sub-case).
- Genuine sorry-elimination each iter: iter-003 closed L1 + L5-base; iter-004 closed
  the 4-lemma L3 chain + L5 torsion sub-case.
- Recurring blocker phrases: (a) "L4 denominator-clearing (Mathlib-absent)" —
  `exists_localizationAway_finite_mvPolynomial` Step-2; partial iter-003→004,
  incremental progress (Step-1 closed iter-004); (b) "L5 generic-rank dévissage /
  needs strong-induction restructure" — `exists_free_localizationAway_polynomial`
  non-torsion branch; partial iter-003→004, incremental progress (torsion subcase
  closed iter-004). Auditor flags the current L5 skeleton uses a cases-split with no
  IH in scope — filling it requires restructuring to strong induction on d.
- Strategy estimate: Iters left = 3–5; route entered ACTIVE at iter-002 (elapsed 3).
- iter-006 proposed objective (1 file): restructure L5 to strong induction on d
  (universally quantifying N) so the IH on the torsion quotient T is in scope, then
  attempt the generic-rank SES dévissage; attempt the L4 Step-2 denominator-clearing
  descent. Leave honest partials.

## Question for you
For each route: CONVERGING / CHURNING / STUCK / UNCLEAR, with the specific signal
you base it on. In particular: are the two FBC residues (instance-wall + mate-trace)
and the two GF residues (L4 denom / L5 dévissage) being genuinely whittled down each
iter, or is this helper-churn with an unmoving residual? If CHURNING/STUCK on either
route, name the corrective TYPE (blueprint expansion / effort-break / Mathlib-idiom
consult / structural refactor / route pivot). Also: is there now a demonstrated
serial bottleneck in GF that would justify splitting the file into per-residue lanes
(L4 vs L5), or should it stay single-lane?
