# Progress-critic directive — iter-024

Assess convergence per active route from the extracted signals below. K = 4 iters
(020–023). Verdict per route (CONVERGING / CHURNING / STUCK / UNCLEAR) + named
corrective for any CHURNING/STUCK.

## Route FBC — `Cohomology/FlatBaseChange.lean`, crux `base_change_mate_gstar_transpose`

STRATEGY phase: FBC-A, `Iters left` estimate = 2–3 (post-swap baseline). Entered current
sub-phase (post route-swap to domain-read / gstar-transpose crux) at iter-020. Elapsed in
phase = 4 iters (020–023).

Signals (live-sorry count = the gstar crux + its decomposition; the file also carries 1 dead
`fstar_reindex_legs` sorry and 2 out-of-scope sorries `affineBaseChange`/`flatBaseChange`):
- iter-020: route swap landed; `gstar_transpose` 1st attempt — PARTIAL. live sorry 1.
- iter-021: PARTIAL (2-rw reframing isolated the two Γ-factors; counit-conjugate route pinned). live sorry 1. helpers added: 0.
- iter-022: PARTIAL (conjugate-counit "huce" scaffold step-1 landed + compiles). live sorry 1. helpers added: 0.
- iter-023: effort-breaker split the crux into a 5-lemma `\uses` chain. Seam C
  (`gstar_counit_transport`) CLOSED axiom-clean; Seam B (`gstar_generator_close`) PARTIAL
  (categorical step closed, element-identity residual); Seam A (`inner_value_eq`) PARTIAL
  (Γ-collapse closed, `inner_eCancel` ~150-LOC telescoping residual). `gstar_transpose`
  itself still sorry. helpers added: +3 chain lemmas (1 closed, 2 sorry).
- Recurring blocker phrase: "step 2–3 ~150-LOC telescoping" (iters 022, 023) → now localized
  to `inner_eCancel` (Seam A) + a Seam-B element identity.
- Status sequence: PARTIAL ×4, but iter-023 closed Seam C axiom-clean (first sorry-elimination
  in the decomposition).

Prior progress-critic verdict (iter-023): FBC STUCK, but "no pivot — route correct and
structurally advancing"; named corrective = blueprint expansion / effort-breaker decomposition
(executed iter-023).

Proposed iter-024 FBC objective: fine-grained — close Seam B (`gstar_generator_close`) via two
element lemmas (`inner_value_apply`, `regroupEquiv_inv_one_tmul`); re-break Seam A's
`inner_eCancel` telescoping into one-cancellation-per-lemma with concrete signatures. (A blueprint
effort-breaker re-break + element-lemma blocks precede the prover this iter.)

## Route GF-geo — `Picard/FlatteningStratification.lean`, crux `genericFlatness`

STRATEGY phase: GF-geo, `Iters left` estimate = 1–2. Entered phase at iter-023 (first GF-geo
attempt; GF-alg core completed axiom-clean iter-022). Elapsed in phase = 1 iter.

Signals:
- iter-023: GF-geo 1st attempt — found+fixed a CORRECTNESS BUG (`genericFlatness` was false
  without `[QuasiCompact p]`; added it, airtight counterexample). Discharged the standing
  algebraic-form instances (Nonempty/IsDomain/IsNoetherianRing for A=Γ(S,U₀)) soundly, no sorry.
  Terminated honestly at the single sorry @2264, blocked on two genuine missing-Mathlib bridges:
  G1 (qcoh + finite-type ⇒ finite section module over affine) and G3 (flat-locality assembly).
  live sorry 1 → 1. helpers added: 0 (signature hyp + in-body scaffold only).
- Status: PARTIAL (correctness fix + sound instances; core sorry remains, blueprint-blocked).

Proposed iter-024 GF objective: blueprint G1+G3 as lemma stubs (this plan phase), then a
`mathlib-build` prover on G1 (the witness-blocking gap) — NOT a re-attempt of the same wall.

## What I need from you
- Per-route verdict + (for CHURNING/STUCK) the named corrective TYPE.
- Dispatch sanity on the proposed 2-lane objective set (FBC fine-grained + GF mathlib-build,
  both preceded by blueprint fixes this iter).
- Flag any route where the proposed action is a reworded re-dispatch of a failed wall vs.
  genuinely new work.
