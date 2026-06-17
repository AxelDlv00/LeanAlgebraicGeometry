# Iter-064 plan — FOURTH flat iter (sorry 9→9); both routes CHURNING; executed the progress-critic's prescribed corrective: blueprint decomposition into atomic sub-lemmas + PROVER MODE-SWITCH mathlib-build→fine-grained (the NEW structural element iter-063 lacked); corrected the provably-wrong φ''; cleared HARD GATE; dispatched 2 fine-grained lanes

## Entering state (verified from iter-063 prover results + iter-063 review subagents)
- iter-063 ran 2 mathlib-build lanes, both PARTIAL, **+9 axiom-clean decls, sorry 9→9 — the FOURTH
  consecutive flat prover iter** (061/062/063 all 9→9; iter-060 was 11→9). None papered (lean-auditor
  iter-063: 0 must-fix; all genuine — incl. the `pushPull_binary_leg_coherence` `rfl`, confirmed
  post-`Functor.map_comp` syntactic, NOT a thin-cat collapse).
  - **CSI:** fixed a RED build (arrived broken) + `pushPull_binary_leg_coherence` (★), `pushPull_binary_coprod_prod`
    (the substantive canonical L2 node), `sigmaOptionIso`. Residual = `pushPull_coprod_prod` induction, decomposed
    by the prover into 6 small mechanical pieces (~120 LOC); declined the monolith near budget. sorry 4→4.
  - **OpenImm:** `sliceOversEquiv` + BOTH continuity instances — the 3-iter `[F.IsContinuous]` metavar wall behind
    `pushforwardPushforwardAdj` CLEARED. KEY HANDOFF: φ'' is object-level correction-FREE; the iter-063 blueprint's
    `sliceStructureSheafHom φ.symm` is a TYPE-MISMATCH; H₁/H₂ reduce to `eqToHom = eqToHom`. sorry 2→2.
- lean-auditor iter-063: 0 must-fix / 2 major (stale CSI planning comment ~695–729; duplicate
  `isZero_of_faithful_preservesZeroMorphisms` OpenImm↔CechAugmentedResolution — latent, no file imports both).

## What I did this phase
1. **progress-critic `iter064`** (dispatched first): **BOTH routes CHURNING + OVER_BUDGET** (A: 8 helpers/0
   closures/4 PARTIAL, ~8 iters elapsed; B: 14 helpers/0 closures/4 PARTIAL, ~10 iters elapsed). Critical
   finding: **the root cause is a budget-stop in mathlib-build mode, NOT a math wall** — both iter-063 provers
   built setup and explicitly declined the terminal mechanical assembly "near budget"; the chains have genuinely
   converged (chain-deepening, not lateral wall discovery). Prescribed corrective for BOTH = **blueprint
   decomposition into individually-named atomic sub-lemmas + prover MODE-SWITCH mathlib-build→fine-grained**, and
   it explicitly assessed this as a GENUINE structural action: the mode-switch is the NEW element iter-063 lacked
   (iter-063 ran a writer pass but kept the prover in mathlib-build). Another mathlib-build pass = predicted 5th PARTIAL.
2. **blueprint-writer `decompose-iter064`** (consolidated chapter, both decompositions + the φ'' correction):
   - Route A: decomposed `lem:pushPull_coprod_prod` into 6 fine-grained `\uses`-linked sub-lemmas
     (`sigmaOptionIso`, `pushPullObjCongr`, `over_sigmaOptionIso`, `piOptionIso`, `pushPull_coprod_prod_empty`,
     + the `induction_empty_option` parent), coverage `pushPullCoprodLegIso`.
   - Route B: **CORRECTED φ''** (the iter-063 `sliceStructureSheafHom φ⁻¹ Vᵢ` was a verified type-mismatch; new
     φ'' = object-level-correction-free over-pullback of `φ.hom.toRingCatSheafHom`) + decomposed
     `lem:pushforward_slice_two_adjunction` into `slice_reverse_ring_map`/H₁/H₂; coverage anchor
     `slice_overs_equiv_continuity` (the 6 iter-063 helpers) + 8 `\mathlibok` anchors; propagated into
     `lem:pushforward_slice_pullback_iso`.
