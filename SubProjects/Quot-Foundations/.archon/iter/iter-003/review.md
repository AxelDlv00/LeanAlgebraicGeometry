# Iter 003 — Review (Quot-Foundations)

## Verdict: honest structural progress on both lanes; build GREEN; 0 must-fix across 3 reviewers

`attempts_raw.jsonl`: 15 edits across the two assigned files (no `no_prover_lane` flag).
Both lanes did faithful work — the lean-auditor and both lean-vs-blueprint-checkers
returned **0 must-fix**, confirming every `sorry` is honest scaffolding, no
weakened-wrong defs, no excuse-comments, no unauthorized axioms.

## Overall progress this iter

- **Sorry-bearing decls (the two prover files):** FBC 3 → **3** (count flat, structure
  vastly improved); GF 2 → **5** (structural scaffold increase — the full Nitsure §4 chain
  is now declared as `\lean{}`-resolving stubs).
- **Branches closed: 4 proved leaves + 2 helper defs + 1 parent assembly.**
  - FBC: `pullback_fst_snd_specMap_tensor` (L1), `base_change_mate_domain_read` (L2),
    `base_change_mate_codomain_read` (L3) — all SOLVED axiom-clean; plus the new helper defs
    `pullbackIsoEquivalenceOfIso` + `pullback_isEquivalence_of_iso`; the parent
    `pushforward_base_change_mate_cancelBaseChange` is now a proved assembly modulo one leaf.
  - GF: `exists_free_localizationAway_of_torsion` (L1) SOLVED axiom-clean; L5 base case (d=0)
    proved.
- **Solved / partial / blocked / not_started: 4 / 6 / 0 / 1.**
  - solved: L1-FBC, L2, L3 (FBC reads); L1-GF (torsion).
  - partial: `base_change_mate_generator_trace` (L4 crux), `pushforward_base_change_mate_cancelBaseChange`
    (direct proof now sorry-free; transitively on L4), `exists_free_localizationAway_of_shortExact`
    (L3-GF), `exists_localizationAway_finite_mvPolynomial` (L4-GF), `exists_free_localizationAway_polynomial`
    (L5, base done), `genericFlatnessAlgebraic` (assembly route documented).
  - not_started: `genericFlatness` (geo wrapper, deferred by design).
- **Graph health:** `dag-query gaps` = 0 (no ∞ holes); blueprint-doctor clean (no orphan
  chapters, all `\ref`/`\uses` resolve, no axioms). `frontier` = 2 ready, both in the QUOT
  leg (`sectionGradedRing`, `gr_affine_chart`) — a not-yet-active lane. `unmatched` = 2
  `lean_aux` nodes (the new FBC helpers; coverage debt, surfaced to planner).

## This session's analysis — two findings shape iter-004's critical path

1. **FBC-A is one concrete leaf from the mate close.** The prover effort-broke the
   previously-monolithic `pushforward_base_change_mate_cancelBaseChange` (the iter-002 blocker)
   into the `\uses`-chain, proved L1/L2/L3 axiom-clean, and assembled the parent so its direct
   proof is sorry-free. Only `base_change_mate_generator_trace` (L4) remains, and it is now a
   CONCRETE tensor map (`R'⊗_R M ⟶ (A⊗_R R')⊗_A M`) reducible to `cancelBaseChange⁻¹` via a
   bundled R'-linear regroup equiv — no longer an abstract sheaf-map Γ. iter-004 should
   fine-grain effort-break L4 and dispatch; do NOT re-assign the parent.

2. **GF blueprint-adequacy is the gating issue, not prover effort.** Both GF major findings
   are blueprint-side: L4 `lem:gf_noether_clear_denominators` has an undocumented
   instance-existential encoding (the auditor independently flagged the interface as fragile),
   and `lem:gf_free_moduleFinite` prose understates its actual hypotheses. I added `% NOTE`
   flags to both; iter-004 should dispatch a blueprint-writer to (for L4) decide between
   documenting the encoding or re-stating with an explicit AlgHom target, and (for
   `gf_free_moduleFinite`) restate the B-intermediate hypotheses — BEFORE re-dispatching the
   GF chain. The next attackable GF leaf is L3 (`exists_free_localizationAway_of_shortExact`),
   whose blocker is the module-side localization plumbing — effort-break it before re-dispatch.

Secondary: the FBC tensor-order divergence (`A ⊗[R] R'` in Lean vs `R' ⊗_R A` in prose) is a
faithful re-orientation (both checkers + I confirmed) — annotated with a `% NOTE`, no content
issue.

## Subagent dispatches

- **lean-auditor** (iter003): 5 files, 0 must-fix / 2 major / 4 minor / 0 excuse-comments.
  Report: `task_results/lean-auditor-iter003.md`.
- **lean-vs-blueprint-checker** (fbc): 25 decls, 0 must-fix / 1 major + 2 minor (all
  blueprint-doc gaps, addressed via markers). Report: `task_results/lean-vs-blueprint-checker-fbc.md`.
- **lean-vs-blueprint-checker** (gf): 9 decls (9/9 coverage), 0 must-fix / 2 major + 1 minor
  (blueprint-adequacy). Report: `task_results/lean-vs-blueprint-checker-gf.md`.

## Markers (manual, this review)

- `Cohomology_FlatBaseChange.tex`, `lem:base_change_mate_generator_trace`: added two
  `% NOTE (iter-003)` — IsIso-corollary vs literal formula, and the `A⊗[R]R'` vs `R'⊗_R A`
  tensor-order convention.
- `Cohomology_FlatBaseChange.tex`, `lem:pushforward_base_change_mate_cancelBaseChange`:
  refreshed the stale iter-002 `% NOTE` (direct proof no longer sorry-bodied; residue is
  transitive via the generator-trace leaf).
- `Picard_FlatteningStratification.tex`, `lem:gf_noether_clear_denominators`: added
  `% NOTE (iter-003 review)` flagging the undocumented instance-existential encoding.
- `Picard_FlatteningStratification.tex`, `lem:gf_free_moduleFinite`: added
  `% NOTE (iter-003 review)` flagging the understated hypotheses.
- No `\mathlibok` added (all anchors already correct). No `\lean{}` renames (all pins
  resolve). No stale `\notready`. `\leanok` untouched — `sync_leanok` ran for iter-003
  (added 21, removed 0; `iter=3` in `sync_leanok-state.json`).
