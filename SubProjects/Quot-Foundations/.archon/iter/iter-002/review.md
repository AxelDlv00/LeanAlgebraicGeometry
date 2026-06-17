# Iter 002 — Review (Quot-Foundations)

## Verdict: first prover iter — honest partial progress on two lanes, build GREEN

`attempts_raw.jsonl` (no `no_prover_lane` flag): 9 edits across the two assigned files.
Both lanes did faithful work — real statements with `sorry` bodies plus one fully-proved
lemma; the lean-auditor returned **0 must-fix** and confirmed the two suspicious-looking
constructs (`IsIso (Γ(α))` form; `by_cases Module.Finite A M` split) are genuine content,
not dodges.

## Overall progress this iter

- Sorry-bearing decls: FBC-A 2 → 3, GF 1 → 2. Both *increases* are structural — each lane
  split a monolithic sorry into named sub-lemmas, and `base_change_map_affine_local` (FBC-A)
  is now fully closed (axiom-clean). Net: more sorries on paper, but the residual obligations
  are now explicit, named, and independently attackable, and one real lemma landed.
- Branches closed: 1 (`base_change_map_affine_local`).
- Solved / partial / blocked / untouched: 1 / 4 / 0 / 1.
  - solved: `base_change_map_affine_local`.
  - partial: `pushforward_base_change_mate_cancelBaseChange` (statement landed),
    `affineBaseChange_pushforward_iso` (rerouted), `genericFlatnessAlgebraic` (primary
    branch closed), `genericFlatness` (re-signed + wrapper setup).
  - untouched (deliberate): `flatBaseChange_pushforward_isIso` (FBC-B, later lane).
- Graph health: `dag-query gaps` = 0 (no ∞ holes), `frontier` = 0 ready, blueprint-doctor
  clean. The three iter-001 `TODO.*` placeholders are now real pinned decls
  (`genericFlatnessAlgebraic`, `base_change_map_affine_local`,
  `pushforward_base_change_mate_cancelBaseChange`) — the scaffold gap from iter-001 is closed.

## This session's analysis

Two findings shape iter-003's critical path:

1. **GF lane is blocked on blueprint adequacy, not prover effort.** The
   lean-vs-blueprint-checker (gf) found both GF proof blocks under-specified — neither names
   the Lean APIs to close the sorries. Re-dispatching a prover as-is would churn. iter-003
   should run a blueprint-writer + effort-breaker on the dévissage residue
   (`genericFlatnessAlgebraic`) and the geometric globalization (`genericFlatness`) BEFORE
   any GF prover round. The polynomial-ring core of generic freeness is genuinely
   Mathlib-absent (verified).

2. **FBC-A's mate lemma is the live frontier crux.** `pushforward_base_change_mate_cancelBaseChange`
   feeds the entire affine close; its proof (4-step mate trace) is blocked on the
   `pullbackSpecIso` identification of `f'/g'` over the generic square. Recommend
   effort-breaker decomposition before re-dispatch — do not re-assign the monolithic sorry.

Secondary: the `IsIso (Γ(α))` vs literal-equality divergence in the mate lemma is
deliberate and faithful (confirmed by both the lean-auditor and the fbc checker); I added a
`% NOTE:` to the chapter reconciling the pin. The plan-phase blueprint-writer's 3-step proof
for `base_change_map_affine_local` now over-describes the Lean (which closed it as a
one-liner) — harmless, optionally trimmed. Phantom `[IsAffineHom]`/`[IsQuasicoherent]`
binders on that lemma are a deliberate carry; planner to confirm or drop.

## Subagent dispatches

- **lean-auditor** (iter002): 2 files audited, 0 must-fix / 3 major / 3 minor. Confirmed
  honest. Report: `task_results/lean-auditor-iter002.md`.
- **lean-vs-blueprint-checker** (fbc): 19 decls, 3 sorries (known) + 2 informational major.
  Report: `task_results/lean-vs-blueprint-checker-fbc.md`.
- **lean-vs-blueprint-checker** (gf): Lean faithful (0 red flags Lean-side); 2 major
  blueprint-adequacy findings → drives the GF blueprint-expansion recommendation.
  Report: `task_results/lean-vs-blueprint-checker-gf.md`.

## Markers

Manual: added one `% NOTE:` to `Cohomology_FlatBaseChange.tex` on
`lem:pushforward_base_change_mate_cancelBaseChange` (IsIso-corollary vs equality). No
`\mathlibok` added, no `\lean{...}` rename needed (both new decls match pins verbatim), no
stale `\notready`. `sync_leanok` (iter 2, sha 693855e) added 4 statement-`\leanok`, removed
0 — deterministic, not laundering (decls compile; sorry-bodied proofs stay unmarked).

## Coverage debt

`dag-query unmatched` = 4 `lean_aux` nodes (all pre-existing, listed in recommendations.md
for the planner to blueprint): the three `GenericFreeness.*` helpers and
`gammaPushforwardNatIso`.
