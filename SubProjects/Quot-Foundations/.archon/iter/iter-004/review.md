# Iter 004 — Review (Quot-Foundations)

## Verdict: real structural progress on both lanes; build GREEN; 0 must-fix across 3 reviewers

`attempts_raw.jsonl`: 21 edits across the two assigned files (no `no_prover_lane` flag). Both lanes
did faithful work — lean-auditor and both lean-vs-blueprint-checkers returned **0 must-fix**,
confirming every `sorry` is honest scaffolding, no weakened-wrong defs, no excuse-comments, no
unauthorized axioms. The re-signed L4 signature was independently confirmed honest and an improvement.

## Overall progress this iter

- **Total project sorry: 12 → 12** (FBC 3→4, GF 5→4, QuotScheme 4→4 untouched). The flat count masks
  the real advance: the entire GF L3 chain (the iter-003 frontier crux) closed, the FBC L4-a core
  proved, and the two genuine FBC cruxes isolated into named, independently-attackable sorries.
- **Branches genuinely closed: 7 obligations, all axiom-clean.**
  - GF: `exact_localizedModule_powers_of_shortExact` (L3a), `free_localizationAway_of_free_of_eq_mul`
    (L3b — the 553-effort leaf), `free_of_shortExact_of_free_free` (L3c), the assembly
    `exists_free_localizationAway_of_shortExact` (L3, primary objective), and the L5 torsion sub-case.
  - FBC: `base_change_regroup_linearEquiv` (L4-a core), `base_change_mate_generator_trace` (L4-c,
    transitively on two residues).
- **Solved / partial / not_started: 7 / 4 / 4.**
  - solved: L3a, L3b, L3c, L3-assembly, L5-torsion-subcase (GF); regroup_linearEquiv,
    generator_trace (FBC).
  - partial: `base_change_mate_regroupEquiv` (hms), `base_change_mate_generator_trace_eq` (FBC mate
    crux), `exists_localizationAway_finite_mvPolynomial` (L4 re-sign + Step1), `exists_free_localizationAway_polynomial` (L5).
  - not_started (deferred by design): `genericFlatnessAlgebraic`, `genericFlatness`,
    `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`.
- **Graph health:** `dag-query gaps` = 0 (no ∞ holes); blueprint-doctor CLEAN (no orphan chapters,
  all `\ref`/`\uses` resolve, no axioms). `frontier` = 4 ready, all QUOT-side (`sectionGradedRing`,
  `Modules.annihilator`, `IsLocallyFreeOfRank`, `gr_affine_chart`) — the not-yet-active QUOT lane.
  `unmatched` = 1 `lean_aux` (`base_change_regroup_linearEquiv` — coverage debt, surfaced to planner).

## This session's analysis — two findings shape iter-005's critical path

1. **FBC `base_change_mate_regroupEquiv` is one file-split from closure.** The prover proved the
   mathematical core (`base_change_regroup_linearEquiv`) axiom-clean, then hit a pure tactic/instance
   wall: after `TensorProduct.induction_on` strips the `restrictScalars` wrapper, the object `R'`-smul
   is defeq-but-opaque to every standard smul lemma. The verified clean closure is
   `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)` — which typechecks sorry-free
   ONLY when the helper is in a separately-compiled module (the imported type normalizes the instance
   diamond). iter-005 should dispatch the `refactor` subagent to split the helper into a new imported
   file; that closes the `hms` sorry outright. (Lean-auditor caveat: the "separate module" claim is
   unverifiable from source — confirm the typecheck on first attempt before committing.)

2. **GF L5 needs a skeleton restructure, not just a proof-fill.** The torsion sub-case is genuinely
   proved, but the non-torsion generic-rank dévissage residue cannot be filled in the current
   `rcases`-based skeleton (no IH in scope). The auditor flagged that the comment understates this:
   filling the sorry requires restructuring to strong induction on `d` with `N` universally
   quantified, THEN effort-breaking the generic-rank SES construction. The L3 chain it splices through
   is now fully proved, so the downstream is unblocked — only the induction restructure gates it.

Secondary: the GF L4 `% LEAN SIGNATURE` blueprint block is stale (claims the `Algebra A_g B_g` binder
was removed; the landed Lean retains it). I added a `% NOTE:` reconciling it; the planner should
rewrite the block. The fbc checker's proof-block `\leanok` gap (~19 proved lemmas) is a deterministic
`sync_leanok` concern outside my marker domain — surfaced for the planner, not papered over.

## Subagent dispatches

- **lean-auditor** `iter004`: 4 files, 0 must-fix / 3 major / 6 minor / 0 excuse-comments. Confirmed
  honest; positively confirmed the L3 lemmas, L4-a helper, and re-signed L4 signature.
  Report: `task_results/lean-auditor-iter004.md`.
- **lean-vs-blueprint-checker** `fbc`: 28 decls, faithful, 0 must-fix, 1 major (sync_leanok proof-block
  gap), 2 minor (helper coverage debt; affine-reduction granularity).
  Report: `task_results/lean-vs-blueprint-checker-fbc.md`.
- **lean-vs-blueprint-checker** `gf`: 12 decls, faithful, 0 must-fix, 1 major (stale L4
  `% LEAN SIGNATURE` block — addressed with `% NOTE` this review).
  Report: `task_results/lean-vs-blueprint-checker-gf.md`.

(Note: the dispatch wrapper derived iter=005 from the env fallback, so report copies archived under
`logs/iter-005/`; the canonical `task_results/` copies are correct and reference iteration 004 work.)

## Markers

Manual: added one `% NOTE:` to `Picard_FlatteningStratification.tex` on
`lem:gf_noether_clear_denominators` (stale `% LEAN SIGNATURE` block omits the `Algebra A_g B_g`
binder). No `\mathlibok` added (no new Mathlib re-export anchors — provers used Mathlib lemmas inside
proofs). No `\lean{...}` rename needed (all new-decl pins matched verbatim per both checkers). No
stale `\notready` present in active chapters. `\leanok` untouched (sync_leanok ran for iter-004:
+12 / −19; proof-block gap surfaced to planner as a sync concern).
