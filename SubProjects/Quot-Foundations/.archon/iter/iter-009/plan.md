# Iter 009 — Plan (Quot-Foundations)

## TL;DR

Strategy-correction + blueprint-decomposition iter, resumed after a context reset mid-plan. A prior
partial plan run had dispatched 4 subagents: strategy-critic (DONE — FBC **CHALLENGE**),
mathlib-analogist (DONE — FBC route-swap recipe), progress-critic (**FAILED**, no report), and an
effort-breaker for GF (interrupted, no completion report). On resume I found the interrupted
effort-breaker had in fact **landed its GF blueprint edits cleanly** (42/42 envs, the 4-sub-lemma
decomposition of `gf_torsion_reindex` present and well-formed), so I did NOT re-dispatch it. I then:
(1) re-dispatched the progress-critic (**FBC-A CHURNING, GF-alg UNCLEAR/not-STUCK, dispatch OK**);
(2) executed the FBC route swap via a blueprint-writer (drop the adjoint-mate tower → one
section-level identity `Γ(θ)=lTensor R' η_M`; rebuild `regroupEquiv` on the natively-`R'`-linear
`Algebra.IsPushout.cancelBaseChange`, killing `map_smul'`); (3) rewrote STRATEGY.md to resolve the
FBC contradiction, name SNAP's blocker, and de-drift the format; (4) blueprint-clean + the mandatory
whole-blueprint reviewer (**HARD GATE**); (5) dispatched a QuotScheme writer to author the must-fix
QCoh-bridge `% LEAN SIGNATURE` + the SNAP-S2 rationality signature. Prover dispatch this iter: ONE
gate-ready lane (**GrassmannianCells GREEN**). FBC-A + GF-alg are gate-ready for iter-010; QUOT-A +
SNAP-S2 gate-pending the iter-010 review of this iter's writer output.

## State at entry

- iter-008 prover: FBC `map_smul'` substantively proven (2 zero-branches sorry), the 3 mate
  sub-lemmas never created (untyped). GF: `gf_generic_rank_ses` + `gf_clear_one_denominator` proved
  axiom-clean; L5 restructured (generalize base `A`); `gf_torsion_reindex` created sorry. Build green.
  GrassmannianCells: dispatched, produced NOTHING (anomaly). QUOT-A: deferred (annihilator writer round).
- Partial iter-009 plan artifacts on disk: strategy-critic + mathlib-analogist reports (valid, used);
  progress-critic failed; effort-breaker GF edits landed despite no report.

## Critic dispositions

- **strategy-critic `iter009`: CHALLENGE on FBC** (must-fix). STRATEGY.md was internally
  contradictory: Routes prose said "drop the adjoint-mate decomposition / prove Γ(θ)=lTensor R' η_M",
  but Phases + Mathlib-gaps retained the whole mate tower (sunk cost). GF + QUOT verdicts SOUND;
  the GF shared-universe `(A N : Type u)` pin confirmed correct for the `Scheme.{u}` cone (Q2).
  Format DRIFTED. **Resolved this iter** — see ## Decision made + STRATEGY rewrite.
- **mathlib-analogist `iter009` (cross-domain):** option (a)-refined — swap the regroup core to
  `Algebra.IsPushout.cancelBaseChange` (natively `≃ₗ[R']`, no `map_smul'`, no zero branch); the lone
  `Module A (A⊗R')` diamond resolved at object level by an `id`-carrier `≃ₗ[R']` (`map_smul':=rfl`).
  `Algebra.IsPushout.cancelBaseChange` + `TensorProduct.isPushout'` verified present. Persistent file
  `analogies/fbc-base-change-square-transparent-module.md`.
- **progress-critic `iter009b` (re-run; the failed one produced no report):** **FBC-A CHURNING** —
  iter-008 tripwire fired (the 3 mate sub-lemmas never existed as typed decls ⇒ 0 closures; sorry
  net +1; OVER_BUDGET). Corrective = the route-swap blueprint expansion (executing this iter) — exact
  match. **GF-alg UNCLEAR→CONVERGING, definitively NOT STUCK** (iter-008 tripwire did NOT fire — 2
  sub-lemmas axiom-clean; the Nagata blocker NARROWED across iters; a pivot would discard real infra).
  GrassmannianCells + QUOT-A UNCLEAR (fresh). **Dispatch-sanity OK** (deferring FBC/GF ONE iter for
  executing correctives is NOT avoidance — both follow iter-008 prover dispatches). OVER_BUDGET on
  both → revise estimates (done: STRATEGY iters-left 2–3 each).
