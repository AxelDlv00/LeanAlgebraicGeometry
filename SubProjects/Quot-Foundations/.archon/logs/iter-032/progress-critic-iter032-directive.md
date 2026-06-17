# Progress-critic directive — iter-032

Assess convergence per active route. Three routes are under consideration for this iter's prover
dispatch. For each: last 4–5 iters' signals (sorry counts, helpers added, prover status, recurring
blocker phrases), the strategy's current `Iters left` estimate, and the iter the route entered its
current phase.

## Route 1 — FBC (`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`), target `base_change_mate_fstar_reindex_legs` sorry

Signals:
- sorry count: iter-028 = 4, iter-029 = 4, iter-030 = 4, iter-031 = 4 (unchanged 4 rounds).
- helpers added: iter-029 = 0 (riders/cleanup only), iter-030 = +1 (`link_distributeCollapse`), iter-031 = +0 (a `simp only` advance inside `_legs`, no new decl).
- prover status: PARTIAL each of the last 4 rounds.
- recurring blocker phrases: "`X.Modules` instance diamond", "keyed rewriting (rw/simp/erw/conv) conclusively dead", "term-mode splice".
- **NEW root-cause finding iter-031** (not previously known): the prescribed proof route — "splice the SHIPPED eCancel atoms" — was **never executable**, because all three eCancel atoms (`base_change_mate_inner_eCancel_eUnit/_pushforwardComp/_pullbackComp`) are declared in the file AFTER `_legs`, hence out of scope at the `_legs` sorry (confirmed: `Unknown identifier` at the sorry). The prior rounds could not even reference the lemmas they were told to use. The iter-032 corrective is structurally different: build the 3 wrapper links INLINING in-scope cancellers (`pullback_isEquivalence_of_iso`, `(pullbackComp _).hom_inv_id_app`, `gammaMap_pushforwardComp_hom_eq_id` — all declared before `_legs`) + collapse the `Eq.mpr` casts via the concrete-legs read.
- strategy `Iters left`: 1–2; entered phase iter-018 (elapsed ~14, OVER_BUDGET).

Question for you: given the ordering-bug discovery (the route was never run), is one more corrective round (route now actually executable) justified, or is this churn? Note the prior progress-critic set a "FIRM iter-032 escalation tripwire."

## Route 2 — QUOT (`AlgebraicJacobian/Picard/QuotScheme.lean`), gap1 infra (bridge C → P1)

Signals:
- sorry count: 4 throughout (the 4 are pre-existing PROTECTED stubs, not the lane's metric; the lane builds axiom-clean gap1 infra).
- helpers added (axiom-clean): iter-028 = +1, iter-029 = +1, iter-030 = +6, iter-031 = +4.
- prover status: iter-031 = COMPLETE on its lane objective (gap1 bridge C fully closed: `overRestrictIso` + `overRestrictPullbackIso` axiom-clean; the named step-2 obstacle collapsed to `rfl`).
- recurring blocker phrases: none recent; iter-030 had "synthInstance timeout" but iter-031 dissolved it ("rfl", "bridge C closed").
- strategy `Iters left`: 3–6; entered phase ~iter-024.
- This iter's objective: P1 (per-affine local-tilde) — now UNBLOCKED by `overRestrictPullbackIso`.

## Route 3 — GR (`AlgebraicJacobian/Picard/GrassmannianCells.lean`), GR-glue → GR-separated

Signals:
- sorry count: 0 → 0 (file is a scaffold target; new decls fully proved).
- helpers added: iter-029 = 0 (NO OUTPUT), iter-030 = 0 (NO OUTPUT), iter-031 = +8 (LANE CLOSED — `Grassmannian.scheme` axiom-clean).
- prover status: iter-029/030 NO OUTPUT (root-caused: dispatch-wording bug — a 0-sorry file is dropped by the no-op filter unless the objective carries a scaffold keyword; fixed iter-031), iter-031 = COMPLETE.
- strategy: GR-glue COMPLETE iter-031; new lane GR-separated (iters left 2–4) entered iter-032 (fresh).
- This iter's objective: scaffold + prove `isSeparated` (frontier node; blueprint complete + source-quoted).

## PROGRESS.md `## Current Objectives` proposal for iter-032 (3 files)

1. `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — FBC corrective (inline cancellers + collapse Eq.mpr casts + assemble `_legs`).
2. `AlgebraicJacobian/Picard/QuotScheme.lean` — QUOT P1 (per-affine local-tilde).
3. `AlgebraicJacobian/Picard/GrassmannianCells.lean` — GR scaffold + prove `isSeparated`.

Give per-route verdicts (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any CHURNING/STUCK, the corrective TYPE. Run dispatch-sanity on the 3-file proposal.
