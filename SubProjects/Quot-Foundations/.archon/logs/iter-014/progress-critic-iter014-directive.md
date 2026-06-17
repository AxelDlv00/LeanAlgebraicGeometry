# Progress-critic directive — iter-014 (Quot-Foundations)

Assess convergence per active route from the signals below. K = last prover iters
(iter-011, iter-012; iter-013 was a DAG-only iter with no prover phase, no trajectory
data). Verdict per route: CONVERGING / CHURNING / STUCK / UNCLEAR. CHURNING/STUCK are
must-fix; name the corrective TYPE.

## Route GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`
Strategy phase: GF-alg, ACTIVE. STRATEGY `Iters left` = 2–4; phase entered at iter-009
(effort-break). Elapsed prover iters in phase: 011, 012 (+ 009).
Signals:
- iter-009: effort-break of `gf_torsion_reindex` into 4 sub-lemmas (Nagata machinery).
- iter-011: sorry 5→5; +3 axiom-clean Nagata sub-lemmas landed (helpers added, residual flat).
- iter-012: sorry 5→5; `gf_torsion_reindex` — SUBSTANTIAL VERIFIED PROGRESS (the hard content
  `Module.Finite (P_g/span{F_g}) T_g'` landed and compiles), still 1 sorry. Helpers added in-body
  (not top-level). Blocker phrase: "the (a)-(e) bookkeeping residue, assembled INLINE, blows
  `isDefEq`/`whnf` heartbeats even at 1,000,000 — factor each of (a)-(e) into a standalone
  top-level helper lemma." So the wall is Lean instance-stacking engineering, not missing math.
- iter-012 verdict (prior critic): CHURNING (helpers in 2/4 iters, sorry flat at 5).
Proposed iter-014 action: close `gf_torsion_reindex` by factoring (a)-(e) into top-level helper
lemmas, then assemble (the prover's own explicit lesson). [prove]

## Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
Strategy phase: FBC-A, ACTIVE. STRATEGY `Iters left` = 2–4; phase active since pre-extraction.
Signals:
- iter-011: sorry 5→3 (`regroupEquiv` `map_smul'` wall CLOSED — multi-iter wall broken).
- iter-012: sorry 3→5 (INTENTIONAL decomposition): `base_change_mate_section_identity` proved
  modulo Seam 3 (own body sorry-free), `base_change_mate_inner_value` PROVEN axiom-clean, and 3
  precisely-typed seam holes created (`unit_value`/`fstar_reindex`/`gstar_transpose`). Seam 3 has
  a partial body (`Functor.map_comp` first step).
- Recurring blocker phrase: "deep adjoint-mate/conjugate coherences, Mathlib-absent; element-level
  `ext` chases dead-end because `conjugateIsoEquiv`'s element action is opaque; closing needs
  abstract `Adjunction.conjugateEquiv` naturality." Prover explicitly requested a mathlib-analogist
  consult on conjugate-adjunction unit transport.
Proposed iter-014 action: close Seam 1 (`base_change_mate_unit_value`, the square-free base case)
via the abstract conjugateEquiv route, with a mathlib-analogist analogies file in hand; cascade
Seam 2/3 if Seam 1 lands. [prove]

## Route QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`
Strategy phase: SNAP (S2), ACTIVE. STRATEGY `Iters left` = 2–4; SNAP-S2 first proved iter-012.
Signals:
- iter-011: +5 axiom-clean predicate/annihilator decls.
- iter-012: +8 axiom-clean power-series-engine decls (the COMPLETE power-series half of Stacks
  00K1); public `gradedModule_hilbertSeries_rational` NOT added — blocked on a genuine Mathlib gap
  (no graded-module quotient/kernel/regrading API). sorry 4→4 (the 4 are downstream-blocked stubs).
- iter-012 verdict (prior critic): UNCLEAR (1 real prover data point).
Proposed iter-014 action: NO prover lane (the residual needs a graded-module-API sub-build that is
not yet blueprinted); set up via a mathlib-analogist api-alignment consult on the graded-module API
shape this iter, blueprint + mathlib-build NEXT iter.

## Route GR — `AlgebraicJacobian/Picard/GrassmannianCells.lean`
Signals: iter-011 +16 decls; iter-012 +12 decls, `lem:gr_cocycle` CLOSED, file GREEN (0 sorry).
Proposed iter-014 action: NONE (route file complete; next GR target `def:gr_glued_scheme` needs a
scheme-gluing API not yet chosen — out of this file).

## This iter's `## Current Objectives` proposal (dispatch-sanity)
2 prover lanes, import-independent, different files:
1. FlatteningStratification.lean — GF reindex close (helper-factoring). [prove]
2. FlatBaseChange.lean — FBC Seam 1 close (abstract route). [prove]
(QUOT + GR not dispatched as prover lanes — rationale above.)
Check: is 2 lanes the right call, or am I walking GF/FBC into the same wall with a reworded recipe?