- **blueprint-reviewer `iter009` (HARD GATE):** GrassmannianCells **GREEN**; FBC-A + GF-alg **NOT
  READY this iter, gate-ready iter-010**; QUOT-A **BLOCKED** (QCoh bridge had no `% LEAN SIGNATURE` —
  must-fix). RelativeSpec correct:partial (known open question, no current lane). leandag +
  blueprint-doctor fully green (0 unknown_uses / 0 broken refs / 0 orphans / 0 axioms).

## Decision made

### FBC: dissolve the adjoint-mate tower; commit to direct-on-sections (resolving the strategy CHALLENGE)
- **Option chosen:** drop the 3 untyped mate sub-lemmas (`unit_value`/`fstar_reindex`/`gstar_transpose`)
  + `generator_trace_eq`; replace with ONE section-level identity
  `lem:base_change_mate_section_identity` (`Γ(θ)=lTensor R' η_M`, Stacks 02KH part 2 /
  `lemma-affine-base-change`); rebuild `regroupEquiv` (and its RegroupHelper core) on
  `Algebra.IsPushout.cancelBaseChange`.
- **Why:** both critics + the analogist converged. The mate tower has blocked FBC-A ~6 iters and is
  the sunk-cost the strategy prose already said to drop; the `map_smul'` opaque-instance wall is
  dissolved at the source by the natively-`R'`-linear Mathlib equiv (not worked around). The strategy
  was incoherent (Routes vs Phases) — this makes blueprint, strategy, and the verified Mathlib API
  agree. The two critics' recommendations are complementary, not conflicting: the analogist's
  `regroupEquiv` core-swap fixes the iso; the strategy-critic's section identity replaces the
  categorical trace unwinding — I adopted both (the blueprint-writer encoded both; reviewer cleared).
- **LOC/risk trade-off:** the route swap REMOVES 3 untyped Mathlib-absent sub-lemmas (high risk) and
  the `map_smul'` wall, leaving ONE typed, source-quoted, well-formed obligation + a mechanical
  cross-file iso rebuild. Net risk down sharply; FBC-A iters-left 3–4 → 2–3.
- **Cheapest signal to reverse:** if `Algebra.IsPushout.cancelBaseChange`'s instance baggage fails to
  synthesize against the `extendScalars` carriers in Lean (iter-010), fall back to the object-level
  `id`-carrier bridge the analogist specified (already in the blueprint prose).

### Defer FBC + GF prover ONE iter; dispatch GrassmannianCells; set up QUOT-A/SNAP for iter-010
- **Option chosen:** GrassmannianCells is the sole gate-ready prover lane this iter; FBC/GF get their
  correctives this iter and dispatch iter-010; a QuotScheme writer authors the QCoh-bridge +
  SNAP-S2 signatures so both become iter-010 lanes.
- **Why:** the blueprint-reviewer gate is binding — FBC/GF chapters were only just rewritten/decomposed
  this iter, so their provers cannot run until iter-010's gate holds; QUOT-A's bridge was unspecified.
  Forcing FBC/GF provers onto a same-iter fast path would rush a brand-new mathematical claim (the
  section identity) and the bridge spec through a compressed review — exactly the low-quality-prover
  failure the gate exists to prevent. One corrective iter that sets up a 4-lane iter-010 beats a rushed
  multi-lane iter-009. progress-critic confirmed this is not avoidance.
- **Cheapest signal to reverse:** if GrassmannianCells produces nothing AGAIN (second consecutive
  no-delivery), it trips CHURNING — iter-010 then gets a structural/Lean-idiom analysis before re-dispatch.

## Subagent skips

- strategy-critic: NOT skipped — ran (this iter's CHALLENGE drove the FBC decision). [recorded for completeness]
- effort-breaker (GF `gf_torsion_reindex`): SKIPPED re-dispatch — the interrupted iter-009 effort-breaker
  had already landed its blueprint decomposition cleanly (4 sub-lemmas + rewired proof, env-balanced,
  reviewer-confirmed sound). Re-dispatching would be redundant.
- lean-auditor / lean-vs-blueprint-checker: N/A this phase (review-phase subagents).

## Tool substitutions
None. (No external-source verification was blocked; all citations read from local reference files.)

## Notes for iter-010
- iter-010 is expected to be a 3–4-lane prover iter: FBC-A (cross-file: RegroupHelper + FlatBaseChange
  — consider a refactor subagent for the `base_change_regroup_linearEquiv` body swap), GF-alg
  (mathlib-build bottom-up chain), GrassmannianCells (continue cocycle→glue), QUOT-A (after the
  mandatory review clears this iter's QCoh-bridge signature). SNAP-S2 sequences within the QuotScheme
  lane or defers one iter (same file).
- FBC-B is the next unstarted phase to blueprint (reviewer Proposal 2) — author after FBC-A's section
  identity lands `\leanok`.
