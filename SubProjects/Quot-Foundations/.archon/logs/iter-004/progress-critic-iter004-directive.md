# Progress-critic directive — iter-004 convergence audit

Two active prover routes. For each, the last-3-iters signals and the strategy's
current estimate. Assess CONVERGING / CHURNING / STUCK / UNCLEAR per route, and
sanity-check the iter-004 dispatch proposal.

---

## Route FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

Phase entered: iter-002 (first prover iter). Strategy estimate: **3–5 iters left**.

Signals (sorry count = honest sorry-bearing decls in the file):
- iter-001: no prover phase (strategy/blueprint repair iter).
- iter-002: sorry 2→3. Landed the top-level mate-lemma statement; PROVED
  `base_change_map_affine_local`. Status PARTIAL. Blocker phrase: "mate crux
  blocked on pullbackSpecIso identification".
- iter-003: sorry 3→3 (count flat). Effort-broke the monolithic mate sorry into a
  4-lemma chain; PROVED L1 (`pullback_fst_snd_specMap_tensor`), L2
  (`base_change_mate_domain_read`), L3 (`base_change_mate_codomain_read`) all
  axiom-clean + 2 helper defs; the parent
  `pushforward_base_change_mate_cancelBaseChange` is now a PROVED assembly modulo
  one leaf. Status: 3 leaves SOLVED, 1 residue (L4 `base_change_mate_generator_trace`).
  Blocker phrase: "L4 generator trace — concrete tensor map".

iter-004 plan for this route: this iter the L4 leaf was effort-broken (fine) into
3 sub-lemmas — `base_change_mate_regroupEquiv` (buildable pure tensor algebra),
`base_change_mate_generator_trace_eq` (the adjoint-mate trace), and the IsIso
corollary. Prover dispatched to scaffold + prove these leaves-first.

---

## Route GF-alg — `AlgebraicJacobian/Picard/FlatteningStratification.lean` (`GenericFreeness`)

Phase entered: iter-002. Strategy estimate: **3–5 iters left**.

Signals:
- iter-001: no prover phase.
- iter-002: sorry 1→2. Closed the primary branch of `genericFlatnessAlgebraic`
  (M module-finite/A case) via the generic-point freeness leaf; re-signed
  `genericFlatness`. Status PARTIAL.
- iter-003: sorry 2→5. Scaffolded the full 5-lemma Nitsure §4 dévissage chain
  (all `\lean{}` pins now resolve); PROVED L1
  (`exists_free_localizationAway_of_torsion`) axiom-clean + the L5 base case
  (d=0). Status: L1 SOLVED; L3/L4/L5-step/assembly residues. Blocker phrases:
  "module-side localization plumbing" (L3), "instance-existential encoding" (L4),
  "generic-rank dévissage" (L5).

iter-004 plan for this route: L4 re-encoded to an explicit-AlgHom target (clears
the fragile instance-existential interface flagged by the auditor + checker); L3
effort-broken into 3 sub-lemmas (localised-SES exactness / free-transport /
split). Prover dispatched to prove the L3 sub-lemmas + re-sign and attack L4.

---

## iter-004 dispatch proposal (sanity-check this)

2 files, 2 lanes:
1. `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — FBC-A: prove
   `base_change_mate_regroupEquiv`, `base_change_mate_generator_trace_eq`, then the
   IsIso leaf; this closes the whole mate-lemma assembly.
2. `AlgebraicJacobian/Picard/FlatteningStratification.lean` — GF-alg: prove the L3
   sub-lemmas (localized_exact / free_transport / split) + assemble L3; re-sign and
   attack L4 (AlgHom form).

## Questions

- Is either route CHURNING (each iter adds helpers/structure but the deep residue
  never shrinks)? Note that both routes show rising-or-flat sorry counts because
  each iter decomposes a monolith into a `\uses`-chain — assess whether this is
  genuine structural progress (leaves being closed axiom-clean) or disguised churn.
- Is the iter-004 proposal a real advance, or a re-dispatch of the same wall with
  reworded recipes?
- For GF-alg specifically: is one serial lane on the `GenericFreeness` chain the
  right structure, or has a serial bottleneck been demonstrated that would justify
  splitting the chain into separate files for parallel deep lanes?