3. **blueprint-clean `iter064`**: stripped 9 Lean-identifier leakages from prose (both regions); no math/marker change.
4. **blueprint-reviewer `iter064`** (mandatory, whole blueprint): **HARD GATE CLEARS** — `correct: true`, no
   must-fix; `complete: false` only from unbuilt build-targets (expected). φ'' correction coherent + consistently
   propagated; all new sub-lemma statements well-formed; no broken `\uses`; coverage debt cleared (live helpers).
5. Updated STRATEGY (both rows: CHURNING root-cause = budget-stop, corrective = decompose + mode-switch; estimates
   ~2–4 left), PROGRESS objectives (2 fine-grained lanes), task_done (iter-063 entry), task_pending (iter-064
   status), this sidecar, objectives.md.

## Decision made — D1: execute the critic's exact corrective (decompose + MODE-SWITCH to fine-grained), then dispatch — NOT defer, NOT bare re-dispatch
- **This is the genuinely different structural action the iter-063 plan explicitly demanded for a 4th flat iter.**
  The iter-063 next-iter note said: "If a lane comes back FLAT again (4th consecutive), do NOT bare-re-dispatch —
  escalate." The escalation is the prover mode-switch. iters 061–063 all ran the same loop (writer pass +
  mathlib-build prover); the prover repeatedly built foundations and declined the terminal assembly near budget.
  Fine-grained mode dispatches ONE atomic sub-lemma per step, which directly defeats the budget-stop — and the
  critic confirmed this is "materially different, not a dressed-up re-dispatch."
- **Why fine-grained over the other escalation options** (mathlib-analogist cross-domain / single-lane focus /
  refactor): the critic's diagnosis is decisive — both residuals are *already fully decomposed with precise
  recipes* (CSI: 6 mechanical pieces with LOC; OpenImm: φ'' object-level-free + H₁/H₂ as eqToHom squares). There
  is no missing idiom (so analogist is premature) and no design-shape flaw (so refactor is wrong). The only thing
  missing is the prover actually attempting the small pieces within budget — exactly fine-grained's purpose. I
  hold mathlib-analogist cross-domain in reserve as the NEXT escalation if H₁/H₂ specifically stalls (recorded in
  PROGRESS next-iter §2).
- **Why I also corrected φ'' this iter** (not just decomposed): the iter-063 prover proved by type analysis that
  the blueprint's φ'' definition does not type-check. Dispatching a prover against a provably-wrong definition
  would burn the iter — this is the "soundness check before budget" discipline. The correction is the prover's
  own verified analysis transcribed, not new math.
- **Cheapest reversal signal:** a 5th flat iter on EITHER lane despite fine-grained + atomic blueprint ⟹ the
  obstacle is implementation depth at one specific sub-lemma; re-break THAT sub-lemma sentence-by-sentence, or
  (OpenImm H₁/H₂ only) run mathlib-analogist cross-domain on the `Over.map(unitIso.inv)` coherence. Do not
  re-dispatch the lane whole.

## Subagent skips
- strategy-critic: the STRATEGY routes are unchanged (same Route A acyclic-resolution comparison; same
  P5a-consumer open-immersion acyclicity via Need#1/#2), and the CHURNING is diagnosed (by the progress-critic,
  fresh-context) as an EXECUTION-MODE problem, not a strategy-soundness problem — both chains have demonstrably
  converged to precise leaves. The only STRATEGY edits this iter are estimate/status refreshes + recording the
  mode-switch corrective, not a route change. Prior strategy-critic verdict was SOUND with no live challenge.
- dag-walker / effort-breaker / strategy-auditor / mathlib-analogist: not needed — the decompositions were
  fully specified by the iter-063 prover handoffs (no mathematical seam-finding required); a single blueprint-writer
  transcribed them. mathlib-analogist held in reserve for a possible 5th-flat H₁/H₂ stall.

## Coverage debt
- 8 live helpers (6 OpenImm slice-equiv/continuity + `sigmaOptionIso` + `pushPullCoprodLegIso`) blueprinted this
  iter (bundled into `slice_overs_equiv_continuity` / their own blocks). leandag `unknown_uses: []`.
- Remaining: dead `CechAcyclic.affine` (1 unmatched node) — superseded, pending refactor-deletion; carries one
  more iter (it shares the consolidated chapter, so its deletion serializes behind blueprint edits; non-blocking).
  Scheduled with the `isZero_of_faithful_preservesZeroMorphisms` extraction in a future cleanup refactor.

## Build state
- GREEN entering (iter-063 review confirmed full `lake build` OK; this iter touched only `.tex`). No Lean edits.
