# Progress-critic directive — iter-020

Assess convergence per active route from the last 4–5 iters of signals. Verdicts feed the
planner's stuck-protocol gate. Three routes below; for each: per-iter sorry counts, helpers
added, prover statuses, recurring blocker phrases, the STRATEGY estimate, and the planner's
proposed iter-020 action.

---

## Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

Target: close the i=0 base-change-map iso via a 3-seam adjoint-mate computation. The live
bottleneck is the **Seam-2 assembly** `base_change_mate_fstar_reindex_legs` (step-(iii)
"mate-unwinding crux").

- Per-iter **file sorry counts**: iter-015 = 4, 016 = 4, 017 = 4, 018 = 4, 019 = 4.
- Per-iter **helpers added**: 017 = +4 (codomain_read_legs + 3 Γ-collapse), 018 = +0 (comment + one
  scaffolding line only), 019 = +2 (`_unitExpand`, `_gammaDistribute`, both axiom-clean).
- Per-iter **prover status**: 015 PARTIAL, 016 PARTIAL, 017 PARTIAL, 018 PARTIAL, 019 PARTIAL.
- **Recurring blocker phrase**: the Seam-2 step-(iii) assembly goal is UNMOVED for 6 consecutive
  iters (014–019). iter-018 named it the "literal-form lock"; iter-019 confirmed: after `subst` of
  the legs, the locked leg literal `(pullbackSpecIso …).hom ≫ Spec.map …` will not unify with the
  metavariable composite pattern `?a ≫ ?b`, so `rw [unitExpand]` cannot even MATCH into the
  assembly. iter-019 also found a pervasive `X.Modules` instance diamond that defeats tactic-mode
  `rw`/`simp` (worked around in term mode for the 2 closed sub-lemmas).
- iter-019 corrective executed = **structural decomposition** (effort-break into 5 standalone atomic
  sub-lemmas, whole-goal prohibited). Outcome: 2/5 closed (`_unitExpand`, `_gammaDistribute`); the
  remaining 3 (`_eCancel`, `_affineUnit`, `_innerMatch`) **could not be stated standalone** — the
  prover reports they are "assembly-internal" (their Lean types are only fixed by the mid-assembly
  goal state, which the leg-lock prevents reaching).
- STRATEGY `## Phases & estimations`: **FBC-A — Iters left = 3–4**; phase has been ACTIVE since the
  early iters (well past estimate; OVER_BUDGET).
- **Planner's proposed iter-020 action for FBC**: NO FBC prover lane this iter. Instead a
  `mathlib-analogist` cross-domain consult on the leg-locked adjoint-mate-unwinding pattern, then a
  `refactor` (restate the assembly to rewrite the unit while the leg is still a free local, before
  `subst`) next iter. (i.e. the planner is treating FBC as STUCK and taking the structural corrective,
  not re-dispatching the fine-grained/whole-goal lane.)

---

## Route GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

Target: `genericFlatness` via algebraic core `genericFlatnessAlgebraic`; live frontier is L4
`exists_localizationAway_finite_mvPolynomial`.

- Per-iter **file sorry counts**: iter-016 = 4, 017 = 3, 018 = 3, 019 = 3.
- Per-iter **helpers added**: 017 = +1 (L5 closed; signature simplified), 018 = +6 (L4 foundation
  F1–F6), 019 = +1 (`isLocalization_lift_injective`).
- Per-iter **prover status**: 016 PARTIAL, 017 PARTIAL (L5 CLOSED), 018 PARTIAL, 019 PARTIAL (L4
  injectivity crux CLOSED).
- **Recurring blocker phrases**: (a) OreLocalization instance diamond at L5 — appeared iters 015–016,
  CLOSED iter-016/017; (b) L4 injectivity crux — stuck 5 iters, **CLOSED iter-019** (ν/ψ comparison
  maps, compatibility square, `Function.Injective φ` all proven). No blocker has survived ≥2 iters
  past its corrective.
- Remaining: ONE isolated L4 `sorry` (the module-finiteness conjunct @754), with a concrete recipe
  (refine witness `g := g0·g1` clearing K[X]-coeffs, `Algebra.finite_adjoin_of_finite_of_isIntegral`).
  Plus `genericFlatnessAlgebraic` (dévissage) + `genericFlatness` (geometric), both gated downstream.
- STRATEGY `## Phases & estimations`: **GF-alg — Iters left = 2**; ACTIVE.
- **Planner's proposed iter-020 action for GF**: `prove` lane — close L4 finiteness conjunct, then
  start `genericFlatnessAlgebraic`.

---

## Route QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

Target (SNAP-S2 keystone): `gradedModule_hilbertSeries_rational` (graded Hilbert–Serre rationality).

- Per-iter **file sorry counts**: 016 = 4 (protected stubs), 017 = 4, 018 = 4, 019 = 5 (+1 = the new
  base-case leaf, accepted as the price of assembling the keystone end-to-end).
- Per-iter **helpers added**: 017 = +13, 018 = +20, 019 = +17 (foundation + induction body).
- Per-iter **prover status**: 017 PARTIAL (foundation), 018 PARTIAL (foundation), 019 PARTIAL
  (keystone assembled end-to-end; 3-iter finiteness blocker `subquotient_finite_transfer` CLOSED
  axiom-clean).
- **Recurring blocker phrases**: (a) graded quotient/subtype isDefEq pathology — avoided since the
  Route-2 pivot (no recurrence iters 017–019); (b) finiteness transfer down one variable — was the
  3-iter blocker, **CLOSED iter-019**; (c) now: ONE residual leaf `iSupIndep` in
  `subquotient_base_eventuallyZero` (@1494) — route (a) (κ-linear `liftQ` detector) is a confirmed
  dead end (scalar-ring clash), route (b) (dfinsupp destructuring) is queued.
- STRATEGY `## Phases & estimations`: **SNAP — Iters left = 2–4**.
- **Planner's proposed iter-020 action for QUOT**: `prove` lane — close the single `iSupIndep` leaf
  via route (b), completing the keystone. (Note: the foundation-additive pattern of 017/018 ended at
  019 with the keystone assembled + the 3-iter finiteness blocker closed — this iter adds NO
  foundation, only closes the leaf.)

---

## What I need from you

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with the corrective TYPE for any
CHURNING/STUCK. In particular: (1) is the planner's FBC decision (no prover; analogist + deferred
refactor) the right response to FBC's trajectory, or is there a cheaper corrective? (2) Are GF and
QUOT genuinely converging (one isolated leaf each) or is the single-leaf framing hiding a deeper
stall? Also run dispatch-sanity on the proposed objective set: **2 prover lanes this iter (GF, QUOT);
FBC deliberately not dispatched.**
